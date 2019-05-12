# McDonnell Douglas MD-11 Hydraulic System
# Copyright (c) 2019 Joshua Davidson (Octal450)

var HYD = {
	Fail: {
		auxPump1: props.globals.getNode("/systems/failures/hydraulics/aux-pump-1"),
		auxPump2: props.globals.getNode("/systems/failures/hydraulics/aux-pump-2"),
		catastrophicAft: props.globals.getNode("/systems/failures/hydraulics/catastrophic-aft"),
		lPump1: props.globals.getNode("/systems/failures/hydraulics/l-pump-1"),
		lPump2: props.globals.getNode("/systems/failures/hydraulics/l-pump-2"),
		lPump3: props.globals.getNode("/systems/failures/hydraulics/l-pump-3"),
		nrmp21: props.globals.getNode("/systems/failures/hydraulics/nrmp-2-1"),
		nrmp32: props.globals.getNode("/systems/failures/hydraulics/nrmp-3-2"),
		rPump1: props.globals.getNode("/systems/failures/hydraulics/r-pump-1"),
		rPump2: props.globals.getNode("/systems/failures/hydraulics/r-pump-2"),
		rPump3: props.globals.getNode("/systems/failures/hydraulics/r-pump-3"),
		rmp13: props.globals.getNode("/systems/failures/hydraulics/rmp-1-3"),
		rmp23: props.globals.getNode("/systems/failures/hydraulics/rmp-2-3"),
		sys1Leak: props.globals.getNode("/systems/failures/hydraulics/sys-1-leak"),
		sys2Leak: props.globals.getNode("/systems/failures/hydraulics/sys-2-leak"),
		sys3Leak: props.globals.getNode("/systems/failures/hydraulics/sys-3-leak"),
	},
	Light: {
		manualFlash: props.globals.initNode("/systems/hydraulics/light/manual-flash", 0, "INT"),
		manualFlashTemp: 0,
	},
	Psi: {
		auxPump1: props.globals.getNode("/systems/hydraulics/aux-pump-1-psi"),
		auxPump2: props.globals.getNode("/systems/hydraulics/aux-pump-2-psi"),
		lPump1: props.globals.getNode("/systems/hydraulics/l-eng-1-pump-psi"),
		lPump2: props.globals.getNode("/systems/hydraulics/l-eng-2-pump-psi"),
		lPump3: props.globals.getNode("/systems/hydraulics/l-eng-3-pump-psi"),
		rPump1: props.globals.getNode("/systems/hydraulics/r-eng-1-pump-psi"),
		rPump2: props.globals.getNode("/systems/hydraulics/r-eng-2-pump-psi"),
		rPump3: props.globals.getNode("/systems/hydraulics/r-eng-3-pump-psi"),
		sys1: props.globals.getNode("/systems/hydraulics/sys-1-psi"),
		sys2: props.globals.getNode("/systems/hydraulics/sys-2-psi"),
		sys3: props.globals.getNode("/systems/hydraulics/sys-3-psi"),
		sys3Aft: props.globals.getNode("/systems/hydraulics/sys-3-aft-psi"),
	},
	Qty: {
		sys1: props.globals.getNode("/systems/hydraulics/sys-1-qty"),
		sys1Input: props.globals.getNode("/systems/hydraulics/sys-1-qty-input"),
		sys2: props.globals.getNode("/systems/hydraulics/sys-2-qty"),
		sys2Input: props.globals.getNode("/systems/hydraulics/sys-2-qty-input"),
		sys3: props.globals.getNode("/systems/hydraulics/sys-3-qty"),
		sys3Input: props.globals.getNode("/systems/hydraulics/sys-3-qty-input"),
		sys3Aft: props.globals.getNode("/systems/hydraulics/sys-3-aft-qty"),
	},
	Switch: {
		auxPump1: props.globals.getNode("/controls/hydraulics/switches/aux-pump-1"),
		auxPump2: props.globals.getNode("/controls/hydraulics/switches/aux-pump-2"),
		lPump1: props.globals.getNode("/controls/hydraulics/switches/l-pump-1"),
		lPump2: props.globals.getNode("/controls/hydraulics/switches/l-pump-2"),
		lPump3: props.globals.getNode("/controls/hydraulics/switches/l-pump-3"),
		pressTest: props.globals.getNode("/controls/hydraulics/switches/press-test"),
		rPump1: props.globals.getNode("/controls/hydraulics/switches/r-pump-1"),
		rPump2: props.globals.getNode("/controls/hydraulics/switches/r-pump-2"),
		rPump3: props.globals.getNode("/controls/hydraulics/switches/r-pump-3"),
		rmp13: props.globals.getNode("/controls/hydraulics/switches/rmp-1-3"),
		rmp23: props.globals.getNode("/controls/hydraulics/switches/rmp-2-3"),
	},
	system: props.globals.getNode("/systems/hydraulics/system"),
	init: func() {
		me.resetFail();
		me.Qty.sys1Input.setValue(math.round((rand() * 4) + 8 , 0.1)); # Random between 8 and 12
		me.Qty.sys2Input.setValue(math.round((rand() * 4) + 8 , 0.1)); # Random between 8 and 12
		me.Qty.sys3Input.setValue(math.round((rand() * 4) + 8 , 0.1)); # Random between 8 and 12
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
		me.Fail.catastrophicAft.setBoolValue(0);
		me.Fail.lPump1.setBoolValue(0);
		me.Fail.lPump2.setBoolValue(0);
		me.Fail.lPump3.setBoolValue(0);
		me.Fail.nrmp21.setBoolValue(0);
		me.Fail.nrmp32.setBoolValue(0);
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
			# Apparently this happens when turning to MANUAL
			me.Switch.rmp13.setBoolValue(1);
			me.Switch.rmp23.setBoolValue(1);
		} else {
			me.system.setBoolValue(1);
			manualHydLightt.stop();
			me.Light.manualFlash.setValue(0);
			# Apparently this happens when turning to AUTO
			me.Switch.auxPump1.setBoolValue(0);
			me.Switch.auxPump2.setBoolValue(0);
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
