# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2026 Josh Davidson (Octal450)

var Menu = {
	new: func(n, t) {
		var m = {parents: [Menu]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 0, 0, 0],
			CTranslate: [-2, 0, 0, 0, 0, 0],
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
			C6L: "",
			C6: "",
			
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: "",
			L1: "",
			L2L: "",
			L2: "",
			L3L: "",
			L3: "",
			L4L: "",
			L4: "<CDFS",
			L5L: "",
			L5: "",
			L6L: "",
			L6: "",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "STANDBY",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "MAINT>",
			R6L: "",
			R6: "",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "MENU",
			titleTranslate: 1,
		};
		
		if (t) {
			m.Display.L2 = "<ACARS";
			m.Display.R1 = "F-PLN*";
		} else {
			m.Display.R1 = "NAV/RAD*";
		}
		
		m.group = "base";
		m.name = "menu";
		m.nextPage = "none";
		m.type = t;
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		if (!me.type) {
			if (fms.Internal.avail[me.id].getBoolValue()) {
				me.Display.L1 = "<FMC-" ~ sprintf("%s", me.id + 1);
				
				if (me.type) {
					me.Display.C1 = "";
				} else if (fms.Internal.request[me.id]) {
					me.Display.C1 = "<REQ>";
				} else {
					me.Display.C1 = "<ACT>";
				}
			} else {
				me.Display.L1 = "";
				me.Display.C1 = "";
			}
			
			if (unit[me.id].lastFmcPage == "none") {
				me.Display.R6 = "";
			} else {
				me.Display.R6 = "RETURN>";
			}
		}
	},
	softKey: func(k) {
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l1" and !me.type) {
			if (me.scratchpadState == 1 and me.Display.L1 != "") {
				if (fms.Internal.request[me.id]) {
					fms.Internal.request[me.id] = 0;
				} else if (unit[me.id].lastFmcPage == "none") {
					unit[me.id].setPage("acStatus");
				} else {
					unit[me.id].setPage(unit[me.id].lastFmcPage);
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r6" and !me.type) {
			if (unit[me.id].lastFmcPage == "none") {
				unit[me.id].setMessage("NOT ALLOWED");
			} else {
				unit[me.id].setPage(unit[me.id].lastFmcPage);
			}
		} else {
			unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};

var Ref = {
	new: func(n) {
		var m = {parents: [Ref]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 0, 0, 0],
			CTranslate: [0, 0, 0, 0, 0, 0],
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
			C6L: "",
			C6: "",
			
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: " DEFINED",
			L1: "<WAYPOINT",
			L2L: "",
			L2: "<WAYPOINT",
			L3L: " CLOSEST",
			L3: "<AIRPORTS",
			L4L: "",
			L4: "<POS REF",
			L5L: "",
			L5: "<A/C STATUS",
			L6L: "",
			L6: "<SENSOR STATUS",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "",
			R1: "",
			R2L: "",
			R2: "NAVAID>",
			R3L: "",
			R3: "ACARS>",
			R4L: "",
			R4: "DOC DATA>",
			R5L: "",
			R5: "MAINT>",
			R6L: "MEMORY ",
			R6: "READOUT>",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "REF INDEX",
			titleTranslate: 0,
		};
		
		m.group = "fmc";
		m.name = "ref";
		m.nextPage = "none";
		m.scratchpadState = 0;
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
	},
	softKey: func(k) {
		if (k == "l3") {
			unit[me.id].setPage("closestAirports");
		} else if (k == "l4") {
			unit[me.id].setPage("posRef");
		} else if (k == "l5") {
			unit[me.id].setPage("acStatus");
		} else if (k == "l6") {
			unit[me.id].setPage("sensorStatus");
		} else {
			unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};
