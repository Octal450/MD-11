# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)

var Menu = {
	new: func(n, t) {
		var m = {parents: [Menu]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			CSTranslate: [0, 0, 0, 0, 0, 0],
			CTranslate: [-60, 0, 0, 0, 0, 0],
			C1S: "",
			C1: "",
			C2S: "",
			C2: "",
			C3S: "",
			C3: "",
			C4S: "",
			C4: "",
			C5S: "",
			C5: "",
			C6S: "",
			C6: "",
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1S: "",
			L1: "",
			L2S: "",
			L2: "",
			L3S: "",
			L3: "",
			L4S: "",
			L4: "<CDFS",
			L5S: "",
			L5: "",
			L6S: "",
			L6: "",
			
			pageNum: "",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1S: "STANDBY",
			R1: "",
			R2S: "",
			R2: "",
			R3S: "",
			R3: "",
			R4S: "",
			R4: "",
			R5S: "",
			R5: "MAINT>",
			R6S: "",
			R6: "",
			
			title: "MENU",
		};
		
		if (t) {
			m.Display.L1 = "";
			m.Display.R1 = "F-PLN*";
		} else {
			m.Display.L1 = "<FMC-" ~ sprintf("%s", n + 1);
			m.Display.R1 = "NAV/RAD*";
		}
		
		m.group = "base";
		m.name = "menu";
		m.nextPage = "none";
		m.type = t;
		
		m.Value = {
			request: 1,
		};
		
		return m;
	},
	reset: func() {
		me.setup();
	},
	setup: func() {
		me.Value.request = 1;
	},
	loop: func() {
		if (me.type) {
			me.Display.C1 = "";
		} else if (me.Value.request) {
			me.Display.C1 = "<REQ>";
		} else {
			me.Display.C1 = "<ACT>";
		}
	},
	softKey: func(k) {
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		if (me.scratchpadState == 1) {
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

var Ref = {
	new: func(n) {
		var m = {parents: [Ref]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			CSTranslate: [0, 0, 0, 0, 0, 0],
			CTranslate: [0, 0, 0, 0, 0, 0],
			C1S: "",
			C1: "",
			C2S: "",
			C2: "",
			C3S: "",
			C3: "",
			C4S: "",
			C4: "",
			C5S: "",
			C5: "",
			C6S: "",
			C6: "",
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1S: " DEFINED",
			L1: "<WAYPOINT",
			L2S: "",
			L2: "<WAYPOINT",
			L3S: " CLOSEST",
			L3: "<AIRPORTS",
			L4S: "",
			L4: "<POS REF",
			L5S: "",
			L5: "<A/C STATUS",
			L6S: "",
			L6: "<SENSOR STATUS",
			
			pageNum: "",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1S: "",
			R1: "",
			R2S: "",
			R2: "NAVAID>",
			R3S: "",
			R3: "ACARS>",
			R4S: "",
			R4: "DOC DATA>",
			R5S: "",
			R5: "MAINT>",
			R6S: "MEMORY ",
			R6: "READOUT>",
			
			title: "REF INDEX",
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
		# Placeholder
	},
	softKey: func(k) {
		if (k == "l3") {
			mcdu.unit[me.id].setPage("closestAirports");
		} else if (k == "l4") {
			mcdu.unit[me.id].setPage("posRef");
		} else if (k == "l5") {
			mcdu.unit[me.id].setPage("acStatus");
		} else if (k == "l6") {
			mcdu.unit[me.id].setPage("sensorStatus");
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};
