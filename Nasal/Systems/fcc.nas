# McDonnell Douglas MD-11 FCC
# Copyright (c) 2025 Josh Davidson (Octal450)

var FCC = {
	bit1: props.globals.getNode("/systems/fcc/bit-1"),
	bit2: props.globals.getNode("/systems/fcc/bit-2"),
	ElevatorFeel: {
		auto: props.globals.getNode("/systems/fcc/elevator-feel/auto"),
		speed: props.globals.getNode("/systems/fcc/elevator-feel/speed"),
	},
	fcc1Power: props.globals.getNode("/systems/fcc/fcc-1-power"),
	fcc2Power: props.globals.getNode("/systems/fcc/fcc-2-power"),
	inhibitAltCapTime: props.globals.getNode("/systems/fcc/inhibit-alt-cap-time"),
	Lsas: {
		autotrimInhibit: props.globals.getNode("/systems/fcc/lsas/autotrim-inhibit"),
		leftInActive: props.globals.getNode("/systems/fcc/lsas/left-in-active"),
		leftOutActive: props.globals.getNode("/systems/fcc/lsas/left-out-active"),
		RightInActive: props.globals.getNode("/systems/fcc/lsas/right-in-active"),
		RightOutActive: props.globals.getNode("/systems/fcc/lsas/right-out-active"),
	},
	nlgWowTimer20: props.globals.getNode("/systems/fcc/nlg-wow-timer-20", 1),
	pitchTrimSpeed: props.globals.getNode("/systems/fcc/pitch-trim-speed"),
	powerAvail: props.globals.getNode("/systems/fcc/power-avail"),
	powerAvailTemp: 0,
	stallAlphaDeg: props.globals.getNode("/systems/fcc/stall-alpha-deg"),
	stallWarnAlphaDeg: props.globals.getNode("/systems/fcc/stall-warn-alpha-deg"),
	Controls: {
		elevatorFeelKnob: props.globals.getNode("/controls/fcc/elevator-feel"),
		elevatorFeelMan: props.globals.getNode("/controls/fcc/elevator-feel-man"),
		flapLimit: props.globals.getNode("/controls/fcc/flap-limit"),
		lsasLeftIn: props.globals.getNode("/controls/fcc/lsas-left-in"),
		lsasLeftOut: props.globals.getNode("/controls/fcc/lsas-left-out"),
		lsasRightIn: props.globals.getNode("/controls/fcc/lsas-right-in"),
		lsasRightOut: props.globals.getNode("/controls/fcc/lsas-right-out"),
		ydLowerA: props.globals.getNode("/controls/fcc/yd-lower-a"),
		ydLowerB: props.globals.getNode("/controls/fcc/yd-lower-b"),
		ydUpperA: props.globals.getNode("/controls/fcc/yd-upper-a"),
		ydUpperB: props.globals.getNode("/controls/fcc/yd-upper-b"),
	},
	Failures: {
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
	init: func() {
		me.resetFailures();
		me.Controls.elevatorFeelKnob.setValue(0);
		me.Controls.elevatorFeelMan.setBoolValue(0);
		me.Controls.flapLimit.setValue(0);
		me.Controls.lsasLeftIn.setBoolValue(1);
		me.Controls.lsasLeftOut.setBoolValue(1);
		me.Controls.lsasRightIn.setBoolValue(1);
		me.Controls.lsasRightOut.setBoolValue(1);
		me.Controls.ydLowerA.setBoolValue(1);
		me.Controls.ydLowerB.setBoolValue(1);
		me.Controls.ydUpperA.setBoolValue(1);
		me.Controls.ydUpperB.setBoolValue(1);	
	},
	resetFailures: func() {
		me.Failures.elevatorFeel.setBoolValue(0);
		me.Failures.flapLimit.setBoolValue(0);
		me.Failures.lsasLeftIn.setBoolValue(0);
		me.Failures.lsasLeftOut.setBoolValue(0);
		me.Failures.lsasRightIn.setBoolValue(0);
		me.Failures.lsasRightOut.setBoolValue(0);
		me.Failures.ydLowerA.setBoolValue(0);
		me.Failures.ydLowerB.setBoolValue(0);
		me.Failures.ydUpperA.setBoolValue(0);
		me.Failures.ydUpperB.setBoolValue(0);
	},
};
