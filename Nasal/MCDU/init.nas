# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2025 Josh Davidson (Octal450)

var Init = {
	new: func(n) {
		var m = {parents: [Init]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, -1, 0, 0, 1],
			CTranslate: [0, 0, 0, 0, 0, 1],
			C1L: "",
			C1: "",
			C2L: "",
			C2: "",
			C3L: "GNS POS",
			C3: "",
			C4L: "",
			C4: "",
			C5L: "",
			C5: "",
			C6L: "OPT/MAXFL",
			C6: "",
			
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: "CO ROUTE",
			L1: "",
			L2L: "ALTN ROUTE",
			L2: "",
			L3L: "",
			L3: "",
			L4L: "FLT NO",
			L4: "",
			L5L: "CRZ LEVELS",
			L5: "",
			L6L: "TEMP/WIND",
			L6: "",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "1/3",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "FROM/ TO  ",
			R1: "",
			R2L: "ALTN",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "CI",
			R6: "",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "F-PLN INIT",
			titleTranslate: 0,
		};
		
		m.Value = {
			cruiseFlText: ["", "", "", "", "", ""],
			cruiseInput: 0,
			cruiseInputVals: [0, 0, 0, 0, 0, 0],
			gnsPosSide: 0,
			maxAlt: 0,
			optAlt: 0,
			positionSplit: ["", ""],
		};
		
		m.group = "fmc";
		m.name = "init";
		m.nextPage = "init2";
		m.scratchpad = "";
		m.scratchpadSplit = nil;
		m.scratchpadSplitSize = 0;
		m.scratchpadState = 0;
		
		return m;
	},
	reset: func() {
		me.setup();
	},
	setup: func() {
		me.Value.gnsPosSide = 0;
		me.Value.positionSplit = split("/", FORMAT.Position.formatNode(pts.Position.node));
		me.Display.L3 = me.Value.positionSplit[0];
		me.Display.R3 = me.Value.positionSplit[1];
	},
	loop: func() {
		if (me.Value.gnsPosSide) {
			me.Display.L3L = "LAT";
			me.Display.R3L = "^  LONG";
		} else {
			me.Display.L3L = "LAT  ^";
			me.Display.R3L = "LONG";
		}
		
		if (fms.flightData.airportTo != "") {
			me.Display.L1 = "";
		} else {
			me.Display.L1 = "__________";
		}
		
		if (fms.flightData.airportAltn != "") {
			me.Display.L2 = "";
		} else if (fms.flightData.airportTo != "") {
			me.Display.L2 = "__________";
		} else {
			me.Display.L2 = "----------";
		}
		
		if (fms.flightData.flightNumber != "") {
			me.Display.L4 = fms.flightData.flightNumber;
		} else {
			me.Display.L4 = "________";
		}
		
		if (fms.flightData.cruiseFl > 0) {
			me.Value.cruiseFlText[0] = sprintf("%03d", fms.flightData.cruiseFlAll[0]);
			
			if (fms.flightData.cruiseFlAll[1] > 0) me.Value.cruiseFlText[1] = sprintf("%03d", fms.flightData.cruiseFlAll[1]);
			else me.Value.cruiseFlText[1] = "[ ]";
			if (fms.flightData.cruiseFlAll[2] > 0) me.Value.cruiseFlText[2] = sprintf("%03d", fms.flightData.cruiseFlAll[2]);
			else me.Value.cruiseFlText[2] = "[ ]";
			if (fms.flightData.cruiseFlAll[3] > 0) me.Value.cruiseFlText[3] = sprintf("%03d", fms.flightData.cruiseFlAll[3]);
			else me.Value.cruiseFlText[3] = "[ ]";
			if (fms.flightData.cruiseFlAll[4] > 0) me.Value.cruiseFlText[4] = sprintf("%03d", fms.flightData.cruiseFlAll[4]);
			else me.Value.cruiseFlText[4] = "[ ]";
			if (fms.flightData.cruiseFlAll[5] > 0) me.Value.cruiseFlText[5] = sprintf("%03d", fms.flightData.cruiseFlAll[5]);
			else me.Value.cruiseFlText[5] = "[ ]";
			
			me.Display.L5 = me.Value.cruiseFlText[0] ~ "/" ~ me.Value.cruiseFlText[1] ~ "/" ~ me.Value.cruiseFlText[2] ~ "/" ~ me.Value.cruiseFlText[3] ~ "/" ~ me.Value.cruiseFlText[4] ~ "/" ~ me.Value.cruiseFlText[5];
		} else if (fms.flightData.airportTo != "") {
			me.Display.L5 = "___/[ ]/[ ]/[ ]/[ ]/[ ]";
		} else {
			me.Display.L5 = "---/---/---/---/---/---";
		}
		
		if (fms.flightData.cruiseTemp != nil) {
			me.Display.L6 = fms.flightData.cruiseTemp ~ "g/HD000";
			me.Display.LFont[5] = FONT.small;
		} else {
			me.Display.L6 = "---g/-----";
			me.Display.LFont[5] = FONT.large;
		}
		
		me.Value.optAlt = fms.Internal.optFl.getValue();
		me.Value.maxAlt = fms.Internal.maxFl.getValue();
		if (me.Value.optAlt > 0 and me.Value.maxAlt > 0) {
			me.Display.C6 = sprintf("%03d", math.round(me.Value.optAlt)) ~ "/" ~ sprintf("%03d", math.round(me.Value.maxAlt));
		} else {
			me.Display.C6 = "---/---";
		}
		
		if (fms.flightData.airportTo != "") {
			me.Display.R1 = fms.flightData.airportFrom ~ "/" ~ fms.flightData.airportTo;
		} else {
			me.Display.R1 = "_____/_____";
		}
		
		if (fms.flightData.airportAltn != "") {
			me.Display.R2 = fms.flightData.airportAltn;
		} else if (fms.flightData.airportTo != "") {
			me.Display.R2 = "_____";
		} else {
			me.Display.R2 = "-----";
		}
		
		if (systems.IRS.Controls.mcduBtn.getBoolValue()) {
			me.Display.R4 = "POS REF>";
		} else {
			me.Display.R4 = "INITIALIZE IRS*";
		}
		
		if (fms.flightData.costIndex > -1) {
			me.Display.R6 = sprintf("%d", fms.flightData.costIndex);
		} else if (fms.flightData.airportTo != "") {
			me.Display.R6 = "___";
		} else {
			me.Display.R6 = "---";
		}
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l3") {
			if (me.scratchpadState == 1) {
				me.Value.gnsPosSide = 0;
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l4") {
			if (me.scratchpadState == 0) {
				fms.flightData.flightNumber = "";
				unit[me.id].scratchpadClear();
			} else if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 8)) {
					fms.flightData.flightNumber = me.scratchpad;
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l5") {
			if (me.scratchpadState == 2) {
				me.Value.cruiseInput = 3;
				me.scratchpadSplit = split("/", me.scratchpad);
				me.scratchpadSplitSize = size(me.scratchpadSplit);
				
				##### Temporarily disable step climb entry, since the FMS doesn't support that yet
				if (me.scratchpadSplitSize > 1) {
					unit[me.id].setMessage("STEP CLIMB INOP");
				} else if (me.scratchpadSplitSize == 1) {
				##### End step climb disable
				
				#if (me.scratchpadSplitSize >= 1 and me.scratchpadSplitSize <= 6) {
					for (var i = 0; i < me.scratchpadSplitSize; i = i + 1) {
						if (!unit[me.id].stringLengthInRange(1, 3, me.scratchpadSplit[i]) or !unit[me.id].stringIsInt(me.scratchpadSplit[i])) {
							me.Value.cruiseInput = 0;
							break;
						}
						if (int(me.scratchpadSplit[i]) <= 0 or int(me.scratchpadSplit[i]) > 430) {
							me.Value.cruiseInput = 1;
							break;
						}
						if (i > 0) {
							if (int(me.scratchpadSplit[i]) <= int(me.scratchpadSplit[i - 1])) {
								me.Value.cruiseInput = 2;
								break;
							}
						}
					}
					
					if (me.Value.cruiseInput == 0) {
						unit[me.id].setMessage("FORMAT ERROR");
					} else if (me.Value.cruiseInput == 1) {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					} else if (me.Value.cruiseInput == 2) {
						unit[me.id].setMessage("STEP DOWN INVALID");
					} else {
						for (var i = 0; i < 6; i = i + 1) { # Set values so unused inputs go to 0
							if (i < me.scratchpadSplitSize) {
								me.Value.cruiseInputVals[i] = me.scratchpadSplit[i];
							} else {
								me.Value.cruiseInputVals[i] = 0;
							}
						}
						fms.EditFlightData.insertCruiseFl(int(me.Value.cruiseInputVals[0]), int(me.Value.cruiseInputVals[1]), int(me.Value.cruiseInputVals[2]), int(me.Value.cruiseInputVals[3]), int(me.Value.cruiseInputVals[4]), int(me.Value.cruiseInputVals[5]));
						unit[me.id].scratchpadClear();
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r1") {
			if (me.scratchpadState == 0) {
				fms.EditFlightData.reset();
				unit[me.id].scratchpadClear();
			} else if (me.scratchpadState == 2) {
				me.scratchpadSplit = split("/", me.scratchpad);
				if (size(me.scratchpadSplit) == 2) {
					if (unit[me.id].stringLengthInRange(3, 4, me.scratchpadSplit[0]) and unit[me.id].stringLengthInRange(3, 4, me.scratchpadSplit[1])) {
						if (size(findAirportsByICAO(me.scratchpadSplit[0])) == 1 and size(findAirportsByICAO(me.scratchpadSplit[1])) == 1) {
							fms.EditFlightData.newFlightplan(me.scratchpadSplit[0], me.scratchpadSplit[1]);
							unit[me.id].scratchpadClear();
							unit[me.id].setPage("compRte");
						} else {
							unit[me.id].setMessage("NOT IN DATA BASE");
						}
					} else {
						unit[me.id].setMessage("FORMAT ERROR");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r2") {
			if (me.scratchpadState == 0) {
				fms.EditFlightData.insertAlternate("");
				unit[me.id].scratchpadClear();
			} else if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(3, 4)) {
					if (size(findAirportsByICAO(me.scratchpad)) == 1) {
						if (fms.flightData.airportTo != "") {
							fms.EditFlightData.insertAlternate(me.scratchpad);
							unit[me.id].scratchpadClear();
						} else {
							unit[me.id].setMessage("NOT ALLOWED");
						}
					} else {
						unit[me.id].setMessage("NOT IN DATA BASE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r3") {
			if (me.scratchpadState == 1) {
				me.Value.gnsPosSide = 1;
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r4") {
			if (systems.IRS.Controls.mcduBtn.getBoolValue()) {
				unit[me.id].setPage("posRef");
			} else {
				if ((systems.IRS.Controls.knob[0].getBoolValue() or systems.IRS.Controls.knob[1].getBoolValue() or systems.IRS.Controls.knob[2].getBoolValue()) and me.scratchpadState == 1) {
					systems.IRS.Controls.mcduBtn.setBoolValue(1);
				} else {
					unit[me.id].setMessage("NOT ALLOWED");
				}
			}
		} else if (k == "r6") {
			if (me.scratchpadState == 2 and fms.flightData.airportTo != "") {
				if (unit[me.id].stringLengthInRange(1, 3) and unit[me.id].stringIsInt()) {
					if (me.scratchpad >= 0) {
						fms.flightData.costIndex = int(me.scratchpad);
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else {
			unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};

var Init2 = {
	new: func(n) {
		var m = {parents: [Init2]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.small, FONT.large, FONT.small, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 0, 0, 0],
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
			C6L: "",
			C6: "",
			
			LFont: [FONT.small, FONT.small, FONT.small, FONT.small, FONT.small, FONT.small],
			L1L: "",
			L1: "",
			L2L: "TRIP/TIME",
			L2: "---.-/----",
			L3L: "RTE RSV/%",
			L3: "--.-",
			L4L: "ALTN",
			L4: "---.-",
			L5L: "FINAL/TIME",
			L5: "---.-",
			L6L: "EXTRA/TIME",
			L6: "---.-/----",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "    /05.0",
			L4B: "",
			L5B: "     /0030",
			L6B: "",
			
			pageNum: "2/3",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.small, FONT.large, FONT.large],
			R1L: "",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "BLST IN ZFW",
			R3: "",
			R4L: "LW",
			R4: "---.-",
			R5L: "TOCG",
			R5: "",
			R6L: "ZFWCG",
			R6: "",
			
			RBFont: [FONT.small, FONT.large, FONT.small, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "0.0       ",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "WEIGHT INIT",
			titleTranslate: 0,
		};
		
		m.Value = {
			taxiInsertStatus: 0,
		};
		
		m.group = "fmc";
		m.name = "init2";
		m.nextPage = "init3";
		m.scratchpad = "";
		m.scratchpadState = 0;
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		if (fms.Internal.engOn) {
			me.Display.L1L = "";
			me.Display.L1 = "";
			me.Display.C1 = "";
			me.Display.R1B = "";
			me.Display.R1L = "";
			me.Display.R1 = sprintf("%5.1f", fms.flightData.ufobLbs) ~ "/FF+FQ";
		} else {
			me.Display.L1L = "TAXI";
			me.Display.L1 = sprintf("%3.1f", fms.flightData.taxiFuel);
			if (fms.flightData.taxiFuelSet) {
				me.Display.LFont[0] = FONT.large;
			} else {
				me.Display.LFont[0] = FONT.small;
			}
			
			me.Display.R1B = sprintf("%5.1f", fms.flightData.ufobLbs) ~ "      ";
			me.Display.R1L = "UFOB  BLOCK";
			if (fms.flightData.blockFuelLbs != 0) {
				me.Display.R1 = sprintf("%5.1f", fms.flightData.blockFuelLbs);
			} else {
				me.Display.R1 = "___._";
			}
		}
		
		if (fms.Internal.engOn) {
			me.Display.R2L = "GW";
			if (fms.flightData.gwLbs > 0) {
				me.Display.R2 = sprintf("%5.1f", fms.flightData.gwLbs);
				if (fms.flightData.lastGwZfw) {
					me.Display.RFont[1] = FONT.small;
				} else {
					me.Display.RFont[1] = FONT.large;
				}
			} else {
				me.Display.R2 = "___._";
				me.Display.RFont[1] = FONT.large;
			}
		} else {
			me.Display.R2L = "TOGW";
			if (fms.flightData.togwLbs > 0) {
				me.Display.R2 = sprintf("%5.1f", fms.flightData.togwLbs);
				if (fms.flightData.lastGwZfw) {
					me.Display.RFont[1] = FONT.small;
				} else {
					me.Display.RFont[1] = FONT.large;
				}
			} else {
				me.Display.R2 = "___._";
				me.Display.RFont[1] = FONT.large;
			}
		}
		
		if (fms.flightData.zfwLbs > 0) {
			me.Display.R3 = sprintf("%5.1f", fms.flightData.zfwLbs);
			if (!fms.flightData.lastGwZfw) {
				me.Display.RFont[2] = FONT.small;
			} else {
				me.Display.RFont[2] = FONT.large;
			}
		} else {
			me.Display.R3 = "___._";
			me.Display.RFont[2] = FONT.large;
		}
		
		if (fms.flightData.tocg > 0) {
			me.Display.R5 = sprintf("%4.1f", fms.flightData.tocg);
		} else {
			me.Display.R5 = "__._";
		}
		
		if (fms.flightData.zfwcg > 0) {
			me.Display.R6 = sprintf("%4.1f", fms.flightData.zfwcg);
		} else {
			me.Display.R6 = "__._";
		}
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l1") {
			if (me.scratchpadState == 2 and me.Display.L1L == "TAXI") {
				if (unit[me.id].stringLengthInRange(1, 3) and unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if (me.scratchpad >= 0 and me.scratchpad <= 9.9) {
						me.Value.taxiInsertStatus = fms.EditFlightData.insertTaxiFuel(me.scratchpad);
						if (me.Value.taxiInsertStatus == 0) {
							fms.flightData.taxiFuelSet = 1;
							unit[me.id].scratchpadClear();
						} else if (me.Value.taxiInsertStatus == 1) {
							unit[me.id].setMessage("TOGW OUT OF RANGE");
						} else if (me.Value.taxiInsertStatus == 2) {
							unit[me.id].setMessage("ZFW OUT OF RANGE");
						}
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r1") {
			if (me.Display.R1L == "") {
				unit[me.id].setMessage("NOT ALLOWED");
			} else if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 5) and unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if (me.scratchpad >= 1 and me.scratchpad <= 300) {
						if (fms.EditFlightData.insertBlockFuel(me.scratchpad)) {
							unit[me.id].scratchpadClear();
						} else {
							unit[me.id].setMessage("TOGW OUT OF RANGE");
						}
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				if (fms.EditFlightData.insertBlockFuel(fms.flightData.ufobLbs)) {
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("TOGW OUT OF RANGE");
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r2") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 5) and unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if (me.scratchpad >= 1 and me.scratchpad <= 633) {
						if (me.Display.R2L == "GW") {
							if (fms.EditFlightData.insertGw(me.scratchpad)) {
								unit[me.id].scratchpadClear();
							} else {
								unit[me.id].setMessage("ZFW OUT OF RANGE");
							}
						} else {
							if (fms.EditFlightData.insertTogw(me.scratchpad)) {
								unit[me.id].scratchpadClear();
							} else {
								unit[me.id].setMessage("ZFW OUT OF RANGE");
							}
						}
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				if (me.Display.R2L == "GW") {
					unit[me.id].scratchpadSet(sprintf("%5.1f", math.round(pts.Fdm.JSBSim.Inertia.weightLbs.getValue() / 1000, 0.1)));
				} else {
					unit[me.id].scratchpadSet(sprintf("%5.1f", math.round((pts.Fdm.JSBSim.Inertia.weightLbs.getValue() / 1000) - fms.flightData.taxiFuel, 0.1)));
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r3") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 5) and unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if (me.scratchpad >= 1 and me.scratchpad <= fms.Internal.maxZfw) {
						if (fms.EditFlightData.insertZfw(me.scratchpad)) {
							unit[me.id].scratchpadClear();
						} else {
							unit[me.id].setMessage("TOGW OUT OF RANGE");
						}
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				unit[me.id].scratchpadSet(sprintf("%5.1f", math.round(pts.Fdm.JSBSim.Inertia.zfwLbs.getValue() / 1000, 0.1)));
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r5") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 4) and unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if (me.scratchpad >= 1 and me.scratchpad <= 35) {
						fms.flightData.tocg = me.scratchpad;
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				unit[me.id].scratchpadSet(sprintf("%4.1f", math.round(pts.Fdm.JSBSim.Inertia.cgPercentMac.getValue(), 0.1)));
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r6") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 4) and unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if (me.scratchpad >= 1 and me.scratchpad <= 34) {
						fms.flightData.zfwcg = me.scratchpad;
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				unit[me.id].scratchpadSet(sprintf("%4.1f", math.round(pts.Fdm.JSBSim.Inertia.zfwcgPercentMac.getValue(), 0.1)));
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else {
			unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};

var Init3 = {
	new: func(n) {
		var m = {parents: [Init3]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 0, 0, 0],
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
			C6L: "",
			C6: "",
			
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: "REFUEL QTY",
			L1: "[  .]",
			L2L: "BLST FUEL",
			L2: "[ .]",
			L3L: "BLST TANK",
			L3: "_",
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
			
			pageNum: "3/3",
			
			RFont: [FONT.small, FONT.small, FONT.small, FONT.small, FONT.large, FONT.large],
			R1L: "DUMP TO GW",
			R1: "---.-",
			R2L: "DUMP TIME",
			R2: "----",
			R3L: "FUEL TYPE",
			R3: "JET A",
			R4L: "FREEZE TEMP",
			R4: "-40",
			R5L: "",
			R5: "FUEL DIPSTICK>",
			R6L: "",
			R6: "",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "FUEL INIT",
			titleTranslate: 0,
		};
		
		m.Value = {
		};
		
		m.group = "fmc";
		m.name = "init3";
		m.nextPage = "init";
		m.scratchpad = "";
		m.scratchpadState = 0;
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		#} else {
			unit[me.id].setMessage("NOT ALLOWED");
		#}
	},
};

var CompRte = {
	new: func(n) {
		var m = {parents: [CompRte]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 0, 0, 0],
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
			C6L: "",
			C6: "",
			
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: "",
			L1: "NONE",
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
			R6L: "RETURN TO ",
			R6: "F-PLN INIT>",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "",
			titleTranslate: 0,
		};
		
		m.group = "fmc";
		m.name = "compRte";
		m.nextPage = "none";
		
		return m;
	},
	setup: func() {
		if (fms.flightData.airportTo != "") {
			me.Display.title = fms.flightData.airportFrom ~ "/" ~ fms.flightData.airportTo;
		}
	},
	loop: func() {
	},
	softKey: func(k) {
		if (k == "r6") {
			unit[me.id].setPage("init");
		} else {
			unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};
