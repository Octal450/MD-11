# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)

var AcStatus = {
	new: func(n) {
		var m = {parents: [AcStatus]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
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
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.small, FONT.normal, FONT.normal],
			L1L: " MODEL",
			L1: "",
			L2L: " OP PROGRAM",
			L2: BASE.acStatus.program,
			L3L: " ACTIVE DATA BASE",
			L3: "",
			L4L: " SECOND DATA BASE",
			L4: "",
			L5L: "",
			L5: "",
			L6L: " PERF FACTOR",
			L6: "",
			
			LBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "1/2",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1L: "ENGINE ",
			R1: BASE.acStatus.eng,
			R2L: "",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "",
			R6: "F-PLN INIT>",
			
			RBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "A/C STATUS",
			titleTranslate: 0,
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
		if (pts.Systems.Acconfig.Options.deflectedAileron.getBoolValue()) {
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
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1: BASE.acStatus2.perfDbPn,
			L1L: " PERF DATABASE",
			L2: BASE.acStatus2.opcPn,
			L2L: " OPC P/N",
			L3: BASE.acStatus2.amiPn,
			L3L: " AMI P/N",
			L4: BASE.acStatus2.fidoPn,
			L4L: " FIDO P/N",
			L5: BASE.acStatus2.dataLink,
			L5L: " DATA LINK",
			L6: "",
			L6L: "",
			
			LBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "2/2",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
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
			R6L: "",
			R6: "F-PLN INIT>",
			
			RBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "A/C STATUS",
			titleTranslate: 0,
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
			
			CFont: [FONT.small, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			CLTranslate: [0, 0, 0, 0, 0, 0],
			CTranslate: [0, 0, 0, 0, 0, 0],
			C1L: "  3/AUX",
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
			
			LFont: [FONT.small, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1L: "        1",
			L1: "",
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
			
			LBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RFont: [FONT.small, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1L: "2   ",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "",
			R6: "",
			
			RBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "SENSOR STATUS",
			titleTranslate: 0,
		};
		
		m.Value = {
			IruFailure: [0, 0, 0],
		};
		
		m.group = "fmc";
		m.name = "sensorStatus";
		m.nextPage = "none";
		
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
				me.Display.L1 = "IRU   FAIL";
			} else {
				me.Display.L1 = "IRU";
			}
			
			if (me.Value.IruFailure[1]) {
				me.Display.C1 = "  FAIL";
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
