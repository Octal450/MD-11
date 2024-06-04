# McDonnell Douglas MD-11 FMS
# Copyright (c) 2024 Josh Davidson (Octal450)

# Properties and Data
var Speeds = {
	athrMax: props.globals.getNode("/fms/speeds/athr-max"),
	athrMaxMach: props.globals.getNode("/fms/speeds/athr-max-mach"),
	athrMin: props.globals.getNode("/fms/speeds/athr-min"),
	athrMinMach: props.globals.getNode("/fms/speeds/athr-min-mach"),
	cleanMin: props.globals.getNode("/fms/speeds/clean-min"),
	flap15Max: props.globals.getNode("/fms/speeds/flap-0-15-max-kts"),
	flap28Max: props.globals.getNode("/fms/speeds/flap-28-max-kts"),
	flap28Min: props.globals.getNode("/fms/speeds/flap-28-min"),
	flap35Max: props.globals.getNode("/fms/speeds/flap-35-max-kts"),
	flap50Max: props.globals.getNode("/fms/speeds/flap-50-max-kts"),
	flapGearMax: props.globals.getNode("/fms/speeds/flap-gear-max"),
	gearExtMax: props.globals.getNode("/fms/speeds/gear-ext-max-kts"),
	gearRetMax: props.globals.getNode("/fms/speeds/gear-ret-max-kts"),
	slatMin: props.globals.getNode("/fms/speeds/slat-min"),
	slatMax: props.globals.getNode("/fms/speeds/slat-max-kts"),
	v1: props.globals.getNode("/fms/speeds/v1"),
	v2: props.globals.getNode("/fms/speeds/v2"),
	vapp: props.globals.getNode("/fms/speeds/vapp"),
	vcl: props.globals.getNode("/fms/speeds/vcl"),
	vclTo: props.globals.getNode("/fms/speeds/vcl-to"),
	vfr: props.globals.getNode("/fms/speeds/vfr"),
	vmax: props.globals.getNode("/fms/speeds/vmax"),
	vmin: props.globals.getNode("/fms/speeds/vmin"),
	vminTape: props.globals.getNode("/fms/speeds/vmin-tape"),
	vmoMmo: props.globals.getNode("/fms/speeds/vmo-mmo"),
	vr: props.globals.getNode("/fms/speeds/vr"),
	vref: props.globals.getNode("/fms/speeds/vref"),
	vsr: props.globals.getNode("/fms/speeds/vsr"),
	vsrTo: props.globals.getNode("/fms/speeds/vsr-to"),
	vss: props.globals.getNode("/fms/speeds/vss"),
	vssTape: props.globals.getNode("/fms/speeds/vss-tape"),
};

var FmsSpd = {
	active: 0,
	activeOut: props.globals.getNode("/fms/fms-spd/active"),
	kts: 0,
	ktsOut: props.globals.getNode("/fms/fms-spd/kts"),
	ktsMach: 0,
	ktsMachOut: props.globals.getNode("/fms/fms-spd/kts-mach"),
	mach: 0,
	machOut: props.globals.getNode("/fms/fms-spd/mach"),
	init: func() {
		me.active = 0;
		me.kts = 0;
		me.ktsMach = 0;
		me.mach = 0;
	},
	cancel: func() {
		me.active = 0;
	},
	writeOut: func() {
		me.activeOut.setBoolValue(me.active);
		me.ktsOut.setValue(me.kts);
		me.ktsMachOut.setBoolValue(me.ktsMach);
		me.machOut.setValue(me.mach);
	},
	loop: func() {
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
		
		me.writeOut();
	},
	setConvertKts: func(kts, mach) {
		me.kts = math.round(me.mach * (kts / mach));
	},
	setConvertMach: func(kts, mach) {
		me.mach = math.round(me.kts * (mach / kts), 0.001);
	},
};
