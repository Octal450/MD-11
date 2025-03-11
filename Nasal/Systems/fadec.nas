# McDonnell Douglas MD-11 FADEC
# Copyright (c) 2025 Josh Davidson (Octal450)

var FADEC = {
	anyEngineOut: 0,
	n1Mode: [props.globals.getNode("/systems/fadec/control-1/n1-mode", 1), props.globals.getNode("/systems/fadec/control-2/n1-mode", 1), props.globals.getNode("/systems/fadec/control-3/n1-mode", 1)],
	pitchMode: "",
	powered: [props.globals.getNode("/systems/fadec/eng-1-powered"), props.globals.getNode("/systems/fadec/eng-2-powered"), props.globals.getNode("/systems/fadec/eng-3-powered")],
	reverseEngage: [props.globals.getNode("/systems/fadec/reverse-1/engage"), props.globals.getNode("/systems/fadec/reverse-2/engage"), props.globals.getNode("/systems/fadec/reverse-3/engage")],
	revState: [props.globals.getNode("/systems/fadec/eng-1-rev-state"), props.globals.getNode("/systems/fadec/eng-2-rev-state"), props.globals.getNode("/systems/fadec/eng-3-rev-state")],
	throttleCompareMax: props.globals.getNode("/systems/fadec/throttle-compare-max"),
	throttleEpr: [props.globals.getNode("/systems/fadec/control-1/throttle-epr", 1), props.globals.getNode("/systems/fadec/control-2/throttle-epr", 1), props.globals.getNode("/systems/fadec/control-3/throttle-epr", 1)],
	throttleN1: [props.globals.getNode("/systems/fadec/control-1/throttle-n1", 1), props.globals.getNode("/systems/fadec/control-2/throttle-n1", 1), props.globals.getNode("/systems/fadec/control-3/throttle-n1", 1)],
	Limit: {
		active: props.globals.getNode("/systems/fadec/limit/active"),
		activeMode: props.globals.getNode("/systems/fadec/limit/active-mode"),
		activeModeInt: props.globals.getNode("/systems/fadec/limit/active-mode-int"), # 0 T/O, 1 G/A, 2 MCT, 3 CLB, 4 CRZ
		activeNorm: props.globals.getNode("/systems/fadec/limit/active-norm"),
		auto: props.globals.getNode("/systems/fadec/limit/auto"),
		cruise: props.globals.getNode("/systems/fadec/limit/cruise"),
		climb: props.globals.getNode("/systems/fadec/limit/climb"),
		goAround: props.globals.getNode("/systems/fadec/limit/go-around"),
		mct: props.globals.getNode("/systems/fadec/limit/mct"),
		pwDerate: props.globals.getNode("/systems/fadec/limit/pw-derate"),
		takeoff: props.globals.getNode("/systems/fadec/limit/takeoff"),
		takeoffFlex: props.globals.getNode("/systems/fadec/limit/takeoff-flex"),
		takeoffNoFlex: props.globals.getNode("/systems/fadec/limit/takeoff-no-flex"),
	},
	Controls: {
		altn1: props.globals.getNode("/controls/fadec/altn-1"),
		altn2: props.globals.getNode("/controls/fadec/altn-2"),
		altn3: props.globals.getNode("/controls/fadec/altn-3"),
	},
	init: func() {
		me.reverseEngage[0].setBoolValue(0);
		me.reverseEngage[1].setBoolValue(0);
		me.reverseEngage[2].setBoolValue(0);
		me.Controls.altn1.setBoolValue(0);
		me.Controls.altn2.setBoolValue(0);
		me.Controls.altn3.setBoolValue(0);
		me.Limit.activeModeInt.setValue(0);
		me.Limit.activeMode.setValue("T/O");
		me.Limit.auto.setBoolValue(1);
		me.Limit.pwDerate.setBoolValue(1);
	},
	loop: func() {
		me.anyEngineOut = systems.ENGINES.anyEngineOut.getBoolValue();
		me.pitchMode = afs.Text.vert.getValue();
		
		if (me.Limit.auto.getBoolValue()) {
			if (me.pitchMode == "G/A CLB") {
				me.setMode(1, 1); # G/A
			} else if (me.pitchMode == "T/O CLB") {
				me.setMode(0, 1); # T/O
			} else if (afs.Output.spdProt.getValue() == 1) {
				me.setMode(2, 1); # MCT
			} else if (me.pitchMode == "SPD CLB" or fms.Internal.phase < 3 or systems.FCS.flapsInput.getValue() >= 2) {
				if (me.anyEngineOut) {
					me.setMode(2, 1); # MCT
				} else {
					me.setMode(3, 1); # CLB
				}
			} else {
				if (me.anyEngineOut) {
					me.setMode(2, 1); # MCT
				} else {
					me.setMode(4, 1); # CRZ
				}
			}
		}
	},
	setMode: func(m, nfr = 0) {
		if (m == 0) {
			me.Limit.activeModeInt.setValue(0);
			me.Limit.activeMode.setValue("T/O");
		} else if (m == 1) {
			me.Limit.activeModeInt.setValue(1);
			me.Limit.activeMode.setValue("G/A");
		} else if (m == 2) {
			me.Limit.activeModeInt.setValue(2);
			me.Limit.activeMode.setValue("MCT");
			me.Limit.pwDerate.setBoolValue(1);
		} else if (m == 3) {
			me.Limit.activeModeInt.setValue(3);
			me.Limit.activeMode.setValue("CLB");
			me.Limit.pwDerate.setBoolValue(1);
		} else if (m == 4) {
			me.Limit.activeModeInt.setValue(4);
			me.Limit.activeMode.setValue("CRZ");
			me.Limit.pwDerate.setBoolValue(1);
		}
		
		if (m != 0 and !nfr) { # NFR = Don't reset while in auto mode
			if (fms.FlightData.flexActive) {
				fms.FlightData.flexActive = 0;
				fms.FlightData.flexTemp = 0;
				fms.EditFlightData.resetVspeeds();
			}
		}
	},
};
