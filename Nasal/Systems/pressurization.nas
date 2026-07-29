# McDonnell Douglas MD-11 Pressurization
# Copyright (c) 2026 Josh Davidson (Octal450)

var PRESSURIZATION = {
	Cabin: {
		altFt: props.globals.getNode("/systems/pressurization/cabin-alt-ft"),
		diffPsi: props.globals.getNode("/systems/pressurization/cabin-diff-psi"),
		psi: props.globals.getNode("/systems/pressurization/cabin-psi"),
		rateFpm: props.globals.getNode("/systems/pressurization/cabin-rate-fpm"),
	},
	Cpcs: {
		landingAlt: props.globals.getNode("/systems/pressurization/cpcs/landing-alt"),
		landingAltIndicated: props.globals.getNode("/systems/pressurization/cpcs/landing-alt-indicated"),
		manualLandingAltSet: props.globals.getNode("/systems/pressurization/cpcs/manual-landing-alt-set"),
		takeoffAlt: props.globals.getNode("/systems/pressurization/cpcs/takeoff-alt"),
	},
	OutflowValve: {
		pos: props.globals.getNode("/systems/pressurization/outflow-valve/pos"),
	},
	system: props.globals.getNode("/systems/pressurization/system"),
	Controls: {
		cabinManual: props.globals.getNode("/controls/pressurization/cabin-manual"),
		manualLandingAlt: props.globals.getNode("/controls/pressurization/manual-landing-alt"),
		manualLandingAltSet: props.globals.getNode("/controls/pressurization/manual-landing-alt-set"),
		system: props.globals.getNode("/controls/pressurization/system"),
	},
	Failures: {
		system: props.globals.getNode("/systems/failures/pressurization/system"),
	},
	Lights: {
		manualFlash: props.globals.getNode("/systems/pressurization/lights/manual-flash"),
		manualFlashTemp: 0,
		outflowClosed: props.globals.getNode("/systems/pressurization/lights/outflow-closed"),
		rateExceed5Sec: props.globals.getNode("/systems/pressurization/lights/rate-exceed-5-sec"),
		rateExceed15Sec: props.globals.getNode("/systems/pressurization/lights/rate-exceed-15-sec"),
	},
	init: func() {
		me.resetFailures();
		me.Cabin.psi.setValue(pts.Environment.pressureInhg.getValue() * 0.491154); # Sync cabin to current pressure on sim load
		me.Controls.cabinManual.setValue(0);
		me.Controls.manualLandingAlt.setValue(0);
		me.Controls.manualLandingAltSet.setBoolValue(0);
		me.Controls.system.setBoolValue(1);
		manualPressLightt.stop();
		me.Lights.manualFlash.setValue(0);
	},
	resetFailures: func() {
		me.Failures.system.setBoolValue(0);
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
	setManualLandingAlt: func(d) {
		if (me.system.getBoolValue()) {
			if (!me.Controls.manualLandingAltSet.getBoolValue()) {
				me.Controls.manualLandingAlt.setValue(0);
				me.Controls.manualLandingAltSet.setBoolValue(1);
			}
			
			me.Controls.manualLandingAlt.setValue(math.clamp(me.Controls.manualLandingAlt.getValue() + d, -1000, 9990));
		}
	},
	systemMode: func() {
		if (me.Controls.system.getBoolValue()) {
			me.Controls.system.setBoolValue(0);
			manualPressLightt.stop();
			me.Lights.manualFlash.setValue(0);
		} else {
			me.Controls.manualLandingAltSet.setBoolValue(0);
			me.Controls.manualLandingAlt.setValue(0);
			me.Controls.system.setBoolValue(1);
			manualPressLightt.stop();
			me.Lights.manualFlash.setValue(0);
		}
	},
};

var manualPressLightt = maketimer(0.4, PRESSURIZATION, PRESSURIZATION.manualLight);
