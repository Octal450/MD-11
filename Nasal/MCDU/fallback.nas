# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2021 Josh Davidson (Octal450)

var Fallback = {
	new: func(n) {
		var m = {parents: [Fallback]};
		
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
			L4: "",
			L4S: "",
			L5: "",
			L5S: "",
			L6: "",
			L6S: "",
			
			pageNum: "",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1: "",
			R1S: "",
			R2: "",
			R2S: "",
			R3: "",
			R3S: "",
			R4: "",
			R4S: "",
			R5: "",
			R5S: "",
			R6: "",
			R6S: "",
			
			simple: 1,
			title: "PAGE NOT AVAIL",
		};
		
		m.group = "base";
		m.name = "fallback";
		m.nextPage = "none";
		m.type = 1;
		
		return m;
	},
	tempReset: func() {
		# Placeholder
	},
	loop: func() {
		# Placeholder
	},
	softKey: func(k) {
		mcdu.unit[me.id].setMessage("NOT ALLOWED");
	},
};
