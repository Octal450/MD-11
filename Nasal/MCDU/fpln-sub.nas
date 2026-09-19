# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2026 Josh Davidson (Octal450)

var DuplicateWp = {
	new: func(n) {
		var m = {parents: [DuplicateWp]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [-2, 0, 0, 0, 0, 0],
			CTranslate: [-2, -2, -2, -2, -2, -2],
			C1L: "LAT/LONG",
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
			L4: "",
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
			R6L: "RETURN TO ",
			R6: "",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			scrollD: 0,
			scrollU: 0,
			
			title: "DUPLICATE NAMES",
			titleSmall: "",
			titleSmallTranslate: 0,
			titleTranslate: 0,
		};
		
		m.fromPage = "";
		m.group = "fmc";
		m.name = "duplicateWp";
		m.nextPage = "none";
		m.scratchpad = "";
		m.scratchpadState = 0;
		
		m.Value = {
			index: 0,
			indexStart: 0,
			indexStartCalc: 0,
			list: [nil, nil, nil, nil, nil],
			size: 0,
			wpIndex: 0,
		};
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		me.Value.size = unit[me.id].Data.duplicateWpInfo.wpVector.size();
		
		if (unit[me.id].Data.duplicateWpInfo.type == "fix") {
			me.Display.R1L = "";
		} else {
			me.Display.R1L = "FREQ ";
		}
		
		if (me.Value.size <= 5) { # No scrolling if the list is too short
			me.Display.scrollD = 0;
			me.Display.scrollU = 0;
			me.Value.indexStart = 0;
		} else {
			if (me.Value.indexStart == 0) {
				me.Display.scrollD = 0;
				me.Display.scrollU = 1;
			} else if (me.Value.indexStart == (me.Value.size - 5)) {
				me.Display.scrollD = 1;
				me.Display.scrollU = 0;
			} else {
				me.Display.scrollD = 1;
				me.Display.scrollU = 1;
			}
		}
		
		for (var i = 0; i < 5; i += 1) {
			me.Value.index = i + me.Value.indexStart;
			
			if (i < me.Value.size) {
				me.Value.list[i] = unit[me.id].Data.duplicateWpInfo.wpVector.vector[me.Value.index];
			} else {
				me.Value.list[i] = nil;
			}
			
			if (me.Value.list[i] != nil) {
				me.Display["L" ~ (i + 1) ~ "L"] = sprintf("%4d", math.round(courseAndDistance(me.Value.list[i])[1])) ~ " NM";
				me.Display["L" ~ (i + 1)] = "*" ~ me.Value.list[i].id;
				me.Display["C" ~ (i + 1)] = me.formatLatLon(me.Value.list[i].lat, me.Value.list[i].lon);
				
				if (unit[me.id].Data.duplicateWpInfo.type != "navaid") {
					me.Display["R" ~ (i + 1)] = "";
				} else if (me.Value.list[i].type == "NDB") {
					me.Display["R" ~ (i + 1)] = sprintf("%5.1f", me.Value.list[i].frequency / 100);
				} else {
					me.Display["R" ~ (i + 1)] = sprintf("%6.2f", me.Value.list[i].frequency / 100);
				}
			} else {
				me.Display["L" ~ (i + 1) ~ "L"] = "";
				me.Display["L" ~ (i + 1)] = "";
				me.Display["C" ~ (i + 1)] = "";
				me.Display["R" ~ (i + 1)] = "";
			}
		}
		
		if (unit[me.id].lastFmcPage == "latRev") {
			me.fromPage = "latRev";
			me.Display.R6 = "LAT REV>";
		} else {
			me.fromPage = "fpln";
			me.Display.R6 = "FPLN>";
		}
	},
	formatLatLon: func(lat, lon) {
		var latHemi = lat >= 0 ? "N" : "S";
		var lonHemi = lon >= 0 ? "E" : "W";
		
		var latDeg = math.abs(lat);
		var lonDeg = math.abs(lon);
		
		return latHemi ~ sprintf("%02d", latDeg) ~ "/" ~ lonHemi ~ sprintf("%03d", lonDeg);
	},
	insert: func(i) {
		if (me.Value.list[i] != nil and me.scratchpadState == 1) {
			if (unit[me.id].Data.duplicateWpInfo.index <= fms.FPController.plan[unit[me.id].Data.duplicateWpInfo.plan].getPlanSize()) {
				fms.FPController.insertGhost(unit[me.id].Data.duplicateWpInfo.plan, unit[me.id].Data.duplicateWpInfo.index, me.Value.list[i]);
				unit[me.id].setPage("fpln");
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else {
			unit[me.id].setMessage("NOT ALLOWED");
		}
	},
	arrowKey: func(d) { # No wraparound
		if (me.Value.size > 5) {
			me.Value.indexStartCalc = me.Value.indexStart + d;
			
			if (me.Value.indexStartCalc > (me.Value.size - 5)) {
				me.Value.indexStart = me.Value.size - 5;
				unit[me.id].setMessage("NOT ALLOWED");
			} else if (me.Value.indexStartCalc < 0) {
				me.Value.indexStart = 0;
				unit[me.id].setMessage("NOT ALLOWED");
			} else {
				me.Value.indexStart = me.Value.indexStartCalc;
			}
		} else {
			me.Value.indexStart = 0;
			unit[me.id].setMessage("NOT ALLOWED");
		}
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l1") {
			me.insert(0);
		} else if (k == "l2") {
			me.insert(1);
		} else if (k == "l3") {
			me.insert(2);
		} else if (k == "l4") {
			me.insert(3);
		} else if (k == "l5") {
			me.insert(4);
		} else if (k == "l6") {
			me.insert(5);
		} else if (k == "r6") {
			unit[me.id].setPage(me.fromPage);
		} else {
			unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};

var LatRev = {
	new: func(n) {
		var m = {parents: [LatRev]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [-6, 0, 0, 0, 0, 0],
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
			L1L: "",
			L1: "",
			L2L: "",
			L2: "",
			L3L: "",
			L3: "",
			L4L: " NEXT WPT",
			L4: "*[     ]",
			L5L: "",
			L5: "",
			L6L: "",
			L6: "",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.small],
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
			R2: "HOLD>",
			R3L: "",
			R3: "",
			R4L: "NEW CO RTE ",
			R4: "[        ]*",
			R5L: "NEW DEST ",
			R5: "[   ]*",
			R6L: "RETURN TO ",
			R6: "ACT F-PLN>",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			scrollD: 0,
			scrollU: 0,
			
			title: "",
			titleSmall: "  FROM",
			titleSmallTranslate: 1,
			titleTranslate: 0,
		};
		
		m.group = "fmc";
		m.name = "latRev";
		m.nextPage = "none";
		m.scratchpad = "";
		m.scratchpadSize = 0;
		m.scratchpadState = 0;
		
		m.Value = {
			airportFrom: 0,
			idSize: 0,
			info: nil,
		};
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		me.Value.info = unit[me.id].Data.latRevInfo;
		
		me.Display.title = "LAT REV      " ~ me.Value.info.wp.id;
		me.Value.idSize = size(me.Value.info.wp.id);
		if (me.Value.idSize == 5) {
			me.Display.titleTranslate = 1;
		} else if (me.Value.idSize == 3 or me.Value.idSize == 4) {
			me.Display.titleTranslate = 0;
		} else if (me.Value.idSize <= 2) {
			me.Display.titleTranslate = -1;
		} else { # Should never be
			me.Display.titleTranslate = 0;
		}
		me.Display.C1L = FORMAT.Position.formatGhost(me.Value.info.wp);
		
		if (me.Value.info.plan == 1) me.Value.airportFrom = fms.flightData.airportTo;
		else me.Value.airportFrom = fms.flightData.airportFrom;
		
		if (me.Value.info.wp.id == "PPOS" or me.Value.info.wp.id == "T-P") {
			me.Display.L1 = "";
			me.Display.L2 = "";
			me.Display.R1 = "";
			me.Display.R3L = "";
			me.Display.R3 = "";
		} else if (fms.Internal.phase == 0 and me.Value.info.wp.index == 0 and me.Value.info.wp.id == me.Value.airportFrom) { # This needs to check if we're the departure runway also for entered RW/SID
			if (me.Value.info.plan == 1) {
				me.Display.L1 = "";
			} else {
				me.Display.L1 = "<SID";
			}
			
			me.Display.L2 = "";
			me.Display.R1 = "";
			me.Display.R3L = "";
			me.Display.R3 = "";
		} else {
			me.Display.L1 = "";
			
			# Airports cannot enter airways
			#if (me.Value.info.wp.wp_type != "airport" and me.Value.info.wp.wp_type != "runway") { # Why are these returning navaid?
			if (size(me.Value.info.wp.id) != 4) {
				me.Display.L2 = "<AIRWAYS";
			} else {
				me.Display.L2 = "";
			}
			
			if (fms.flightData.airportTo != "") {
				me.Display.R1 = "STAR>";
				me.Display.R3L = "PROCEDURE ";
				me.Display.R3 = "TURN>";
			} else {
				me.Display.R1 = "";
				me.Display.R3L = "";
				me.Display.R3 = "";
			}
		}
		
		if (fms.flightData.airportAltn != "" and me.Value.info.plan != 1) {
			me.Display.L6L = " ENABLE ALTN";
			me.Display.L6 = "*   " ~ fms.flightData.airportAltn;
			me.Display.L6B = " TO";
		} else {
			me.Display.L6L = "";
			me.Display.L6 = "";
			me.Display.L6B = "";
		}
	},
	arrowKey: func(d) {
		unit[me.id].setMessage("NOT ALLOWED");
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l4") {
			if (me.scratchpadState == 2) {
				me.scratchpadSize = size(me.scratchpad);
				
				if (me.scratchpadSize == 5) { # Fix
					me.Value.result = fms.FPController.insertWp(me.Value.info.plan, me.Value.info.index + 1, "fix", me.scratchpad, me.id);
				} else if (me.scratchpadSize >= 1 and me.scratchpadSize <= 3) { # Navaid
					me.Value.result = fms.FPController.insertWp(me.Value.info.plan, me.Value.info.index + 1, "navaid", me.scratchpad, me.id);
				} else if (me.scratchpadSize == 4) { # Airport
					me.Value.result = fms.FPController.insertWp(me.Value.info.plan, me.Value.info.index + 1, "airport", me.scratchpad, me.id);
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
					return;
				}	
				
				if (me.Value.result == 2) {
					unit[me.id].scratchpadClear();
					unit[me.id].setPage("duplicateWp");
				} else if (me.Value.result == 1) {
					unit[me.id].setMessage("NOT IN DATA BASE");
				} else {
					unit[me.id].scratchpadClear();
					unit[me.id].setPage("fpln");
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r6") {
			unit[me.id].setPage("fpln");
		} else {
			unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};
