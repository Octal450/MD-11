# McDonnell Douglas MD-11 FMS
# Copyright (c) 2024 Josh Davidson (Octal450)

# Properties and Data
var Speeds = {
	athrMax: props.globals.getNode("/systems/fms/speeds/athr-max"),
	athrMaxMach: props.globals.getNode("/systems/fms/speeds/athr-max-mach"),
	athrMin: props.globals.getNode("/systems/fms/speeds/athr-min"),
	athrMinMach: props.globals.getNode("/systems/fms/speeds/athr-min-mach"),
	cleanMin: props.globals.getNode("/systems/fms/speeds/clean-min"),
	econKts: props.globals.getNode("/systems/fms/speeds/econ-kts"),
	econMach: props.globals.getNode("/systems/fms/speeds/econ-mach"),
	flap15Max: props.globals.getNode("/systems/fms/speeds/flap-0-15-max-kts"),
	flap28Max: props.globals.getNode("/systems/fms/speeds/flap-28-max-kts"),
	flap28Min: props.globals.getNode("/systems/fms/speeds/flap-28-min"),
	flap35Max: props.globals.getNode("/systems/fms/speeds/flap-35-max-kts"),
	flap50Max: props.globals.getNode("/systems/fms/speeds/flap-50-max-kts"),
	flapGearMax: props.globals.getNode("/systems/fms/speeds/flap-gear-max"),
	gearExtMax: props.globals.getNode("/systems/fms/speeds/gear-ext-max-kts"),
	gearRetMax: props.globals.getNode("/systems/fms/speeds/gear-ret-max-kts"),
	maxClimb: props.globals.getNode("/systems/fms/speeds/max-climb"),
	maxDescent: props.globals.getNode("/systems/fms/speeds/max-descent"),
	slatMin: props.globals.getNode("/systems/fms/speeds/slat-min"),
	slatMax: props.globals.getNode("/systems/fms/speeds/slat-max-kts"),
	v1: props.globals.getNode("/systems/fms/speeds/v1"),
	v2: props.globals.getNode("/systems/fms/speeds/v2"),
	vapp: props.globals.getNode("/systems/fms/speeds/vapp"),
	vcl: props.globals.getNode("/systems/fms/speeds/vcl"),
	vclTo: props.globals.getNode("/systems/fms/speeds/vcl-to"),
	vfr: props.globals.getNode("/systems/fms/speeds/vfr"),
	vmax: props.globals.getNode("/systems/fms/speeds/vmax"),
	vmin: props.globals.getNode("/systems/fms/speeds/vmin"),
	vminTape: props.globals.getNode("/systems/fms/speeds/vmin-tape"),
	vmoMmo: props.globals.getNode("/systems/fms/speeds/vmo-mmo"),
	vr: props.globals.getNode("/systems/fms/speeds/vr"),
	vref: props.globals.getNode("/systems/fms/speeds/vref"),
	vsr: props.globals.getNode("/systems/fms/speeds/vsr"),
	vsrTo: props.globals.getNode("/systems/fms/speeds/vsr-to"),
	vss: props.globals.getNode("/systems/fms/speeds/vss"),
	vssTape: props.globals.getNode("/systems/fms/speeds/vss-tape"),
};

var FmsSpd = {
	active: 0,
	activeOut: props.globals.getNode("/systems/fms/fms-spd/active"),
	activeTo: 0,
	alt10kToggle: 0,
	econKts: 0,
	econMach: 0,
	kts: 0,
	ktsCmd: 0,
	ktsOut: props.globals.getNode("/systems/fms/fms-spd/kts"),
	ktsMach: 0,
	ktsMachOut: props.globals.getNode("/systems/fms/fms-spd/kts-mach"),
	mach: 0,
	machCmd: 0,
	machOut: props.globals.getNode("/systems/fms/fms-spd/mach"),
	machToggle: 0,
	maxClimb: 0,
	maxDescent: 0,
	maxKts: 365,
	maxMach: 0.87,
	minKts: 0,
	minMach: 0,
	pfdActive: 0,
	toDriving: 0,
	toKts: 0,
	v2Toggle: 0,
	vcl: 0,
	init: func() {
		me.active = 0;
		me.activeTo = 0;
		me.alt10kToggle = 0;
		me.kts = 0;
		me.ktsCmd = 0;
		me.ktsMach = 0;
		me.mach = 0;
		me.machCmd = 0;
		me.machToggle = 0;
		me.pfdActive = 0;
		me.toKts = 0;
		me.v2Toggle = 0;
	},
	cancel: func() {
		me.active = 0;
		me.toDriving = 0; # Cancels FMS SPD and Takeoff Guidance
		me.loop(); # Update immediately
		afs.Output.showSpdPreSel.setBoolValue(1);
	},
	cancelAndZero: func() {
		if (me.active) {
			me.cancel();
		}
		me.ktsMach = 0;
		me.ktsCmd = 0;
	},
	engage: func() {
		afs.Output.showSpdPreSel.setBoolValue(0);
		
		if (me.active) {
			fms.EditFlightData.returnToEcon();
			return;
		}
		
		if (me.engageAllowed) {
			me.active = 1;
			me.loop(); # Update immediately
		}
	},
	engageAllowed: func() {
		if (pts.Position.gearAglFt.getValue() >= 400 and !pts.Gear.wow[1].getBoolValue() and !pts.Gear.wow[2].getBoolValue() and ((Internal.phase <= 1 and me.toKts > 0) or (me.kts > 0 and me.mach > 0))) {
			return 1;
		} else {
			return 0;
		}
	},
	writeOut: func() {
		me.activeOut.setBoolValue(me.active);
		me.ktsOut.setValue(me.kts);
		me.ktsMachOut.setBoolValue(me.ktsMach);
		me.machOut.setValue(me.mach);
	},
	loop: func() {
		if (me.active) {
			if (!me.engageAllowed()) {
				me.cancel();
			}
		}
		
		me.getSpeeds();
		
		# Takeoff Guidance Logic
		me.takeoffLogic();
		
		# Special Takeoff Guidance Logic
		# Only when FMS SPD is active, or takeoff speed is available and non-overridden V2 is set
		if (me.active or (me.toKts > 0 and FlightData.v2State == 1)) {
			me.activeTo = 1;
		} else {
			me.activeTo = 0;
		}
		
		# Main FMS SPD Logic
		# ktsMach determins which is active, the other is handled in Inactive Value Sync
		if (Internal.phase == 2) { # Climb
			if (me.vcl > 0 and me.econKts > 0 and me.econMach > 0) {
				# Prevent flickering by using a latch
				if (Value.altitude >= 9995) {
					me.alt10kToggle = 1;
					
					if (Value.asiMach + 0.0005 >= me.econMach) {
						me.machToggle = 1;
					}
				} else if (Value.altitude < 9950) {
					me.alt10kToggle = 0;
					me.machToggle = 0;
				}
				
				if (me.alt10kToggle) {
					# TODO: EDIT mode
					if (FlightData.climbSpeedMode == 1) {
						me.ktsMach = 0;
						me.ktsCmd = math.max(me.maxClimb, me.vcl);
					} else {
						if (me.machToggle) {
							me.ktsMach = 1;
							me.machCmd = me.econMach;
						} else {
							me.ktsMach = 0;
							me.ktsCmd = math.max(me.econKts, me.vcl);
						}
					}
				} else {
					# TODO: EDIT mode
					if (FlightData.climbSpeedMode == 1) {
						me.ktsMach = 0;
						me.ktsCmd = math.max(me.maxClimb, me.vcl);
					} else {
						me.ktsMach = 0;
						me.ktsCmd = math.max(250, me.vcl);
					}
				}
			} else {
				me.cancelAndZero();
			}
		} else if (Internal.phase <= 1) { # Preflight/Takeoff
			if (me.active) { # Re-enable driving if overriden
				me.toDriving = 1;
			}
			
			if (me.activeTo) {
				me.ktsMach = 0;
				me.ktsCmd = me.toKts;
			} else {
				me.cancelAndZero();
			}
		} else {
			me.cancelAndZero();
		}
		
		# Inactive Value Sync
		if (me.ktsMach) {
			if (me.machCmd > 0) {
				me.setConvertKts(Value.asiKts, Value.asiMach);
			} else {
				me.ktsCmd = 0;
			}
		} else {
			if (me.ktsCmd > 0) {
				me.setConvertMach(Value.asiKts, Value.asiMach);
			} else {
				me.machCmd = 0;
			}
		}
		
		# Speed Limiting Logic
		# 0 is disallowed as it indicates invalid speed
		me.maxKts = math.max(Speeds.athrMax.getValue(), 1);
		me.maxMach = math.max(Speeds.athrMaxMach.getValue(), 0.001);
		me.minKts = math.max(Speeds.athrMin.getValue(), 1);
		me.minMach = math.max(Speeds.athrMinMach.getValue(), 0.001);
		
		if (me.ktsCmd > 0) {
			if (me.minKts > me.maxKts) { # Max takes priority
				me.kts = me.maxKts;
			} else if (me.ktsCmd > me.maxKts) {
				me.kts = me.maxKts;
			} else if (me.ktsCmd < me.minKts) {
				me.kts = me.minKts;
			} else {
				me.kts = me.ktsCmd;
			}
		} else {
			me.kts = 0;
		}
		
		if (me.machCmd > 0) {
			if (me.minMach > me.maxMach) { # Max takes priority
				me.mach = me.maxMach;
			} else if (me.machCmd > me.maxMach) {
				me.mach = me.maxMach;
			} else if (me.machCmd < me.minMach) {
				me.mach = me.minMach;
			} else {
				me.mach = me.machCmd;
			}
		} else {
			me.mach = 0;
		}
		
		# PFD Magenta Bug: Shown only when FMS SPD is active, or non-overridden V2 is set and driven
		if (me.active or (me.toDriving and me.toKts > 0 and FlightData.v2State == 1)) {
			me.pfdActive = 1;
		} else {
			me.pfdActive = 0;
		}
		
		# Write to Property Tree
		me.writeOut();
	},
	getSpeeds: func() {
		me.econKts = math.round(Speeds.econKts.getValue());
		me.econMach = math.round(Speeds.econMach.getValue(), 0.001);
		me.maxClimb = math.round(Speeds.maxClimb.getValue());
		me.maxDescent = math.round(Speeds.maxDescent.getValue());
		me.vcl = math.round(Speeds.vcl.getValue());
	},
	setConvertKts: func(ktsCurrent, machCurrent) {
		me.ktsCmd = math.max(math.round(me.machCmd * (ktsCurrent / machCurrent)), 1); # 0 is disallowed
	},
	setConvertMach: func(ktsCurrent, machCurrent) {
		me.machCmd = math.max(math.round(me.ktsCmd * (machCurrent / ktsCurrent), 0.001), 0.001); # 0 is disallowed
	},
	takeoffLogic: func() {
		if (Internal.phase >= 2) {
			me.toDriving = 0;
			me.toKts = 0;
			me.v2Toggle = 0;
			return;
		}
		
		if (fms.FlightData.v2 > 0) {
			if (!Value.wow) {
				if (systems.ENGINES.anyEngineOut.getBoolValue()) {
					if (!me.v2Toggle) { # Only set the speed once
						me.v2Toggle = 1;
						me.toKts = math.clamp(math.round(Value.asiKts), FlightData.v2, FlightData.v2 + 10);
					}
				} else if (Value.gearAglFt < 400) { # Once hitting 400 feet, this is overridable
					me.toDriving = 1;
					me.toKts = fms.FlightData.v2 + 10;
				}
			} else {
				me.toDriving = 1;
				me.toKts = math.clamp(math.max(FlightData.v2, math.round(Value.asiKts)), FlightData.v2, FlightData.v2 + 10);
				me.v2Toggle = 0;
			}
		} else {
			me.toDriving = 0;
			me.toKts = 0;
			me.v2Toggle = 0;
		}
	},
};

setlistener("/systems/fms/internal/ias-v2-clamp-out", func() { # This is used only to make the loop update when the speed changes between V2 and V2 + 10
	if (FmsSpd.toDriving) {
		FmsSpd.takeoffLogic();
		afs.ITAF.takeoffSpdLogic();
	}
}, 0, 0);
