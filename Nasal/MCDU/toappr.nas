# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)

var Takeoff = {
	new: func(n) {
		var m = {parents: [Takeoff]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.small, FONT.small, FONT.small, FONT.small, FONT.small, FONT.small],
			CSTranslate: [-120, -120, -120, -120, -120, -120],
			CTranslate: [-120, -120, -120, -120, -120, -120],
			C1S: "TOCG/TOGW",
			C1: "--.-/---.-",
			C2S: "",
			C2: "",
			C3S: "STAB",
			C3: "---",
			C4S: "VFR",
			C4: "---",
			C5S: "VSR/V3",
			C5: "---",
			C6S: "VCL",
			C6: "---",
			
			LFont: [FONT.normal, FONT.small, FONT.normal, FONT.small, FONT.small, FONT.small],
			L1S: "FLEX",
			L1: "*[ ]",
			L2S: "PACKS",
			L2: "OFF",
			L3S: "FLAP",
			L3: "__._",
			L4S: "V1",
			L4: "---",
			L5S: "VR",
			L5: "---",
			L6S: "V2",
			L6: "---",
			
			pageNum: "",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.small, FONT.small, FONT.small],
			R1S: "THRUST ",
			R1: "LIMITS>",
			R2S: "SLOPE/WIND",
			R2: "___._/____",
			R3S: "OAT",
			R3: "____",
			R4S: "CLB THRUST",
			R4: "----",
			R5S: "ACCEL",
			R5: "----",
			R6S: "EO ACCEL",
			R6: "----",
			
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
