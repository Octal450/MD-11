# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2021 Josh Davidson (Octal450)

var NavRadio = {
	new: func(n) {
		var m = {parents: [NavRadio]};
		
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
			C6S: "PRESELECT",
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1: "[  ]/[ ]g",
			L1S: "VOR1/CRS",
			L2: "",
			L2S: "",
			L3: "[  ]",
			L3S: "ADF1",
			L4: "[  ]/[ ]g",
			L4S: "ILS/CRS",
			L5: "",
			L5S: "",
			L6: "[   ]/[   ]",
			L6S: "",
			
			pageNum: "",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1: "[  ]/[ ]g",
			R1S: "VOR2/CRS",
			R2: "",
			R2S: "",
			R3: "[  ]",
			R3S: "ADF2",
			R4: "",
			R4S: "",
			R5: "",
			R5S: "",
			R6: "[   ]/[   ]",
			R6S: "",
			
			simple: 1,
			title: "NAV RADIO",
		};
		
		m.group = "fmc";
		m.name = "navRadio";
		m.nextPage = "none";
		m.scratchpad = "";
		
		m.Value = {
			
		};
		
		return m;
	},
	reset: func() {
		me.setup();
	},
	setup: func() {
		
	},
	loop: func() {
		
	},
	softKey: func(k) {
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		
		mcdu.unit[me.id].setMessage("NOT ALLOWED"); # Temporary
	},
};
