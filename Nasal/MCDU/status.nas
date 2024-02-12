# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)

var AcStatus = {
	new: func(n) {
		var m = {parents: [AcStatus]};
		
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
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.small, FONT.normal, FONT.normal],
			L1: "",
			L1S: " MODEL",
			L2: mcdu.BASE.acStatus.program,
			L2S: " OP PROGRAM",
			L3: "",
			L3S: " ACTIVE DATA BASE",
			L4: "",
			L4S: " SECOND DATA BASE",
			L5: "",
			L5S: "",
			L6: "",
			L6S: " PERF FACTOR",
			
			pageNum: "1/2",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1: mcdu.BASE.acStatus.eng,
			R1S: "ENGINE ",
			R2: "",
			R2S: "",
			R3: "",
			R3S: "",
			R4: "",
			R4S: "",
			R5: "",
			R5S: "",
			R6: "F-PLN INIT>",
			R6S: "",
			
			simple: 1,
			title: "A/C STATUS",
		};
		
		m.group = "fmc";
		m.name = "acStatus";
		m.nextPage = "acStatus2";
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
		me.Value.databaseConfirm = 0;
		me.Display.R4 = "";
	},
	loop: func() {
		if (pts.Systems.Acconfig.Options.deflectedAileronEquipped.getBoolValue()) {
			me.Display.L1 = "MD-11 DEF AIL";
		} else {
			me.Display.L1 = "MD-11";
		}
		
		if (mcdu.BASE.acStatus.databaseSelected) {
			me.Display.L3 = mcdu.BASE.acStatus.database2;
			me.Display.L4 = mcdu.BASE.acStatus.database;
			me.Display.R3 = mcdu.BASE.acStatus.databaseCode2;
		} else {
			me.Display.L3 = mcdu.BASE.acStatus.database;
			me.Display.L4 = mcdu.BASE.acStatus.database2;
			me.Display.R3 = mcdu.BASE.acStatus.databaseCode;
		}
		
		me.Display.L6 = sprintf("%+2.1f", mcdu.BASE.acStatus.perfFactor);
	},
	softKey: func(k) {
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		if (k == "l4") {
			if (me.scratchpadState == 1) {
				me.Value.databaseConfirm = 1;
				me.Display.R4 = "CONFIRM*";
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l6") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringIsNumber() and mcdu.unit[me.id].stringLengthInRange(1, 3)) {
					if (abs(me.scratchpad) > 9.9) {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					} else {
						mcdu.BASE.acStatus.perfFactor = me.scratchpad;
						mcdu.unit[me.id].scratchpadClear();
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r4") {
			if (me.Value.databaseConfirm) {
				mcdu.BASE.acStatus.databaseSelected = !mcdu.BASE.acStatus.databaseSelected;
				me.Value.databaseConfirm = 0;
				me.Display.R4 = "";
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r6") {
			mcdu.unit[me.id].setPage("init");
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};

var AcStatus2 = {
	new: func(n) {
		var m = {parents: [AcStatus2]};
		
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
			L1: mcdu.BASE.acStatus2.perfDbPn,
			L1S: " PERF DATABASE",
			L2: mcdu.BASE.acStatus2.opcPn,
			L2S: " OPC P/N",
			L3: mcdu.BASE.acStatus2.amiPn,
			L3S: " AMI P/N",
			L4: mcdu.BASE.acStatus2.fidoPn,
			L4S: " FIDO P/N",
			L5: mcdu.BASE.acStatus2.dataLink,
			L5S: " DATA LINK",
			L6: "",
			L6S: "",
			
			pageNum: "2/2",
			
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
			R6S: "",
			
			simple: 1,
			title: "A/C STATUS",
		};
		
		m.group = "fmc";
		m.name = "acStatus2";
		m.nextPage = "acStatus";
		
		return m;
	},
	setup: func() {
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

var SensorStatus = {
	new: func(n) {
		var m = {parents: [SensorStatus]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			CTranslate: [0, 0, 0, 0, 0, 0],
			C1: "",
			C1S: "      3",
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
			L1S: "           1",
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
			R1S: "2    ",
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
			title: "SENSOR STATUS",
		};
		
		m.Value = {
			IruFailure: [0, 0, 0],
		};
		
		m.group = "fmc";
		m.name = "sensorStatus";
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		if (systems.IRS.Iru.aligned[0].getValue()) {
			me.Value.IruFailure[0] = 0;
		} else {
			me.Value.IruFailure[0] = 1;
		}
		
		if (systems.IRS.Iru.aligned[1].getValue()) {
			me.Value.IruFailure[1] = 0;
		} else {
			me.Value.IruFailure[1] = 1;
		}
		
		if (systems.IRS.Iru.aligned[2].getValue()) {
			me.Value.IruFailure[2] = 0;
		} else {
			me.Value.IruFailure[2] = 1;
		}
		
		if (me.Value.IruFailure[0] or me.Value.IruFailure[1] or me.Value.IruFailure[2]) {
			if (me.Value.IruFailure[0]) {
				me.Display.L1 = "IRU    FAIL";
			} else {
				me.Display.L1 = "IRU";
			}
			
			if (me.Value.IruFailure[1]) {
				me.Display.C1 = "     FAIL";
			} else {
				me.Display.C1 = "";
			}
			
			if (me.Value.IruFailure[2]) {
				me.Display.R1 = "FAIL  ";
			} else {
				me.Display.R1 = "";
			}
		} else {
			me.Display.L1 = "";
			me.Display.C1 = "";
			me.Display.R1 = "";	
		}
	},
	softKey: func(k) {
		mcdu.unit[me.id].setMessage("NOT ALLOWED");
	},
};
