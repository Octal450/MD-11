# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2025 Josh Davidson (Octal450)
# Where needed + 0 is used to force a string to a number

var Takeoff = {
	new: func(n) {
		var m = {parents: [Takeoff]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.small, FONT.small, FONT.small, FONT.small, FONT.small, FONT.small],
			CLTranslate: [-4, -4, -4, -4, -4, -4],
			CTranslate: [-4, -4, -4, -4, -4, -4],
			C1L: "TOCG/TOGW",
			C1: "",
			C2L: "",
			C2: "",
			C3L: "STAB",
			C3: "",
			C4L: "VFR",
			C4: "---",
			C5L: "VSR/V3",
			C5: "",
			C6L: "VCL",
			C6: "",
			
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: "FLEX",
			L1: "",
			L2L: "PACKS",
			L2: "OFF",
			L3L: "FLAP",
			L3: "",
			L4L: "V1",
			L4: "",
			L5L: "VR",
			L5: "",
			L6L: "V2",
			L6: "",
			
			LBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1L: "THRUST ",
			R1: "LIMITS>",
			R2L: "SLOPE/WIND",
			R2: "",
			R3L: "OAT",
			R3: "",
			R4L: "CLB THRUST",
			R4: "",
			R5L: "ACCEL",
			R5: "",
			R6L: "EO ACCEL",
			R6: "",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "",
			titleTranslate: 0,
		};
		
		m.Value = {
			oatEntry: 0,
			pw: 0,
			takeoffStabDeg: 0,
			tocg: "",
			togw: "",
			toSlopeFmt: "",
			toWindFmt: "",
			v1Calc: 0,
			v2Calc: 0,
			vcl: 0,
			vfr: 0,
			vrCalc: 0,
			vsr: 0,
		};
		
		m.group = "fmc";
		m.name = "takeoff";
		m.nextPage = "none";
		m.scratchpad = "";
		m.scratchpadSplit = nil;
		m.scratchpadState = 0;
		
		return m;
	},
	reset: func() {
		me.setup();
	},
	setup: func() {
		if (pts.Options.eng.getValue() == "PW") {
			me.Display.C2L = "EPR";
			me.Value.pw = 1;
		} else {
			me.Display.C2L = "N1";
			me.Value.pw = 0;
		}
	},
	loop: func() {
		if (fms.Internal.phase > 1) {
			unit[me.id].setPage("approach");
		}
		
		if (fms.flightData.airportFrom != "") {
			me.Display.title = "TAKE OFF " ~ fms.flightData.airportFrom; # Add runway
		} else {
			me.Display.title = "TAKE OFF";
		}
		
		if (fms.flightData.flexActive) {
			me.Display.L1 = sprintf("%d", fms.flightData.flexTemp) ~ "g";
		} else {
			me.Display.L1 = "*[ ]";
		}
		
		if (fms.flightData.toPacks) {
			me.Display.L2 = "ON";
			me.Display.LFont[1] = FONT.large;
		} else {
			me.Display.L2 = "OFF";
			me.Display.LFont[1] = FONT.small;
		}
		
		if (fms.flightData.toFlaps > 0) {
			me.Display.L3 = sprintf("%4.1f", fms.flightData.toFlaps);
		} else {
			me.Display.L3 = "__._";
		}
		
		me.Value.v1Calc = math.round(fms.Speeds.v1.getValue());
		if (fms.flightData.v1State > 0) {
			me.Display.L4 = sprintf("%d", fms.flightData.v1);
			me.Display.LFont[3] = FONT.large;
		} else if (fms.flightData.v1State == 0 and me.Value.v1Calc > 0) {
			me.Display.L4 = "*" ~ sprintf("%d", me.Value.v1Calc);
			me.Display.LFont[3] = FONT.small;
		} else {
			me.Display.L4 = "---";
			me.Display.LFont[3] = FONT.small;
		}
		
		me.Value.vrCalc = math.round(fms.Speeds.vr.getValue());
		if (fms.flightData.vrState > 0) {
			me.Display.L5 = sprintf("%d", fms.flightData.vr);
			me.Display.LFont[4] = FONT.large;
		} else if (fms.flightData.vrState == 0 and me.Value.vrCalc > 0) {
			me.Display.L5 = "*" ~ sprintf("%d", me.Value.vrCalc);
			me.Display.LFont[4] = FONT.small;
		} else {
			me.Display.L5 = "---";
			me.Display.LFont[4] = FONT.small;
		}
		
		me.Value.v2Calc = math.round(fms.Speeds.v2.getValue());
		if (fms.flightData.v2State > 0) {
			me.Display.L6 = sprintf("%d", fms.flightData.v2);
			me.Display.LFont[5] = FONT.large;
		} else if (fms.flightData.v2State == 0 and me.Value.v2Calc > 0) {
			me.Display.L6 = "*" ~ sprintf("%d", me.Value.v2Calc);
			me.Display.LFont[5] = FONT.small;
		} else {
			me.Display.L6 = "---";
			me.Display.LFont[5] = FONT.small;
		}
		
		if (fms.flightData.tocg > 0) {
			me.Value.tocg = sprintf("%4.1f", fms.flightData.tocg);
		} else {
			me.Value.tocg = "--.-";
		}
		if (fms.flightData.togwLbs > 0) {
			me.Value.togw = sprintf("%5.1f", fms.flightData.togwLbs);
		} else {
			me.Value.togw = "---.-";
		}
		me.Display.C1 = me.Value.tocg ~ "/" ~ me.Value.togw;
		
		if (me.Value.pw) {
			me.Display.C2 = sprintf("%4.2f", math.round(systems.FADEC.Limit.takeoff.getValue(), 0.01)); # EPR
		} else {
			me.Display.C2 = sprintf("%5.1f", systems.FADEC.Limit.takeoff.getValue()); # N1
		}
		
		me.Value.takeoffStabDeg = fms.Internal.takeoffStabDeg.getValue();
		if (me.Value.takeoffStabDeg > 0) {
			me.Display.C3 = sprintf("%4.1f", me.Value.takeoffStabDeg);
		} else {
			me.Display.C3 = "---";
		}
		
		me.Value.vfr = fms.Speeds.vfr.getValue();
		if (me.Value.vfr > 0) {
			me.Display.C4 = sprintf("%d", math.round(me.Value.vfr));
		} else {
			me.Display.C4 = "---";
		}
		
		me.Value.vsr = fms.Speeds.vsrTo.getValue();
		if (me.Value.vsr > 0) {
			me.Display.C5 = sprintf("%d", math.round(me.Value.vsr));
		} else {
			me.Display.C5 = "---";
		}
		
		me.Value.vcl = fms.Speeds.vclTo.getValue();
		if (me.Value.vcl > 0) {
			me.Display.C6 = sprintf("%d", math.round(me.Value.vcl));
		} else {
			me.Display.C6 = "---";
		}
		
		if (fms.flightData.toSlope > -100 and fms.flightData.toWind > -100) {
			if (fms.flightData.toSlope < 0) {
				me.Value.toSlopeFmt = "DN" ~ sprintf("%3.1f", abs(fms.flightData.toSlope));
			} else {
				me.Value.toSlopeFmt = "UP" ~ sprintf("%3.1f", fms.flightData.toSlope);
			}
			
			if (fms.flightData.toWind < 0) {
				me.Value.toWindFmt = "TL" ~ sprintf("%02d", abs(fms.flightData.toWind));
			} else {
				me.Value.toWindFmt = "HD" ~ sprintf("%02d", fms.flightData.toWind);
			}
			
			me.Display.R2 = me.Value.toSlopeFmt ~ "/" ~ me.Value.toWindFmt;
		} else {
			me.Display.R2 = "___._/____";
		}
		
		if (fms.flightData.oatC > -100) {
			if (fms.flightData.oatUnit) {
				me.Display.R3 = sprintf("%d", fms.flightData.oatF) ~ "F";
			} else {
				me.Display.R3 = sprintf("%d", fms.flightData.oatC) ~ "C";
			}
		} else {
			me.Display.R3 = "____";
		}
		
		if (fms.flightData.climbThrustAlt > -2000) {
			me.Display.R4 = sprintf("%d", fms.flightData.climbThrustAlt);
			if (fms.flightData.climbThrustAltSet) {
				me.Display.RFont[3] = FONT.large;
			} else {
				me.Display.RFont[3] = FONT.small;
			}
		} else {
			me.Display.R4 = "----";
			me.Display.RFont[3] = FONT.small;
		}
		
		if (fms.flightData.accelAlt > -2000) {
			me.Display.R5 = sprintf("%d", fms.flightData.accelAlt);
			if (fms.flightData.accelAltSet) {
				me.Display.RFont[4] = FONT.large;
			} else {
				me.Display.RFont[4] = FONT.small;
			}
		} else {
			me.Display.R5 = "----";
			me.Display.RFont[4] = FONT.small;
		}
		
		if (fms.flightData.accelAltEo > -2000) {
			me.Display.R6 = sprintf("%d", fms.flightData.accelAltEo);
			if (fms.flightData.accelAltEoSet) {
				me.Display.RFont[5] = FONT.large;
			} else {
				me.Display.RFont[5] = FONT.small;
			}
		} else {
			me.Display.R6 = "----";
			me.Display.RFont[5] = FONT.small;
		}
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l1") { # Also in thrlim.nas
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 2) and unit[me.id].stringIsInt()) {
					if (me.scratchpad >= math.round(pts.Fdm.JSBSim.Propulsion.tatC.getValue()) and me.scratchpad <= 70) {
						if (systems.FADEC.Limit.activeModeInt.getValue() != 0) {
							if (!systems.FADEC.Limit.auto.getBoolValue()) {
								systems.FADEC.setMode(0);
							}
						}
						
						systems.FADEC.Limit.pwDerate.setBoolValue(1);
						fms.flightData.flexActive = 1;
						fms.flightData.flexTemp = int(me.scratchpad);
						fms.EditFlightData.resetVspeeds();
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 0) {
				fms.flightData.flexActive = 0;
				fms.flightData.flexTemp = 0;
				fms.EditFlightData.resetVspeeds();
				unit[me.id].scratchpadClear();
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l2") {
			if (me.scratchpadState == 1) {
				fms.flightData.toPacks = !fms.flightData.toPacks;
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l3") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 4) and unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if ((me.scratchpad >= 10 and me.scratchpad <= 25) or (me.scratchpad == 28 and pts.Systems.Acconfig.Options.deflectedAileron.getBoolValue())) {
						fms.flightData.toFlaps = me.scratchpad + 0;
						fms.EditFlightData.resetVspeeds();
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l4") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(2, 3) and unit[me.id].stringIsInt()) {
					if (me.scratchpad >= 90 and me.scratchpad <= 250) {
						fms.flightData.v1 = int(me.scratchpad);
						fms.flightData.v1State = 2;
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				me.Value.v1Calc = math.round(fms.Speeds.v1.getValue());
				if (fms.flightData.v1State == 0 and me.Value.v1Calc > 0) {
					fms.flightData.v1 = me.Value.v1Calc;
					fms.flightData.v1State = 1;
				} else {
					unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				if (fms.flightData.v1State > 0) {
					fms.flightData.v1 = 0;
					fms.flightData.v1State = 0;
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("NOT ALLOWED");
				}
			}
		} else if (k == "l5") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(2, 3) and unit[me.id].stringIsInt()) {
					if (me.scratchpad >= 90 and me.scratchpad <= 250) {
						fms.flightData.vr = int(me.scratchpad);
						fms.flightData.vrState = 2;
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				me.Value.vrCalc = math.round(fms.Speeds.vr.getValue());
				if (fms.flightData.vrState == 0 and me.Value.vrCalc > 0) {
					fms.flightData.vr = me.Value.vrCalc;
					fms.flightData.vrState = 1;
				} else {
					unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				if (fms.flightData.vrState > 0) {
					fms.flightData.vr = 0;
					fms.flightData.vrState = 0;
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("NOT ALLOWED");
				}
			}
		} else if (k == "l6") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(2, 3) and unit[me.id].stringIsInt()) {
					if (me.scratchpad >= 90 and me.scratchpad <= 250) {
						fms.flightData.v2 = int(me.scratchpad);
						fms.flightData.v2State = 2;
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				me.Value.v2Calc = math.round(fms.Speeds.v2.getValue());
				if (fms.flightData.v2State == 0 and me.Value.v2Calc > 0) {
					fms.flightData.v2 = me.Value.v2Calc;
					fms.flightData.v2State = 1;
				} else {
					unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				if (fms.flightData.v2State > 0) {
					fms.flightData.v2 = 0;
					fms.flightData.v2State = 0;
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("NOT ALLOWED");
				}
			}
		} else if (k == "r1") {
			unit[me.id].setPage("thrLim");
		} else if (k == "r2") {
			if (me.scratchpadState == 2) {
				me.scratchpad = string.replace(me.scratchpad, "+", "");
				me.scratchpadSplit = split("/", me.scratchpad);
				if (size(me.scratchpadSplit) == 2) {
					if (unit[me.id].stringLengthInRange(1, 4, me.scratchpadSplit[0]) and unit[me.id].stringLengthInRange(1, 3, me.scratchpadSplit[1])) {
						# Check Slope
						if ((find("U", me.scratchpadSplit[0]) == 0 and find("D", me.scratchpadSplit[0]) == -1) or (find("D", me.scratchpadSplit[0]) == 0 and find("U", me.scratchpadSplit[0]) == -1)) {
							if (unit[me.id].stringContains("+", me.scratchpadSplit[0]) or unit[me.id].stringContains("-", me.scratchpadSplit[0])) {
								unit[me.id].setMessage("FORMAT ERROR");
								return;
							}
							
							me.scratchpadSplit[0] = string.replace(me.scratchpadSplit[0], "U", "");
							me.scratchpadSplit[0] = string.replace(me.scratchpadSplit[0], "D", "-");
						}
						
						if (!unit[me.id].stringDecimalLengthInRange(0, 1, me.scratchpadSplit[0])) {
							unit[me.id].setMessage("FORMAT ERROR");
							return;
						}
						if (me.scratchpadSplit[0] < -2 or me.scratchpadSplit[0] > 2) {
							unit[me.id].setMessage("ENTRY OUT OF RANGE");
							return;
						}
						
						# Check Wind
						if ((find("H", me.scratchpadSplit[1]) == 0 and find("T", me.scratchpadSplit[1]) == -1) or (find("T", me.scratchpadSplit[1]) == 0 and find("H", me.scratchpadSplit[1]) == -1)) {
							if (unit[me.id].stringContains("+", me.scratchpadSplit[1]) or unit[me.id].stringContains("-", me.scratchpadSplit[1])) {
								unit[me.id].setMessage("FORMAT ERROR");
								return;
							}
							
							me.scratchpadSplit[1] = string.replace(me.scratchpadSplit[1], "H", "");
							me.scratchpadSplit[1] = string.replace(me.scratchpadSplit[1], "T", "-");
						}
						
						if (!unit[me.id].stringIsInt(me.scratchpadSplit[1])) {
							unit[me.id].setMessage("FORMAT ERROR");
							return;
						}
						if (me.scratchpadSplit[1] < -50 or me.scratchpadSplit[1] > 50) {
							unit[me.id].setMessage("ENTRY OUT OF RANGE");
							return;
						}
						
						# Enter Data
						fms.flightData.toSlope = me.scratchpadSplit[0] + 0;
						fms.flightData.toWind = int(me.scratchpadSplit[1]);
						fms.EditFlightData.resetVspeeds();
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("FORMAT ERROR");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r3") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 5)) {
					me.scratchpad = string.replace(me.scratchpad, "+", "");
					if (unit[me.id].stringContains("F")) {
						me.Value.oatEntry = int(string.replace(me.scratchpad, "F", ""));
						if (me.Value.oatEntry >= -147 and me.Value.oatEntry <= 211) {
							fms.flightData.oatC = math.round((string.replace(me.scratchpad, "F", "") - 32) / 1.8);
							fms.flightData.oatF = me.Value.oatEntry;
							fms.flightData.oatUnit = 1;
							fms.EditFlightData.resetVspeeds();
							unit[me.id].scratchpadClear();
						} else {
							unit[me.id].setMessage("ENTRY OUT OF RANGE");
						}
					} else if (unit[me.id].stringContains("C")) {
						me.Value.oatEntry = int(string.replace(me.scratchpad, "C", ""));
						if (me.Value.oatEntry >= -99 and me.Value.oatEntry <= 99) {
							fms.flightData.oatC = me.Value.oatEntry; 
							fms.flightData.oatF = math.round((me.Value.oatEntry * 1.8) + 32); 
							fms.flightData.oatUnit = 0;
							fms.EditFlightData.resetVspeeds();
							unit[me.id].scratchpadClear();
						} else {
							unit[me.id].setMessage("ENTRY OUT OF RANGE");
						}
					} else {
						unit[me.id].setMessage("FORMAT ERROR");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				fms.flightData.oatUnit = !fms.flightData.oatUnit;
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r4") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 5) and unit[me.id].stringIsInt()) {
					if (me.scratchpad >= fms.flightData.airportFromAlt + 1000) {
						fms.flightData.climbThrustAlt = int(me.scratchpad);
						fms.flightData.climbThrustAltSet = 1;
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 0) {
				if (fms.flightData.climbThrustAltSet)  {
					fms.EditFlightData.insertToAlts(1);
					fms.flightData.climbThrustAltSet = 0;
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r5") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 5) and unit[me.id].stringIsInt()) {
					if (me.scratchpad >= fms.flightData.airportFromAlt + 1000) {
						fms.flightData.accelAlt = int(me.scratchpad);
						fms.flightData.accelAltSet = 1;
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 0) {
				if (fms.flightData.accelAltSet) {
					fms.EditFlightData.insertToAlts(2);
					fms.flightData.accelAltSet = 0;
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r6") {
			if (me.scratchpadState == 2) {
				if (unit[me.id].stringLengthInRange(1, 5) and unit[me.id].stringIsInt()) {
					if (me.scratchpad >= fms.flightData.airportFromAlt + 400) {
						fms.flightData.accelAltEo = int(me.scratchpad);
						fms.flightData.accelAltEoSet = 1;
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 0) {
				if (fms.flightData.accelAltEoSet) {
					fms.EditFlightData.insertToAlts(3);
					fms.flightData.accelAltEoSet = 0;
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else {
			unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};

var Approach = {
	new: func(n) {
		var m = {parents: [Approach]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			CLTranslate: [0, 0, 0, 0, -3, 0],
			CTranslate: [0, 0, 0, 0, -3, 0],
			C1L: "",
			C1: "",
			C2L: "",
			C2: "",
			C3L: "",
			C3: "",
			C4L: "",
			C4: "",
			C5L: "VREF",
			C5: "",
			C6L: "",
			C6: "",
			
			LFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			L1L: "CLEAN MIN",
			L1: "",
			L2L: "SLAT EXT MIN",
			L2: "",
			L3L: "FLAP 28g MIN",
			L3: "",
			L4L: "",
			L4: "",
			L5L: "VAPP",
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
			R1L: "LW",
			R1: "---.-",
			R2L: "LENGTH",
			R2: "-----",
			R3L: "ELEV",
			R3: "",
			R4L: "TIMER MMSS",
			R4: "[  ]",
			R5L: "",
			R5: "",
			R6L: "",
			R6: "GO AROUND>",
			
			RBFont: [FONT.large, FONT.large, FONT.large, FONT.large, FONT.large, FONT.large],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "",
			titleTranslate: 0,
		};
		
		m.Value = {
			cleanMin: 0,
			flap28Min: 0,
			slatMin: 0,
			vappMax: 0,
			vref: 0,
		};
		
		m.group = "fmc";
		m.name = "approach";
		m.nextPage = "none";
		m.scratchpad = "";
		m.scratchpadState = 0;
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		if (fms.flightData.airportTo != "") {
			me.Display.title = "APPROACH " ~ fms.flightData.airportTo; # Add runway
		} else {
			me.Display.title = "APPROACH";
		}
		
		me.Value.cleanMin = math.round(fms.Speeds.cleanMin.getValue());
		if (me.Value.cleanMin > 0) {
			me.Display.L1 = sprintf("%d", me.Value.cleanMin);
		} else {
			me.Display.L1 = "---";
		}
		
		me.Value.slatMin = math.round(fms.Speeds.slatMin.getValue());
		if (me.Value.slatMin > 0) {
			me.Display.L2 = sprintf("%d", me.Value.slatMin);
		} else {
			me.Display.L2 = "---";
		}
		
		me.Value.flap28Min = math.round(fms.Speeds.flap28Min.getValue());
		if (me.Value.flap28Min > 0) {
			me.Display.L3 = sprintf("%d", me.Value.flap28Min);
		} else {
			me.Display.L3 = "---";
		}
		
		if (fms.flightData.vapp > 0) {
			me.Display.L5 = sprintf("%d", fms.flightData.vapp);
		} else {
			me.Display.L5 = "---";
		}
		
		me.Value.vref = math.round(fms.Speeds.vref.getValue());
		if (me.Value.vref > 0) {
			me.Display.C5 = sprintf("%d", me.Value.vref);
		} else {
			me.Display.C5 = "---";
		}
		
		if (fms.flightData.airportToAlt > -2000) {
			me.Display.R3 = sprintf("%d", math.round(fms.flightData.airportToAlt));
		} else {
			me.Display.R3 = "----";
		}
		
		if (fms.flightData.landFlaps == 50) {
			me.Display.L4 = "50/LAND";
			me.Display.L6 = "*35/LAND";
		} else {
			me.Display.L4 = "35/LAND";
			me.Display.L6 = "*50/LAND";
		}
	},
	softKey: func(k) {
		me.scratchpad = unit[me.id].scratchpad;
		me.scratchpadState = unit[me.id].scratchpadState();
		
		if (k == "l5") {
			if (me.scratchpadState == 2) {
				if (fms.flightData.landFlaps == 50) { # Ignore mach, not relevant here
					me.Value.vappMax = 175;
				} else {
					me.Value.vappMax = 190;
				}
				if (unit[me.id].stringLengthInRange(3, 3) and unit[me.id].stringIsInt()) {
					if (me.scratchpad >= math.round(fms.Speeds.vref.getValue()) and me.scratchpad <= me.Value.vappMax) {
						fms.flightData.vappOvrd = 1; # Must be set first
						fms.flightData.vapp = int(me.scratchpad);
						unit[me.id].scratchpadClear();
					} else {
						unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 0) {
				if (fms.flightData.vappOvrd) {
					fms.flightData.vappOvrd = 0;
					fms.EditFlightData.calcSpeeds(); # Force update
					unit[me.id].scratchpadClear();
				} else {
					unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l6") {
			if (me.scratchpadState == 1) {
				if (fms.flightData.landFlaps == 50) {
					fms.flightData.landFlaps = 35;
				} else {
					fms.flightData.landFlaps = 50;
				}
			} else {
				unit[me.id].setMessage("NOT ALLOWED");
			}
		}
	},
};
