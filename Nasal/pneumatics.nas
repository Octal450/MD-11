# McDonnell Douglas MD-11 Pneumatic System
# Copyright (c) 2019 Joshua Davidson (Octal450)

var PNEU = {
	Fail: {
		bleedApu: props.globals.getNode("/systems/failures/pneumatics/bleed-apu"),
		bleedExt: props.globals.getNode("/systems/failures/pneumatics/bleed-ext"),
		bleed1: props.globals.getNode("/systems/failures/pneumatics/bleed-1"),
		bleed2: props.globals.getNode("/systems/failures/pneumatics/bleed-2"),
		bleed3: props.globals.getNode("/systems/failures/pneumatics/bleed-3"),
		pack1: props.globals.getNode("/systems/failures/pneumatics/pack-1"),
		pack2: props.globals.getNode("/systems/failures/pneumatics/pack-2"),
		pack3: props.globals.getNode("/systems/failures/pneumatics/pack-3"),
	},
	Flow: {
		pack1: props.globals.getNode("/systems/pneumatics/pack-1-flow"),
		pack2: props.globals.getNode("/systems/pneumatics/pack-2-flow"),
		pack3: props.globals.getNode("/systems/pneumatics/pack-3-flow"),
	},
	Light: {
		manualFlash: props.globals.initNode("/systems/pneumatics/light/manual-flash", 0, "INT"),
		manualFlashTemp: 0,
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
	Switch: {
		aftTemp: props.globals.getNode("/controls/pneumatics/switches/aft-temp"),
		avionicsFan: props.globals.getNode("/controls/pneumatics/switches/avionics-fan"),
		bleedApu: props.globals.getNode("/controls/pneumatics/switches/bleed-apu"),
		bleed1: props.globals.getNode("/controls/pneumatics/switches/bleed-1"),
		bleed2: props.globals.getNode("/controls/pneumatics/switches/bleed-2"),
		bleed3: props.globals.getNode("/controls/pneumatics/switches/bleed-3"),
		cockpitTemp: props.globals.getNode("/controls/pneumatics/switches/cockpit-temp"),
		econ: props.globals.getNode("/controls/pneumatics/switches/econ"),
		fwdTemp: props.globals.getNode("/controls/pneumatics/switches/fwd-temp"),
		groundAir: props.globals.getNode("/controls/pneumatics/switches/ground-air"), # No switch in cockpit
		isol12: props.globals.getNode("/controls/pneumatics/switches/isol-1-2"),
		isol13: props.globals.getNode("/controls/pneumatics/switches/isol-1-3"),
		midTemp: props.globals.getNode("/controls/pneumatics/switches/mid-temp"),
		pack1: props.globals.getNode("/controls/pneumatics/switches/pack-1"),
		pack2: props.globals.getNode("/controls/pneumatics/switches/pack-2"),
		pack3: props.globals.getNode("/controls/pneumatics/switches/pack-3"),
		trimAir: props.globals.getNode("/controls/pneumatics/switches/trim-air"),
	},
	system: props.globals.getNode("/systems/pneumatics/system"),
	init: func() {
		me.resetFail();
		me.Switch.aftTemp.setValue(0.5);
		me.Switch.avionicsFan.setBoolValue(1);
		me.Switch.bleedApu.setBoolValue(0);
		me.Switch.bleed1.setBoolValue(1);
		me.Switch.bleed2.setBoolValue(1);
		me.Switch.bleed3.setBoolValue(1);
		me.Switch.econ.setBoolValue(1);
		me.Switch.fwdTemp.setValue(0.5);
		me.Switch.groundAir.setBoolValue(0);
		me.Switch.isol12.setBoolValue(0);
		me.Switch.isol13.setBoolValue(0);
		me.Switch.midTemp.setValue(0.5);
		me.Switch.pack1.setBoolValue(1);
		me.Switch.pack2.setBoolValue(1);
		me.Switch.pack3.setBoolValue(1);
		me.Switch.trimAir.setBoolValue(1);
		me.system.setBoolValue(1);
		manualPneuLightt.stop();
		me.Light.manualFlash.setValue(0);
	},
	resetFail: func() {
		me.Fail.bleedApu.setBoolValue(0);
		me.Fail.bleedExt.setBoolValue(0);
		me.Fail.bleed1.setBoolValue(0);
		me.Fail.bleed2.setBoolValue(0);
		me.Fail.bleed3.setBoolValue(0);
		me.Fail.pack1.setBoolValue(0);
		me.Fail.pack2.setBoolValue(0);
		me.Fail.pack3.setBoolValue(0);
	},
	systemMode: func() {
		if (me.system.getBoolValue()) {
			me.system.setBoolValue(0);
			manualPneuLightt.stop();
			me.Light.manualFlash.setValue(0);
		} else {
			me.system.setBoolValue(1);
			manualPneuLightt.stop();
			me.Light.manualFlash.setValue(0);
		}
	},
	manualLight: func() {
		me.Light.manualFlashTemp = me.Light.manualFlash.getValue();
		if (me.Light.manualFlashTemp >= 5 or !me.system.getBoolValue()) {
			manualPneuLightt.stop();
			me.Light.manualFlash.setValue(0);
		} else {
			me.Light.manualFlash.setValue(me.Light.manualFlashTemp + 1);
		}
	},
};

var manualPneuLightt = maketimer(0.4, PNEU, PNEU.manualLight);
