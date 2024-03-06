# McDonnell Douglas MD-11 Misc Systems
# Copyright (c) 2024 Josh Davidson (Octal450)

# APU
var APU = {
	autoConnect: 0,
	egt: props.globals.getNode("/engines/engine[3]/egt-actual"),
	ff: props.globals.getNode("/engines/engine[3]/ff-actual"),
	n1: props.globals.getNode("/engines/engine[3]/n1-actual"),
	n2: props.globals.getNode("/engines/engine[3]/n2-actual"),
	oilQty: props.globals.getNode("/engines/engine[3]/oil-qty"),
	oilQtyInput: props.globals.getNode("/engines/engine[3]/oil-qty-input"),
	state: props.globals.getNode("/engines/engine[3]/state"),
	Light: {
		avail: props.globals.getNode("/controls/apu/lights/avail-flash"), # Flashes Elec Panel AVAIL light
		on: props.globals.initNode("/controls/apu/lights/on", 0, "BOOL"),
		onTemp: 0,
	},
	Switch: {
		start: props.globals.getNode("/controls/apu/switches/start"),
	},
	init: func() {
		me.oilQtyInput.setValue(math.round((rand() * 2) + 5.5 , 0.1)); # Random between 5.5 and 7.5
		me.Switch.start.setBoolValue(0);
		me.Light.avail.setBoolValue(0);
		me.Light.on.setBoolValue(0);
		me.autoConnect = 0;
	},
	fastStart: func() {
		me.Switch.start.setBoolValue(1);
		me.Light.avail.setValue(1);
		me.Light.on.setValue(1);
		me.autoConnect = 0;
		settimer(func() { # Give the fuel system a moment to provide fuel in the pipe
			pts.Fdm.JSBsim.Propulsion.setRunning.setValue(3);
		}, 1);
	},
	onLight: func() {
		me.Light.onTemp = me.Light.on.getValue();
		if (!me.Switch.start.getBoolValue()) {
			onLightt.stop();
			me.Light.avail.setValue(0);
			me.Light.on.setValue(0);
		} else if (me.Switch.start.getBoolValue() and me.n2.getValue() >= 95) {
			onLightt.stop();
			me.Light.avail.setValue(1);
			me.Light.on.setValue(1);
			if (me.autoConnect) {
				if (ELEC.Epcu.allowApu.getBoolValue()) {
					ELEC.Switch.apuPwr.setBoolValue(1);
				}
			}
		} else {
			if (me.autoConnect) {
				me.Light.avail.setValue(!me.Light.onTemp); 
			} else {
				me.Light.avail.setValue(0);
			}
			me.Light.on.setValue(!me.Light.onTemp);
		}
	},
	startStop: func(t) {
		if (ELEC.Bus.dcBat.getValue() >= 24) {
			if (!me.Switch.start.getBoolValue() and me.n2.getValue() < 2) {
				me.autoConnect = t;
				me.Switch.start.setBoolValue(1);
				onLightt.start();
			} else if (!acconfig.SYSTEM.autoConfigRunning.getBoolValue() and t != 1) { # Do nothing if autoconfig is running, cause it'll break it, or if ELEC panel switch was used
				onLightt.stop();
				me.Switch.start.setBoolValue(0);
				me.Light.avail.setValue(0);
				me.Light.on.setValue(0);
				PNEU.Switch.bleedApu.setBoolValue(0);
				me.autoConnect = 0;
			}
		}
	},
	stop: func() {
		onLightt.stop();
		me.Switch.start.setBoolValue(0);
		me.Light.avail.setValue(0);
		me.Light.on.setValue(0);
		PNEU.Switch.bleedApu.setBoolValue(0);
		me.autoConnect = 0;
	},
};

setlistener("/systems/electrical/epcu/allow-apu-out", func() {
	if (APU.autoConnect) {
		if (ELEC.Epcu.allowApu.getBoolValue() and APU.state.getValue() == 3) {
			ELEC.Switch.apuPwr.setBoolValue(1);
		}
	}
}, 0, 0);

var onLightt = maketimer(0.4, APU, APU.onLight);

# Brakes
var BRAKES = {
	Abs: {
		armed: props.globals.getNode("/gear/abs/armed"),
		disarm: props.globals.getNode("/gear/abs/disarm"),
		mode: props.globals.getNode("/gear/abs/mode"), # -2: RTO MAX, -1: RTO MIN, 0: OFF, 1: MIN, 2: MED, 3: MAX
	},
	Fail: {
		abs: props.globals.getNode("/systems/failures/brakes/abs"),
	},
	Light: {
		absDisarm: props.globals.initNode("/gear/abs/lights/disarm", 0, "BOOL"),
	},
	Switch: {
		abs: props.globals.getNode("/controls/gear/abs/knob"), # -1: RTO, 0: OFF, 1: MIN, 2: MED, 3: MAX
	},
	init: func() {
		me.Switch.abs.setValue(0);
		me.absSetUpdate(0);
	},
	absSetOff: func(t) {
		me.Abs.armed.setBoolValue(0);
		if (t == 1) {
			me.Light.absDisarm.setBoolValue(1);
		} else {
			me.Light.absDisarm.setBoolValue(0);
		}
		me.Abs.mode.setValue(0);
	},
	absSetUpdate: func(n) {
		pts.Fdm.JSBsim.Position.wowTemp = pts.Fdm.JSBsim.Position.wow.getBoolValue();
		if (n == -1) {
			if (pts.Fdm.JSBsim.Position.wowTemp and !me.Abs.disarm.getBoolValue()) { # Disarm is cleared at OFF position
				me.Abs.mode.setValue(-1);
				me.Abs.armed.setBoolValue(1);
			} else {
				me.absSetOff(1);
			}
		} else if (n == 0) {
			me.absSetOff(0);
		} else if (n == 1) {
			if (!pts.Fdm.JSBsim.Position.wowTemp and !me.Abs.disarm.getBoolValue()) { # Disarm is cleared at OFF position
				me.Abs.mode.setValue(1);
				me.Abs.armed.setBoolValue(1);
			} else {
				me.absSetOff(1);
			}
		} else if (n == 2) {
			if (!pts.Fdm.JSBsim.Position.wowTemp and !me.Abs.disarm.getBoolValue()) { # Disarm is cleared at OFF position
				me.Abs.mode.setValue(2);
				me.Abs.armed.setBoolValue(1);
			} else {
				me.absSetOff(1);
			}
		} else if (n == 3) {
			if (!pts.Fdm.JSBsim.Position.wowTemp and !me.Abs.disarm.getBoolValue()) { # Disarm is cleared at OFF position
				me.Abs.mode.setValue(3);
				me.Abs.armed.setBoolValue(1);
			} else {
				me.absSetOff(1);
			}
		}
	},
};

setlistener("/gear/abs/knob-input", func() {
	BRAKES.absSetUpdate(BRAKES.Switch.abs.getValue());
}, 0, 0);

setlistener("/gear/abs/disarm", func() {
	BRAKES.absSetOff(1);
}, 0, 0);

# Engine Control
var ENGINE = {
	cutoffSwitch: [props.globals.getNode("/controls/engines/engine[0]/cutoff-switch"), props.globals.getNode("/controls/engines/engine[1]/cutoff-switch"), props.globals.getNode("/controls/engines/engine[2]/cutoff-switch")],
	reverseEngage: [props.globals.getNode("/controls/engines/engine[0]/reverse-engage"), props.globals.getNode("/controls/engines/engine[1]/reverse-engage"), props.globals.getNode("/controls/engines/engine[2]/reverse-engage")],
	startCmd: [props.globals.getNode("/controls/engines/engine[0]/start-cmd"), props.globals.getNode("/controls/engines/engine[1]/start-cmd"), props.globals.getNode("/controls/engines/engine[2]/start-cmd")],
	startSwitch: [props.globals.getNode("/controls/engines/engine[0]/start-switch"), props.globals.getNode("/controls/engines/engine[1]/start-switch"), props.globals.getNode("/controls/engines/engine[2]/start-switch")],
	throttle: [props.globals.getNode("/controls/engines/engine[0]/throttle"), props.globals.getNode("/controls/engines/engine[1]/throttle"), props.globals.getNode("/controls/engines/engine[2]/throttle")],
	throttleTemp: [0, 0, 0],
	init: func() {
		me.reverseEngage[0].setBoolValue(0);
		me.reverseEngage[1].setBoolValue(0);
		me.reverseEngage[2].setBoolValue(0);
		me.startCmd[0].setBoolValue(0);
		me.startCmd[1].setBoolValue(0);
		me.startCmd[2].setBoolValue(0);
		me.startSwitch[0].setBoolValue(0);
		me.startSwitch[1].setBoolValue(0);
		me.startSwitch[2].setBoolValue(0);
		pts.Engines.Engine.oilQtyInput[0].setValue(math.round((rand() * 8) + 20 , 0.1)); # Random between 20 and 28
		pts.Engines.Engine.oilQtyInput[1].setValue(math.round((rand() * 8) + 20 , 0.1)); # Random between 20 and 28
		pts.Engines.Engine.oilQtyInput[2].setValue(math.round((rand() * 8) + 20 , 0.1)); # Random between 20 and 28
	},
};

# Base off Engine 2
var doRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and systems.FADEC.throttleCompareMax.getValue() <= 0.05) {
		ENGINE.throttleTemp[1] = ENGINE.throttle[1].getValue();
		if (!ENGINE.reverseEngage[0].getBoolValue() or !ENGINE.reverseEngage[1].getBoolValue() or !ENGINE.reverseEngage[2].getBoolValue()) {
			ENGINE.reverseEngage[0].setBoolValue(1);
			ENGINE.reverseEngage[1].setBoolValue(1);
			ENGINE.reverseEngage[2].setBoolValue(1);
			ENGINE.throttle[0].setValue(0);
			ENGINE.throttle[1].setValue(0);
			ENGINE.throttle[2].setValue(0);
		} else if (ENGINE.throttleTemp[1] < 0.4) {
			ENGINE.throttle[0].setValue(0.4);
			ENGINE.throttle[1].setValue(0.4);
			ENGINE.throttle[2].setValue(0.4);
		} else if (ENGINE.throttleTemp[1] < 0.7) {
			ENGINE.throttle[0].setValue(0.7);
			ENGINE.throttle[1].setValue(0.7);
			ENGINE.throttle[2].setValue(0.7);
		} else if (ENGINE.throttleTemp[1] < 1) {
			ENGINE.throttle[0].setValue(1);
			ENGINE.throttle[1].setValue(1);
			ENGINE.throttle[2].setValue(1);
		}
	} else {
		ENGINE.throttle[0].setValue(0);
		ENGINE.throttle[1].setValue(0);
		ENGINE.throttle[2].setValue(0);
		ENGINE.reverseEngage[0].setBoolValue(0);
		ENGINE.reverseEngage[1].setBoolValue(0);
		ENGINE.reverseEngage[2].setBoolValue(0);
	}
}

var unRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and systems.FADEC.throttleCompareMax.getValue() <= 0.05) {
		if (ENGINE.reverseEngage[0].getBoolValue() or ENGINE.reverseEngage[1].getBoolValue() or ENGINE.reverseEngage[2].getBoolValue()) {
			ENGINE.throttleTemp[1] = ENGINE.throttle[1].getValue();
			if (ENGINE.throttleTemp[1] > 0.7) {
				ENGINE.throttle[0].setValue(0.7);
				ENGINE.throttle[1].setValue(0.7);
				ENGINE.throttle[2].setValue(0.7);
			} else if (ENGINE.throttleTemp[1] > 0.4) {
				ENGINE.throttle[0].setValue(0.4);
				ENGINE.throttle[1].setValue(0.4);
				ENGINE.throttle[2].setValue(0.4);
			} else if (ENGINE.throttleTemp[1] > 0.05) {
				ENGINE.throttle[0].setValue(0);
				ENGINE.throttle[1].setValue(0);
				ENGINE.throttle[2].setValue(0);
			} else {
				ENGINE.throttle[0].setValue(0);
				ENGINE.throttle[1].setValue(0);
				ENGINE.throttle[2].setValue(0);
				ENGINE.reverseEngage[0].setBoolValue(0);
				ENGINE.reverseEngage[1].setBoolValue(0);
				ENGINE.reverseEngage[2].setBoolValue(0);
			}
		}
	} else {
		ENGINE.throttle[0].setValue(0);
		ENGINE.throttle[1].setValue(0);
		ENGINE.throttle[2].setValue(0);
		ENGINE.reverseEngage[0].setBoolValue(0);
		ENGINE.reverseEngage[1].setBoolValue(0);
		ENGINE.reverseEngage[2].setBoolValue(0);
	}
}

var toggleRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and systems.FADEC.throttleCompareMax.getValue() <= 0.05) {
		if (ENGINE.reverseEngage[0].getBoolValue() or ENGINE.reverseEngage[1].getBoolValue() or ENGINE.reverseEngage[2].getBoolValue()) {
			ENGINE.throttle[0].setValue(0);
			ENGINE.throttle[1].setValue(0);
			ENGINE.throttle[2].setValue(0);
			ENGINE.reverseEngage[0].setBoolValue(0);
			ENGINE.reverseEngage[1].setBoolValue(0);
			ENGINE.reverseEngage[2].setBoolValue(0);
		} else {
			ENGINE.reverseEngage[0].setBoolValue(1);
			ENGINE.reverseEngage[1].setBoolValue(1);
			ENGINE.reverseEngage[2].setBoolValue(1);
		}
	} else {
		ENGINE.throttle[0].setValue(0);
		ENGINE.throttle[1].setValue(0);
		ENGINE.throttle[2].setValue(0);
		ENGINE.reverseEngage[0].setBoolValue(0);
		ENGINE.reverseEngage[1].setBoolValue(0);
		ENGINE.reverseEngage[2].setBoolValue(0);
	}
}

var doIdleThrust = func() {
	ENGINE.throttle[0].setValue(0);
	ENGINE.throttle[1].setValue(0);
	ENGINE.throttle[2].setValue(0);
}

var doLimitThrust = func() {
	var active = FADEC.Limit.activeNorm.getValue();
	ENGINE.throttle[0].setValue(active);
	ENGINE.throttle[1].setValue(active);
	ENGINE.throttle[2].setValue(active);
}

var doFullThrust = func() {
	ENGINE.throttle[0].setValue(1);
	ENGINE.throttle[1].setValue(1);
	ENGINE.throttle[2].setValue(1);
}

setlistener("/engines/engine[0]/state", func() {
	setprop("/sim/sound/shutdown[0]", pts.Engines.Engine.state[0].getValue());
}, 0, 0);

setlistener("/engines/engine[1]/state", func() {
	setprop("/sim/sound/shutdown[1]", pts.Engines.Engine.state[1].getValue());
}, 0, 0);

setlistener("/engines/engine[2]/state", func() {
	setprop("/sim/sound/shutdown[2]", pts.Engines.Engine.state[2].getValue());
}, 0, 0);

# FADEC
var FADEC = {
	anyEngineOut: 0,
	engPowered: [props.globals.getNode("/fdm/jsbsim/fadec/eng-1-powered"), props.globals.getNode("/fdm/jsbsim/fadec/eng-2-powered"), props.globals.getNode("/fdm/jsbsim/fadec/eng-3-powered")],
	pitchMode: 0,
	revState: [props.globals.getNode("/fdm/jsbsim/fadec/eng-1-rev-state"), props.globals.getNode("/fdm/jsbsim/fadec/eng-2-rev-state"), props.globals.getNode("/fdm/jsbsim/fadec/eng-3-rev-state")],
	throttleCompareMax: props.globals.getNode("/fdm/jsbsim/fadec/throttle-compare-max"),
	Limit: {
		active: props.globals.getNode("/fdm/jsbsim/fadec/limit/active"),
		activeMode: props.globals.getNode("/fdm/jsbsim/fadec/limit/active-mode"),
		activeModeInt: props.globals.getNode("/fdm/jsbsim/fadec/limit/active-mode-int"), # 0 T/O, 1 G/A, 2 MCT, 3 CLB, 4 CRZ
		activeNorm: props.globals.getNode("/fdm/jsbsim/fadec/limit/active-norm"),
		cruise: props.globals.getNode("/fdm/jsbsim/fadec/limit/cruise"),
		climb: props.globals.getNode("/fdm/jsbsim/fadec/limit/climb"),
		flexActive: props.globals.getNode("/fdm/jsbsim/fadec/limit/flex-active"),
		flexTemp: props.globals.getNode("/fdm/jsbsim/fadec/limit/flex-temp"),
		goAround: props.globals.getNode("/fdm/jsbsim/fadec/limit/go-around"),
		mct: props.globals.getNode("/fdm/jsbsim/fadec/limit/mct"),
		takeoff: props.globals.getNode("/fdm/jsbsim/fadec/limit/takeoff"),
	},
	Switch: {
		eng1Altn: props.globals.getNode("/controls/fadec/eng-1-altn"),
		eng2Altn: props.globals.getNode("/controls/fadec/eng-2-altn"),
		eng3Altn: props.globals.getNode("/controls/fadec/eng-3-altn"),
	},
	init: func() {
		me.Switch.eng1Altn.setBoolValue(0);
		me.Switch.eng2Altn.setBoolValue(0);
		me.Switch.eng3Altn.setBoolValue(0);
		me.Limit.activeModeInt.setValue(0);
		me.Limit.activeMode.setValue("T/O");
		me.Limit.flexActive.setBoolValue(0);
		me.Limit.flexTemp.setValue(30);
	},
	loop: func() {
		me.anyEngineOut = pts.Fdm.JSBsim.Libraries.anyEngineOut.getBoolValue();
		me.pitchMode = afs.Text.vert.getValue();
		if (me.pitchMode == "G/A CLB") {
			me.Limit.activeModeInt.setValue(1);
			me.Limit.activeMode.setValue("G/A");
		} else if (me.pitchMode == "T/O CLB") {
			me.Limit.activeModeInt.setValue(0);
			me.Limit.activeMode.setValue("T/O");
		} else if (me.pitchMode == "SPD CLB" or (me.pitchMode == "V/S" and afs.Input.vs.getValue() >= 50) or pts.Controls.Flight.flapsInput.getValue() >= 2) {
			if (me.anyEngineOut) {
				me.Limit.activeModeInt.setValue(2);
				me.Limit.activeMode.setValue("MCT");
			} else {
				me.Limit.activeModeInt.setValue(3);
				me.Limit.activeMode.setValue("CLB");
			}
		} else {
			if (me.anyEngineOut) {
				me.Limit.activeModeInt.setValue(2);
				me.Limit.activeMode.setValue("MCT");
			} else {
				me.Limit.activeModeInt.setValue(4);
				me.Limit.activeMode.setValue("CRZ");
			}
		}
	},
};

# Flight Control Computers
var FCC = {
	Fail: {
		elevatorFeel: props.globals.getNode("/systems/failures/fcc/elevator-feel"),
		flapLimit: props.globals.getNode("/systems/failures/fcc/flap-limit"),
		lsasLeftIn: props.globals.getNode("/systems/failures/fcc/lsas-left-in"),
		lsasLeftOut: props.globals.getNode("/systems/failures/fcc/lsas-left-out"),
		lsasRightIn: props.globals.getNode("/systems/failures/fcc/lsas-right-in"),
		lsasRightOut: props.globals.getNode("/systems/failures/fcc/lsas-right-out"),
		ydLowerA: props.globals.getNode("/systems/failures/fcc/yd-lower-a"),
		ydLowerB: props.globals.getNode("/systems/failures/fcc/yd-lower-b"),
		ydUpperA: props.globals.getNode("/systems/failures/fcc/yd-upper-a"),
		ydUpperB: props.globals.getNode("/systems/failures/fcc/yd-upper-b"),
	},
	fcc1Power: props.globals.getNode("/fdm/jsbsim/fcc/fcc1-power"),
	fcc2Power: props.globals.getNode("/fdm/jsbsim/fcc/fcc2-power"),
	Lsas: {
		leftInActive: props.globals.getNode("/fdm/jsbsim/fcc/lsas/left-in-active"),
		leftOutActive: props.globals.getNode("/fdm/jsbsim/fcc/lsas/left-out-active"),
		RightInActive: props.globals.getNode("/fdm/jsbsim/fcc/lsas/right-in-active"),
		RightOutActive: props.globals.getNode("/fdm/jsbsim/fcc/lsas/right-out-active"),
	},
	Switch: {
		elevatorFeelKnob: props.globals.getNode("/controls/fcc/switches/elevator-feel"),
		elevatorFeelMan: props.globals.getNode("/controls/fcc/switches/elevator-feel-man"),
		flapLimit: props.globals.getNode("/controls/fcc/switches/flap-limit"),
		lsasLeftIn: props.globals.getNode("/controls/fcc/switches/lsas-left-in"),
		lsasLeftOut: props.globals.getNode("/controls/fcc/switches/lsas-left-out"),
		lsasRightIn: props.globals.getNode("/controls/fcc/switches/lsas-right-in"),
		lsasRightOut: props.globals.getNode("/controls/fcc/switches/lsas-right-out"),
		ydLowerA: props.globals.getNode("/controls/fcc/switches/yd-lower-a"),
		ydLowerB: props.globals.getNode("/controls/fcc/switches/yd-lower-b"),
		ydUpperA: props.globals.getNode("/controls/fcc/switches/yd-upper-a"),
		ydUpperB: props.globals.getNode("/controls/fcc/switches/yd-upper-b"),
	},
	init: func() {
		me.resetFailures();
		me.Switch.elevatorFeelKnob.setValue(0);
		me.Switch.elevatorFeelMan.setBoolValue(0);
		me.Switch.flapLimit.setValue(0);
		me.Switch.lsasLeftIn.setBoolValue(1);
		me.Switch.lsasLeftOut.setBoolValue(1);
		me.Switch.lsasRightIn.setBoolValue(1);
		me.Switch.lsasRightOut.setBoolValue(1);
		me.Switch.ydLowerA.setBoolValue(1);
		me.Switch.ydLowerB.setBoolValue(1);
		me.Switch.ydUpperA.setBoolValue(1);
		me.Switch.ydUpperB.setBoolValue(1);	
	},
	resetFailures: func() {
		me.Fail.elevatorFeel.setBoolValue(0);
		me.Fail.flapLimit.setBoolValue(0);
		me.Fail.lsasLeftIn.setBoolValue(0);
		me.Fail.lsasLeftOut.setBoolValue(0);
		me.Fail.lsasRightIn.setBoolValue(0);
		me.Fail.lsasRightOut.setBoolValue(0);
		me.Fail.ydLowerA.setBoolValue(0);
		me.Fail.ydLowerB.setBoolValue(0);
		me.Fail.ydUpperA.setBoolValue(0);
		me.Fail.ydUpperB.setBoolValue(0);
	},
};

# Landing Gear
var GEAR = {
	Fail: {
		centerActuator: props.globals.getNode("/systems/failures/gear/center-actuator"),
		leftActuator: props.globals.getNode("/systems/failures/gear/left-actuator"),
		noseActuator: props.globals.getNode("/systems/failures/gear/nose-actuator"),
		rightActuator: props.globals.getNode("/systems/failures/gear/right-actuator"),
	},
	Switch: {
		brakeLeft: props.globals.getNode("/controls/gear/brake-left"),
		brakeParking: props.globals.getNode("/controls/gear/brake-parking"),
		brakeRight: props.globals.getNode("/controls/gear/brake-right"),
		centerGearUp: props.globals.getNode("/controls/gear/center-gear-up"),
		lever: props.globals.getNode("/controls/gear/lever"),
		leverCockpit: props.globals.getNode("/controls/gear/lever-cockpit"),
	},
	init: func() {
		me.resetFailures();
		me.Switch.brakeParking.setBoolValue(0);
		me.Switch.centerGearUp.setBoolValue(0);
	},
	resetFailures: func() {
		me.Fail.centerActuator.setBoolValue(0);
		me.Fail.leftActuator.setBoolValue(0);
		me.Fail.noseActuator.setBoolValue(0);
		me.Fail.rightActuator.setBoolValue(0);
	},
};

# Ignition
var IGNITION = {
	cutoff1: props.globals.getNode("/systems/ignition/cutoff-1"),
	cutoff2: props.globals.getNode("/systems/ignition/cutoff-2"),
	cutoff3: props.globals.getNode("/systems/ignition/cutoff-3"),
	ignAvail: props.globals.getNode("/systems/ignition/ign-avail"),
	ign1: props.globals.getNode("/systems/ignition/ign-1"),
	ign2: props.globals.getNode("/systems/ignition/ign-2"),
	ign3: props.globals.getNode("/systems/ignition/ign-3"),
	starter1: props.globals.getNode("/systems/ignition/starter-1"),
	starter2: props.globals.getNode("/systems/ignition/starter-2"),
	starter3: props.globals.getNode("/systems/ignition/starter-3"),
	Switch: {
		ignA: props.globals.getNode("/controls/ignition/switches/ign-a"),
		ignB: props.globals.getNode("/controls/ignition/switches/ign-b"),
		ignOvrd: props.globals.getNode("/controls/ignition/switches/ign-ovrd"),
	},
	init: func() {
		me.Switch.ignA.setBoolValue(0);
		me.Switch.ignB.setBoolValue(0);
		me.Switch.ignOvrd.setBoolValue(0);
	},
	fastStart: func(n) {
		ENGINE.cutoffSwitch[n].setBoolValue(0);
		pts.Fdm.JSBsim.Propulsion.setRunning.setValue(n);
	},
};

# IRS
var IRS = {
	hdg: 0,
	setHdg: 1,
	Iru: {
		aligned: [props.globals.getNode("/systems/iru[0]/aligned"), props.globals.getNode("/systems/iru[1]/aligned"), props.globals.getNode("/systems/iru[2]/aligned")],
		aligning: [props.globals.getNode("/systems/iru[0]/aligning"), props.globals.getNode("/systems/iru[1]/aligning"), props.globals.getNode("/systems/iru[2]/aligning")],
		alignMcduMsgOut: [props.globals.getNode("/systems/iru[0]/align-mcdu-msg-out"), props.globals.getNode("/systems/iru[1]/align-mcdu-msg-out"), props.globals.getNode("/systems/iru[2]/align-mcdu-msg-out")],
		alignTimer: [props.globals.getNode("/systems/iru[0]/align-timer"), props.globals.getNode("/systems/iru[1]/align-timer"), props.globals.getNode("/systems/iru[2]/align-timer")],
		alignTimeRemainingMinutes: [props.globals.getNode("/systems/iru[0]/align-time-remaining-minutes"),props.globals.getNode("/systems/iru[1]/align-time-remaining-minutes"),props.globals.getNode("/systems/iru[2]/align-time-remaining-minutes")],
		allAligned: props.globals.getNode("/systems/iru-common/all-aligned-out"),
		anyAligned: props.globals.getNode("/systems/iru-common/any-aligned-out"),
		attAvail: [props.globals.getNode("/systems/iru[0]/att-avail"), props.globals.getNode("/systems/iru[1]/att-avail"), props.globals.getNode("/systems/iru[2]/att-avail")],
		mainAvail: [props.globals.getNode("/systems/iru[0]/main-avail"), props.globals.getNode("/systems/iru[1]/main-avail"), props.globals.getNode("/systems/iru[2]/main-avail")],
	},
	Switch: {
		knob: [props.globals.getNode("/controls/iru[0]/switches/knob"), props.globals.getNode("/controls/iru[1]/switches/knob"), props.globals.getNode("/controls/iru[2]/switches/knob")],
		mcduBtn: props.globals.getNode("/controls/iru-common/mcdu-btn"),
	},
	init: func() {
		me.Switch.knob[0].setBoolValue(0);
		me.Switch.knob[1].setBoolValue(0);
		me.Switch.knob[2].setBoolValue(0);
		me.Switch.mcduBtn.setBoolValue(0);
	},
	anyAlignedUpdate: func() { # Called when the logical OR of the 3 aligned changes
		me.hdg = pts.Orientation.headingMagneticDeg.getValue();
		if (!me.Iru.aligned[0].getBoolValue() and !me.Iru.aligned[1].getBoolValue() and !me.Iru.aligned[2].getBoolValue()) {
			me.setHdg = 1;
		}
		if ((me.Iru.aligned[0].getBoolValue() or me.Iru.aligned[1].getBoolValue() or me.Iru.aligned[2].getBoolValue()) and me.setHdg) {
			me.setHdg = 0;
			afs.Input.hdg.setValue(me.hdg);
			afs.Internal.hdg.setValue(me.hdg);
		}
	},
	mcduMsgUpdate: func() {
		if (me.Iru.alignMcduMsgOut[0].getBoolValue() or me.Iru.alignMcduMsgOut[1].getBoolValue() or me.Iru.alignMcduMsgOut[2].getBoolValue()) {
			if (IRS.Switch.mcduBtn.getBoolValue()) {
				mcdu.BASE.removeGlobalMessage("ALIGN IRS");
			} else {
				mcdu.BASE.setGlobalMessage("ALIGN IRS");
			}
		} else {
			mcdu.BASE.removeGlobalMessage("ALIGN IRS");
		}
	},
};

# IRS MCDU Messages Logic
setlistener("/systems/iru-common/any-aligned-out", func() {
	IRS.anyAlignedUpdate();
}, 0, 0);
setlistener("/systems/iru[0]/align-mcdu-msg-out", func() {
	IRS.mcduMsgUpdate();
}, 0, 0);
setlistener("/systems/iru[1]/align-mcdu-msg-out", func() {
	IRS.mcduMsgUpdate();
}, 0, 0);
setlistener("/systems/iru[2]/align-mcdu-msg-out", func() {
	IRS.mcduMsgUpdate();
}, 0, 0);
setlistener("/controls/iru-common/mcdu-btn", func() {
	IRS.mcduMsgUpdate();
}, 0, 0);

# Warnings
var WARNINGS = {
	altitudeAlert: props.globals.getNode("/systems/caws/logic/altitude-alert"),
	altitudeAlertCaptured: props.globals.getNode("/systems/caws/logic/altitude-alert-captured"),
};
