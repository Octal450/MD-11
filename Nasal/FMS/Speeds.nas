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
	activeOrTo: 0,
	activeOrToDriving: 0,
	econKts: 0,
	econMach: 0,
	kts: 0,
	ktsOut: props.globals.getNode("/systems/fms/fms-spd/kts"),
	ktsMach: 0,
	ktsMachOut: props.globals.getNode("/systems/fms/fms-spd/kts-mach"),
	mach: 0,
	machOut: props.globals.getNode("/systems/fms/fms-spd/mach"),
	maxClimb: 0,
	maxDescent: 0,
	toDriving: 0,
	toKts: 0,
	v2Toggle: 0,
	init: func() {
		me.active = 0;
		me.activeOrTo = 0;
		me.activeOrToDriving = 0;
		me.kts = 0;
		me.ktsMach = 0;
		me.mach = 0;
		me.toKts = 0;
		me.v2Toggle = 0;
	},
	cancel: func() {
		me.active = 0;
		me.toDriving = 0;
		me.loop(); # Update immediately
	},
	engage: func() {
		me.active = 1;
		me.toDriving = 0; # Ensure it doesn't interfere with FMS SPD
		me.loop(); # Update immediately
	},
	writeOut: func() {
		me.activeOut.setBoolValue(me.active);
		me.ktsOut.setValue(me.kts);
		me.ktsMachOut.setBoolValue(me.ktsMach);
		me.machOut.setValue(me.mach);
	},
	loop: func() {
		me.getSpeeds();
		
		Value.asiKts = math.max(pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue(), 0.0001);
		Value.asiMach = math.max(pts.Instrumentation.AirspeedIndicator.indicatedMach.getValue(), 0.0001);
		
		# Sync the inactive value
		if (me.ktsMach) {
			if (me.mach > 0) {
				me.setConvertKts(Value.asiKts, Value.asiMach);
			} else {
				me.kts = 0;
			}
		} else {
			if (me.kts > 0) {
				me.setConvertMach(Value.asiKts, Value.asiMach);
			} else {
				me.mach = 0;
			}
		}
		
		# Takeoff Guidance Logic
		me.takeoffLogic();
		
		# Special Takeoff Guidance Logic
		# Only when FMS SPD is active, or non-overridden V2 is set
		if (me.active or (me.toKts > 0 and FlightData.v2State == 1)) {
			me.activeOrTo = 1;
		} else {
			me.activeOrTo = 0;
		}
		
		# Only when FMS SPD is active, or non-overridden V2 is set and driven
		if (me.active or (me.toDriving and me.toKts > 0 and FlightData.v2State == 1)) {
			me.activeOrToDriving = 1;
		} else {
			me.activeOrToDriving = 0;
		}
		# End Special Takeoff Guidance Logic
		
		# Main FMS SPD Logic
		if (Internal.phase <= 1) {
			if (me.activeOrTo) {
				me.ktsMach = 0;
				me.kts = me.toKts;
			} else {
				me.ktsMach = 0;
				me.kts = 0;
			}
		} else {
			me.ktsMach = 0;
			me.kts = 0;
		}
		
		me.writeOut();
	},
	getSpeeds: func() {
		me.econKts = math.round(Speeds.econKts.getValue());
		me.econMach = math.round(Speeds.econMach.getValue(), 0.001);
		me.maxClimb = math.round(Speeds.maxClimb.getValue());
		me.maxDescent = math.round(Speeds.maxDescent.getValue());
	},
	setConvertKts: func(kts, mach) {
		me.kts = math.round(me.mach * (kts / mach));
	},
	setConvertMach: func(kts, mach) {
		me.mach = math.round(me.kts * (mach / kts), 0.001);
	},
	takeoffLogic: func() {
		if (fms.FmsSpd.active) {
			me.toDriving = 0; # Ensure it doesn't interfere with FMS SPD
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
			me.toDriving = 1;
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
