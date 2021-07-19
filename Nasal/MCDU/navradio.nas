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
			L3: "",
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
			R3: "",
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
			adfSet: [0, 0],
		};
		
		return m;
	},
	reset: func() {
		me.setup();
	},
	setup: func() {
		me.Value.adfSet[0] = 0;
		me.Value.adfSet[1] = 0;
	},
	loop: func() {
		if (me.Value.adfSet[0]) {
			me.Display.L3 = sprintf("%4.1f", math.round(pts.Instrumentation.Adf.Frequencies.selectedKhz[0].getValue(), 0.1));
		} else {
			me.Display.L3 = "[  ]";
		}
		
		if (me.Value.adfSet[1]) {
			me.Display.R3 = sprintf("%4.1f", math.round(pts.Instrumentation.Adf.Frequencies.selectedKhz[1].getValue(), 0.1));
		} else {
			me.Display.R3 = "[  ]";
		}
	},
	softKey: func(k) {
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		
		if (mcdu.unit[me.id].scratchpadState() == 2) {
			if (k == "l3") {
				if (mcdu.unit[me.id].scratchpadIsNumber() and mcdu.unit[me.id].scratchpadLengthInRange(3, 6) and me.scratchpad >= 0) {
					if (mcdu.unit[me.id].scratchpadDecimalLengthInRange(0, 1)) {
						if (me.scratchpad >= 190 and me.scratchpad <= 1750) {
							pts.Instrumentation.Adf.Frequencies.selectedKhz[0].setValue(me.scratchpad);
							me.Value.adfSet[0] = 1;
							mcdu.unit[me.id].scratchpadClear();
						} else {
							mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
						}
					} else {
						mcdu.unit[me.id].setMessage("FORMAT ERROR");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (k == "r3") {
				if (mcdu.unit[me.id].scratchpadIsNumber() and mcdu.unit[me.id].scratchpadLengthInRange(3, 6) and me.scratchpad >= 0) {
					if (mcdu.unit[me.id].scratchpadDecimalLengthInRange(0, 1)) {
						if (me.scratchpad >= 190 and me.scratchpad <= 1750) {
							pts.Instrumentation.Adf.Frequencies.selectedKhz[1].setValue(me.scratchpad);
							me.Value.adfSet[1] = 1;
							mcdu.unit[me.id].scratchpadClear();
						} else {
							mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
						}
					} else {
						mcdu.unit[me.id].setMessage("FORMAT ERROR");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (mcdu.unit[me.id].scratchpadState() == 0) {
			if (k == "l3") {
				if (me.Value.adfSet[0]) {
					me.Value.adfSet[0] = 0;
					pts.Instrumentation.Adf.Frequencies.selectedKhz[0].setValue(0);
					mcdu.unit[me.id].scratchpadClear();
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			} else if (k == "r3") {
				if (me.Value.adfSet[1]) {
					me.Value.adfSet[1] = 0;
					pts.Instrumentation.Adf.Frequencies.selectedKhz[1].setValue(0);
					mcdu.unit[me.id].scratchpadClear();
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};
