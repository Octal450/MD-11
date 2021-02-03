# McDonnell Douglas MD-11 AFS Interface
# Copyright (c) 2021 Josh Davidson (Octal450)

var Fma = {
	ap: props.globals.initNode("/instrumentation/pfd/fma/ap-mode", "", "STRING"),
	pitch: props.globals.initNode("/instrumentation/pfd/fma/pitch-mode", "T/O CLAMP", "STRING"),
	pitchArm: props.globals.initNode("/instrumentation/pfd/fma/pitch-mode-armed", "", "STRING"),
	roll: props.globals.initNode("/instrumentation/pfd/fma/roll-mode", "TAKEOFF", "STRING"),
	rollArm: props.globals.initNode("/instrumentation/pfd/fma/roll-mode-armed", "", "STRING"),
};

var updateFma = {
	ap1: 0,
	ap2: 0,
	pitchText: "T/O CLB",
	rollText: "T/O",
	roll: func() {
		me.rollText = Text.lat.getValue();
		if (me.rollText == "HDG") {
			if (Input.trk.getBoolValue()) {
				Fma.roll.setValue("TRACK");
			} else {
				Fma.roll.setValue("HEADING");
			}
		} else if (me.rollText == "LNAV") {
			Fma.roll.setValue("NAV" ~ Internal.activeFMS.getValue());
		} else if (me.rollText == "LOC") {
			Fma.roll.setValue("LOC");
		} else if (me.rollText == "ALGN") {
			Fma.roll.setValue("ALIGN");
		} else if (me.rollText == "T/O") {
			Fma.roll.setValue("TAKEOFF");
		} else if (me.rollText == "RLOU") {
			Fma.roll.setValue("ROLLOUT");
		}
	},
	pitch: func() {
		me.pitchText = Text.vert.getValue();
		if (me.pitchText == "SPD DES") {
			Fma.pitch.setValue("IDLE CLAMP");
		} else if (me.pitchText == "G/A CLB") {
			Fma.pitch.setValue("GO AROUND");
		} else if (me.pitchText == "ALT HLD") {
			Fma.pitch.setValue("HOLD");
		} else if (me.pitchText == "ALT CAP") {
			Fma.pitch.setValue("HOLD");
		} else if (me.pitchText == "V/S") {
			Fma.pitch.setValue("V/S");
		} else if (me.pitchText == "G/S") {
			Fma.pitch.setValue("G/S");
		} else if (me.pitchText == "FPA") {
			Fma.pitch.setValue("FPA");
		} else if (me.pitchText == "FLARE") {
			Fma.pitch.setValue("FLARE");
		} else if (me.pitchText == "ROLLOUT") {
			Fma.pitch.setValue("ROLLOUT");
		}
	},
	arm: func() {
		if (Output.locArm.getBoolValue()) {
			Fma.rollArm.setValue("LAND ARMED");
		} else if (Output.lnavArm.getBoolValue()) {
			Fma.rollArm.setValue("NAV ARMED");
		} else {
			Fma.rollArm.setValue("");
		}
		if (Output.apprArm.getBoolValue() and !Output.locArm.getBoolValue()) {
			Fma.pitchArm.setValue("LAND ARMED");
		} else {
			Fma.pitchArm.setValue("");
		}
	},
	ap: func() {
		ap1 = Output.ap1.getBoolValue();
		ap2 = Output.ap2.getBoolValue();
		if (ap1 and ap2) {
			Fma.ap.setValue("AP1");
		} else if (ap1 and !ap2) {
			Fma.ap.setValue("AP1");
		} else if (ap2 and !ap1) {
			Fma.ap.setValue("AP2");
		} else if (!ap1 and !ap2) {
			Fma.ap.setValue("");
		}
	},
};

setlistener("/it-autoflight/output/ap1", func() {
	updateFma.ap();
}, 0, 0);
setlistener("/it-autoflight/output/ap2", func() {
	updateFma.ap();
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
		me.throttleMax = systems.FADEC.throttleCompareMax.getValue();
		
		if (me.pitchText == "T/O CLB") {
			if (Output.athr.getBoolValue() and pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue() < 80) {
				if (me.throttleMax >= 0.6) {
					me.active = 0;
				}
			} else {
				me.active = 1;
			}
		} else if (me.pitchText == "SPD DES") {
			if (me.throttleMax <= 0.005) {
				me.stopCheck = 1;
				me.active = 1;
				if (me.stopThrottleReset != 1) {
					me.stopThrottleReset = 1;
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
		
		if (pts.Systems.Acconfig.Options.throttleOverride.getValue() == "Never") {
			if (Output.clamp.getBoolValue() != 0) {
				Output.clamp.setBoolValue(0);
			}
		} else {
			if (Output.clamp.getBoolValue() != me.active) {
				Output.clamp.setBoolValue(me.active);
			}
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
				Fma.pitch.setValue(systems.FADEC.Limit.activeMode.getValue() ~ " CLAMP");
			} else {
				Fma.pitch.setValue(systems.FADEC.Limit.activeMode.getValue() ~ " THRUST");
			}
		}
	},
};

var clampLoop = maketimer(0.05, Clamp, Clamp.loop);
