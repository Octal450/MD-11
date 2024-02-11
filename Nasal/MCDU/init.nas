# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)

var Init = {
	new: func(n) {
		var m = {parents: [Init]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
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
			C6: "     ---/---",
			C6S: "      OPT/MAXFL",
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1: "",
			L1S: "CO ROUTE",
			L2: "",
			L2S: "ALTN ROUTE",
			L3: "",
			L3S: "LAT",
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
			R3S: "LONG",
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
	},
	loop: func() {
		me.Value.positionSplit = split("/", positionFormat(pts.Position.node));
		me.Display.L3 = me.Value.positionSplit[0];
		me.Display.R3 = me.Value.positionSplit[1];
		
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
		
		if (k == "l4") {
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
		} else if (k == "r4") {
			if (systems.IRS.Switch.mcduBtn.getBoolValue()) {
				mcdu.unit[me.id].setPage("posRef");
			} else {
				if (systems.IRS.Switch.knob[0].getBoolValue() or systems.IRS.Switch.knob[1].getBoolValue() or systems.IRS.Switch.knob[2].getBoolValue()) {
					systems.IRS.Switch.mcduBtn.setBoolValue(1);
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			}
		} else if (k == "r6") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 3) and mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad > 1) {
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

var CompRte = {
	new: func(n) {
		var m = {parents: [CompRte]};
		
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
