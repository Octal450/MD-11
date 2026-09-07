# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2026 Josh Davidson (Octal450)

var Fpln = {
	new: func(n) {
		var m = {parents: [Fpln]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.small, FONT.small, FONT.small, FONT.small, FONT.small, FONT.small],
			CLTranslate: [-2, -2, -2, -2, -2, -2],
			CTranslate: [-2, -2, -2, -2, -2, -2],
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
			
			RFont: [FONT.small, FONT.small, FONT.small, FONT.small, FONT.small, FONT.small],
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
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "ACT F-PLN",
			titleTranslate: -1,
		};
		
		m.group = "fmc";
		m.name = "fpln";
		m.nextPage = "handled";
		m.scratchpad = "";
		m.scratchpadSize = 0;
		m.scratchpadState = 0;
		
		m.Value = {
			index: 0,
			indexStart: 0,
			indexStartCalc: 0,
			list: [nil, nil, nil, nil, nil, nil],
			page: 0,
			result: 0,
			size: 0,
			wpIndex: 0,
		};
		
		return m;
	},
	setup: func() {
		me.Value.page = 0;
	},
	loop: func() {
		if (me.Value.page) {
			me.Display.C1L = "DIST";
			me.Display.pageNum = "2/2";
			me.Display.R1L = "gC   WIND  ";
		} else {
			if (fms.Internal.phase == 0) {
				me.Display.C1L = " ETE";
			} else {
				me.Display.C1L = " ETO";
			}
			me.Display.pageNum = "1/2";
			me.Display.R1L = "SPD   ALT ";
		}
		
		me.Value.size = fms.FPList.list[0].size();
		
		if (me.Value.size <= 6) { # No scrolling if the list is too short
			me.Value.indexStart = 0;
		}
		
		for (var i = 0; i < 6; i += 1) {
			me.Value.index = i + me.Value.indexStart;
			if (me.Value.index >= me.Value.size) me.Value.index = me.Value.index - me.Value.size;
			
			if (i < me.Value.size) {
				me.Value.list[i] = fms.FPList.list[0].vector[me.Value.index];
			} else {
				me.Value.list[i] = nil;
			}
			
			if (me.Value.list[i] != nil) {
				if (me.Value.list[i].type == "static") {
					me.Display["L" ~ (i + 1) ~ "L"] = "";
					me.Display["L" ~ (i + 1)] = me.Value.list[i].text;
					
					if (i > 0) { # C1L is fixed
						me.Display["C" ~ (i + 1) ~ "L"] = "";
					}
					
					me.Display["C" ~ (i + 1)] = "";
					me.Display["R" ~ (i + 1)] = "";
				} else if (me.Value.list[i].id == "DISCONTINUITY") {
					me.Display["L" ~ (i + 1) ~ "L"] = "";
					me.Display["L" ~ (i + 1)] = "---F-PLN DISCONTINUITY--";
					
					if (i > 0) { # C1L is fixed
						me.Display["C" ~ (i + 1) ~ "L"] = "";
					}
					
					me.Display["C" ~ (i + 1)] = "";
					me.Display["R" ~ (i + 1)] = "";
				} else {
					me.Value.wpIndex = fms.FPList.list[0].index(me.Value.list[i]);
					if (me.Value.wpIndex == 0) {
						me.Display["L" ~ (i + 1) ~ "L"] = " FROM";
					} else {
						me.Display["L" ~ (i + 1) ~ "L"] = "";
					}
					
					if (i > 0) { # C1L is fixed
						if (me.Value.page and me.Value.wpIndex != 0 and me.Value.list[i - 1].id != "DISCONTINUITY") { # i - 1 is safe as this doesn't run for i = 0
							me.Display["C" ~ (i + 1) ~ "L"] = sprintf("%4d", math.round(me.Value.list[i].leg_distance));
						} else {
							me.Display["C" ~ (i + 1) ~ "L"] = "";
						}
					}
					
					me.Display["L" ~ (i + 1)] = me.Value.list[i].id;
					if (me.Value.page) {
						me.Display["C" ~ (i + 1)] = "";
						
						me.Display["R" ~ (i + 1)] = "-- ---g/---";
					} else {
						me.Display["C" ~ (i + 1)] = "----";
						me.Display["R" ~ (i + 1)] = "---/ -----";
					}
				}
			} else {
				me.Display["L" ~ (i + 1) ~ "L"] = "";
				me.Display["L" ~ (i + 1)] = "";
				me.Display["C" ~ (i + 1)] = "";
				me.Display["R" ~ (i + 1)] = "";
			}
		}
	},
	latRev: func(i) {
		if (me.Value.list[i] != nil) {
			if (me.Value.list[i].type == "wp") {
				if (me.scratchpadState == 2) {
					if (me.Value.list[i].index == 0) { # Can't replace FROM waypoint
						unit[me.id].setMessage("NOT ALLOWED");
					} else {
						me.scratchpadSize = size(me.scratchpad);
						
						if (me.scratchpadSize == 5) { # Fix
							me.Value.result = fms.FPController.insertWp(0, me.Value.list[i].index, "fix", me.scratchpad);
						} else if (me.scratchpadSize >= 1 and me.scratchpadSize <= 3) { # Navaid
							me.Value.result = fms.FPController.insertWp(0, me.Value.list[i].index, "navaid", me.scratchpad);
						} else if (me.scratchpadSize == 4) { # Airport
							me.Value.result = fms.FPController.insertWp(0, me.Value.list[i].index, "airport", me.scratchpad);
						} else {
							unit[me.id].setMessage("FORMAT ERROR");
							return;
						}	
						
						if (me.Value.result == 2) {
							unit[me.id].setPage("duplicateWp");
							unit[me.id].setMessage("DUP WP NOT SUPPORTED");
						} else if (me.Value.result == 1) {
							unit[me.id].setMessage("NOT IN DATA BASE");
						} else {
							unit[me.id].scratchpadClear();
						}
					}
				} else if (me.scratchpadState == 0) {
					if (me.Value.list[i].index == 0) { # Can't remove FROM waypoint
						unit[me.id].setMessage("NOT ALLOWED");
					} else {
						fms.FPController.removeWp(0, me.Value.list[i].index);
						unit[me.id].scratchpadClear();
					}
				} else {
					
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else {
			unit[me.id].setMessage("NOT ALLOWED");
		}
	},
	vertRev: func(i) {
		unit[me.id].setMessage("NOT ALLOWED");
	},
	arrowKey: func(d) {
		if (me.Value.size > 6) {
			me.Value.indexStartCalc = me.Value.indexStart + d;
			
			if (me.Value.indexStartCalc > me.Value.size) me.Value.indexStart = 0;
			else if (me.Value.indexStartCalc < 0) me.Value.indexStart = me.Value.size;
			else me.Value.indexStart = me.Value.indexStartCalc;
		} else {
			me.Value.indexStart = 0;
			unit[me.id].setMessage("NOT ALLOWED");
		}
	},
	nextPageKey: func() {
		me.Value.page = !me.Value.page;
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l1") {
			me.latRev(0);
		} else if (k == "l2") {
			me.latRev(1);
		} else if (k == "l3") {
			me.latRev(2);
		} else if (k == "l4") {
			me.latRev(3);
		} else if (k == "l5") {
			me.latRev(4);
		} else if (k == "l6") {
			me.latRev(5);
		} else if (k == "r1") {
			me.vertRev(0);
		} else if (k == "r2") {
			me.vertRev(1);
		} else if (k == "r3") {
			me.vertRev(2);
		} else if (k == "r4") {
			me.vertRev(3);
		} else if (k == "r5") {
			me.vertRev(4);
		} else if (k == "r6") {
			me.vertRev(5);
		}
	},
};

var DuplicateWp = {
	new: func(n) {
		var m = {parents: [DuplicateWp]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [-2, 0, 0, 0, 0, 0],
			CTranslate: [-1, -1, -1, -1, -1, -1],
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
			R1L: "FREQ ",
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
			R6: "ACT F-PLN>",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "DUPLICATE NAMES",
			titleTranslate: 0,
		};
		
		m.group = "fmc";
		m.name = "duplicateWp";
		m.nextPage = "none";
	
		m.Value = {
		};
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
	},
	arrowKey: func(d) {
	},
	softKey: func(k) {
		if (k = "r6") {
			unit[me.id].setPage("fpln");
		} else {
			unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};
