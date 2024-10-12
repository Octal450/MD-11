# McDonnell Douglas MD-11 FMS
# Copyright (c) 2024 Josh Davidson (Octal450)

# Properties and Data
var Internal = {
	bankAngle1: props.globals.initNode("/systems/fms/internal/bank-limit-1"),
	bankAngle2: props.globals.initNode("/systems/fms/internal/bank-limit-2"),
	bankAngleVss: props.globals.initNode("/systems/fms/internal/bank-limit-vss"),
	cgPercentMac: props.globals.initNode("/systems/fms/internal/cg-percent-mac"),
	engOn: 0,
	Messages: {
		vspeeds: 0,
	},
	phase: 0, # 0: Preflight, 1: Takeoff, 2: Climb, 3: Cruise, 4: Descent, 5: Approach, 6: Rollout
	phaseNew: 0,
	phaseOut: props.globals.getNode("/systems/fms/internal/phase"),
	request: [1, 1, 0],
	resetToggle: 0,
	takeoffStabDeg: props.globals.initNode("/systems/fms/internal/takeoff-stab-deg"),
};

var Value = { # Local store of commonly accessed values
	active: 0,
	afsAlt: 0,
	altitude: 0,
	asiKts: 0,
	asiMach: 0,
	distanceRemainingNm: 0,
	flapLever: 0,
	gearLever: 0,
	vertText: 0,
	wow: 0,
};

# Logic
var CORE = {
	init: func(t = 0) {
		EditFlightData.reset();
		Internal.phaseNew = 0;
		Internal.phase = 0;
		Internal.phaseOut.setValue(0);
		Internal.request[0] = 1;
		Internal.request[1] = 1;
		Internal.request[2] = 0;
		FmsSpd.init();
		if (t == 1) {
			mcdu.BASE.reset(); # Last
		} else {
			me.resetRadio();
		}
	},
	loop: func() {
		Value.active = RouteManager.active.getBoolValue();
		Value.afsAlt = afs.Internal.alt.getValue();
		Value.altitude = pts.Instrumentation.Altimeter.indicatedAltitudeFt.getValue();
		Value.distanceRemainingNm = RouteManager.distanceRemainingNm.getValue();
		Value.flapLever = systems.FCS.flapsInput.getValue();
		Value.gearAglFt = pts.Position.gearAglFt.getValue();
		Value.gearLever = systems.GEAR.cmd.getBoolValue();
		Value.vertText = afs.Text.vert.getValue();
		Value.wow = pts.Fdm.JSBSim.Position.wow.getBoolValue();
		
		if (systems.ENGINES.state[0].getValue() == 3 or systems.ENGINES.state[1].getValue() == 3 or systems.ENGINES.state[2].getValue() == 3) {
			Internal.engOn = 1;
		} else {
			Internal.engOn = 0;
		}
		
		EditFlightData.loop();
		
		# Flight Phases
		if (Internal.phase == 0) { # Preflight
			if ((Value.vertText == "T/O CLB" and systems.FADEC.throttleCompareMax.getValue() >= 0.7) or !Value.wow) {
				Internal.phaseNew = 1; # Takeoff
			}
		} else if (Internal.phase == 1) { # Takeoff
			if (!Value.wow and Value.vertText == "ALT HLD") {
				Internal.phaseNew = 2; # Climb
			} else if (Value.wow and Value.vertText == "T/O CLB" and systems.FADEC.throttleCompareMax.getValue() < 0.7) { # Rejected T/O
				Internal.phaseNew = 0;
			} else if (FlightData.accelAlt > -1000) {
				if (Value.vertText != "T/O CLB" and Value.altitude >= FlightData.accelAlt) {
					Internal.phaseNew = 2; # Climb
				}
			}
		} else if (Internal.phase == 2) { # Climb
			if (FlightData.cruiseAltAll[0] > 0) {
				if (Value.vertText == "ALT HLD" and Value.afsAlt >= FlightData.cruiseAltAll[0]) {
					Internal.phaseNew = 3; # Cruise
				} else if (Value.flapLever >= 4 and Value.gearLever) {
					Internal.phaseNew = 5; # Approach
				} else if (Value.wow) {
					Internal.phaseNew = 6; # Rollout
				}
			}
		} else if (Internal.phase == 3) { # Cruise
			if (FlightData.cruiseAltAll[0] > 0) {
				if (Value.afsAlt < FlightData.cruiseAltAll[0]) {
					Internal.phaseNew = 4; # Descent
				} else if (Value.flapLever >= 4 and Value.gearLever) {
					Internal.phaseNew = 5; # Approach
				} else if (Value.wow) {
					Internal.phaseNew = 6; # Rollout
				}
			}
		} else if (Internal.phase == 4) { # Descent
			if (Value.flapLever > 0) {
				Internal.phaseNew = 5; # Approach
			} else if (Value.wow) {
				Internal.phaseNew = 6; # Rollout
			}
		} else if (Internal.phase == 5) { # Approach
			if (Value.flapLever == 0) {
				Internal.phaseNew = 4; # Descent
			} else if (Value.wow and Value.vertText != "G/A CLB") {
				Internal.phaseNew = 6; # Rollout
			}
		} else if (Internal.phase == 6) { # Rollout
			if (!Value.wow or Value.vertText == "G/A CLB") {
				Internal.phaseNew = 5; # Approach
			}
		}
		
		if (Internal.phase != Internal.phaseNew) {
			Internal.phase = Internal.phaseNew;
			Internal.phaseOut.setValue(Internal.phaseNew);
		}
		
		# FMS SPD logic
		FmsSpd.loop();
		
		# Reset system once engines shutdown
		if (Internal.engOn) {
			if (!Internal.resetToggle) {
				Internal.resetToggle = 1;
			}
		} else {
			if (Internal.resetToggle) {
				Internal.resetToggle = 0;
				me.init(1);
			}
		}
	},
	resetRadio: func() {
		pts.Instrumentation.Adf.Frequencies.selectedKhz[0].setValue(0);
		pts.Instrumentation.Adf.Frequencies.selectedKhz[1].setValue(0);
		pts.Instrumentation.Nav.Frequencies.selectedMhz[0].setValue(0);
		pts.Instrumentation.Nav.Frequencies.selectedMhz[1].setValue(0);
		pts.Instrumentation.Nav.Frequencies.selectedMhz[2].setValue(0);
		pts.Instrumentation.Nav.Radials.selectedDeg[0].setValue(-1);
		pts.Instrumentation.Nav.Radials.selectedDeg[1].setValue(-1);
		pts.Instrumentation.Nav.Radials.selectedDeg[2].setValue(-1);
	},
};
