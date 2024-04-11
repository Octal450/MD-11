# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)

var Init = {
	new: func(n) {
		var m = {parents: [Init]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			CTranslate: [0, 0, 0, 0, 0, 100],
			C1: "",
			C1S: "",
			C2: "",
			C2S: "",
			C3: "",
			C3S: "GNS POS",
			C4: "",
			C4S: "",
			C5: "",
			C5S: "",
			C6: "---/---",
			C6S: "OPT/MAXFL",
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1: "",
			L1S: "CO ROUTE",
			L2: "",
			L2S: "ALTN ROUTE",
			L3: "",
			L3S: "",
			L4: "",
			L4S: "FLT NO",
			L5: "",
			L5S: "CRZ LEVELS",
			L6: "",
			L6S: "TEMP/WIND",
			
			pageNum: "1/3",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1: "",
			R1S: "FROM/ TO   ",
			R2: "",
			R2S: "ALTN",
			R3: "",
			R3S: "",
			R4: "",
			R4S: "",
			R5: "",
			R5S: "",
			R6: "",
			R6S: "CI",
			
			simple: 1,
			title: "F-PLN INIT",
		};
		
		m.Value = {
			cruiseFlText: ["", "", "", "", "", ""],
			cruiseInput: 0,
			cruiseInputVals: [0, 0, 0, 0, 0, 0],
			gnsPosSide: 0,
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
		me.Value.positionSplit = split("/", positionFormat(pts.Position.node));
		me.Display.L3 = me.Value.positionSplit[0];
		me.Display.R3 = me.Value.positionSplit[1];
	},
	loop: func() {
		if (me.Value.gnsPosSide) {
			me.Display.L3S = "LAT";
			me.Display.R3S = "^  LONG";
		} else {
			me.Display.L3S = "LAT  ^";
			me.Display.R3S = "LONG";
		}
		
		if (fms.FlightData.airportTo != "") {
			me.Display.L1 = "";
		} else {
			me.Display.L1 = "__________";
		}
		
		if (fms.FlightData.airportAlt != "") {
			me.Display.L2 = "";
		} else if (fms.FlightData.airportTo != "") {
			me.Display.L2 = "__________";
		} else {
			me.Display.L2 = "----------";
		}
		
		if (fms.FlightData.flightNumber != "") {
			me.Display.L4 = fms.FlightData.flightNumber;
		} else {
			me.Display.L4 = "________";
		}
		
		if (fms.FlightData.cruiseFl > 0) {
			me.Value.cruiseFlText[0] = fms.FlightData.cruiseFlAll[0];
			
			if (fms.FlightData.cruiseFlAll[1] > 0) me.Value.cruiseFlText[1] = sprintf("%03d", fms.FlightData.cruiseFlAll[1]);
			else me.Value.cruiseFlText[1] = "[ ]";
			if (fms.FlightData.cruiseFlAll[2] > 0) me.Value.cruiseFlText[2] = sprintf("%03d", fms.FlightData.cruiseFlAll[2]);
			else me.Value.cruiseFlText[2] = "[ ]";
			if (fms.FlightData.cruiseFlAll[3] > 0) me.Value.cruiseFlText[3] = sprintf("%03d", fms.FlightData.cruiseFlAll[3]);
			else me.Value.cruiseFlText[3] = "[ ]";
			if (fms.FlightData.cruiseFlAll[4] > 0) me.Value.cruiseFlText[4] = sprintf("%03d", fms.FlightData.cruiseFlAll[4]);
			else me.Value.cruiseFlText[4] = "[ ]";
			if (fms.FlightData.cruiseFlAll[5] > 0) me.Value.cruiseFlText[5] = sprintf("%03d", fms.FlightData.cruiseFlAll[5]);
			else me.Value.cruiseFlText[5] = "[ ]";
			
			me.Display.L5 = me.Value.cruiseFlText[0] ~ "/" ~ me.Value.cruiseFlText[1] ~ "/" ~ me.Value.cruiseFlText[2] ~ "/" ~ me.Value.cruiseFlText[3] ~ "/" ~ me.Value.cruiseFlText[4] ~ "/" ~ me.Value.cruiseFlText[5];
		} else if (fms.FlightData.airportTo != "") {
			me.Display.L5 = "___/[ ]/[ ]/[ ]/[ ]/[ ]";
		} else {
			me.Display.L5 = "---/---/---/---/---/---";
		}
		
		if (fms.FlightData.cruiseTemp != nil) {
			me.Display.L6 = fms.FlightData.cruiseTemp ~ "g/HD000";
			me.Display.LFont[5] = FONT.small;
		} else {
			me.Display.L6 = "---g/-----";
			me.Display.LFont[5] = FONT.normal;
		}
		
		if (fms.FlightData.airportTo != "") {
			me.Display.R1 = fms.FlightData.airportFrom ~ "/" ~ fms.FlightData.airportTo;
		} else {
			me.Display.R1 = "_____/_____";
		}
		
		if (fms.FlightData.airportAlt != "") {
			me.Display.R2 = fms.FlightData.airportAlt;
		} else if (fms.FlightData.airportTo != "") {
			me.Display.R2 = "_____";
		} else {
			me.Display.R2 = "-----";
		}
		
		if (systems.IRS.Switch.mcduBtn.getBoolValue()) {
			me.Display.R4 = "POS REF>";
		} else {
			me.Display.R4 = "INITIALIZE IRS*";
		}
		
		if (fms.FlightData.costIndex != 0) {
			me.Display.R6 = sprintf("%3.0f", fms.FlightData.costIndex);;
		} else if (fms.FlightData.airportTo != "") {
			me.Display.R6 = "___";
		} else {
			me.Display.R6 = "---";
		}
	},
	softKey: func(k) {
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		if (k == "l3") {
			if (me.scratchpadState == 1) {
				me.Value.gnsPosSide = 0;
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l4") {
			if (me.scratchpadState == 0) {
				fms.FlightData.flightNumber = "";
				mcdu.unit[me.id].scratchpadClear();
			} else if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 8)) {
					fms.FlightData.flightNumber = me.scratchpad;
					mcdu.unit[me.id].scratchpadClear();
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l5") {
			if (me.scratchpadState == 2) {
				me.Value.cruiseInput = 3;
				me.scratchpadSplit = split("/", me.scratchpad);
				me.scratchpadSplitSize = size(me.scratchpadSplit);
				
				##### Temporarily disable step climb entry, since the FMS doesn't support that yet
				if (me.scratchpadSplitSize > 1) {
					mcdu.unit[me.id].setMessage("STEP CLIMB INOP");
				} else if (me.scratchpadSplitSize == 1) {
				##### End step climb disable
				
				#if (me.scratchpadSplitSize >= 1 and me.scratchpadSplitSize <= 6) {
					for (var i = 0; i < me.scratchpadSplitSize; i = i + 1) {
						if (!mcdu.unit[me.id].stringLengthInRange(1, 3, me.scratchpadSplit[i]) or !mcdu.unit[me.id].stringIsInt(me.scratchpadSplit[i])) {
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
						mcdu.unit[me.id].setMessage("FORMAT ERROR");
					} else if (me.Value.cruiseInput == 1) {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					} else if (me.Value.cruiseInput == 2) {
						mcdu.unit[me.id].setMessage("STEP DOWN INVALID");
					} else {
						for (var i = 0; i < 6; i = i + 1) { # Set values so unused inputs go to 0
							if (i < me.scratchpadSplitSize) {
								me.Value.cruiseInputVals[i] = me.scratchpadSplit[i];
							} else {
								me.Value.cruiseInputVals[i] = 0;
							}
						}
						fms.FPLN.insertCruiseFl(int(me.Value.cruiseInputVals[0]), int(me.Value.cruiseInputVals[1]), int(me.Value.cruiseInputVals[2]), int(me.Value.cruiseInputVals[3]), int(me.Value.cruiseInputVals[4]), int(me.Value.cruiseInputVals[5]));
						mcdu.unit[me.id].scratchpadClear();
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r1") {
			if (me.scratchpadState == 0) {
				fms.FPLN.resetFlightData();
				mcdu.unit[me.id].scratchpadClear();
			} else if (me.scratchpadState == 2) {
				me.scratchpadSplit = split("/", me.scratchpad);
				if (size(me.scratchpadSplit) == 2) {
					if (mcdu.unit[me.id].stringLengthInRange(3, 4, me.scratchpadSplit[0]) and mcdu.unit[me.id].stringLengthInRange(3, 4, me.scratchpadSplit[1])) {
						if (size(findAirportsByICAO(me.scratchpadSplit[0])) == 1 and size(findAirportsByICAO(me.scratchpadSplit[1])) == 1) {
							fms.FPLN.newFlightplan(me.scratchpadSplit[0], me.scratchpadSplit[1]);
							mcdu.unit[me.id].scratchpadClear();
							mcdu.unit[me.id].setPage("compRte");
						} else {
							mcdu.unit[me.id].setMessage("NOT IN DATA BASE");
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
		} else if (k == "r2") {
			if (me.scratchpadState == 0) {
				fms.FPLN.insertAlternate("");
				mcdu.unit[me.id].scratchpadClear();
			} else if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(3, 4)) {
					if (size(findAirportsByICAO(me.scratchpad)) == 1) {
						if (fms.FlightData.airportTo != "") {
							fms.FPLN.insertAlternate(me.scratchpad);
							mcdu.unit[me.id].scratchpadClear();
						} else {
							mcdu.unit[me.id].setMessage("NOT ALLOWED");
						}
					} else {
						mcdu.unit[me.id].setMessage("NOT IN DATA BASE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r3") {
			if (me.scratchpadState == 1) {
				me.Value.gnsPosSide = 1;
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r4") {
			if (systems.IRS.Switch.mcduBtn.getBoolValue()) {
				mcdu.unit[me.id].setPage("posRef");
			} else {
				if ((systems.IRS.Switch.knob[0].getBoolValue() or systems.IRS.Switch.knob[1].getBoolValue() or systems.IRS.Switch.knob[2].getBoolValue()) and me.scratchpadState == 1) {
					systems.IRS.Switch.mcduBtn.setBoolValue(1);
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			}
		} else if (k == "r6") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 3) and mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad >= 1) {
						fms.FlightData.costIndex = int(me.scratchpad);
						mcdu.unit[me.id].scratchpadClear();
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};

var Init2 = {
	new: func(n) {
		var m = {parents: [Init2]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.small, FONT.normal, FONT.small, FONT.normal, FONT.normal, FONT.normal],
			CTranslate: [150, 0, 150, 0, 0, 0],
			C1: "",
			C1S: "UFOB",
			C2: "",
			C2S: "",
			C3: "0.0",
			C3S: "BLST",
			C4: "",
			C4S: "",
			C5: "",
			C5S: "",
			C6: "",
			C6S: "",
			
			LFont: [FONT.small, FONT.small, FONT.small, FONT.small, FONT.small, FONT.small],
			L1: "",
			L1S: "TAXI",
			L2: "---.-/----",
			L2S: "TRIP/TIME",
			L3: "--.-/05.0",
			L3S: "RTE RSV/%",
			L4: "---.-",
			L4S: "ALTN",
			L5: "---.-/0030",
			L5S: "FINAL/TIME",
			L6: "---.-/----",
			L6S: "EXTRA/TIME",
			
			pageNum: "2/3",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.small, FONT.normal, FONT.normal],
			R1: "",
			R1S: "",
			R2: "",
			R2S: "TOGW",
			R3: "",
			R3S: "IN ZFW",
			R4: "---.-",
			R4S: "LW",
			R5: "",
			R5S: "TOCG",
			R6: "",
			R6S: "ZFWCG",
			
			simple: 1,
			title: "WEIGHT INIT",
		};
		
		m.Value = {
			taxiInsertStatus: 0,
			ufob: 0,
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
		me.Display.L1 = sprintf("%3.1f", fms.FlightData.taxiFuel);
		if (fms.FlightData.taxiFuelSet) {
			me.Display.LFont[0] = FONT.normal;
		} else {
			me.Display.LFont[0] = FONT.small;
		}
		
		me.Value.ufob = math.round(pts.Consumables.Fuel.totalFuelLbs.getValue(), 100) / 1000;
		if (pts.Engines.Engine.state[0].getValue() == 3 or pts.Engines.Engine.state[1].getValue() == 3 or pts.Engines.Engine.state[2].getValue() == 3) {
			me.Display.C1 = "";
			me.Display.R1 = sprintf("%5.1f", me.Value.ufob) ~ "/FF+FQ";
			me.Display.R1S = "";
		} else {
			me.Display.C1 = sprintf("%5.1f", me.Value.ufob);
			if (fms.FlightData.blockFuel != 0) {
				me.Display.R1 = sprintf("%5.1f", fms.FlightData.blockFuel);
			} else {
				me.Display.R1 = "___._";
			}
			me.Display.R1S = "BLOCK";
		}
		
		if (fms.FlightData.togw > 0) {
			me.Display.R2 = sprintf("%5.1f", fms.FlightData.togw);
			if (fms.FlightData.lastTogwZfw) {
				me.Display.RFont[1] = FONT.small;
			} else {
				me.Display.RFont[1] = FONT.normal;
			}
		} else {
			me.Display.R2 = "___._";
			me.Display.RFont[1] = FONT.normal;
		}
		
		if (fms.FlightData.zfw > 0) {
			me.Display.R3 = sprintf("%5.1f", fms.FlightData.zfw);
			if (!fms.FlightData.lastTogwZfw) {
				me.Display.RFont[2] = FONT.small;
			} else {
				me.Display.RFont[2] = FONT.normal;
			}
		} else {
			me.Display.R3 = "___._";
			me.Display.RFont[2] = FONT.normal;
		}
		
		if (fms.FlightData.tocg > 0) {
			me.Display.R5 = sprintf("%4.1f", fms.FlightData.tocg);
		} else {
			me.Display.R5 = "__._";
		}
		
		if (fms.FlightData.zfwcg > 0) {
			me.Display.R6 = sprintf("%4.1f", fms.FlightData.zfwcg);
		} else {
			me.Display.R6 = "__._";
		}
	},
	softKey: func(k) {
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		if (k == "l1") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 3) and mcdu.unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if (me.scratchpad >= 0 and me.scratchpad <= 9.9) {
						me.Value.taxiInsertStatus = fms.FPLN.insertTaxiFuel(me.scratchpad);
						if (me.Value.taxiInsertStatus == 0) {
							fms.FlightData.taxiFuelSet = 1;
							mcdu.unit[me.id].scratchpadClear();
						} else if (me.Value.taxiInsertStatus == 1) {
							mcdu.unit[me.id].setMessage("TOGW OUT OF RANGE");
						} else if (me.Value.taxiInsertStatus == 2) {
							mcdu.unit[me.id].setMessage("ZFW OUT OF RANGE");
						}
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r1") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 5) and mcdu.unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if (me.scratchpad >= 1 and me.scratchpad <= 300) {
						if (fms.FPLN.insertBlockFuel(me.scratchpad)) {
							mcdu.unit[me.id].scratchpadClear();
						} else {
							mcdu.unit[me.id].setMessage("TOGW OUT OF RANGE");
						}
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r2") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 5) and mcdu.unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if (me.scratchpad >= 1 and me.scratchpad <= 633) {
						if (fms.FPLN.insertTogw(me.scratchpad)) {
							mcdu.unit[me.id].scratchpadClear();
						} else {
							mcdu.unit[me.id].setMessage("ZFW OUT OF RANGE");
						}
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				mcdu.unit[me.id].clearMessage(1);
				mcdu.unit[me.id].scratchpad = sprintf("%5.1f", math.round(pts.Fdm.JSBsim.Inertia.weightLbs.getValue() / 1000, 0.1) - fms.FlightData.taxiFuel);
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r3") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 5) and mcdu.unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if (me.scratchpad >= 1 and me.scratchpad <= BASE.initPage2.maxZfw) {
						if (fms.FPLN.insertZfw(me.scratchpad)) {
							mcdu.unit[me.id].scratchpadClear();
						} else {
							mcdu.unit[me.id].setMessage("TOGW OUT OF RANGE");
						}
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				mcdu.unit[me.id].clearMessage(1);
				mcdu.unit[me.id].scratchpad = sprintf("%5.1f", math.round(pts.Fdm.JSBsim.Inertia.zfwLbs.getValue() / 1000, 0.1));
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r5") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 4) and mcdu.unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if (me.scratchpad >= 1 and me.scratchpad <= 35) {
						fms.FlightData.tocg = me.scratchpad;
						mcdu.unit[me.id].scratchpadClear();
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				mcdu.unit[me.id].clearMessage(1);
				mcdu.unit[me.id].scratchpad = sprintf("%4.1f", math.round(pts.Fdm.JSBsim.Inertia.cgPercentMac.getValue(), 0.1));
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r6") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 4) and mcdu.unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if (me.scratchpad >= 1 and me.scratchpad <= 34) {
						fms.FlightData.zfwcg = me.scratchpad;
						mcdu.unit[me.id].scratchpadClear();
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				mcdu.unit[me.id].clearMessage(1);
				mcdu.unit[me.id].scratchpad = sprintf("%4.1f", math.round(pts.Fdm.JSBsim.Inertia.zfwcgPercentMac.getValue(), 0.1));
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};

var Init3 = {
	new: func(n) {
		var m = {parents: [Init3]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			CTranslate: [0, 0, 0, 0, 0, 0],
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
			L1: "[  .]",
			L1S: "REFUEL QTY",
			L2: "[ .]",
			L2S: "BLST FUEL",
			L3: "_",
			L3S: "BLST TANK",
			L4: "",
			L4S: "",
			L5: "",
			L5S: "",
			L6: "",
			L6S: "",
			
			pageNum: "3/3",
			
			RFont: [FONT.small, FONT.small, FONT.small, FONT.small, FONT.normal, FONT.normal],
			R1: "---.-",
			R1S: "DUMP TO GW",
			R2: "----",
			R2S: "DUMP TIME",
			R3: "JET A",
			R3S: "FUEL TYPE",
			R4: "-40",
			R4S: "FREEZE TEMP",
			R5: "FUEL DIPSTICK>",
			R5S: "",
			R6: "",
			R6S: "",
			
			simple: 1,
			title: "FUEL INIT",
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
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		#} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		#}
	},
};

var CompRte = {
	new: func(n) {
		var m = {parents: [CompRte]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			CTranslate: [0, 0, 0, 0, 0, 0],
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
			L1: "NONE",
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
			R6: "F-PLN INIT>",
			R6S: "RETURN TO ",
			
			simple: 1,
			title: "",
		};
		
		m.group = "fmc";
		m.name = "compRte";
		m.nextPage = "none";
		
		return m;
	},
	setup: func() {
		if (fms.FlightData.airportTo != "") {
			me.Display.title = fms.FlightData.airportFrom ~ "/" ~ fms.FlightData.airportTo;
		}
	},
	loop: func() {
	},
	softKey: func(k) {
		if (k == "r6") {
			mcdu.unit[me.id].setPage("init");
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};
