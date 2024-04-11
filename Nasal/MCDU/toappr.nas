# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)

var Takeoff = {
	new: func(n) {
		var m = {parents: [Takeoff]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.small, FONT.small, FONT.small, FONT.small, FONT.small, FONT.small],
			CTranslate: [-120, -120, -120, -120, -120, -120],
			CSTranslate: [-120, -120, -120, -120, -120, -120],
			C1: "--.-/---.-",
			C1S: "TOCG/TOGW",
			C2: "",
			C2S: "",
			C3: "---",
			C3S: "STAB",
			C4: "---",
			C4S: "VFR",
			C5: "---",
			C5S: "VSR/V3",
			C6: "---",
			C6S: "VCL",
			
			LFont: [FONT.normal, FONT.small, FONT.normal, FONT.small, FONT.small, FONT.small],
			L1: "*[ ]",
			L1S: "FLEX",
			L2: "OFF",
			L2S: "PACKS",
			L3: "__._",
			L3S: "FLAP",
			L4: "---",
			L4S: "V1",
			L5: "---",
			L5S: "VR",
			L6: "---",
			L6S: "V2",
			
			pageNum: "",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.small, FONT.small, FONT.small],
			R1: "LIMITS>",
			R1S: "THRUST ",
			R2: "___._/____",
			R2S: "SLOPE/WIND",
			R3: "____",
			R3S: "OAT",
			R4: "----",
			R4S: "CLB THRUST",
			R5: "----",
			R5S: "ACCEL",
			R6: "----",
			R6S: "EO ACCEL",
			
			simple: 1,
			title: "",
		};
		
		m.Value = {
		};
		
		m.group = "fmc";
		m.name = "takeoff";
		m.nextPage = "none";
		m.scratchpad = "";
		m.scratchpadSplit = nil;
		m.scratchpadSplitSize = 0;
		m.scratchpadState = 0;
		
		return m;
	},
	reset: func() {
		me.setup();
	},
	setup: func() {
		if (pts.Options.eng.getValue() == "PW") {
			me.Display.C2S = "EPR";
		} else {
			me.Display.C2S = "N1";
		}
	},
	loop: func() {
		if (fms.FlightData.airportFrom != "") {
			me.Display.title = "TAKE OFF " ~ fms.FlightData.airportFrom;
		} else {
			me.Display.title = "TAKE OFF";
		}
		
		if (pts.Options.eng.getValue() == "PW") {
			me.Display.C2 = sprintf("%4.2f", systems.FADEC.Limit.takeoff.getValue());
		} else {
			me.Display.C2 = sprintf("%5.1f", systems.FADEC.Limit.takeoff.getValue());
		}
	},
	softKey: func(k) {
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		#} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		#}
	},
};
