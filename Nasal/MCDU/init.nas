# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)

var Init = {
	new: func(n) {
		var m = {parents: [Init]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			CSTranslate: [0, 0, -50, 0, 0, 40],
			CTranslate: [0, 0, 0, 0, 0, 40],
			C1S: "",
			C1: "",
			C2S: "",
			C2: "",
			C3S: "GNS POS",
			C3: "",
			C4S: "",
			C4: "",
			C5S: "",
			C5: "",
			C6S: "OPT/MAXFL",
			C6: "---/---",
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1S: "CO ROUTE",
			L1: "",
			L2S: "ALTN ROUTE",
			L2: "",
			L3S: "",
			L3: "",
			L4S: "FLT NO",
			L4: "",
			L5S: "CRZ LEVELS",
			L5: "",
			L6S: "TEMP/WIND",
			L6: "",
			
			pageNum: "1/3",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1S: "FROM/ TO   ",
			R1: "",
			R2S: "ALTN",
			R2: "",
			R3S: "",
			R3: "",
			R4S: "",
			R4: "",
			R5S: "",
			R5: "",
			R6S: "CI",
			R6: "",
			
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
		
		if (fms.FlightData.airportAltn != "") {
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
			me.Value.cruiseFlText[0] = sprintf("%03d", fms.FlightData.cruiseFlAll[0]);
			
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
		
		if (fms.FlightData.airportAltn != "") {
			me.Display.R2 = fms.FlightData.airportAltn;
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
						fms.EditFlightData.insertCruiseFl(int(me.Value.cruiseInputVals[0]), int(me.Value.cruiseInputVals[1]), int(me.Value.cruiseInputVals[2]), int(me.Value.cruiseInputVals[3]), int(me.Value.cruiseInputVals[4]), int(me.Value.cruiseInputVals[5]));
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
				fms.EditFlightData.reset();
				mcdu.unit[me.id].scratchpadClear();
			} else if (me.scratchpadState == 2) {
				me.scratchpadSplit = split("/", me.scratchpad);
				if (size(me.scratchpadSplit) == 2) {
					if (mcdu.unit[me.id].stringLengthInRange(3, 4, me.scratchpadSplit[0]) and mcdu.unit[me.id].stringLengthInRange(3, 4, me.scratchpadSplit[1])) {
						if (size(findAirportsByICAO(me.scratchpadSplit[0])) == 1 and size(findAirportsByICAO(me.scratchpadSplit[1])) == 1) {
							fms.EditFlightData.newFlightplan(me.scratchpadSplit[0], me.scratchpadSplit[1]);
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
				fms.EditFlightData.insertAlternate("");
				mcdu.unit[me.id].scratchpadClear();
			} else if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(3, 4)) {
					if (size(findAirportsByICAO(me.scratchpad)) == 1) {
						if (fms.FlightData.airportTo != "") {
							fms.EditFlightData.insertAlternate(me.scratchpad);
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
			CSTranslate: [150, 0, 150, 0, 0, 0],
			CTranslate: [150, 0, 170, 0, 0, 0],
			C1S: "UFOB",
			C1: "",
			C2S: "",
			C2: "",
			C3S: "BLST",
			C3: "0.0",
			C4S: "",
			C4: "",
			C5S: "",
			C5: "",
			C6S: "",
			C6: "",
			
			LFont: [FONT.small, FONT.small, FONT.small, FONT.small, FONT.small, FONT.small],
			L1S: "",
			L1: "",
			L2S: "TRIP/TIME",
			L2: "---.-/----",
			L3S: "RTE RSV/%",
			L3: "--.-/05.0",
			L4S: "ALTN",
			L4: "---.-",
			L5S: "FINAL/TIME",
			L5: "---.-/0030",
			L6S: "EXTRA/TIME",
			L6: "---.-/----",
			
			pageNum: "2/3",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.small, FONT.normal, FONT.normal],
			R1S: "",
			R1: "",
			R2S: "",
			R2: "",
			R3S: "IN ZFW",
			R3: "",
			R4S: "LW",
			R4: "---.-",
			R5S: "TOCG",
			R5: "",
			R6S: "ZFWCG",
			R6: "",
			
			title: "WEIGHT INIT",
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
			me.Display.L1S = "";
			me.Display.L1 = "";
			me.Display.C1 = "";
			me.Display.R1S = "";
			me.Display.R1 = sprintf("%5.1f", fms.FlightData.ufobLbs) ~ "/FF+FQ";
		} else {
			me.Display.L1S = "TAXI";
			me.Display.L1 = sprintf("%3.1f", fms.FlightData.taxiFuel);
			if (fms.FlightData.taxiFuelSet) {
				me.Display.LFont[0] = FONT.normal;
			} else {
				me.Display.LFont[0] = FONT.small;
			}
			
			me.Display.C1 = sprintf("%5.1f", fms.FlightData.ufobLbs);
			me.Display.R1S = "BLOCK";
			if (fms.FlightData.blockFuelLbs != 0) {
				me.Display.R1 = sprintf("%5.1f", fms.FlightData.blockFuelLbs);
			} else {
				me.Display.R1 = "___._";
			}
		}
		
		if (fms.Internal.engOn) {
			me.Display.R2S = "GW";
			if (fms.FlightData.gwLbs > 0) {
				me.Display.R2 = sprintf("%5.1f", fms.FlightData.gwLbs);
				if (fms.FlightData.lastGwZfw) {
					me.Display.RFont[1] = FONT.small;
				} else {
					me.Display.RFont[1] = FONT.normal;
				}
			} else {
				me.Display.R2 = "___._";
				me.Display.RFont[1] = FONT.normal;
			}
		} else {
			me.Display.R2S = "TOGW";
			if (fms.FlightData.togwLbs > 0) {
				me.Display.R2 = sprintf("%5.1f", fms.FlightData.togwLbs);
				if (fms.FlightData.lastGwZfw) {
					me.Display.RFont[1] = FONT.small;
				} else {
					me.Display.RFont[1] = FONT.normal;
				}
			} else {
				me.Display.R2 = "___._";
				me.Display.RFont[1] = FONT.normal;
			}
		}
		
		if (fms.FlightData.zfwLbs > 0) {
			me.Display.R3 = sprintf("%5.1f", fms.FlightData.zfwLbs);
			if (!fms.FlightData.lastGwZfw) {
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
			if (me.scratchpadState == 2 and me.Display.L1S == "TAXI") {
				if (mcdu.unit[me.id].stringLengthInRange(1, 3) and mcdu.unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if (me.scratchpad >= 0 and me.scratchpad <= 9.9) {
						me.Value.taxiInsertStatus = fms.EditFlightData.insertTaxiFuel(me.scratchpad);
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
						if (fms.EditFlightData.insertBlockFuel(me.scratchpad)) {
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
						if (me.Display.R2S == "GW") {
							if (fms.EditFlightData.insertGw(me.scratchpad)) {
								mcdu.unit[me.id].scratchpadClear();
							} else {
								mcdu.unit[me.id].setMessage("ZFW OUT OF RANGE");
							}
						} else {
							if (fms.EditFlightData.insertTogw(me.scratchpad)) {
								mcdu.unit[me.id].scratchpadClear();
							} else {
								mcdu.unit[me.id].setMessage("ZFW OUT OF RANGE");
							}
						}
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				mcdu.unit[me.id].clearMessage(1);
				if (me.Display.R2S == "GW") {
					mcdu.unit[me.id].scratchpad = sprintf("%5.1f", math.round(pts.Fdm.JSBsim.Inertia.weightLbs.getValue() / 1000, 0.1));
				} else {
					mcdu.unit[me.id].scratchpad = sprintf("%5.1f", math.round((pts.Fdm.JSBsim.Inertia.weightLbs.getValue() / 1000) - fms.FlightData.taxiFuel, 0.1));
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r3") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 5) and mcdu.unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if (me.scratchpad >= 1 and me.scratchpad <= BASE.initPage2.maxZfw) {
						if (fms.EditFlightData.insertZfw(me.scratchpad)) {
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
			L1S: "REFUEL QTY",
			L1: "[  .]",
			L2S: "BLST FUEL",
			L2: "[ .]",
			L3S: "BLST TANK",
			L3: "_",
			L4S: "",
			L4: "",
			L5S: "",
			L5: "",
			L6S: "",
			L6: "",
			
			pageNum: "3/3",
			
			RFont: [FONT.small, FONT.small, FONT.small, FONT.small, FONT.normal, FONT.normal],
			R1S: "DUMP TO GW",
			R1: "---.-",
			R2S: "DUMP TIME",
			R2: "----",
			R3S: "FUEL TYPE",
			R3: "JET A",
			R4S: "FREEZE TEMP",
			R4: "-40",
			R5S: "",
			R5: "FUEL DIPSTICK>",
			R6S: "",
			R6: "",
			
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
			L1: "NONE",
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
			R6S: "RETURN TO ",
			R6: "F-PLN INIT>",
			
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
