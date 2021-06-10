# McDonnell Douglas MD-11 Fuel System
# Copyright (c) 2021 Josh Davidson (Octal450)

var FUEL = {
	Fail: {
		pumpsAuxL: props.globals.getNode("/systems/failures/fuel/pumps-aux-l"),
		pumpsAuxR: props.globals.getNode("/systems/failures/fuel/pumps-aux-r"),
		pumpsTail: props.globals.getNode("/systems/failures/fuel/pumps-tail"),
		pumps1: props.globals.getNode("/systems/failures/fuel/pumps-1"),
		pumps2: props.globals.getNode("/systems/failures/fuel/pumps-2"),
		pumps3: props.globals.getNode("/systems/failures/fuel/pumps-3"),
		system: props.globals.getNode("/systems/failures/fuel/system"),
	},
	Light: {
		manualFlash: props.globals.initNode("/controls/fuel/lights/manual-flash", 0, "INT"),
		manualFlashTemp: 0,
	},
	Switch: {
		altPump: props.globals.getNode("/controls/fuel/switches/alt-pump"),
		fill1: props.globals.getNode("/controls/fuel/switches/fill-1"),
		fill2: props.globals.getNode("/controls/fuel/switches/fill-2"),
		fill3: props.globals.getNode("/controls/fuel/switches/fill-3"),
		pumps1: props.globals.getNode("/controls/fuel/switches/pumps-1"),
		pumps2: props.globals.getNode("/controls/fuel/switches/pumps-2"),
		pumps3: props.globals.getNode("/controls/fuel/switches/pumps-3"),
		system: props.globals.getNode("/controls/fuel/switches/system"),
		transAuxL: props.globals.getNode("/controls/fuel/switches/trans-aux-l"),
		transAuxR: props.globals.getNode("/controls/fuel/switches/trans-aux-r"),
		transTail: props.globals.getNode("/controls/fuel/switches/trans-tail"),
		trans1: props.globals.getNode("/controls/fuel/switches/trans-1"),
		trans2: props.globals.getNode("/controls/fuel/switches/trans-2"),
		trans3: props.globals.getNode("/controls/fuel/switches/trans-3"),
		xFeed1: props.globals.getNode("/controls/fuel/switches/x-feed-1"),
		xFeed2: props.globals.getNode("/controls/fuel/switches/x-feed-2"),
		xFeed3: props.globals.getNode("/controls/fuel/switches/x-feed-3"),
	},
	system: props.globals.getNode("/systems/fuel/system"),
	init: func() {
		me.resetFailures();
		me.Switch.altPump.setBoolValue(0);
		me.Switch.fill1.setBoolValue(0);
		me.Switch.fill2.setBoolValue(0);
		me.Switch.fill3.setBoolValue(0);
		me.Switch.pumps1.setBoolValue(0);
		me.Switch.pumps2.setBoolValue(0);
		me.Switch.pumps3.setBoolValue(0);
		me.Switch.system.setBoolValue(1);
		me.Switch.transAuxL.setBoolValue(0);
		me.Switch.transAuxR.setBoolValue(0);
		me.Switch.transTail.setBoolValue(0);
		me.Switch.trans1.setBoolValue(0);
		me.Switch.trans2.setBoolValue(0);
		me.Switch.trans3.setBoolValue(0);
		me.Switch.xFeed1.setBoolValue(0);
		me.Switch.xFeed2.setBoolValue(0);
		me.Switch.xFeed3.setBoolValue(0);
		manualFuelLightt.stop();
		me.Light.manualFlash.setValue(0);
	},
	resetFailures: func() {
		me.Fail.pumpsAuxL.setBoolValue(0);
		me.Fail.pumpsAuxR.setBoolValue(0);
		me.Fail.pumpsTail.setBoolValue(0);
		me.Fail.pumps1.setBoolValue(0);
		me.Fail.pumps2.setBoolValue(0);
		me.Fail.pumps3.setBoolValue(0);
		me.Fail.system.setBoolValue(0);
	},
	systemMode: func() {
		if (me.Switch.system.getBoolValue()) {
			me.Switch.system.setBoolValue(0);
			manualFuelLightt.stop();
			me.Light.manualFlash.setValue(0);
			# Sets this config when put in manual
			me.Switch.altPump.setBoolValue(0);
			me.Switch.pumps1.setBoolValue(1);
			me.Switch.pumps2.setBoolValue(1);
			me.Switch.pumps3.setBoolValue(1);
			me.Switch.transAuxL.setBoolValue(1);
			me.Switch.transAuxR.setBoolValue(1);
			me.Switch.transTail.setBoolValue(1);
			me.Switch.trans1.setBoolValue(0);
			me.Switch.trans3.setBoolValue(0);
			me.Switch.xFeed1.setBoolValue(0);
			me.Switch.xFeed2.setBoolValue(0);
			me.Switch.xFeed3.setBoolValue(0);
		} else {
			me.Switch.system.setBoolValue(1);
			manualFuelLightt.stop();
			me.Light.manualFlash.setValue(0);
		}
	},
	manualLight: func() {
		me.Light.manualFlashTemp = me.Light.manualFlash.getValue();
		if (me.Light.manualFlashTemp >= 5 or !me.Switch.system.getBoolValue()) {
			manualFuelLightt.stop();
			me.Light.manualFlash.setValue(0);
		} else {
			me.Light.manualFlash.setValue(me.Light.manualFlashTemp + 1);
		}
	},
};

var manualFuelLightt = maketimer(0.4, FUEL, FUEL.manualLight);
