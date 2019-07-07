# McDonnell Douglas MD-11 Pneumatic System
# Copyright (c) 2019 Joshua Davidson (Octal450)

var FUEL = {
	Fail: {
		pumpsAuxL: props.globals.getNode("/systems/failures/fuel/pumps-aux-l"),
		pumpsAuxR: props.globals.getNode("/systems/failures/fuel/pumps-aux-r"),
		pumps1: props.globals.getNode("/systems/failures/fuel/pumps-1"),
		pumps2: props.globals.getNode("/systems/failures/fuel/pumps-2"),
		pumps3: props.globals.getNode("/systems/failures/fuel/pumps-3"),
	},
	Light: {
		manualFlash: props.globals.initNode("/systems/fuel/light/manual-flash", 0, "INT"),
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
		transAuxL: props.globals.getNode("/controls/fuel/switches/trans-aux-l"),
		transAuxR: props.globals.getNode("/controls/fuel/switches/trans-aux-r"),
		trans1: props.globals.getNode("/controls/fuel/switches/trans-1"),
		trans2: props.globals.getNode("/controls/fuel/switches/trans-2"),
		trans3: props.globals.getNode("/controls/fuel/switches/trans-3"),
		xFeed1: props.globals.getNode("/controls/fuel/switches/x-feed-1"),
		xFeed2: props.globals.getNode("/controls/fuel/switches/x-feed-2"),
		xFeed3: props.globals.getNode("/controls/fuel/switches/x-feed-3"),
	},
	system: props.globals.getNode("/systems/fuel/system"),
	init: func() {
		me.resetFail();
		me.Switch.altPump.setBoolValue(0);
		me.Switch.fill1.setBoolValue(0);
		me.Switch.fill2.setBoolValue(0);
		me.Switch.fill3.setBoolValue(0);
		me.Switch.pumps1.setBoolValue(0);
		me.Switch.pumps2.setBoolValue(0);
		me.Switch.pumps3.setBoolValue(0);
		me.Switch.transAuxL.setBoolValue(0);
		me.Switch.transAuxR.setBoolValue(0);
		me.Switch.trans1.setBoolValue(0);
		me.Switch.trans2.setBoolValue(0);
		me.Switch.trans3.setBoolValue(0);
		me.Switch.xFeed1.setBoolValue(0);
		me.Switch.xFeed2.setBoolValue(0);
		me.Switch.xFeed3.setBoolValue(0);
		me.system.setBoolValue(1);
		manualFuelLightt.stop();
		me.Light.manualFlash.setValue(0);
	},
	resetFail: func() {
		me.Fail.pumpsAuxL.setBoolValue(0);
		me.Fail.pumpsAuxR.setBoolValue(0);
		me.Fail.pumps1.setBoolValue(0);
		me.Fail.pumps2.setBoolValue(0);
		me.Fail.pumps3.setBoolValue(0);
	},
	systemMode: func() {
		if (me.system.getBoolValue()) {
			me.system.setBoolValue(0);
			manualFuelLightt.stop();
			me.Light.manualFlash.setValue(0);
		} else {
			me.system.setBoolValue(1);
			manualFuelLightt.stop();
			me.Light.manualFlash.setValue(0);
		}
	},
	manualLight: func() {
		me.Light.manualFlashTemp = me.Light.manualFlash.getValue();
		if (me.Light.manualFlashTemp >= 5 or !me.system.getBoolValue()) {
			manualFuelLightt.stop();
			me.Light.manualFlash.setValue(0);
		} else {
			me.Light.manualFlash.setValue(me.Light.manualFlashTemp + 1);
		}
	},
};

var manualFuelLightt = maketimer(0.4, FUEL, FUEL.manualLight);
