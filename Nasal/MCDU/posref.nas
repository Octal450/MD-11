# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)

var PosRef = {
	new: func(n) {
		var m = {parents: [PosRef]};
		
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
			L1S: "",
			L1: "",
			L2S: " IRS (MIX)",
			L2: "",
			L3S: "",
			L3: "",
			L4S: " RNP ACTUAL",
			L4: "2.00/0.05NM",
			L5S: "",
			L5: "",
			L6S: "",
			L6: "",
			
			pageNum: "1/3",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1S: "",
			R1: "",
			R2S: "",
			R2: "",
			R3S: "",
			R3: "",
			R4S: "",
			R4: "",
			R5S: "GPS NAV ",
			R5: "",
			R6S: "RETURN TO ",
			R6: "",
			
			title: "POS REF",
		};
		
		m.Value = {
			frozen: 0,
			gpsEnable: 1,
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
		me.Value.gpsEnable = 1;
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
		if (me.Value.positionMode != "(NO NAV)") {
			me.Value.positionString = positionFormat(pts.Position.node);
			me.Display.L1 = me.Value.positionString;
			me.Display.L2 = me.Value.positionString;
		} else {
			me.Display.L1 = "-----.-/------.-";
			me.Display.L2 = "-----.-/------.-";
		}
		
		if (!me.Value.frozen) {
			me.Display.L1S = " FMC LAT/LONG " ~ me.Value.positionMode;
		} else {
			me.Display.L1S = " POS FROZEN " ~ me.Value.positionMode
		}
		
		if (me.Value.gpsEnable) {
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
			me.Value.gpsEnable = !me.Value.gpsEnable;
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
			L1: "",
			L2S: "",
			L2: "",
			L3S: "",
			L3: "",
			L4S: " GNS 1 - NAV",
			L4: "",
			L5S: " GNS 2 - NAV",
			L5: "",
			L6S: "",
			L6: "",
			
			pageNum: "2/3",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1S: "",
			R1: "",
			R2S: "",
			R2: "",
			R3S: "",
			R3: "",
			R4S: "6SV ",
			R4: "000g/00",
			R5S: "5SV ",
			R5: "000g/00",
			R6S: "RETURN TO ",
			R6: "",
			
			title: "IRS/GNS POS",
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
			me.Display.L1S = " IRU 1 - NAV";
			me.Display.R1 = "000g/00";
			me.Display.R1S = "";
		} else {
			me.Display.L1 = "-----.-/------.-";
			me.Display.R1 = "";
			if (systems.IRS.Iru.aligning[0].getValue()) {
				me.Display.L1S = " IRU 1 - ALIGN";
				me.Display.R1S = sprintf("%2.0f MIN", systems.IRS.Iru.alignTimeRemainingMinutes[0].getValue());
			} else {
				me.Display.L1S = " IRU 1";
				me.Display.R1S = "";
			}
		}
		
		if (systems.IRS.Iru.aligned[1].getValue()) {
			me.Display.L2 = me.Value.positionString;
			me.Display.L2S = " IRU 2 - NAV";
			me.Display.R2 = "000g/00";
			me.Display.R2S = "";
		} else {
			me.Display.L2 = "-----.-/------.-";
			me.Display.R2 = "";
			if (systems.IRS.Iru.aligning[1].getValue()) {
				me.Display.L2S = " IRU 2 - ALIGN";
				me.Display.R2S = sprintf("%2.0f MIN", systems.IRS.Iru.alignTimeRemainingMinutes[1].getValue());
			} else {
				me.Display.L2S = " IRU 2";
				me.Display.R2S = "";
			}
		}
		
		if (systems.IRS.Iru.aligned[2].getValue()) {
			me.Display.L3 = me.Value.positionString;
			me.Display.L3S = " IRU 3 - NAV";
			me.Display.R3 = "000g/00";
			me.Display.R3S = "";
		} else {
			me.Display.L3 = "-----.-/------.-";
			me.Display.R3 = "";
			if (systems.IRS.Iru.aligning[2].getValue()) {
				me.Display.L3S = " IRU 3 - ALIGN";
				me.Display.R3S = sprintf("%2.0f MIN", systems.IRS.Iru.alignTimeRemainingMinutes[2].getValue());
			} else {
				me.Display.L3S = " IRU 3";
				me.Display.R3S = "";
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
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			CSTranslate: [-80, 0, 0, 0, 0, 0],
			CTranslate: [160, 160, 160, 0, 0, 0],
			C1S: "DRIFT RATE",
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
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.small, FONT.small],
			L1S: "",
			L1: "IRU1",
			L2S: "",
			L2: "IRU2",
			L3S: "",
			L3: "IRU3",
			L4S: "",
			L4: "",
			L5S: " STATUS CODE",
			L5: "IRU1        00",
			L6S: "IRU2        00",
			L6: "IRU3        00",
			
			pageNum: "3/3",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1S: "GS ",
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
			R6: "",
			
			title: "IRS STATUS",
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
