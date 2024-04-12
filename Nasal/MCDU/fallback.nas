# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)

var Fallback = {
	new: func(n) {
		var m = {parents: [Fallback]};
		
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
			L1S: "",
			L1: "",
			L2S: "",
			L2: "",
			L3S: "",
			L3: "",
			L4S: "",
			L4: "",
			L5S: "",
			L5: "",
			L6S: "",
			L6: "",
			
			pageNum: "",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1S: "",
			R1: "",
			R2S: "",
			R2: "",
			R3S: "",
			R3: "",
			R4S: "",
			R4: "",
			R5S: "",
			R5: "",
			R6S: "",
			R6: "",
			
			title: "PAGE NOT AVAIL",
		};
		
		m.group = "base";
		m.name = "fallback";
		m.nextPage = "none";
		m.type = 1;
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
	},
	softKey: func(k) {
		mcdu.unit[me.id].setMessage("NOT ALLOWED");
	},
};
