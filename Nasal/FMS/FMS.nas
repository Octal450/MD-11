# MD-11 FMS
# Copyright (c) 2021 Josh Davidson (Octal450)

var Internal = {
	bankAngle1: props.globals.initNode("/fms/internal/bank-limit-1", 0, "DOUBLE"),
	bankAngle2: props.globals.initNode("/fms/internal/bank-limit-2", 0, "DOUBLE"),
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
	v2Plus10: props.globals.getNode("/fms/speeds/v2-plus-10"),
	vcl: props.globals.getNode("/fms/speeds/vcl"),
	vfr: props.globals.getNode("/fms/speeds/vfr"),
	vmax: props.globals.getNode("/fms/speeds/vmax"),
	vmin: props.globals.getNode("/fms/speeds/vmin"),
	vminTape: props.globals.getNode("/fms/speeds/vmin-tape"),
	vmoMmo: props.globals.getNode("/fms/speeds/vmo-mmo"),
	vr: props.globals.getNode("/fms/speeds/vr"),
	vsr: props.globals.getNode("/fms/speeds/vsr"),
	vss: props.globals.getNode("/fms/speeds/vss"),
	vssTape: props.globals.getNode("/fms/speeds/vss-tape"),
};

var CORE = {
	resetFMS: func() {
		Internal.v2.setValue(153);
		afs.ITAF.init(1);
	},
};
