# McDonnell Douglas MD-11 Hydraulics
# Copyright (c) 2025 Josh Davidson (Octal450)

var HYDRAULICS = {
	Psi: {
		auxPump1: props.globals.getNode("/systems/hydraulics/aux-pump-1-psi"),
		auxPump2: props.globals.getNode("/systems/hydraulics/aux-pump-2-psi"),
		lPump1: props.globals.getNode("/systems/hydraulics/l-eng-1-pump-psi"),
		lPump2: props.globals.getNode("/systems/hydraulics/l-eng-2-pump-psi"),
		lPump3: props.globals.getNode("/systems/hydraulics/l-eng-3-pump-psi"),
		rmp1To3: props.globals.getNode("/systems/hydraulics/rmp/sys-1-to-sys-3"),
		rmp2To3: props.globals.getNode("/systems/hydraulics/rmp/sys-2-to-sys-3"),
		rmp3To1: props.globals.getNode("/systems/hydraulics/rmp/sys-3-to-sys-1"),
		rmp3To2: props.globals.getNode("/systems/hydraulics/rmp/sys-3-to-sys-2"),
		rmp1Thru3To2: props.globals.getNode("/systems/hydraulics/rmp/sys-1-thru-sys-3-to-sys-2"),
		rmp2Thru3To1: props.globals.getNode("/systems/hydraulics/rmp/sys-2-thru-sys-3-to-sys-1"),
		rPump1: props.globals.getNode("/systems/hydraulics/r-eng-1-pump-psi"),
		rPump2: props.globals.getNode("/systems/hydraulics/r-eng-2-pump-psi"),
		rPump3: props.globals.getNode("/systems/hydraulics/r-eng-3-pump-psi"),
		sys1: props.globals.getNode("/systems/hydraulics/sys-1-psi"),
		sys2: props.globals.getNode("/systems/hydraulics/sys-2-psi"),
		sys3: props.globals.getNode("/systems/hydraulics/sys-3-psi"),
		sys3Aft: props.globals.getNode("/systems/hydraulics/sys-3-aft-psi"),
	},
	PumpCmd: {
		auxPump1: props.globals.getNode("/systems/hydraulics/aux-pump-1-cmd"),
		auxPump2: props.globals.getNode("/systems/hydraulics/aux-pump-2-cmd"),
		lPump1: props.globals.getNode("/systems/hydraulics/l-eng-1-pump-cmd"),
		lPump2: props.globals.getNode("/systems/hydraulics/l-eng-2-pump-cmd"),
		lPump3: props.globals.getNode("/systems/hydraulics/l-eng-3-pump-cmd"),
		rPump1: props.globals.getNode("/systems/hydraulics/r-eng-1-pump-cmd"),
		rPump2: props.globals.getNode("/systems/hydraulics/r-eng-2-pump-cmd"),
		rPump3: props.globals.getNode("/systems/hydraulics/r-eng-3-pump-cmd"),
		rmp13: props.globals.getNode("/systems/hydraulics/rmp/rmp-1-3-cmd"),
		rmp23: props.globals.getNode("/systems/hydraulics/rmp/rmp-2-3-cmd"),
	},
	Qty: {
		sys1: props.globals.getNode("/systems/hydraulics/sys-1-qty"),
		sys1Input: props.globals.getNode("/systems/hydraulics/sys-1-qty-input"),
		sys1Preflight: props.globals.getNode("/systems/hydraulics/sys-1-preflight-qty"),
		sys2: props.globals.getNode("/systems/hydraulics/sys-2-qty"),
		sys2Input: props.globals.getNode("/systems/hydraulics/sys-2-qty-input"),
		sys2Preflight: props.globals.getNode("/systems/hydraulics/sys-2-preflight-qty"),
		sys3: props.globals.getNode("/systems/hydraulics/sys-3-qty"),
		sys3Input: props.globals.getNode("/systems/hydraulics/sys-3-qty-input"),
		sys3Aft: props.globals.getNode("/systems/hydraulics/sys-3-aft-qty"),
		sys3Preflight: props.globals.getNode("/systems/hydraulics/sys-3-preflight-qty"),
	},
	Valve: {
		rmp13: props.globals.getNode("/systems/hydraulics/rmp/rmp-1-3-valve"),
		rmp23: props.globals.getNode("/systems/hydraulics/rmp/rmp-2-3-valve"),
	},
	system: props.globals.getNode("/systems/hydraulics/system"),
	Controls: {
		auxPump1: props.globals.getNode("/controls/hydraulics/aux-pump-1"),
		auxPump2: props.globals.getNode("/controls/hydraulics/aux-pump-2"),
		gearGravityExt: props.globals.getNode("/controls/hydraulics/gear-gravity-ext"),
		lPump1: props.globals.getNode("/controls/hydraulics/l-pump-1"),
		lPump2: props.globals.getNode("/controls/hydraulics/l-pump-2"),
		lPump3: props.globals.getNode("/controls/hydraulics/l-pump-3"),
		pressTest: props.globals.getNode("/controls/hydraulics/press-test"),
		rPump1: props.globals.getNode("/controls/hydraulics/r-pump-1"),
		rPump2: props.globals.getNode("/controls/hydraulics/r-pump-2"),
		rPump3: props.globals.getNode("/controls/hydraulics/r-pump-3"),
		rmp13: props.globals.getNode("/controls/hydraulics/rmp-1-3"),
		rmp23: props.globals.getNode("/controls/hydraulics/rmp-2-3"),
		system: props.globals.getNode("/controls/hydraulics/system"),
	},
	Failures: {
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
		system: props.globals.getNode("/systems/failures/hydraulics/system"),
	},
	Lights: {
		lPump1Fault: props.globals.getNode("/systems/hydraulics/lights/l-pump-1-fault"),
		lPump2Fault: props.globals.getNode("/systems/hydraulics/lights/l-pump-2-fault"),
		lPump3Fault: props.globals.getNode("/systems/hydraulics/lights/l-pump-3-fault"),
		rPump1Fault: props.globals.getNode("/systems/hydraulics/lights/r-pump-1-fault"),
		rPump2Fault: props.globals.getNode("/systems/hydraulics/lights/r-pump-2-fault"),
		rPump3Fault: props.globals.getNode("/systems/hydraulics/lights/r-pump-3-fault"),
		manualFlash: props.globals.initNode("/systems/hydraulics/lights/manual-flash", 0, "INT"),
		manualFlashTemp: 0,
		rmp13Disag: props.globals.initNode("/systems/hydraulics/lights/rmp-1-3-disag"),
		rmp23Disag: props.globals.initNode("/systems/hydraulics/lights/rmp-2-3-disag"),
	},
	init: func() {
		me.resetFailures();
		me.Qty.sys1Input.setValue(math.round((rand() * 4) + 6 , 0.1)); # Random between 6 and 10
		me.Qty.sys2Input.setValue(math.round((rand() * 4) + 6 , 0.1)); # Random between 6 and 10
		me.Qty.sys3Input.setValue(math.round((rand() * 4) + 6 , 0.1)); # Random between 6 and 10
		me.Controls.auxPump1.setBoolValue(0);
		me.Controls.auxPump2.setBoolValue(0);
		me.Controls.gearGravityExt.setBoolValue(0);
		me.Controls.lPump1.setBoolValue(1);
		me.Controls.lPump2.setBoolValue(1);
		me.Controls.lPump3.setBoolValue(1);
		me.Controls.pressTest.setBoolValue(0);
		me.Controls.rPump1.setBoolValue(1);
		me.Controls.rPump2.setBoolValue(1);
		me.Controls.rPump3.setBoolValue(1);
		me.Controls.rmp13.setBoolValue(0);
		me.Controls.rmp23.setBoolValue(0);
		me.Controls.system.setBoolValue(1);
		manualHydLightt.stop();
		me.Lights.manualFlash.setValue(0);
	},
	resetFailures: func() {
		me.Failures.auxPump1.setBoolValue(0);
		me.Failures.auxPump2.setBoolValue(0);
		me.Failures.catastrophicAft.setBoolValue(0);
		me.Failures.lPump1.setBoolValue(0);
		me.Failures.lPump2.setBoolValue(0);
		me.Failures.lPump3.setBoolValue(0);
		me.Failures.nrmp21.setBoolValue(0);
		me.Failures.nrmp32.setBoolValue(0);
		me.Failures.rPump1.setBoolValue(0);
		me.Failures.rPump2.setBoolValue(0);
		me.Failures.rPump3.setBoolValue(0);
		me.Failures.rmp13.setBoolValue(0);
		me.Failures.rmp23.setBoolValue(0);
		me.Failures.sys1Leak.setBoolValue(0);
		me.Failures.sys2Leak.setBoolValue(0);
		me.Failures.sys3Leak.setBoolValue(0);
		me.Failures.system.setBoolValue(0);
	},
	systemMode: func() {
		if (me.Controls.system.getBoolValue()) {
			me.Controls.system.setBoolValue(0);
			manualHydLightt.stop();
			me.Lights.manualFlash.setValue(0);
			# Apparently this happens when turning to MANUAL
			me.Controls.rmp13.setBoolValue(1);
			me.Controls.rmp23.setBoolValue(1);
		} else {
			me.Controls.system.setBoolValue(1);
			manualHydLightt.stop();
			me.Lights.manualFlash.setValue(0);
			# Apparently this happens when turning to AUTO
			me.Controls.auxPump1.setBoolValue(0);
			me.Controls.auxPump2.setBoolValue(0);
		}
	},
	manualLight: func() {
		me.Lights.manualFlashTemp = me.Lights.manualFlash.getValue();
		if (me.Lights.manualFlashTemp >= 5 or !me.Controls.system.getBoolValue()) {
			manualHydLightt.stop();
			me.Lights.manualFlash.setValue(0);
		} else {
			me.Lights.manualFlash.setValue(me.Lights.manualFlashTemp + 1);
		}
	},
};

var manualHydLightt = maketimer(0.4, HYDRAULICS, HYDRAULICS.manualLight);
