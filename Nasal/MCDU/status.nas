# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)

var AcStatus = {
	new: func(n) {
		var m = {parents: [AcStatus]};
		
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
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.small, FONT.normal, FONT.normal],
			L1S: " MODEL",
			L1: "",
			L2S: " OP PROGRAM",
			L2: BASE.acStatus.program,
			L3S: " ACTIVE DATA BASE",
			L3: "",
			L4S: " SECOND DATA BASE",
			L4: "",
			L5S: "",
			L5: "",
			L6S: " PERF FACTOR",
			L6: "",
			
			pageNum: "1/2",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1S: "ENGINE ",
			R1: BASE.acStatus.eng,
			R2S: "",
			R2: "",
			R3S: "",
			R3: "",
			R4S: "",
			R4: "",
			R5S: "",
			R5: "",
			R6S: "",
			R6: "F-PLN INIT>",
			
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
		
		if (BASE.acStatus.databaseSelected) {
			me.Display.L3 = BASE.acStatus.database2;
			me.Display.L4 = BASE.acStatus.database;
			me.Display.R3 = BASE.acStatus.databaseCode2;
		} else {
			me.Display.L3 = BASE.acStatus.database;
			me.Display.L4 = BASE.acStatus.database2;
			me.Display.R3 = BASE.acStatus.databaseCode;
		}
		
		me.Display.L6 = sprintf("%+2.1f", BASE.acStatus.perfFactor);
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
						BASE.acStatus.perfFactor = me.scratchpad;
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
				BASE.acStatus.databaseSelected = !BASE.acStatus.databaseSelected;
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
			L1: BASE.acStatus2.perfDbPn,
			L1S: " PERF DATABASE",
			L2: BASE.acStatus2.opcPn,
			L2S: " OPC P/N",
			L3: BASE.acStatus2.amiPn,
			L3S: " AMI P/N",
			L4: BASE.acStatus2.fidoPn,
			L4S: " FIDO P/N",
			L5: BASE.acStatus2.dataLink,
			L5S: " DATA LINK",
			L6: "",
			L6S: "",
			
			pageNum: "2/2",
			
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
			R6S: "",
			R6: "F-PLN INIT>",
			
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
			CSTranslate: [0, 0, 0, 0, 0, 0],
			CTranslate: [0, 0, 0, 0, 0, 0],
			C1S: "   3",
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
			L1S: "           1",
			L1: "",
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
			R1S: "2    ",
			R1: "",
			R2S: "",
			R2: "",
			R3S: "",
			R3: "",
			R4S: "",
			R4: "",
			R5S: "",
			R5: "",
			R6S: "",
			R6: "",
			
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
