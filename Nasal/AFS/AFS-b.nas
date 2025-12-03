# McDonnell Douglas MD-11 AFS
# Copyright (c) 2025 Josh Davidson (Octal450)

var Fma = {
	ap: props.globals.initNode("/instrumentation/pfd/fma/ap-mode", "", "STRING"),
	pitch: props.globals.initNode("/instrumentation/pfd/fma/pitch-mode", "T/O CLAMP", "STRING"),
	pitchArm: props.globals.initNode("/instrumentation/pfd/fma/pitch-mode-armed", "", "STRING"),
	roll: props.globals.initNode("/instrumentation/pfd/fma/roll-mode", "TAKEOFF", "STRING"),
	rollArm: props.globals.initNode("/instrumentation/pfd/fma/roll-mode-armed", "", "STRING"),
	Blink: {
		active: [0, 0, 0],
		count: [0, 0, 0],
		diff: [0, 0, 0],
		elapsed: 0,
		hide: [0, 0, 0],
		time: [-5, -5, -5],
	},
	loop: func() {
		me.Blink.elapsed = pts.Sim.Time.elapsedSec.getValue();
		
		for (var i = 0; i < 3; i = i + 1) {
			if (me.Blink.elapsed < me.Blink.time[i] + 5) {
				me.Blink.active[i] = 1;
				me.Blink.count[i] = math.floor(math.max(me.Blink.elapsed - me.Blink.time[i], 0) * 2);
				me.Blink.hide[i] = !math.mod(me.Blink.count[i], 2);
			} else {
				me.Blink.active[i] = 0;
				me.Blink.count[i] = 0;
				me.Blink.hide[i] = 0;
			}
		}
	},
	startBlink: func(window) { # 0 Speed, 1 Roll, 2 Pitch
		me.Blink.time[window] = pts.Sim.Time.elapsedSec.getValue();
		me.loop(); # Force update
	},
	stopBlink: func(window) {
		me.Blink.time[window] = -5;
	},
};

var UpdateFma = {
	ap1: 0,
	ap2: 0,
	gsArm: 0,
	InternalRadioSel: 2,
	latText: "T/O",
	landArm: 0,
	lnavArm: 0,
	locArm: 0,
	vertText: "T/O CLB",
	arm: func() {
		me.gsArm = Output.gsArm.getBoolValue();
		me.landArm = Output.landArm.getBoolValue();
		me.lnavArm = Output.lnavArm.getBoolValue();
		me.locArm = Output.locArm.getBoolValue();
		if (me.locArm) {
			if (Input.radioSel.getValue() != 2) {
				Fma.rollArm.setValue("VOR ARMED");
			} else if (Internal.locOnly) {
				Fma.rollArm.setValue("LOC ARMED");
			} else {
				Fma.rollArm.setValue("LAND ARMED");
			}
		} else if (me.lnavArm) {
			Fma.rollArm.setValue("NAV ARMED");
		} else {
			Fma.rollArm.setValue("");
		}
		if ((me.gsArm or me.landArm) and !me.locArm) {
			Fma.pitchArm.setValue("LAND ARMED");
		} else {
			Fma.pitchArm.setValue("");
		}
	},
	lat: func() {
		me.latText = Text.lat.getValue();
		if (me.latText == "HDG") {
			if (Input.trk.getBoolValue()) {
				Fma.roll.setValue("TRACK");
			} else {
				Fma.roll.setValue("HEADING");
			}
		} else if (me.latText == "LNAV") {
			Fma.roll.setValue("NAV" ~ Internal.activeFms.getValue());
		} else if (me.latText == "LOC") {
			me.InternalRadioSel = Internal.radioSel.getValue();
			if (me.InternalRadioSel == 0) {
				Fma.roll.setValue("VOR1");
			} else if (me.InternalRadioSel == 1) {
				Fma.roll.setValue("VOR2");
			} else if (Internal.locOnly) {
				Fma.roll.setValue("LOC ONLY");
			} else {
				Fma.roll.setValue("LOC");
			}
		} else if (me.latText == "ALIGN") {
			Fma.roll.setValue("ALIGN");
		} else if (me.latText == "T/O") {
			Fma.roll.setValue("TAKEOFF");
		} else if (me.latText == "ROLLOUT") {
			Fma.roll.setValue("ROLLOUT");
		}
	},
	vert: func() {
		me.vertText = Text.vert.getValue();
		if (me.vertText == "SPD CLB" or me.vertText == "T/O CLB") {
			Clamp.loop(1);
		} else if (me.vertText == "SPD DES") {
			Fma.pitch.setValue("IDLE CLAMP");
		} else if (me.vertText == "G/A CLB") {
			Fma.pitch.setValue("GO AROUND");
		} else if (me.vertText == "ALT HLD") {
			Fma.pitch.setValue("HOLD");
		} else if (me.vertText == "ALT CAP") {
			Fma.pitch.setValue("HOLD");
		} else if (me.vertText == "V/S") {
			Fma.pitch.setValue("V/S");
		} else if (me.vertText == "G/S") {
			Fma.pitch.setValue("G/S");
		} else if (me.vertText == "FPA") {
			Fma.pitch.setValue("FPA");
		} else if (me.vertText == "FLARE") {
			Fma.pitch.setValue("FLARE");
		} else if (me.vertText == "ROLLOUT") {
			Fma.pitch.setValue("ROLLOUT");
		}
	},
};

var Clamp = {
	active: 0,
	fmaOutput: 0,
	vertText: "T/O CLB",
	stopCheck: 0,
	stopThrottleReset: 0,
	throttleMax: 0,
	loop: func(t = 0) {
		me.vertText = Text.vert.getValue();
		me.throttleMax = systems.FADEC.throttleCompareMax.getValue();
		
		if (me.vertText == "T/O CLB") {
			if (Output.athr.getBoolValue() and pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue() < 80) {
				if (me.throttleMax >= 0.6) {
					me.active = 0;
				}
			} else {
				me.active = 1;
			}
		} else if (me.vertText == "SPD DES") {
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
		
		if (Output.clamp.getBoolValue() != me.active) {
			Output.clamp.setBoolValue(me.active);
		}
		
		if (me.vertText == "T/O CLB") {
			if (me.active) {
				me.fmaOutput = 1;
			} else {
				me.fmaOutput = 0;
			}
		} else if (me.vertText == "SPD DES") {
			me.fmaOutput = 1;
		} else {
			me.fmaOutput = 0;
		}
		
		if (t == 1) {
			systems.FADEC.loop(); # Update thrust mode in case of out of sync loops
		}
		
		if (me.vertText == "SPD CLB" or me.vertText == "T/O CLB") {
			if (me.fmaOutput) {
				Fma.pitch.setValue(systems.FADEC.Limit.activeMode.getValue() ~ " CLAMP");
			} else {
				Fma.pitch.setValue(systems.FADEC.Limit.activeMode.getValue() ~ " THRUST");
			}
		}
	},
};

var clampLoop = maketimer(0.05, Clamp, Clamp.loop);
