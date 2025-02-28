# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2025 Josh Davidson (Octal450)

var ThrLim = {
	new: func(n) {
		var m = {parents: [ThrLim]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			CLTranslate: [-4, -4, -4, -4, -4, -4],
			CTranslate: [-4, -4, -4, -4, -4, -4],
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
			L1L: "",
			L1: "",
			L2L: "",
			L2: "",
			L3L: "",
			L3: " MCT",
			L4L: "",
			L4: " CLB",
			L5L: "",
			L5: "",
			L6L: "",
			L6: " CRZ",
			
			LBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
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
			R6L: "RETURN TO ",
			R6: "",
			
			RBFont: [FONT.small, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "",
			titleTranslate: 1,
		};
		
		m.fromPage = "";
		m.group = "fmc";
		m.name = "thrLim";
		m.nextPage = "none";
		m.scratchpad = "";
		m.scratchpadState = 0;
		
		m.Value = {
			Limit: {
				auto: 0,
				climb: 0,
				cruise: 0,
				goAround: 0,
				mct: 0,
				mode: 0,
				pwDerate: 0,
				takeoff: 0,
				takeoffNoFlex: 0,
			},
			pw: 0,
			toPhase: 0,
		};
		
		return m;
	},
	setup: func() {
		if (mcdu.unit[me.id].lastFmcPage == "takeoff") {
			me.fromPage = "takeoff";
			me.Display.R6 = "TAKEOFF>";
		} else {
			me.fromPage = "perf"; # Which page is handled by MCDU.nas
			me.Display.R6 = "PERF MODE>";
		}
		if (pts.Options.eng.getValue() == "PW") {
			me.Display.C1L = " EPR";
			me.Value.pw = 1;
		} else {
			me.Display.C1L = "N1";
			me.Value.pw = 0;
		}
	},
	loop: func() {
		me.Value.Limit.mode = systems.FADEC.Limit.activeModeInt.getValue();
		if ((fms.Internal.phase >= 2 and me.Value.Limit.mode != 0) or me.Value.Limit.mode == 1) { # Before FLEX check below
			me.Value.toPhase = 0;
		} else {
			me.Value.toPhase = 1;
		}
		if (me.Value.Limit.mode == 0 and fms.FlightData.flexActive) me.Value.Limit.mode = 5; # T/O FLEX mode
		
		me.Value.Limit.auto = systems.FADEC.Limit.auto.getBoolValue();
		me.Value.Limit.climb = systems.FADEC.Limit.climb.getValue();
		me.Value.Limit.cruise = systems.FADEC.Limit.cruise.getValue();
		me.Value.Limit.goAround = systems.FADEC.Limit.goAround.getValue();
		me.Value.Limit.mct = systems.FADEC.Limit.mct.getValue();
		me.Value.Limit.pwDerate = systems.FADEC.Limit.pwDerate.getBoolValue();
		me.Value.Limit.takeoffFlex = systems.FADEC.Limit.takeoffFlex.getValue();
		me.Value.Limit.takeoffNoFlex = systems.FADEC.Limit.takeoffNoFlex.getValue();
		
		if (me.Value.Limit.auto) {
			me.Display.title = "AUTO THRUST LIMITS";
			me.Display.R5 = "";
			me.Display.R5L = "";
		} else {
			me.Display.title = "MANUAL THRUST LIMITS";
			me.Display.R5 = "AUTO*";
			me.Display.R5L = "SELECT ";
		}
		
		if (me.Value.toPhase) {
			me.Display.L1 = " T/O";
			
			if (fms.FlightData.flexActive) {
				me.Display.L2 = " T/O";
				me.Display.L2L = " FLX DERATE";
				
				if (me.Value.pw) {
					me.Display.C2 = " " ~ sprintf("%4.2f", math.round(me.Value.Limit.takeoffFlex, 0.01));
				} else {
					if (me.Value.Limit.takeoffFlex < 100) {
						me.Display.C2 = " " ~ sprintf("%4.1f", me.Value.Limit.takeoffFlex);
					} else {
						me.Display.C2 = sprintf("%5.1f", me.Value.Limit.takeoffFlex);
					}
				}
			} else {
				me.Display.L2 = "";
				me.Display.L2L = "";
				me.Display.C2 = "";
			}
			
			if (me.Value.pw) {
				me.Display.C1 = " " ~ sprintf("%4.2f", math.round(me.Value.Limit.takeoffNoFlex, 0.01));
			} else {
				if (me.Value.Limit.takeoffNoFlex < 100) {
					me.Display.C1 = " " ~ sprintf("%4.1f", me.Value.Limit.takeoffNoFlex);
				} else {
					me.Display.C1 = sprintf("%5.1f", me.Value.Limit.takeoffNoFlex);
				}
			}
			
			if (fms.FlightData.flexActive) {
				me.Display.R1 = sprintf("%d", fms.FlightData.flexTemp) ~ "g";
			} else {
				me.Display.R1 = "[ ]*";
			}
			me.Display.R1L = "TAT   FLEX ";
		} else {
			me.Display.L1 = " G/A";
			
			if (me.Value.pw) {
				me.Display.C1 = " " ~ sprintf("%4.2f", math.round(me.Value.Limit.goAround, 0.01));
			} else {
				if (me.Value.Limit.goAround < 100) {
					me.Display.C1 = " " ~ sprintf("%4.1f", me.Value.Limit.goAround);
				} else {
					me.Display.C1 = sprintf("%5.1f", me.Value.Limit.goAround);
				}
			}
			
			me.Display.R1 = "";
			me.Display.R1L = "TAT        ";
		}
		
		if (me.Value.pw) {
			if (me.Value.Limit.pwDerate) {
				me.Display.L1L = " 60K";
			} else {
				me.Display.L1L = " 62K";
			}
		} else {
			me.Display.L1L = "";
		}
		
		if (me.Value.pw) {
			me.Display.C3 = " " ~ sprintf("%4.2f", math.round(me.Value.Limit.mct, 0.01));
		} else {
			if (me.Value.Limit.mct < 100) {
				me.Display.C3 = " " ~ sprintf("%4.1f", me.Value.Limit.mct);
			} else {
				me.Display.C3 = sprintf("%5.1f", me.Value.Limit.mct);
			}
		}
		
		if (me.Value.pw) {
			me.Display.C4 = " " ~ sprintf("%4.2f", math.round(me.Value.Limit.climb, 0.01));
		} else {
			if (me.Value.Limit.climb < 100) {
				me.Display.C4 = " " ~ sprintf("%4.1f", me.Value.Limit.climb);
			} else {
				me.Display.C4 = sprintf("%5.1f", me.Value.Limit.climb);
			}
		}
		
		if (me.Value.pw) {
			me.Display.C6 = " " ~ sprintf("%4.2f", math.round(me.Value.Limit.cruise, 0.01));
		} else {
			if (me.Value.Limit.cruise < 100) {
				me.Display.C6 = " " ~ sprintf("%4.1f", me.Value.Limit.cruise);
			} else {
				me.Display.C6 = sprintf("%5.1f", me.Value.Limit.cruise);
			}
		}
		
		if (me.Value.Limit.mode == 0 or me.Value.Limit.mode == 1) {
			me.Display.CFont = [FONT.normal, FONT.small, FONT.small, FONT.small, FONT.small, FONT.small];
			me.Display.L1B = "a";
			me.Display.L2B = "";
			me.Display.L3B = "";
			me.Display.L4B = "";
			me.Display.L6B = "";
		} else if (me.Value.Limit.mode == 5) {
			me.Display.CFont = [FONT.small, FONT.normal, FONT.small, FONT.small, FONT.small, FONT.small];
			me.Display.L1B = "*";
			me.Display.L2B = "a";
			me.Display.L3B = "";
			me.Display.L4B = "";
			me.Display.L6B = "";
		} else if (me.Value.Limit.mode == 2) {
			me.Display.CFont = [FONT.small, FONT.small, FONT.normal, FONT.small, FONT.small, FONT.small];
			me.Display.L1B = "";
			me.Display.L2B = "";
			me.Display.L3B = "a";
			me.Display.L4B = "";
			me.Display.L6B = "";
		} else if (me.Value.Limit.mode == 3) {
			me.Display.CFont = [FONT.small, FONT.small, FONT.small, FONT.normal, FONT.small, FONT.small];
			me.Display.L1B = "";
			me.Display.L2B = "";
			me.Display.L3B = "";
			me.Display.L4B = "a";
			me.Display.L6B = "";
		} else if (me.Value.Limit.mode == 4) {
			me.Display.CFont = [FONT.small, FONT.small, FONT.small, FONT.small, FONT.small, FONT.normal];
			me.Display.L1B = "";
			me.Display.L2B = "";
			me.Display.L3B = "";
			me.Display.L4B = "";
			me.Display.L6B = "a";
		}
		
		me.Display.R1B = math.round(pts.Fdm.JSBSim.Propulsion.tatC.getValue()) ~ "g        ";
		
		if (me.Value.pw and (me.Value.Limit.mode == 0 or me.Value.Limit.mode == 1)) {
			if (me.Value.Limit.pwDerate) {
				me.Display.R3 = "62K*";
			} else {
				me.Display.R3 = "60K*";
			}
			me.Display.R3L = "SELECT ";
		} else {
			me.Display.R3 = "";
			me.Display.R3L = "";
		}
	},
	softKey: func(k) {
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		if (k == "l1") {
			if (fms.FlightData.flexActive) {
				fms.FlightData.flexActive = 0;
				fms.FlightData.flexTemp = 0;
				fms.EditFlightData.resetVspeeds();
			} else {
				systems.FADEC.Limit.auto.setBoolValue(0);
			}
			
			if (me.Value.toPhase == 1) {
				systems.FADEC.setMode(0);
			} else {
				systems.FADEC.setMode(1);
			}
		} else if (k == "l2") {
			if (me.Display.L2 != "" and me.Value.toPhase == 1) {
				systems.FADEC.Limit.auto.setBoolValue(0);
				systems.FADEC.setMode(0);
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l3") {
			systems.FADEC.Limit.auto.setBoolValue(0);
			systems.FADEC.setMode(2);
		} else if (k == "l4") {
			systems.FADEC.Limit.auto.setBoolValue(0);
			systems.FADEC.setMode(3);
		} else if (k == "l6") {
			systems.FADEC.Limit.auto.setBoolValue(0);
			systems.FADEC.setMode(4);
		} else if (k == "r1") { # Also in toappr.nas
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 2) and mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad >= math.round(pts.Fdm.JSBSim.Propulsion.tatC.getValue()) and me.scratchpad <= 70) {
						if (systems.FADEC.Limit.activeModeInt.getValue() != 0) {
							if (!systems.FADEC.Limit.auto.getBoolValue()) {
								systems.FADEC.setMode(0);
							}
						}
						
						fms.FlightData.flexActive = 1;
						fms.FlightData.flexTemp = int(me.scratchpad);
						systems.FADEC.Limit.pwDerate.setBoolValue(1);
						fms.EditFlightData.resetVspeeds();
						mcdu.unit[me.id].scratchpadClear();
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 0) {
				fms.FlightData.flexActive = 0;
				fms.FlightData.flexTemp = 0;
				fms.EditFlightData.resetVspeeds();
				mcdu.unit[me.id].scratchpadClear();
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r3") {
			if (me.Display.R3 != "") {
				systems.FADEC.Limit.pwDerate.setBoolValue(!systems.FADEC.Limit.pwDerate.getBoolValue());
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r5") {
			if (me.Display.R5 != "") {
				systems.FADEC.Limit.auto.setBoolValue(1);
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r6") {
			mcdu.unit[me.id].setPage(me.fromPage);
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};
