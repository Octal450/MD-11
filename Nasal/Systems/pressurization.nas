# McDonnell Douglas MD-11 Pressurization
# Copyright (c) 2026 Josh Davidson (Octal450)

var PRESSURIZATION = {
	Cabin: {
		altFt: props.globals.getNode("/systems/pressurization/cabin-alt-ft"),
		diffPsi: props.globals.getNode("/systems/pressurization/cabin-diff-psi"),
		rateFpm: props.globals.getNode("/systems/pressurization/cabin-rate-fpm"),
	},
	OutflowValve: {
		pos: props.globals.getNode("/systems/pressurization/outflow-valve/pos"),
	},
	system: props.globals.getNode("/systems/pressurization/system"),
	Controls: {
		system: props.globals.getNode("/controls/pressurization/system"),
	},
	Failures: {
		system: props.globals.getNode("/systems/failures/pressurization/system"),
	},
	Lights: {
		manualFlash: props.globals.getNode("/systems/pressurization/lights/manual-flash"),
		manualFlashTemp: 0,
		outflowClosed: props.globals.getNode("/systems/pressurization/lights/outflow-closed"),
	},
	init: func() {
		me.resetFailures();
		me.Controls.system.setBoolValue(1);
		manualPressLightt.stop();
		me.Lights.manualFlash.setValue(0);
	},
	resetFailures: func() {
		me.Failures.system.setBoolValue(0);
	},
	systemMode: func() {
		if (me.Controls.system.getBoolValue()) {
			me.Controls.system.setBoolValue(0);
			manualPressLightt.stop();
			me.Lights.manualFlash.setValue(0);
		} else {
			me.Controls.system.setBoolValue(1);
			manualPressLightt.stop();
			me.Lights.manualFlash.setValue(0);
		}
	},
	manualLight: func() {
		me.Lights.manualFlashTemp = me.Lights.manualFlash.getValue();
		if (me.Lights.manualFlashTemp >= 5 or !me.Controls.system.getBoolValue()) {
			manualPressLightt.stop();
			me.Lights.manualFlash.setValue(0);
		} else {
			me.Lights.manualFlash.setValue(me.Lights.manualFlashTemp + 1);
		}
	},
};

var manualPressLightt = maketimer(0.4, PRESSURIZATION, PRESSURIZATION.manualLight);
