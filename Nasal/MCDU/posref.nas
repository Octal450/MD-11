# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2025 Josh Davidson (Octal450)

var PosRef = {
	new: func(n) {
		var m = {parents: [PosRef]};
		
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
			L1L: "",
			L1: "",
			L2L: " IRS (MIX)",
			L2: "",
			L3L: "",
			L3: "",
			L4L: " RNP ACTUAL",
			L4: "2.00/0.05NM",
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
			
			pageNum: "1/3",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "GPS NAV ",
			R5: "",
			R6L: "RETURN TO ",
			R6: "",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "POS REF",
			titleTranslate: 0,
		};
		
		m.Value = {
			frozen: 0,
			positionMode: "",
			positionString: "",
		};
		
		m.fromPage = "";
		m.group = "fmc";
		m.name = "posRef";
		m.nextPage = "irsGnsPos";
		m.scratchpadState = 0;
		
		return m;
	},
	reset: func() {
		me.setup();
	},
	setup: func() {
		if (mcdu.unit[me.id].lastFmcPage == "init") {
			me.fromPage = "init";
			me.Display.R6 = "F-PLN INIT>";
		} else {
			me.fromPage = "ref";
			me.Display.R6 = "REF INDEX>";
		}
		me.Value.frozen = 0;
	},
	loop: func() {
		if (fms.flightData.gpsEnable) {
			me.Display.R5 = "INHIBIT*";
			if (systems.IRS.Iru.anyAligned.getValue()) {
				me.Value.positionMode = "(G/I)";
			} else {
				me.Value.positionMode = "(G)";
			}
		} else {
			me.Display.R5 = "ENABLE*";
			if (systems.IRS.Iru.anyAligned.getValue()) {
				me.Value.positionMode = "(I)";
			} else {
				me.Value.positionMode = "(NO NAV)";
			}
		}
		
		if (me.Value.positionMode != "(NO NAV)") {
			me.Value.positionString = positionFormat(pts.Position.node);
			me.Display.L1 = me.Value.positionString;
			me.Display.L2 = me.Value.positionString;
		} else {
			me.Display.L1 = "-----.-/------.-";
			me.Display.L2 = "-----.-/------.-";
		}
		
		if (!me.Value.frozen) {
			me.Display.L1L = " FMC LAT/LONG " ~ me.Value.positionMode;
		} else {
			me.Display.L1L = " POS FROZEN " ~ me.Value.positionMode
		}
	},
	softKey: func(k) {
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		if (k == "l1") {
			if (me.scratchpadState == 1) {
				me.Value.frozen = !me.Value.frozen;
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r5") {
			fms.flightData.gpsEnable = !fms.flightData.gpsEnable;
		} else if (k == "r6") {
			if (me.fromPage == "init") {
				mcdu.unit[me.id].setPage("init");
			} else {
				mcdu.unit[me.id].setPage("ref");
			}
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};

var IrsGnsPos = {
	new: func(n) {
		var m = {parents: [IrsGnsPos]};
		
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
			L1L: "",
			L1: "",
			L2L: "",
			L2: "",
			L3L: "",
			L3: "",
			L4L: " GNS 1 - NAV",
			L4: "",
			L5L: " GNS 2 - NAV",
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
			
			pageNum: "2/3",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "6SV ",
			R4: "000g/00",
			R5L: "5SV ",
			R5: "000g/00",
			R6L: "RETURN TO ",
			R6: "",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "IRS/GNS POS",
			titleTranslate: 0,
		};
		
		m.Value = {
			positionString: "",
		};
		
		m.fromPage = "";
		m.group = "fmc";
		m.name = "irsGnsPos";
		m.nextPage = "irsStatus";
		
		return m;
	},
	reset: func() {
		me.setup();
	},
	setup: func() {
		me.fromPage = mcdu.unit[me.id].PageList.posRef.fromPage;
		if (me.fromPage == "init") {
			me.Display.R6 = "F-PLN INIT>";
		} else {
			me.Display.R6 = "REF INDEX>";
		}
	},
	loop: func() {
		me.Value.positionString = positionFormat(pts.Position.node);
		if (systems.IRS.Iru.aligned[0].getValue()) {
			me.Display.L1 = me.Value.positionString;
			me.Display.L1L = " IRU 1 - NAV";
			me.Display.R1 = "000g/00";
			me.Display.R1L = "";
		} else {
			me.Display.L1 = "-----.-/------.-";
			me.Display.R1 = "";
			if (systems.IRS.Iru.aligning[0].getValue()) {
				me.Display.L1L = " IRU 1 - ALIGN";
				me.Display.R1L = sprintf("%2.0f MIN", systems.IRS.Iru.alignTimeRemainingMinutes[0].getValue());
			} else {
				me.Display.L1L = " IRU 1";
				me.Display.R1L = "";
			}
		}
		
		if (systems.IRS.Iru.aligned[1].getValue()) {
			me.Display.L2 = me.Value.positionString;
			me.Display.L2L = " IRU 2 - NAV";
			me.Display.R2 = "000g/00";
			me.Display.R2L = "";
		} else {
			me.Display.L2 = "-----.-/------.-";
			me.Display.R2 = "";
			if (systems.IRS.Iru.aligning[1].getValue()) {
				me.Display.L2L = " IRU 2 - ALIGN";
				me.Display.R2L = sprintf("%2.0f MIN", systems.IRS.Iru.alignTimeRemainingMinutes[1].getValue());
			} else {
				me.Display.L2L = " IRU 2";
				me.Display.R2L = "";
			}
		}
		
		if (systems.IRS.Iru.aligned[2].getValue()) {
			me.Display.L3 = me.Value.positionString;
			me.Display.L3L = " IRU 3 - NAV";
			me.Display.R3 = "000g/00";
			me.Display.R3L = "";
		} else {
			me.Display.L3 = "-----.-/------.-";
			me.Display.R3 = "";
			if (systems.IRS.Iru.aligning[2].getValue()) {
				me.Display.L3L = " IRU 3 - ALIGN";
				me.Display.R3L = sprintf("%2.0f MIN", systems.IRS.Iru.alignTimeRemainingMinutes[2].getValue());
			} else {
				me.Display.L3L = " IRU 3";
				me.Display.R3L = "";
			}
		}
		
		me.Display.L4 = me.Value.positionString;
		me.Display.L5 = me.Value.positionString;
	},
	softKey: func(k) {
		if (k == "r6") {
			if (me.fromPage == "init") {
				mcdu.unit[me.id].setPage("init");
			} else {
				mcdu.unit[me.id].setPage("ref");
			}
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};

var IrsStatus = {
	new: func(n) {
		var m = {parents: [IrsStatus]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [-4, 0, 0, 0, 0, 0],
			CTranslate: [4, 4, 4, 0, 0, 0],
			C1L: "DRIFT RATE",
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
			
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.small, FONT.small],
			L1L: "",
			L1: "IRU1",
			L2L: "",
			L2: "IRU2",
			L3L: "",
			L3: "IRU3",
			L4L: "",
			L4: "",
			L5L: " STATUS CODE",
			L5: "IRU1     00",
			L6L: "IRU2     00",
			L6: "IRU3     00",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "3/3",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "GS ",
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
			R6: "",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "IRS STATUS",
			titleTranslate: 0,
		};
		
		m.fromPage = "";
		m.group = "fmc";
		m.name = "irsStatus";
		m.nextPage = "posRef";
		
		return m;
	},
	reset: func() {
		me.setup();
	},
	setup: func() {
		me.fromPage = mcdu.unit[me.id].PageList.posRef.fromPage;
		if (me.fromPage == "init") {
			me.Display.R6 = "F-PLN INIT>";
		} else {
			me.Display.R6 = "REF INDEX>";
		}
	},
	loop: func() {
		pts.Velocities.groundspeedKtTemp = pts.Velocities.groundspeedKt.getValue();
		if (systems.IRS.Iru.aligned[0].getValue()) {
			me.Display.C1 = " 0";
			me.Display.R1 = sprintf("%3.0f ",pts.Velocities.groundspeedKtTemp);
		} else {
			me.Display.C1 = " -";
			me.Display.R1 = "- ";
		}
		
		if (systems.IRS.Iru.aligned[1].getValue()) {
			me.Display.C2 = " 0";
			me.Display.R2 = sprintf("%3.0f ",pts.Velocities.groundspeedKtTemp);
		} else {
			me.Display.C2 = " -";
			me.Display.R2 = "- ";
		}
	
		if (systems.IRS.Iru.aligned[2].getValue()) {
			me.Display.C3 = " 0";
			me.Display.R3 = sprintf("%3.0f ",pts.Velocities.groundspeedKtTemp);
		} else {
			me.Display.C3 = " -";
			me.Display.R3 = "- ";
		}
	},
	softKey: func(k) {
		if (k == "r6") {
			if (me.fromPage == "init") {
				mcdu.unit[me.id].setPage("init");
			} else {
				mcdu.unit[me.id].setPage("ref");
			}
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};
