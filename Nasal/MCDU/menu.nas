# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2021 Josh Davidson (Octal450)

var Menu = {
	new: func(n, t) {
		var m = {parents: [Menu]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			C1: "",
			C1S: "",
			C2: "",
			C2S: "",
			C3: "",
			C3S: "",
			C4: "",
			C4S: "",
			C5: "",
			C5S: "",
			C6: "",
			C6S: "",
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1: "",
			L1S: "",
			L2: "",
			L2S: "",
			L3: "",
			L3S: "",
			L4: "<CDFS",
			L4S: "",
			L5: "",
			L5S: "",
			L6: "",
			L6S: "",
			
			pageNum: "",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1: "NAV/RAD*",
			R1S: "STANDBY",
			R2: "",
			R2S: "",
			R3: "",
			R3S: "",
			R4: "",
			R4S: "",
			R5: "MAINT>",
			R5S: "",
			R6: "",
			R6S: "",
			
			simple: 1,
			title: "MENU",
		};
		
		if (t) {
			m.Display.L1 = "";
		} else {
			m.Display.L1 = "<FMC-" ~ sprintf("%s", n + 1);
		}
		
		m.group = "fmc";
		m.nextPage = "none";
		m.type = t;
		
		m.Value = {
			request: 1,
		};
		
		return m;
	},
	reset: func() {
		me.tempReset();
		me.Value.request = 1;
	},
	tempReset: func() {
		# Placeholder
	},
	loop: func() {
		if (me.type) {
			me.Display.C1 = "";
		} else if (me.Value.request) {
			me.Display.C1 = "<REQ>  ";
		} else {
			me.Display.C1 = "<ACT>  ";
		}
	},
	softKey: func(k) {
		if (mcdu.unit[me.id].scratchpadState() == 1) {
			if (k == "l1" and !me.type) {
				if (me.Value.request) {
					me.Value.request = 0;
				} else {
					mcdu.unit[me.id].setPage(mcdu.unit[me.id].lastFmcPage);
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};
