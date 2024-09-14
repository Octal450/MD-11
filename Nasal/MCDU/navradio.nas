# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)

var NavRadio = {
	new: func(n) {
		var m = {parents: [NavRadio]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			CLTranslate: [0, 0, 0, 0, 0, -3],
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
			C6L: "PRESELECT",
			C6: "",
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1L: "VOR1/CRS",
			L1: "",
			L2L: "",
			L2: "",
			L3L: "ADF1",
			L3: "",
			L4L: "ILS/CRS",
			L4: "",
			L5L: "",
			L5: "",
			L6L: "",
			L6: "[   ]/[   ]",
			
			LBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1L: "VOR2/CRS",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "ADF2",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "",
			R6: "[   ]/[   ]",
			
			RBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "NAV RADIO",
			titleTranslate: 0,
		};
		
		m.Value = {
			adfKhz: [0, 0],
			lat: 0,
			navCrs: [0, 0, 0], # Course 0 is forced to 360, so 0 = no course set
			navMhz: [0, 0, 0],
			vert: 0,
		};
		
		m.group = "fmc";
		m.name = "navRadio";
		m.nextPage = "none";
		m.scratchpad = "";
		m.scratchpadSplit = nil;
		m.scratchpadState = 0;
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		me.Value.navCrs[0] = pts.Instrumentation.Nav.Radials.selectedDeg[0].getValue();
		me.Value.navMhz[0] = pts.Instrumentation.Nav.Frequencies.selectedMhz[0].getValue();
		if (me.Value.navMhz[0] > 0) {
			if (me.Value.navCrs[0] > -1) {
				me.Display.L1 = sprintf("%5.2f", math.round(me.Value.navMhz[0], 0.01)) ~ "/" ~ sprintf("%03d", me.Value.navCrs[0]) ~ "g";
			} else {
				me.Display.L1 = sprintf("%5.2f", math.round(me.Value.navMhz[0], 0.01)) ~ "/[ ]g";
			}
		} else {
			me.Display.L1 = "[  ]/[ ]g";
			me.Display.L2 = "";
		}
		
		me.Value.navCrs[1] = pts.Instrumentation.Nav.Radials.selectedDeg[1].getValue();
		me.Value.navMhz[1] = pts.Instrumentation.Nav.Frequencies.selectedMhz[1].getValue();
		if (me.Value.navMhz[1] > 0) {
			if (me.Value.navCrs[1] > -1) {
				me.Display.R1 = sprintf("%5.2f", math.round(me.Value.navMhz[1], 0.01)) ~ "/" ~ sprintf("%03d", me.Value.navCrs[1]) ~ "g";
			} else {
				me.Display.R1 = sprintf("%5.2f", math.round(me.Value.navMhz[1], 0.01)) ~ "/[ ]g";
			}
		} else {
			me.Display.R1 = "[  ]/[ ]g";
		}
		
		me.Value.navCrs[2] = pts.Instrumentation.Nav.Radials.selectedDeg[2].getValue();
		me.Value.navMhz[2] = pts.Instrumentation.Nav.Frequencies.selectedMhz[2].getValue();
		if (me.Value.navMhz[2] > 0) {
			if (me.Value.navCrs[2] > -1) {
				me.Display.L4 = sprintf("%5.2f", math.round(me.Value.navMhz[2], 0.01)) ~ "/" ~ sprintf("%03d", me.Value.navCrs[2]) ~ "g";
			} else {
				me.Display.L4 = sprintf("%5.2f", math.round(me.Value.navMhz[2], 0.01)) ~ "/[ ]g";
			}
		} else {
			me.Display.L4 = "[  ]/[ ]g";
		}
		
		me.Value.adfKhz[0] = pts.Instrumentation.Adf.Frequencies.selectedKhz[0].getValue();
		if (me.Value.adfKhz[0] > 0) {
			me.Display.L3 = sprintf("%4.1f", math.round(me.Value.adfKhz[0], 0.1));
		} else {
			me.Display.L3 = "[  ]";
		}
		
		me.Value.adfKhz[1] = pts.Instrumentation.Adf.Frequencies.selectedKhz[1].getValue();
		if (me.Value.adfKhz[1] > 0) {
			me.Display.R3 = sprintf("%4.1f", math.round(me.Value.adfKhz[1], 0.1));
		} else {
			me.Display.R3 = "[  ]";
		}
		
		if (me.Value.navMhz[0] > 0 and me.Value.navCrs[0] > -1) {
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
		
		if (me.Value.navMhz[1] > 0 and me.Value.navCrs[1] > -1) {
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
		
		if (me.Value.navMhz[2] > 0 and me.Value.navCrs[2] > -1) {
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
			if (mcdu.unit[me.id].stringLengthInRange(1, 3, me.scratchpadSplit[1]) and mcdu.unit[me.id].stringIsInt(me.scratchpadSplit[1])) {
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
		}
		if (size(me.scratchpadSplit[1]) > 0) {
			if (pts.Instrumentation.Nav.Frequencies.selectedMhz[n].getValue()) {
				pts.Instrumentation.Nav.Radials.selectedDeg[n].setValue(me.scratchpadSplit[1]);
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
				if (pts.Instrumentation.Nav.Frequencies.selectedMhz[0].getValue() > 0) {
					pts.Instrumentation.Nav.Frequencies.selectedMhz[0].setValue(0);
					pts.Instrumentation.Nav.Radials.selectedDeg[0].setValue(-1);
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
				if (pts.Instrumentation.Adf.Frequencies.selectedKhz[0].getValue() > 0) {
					pts.Instrumentation.Adf.Frequencies.selectedKhz[0].setValue(0);
					mcdu.unit[me.id].scratchpadClear();
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l4") {
			me.Value.lat = afs.Output.lat.getValue();
			me.Value.vert = afs.Output.vert.getValue();
			
			if ((me.Value.lat == 2 or me.Value.lat == 4 or me.Value.vert == 2 or me.Value.vert == 6) and afs.Input.radioSel.getValue() == 2) {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			} else if (me.scratchpadState == 2) {
				me.insertNav(2);
			} else if (me.scratchpadState == 0) {
				if (pts.Instrumentation.Nav.Frequencies.selectedMhz[2].getValue() > 0) {
					pts.Instrumentation.Nav.Frequencies.selectedMhz[2].setValue(0);
					pts.Instrumentation.Nav.Radials.selectedDeg[2].setValue(-1);
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
				if (pts.Instrumentation.Nav.Frequencies.selectedMhz[1].getValue() > 0) {
					pts.Instrumentation.Nav.Frequencies.selectedMhz[1].setValue(0);
					pts.Instrumentation.Nav.Radials.selectedDeg[1].setValue(-1);
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
				if (pts.Instrumentation.Adf.Frequencies.selectedKhz[1].getValue() > 0) {
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
