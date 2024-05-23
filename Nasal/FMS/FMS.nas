# McDonnell Douglas MD-11 FMS
# Copyright (c) 2024 Josh Davidson (Octal450)

# Properties and Data
var Internal = {
	bankAngle1: props.globals.initNode("/fms/internal/bank-limit-1"),
	bankAngle2: props.globals.initNode("/fms/internal/bank-limit-2"),
	bankAngleVss: props.globals.initNode("/fms/internal/bank-limit-vss"),
	cgPercentMac: props.globals.initNode("/fms/internal/cg-percent-mac"),
	engOn: 0,
	Messages: {
		vspeeds: 0,
	},
	phase: 0, # 0: Preflight, 1: Takeoff, 2: Climb, 3: Cruise, 4: Descent, 5: Approach, 6: Rollout
	phaseNew: 0,
	phaseOut: props.globals.getNode("/fms/internal/phase"),
	request: [1, 1, 0],
	resetToggle: 0,
	takeoffStabDeg: props.globals.initNode("/fms/internal/takeoff-stab-deg"),
};

var RouteManager = {
	active: props.globals.getNode("/autopilot/route-manager/active"),
	alternateAirport: props.globals.getNode("/autopilot/route-manager/alternate/airport"),
	cruiseAlt: props.globals.getNode("/autopilot/route-manager/cruise/altitude-ft"),
	currentWp: props.globals.getNode("/autopilot/route-manager/current-wp"),
	departureAirport: props.globals.getNode("/autopilot/route-manager/departure/airport"),
	destinationAirport: props.globals.getNode("/autopilot/route-manager/destination/airport"),
	distanceRemainingNm: props.globals.getNode("/autopilot/route-manager/distance-remaining-nm"),
};

var Speeds = {
	athrMax: props.globals.getNode("/fms/speeds/athr-max"),
	athrMaxMach: props.globals.getNode("/fms/speeds/athr-max-mach"),
	athrMin: props.globals.getNode("/fms/speeds/athr-min"),
	athrMinMach: props.globals.getNode("/fms/speeds/athr-min-mach"),
	flap15Max: props.globals.getNode("/fms/speeds/flap-0-15-max-kts"),
	flap28Max: props.globals.getNode("/fms/speeds/flap-28-max-kts"),
	flap35Max: props.globals.getNode("/fms/speeds/flap-35-max-kts"),
	flap50Max: props.globals.getNode("/fms/speeds/flap-50-max-kts"),
	flapGearMax: props.globals.getNode("/fms/speeds/flap-gear-max"),
	gearExtMax: props.globals.getNode("/fms/speeds/gear-ext-max-kts"),
	gearRetMax: props.globals.getNode("/fms/speeds/gear-ret-max-kts"),
	slatMax: props.globals.getNode("/fms/speeds/slat-max-kts"),
	v1: props.globals.getNode("/fms/speeds/v1"),
	v2: props.globals.getNode("/fms/speeds/v2"),
	vcl: props.globals.getNode("/fms/speeds/vcl"),
	vclTo: props.globals.getNode("/fms/speeds/vcl-to"),
	vfr: props.globals.getNode("/fms/speeds/vfr"),
	vmax: props.globals.getNode("/fms/speeds/vmax"),
	vmin: props.globals.getNode("/fms/speeds/vmin"),
	vminTape: props.globals.getNode("/fms/speeds/vmin-tape"),
	vmoMmo: props.globals.getNode("/fms/speeds/vmo-mmo"),
	vr: props.globals.getNode("/fms/speeds/vr"),
	vsr: props.globals.getNode("/fms/speeds/vsr"),
	vsrTo: props.globals.getNode("/fms/speeds/vsr-to"),
	vss: props.globals.getNode("/fms/speeds/vss"),
	vssTape: props.globals.getNode("/fms/speeds/vss-tape"),
};

var Value = { # Local store of commonly accessed values
	active: 0,
	afsAlt: 0,
	altitude: 0,
	distanceRemainingNm: 0,
	vertText: 0,
	wow: 0,
};

# Logic
var CORE = {
	init: func() {
		EditFlightData.reset();
		Internal.request[0] = 1;
		Internal.request[1] = 1;
		Internal.request[2] = 0;
		me.resetRadio();
	},
	loop: func() {
		Value.active = RouteManager.active.getBoolValue();
		Value.afsAlt = afs.Internal.alt.getValue();
		Value.altitude = pts.Instrumentation.Altimeter.indicatedAltitudeFt.getValue();
		Value.distanceRemainingNm = RouteManager.distanceRemainingNm.getValue();
		Value.vertText = afs.Text.vert.getValue();
		Value.wow = pts.Fdm.JSBsim.Position.wow.getBoolValue();
		
		if (pts.Engines.Engine.state[0].getValue() == 3 or pts.Engines.Engine.state[1].getValue() == 3 or pts.Engines.Engine.state[2].getValue() == 3) {
			Internal.engOn = 1;
		} else {
			Internal.engOn = 0;
		}
		
		EditFlightData.loop();
		
		# Flight Phases
		if (Internal.phase == 0) { # Preflight
			if (Value.vertText == "T/O CLB" and systems.FADEC.throttleCompareMax.getValue() >= 0.7) {
				Internal.phaseNew = 1;
			}
		} else if (Internal.phase == 1) { # Takeoff
			if (systems.FADEC.throttleCompareMax.getValue() < 0.7) { # Rejected T/O
				Internal.phaseNew = 0;
			} else if (FlightData.accelAlt > -1000) {
				if (Value.vertText != "T/O CLB" and Value.altitude >= FlightData.accelAlt) {
					Internal.phaseNew = 2;
				}
			}
		} else if (Internal.phase == 2) { # Climb
			if (FlightData.cruiseAltAll[0] > 0) {
				if (Value.vertText == "ALT HLD" and Value.afsAlt >= FlightData.cruiseAltAll[0]) {
					Internal.phaseNew = 3;
				}
			}
		} else if (Internal.phase == 3) { # Cruise
			if (FlightData.cruiseAltAll[0] > 0) {
				if (Value.afsAlt < FlightData.cruiseAltAll[0]) {
					Internal.phaseNew = 4;
				}
			}
		} else if (Internal.phase == 4) { # Descent
			if (Value.active) {
				if (Value.distanceRemainingNm <= 15 or Value.vertText == "G/S") { # Fix this
					Internal.phaseNew = 5;
				}
			}
		} else if (Internal.phase == 5) { # Approach
			if (Value.active) {
				if (Value.wow) {
					Internal.phaseNew = 6;
				} else if (Value.vertText == "G/A CLB") {
					Internal.phaseNew = 4;
				}
			}
		} else if (Internal.phase == 6) { # Rollout
			if (Value.active) {
				if (Value.vertText == "G/A CLB") {
					Internal.phaseNew = 4;
				}
			}
		}
		
		if (Internal.phase != Internal.phaseNew) {
			Internal.phase = Internal.phaseNew;
			Internal.phaseOut.setValue(Internal.phaseNew);
		}
		
		# Reset system once engines shutdown
		if (Internal.engOn) {
			if (!Internal.resetToggle) {
				Internal.resetToggle = 1;
			}
		} else {
			if (Internal.resetToggle) {
				Internal.resetToggle = 0;
				me.reset();
			}
		}
	},
	reset: func() {
		EditFlightData.reset();
		Internal.request[0] = 1;
		Internal.request[1] = 1;
		Internal.request[2] = 0;
		mcdu.BASE.reset(); # Last
	},
	resetRadio: func() {
		pts.Instrumentation.Adf.Frequencies.selectedKhz[0].setValue(0);
		pts.Instrumentation.Adf.Frequencies.selectedKhz[1].setValue(0);
		pts.Instrumentation.Nav.Frequencies.selectedMhz[0].setValue(0);
		pts.Instrumentation.Nav.Frequencies.selectedMhz[1].setValue(0);
		pts.Instrumentation.Nav.Frequencies.selectedMhz[2].setValue(0);
		pts.Instrumentation.Nav.Radials.selectedDeg[0].setValue(0);
		pts.Instrumentation.Nav.Radials.selectedDeg[1].setValue(0);
		pts.Instrumentation.Nav.Radials.selectedDeg[2].setValue(0);
	},
};
