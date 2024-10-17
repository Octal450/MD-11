# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)

var PerfClb = {
	new: func(n) {
		var m = {parents: [PerfClb]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.normal, FONT.small, FONT.small, FONT.normal, FONT.normal, FONT.normal],
			CLTranslate: [0, 1, 1, 0, 0, -3],
			CTranslate: [0, 1, 1, 0, 0, -3],
			C1L: "",
			C1: "",
			C2L: "TIME",
			C2: "----",
			C3L: "",
			C3: "----",
			C4L: "",
			C4: "",
			C5L: "",
			C5: "",
			C6L: "OPT/MAXFL",
			C6: "---/---",
			
			LFont: [FONT.normal, FONT.small, FONT.small, FONT.normal, FONT.normal, FONT.normal],
			L1L: "",
			L1: "",
			L2L: " ECON",
			L2: "---",
			L3L: " MAX CLB",
			L3: "",
			L4L: " EDIT",
			L4: "[ ]",
			L5L: "",
			L5: "",
			L6L: "TRANS",
			L6: "",
			
			LBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "1/3",
			
			RFont: [FONT.small, FONT.small, FONT.small, FONT.normal, FONT.normal, FONT.normal],
			R1L: "PRED TO",
			R1: "10000",
			R2L: "DIST",
			R2: "----",
			R3L: "",
			R3: "----",
			R4L: "",
			R4: "",
			R5L: "CLIMB ",
			R5: "FORCAST>",
			R6L: "THRUST ",
			R6: "LIMITS>",
			
			RBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "",
			titleTranslate: 0,
		};
		
		m.fromPage = "";
		m.group = "fmc";
		m.name = "perf";
		m.nextPage = "preSelCrz";
		m.scratchpad = "";
		m.scratchpadState = 0;
		
		m.Value = {
		};
		
		return m;
	},
	setup: func() {
		
	},
	loop: func() {
		#if (fms.Internal.phase == 3) {
		#	mcdu.unit[me.id].setPage("perfCrz");
		#} else if (fms.Internal.phase >= 4) {
		#	mcdu.unit[me.id].setPage("perfDes");
		#}
		
		# Fix title for ECON/MAX/EDIT
		me.Display.title = "ECON CLB";
		
		if (fms.FmsSpd.maxClimb > 0) {
			me.Display.L3 = sprintf("%d", fms.FmsSpd.maxClimb);
		} else {
			me.Display.L3 = "---";
		}
		
		me.Display.L6 = sprintf("%d", fms.FlightData.climbTransAlt);
	},
	softKey: func(k) {
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		if (k == "l6") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad >= 1000 and me.scratchpad <= 18000) {
						fms.FlightData.climbTransAlt = math.round(me.scratchpad, 1000);
						mcdu.unit[me.id].scratchpadClear();
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r6") {
			mcdu.unit[me.id].setPage("thrLim");
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};
