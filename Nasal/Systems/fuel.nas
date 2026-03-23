# McDonnell Douglas MD-11 Fuel
# Copyright (c) 2026 Josh Davidson (Octal450)

var FUEL = {
	PumpCmd: {
		aftPump1: props.globals.getNode("/systems/fuel/aft-pump-1-cmd"),
		aftPump2L: props.globals.getNode("/systems/fuel/aft-pump-2l-cmd"),
		aftPump2R: props.globals.getNode("/systems/fuel/aft-pump-2r-cmd"),
		aftPump3: props.globals.getNode("/systems/fuel/aft-pump-3-cmd"),
		apuStartPump: props.globals.getNode("/systems/fuel/apu-start-pump-cmd"),
		fwdPump1: props.globals.getNode("/systems/fuel/fwd-pump-1-cmd"),
		fwdPump2: props.globals.getNode("/systems/fuel/fwd-pump-2-cmd"),
		fwdPump3: props.globals.getNode("/systems/fuel/fwd-pump-3-cmd"),
		trans1: props.globals.getNode("/systems/fuel/trans-1-cmd"),
		trans2: props.globals.getNode("/systems/fuel/trans-2-cmd"),
		trans3: props.globals.getNode("/systems/fuel/trans-3-cmd"),
	},
	tankFuelManagement: props.globals.getNode("/systems/fuel/tail-fuel-management"),
	system: props.globals.getNode("/systems/fuel/system"),
	Controls: {
		altPump: props.globals.getNode("/controls/fuel/alt-pump"),
		fill1: props.globals.getNode("/controls/fuel/fill-1"),
		fill2: props.globals.getNode("/controls/fuel/fill-2"),
		fill3: props.globals.getNode("/controls/fuel/fill-3"),
		pumps1: props.globals.getNode("/controls/fuel/pumps-1"),
		pumps2: props.globals.getNode("/controls/fuel/pumps-2"),
		pumps3: props.globals.getNode("/controls/fuel/pumps-3"),
		system: props.globals.getNode("/controls/fuel/system"),
		transAuxL: props.globals.getNode("/controls/fuel/trans-aux-l"),
		transAuxR: props.globals.getNode("/controls/fuel/trans-aux-r"),
		transTail: props.globals.getNode("/controls/fuel/trans-tail"),
		trans1: props.globals.getNode("/controls/fuel/trans-1"),
		trans2: props.globals.getNode("/controls/fuel/trans-2"),
		trans3: props.globals.getNode("/controls/fuel/trans-3"),
		xFeed1: props.globals.getNode("/controls/fuel/x-feed-1"),
		xFeed2: props.globals.getNode("/controls/fuel/x-feed-2"),
		xFeed3: props.globals.getNode("/controls/fuel/x-feed-3"),
	},
	Failures: {
		pumpsAuxL: props.globals.getNode("/systems/failures/fuel/pumps-aux-l"),
		pumpsAuxR: props.globals.getNode("/systems/failures/fuel/pumps-aux-r"),
		pumpsTail: props.globals.getNode("/systems/failures/fuel/pumps-tail"),
		pumps1: props.globals.getNode("/systems/failures/fuel/pumps-1"),
		pumps2: props.globals.getNode("/systems/failures/fuel/pumps-2"),
		pumps3: props.globals.getNode("/systems/failures/fuel/pumps-3"),
		system: props.globals.getNode("/systems/failures/fuel/system"),
	},
	Lights: {
		aftPump1PsiLow: props.globals.getNode("/systems/fuel/lights/aft-pump-1-psi-low"),
		aftPump2LPsiLow: props.globals.getNode("/systems/fuel/lights/aft-pump-2l-psi-low"),
		aftPump2RPsiLow: props.globals.getNode("/systems/fuel/lights/aft-pump-2r-psi-low"),
		aftPump3PsiLow: props.globals.getNode("/systems/fuel/lights/aft-pump-3-psi-low"),
		fillStatus1: props.globals.getNode("/systems/fuel/lights/fill-status-1"),
		fillStatus2: props.globals.getNode("/systems/fuel/lights/fill-status-2"),
		fillStatus3: props.globals.getNode("/systems/fuel/lights/fill-status-3"),
		fwdPump1PsiLow: props.globals.getNode("/systems/fuel/lights/fwd-pump-1-psi-low"),
		fwdPump2PsiLow: props.globals.getNode("/systems/fuel/lights/fwd-pump-2-psi-low"),
		fwdPump3PsiLow: props.globals.getNode("/systems/fuel/lights/fwd-pump-3-psi-low"),
		manualFlash: props.globals.initNode("/systems/fuel/lights/manual-flash", 0, "INT"),
		manualFlashTemp: 0,
		trans1PsiLow: props.globals.getNode("/systems/fuel/lights/trans-1-psi-low"),
		trans2PsiLow: props.globals.getNode("/systems/fuel/lights/trans-2-psi-low"),
		trans3PsiLow: props.globals.getNode("/systems/fuel/lights/trans-3-psi-low"),
		xFeed1Disag: props.globals.getNode("/systems/fuel/lights/x-feed-1-disag"),
		xFeed2Disag: props.globals.getNode("/systems/fuel/lights/x-feed-2-disag"),
		xFeed3Disag: props.globals.getNode("/systems/fuel/lights/x-feed-3-disag"),
	},
	init: func() {
		me.resetFailures();
		me.Controls.altPump.setBoolValue(0);
		me.Controls.fill1.setBoolValue(0);
		me.Controls.fill2.setBoolValue(0);
		me.Controls.fill3.setBoolValue(0);
		me.Controls.pumps1.setBoolValue(0);
		me.Controls.pumps2.setBoolValue(0);
		me.Controls.pumps3.setBoolValue(0);
		me.Controls.system.setBoolValue(1);
		me.Controls.transAuxL.setBoolValue(0);
		me.Controls.transAuxR.setBoolValue(0);
		me.Controls.transTail.setBoolValue(0);
		me.Controls.trans1.setBoolValue(0);
		me.Controls.trans2.setBoolValue(0);
		me.Controls.trans3.setBoolValue(0);
		me.Controls.xFeed1.setBoolValue(0);
		me.Controls.xFeed2.setBoolValue(0);
		me.Controls.xFeed3.setBoolValue(0);
		manualFuelLightt.stop();
		me.Lights.manualFlash.setValue(0);
	},
	resetFailures: func() {
		me.Failures.pumpsAuxL.setBoolValue(0);
		me.Failures.pumpsAuxR.setBoolValue(0);
		me.Failures.pumpsTail.setBoolValue(0);
		me.Failures.pumps1.setBoolValue(0);
		me.Failures.pumps2.setBoolValue(0);
		me.Failures.pumps3.setBoolValue(0);
		me.Failures.system.setBoolValue(0);
	},
	systemMode: func() {
		if (me.Controls.system.getBoolValue()) {
			me.Controls.system.setBoolValue(0);
			manualFuelLightt.stop();
			me.Lights.manualFlash.setValue(0);
			# Sets this config when put in manual
			me.Controls.altPump.setBoolValue(0);
			me.Controls.pumps1.setBoolValue(1);
			me.Controls.pumps2.setBoolValue(1);
			me.Controls.pumps3.setBoolValue(1);
			me.Controls.transAuxL.setBoolValue(1);
			me.Controls.transAuxR.setBoolValue(1);
			me.Controls.transTail.setBoolValue(1);
			me.Controls.trans1.setBoolValue(0);
			me.Controls.trans3.setBoolValue(0);
			me.Controls.xFeed1.setBoolValue(0);
			me.Controls.xFeed2.setBoolValue(0);
			me.Controls.xFeed3.setBoolValue(0);
		} else {
			me.Controls.system.setBoolValue(1);
			manualFuelLightt.stop();
			me.Lights.manualFlash.setValue(0);
		}
	},
	manualLight: func() {
		me.Lights.manualFlashTemp = me.Lights.manualFlash.getValue();
		if (me.Lights.manualFlashTemp >= 5 or !me.Controls.system.getBoolValue()) {
			manualFuelLightt.stop();
			me.Lights.manualFlash.setValue(0);
		} else {
			me.Lights.manualFlash.setValue(me.Lights.manualFlashTemp + 1);
		}
	},
};

var manualFuelLightt = maketimer(0.4, FUEL, FUEL.manualLight);
