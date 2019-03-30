# McDonnell Douglas MD-11 Hydraulic System
# Copyright (c) 2019 Joshua Davidson (it0uchpods)

var HYD = {
	Fail: {
		auxPump1: props.globals.getNode("/systems/failures/hydraulic/aux-pump-1"),
		auxPump2: props.globals.getNode("/systems/failures/hydraulic/aux-pump-2"),
		lPump1: props.globals.getNode("/systems/failures/hydraulic/l-pump-1"),
		lPump2: props.globals.getNode("/systems/failures/hydraulic/l-pump-2"),
		lPump3: props.globals.getNode("/systems/failures/hydraulic/l-pump-3"),
		rPump1: props.globals.getNode("/systems/failures/hydraulic/r-pump-1"),
		rPump2: props.globals.getNode("/systems/failures/hydraulic/r-pump-2"),
		rPump3: props.globals.getNode("/systems/failures/hydraulic/r-pump-3"),
		rmp13: props.globals.getNode("/systems/failures/hydraulic/rmp-1-3"),
		rmp23: props.globals.getNode("/systems/failures/hydraulic/rmp-2-3"),
		sys1Leak: props.globals.getNode("/systems/failures/hydraulic/sys-1-leak"),
		sys2Leak: props.globals.getNode("/systems/failures/hydraulic/sys-2-leak"),
		sys3Leak: props.globals.getNode("/systems/failures/hydraulic/sys-3-leak"),
	},
	Light: {
		manualFlash: props.globals.initNode("/systems/hydraulic/light/manual-flash", 0, "INT"),
		manualFlashTemp: 0,
	},
	Misc: {
		gearDown: props.globals.getNode("/controls/gear/gear-down"),
		wow0: props.globals.getNode("/gear/gear[0]/wow"),
		wow1: props.globals.getNode("/gear/gear[1]/wow"),
		wow2: props.globals.getNode("/gear/gear[2]/wow"),
	},
	Switch: {
		auxPump1: props.globals.getNode("/controls/hydraulic/switches/aux-pump-1"),
		auxPump2: props.globals.getNode("/controls/hydraulic/switches/aux-pump-2"),
		lPump1: props.globals.getNode("/controls/hydraulic/switches/l-pump-1"),
		lPump2: props.globals.getNode("/controls/hydraulic/switches/l-pump-2"),
		lPump3: props.globals.getNode("/controls/hydraulic/switches/l-pump-3"),
		pressTest: props.globals.getNode("/controls/hydraulic/switches/press-test"),
		rPump1: props.globals.getNode("/controls/hydraulic/switches/r-pump-1"),
		rPump2: props.globals.getNode("/controls/hydraulic/switches/r-pump-2"),
		rPump3: props.globals.getNode("/controls/hydraulic/switches/r-pump-3"),
		rmp13: props.globals.getNode("/controls/hydraulic/switches/rmp-1-3"),
		rmp23: props.globals.getNode("/controls/hydraulic/switches/rmp-2-3"),
	},
	system: props.globals.getNode("/systems/hydraulic/system"),
	init: func() {
		me.resetFail();
		me.Switch.auxPump1.setBoolValue(0);
		me.Switch.auxPump2.setBoolValue(0);
		me.Switch.lPump1.setBoolValue(1);
		me.Switch.lPump2.setBoolValue(1);
		me.Switch.lPump3.setBoolValue(1);
		me.Switch.pressTest.setBoolValue(0);
		me.Switch.rPump1.setBoolValue(1);
		me.Switch.rPump2.setBoolValue(1);
		me.Switch.rPump3.setBoolValue(1);
		me.Switch.rmp13.setBoolValue(0);
		me.Switch.rmp23.setBoolValue(0);
		me.system.setBoolValue(1);
		manualHydLightt.stop();
		me.Light.manualFlash.setValue(0);
	},
	resetFail: func() {
		me.Fail.auxPump1.setBoolValue(0);
		me.Fail.auxPump2.setBoolValue(0);
		me.Fail.lPump1.setBoolValue(0);
		me.Fail.lPump2.setBoolValue(0);
		me.Fail.lPump3.setBoolValue(0);
		me.Fail.rPump1.setBoolValue(0);
		me.Fail.rPump2.setBoolValue(0);
		me.Fail.rPump3.setBoolValue(0);
		me.Fail.rmp13.setBoolValue(0);
		me.Fail.rmp23.setBoolValue(0);
		me.Fail.sys1Leak.setBoolValue(0);
		me.Fail.sys2Leak.setBoolValue(0);
		me.Fail.sys3Leak.setBoolValue(0);
	},
	systemMode: func() {
		if (me.system.getBoolValue()) {
			me.system.setBoolValue(0);
			manualHydLightt.stop();
			me.Light.manualFlash.setValue(0);
		} else {
			me.system.setBoolValue(1);
			manualHydLightt.stop();
			me.Light.manualFlash.setValue(0);
		}
	},
	manualLight: func() {
		me.Light.manualFlashTemp = me.Light.manualFlash.getValue();
		if (me.Light.manualFlashTemp >= 5 or !me.system.getBoolValue()) {
			manualHydLightt.stop();
			me.Light.manualFlash.setValue(0);
		} else {
			me.Light.manualFlash.setValue(me.Light.manualFlashTemp + 1);
		}
	},
};

var manualHydLightt = maketimer(0.4, HYD, HYD.manualLight);

setlistener("/controls/gear/gear-down", func {
	if (!HYD.Misc.gearDown.getBoolValue() and (HYD.Misc.wow0.getBoolValue() or HYD.Misc.wow1.getBoolValue() or HYD.Misc.wow2.getBoolValue())) {
		HYD.Misc.gearDown.setBoolValue(1);
	}
});
