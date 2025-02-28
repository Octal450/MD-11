# McDonnell Douglas MD-11 Pneumatics
# Copyright (c) 2025 Josh Davidson (Octal450)

var PNEUMATICS = {
	Flow: {
		pack1: props.globals.getNode("/systems/pneumatics/pack-1-flow"),
		pack2: props.globals.getNode("/systems/pneumatics/pack-2-flow"),
		pack3: props.globals.getNode("/systems/pneumatics/pack-3-flow"),
	},
	Psi: {
		apu: props.globals.getNode("/systems/pneumatics/apu-psi"),
		bleed1: props.globals.getNode("/systems/pneumatics/bleed-1-psi"),
		bleed2: props.globals.getNode("/systems/pneumatics/bleed-2-psi"),
		bleed3: props.globals.getNode("/systems/pneumatics/bleed-3-psi"),
		eng1: props.globals.getNode("/systems/pneumatics/eng-1-psi"),
		eng2: props.globals.getNode("/systems/pneumatics/eng-2-psi"),
		eng3: props.globals.getNode("/systems/pneumatics/eng-3-psi"),
		ground: props.globals.getNode("/systems/pneumatics/ground-psi"),
	},
	system: props.globals.getNode("/systems/pneumatics/system"),
	Controls: {
		aftTemp: props.globals.getNode("/controls/pneumatics/aft-temp"),
		avionicsFan: props.globals.getNode("/controls/pneumatics/avionics-fan"),
		bleedApu: props.globals.getNode("/controls/pneumatics/bleed-apu"),
		bleed1: props.globals.getNode("/controls/pneumatics/bleed-1"),
		bleed2: props.globals.getNode("/controls/pneumatics/bleed-2"),
		bleed3: props.globals.getNode("/controls/pneumatics/bleed-3"),
		cargoAftTemp: props.globals.getNode("/controls/pneumatics/cargo-aft-temp"),
		cargoFwdTemp: props.globals.getNode("/controls/pneumatics/cargo-fwd-temp"),
		cockpitTemp: props.globals.getNode("/controls/pneumatics/cockpit-temp"),
		econ: props.globals.getNode("/controls/pneumatics/econ"),
		fwdTemp: props.globals.getNode("/controls/pneumatics/fwd-temp"),
		groundAir: props.globals.getNode("/controls/pneumatics/ground-air"), # No switch in cockpit
		isol12: props.globals.getNode("/controls/pneumatics/isol-1-2"),
		isol13: props.globals.getNode("/controls/pneumatics/isol-1-3"),
		midTemp: props.globals.getNode("/controls/pneumatics/mid-temp"),
		pack1: props.globals.getNode("/controls/pneumatics/pack-1"),
		pack2: props.globals.getNode("/controls/pneumatics/pack-2"),
		pack3: props.globals.getNode("/controls/pneumatics/pack-3"),
		system: props.globals.getNode("/controls/pneumatics/system"),
		trimAir: props.globals.getNode("/controls/pneumatics/trim-air"),
	},
	Failures: {
		bleedApu: props.globals.getNode("/systems/failures/pneumatics/bleed-apu"),
		bleed1: props.globals.getNode("/systems/failures/pneumatics/bleed-1"),
		bleed2: props.globals.getNode("/systems/failures/pneumatics/bleed-2"),
		bleed3: props.globals.getNode("/systems/failures/pneumatics/bleed-3"),
		pack1: props.globals.getNode("/systems/failures/pneumatics/pack-1"),
		pack2: props.globals.getNode("/systems/failures/pneumatics/pack-2"),
		pack3: props.globals.getNode("/systems/failures/pneumatics/pack-3"),
		system: props.globals.getNode("/systems/failures/pneumatics/system"),
	},
	Lights: {
		manualFlash: props.globals.initNode("/systems/pneumatics/lights/manual-flash", 0, "INT"),
		manualFlashTemp: 0,
	},
	init: func() {
		me.resetFailures();
		me.Controls.aftTemp.setValue(0.45);
		me.Controls.avionicsFan.setBoolValue(1);
		me.Controls.bleedApu.setBoolValue(0);
		me.Controls.bleed1.setBoolValue(1);
		me.Controls.bleed2.setBoolValue(1);
		me.Controls.bleed3.setBoolValue(1);
		me.Controls.cargoFwdTemp.setValue(0.5);
		me.Controls.cargoAftTemp.setValue(0.4);
		me.Controls.cockpitTemp.setValue(0.45);
		me.Controls.econ.setBoolValue(1);
		me.Controls.fwdTemp.setValue(0.45);
		me.Controls.groundAir.setBoolValue(0);
		me.Controls.isol12.setBoolValue(0);
		me.Controls.isol13.setBoolValue(0);
		me.Controls.midTemp.setValue(0.45);
		me.Controls.pack1.setBoolValue(1);
		me.Controls.pack2.setBoolValue(1);
		me.Controls.pack3.setBoolValue(1);
		me.Controls.system.setBoolValue(1);
		me.Controls.trimAir.setBoolValue(1);
		manualPneuLightt.stop();
		me.Lights.manualFlash.setValue(0);
	},
	resetFailures: func() {
		me.Failures.bleedApu.setBoolValue(0);
		me.Failures.bleed1.setBoolValue(0);
		me.Failures.bleed2.setBoolValue(0);
		me.Failures.bleed3.setBoolValue(0);
		me.Failures.pack1.setBoolValue(0);
		me.Failures.pack2.setBoolValue(0);
		me.Failures.pack3.setBoolValue(0);
		me.Failures.system.setBoolValue(0);
	},
	systemMode: func() {
		if (me.Controls.system.getBoolValue()) {
			me.Controls.system.setBoolValue(0);
			manualPneuLightt.stop();
			me.Lights.manualFlash.setValue(0);
		} else {
			me.Controls.system.setBoolValue(1);
			manualPneuLightt.stop();
			me.Lights.manualFlash.setValue(0);
		}
	},
	manualLight: func() {
		me.Lights.manualFlashTemp = me.Lights.manualFlash.getValue();
		if (me.Lights.manualFlashTemp >= 5 or !me.Controls.system.getBoolValue()) {
			manualPneuLightt.stop();
			me.Lights.manualFlash.setValue(0);
		} else {
			me.Lights.manualFlash.setValue(me.Lights.manualFlashTemp + 1);
		}
	},
};

var manualPneuLightt = maketimer(0.4, PNEUMATICS, PNEUMATICS.manualLight);
