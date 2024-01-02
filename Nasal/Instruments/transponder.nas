# McDonnell Douglas MD-11 Transponder
# Copyright (c) 2024 Josh Davidson (Octal450)

var XPDR = {
	altReport: props.globals.initNode("/instrumentation/transponder/input/alt-report"),
	clearTime: 0,
	code: "1200",
	digit: [props.globals.initNode("/instrumentation/transponder/output/digit[0]", "1", "STRING"), props.globals.initNode("/instrumentation/transponder/output/digit[1]", "2", "STRING"), props.globals.initNode("/instrumentation/transponder/output/digit[2]", "0", "STRING"), props.globals.initNode("/instrumentation/transponder/output/digit[3]", "0", "STRING")],
	fgKnob: props.globals.getNode("/instrumentation/transponder/inputs/knob-mode", 1),
	fgMode: props.globals.getNode("/sim/gui/dialogs/radios/transponder-mode", 1), # OFF, STANDBY, TEST, GROUND, ON, ALTITUDE
	fgModeList: ["OFF", "STANDBY", "TEST", "GROUND", "ON", "ALTITUDE"],
	fgCode: props.globals.getNode("/instrumentation/transponder/id-code", 1),
	knob: props.globals.getNode("/instrumentation/transponder/output/knob"),
	mode: 1,
	ident: props.globals.getNode("/instrumentation/transponder/inputs/ident-btn", 1),
	identTime: 0,
	onMode: 5,
	power: props.globals.getNode("/systems/electrical/outputs/transponder", 1),
	tcasMode: props.globals.getNode("/instrumentation/tcas/inputs/mode"),
	xpdr: props.globals.getNode("/instrumentation/transponder/input/xpdr"),
	init: func() { # Don't reset the code
		me.altReport.setBoolValue(1);
		me.codeEntryActive = 0;
		me.setMode(0);
		me.xpdr.setBoolValue(0);
	},
	getOnMode: func() {
		if (me.altReport.getBoolValue()) {
			if (!pts.Fdm.JSBsim.Position.wow.getBoolValue()) {
				return 5; # Altitude
			} else {
				return 3; # Ground
			}
		} else {
			return 4; # On
		}
	},
	modeKnob: func(d) {
		me.setMode(math.clamp(me.knob.getValue() + d, 0, 3));
	},
	setMode: func(m) {
		me.knob.setValue(m);
		me.onMode = me.getOnMode();
		if (m == 0) { # STBY
			me.fgKnob.setValue(1); # Standby
			me.fgMode.setValue("STANDBY");
			me.tcasMode.setValue(0); # OFF
		} else if (m == 1) { # XPDR
			me.fgKnob.setValue(me.onMode);
			me.fgMode.setValue(me.fgModeList[me.onMode]);
			me.tcasMode.setValue(0); # OFF
		} else if (m == 2) { # TA
			me.fgKnob.setValue(me.onMode);
			me.fgMode.setValue(me.fgModeList[me.onMode]);
			me.tcasMode.setValue(2); # TA Only
		} else if (m == 3) { # TA/RA
			me.fgKnob.setValue(me.onMode);
			me.fgMode.setValue(me.fgModeList[me.onMode]);
			me.tcasMode.setValue(3); # TA/RA
		}
	},
	airGround: func() {
		me.setMode(me.knob.getValue());
	},
	toggleAltReport: func() {
		me.altReport.setBoolValue(!me.altReport.getBoolValue());
		me.setMode(me.knob.getValue());
	},
	input: func(n) {
		if (me.power.getValue() >= 24) {
			if (n == "CLR") {
				if (size(me.code) == 4) {
					me.code = "";
					# After 5 seconds revert to 1200
					me.clearTime = pts.Sim.Time.elapsedSec.getValue();
					xpdrClearChk.start();
				} else {
					me.code = "1200";
				}
			} else {
				if (size(me.code) == 4) {
					me.code = n;
				} else {
					me.code = me.code ~ n;
				}
				if (size(me.code) > 0) { # Remove leading 0s, so that the displays cycles right
					me.code = sprintf("%d", me.code);
				}
			}
			
			me.updateDisplay();
			if (size(me.code) > 0) {
				me.setCode();
			}
		}
	},
	updateDisplay: func() {
		if (size(me.code) == 0) {
			me.digit[0].setValue("-"); # Hidden
			me.digit[1].setValue("-"); # Hidden
			me.digit[2].setValue("-"); # Hidden
			me.digit[3].setValue("-"); # Hidden
		} else {
			me.digit[0].setValue(sprintf("%1d", math.mod(me.code / 1000, 10)));
			me.digit[1].setValue(sprintf("%1d", math.mod(me.code / 100, 10)));
			me.digit[2].setValue(sprintf("%1d", math.mod(me.code / 10, 10)));
			me.digit[3].setValue(sprintf("%1d", math.mod(me.code, 10)));
		}
	},
	setCode: func() {
		if (me.fgCode.getValue() != me.code) {
			me.fgCode.setValue(me.code);
		}
	},
	setIdent: func() {
		me.ident.setBoolValue(1);
		me.identTime = pts.Sim.Time.elapsedSec.getValue();
		identChk.start();
	},
};

var xpdrClearChk = maketimer(0.5, func {
	if (size(XPDR.code) == 0) {
		if (XPDR.clearTime + 5 <= pts.Sim.Time.elapsedSec.getValue()) {
			xpdrClearChk.stop();
			XPDR.code = "1200";
			XPDR.updateDisplay();
			XPDR.setCode();
		}
	} else {
		xpdrClearChk.stop();
	}
});

var identChk = maketimer(0.5, func {
	if (XPDR.power.getValue() >= 24) {
		if (XPDR.identTime + 18 <= pts.Sim.Time.elapsedSec.getValue()) {
			identChk.stop();
			XPDR.ident.setBoolValue(0);
		}
	} else {
		identChk.stop();
		XPDR.ident.setBoolValue(0);
	}
});

setlistener("/instrumentation/transponder/id-code", func { # Backwards compatibility with hardware etc
	if (XPDR.fgCode.getValue() != XPDR.code) { # Make sure this and setCode won't keep calling each other, they both check
		XPDR.code = sprintf("%d", XPDR.fgCode.getValue());
		XPDR.updateDisplay();
		XPDR.setCode();
	}
}, 0, 0);
