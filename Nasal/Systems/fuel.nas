# McDonnell Douglas MD-11 Fuel
# Copyright (c) 2026 Josh Davidson (Octal450)

var FUEL = {
	PumpCmd: {
		aftPump1: props.globals.getNode("/systems/fuel/aft-pump-1-cmd"),
		aftPump2L: props.globals.getNode("/systems/fuel/aft-pump-2l-cmd"),
		aftPump2R: props.globals.getNode("/systems/fuel/aft-pump-2r-cmd"),
		aftPump3: props.globals.getNode("/systems/fuel/aft-pump-3-cmd"),
		altPump: props.globals.getNode("/systems/fuel/alt-pump-cmd"),
		apuStartPump: props.globals.getNode("/systems/fuel/apu-start-pump-cmd"),
		fwdPump1: props.globals.getNode("/systems/fuel/fwd-pump-1-cmd"),
		fwdPump2: props.globals.getNode("/systems/fuel/fwd-pump-2-cmd"),
		fwdPump3: props.globals.getNode("/systems/fuel/fwd-pump-3-cmd"),
		trans1: props.globals.getNode("/systems/fuel/trans-1-cmd"),
		trans2: props.globals.getNode("/systems/fuel/trans-2-cmd"),
		trans3: props.globals.getNode("/systems/fuel/trans-3-cmd"),
		transAuxLowerL: props.globals.getNode("/systems/fuel/trans-aux-lower-l-cmd"),
		transAuxLowerR: props.globals.getNode("/systems/fuel/trans-aux-lower-r-cmd"),
		transAuxUpperL: props.globals.getNode("/systems/fuel/trans-aux-upper-l-cmd"),
		transAuxUpperR: props.globals.getNode("/systems/fuel/trans-aux-upper-r-cmd"),
		transTailL: props.globals.getNode("/systems/fuel/trans-tail-l-cmd"),
		transTailR: props.globals.getNode("/systems/fuel/trans-tail-r-cmd"),
	},
	PumpPsi: {
		aftPump1: props.globals.getNode("/systems/fuel/aft-pump-1-psi"),
		aftPump2L: props.globals.getNode("/systems/fuel/aft-pump-2l-psi"),
		aftPump2R: props.globals.getNode("/systems/fuel/aft-pump-2r-psi"),
		aftPump3: props.globals.getNode("/systems/fuel/aft-pump-3-psi"),
		altPump: props.globals.getNode("/systems/fuel/alt-pump-psi"),
		apuStartPump: props.globals.getNode("/systems/fuel/apu-start-pump-psi"),
		fwdPump1: props.globals.getNode("/systems/fuel/fwd-pump-1-psi"),
		fwdPump2: props.globals.getNode("/systems/fuel/fwd-pump-2-psi"),
		fwdPump3: props.globals.getNode("/systems/fuel/fwd-pump-3-psi"),
		trans1: props.globals.getNode("/systems/fuel/trans-1-psi"),
		trans2: props.globals.getNode("/systems/fuel/trans-2-psi"),
		trans3: props.globals.getNode("/systems/fuel/trans-3-psi"),
		transAuxLowerL: props.globals.getNode("/systems/fuel/trans-aux-lower-l-psi"),
		transAuxLowerR: props.globals.getNode("/systems/fuel/trans-aux-lower-r-psi"),
		transAuxUpperL: props.globals.getNode("/systems/fuel/trans-aux-upper-l-psi"),
		transAuxUpperR: props.globals.getNode("/systems/fuel/trans-aux-upper-r-psi"),
		transTailL: props.globals.getNode("/systems/fuel/trans-tail-l-psi"),
		transTailR: props.globals.getNode("/systems/fuel/trans-tail-r-psi"),
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
		aftPump1: props.globals.getNode("/systems/failures/fuel/aft-pump-1"),
		aftPump2L: props.globals.getNode("/systems/failures/fuel/aft-pump-2l"),
		aftPump2R: props.globals.getNode("/systems/failures/fuel/aft-pump-2r"),
		aftPump3: props.globals.getNode("/systems/failures/fuel/aft-pump-3"),
		altPump: props.globals.getNode("/systems/failures/fuel/alt-pump"),
		apuStartPump: props.globals.getNode("/systems/failures/fuel/apu-start-pump"),
		fwdPump1: props.globals.getNode("/systems/failures/fuel/fwd-pump-1"),
		fwdPump2: props.globals.getNode("/systems/failures/fuel/fwd-pump-2"),
		fwdPump3: props.globals.getNode("/systems/failures/fuel/fwd-pump-3"),
		system: props.globals.getNode("/systems/failures/fuel/system"),
		trans1: props.globals.getNode("/systems/failures/fuel/trans-1"),
		trans2: props.globals.getNode("/systems/failures/fuel/trans-2"),
		trans3: props.globals.getNode("/systems/failures/fuel/trans-3"),
		transAuxLowerL: props.globals.getNode("/systems/failures/fuel/trans-aux-lower-l"),
		transAuxLowerR: props.globals.getNode("/systems/failures/fuel/trans-aux-lower-r"),
		transAuxUpperL: props.globals.getNode("/systems/failures/fuel/trans-aux-upper-l"),
		transAuxUpperR: props.globals.getNode("/systems/failures/fuel/trans-aux-upper-r"),
		transTailL: props.globals.getNode("/systems/failures/fuel/trans-tail-l"),
		transTailR: props.globals.getNode("/systems/failures/fuel/trans-tail-r"),
	},
	Lights: {
		aftPump1PsiLow: props.globals.getNode("/systems/fuel/lights/aft-pump-1-psi-low"),
		aftPump2LPsiLow: props.globals.getNode("/systems/fuel/lights/aft-pump-2l-psi-low"),
		aftPump2RPsiLow: props.globals.getNode("/systems/fuel/lights/aft-pump-2r-psi-low"),
		aftPump3PsiLow: props.globals.getNode("/systems/fuel/lights/aft-pump-3-psi-low"),
		altPumpPsiLow: props.globals.getNode("/systems/fuel/lights/alt-pump-psi-low"),
		apuStartPumpPsiLow: props.globals.getNode("/systems/fuel/lights/apu-start-pump-psi-low"),
		fillStatus1: props.globals.getNode("/systems/fuel/lights/fill-status-1"),
		fillStatus2: props.globals.getNode("/systems/fuel/lights/fill-status-2"),
		fillStatus3: props.globals.getNode("/systems/fuel/lights/fill-status-3"),
		fillStatusAuxUpper: props.globals.getNode("/systems/fuel/lights/fill-status-aux-upper"),
		fillStatusTail: props.globals.getNode("/systems/fuel/lights/fill-status-tail"),
		fwdPump1PsiLow: props.globals.getNode("/systems/fuel/lights/fwd-pump-1-psi-low"),
		fwdPump2PsiLow: props.globals.getNode("/systems/fuel/lights/fwd-pump-2-psi-low"),
		fwdPump3PsiLow: props.globals.getNode("/systems/fuel/lights/fwd-pump-3-psi-low"),
		manualFlash: props.globals.initNode("/systems/fuel/lights/manual-flash", 0, "INT"),
		manualFlashTemp: 0,
		trans1PsiLow: props.globals.getNode("/systems/fuel/lights/trans-1-psi-low"),
		trans2PsiLow: props.globals.getNode("/systems/fuel/lights/trans-2-psi-low"),
		trans3PsiLow: props.globals.getNode("/systems/fuel/lights/trans-3-psi-low"),
		transAuxLowerLPsiLow: props.globals.getNode("/systems/fuel/lights/trans-aux-lower-l-psi-low"),
		transAuxLowerRPsiLow: props.globals.getNode("/systems/fuel/lights/trans-aux-lower-r-psi-low"),
		transAuxUpperLPsiLow: props.globals.getNode("/systems/fuel/lights/trans-aux-upper-l-psi-low"),
		transAuxUpperRPsiLow: props.globals.getNode("/systems/fuel/lights/trans-aux-upper-r-psi-low"),
		transTailLPsiLow: props.globals.getNode("/systems/fuel/lights/trans-tail-l-psi-low"),
		transTailRPsiLow: props.globals.getNode("/systems/fuel/lights/trans-tail-r-psi-low"),
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
		me.Failures.aftPump1.setBoolValue(0);
		me.Failures.aftPump2L.setBoolValue(0);
		me.Failures.aftPump2R.setBoolValue(0);
		me.Failures.aftPump3.setBoolValue(0);
		me.Failures.altPump.setBoolValue(0);
		me.Failures.apuStartPump.setBoolValue(0);
		me.Failures.fwdPump1.setBoolValue(0);
		me.Failures.fwdPump2.setBoolValue(0);
		me.Failures.fwdPump3.setBoolValue(0);
		me.Failures.system.setBoolValue(0);
		me.Failures.trans1.setBoolValue(0);
		me.Failures.trans2.setBoolValue(0);
		me.Failures.trans3.setBoolValue(0);
		me.Failures.transAuxLowerL.setBoolValue(0);
		me.Failures.transAuxLowerR.setBoolValue(0);
		me.Failures.transAuxUpperL.setBoolValue(0);
		me.Failures.transAuxUpperR.setBoolValue(0);
		me.Failures.transTailL.setBoolValue(0);
		me.Failures.transTailR.setBoolValue(0);
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
