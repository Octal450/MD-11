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
			L1: "__________",
			L1S: "CO ROUTE",
			L2: "----------",
			L2S: "ALTN ROUTE",
			L3: "",
			L3S: "LAT",
			L4: "",
			L4S: "FLT NO",
			L5: "---/---/---/---/---/---",
			L5S: "CRZ LEVELS",
			L6: "---g/-----",
			L6S: "TEMP/WIND",
			
			pageNum: "1/3",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1: "_____/_____",
			R1S: "FROM/ TO   ",
			R2: "-----",
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
			title: "F-PLN INIT  ",
		};
		
		m.Value = {
			positionSplit: ["", ""],
		};
		
		m.group = "fmc";
		m.name = "init";
		m.nextPage = "init2";
		m.scratchpad = "";
		m.scratchpadState = 0;
		
		m.Value = {
			databaseConfirm: 0,
		};
		
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
		
		if (fms.FlightData.flightNumber != "") {
			me.Display.L4 = fms.FlightData.flightNumber;
		} else {
			me.Display.L4 = "________";
		}
		
		if (systems.IRS.Switch.mcduBtn.getBoolValue()) {
			me.Display.R4 = "POS REF>";
		} else {
			me.Display.R4 = "INITIALIZE IRS*";
		}
		
		if (fms.FlightData.costIndex != 0) {
			me.Display.R6 = fms.FlightData.costIndex;
		#} else if () { # FROM/TO set
		#	me.Display.R6 = "___";
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
			if (me.scratchpadState == 0) {
				fms.FlightData.costIndex = 0;
				mcdu.unit[me.id].scratchpadClear();
			} else if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 3) and mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad > 1) {
						fms.FlightData.costIndex = me.scratchpad;
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
