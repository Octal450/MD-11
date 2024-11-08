# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)

var Perf = {
	new: func(n, t) {
		var m = {parents: [Perf]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.normal, FONT.small, FONT.small, FONT.normal, FONT.normal, FONT.normal],
			CLTranslate: [0, 1, 1, 0, 0, -3],
			CTranslate: [0, 1, 1, 0, 0, -3],
			C1L: "",
			C1: "",
			C2L: "",
			C2: "",
			C3L: "",
			C3: "",
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
			L2: "",
			L3L: "",
			L3: "",
			L4L: " EDIT",
			L4: "[ ]",
			L5L: "",
			L5: "",
			L6L: "",
			L6: "",
			
			LBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RFont: [FONT.small, FONT.small, FONT.small, FONT.normal, FONT.normal, FONT.normal],
			R1L: "",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
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
		
		if (t == 0) {
			m.Display.C2L = "TIME";
			m.Display.C2 = "----";
			m.Display.C3 = "----";
			
			m.Display.L3L = " MAX CLB";
			m.Display.L6L = "TRANS";
			
			m.Display.pageNum = "1/3";
			
			m.Display.R1L = "PRED TO";
			m.Display.R1 = "10000";
			m.Display.R2L = "DIST";
			m.Display.R2 = "----";
			m.Display.R3 = "----";
			m.Display.R5L = "CLIMB ";
			m.Display.R5 = "FORECAST>";
			
			m.nextPage = "preSelCrz";
		} else if (t == 1) {
			m.Display.pageNum = "1/2";
			
			m.Display.R1L = "TO T/D";
			m.Display.R1 = "----/---";
			
			m.nextPage = "preSelDes";
		} else if (t == 2) {
			m.Display.arrow = 0;
			
			m.Display.C1 = "0LONG";
			m.Display.C2L = "UTC";
			m.Display.C2 = "----";
			m.Display.C3 = "----";
			
			m.Display.L1L = "PATH ERROR";
			m.Display.L1 = " 0HI";
			m.Display.L3L = " MAX DES";
			m.Display.L6L = "TRANS";
			
			m.Display.pageNum = "";
			
			m.Display.R1L = "PRED TO";
			m.Display.R1 = "10000";
			m.Display.R2L = "DIST";
			m.Display.R2 = "----";
			m.Display.R3 = "----";
			m.Display.R5L = "DESCENT ";
			m.Display.R5 = "FORECAST>";
			
			m.nextPage = "none";
		}
		
		m.fromPage = "";
		m.group = "fmc";
		m.name = "perf";
		m.scratchpad = "";
		m.scratchpadState = 0;
		m.type = t; # 0 = CLB, 1 = CRZ, 2 = DES
		
		m.Value = {
		};
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		# Page advance logic
		if (me.type == 0) {
			if (fms.Internal.phase >= 4) {
				mcdu.unit[me.id].setPage("perfDes");
			} else if (fms.Internal.phase == 3) {
				mcdu.unit[me.id].setPage("perfCrz");
			}
		} else if (me.type == 1) {
			if (fms.Internal.phase >= 4) {
				mcdu.unit[me.id].setPage("perfDes");
			} else if (fms.Internal.phase <= 2) {
				mcdu.unit[me.id].setPage("perfClb");
			}
		} else if (me.type == 2) {
			if (fms.Internal.phase == 3) {
				mcdu.unit[me.id].setPage("perfCrz");
			} else if (fms.Internal.phase <= 2) {
				mcdu.unit[me.id].setPage("perfClb");
			}
		}
		
		# Fix title for ECON/MAX/EDIT
		if (me.type == 2) {
			me.Display.title = "ECON DES";
		} else if (me.type == 1) {
			me.Display.title = "ECON CRZ";
		} else {
			me.Display.title = "ECON CLB";
		}
		
		if (fms.FmsSpd.econKts > 0 and fms.FmsSpd.econMach > 0) {
			me.Display.L2 = sprintf("%d", fms.FmsSpd.econKts) ~ "/." ~ sprintf("%d", fms.FmsSpd.econMach * 1000);
			me.Display.LFont[1] = FONT.normal;
		} else {
			me.Display.L2 = "---";
			me.Display.LFont[1] = FONT.small;
		}
		
		if (me.type != 1) {
			if (fms.FmsSpd.maxClimb > 0) {
				if (me.type == 2) {
					me.Display.L3 = "*" ~ sprintf("%d", fms.FmsSpd.maxDescent);
				} else if (me.type == 1) {
					me.Display.L3 = "---"; # Not yet computed
				} else {
					me.Display.L3 = "*" ~ sprintf("%d", fms.FmsSpd.maxClimb);
				}
			} else {
				me.Display.L3 = "---";
			}
		}
		
		if (me.type == 0) {
			me.Display.L6 = sprintf("%d", fms.FlightData.climbTransAlt);
		} else if (me.type == 2) {
			me.Display.L6 = sprintf("%d", fms.FlightData.descentTransAlt);
		} else {
			me.Display.L6 = "";
		}
	},
	softKey: func(k) {
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		if (k == "l6") {
			if (me.scratchpadState == 2 and me.type != 1) {
				if (mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad >= 1000 and me.scratchpad <= 18000) {
						if (me.type == 2) {
							fms.FlightData.descentTransAlt = math.round(me.scratchpad, 1000);
						} else {
							fms.FlightData.climbTransAlt = math.round(me.scratchpad, 1000);
						}
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

var PreSel = {
	new: func(n, t) {
		var m = {parents: [PreSel]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.normal, FONT.small, FONT.small, FONT.normal, FONT.normal, FONT.normal],
			CLTranslate: [0, 1, 1, 0, 0, -3],
			CTranslate: [0, 1, 1, 0, 0, -3],
			C1L: "",
			C1: "",
			C2L: "",
			C2: "",
			C3L: "",
			C3: "",
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
			L2: "",
			L3L: "",
			L3: "",
			L4L: " EDIT",
			L4: "[ ]",
			L5L: "",
			L5: "",
			L6L: "",
			L6: "",
			
			LBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RFont: [FONT.small, FONT.small, FONT.small, FONT.normal, FONT.normal, FONT.normal],
			R1L: "",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "",
			R6: "",
			
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
		
		if (t == 1) {
			m.Display.pageNum = "2/3";
			m.Display.title = "PRESELECT CRZ";
			
			m.nextPage = "preSelDes";
		} else if (t == 2) {
			m.Display.L6L = "TRANS";
			
			m.Display.title = "PRESELECT DES";
			
			m.Display.R5L = "DESCENT ";
			m.Display.R5 = "FORECAST>";
		}
		
		m.fromPage = "";
		m.group = "fmc";
		m.name = "perf";
		m.scratchpad = "";
		m.scratchpadState = 0;
		m.type = t; # 0 = Unused so numbers match Perf class, 1 = CRZ, 2 = DES
		
		m.Value = {
		};
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		if (me.type == 1) {
			if (fms.Internal.phase >= 4) {
				mcdu.unit[me.id].setPage("perfDes");
			} else if (fms.Internal.phase == 3) {
				mcdu.unit[me.id].setPage("perfCrz");
			}
		} else if (me.type == 2) {
			if (fms.Internal.phase >= 4) {
				mcdu.unit[me.id].setPage("perfDes");
			} else if (fms.Internal.phase == 3) {
				me.Display.pageNum = "2/2";
				me.nextPage = "perfCrz";
			} else {
				me.Display.pageNum = "3/3";
				me.nextPage = "perfClb";
			}
		}
		
		if (fms.FmsSpd.econKts > 0 and fms.FmsSpd.econMach > 0) {
			me.Display.L2 = sprintf("%d", fms.FmsSpd.econKts) ~ "/." ~ sprintf("%d", fms.FmsSpd.econMach * 1000);
			me.Display.LFont[1] = FONT.normal;
		} else {
			me.Display.L2 = "---";
			me.Display.LFont[1] = FONT.small;
		}
		
		if (me.type == 0) {
			me.Display.L6 = sprintf("%d", fms.FlightData.climbTransAlt);
		} else if (me.type == 2) {
			me.Display.L6 = sprintf("%d", fms.FlightData.descentTransAlt);
		} else {
			me.Display.L6 = "";
		}
	},
	softKey: func(k) {
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		if (k == "l6") {
			if (me.scratchpadState == 2 and me.type == 2) {
				if (mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad >= 1000 and me.scratchpad <= 18000) {
						fms.FlightData.descentTransAlt = math.round(me.scratchpad, 1000);
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
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};
