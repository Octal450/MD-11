# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2023 Josh Davidson (Octal450)

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
			L1: "",
			L1S: "VOR1/CRS",
			L2: "",
			L2S: "",
			L3: "",
			L3S: "ADF1",
			L4: "",
			L4S: "ILS/CRS",
			L5: "",
			L5S: "",
			L6: "[   ]/[   ]",
			L6S: "",
			
			pageNum: "",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1: "",
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
		m.scratchpadSplit = nil;
		m.scratchpadState = 0;
		
		return m;
	},
	commonValue: {
		adfSet: [0, 0],
		navCrsSet: [0, 0, 0],
		navSet: [0, 0, 0],
	},
	reset: func() {
		me.setup();
	},
	setup: func() {
		me.commonValue.adfSet[0] = 0;
		me.commonValue.adfSet[1] = 0;
		me.commonValue.navCrsSet[0] = 0;
		me.commonValue.navCrsSet[1] = 0;
		me.commonValue.navCrsSet[2] = 0;
		me.commonValue.navSet[0] = 0;
		me.commonValue.navSet[1] = 0;
		me.commonValue.navSet[2] = 0;
	},
	loop: func() {
		if (me.commonValue.navSet[0]) {
			if (me.commonValue.navCrsSet[0]) {
				me.Display.L1 = sprintf("%5.2f", math.round(pts.Instrumentation.Nav.Frequencies.selectedMhz[0].getValue(), 0.01)) ~ "/" ~ sprintf("%03d", pts.Instrumentation.Nav.Radials.selectedDeg[0].getValue()) ~ "g";
			} else {
				me.Display.L1 = sprintf("%5.2f", math.round(pts.Instrumentation.Nav.Frequencies.selectedMhz[0].getValue(), 0.01)) ~ "/[ ]g";
			}
		} else {
			me.Display.L1 = "[  ]/[ ]g";
			me.Display.L2 = "";
		}
		
		if (me.commonValue.navSet[1]) {
			if (me.commonValue.navCrsSet[1]) {
				me.Display.R1 = sprintf("%5.2f", math.round(pts.Instrumentation.Nav.Frequencies.selectedMhz[1].getValue(), 0.01)) ~ "/" ~ sprintf("%03d", pts.Instrumentation.Nav.Radials.selectedDeg[1].getValue()) ~ "g";
			} else {
				me.Display.R1 = sprintf("%5.2f", math.round(pts.Instrumentation.Nav.Frequencies.selectedMhz[1].getValue(), 0.01)) ~ "/[ ]g";
			}
		} else {
			me.Display.R1 = "[  ]/[ ]g";
		}
		
		if (me.commonValue.navSet[2]) {
			if (me.commonValue.navCrsSet[2]) {
				me.Display.L4 = sprintf("%5.2f", math.round(pts.Instrumentation.Nav.Frequencies.selectedMhz[2].getValue(), 0.01)) ~ "/" ~ sprintf("%03d", pts.Instrumentation.Nav.Radials.selectedDeg[2].getValue()) ~ "g";
			} else {
				me.Display.L4 = sprintf("%5.2f", math.round(pts.Instrumentation.Nav.Frequencies.selectedMhz[2].getValue(), 0.01)) ~ "/[ ]g";
			}
		} else {
			me.Display.L4 = "[  ]/[ ]g";
		}
		
		if (me.commonValue.adfSet[0]) {
			me.Display.L3 = sprintf("%4.1f", math.round(pts.Instrumentation.Adf.Frequencies.selectedKhz[0].getValue(), 0.1));
		} else {
			me.Display.L3 = "[  ]";
		}
		
		if (me.commonValue.adfSet[1]) {
			me.Display.R3 = sprintf("%4.1f", math.round(pts.Instrumentation.Adf.Frequencies.selectedKhz[1].getValue(), 0.1));
		} else {
			me.Display.R3 = "[  ]";
		}
		
		if (me.commonValue.navSet[0] and me.commonValue.navCrsSet[0]) {
			if (afs.Output.lat.getValue() == 2 and afs.Internal.radioSel.getValue() == 0) {
				me.Display.LFont[1] = FONT.normal;
				me.Display.L2 = "VOR TRACK";
			} else if (afs.Output.locArm.getBoolValue() and afs.Input.radioSel.getValue() == 0) {
				me.Display.LFont[1] = FONT.normal;
				me.Display.L2 = "VOR ARMED";
			} else {
				me.Display.LFont[1] = FONT.small;
				me.Display.L2 = "*VOR ARM";
			}
		} else {
			me.Display.L2 = "";
		}
		
		if (me.commonValue.navSet[1] and me.commonValue.navCrsSet[1]) {
			if (afs.Output.lat.getValue() == 2 and afs.Internal.radioSel.getValue() == 1) {
				me.Display.RFont[1] = FONT.normal;
				me.Display.R2 = "VOR TRACK";
			} else if (afs.Output.locArm.getBoolValue() and afs.Input.radioSel.getValue() == 1) {
				me.Display.RFont[1] = FONT.normal;
				me.Display.R2 = "VOR ARMED";
			} else {
				me.Display.RFont[1] = FONT.small;
				me.Display.R2 = "VOR ARM*";
			}
		} else {
			me.Display.R2 = "";
		}
		
		if (me.commonValue.navSet[2] and me.commonValue.navCrsSet[2]) {
			if (afs.Internal.locOnly and afs.Output.lat.getValue() == 2 and afs.Internal.radioSel.getValue() == 2) {
				me.Display.LFont[4] = FONT.normal;
				me.Display.L5 = "LOC ONLY";
			} else if (afs.Internal.locOnly and afs.Output.locArm.getBoolValue() and afs.Input.radioSel.getValue() == 2) {
				me.Display.LFont[4] = FONT.normal;
				me.Display.L5 = "LOC ONLY";
			} else {
				me.Display.LFont[4] = FONT.small;
				me.Display.L5 = "*LOC ONLY";
			}
		} else {
			me.Display.L5 = "";
		}
	},
	insertAdf: func(n) {
		if (mcdu.unit[me.id].stringDecimalLengthInRange(0, 1) and mcdu.unit[me.id].stringLengthInRange(3, 6) and !mcdu.unit[me.id].stringContains("-")) {
			if (me.scratchpad >= 190 and me.scratchpad <= 1750) {
				pts.Instrumentation.Adf.Frequencies.selectedKhz[n].setValue(me.scratchpad);
				me.commonValue.adfSet[n] = 1;
				mcdu.unit[me.id].scratchpadClear();
			} else {
				mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
			}
		} else {
			mcdu.unit[me.id].setMessage("FORMAT ERROR");
		}
	},
	insertNav: func(n) {
		if (find("/", me.scratchpad) != -1) {
			me.scratchpadSplit = split("/", me.scratchpad);
		} else {
			me.scratchpadSplit = [me.scratchpad, ""];
		}
		
		if (mcdu.unit[me.id].stringContains("-")) {
			mcdu.unit[me.id].setMessage("FORMAT ERROR");
			return;
		}
		
		if (size(me.scratchpadSplit[0]) > 0) { # Frequency
			if (mcdu.unit[me.id].stringLengthInRange(3, 6, me.scratchpadSplit[0]) and mcdu.unit[me.id].stringDecimalLengthInRange(0, 2, me.scratchpadSplit[0])) {
				if (n == 2) { # ILS
					if (me.scratchpadSplit[0] < 108 or me.scratchpadSplit[0] > 111.95) {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
						return;
					}
				} else { # VOR
					if (me.scratchpadSplit[0] < 108 or me.scratchpadSplit[0] > 117.95) {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
						return;
					}
				}
			} else {
				mcdu.unit[me.id].setMessage("FORMAT ERROR");
				return;
			}
		}
		
		if (size(me.scratchpadSplit[1]) > 0) { # Course
			if (mcdu.unit[me.id].stringLengthInRange(1, 3, me.scratchpadSplit[1]) and mcdu.unit[me.id].stringIsNumber(me.scratchpadSplit[1]) and !mcdu.unit[me.id].stringContains(".", me.scratchpadSplit[1])) {
				if (me.scratchpadSplit[1] == 0) { # Evaluate as integer so all forms of 0 work
					me.scratchpadSplit[1] = "360"; # Must be string
				}
				
				if (me.scratchpadSplit[1] < 1 or me.scratchpadSplit[1] > 360) {
					mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					return;
				}
			} else {
				mcdu.unit[me.id].setMessage("FORMAT ERROR");
				return;
			}
		}
		
		if (size(me.scratchpadSplit[0]) > 0) {
			pts.Instrumentation.Nav.Frequencies.selectedMhz[n].setValue(me.scratchpadSplit[0]);
			me.commonValue.navSet[n] = 1;
		}
		if (size(me.scratchpadSplit[1]) > 0) {
			if (me.commonValue.navSet[n]) {
				pts.Instrumentation.Nav.Radials.selectedDeg[n].setValue(me.scratchpadSplit[1]);
				me.commonValue.navCrsSet[n] = 1;
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
				return;
			}
		}
		mcdu.unit[me.id].scratchpadClear();
	},
	softKey: func(k) {
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		if (k == "l1") {
			if (me.scratchpadState == 2) {
				me.insertNav(0);
			} else if (me.scratchpadState == 0) {
				if (me.commonValue.navSet[0]) {
					me.commonValue.navSet[0] = 0;
					me.commonValue.navCrsSet[0] = 0;
					pts.Instrumentation.Nav.Frequencies.selectedMhz[0].setValue(0);
					pts.Instrumentation.Nav.Radials.selectedDeg[0].setValue(0);
					mcdu.unit[me.id].scratchpadClear();
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l2") {
			if (me.scratchpadState == 0) {
				if (me.Display.L2 == "VOR ARMED") {
					afs.ITAF.updateLocArm(0);
					mcdu.unit[me.id].scratchpadClear();
				} else if (me.Display.L2 == "*VOR ARM") {
					afs.Input.radioSel.setValue(0);
					afs.Input.lat.setValue(2);
					mcdu.unit[me.id].scratchpadClear();
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				if (me.Display.L2 == "*VOR ARM") {
					afs.Input.radioSel.setValue(0);
					afs.Input.lat.setValue(2);
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			}
		} else if (k == "l3") {
			if (me.scratchpadState == 2) {
				me.insertAdf(0);
			} else if (me.scratchpadState == 0) {
				if (me.commonValue.adfSet[0]) {
					me.commonValue.adfSet[0] = 0;
					pts.Instrumentation.Adf.Frequencies.selectedKhz[0].setValue(0);
					mcdu.unit[me.id].scratchpadClear();
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l4") {
			if (me.scratchpadState == 2) {
				me.insertNav(2);
			} else if (me.scratchpadState == 0) {
				if (me.commonValue.navSet[2]) {
					me.commonValue.navSet[2] = 0;
					me.commonValue.navCrsSet[2] = 0;
					pts.Instrumentation.Nav.Frequencies.selectedMhz[2].setValue(0);
					pts.Instrumentation.Nav.Radials.selectedDeg[2].setValue(0);
					mcdu.unit[me.id].scratchpadClear();
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l5") {
			if (me.scratchpadState == 0) {
				if (me.Display.L5 == "LOC ONLY") {
					afs.ITAF.updateLocArm(0, 1); # Do not reset locOnly
					mcdu.unit[me.id].scratchpadClear();
				} else if (me.Display.L5 == "*LOC ONLY") {
					afs.Internal.locOnly = 1;
					afs.Input.radioSel.setValue(2);
					afs.Input.lat.setValue(2);
					mcdu.unit[me.id].scratchpadClear();
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				if (me.Display.L5 == "*LOC ONLY") {
					afs.Input.radioSel.setValue(2);
					afs.Input.lat.setValue(2);
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			}
		} else if (k == "r1") {
			if (me.scratchpadState == 2) {
				me.insertNav(1);
			} else if (me.scratchpadState == 0) {
				if (me.commonValue.navSet[1]) {
					me.commonValue.navSet[1] = 0;
					me.commonValue.navCrsSet[1] = 0;
					pts.Instrumentation.Nav.Frequencies.selectedMhz[1].setValue(0);
					pts.Instrumentation.Nav.Radials.selectedDeg[1].setValue(0);
					mcdu.unit[me.id].scratchpadClear();
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r2") {
			if (me.scratchpadState == 0) {
				if (me.Display.R2 == "VOR ARMED") {
					afs.ITAF.updateLocArm(0);
					mcdu.unit[me.id].scratchpadClear();
				} else if (me.Display.R2 == "VOR ARM*") {
					afs.Input.radioSel.setValue(1);
					afs.Input.lat.setValue(2);
					mcdu.unit[me.id].scratchpadClear();
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				if (me.Display.R2 == "VOR ARM*") {
					afs.Input.radioSel.setValue(1);
					afs.Input.lat.setValue(2);
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			}
		} else if (k == "r3") {
			if (me.scratchpadState == 2) {
				me.insertAdf(1);
			} else if (me.scratchpadState == 0) {
				if (me.commonValue.adfSet[1]) {
					me.commonValue.adfSet[1] = 0;
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
