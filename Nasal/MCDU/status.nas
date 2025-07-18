# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2025 Josh Davidson (Octal450)

var AcStatus = {
	Common: {
		database: "01JAN-28JAN",
		database2: "29JAN-26FEB",
		databaseCode: "MD11605001",
		databaseCode2: "MD11605002",
		databaseSelected: 1,
		eng: props.globals.getNode("/options/eng-string").getValue(),
		perfFactor: 0,
		program: "PS4070541-924", # -924 software load
	},
	new: func(n) {
		var m = {parents: [AcStatus]};
		
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
			
			LFont: [FONT.large, FONT.large, FONT.large, FONT.small, FONT.large, FONT.large],
			L1L: " MODEL",
			L1: "",
			L2L: " OP PROGRAM",
			L2: me.Common.program,
			L3L: " ACTIVE DATA BASE",
			L3: "",
			L4L: " SECOND DATA BASE",
			L4: "",
			L5L: "",
			L5: "",
			L6L: " PERF FACTOR",
			L6: "",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "1/2",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "ENGINE ",
			R1: me.Common.eng,
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
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
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
			type: pts.Options.type.getValue(),
		};
		
		return m;
	},
	reset: func() {
		me.Common.databaseSelected = 1;
		me.Common.perfFactor = 0;
		me.setup();
	},
	setup: func() {
		me.Value.databaseConfirm = 0;
		me.Display.R4 = "";
	},
	loop: func() {
		if (pts.Systems.Acconfig.Options.deflectedAileron.getBoolValue()) {
			me.Display.L1 = me.Value.type ~ " DEF AIL";
		} else {
			me.Display.L1 = me.Value.type;
		}
		
		if (me.Common.databaseSelected) {
			me.Display.L3 = me.Common.database2;
			me.Display.L4 = me.Common.database;
			me.Display.R3 = me.Common.databaseCode2;
		} else {
			me.Display.L3 = me.Common.database;
			me.Display.L4 = me.Common.database2;
			me.Display.R3 = me.Common.databaseCode;
		}
		
		me.Display.L6 = sprintf("%+2.1f", me.Common.perfFactor);
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l4") {
			if (me.scratchpadState == 1) {
				me.Value.databaseConfirm = 1;
				me.Display.R4 = "CONFIRM*";
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l6") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringIsNumber() and unit[me.id].stringLengthInRange(1, 3)) {
					if (abs(me.scratchpad) > 9.9) {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					} else {
						me.Common.perfFactor = me.scratchpad;
						unit[me.id].scratchpadClear();
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r4") {
			if (me.Value.databaseConfirm) {
				me.Common.databaseSelected = !me.Common.databaseSelected;
				me.Value.databaseConfirm = 0;
				me.Display.R4 = "";
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r6") {
			unit[me.id].setPage("init");
		} else {
			unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};

var AcStatus2 = {
	Common: {
		amiPn: "3412-HNP-08J-01",
		dataLink: "003FFC00",
		fidoPn: "341B-HNP-05M-02",
		opcPn: "3476-BCG-00T-U6",
		perfDbPn: "3401-HNP-05T-01",
	},
	new: func(n) {
		var m = {parents: [AcStatus2]};
		
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
			L1L: " PERF DATABASE",
			L1: me.Common.perfDbPn,
			L2L: " OPC P/N",
			L2: me.Common.opcPn,
			L3L: " AMI P/N",
			L3: me.Common.amiPn,
			L4L: " FIDO P/N",
			L4: me.Common.fidoPn,
			L5L: " DATA LINK",
			L5: me.Common.dataLink,
			L6L: "",
			L6: "",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "2/2",
			
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
			R6L: "",
			R6: "F-PLN INIT>",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
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
			unit[me.id].setPage("init");
		} else {
			unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};

var SensorStatus = {
	new: func(n) {
		var m = {parents: [SensorStatus]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.small, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
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
			
			LFont: [FONT.small, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
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
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RFont: [FONT.small, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
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
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
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
		unit[me.id].setMessage("NOT ALLOWED");
	},
};
