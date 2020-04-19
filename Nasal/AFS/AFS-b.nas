# McDonnell Douglas MD-11 AFS Interface
# Copyright (c) 2020 Josh Davidson (Octal450)

var FMA = {
	ap: props.globals.initNode("/instrumentation/pfd/fma/ap-mode", "", "STRING"),
	pitch: props.globals.initNode("/instrumentation/pfd/fma/pitch-mode", "T/O CLAMP", "STRING"),
	pitchArm: props.globals.initNode("/instrumentation/pfd/fma/pitch-mode-armed", "", "STRING"),
	roll: props.globals.initNode("/instrumentation/pfd/fma/roll-mode", "TAKEOFF", "STRING"),
	rollArm: props.globals.initNode("/instrumentation/pfd/fma/roll-mode-armed", "", "STRING"),
};

var updateFMA = {
	ap1: 0,
	ap2: 0,
	clampFMA: 0,
	pitchText: "T/O CLB",
	rollText: "T/O",
	roll: func() {
		me.rollText = Text.lat.getValue();
		if (me.rollText == "HDG") {
			FMA.roll.setValue("HEADING");
		} else if (me.rollText == "LNAV") {
			FMA.roll.setValue("NAV" ~ Custom.Internal.activeFMS.getValue());
		} else if (me.rollText == "LOC") {
			FMA.roll.setValue("LOC");
		} else if (me.rollText == "ALGN") {
			FMA.roll.setValue("ALIGN");
		} else if (me.rollText == "T/O") {
			FMA.roll.setValue("TAKEOFF");
		} else if (me.rollText == "RLOU") {
			FMA.roll.setValue("ROLLOUT");
		}
	},
	pitch: func() {
		me.pitchText = Text.vert.getValue();
		if (me.pitchText == "SPD DES") {
			FMA.pitch.setValue("IDLE CLAMP");
		} else if (me.pitchText == "G/A CLB") {
			FMA.pitch.setValue("GO AROUND");
		} else if (me.pitchText == "ALT HLD") {
			FMA.pitch.setValue("HOLD");
		} else if (me.pitchText == "ALT CAP") {
			FMA.pitch.setValue("HOLD");
		} else if (me.pitchText == "V/S") {
			FMA.pitch.setValue("V/S");
		} else if (me.pitchText == "G/S") {
			FMA.pitch.setValue("G/S");
		} else if (me.pitchText == "FPA") {
			FMA.pitch.setValue("FPA");
		} else if (me.pitchText == "FLARE") {
			FMA.pitch.setValue("FLARE");
		} else if (me.pitchText == "ROLLOUT") {
			FMA.pitch.setValue("ROLLOUT");
		}
	},
	arm: func() {
		if (Output.locArm.getBoolValue()) {
			FMA.rollArm.setValue("LAND ARMED");
		} else if (Output.lnavArm.getBoolValue()) {
			FMA.rollArm.setValue("NAV ARMED");
		} else {
			FMA.rollArm.setValue("");
		}
		if (Output.apprArm.getBoolValue() and !Output.locArm.getBoolValue()) {
			FMA.pitchArm.setValue("LAND ARMED");
		} else {
			FMA.pitchArm.setValue("");
		}
	},
	ap: func() {
		ap1 = Output.ap1.getBoolValue();
		ap2 = Output.ap2.getBoolValue();
		if (ap1 and ap2) {
			FMA.ap.setValue("AP1");
		} else if (ap1 and !ap2) {
			FMA.ap.setValue("AP1");
		} else if (ap2 and !ap1) {
			FMA.ap.setValue("AP2");
		} else if (!ap1 and !ap2) {
			FMA.ap.setValue("");
		}
	},
};

setlistener("/it-autoflight/output/ap1", func {
	updateFMA.ap();
}, 0, 0);
setlistener("/it-autoflight/output/ap2", func {
	updateFMA.ap();
}, 0, 0);

var Clamp = {
	active: 0,
	fmaOutput: 0,
	pitchText: "T/O CLB",
	stopCheck: 0,
	stopThrottleReset: 0,
	throttleMax: 0,
	loop: func() {
		me.pitchText = Text.vert.getValue();
		me.throttleMax = pts.Controls.Engines.throttleMax.getValue();
		
		if (me.pitchText == "T/O CLB") {
			if (Output.athr.getBoolValue() and pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue() < 80) {
				if (me.throttleMax >= 0.6) {
					me.active = 0;
				}
			} else {
				me.active = 1;
			}
		} else if (me.pitchText == "SPD CLB") {
			me.stopCheck = 0;
			me.stopThrottleReset = 0;
			me.active = 0;
		} else if (me.pitchText == "SPD DES") {
			if (me.throttleMax <= 0.01) {
				me.stopCheck = 1;
				me.active = 1;
				if (me.stopThrottleReset != 1) {
					me.stopThrottleReset = 1;
					setprop("/controls/engines/engine[0]/throttle", 0);
					setprop("/controls/engines/engine[1]/throttle", 0);
					setprop("/controls/engines/engine[2]/throttle", 0);
				}
			} else if (me.stopCheck != 1) {
				me.stopThrottleReset = 0;
				me.active = 0;
			}
		} else {
			me.stopCheck = 0;
			me.stopThrottleReset = 0;
			me.active = 0;
		}
		
		if (getprop("/it-autoflight/output/clamp") != me.active) {
			setprop("/it-autoflight/output/clamp", me.active);
		}
		
		if (me.pitchText == "T/O CLB") {
			if (me.active) {
				me.fmaOutput = 1;
			} else {
				me.fmaOutput = 0;
			}
		} else if (me.pitchText == "SPD DES") {
			me.fmaOutput = 1;
		} else {
			me.fmaOutput = 0;
		}
		
		if (me.pitchText == "SPD CLB" or me.pitchText == "T/O CLB") {
			if (me.fmaOutput) {
				FMA.pitch.setValue(fadec.Output.thrustLimitMode.getValue() ~ " CLAMP");
			} else {
				FMA.pitch.setValue(fadec.Output.thrustLimitMode.getValue() ~ " THRUST");
			}
		}
	},
};

var clampLoop = maketimer(0.05, Clamp, Clamp.loop);
