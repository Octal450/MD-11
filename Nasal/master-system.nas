# MD-11 Master System
# Copyright (c) 2019 Joshua Davidson (Octal450)

var FCTL = {
	Fail: {
		flapLimit: props.globals.getNode("/systems/failures/fctl/flap-limit"),
		lsasElevFeel: props.globals.getNode("/systems/failures/fctl/lsas-elev-feel"),
		lsasLeftIn: props.globals.getNode("/systems/failures/fctl/lsas-left-in"),
		lsasLeftOut: props.globals.getNode("/systems/failures/fctl/lsas-left-out"),
		lsasRightIn: props.globals.getNode("/systems/failures/fctl/lsas-right-in"),
		lsasRightOut: props.globals.getNode("/systems/failures/fctl/lsas-right-out"),
		ydUpperA: props.globals.getNode("/systems/failures/fctl/yd-upper-a"),
		ydUpperB: props.globals.getNode("/systems/failures/fctl/yd-upper-b"),
		ydLowerA: props.globals.getNode("/systems/failures/fctl/yd-lower-a"),
		ydLowerB: props.globals.getNode("/systems/failures/fctl/yd-lower-b"),
	},
	Switch: {
		flapLimit: props.globals.getNode("/controls/fctl/flap-limit-knob"),
		lsasFeelKnob: props.globals.getNode("/controls/fctl/lsas-feel-knob"),
		lsasFeelMan: props.globals.getNode("/controls/fctl/lsas-feel-man"),
		lsasLeftIn: props.globals.getNode("/controls/fctl/lsas-left-in"),
		lsasLeftOut: props.globals.getNode("/controls/fctl/lsas-left-out"),
		lsasRightIn: props.globals.getNode("/controls/fctl/lsas-right-in"),
		lsasRightOut: props.globals.getNode("/controls/fctl/lsas-right-out"),
		ydUpperA: props.globals.getNode("/controls/fctl/yd-upper-a"),
		ydUpperB: props.globals.getNode("/controls/fctl/yd-upper-b"),
		ydLowerA: props.globals.getNode("/controls/fctl/yd-lower-a"),
		ydLowerB: props.globals.getNode("/controls/fctl/yd-lower-b"),
	},
	init: func() {
		me.resetFail();
		me.Switch.flapLimit.setValue(0);
		me.Switch.lsasFeelKnob.setValue(0);
		me.Switch.lsasFeelMan.setBoolValue(0);
		me.Switch.lsasLeftIn.setBoolValue(1);
		me.Switch.lsasLeftOut.setBoolValue(1);
		me.Switch.lsasRightIn.setBoolValue(1);
		me.Switch.lsasRightOut.setBoolValue(1);
		me.Switch.ydUpperA.setBoolValue(1);
		me.Switch.ydUpperB.setBoolValue(1);	
		me.Switch.ydLowerA.setBoolValue(1);
		me.Switch.ydLowerB.setBoolValue(1);
	},
	resetFail: func() {
		me.Fail.flapLimit.setBoolValue(0);
		me.Fail.lsasElevFeel.setBoolValue(0);
		me.Fail.lsasLeftIn.setBoolValue(0);
		me.Fail.lsasLeftOut.setBoolValue(0);
		me.Fail.lsasRightIn.setBoolValue(0);
		me.Fail.lsasRightOut.setBoolValue(0);
		me.Fail.ydUpperA.setBoolValue(0);
		me.Fail.ydUpperB.setBoolValue(0);	
		me.Fail.ydLowerA.setBoolValue(0);
		me.Fail.ydLowerB.setBoolValue(0);
	},
};
