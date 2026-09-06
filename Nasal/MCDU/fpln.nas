# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2026 Josh Davidson (Octal450)

var Fpln = {
	new: func(n) {
		var m = {parents: [Fpln]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [-2, -2, -2, -2, -2, -2],
			CTranslate: [-2, -2, -2, -2, -2, -2],
			C1L: " ETE",
			C1: "----",
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
			
			pageNum: "1/2",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "SPD   ALT ",
			R1: "---/ -----",
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
		m.nextPage = "none";
		m.type = 1;
		
		m.Value = {
			index: 0,
			indexStart: 0,
			indexStartCalc: 0,
			list: [nil, nil, nil, nil, nil, nil],
			size: 0,
		};
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
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
					me.Display["L" ~ (i + 1)] = me.Value.list[i].text;
					me.Display["L" ~ (i + 1) ~ "L"] = "";
					me.Display["C" ~ (i + 1)] = "";
					me.Display["R" ~ (i + 1)] = "";
				} else if (me.Value.list[i].id == "DISCONTINUITY") {
					me.Display["L" ~ (i + 1)] = "---F-PLN DISCONTINUITY--";
					me.Display["L" ~ (i + 1) ~ "L"] = "";
					me.Display["C" ~ (i + 1)] = "";
					me.Display["R" ~ (i + 1)] = "";
				} else {
					me.Display["L" ~ (i + 1)] = me.Value.list[i].id;
					me.Display["C" ~ (i + 1)] = "----";
					me.Display["R" ~ (i + 1)] = "---/ -----";
					
					if (fms.FPList.list[0].index(me.Value.list[i]) == 0) {
						me.Display["L" ~ (i + 1) ~ "L"] = " FROM";
					} else {
						me.Display["L" ~ (i + 1) ~ "L"] = "";
					}
				}
			} else {
				me.Display["L" ~ (i + 1)] = "";
				me.Display["L" ~ (i + 1) ~ "L"] = "";
				me.Display["C" ~ (i + 1)] = "";
				me.Display["R" ~ (i + 1)] = "";
			}
		}
	},
	arrowKey: func(d) {
		if (me.Value.size > 6) {
			me.Value.indexStartCalc = me.Value.indexStart + d;
			
			if (me.Value.indexStartCalc > me.Value.size) me.Value.indexStart = 0;
			else if (me.Value.indexStartCalc < 0) me.Value.indexStart = me.Value.size;
			else me.Value.indexStart = me.Value.indexStartCalc;
		} else {
			me.Value.indexStart = 0;
		}
	},
	softKey: func(k) {
		unit[me.id].setMessage("NOT ALLOWED");
	},
};
