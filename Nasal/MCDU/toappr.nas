# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)
# Where needed + 0 is used to force a string to a number

var Takeoff = {
	new: func(n) {
		var m = {parents: [Takeoff]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.small, FONT.small, FONT.small, FONT.small, FONT.small, FONT.small],
			CSTranslate: [-120, -120, -120, -120, -120, -120],
			CTranslate: [-120, -120, -120, -120, -120, -120],
			C1S: "TOCG/TOGW",
			C1: "",
			C2S: "",
			C2: "",
			C3S: "STAB",
			C3: "",
			C4S: "VFR",
			C4: "---",
			C5S: "VSR/V3",
			C5: "",
			C6S: "VCL",
			C6: "",
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1S: "FLEX",
			L1: "",
			L2S: "PACKS",
			L2: "OFF",
			L3S: "FLAP",
			L3: "",
			L4S: "V1",
			L4: "",
			L5S: "VR",
			L5: "",
			L6S: "V2",
			L6: "",
			
			pageNum: "",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1S: "THRUST ",
			R1: "LIMITS>",
			R2S: "SLOPE/WIND",
			R2: "",
			R3S: "OAT",
			R3: "",
			R4S: "CLB THRUST",
			R4: "",
			R5S: "ACCEL",
			R5: "",
			R6S: "EO ACCEL",
			R6: "",
			
			title: "",
		};
		
		m.Value = {
			oatCEntry: 0,
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
		m.scratchpadSplitSize = 0;
		m.scratchpadState = 0;
		
		return m;
	},
	reset: func() {
		me.setup();
	},
	setup: func() {
		if (pts.Options.eng.getValue() == "PW") {
			me.Display.C2S = "EPR";
		} else {
			me.Display.C2S = "N1";
		}
	},
	loop: func() {
		if (fms.FlightData.airportFrom != "") {
			me.Display.title = "TAKE OFF " ~ fms.FlightData.airportFrom; # Add runway
		} else {
			me.Display.title = "TAKE OFF";
		}
		
		if (fms.FlightData.flexActive) {
			me.Display.L1 = sprintf("%d", fms.FlightData.flexTemp) ~ "g";
		} else {
			me.Display.L1 = "*[ ]";
		}
		
		if (fms.FlightData.toPacks) {
			me.Display.L2 = "ON";
			me.Display.LFont[1] = FONT.normal;
		} else {
			me.Display.L2 = "OFF";
			me.Display.LFont[1] = FONT.small;
		}
		
		if (fms.FlightData.toFlaps > 0) {
			me.Display.L3 = sprintf("%4.1f", fms.FlightData.toFlaps);
		} else {
			me.Display.L3 = "__._";
		}
		
		me.Value.v1Calc = math.round(fms.Speeds.v1.getValue());
		if (fms.FlightData.v1State > 0) {
			me.Display.L4 = sprintf("%d", fms.FlightData.v1);
			me.Display.LFont[3] = FONT.normal;
		} else if (fms.FlightData.v1State == 0 and me.Value.v1Calc > 0) {
			me.Display.L4 = "*" ~ sprintf("%d", me.Value.v1Calc);
			me.Display.LFont[3] = FONT.small;
		} else {
			me.Display.L4 = "---";
			me.Display.LFont[3] = FONT.small;
		}
		
		me.Value.vrCalc = math.round(fms.Speeds.vr.getValue());
		if (fms.FlightData.vrState > 0) {
			me.Display.L5 = sprintf("%d", fms.FlightData.vr);
			me.Display.LFont[4] = FONT.normal;
		} else if (fms.FlightData.vrState == 0 and me.Value.vrCalc > 0) {
			me.Display.L5 = "*" ~ sprintf("%d", me.Value.vrCalc);
			me.Display.LFont[4] = FONT.small;
		} else {
			me.Display.L5 = "---";
			me.Display.LFont[4] = FONT.small;
		}
		
		me.Value.v2Calc = math.round(fms.Speeds.v2.getValue());
		if (fms.FlightData.v2State > 0) {
			me.Display.L6 = sprintf("%d", fms.FlightData.v2);
			me.Display.LFont[5] = FONT.normal;
		} else if (fms.FlightData.v2State == 0 and me.Value.v2Calc > 0) {
			me.Display.L6 = "*" ~ sprintf("%d", me.Value.v2Calc);
			me.Display.LFont[5] = FONT.small;
		} else {
			me.Display.L6 = "---";
			me.Display.LFont[5] = FONT.small;
		}
		
		if (fms.FlightData.tocg > 0) {
			me.Value.tocg = sprintf("%4.1f", fms.FlightData.tocg);
		} else {
			me.Value.tocg = "--.-";
		}
		if (fms.FlightData.togwLbs > 0) {
			me.Value.togw = sprintf("%5.1f", fms.FlightData.togwLbs);
		} else {
			me.Value.togw = "---.-";
		}
		me.Display.C1 = me.Value.tocg ~ "/" ~ me.Value.togw;
		
		if (pts.Options.eng.getValue() == "PW") {
			me.Display.C2 = sprintf("%4.2f", systems.FADEC.Limit.takeoff.getValue()); # EPR
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
		
		if (fms.FlightData.toSlope > -100 and fms.FlightData.toWind > -100) {
			if (fms.FlightData.toSlope < 0) {
				me.Value.toSlopeFmt = "DN" ~ sprintf("%3.1f", abs(fms.FlightData.toSlope));
			} else {
				me.Value.toSlopeFmt = "UP" ~ sprintf("%3.1f", fms.FlightData.toSlope);
			}
			
			if (fms.FlightData.toWind < 0) {
				me.Value.toWindFmt = "TL" ~ sprintf("%02d", abs(fms.FlightData.toWind));
			} else {
				me.Value.toWindFmt = "HD" ~ sprintf("%02d", fms.FlightData.toWind);
			}
			
			me.Display.R2 = me.Value.toSlopeFmt ~ "/" ~ me.Value.toWindFmt;
		} else {
			me.Display.R2 = "___._/____";
		}
		
		if (fms.FlightData.oatC > -100) {
			if (fms.FlightData.oatUnit) {
				me.Display.R3 = sprintf("%d", math.round((fms.FlightData.oatC * 1.8) + 32)) ~ "F";
			} else {
				me.Display.R3 = sprintf("%d", fms.FlightData.oatC) ~ "C";
			}
		} else {
			me.Display.R3 = "____";
		}
		
		if (fms.FlightData.climbThrustAlt > -1000) {
			me.Display.R4 = sprintf("%d", fms.FlightData.climbThrustAlt);
			if (fms.FlightData.climbThrustAltSet) {
				me.Display.RFont[3] = FONT.normal;
			} else {
				me.Display.RFont[3] = FONT.small;
			}
		} else {
			me.Display.R4 = "----";
			me.Display.RFont[3] = FONT.small;
		}
		
		if (fms.FlightData.accelAlt > -1000) {
			me.Display.R5 = sprintf("%d", fms.FlightData.accelAlt);
			if (fms.FlightData.accelAltSet) {
				me.Display.RFont[4] = FONT.normal;
			} else {
				me.Display.RFont[4] = FONT.small;
			}
		} else {
			me.Display.R5 = "----";
			me.Display.RFont[4] = FONT.small;
		}
		
		if (fms.FlightData.accelAltEo > -1000) {
			me.Display.R6 = sprintf("%d", fms.FlightData.accelAltEo);
			if (fms.FlightData.accelAltEoSet) {
				me.Display.RFont[5] = FONT.normal;
			} else {
				me.Display.RFont[5] = FONT.small;
			}
		} else {
			me.Display.R6 = "----";
			me.Display.RFont[5] = FONT.small;
		}
	},
	softKey: func(k) {
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		if (k == "l1") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 2) and mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad >= math.round(pts.Fdm.JSBsim.Propulsion.tatC.getValue()) and me.scratchpad <= 70) {
						fms.FlightData.flexActive = 1;
						fms.FlightData.flexTemp = int(me.scratchpad);
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
		} else if (k == "l2") {
			if (me.scratchpadState == 1) {
				fms.FlightData.toPacks = !fms.FlightData.toPacks;
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l3") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 4) and mcdu.unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if ((me.scratchpad >= 10 and me.scratchpad <= 25) or (me.scratchpad == 28 and pts.Systems.Acconfig.Options.deflectedAileronEquipped.getBoolValue())) {
						fms.FlightData.toFlaps = me.scratchpad + 0;
						fms.EditFlightData.resetVspeeds();
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
		} else if (k == "l4") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(2, 3) and mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad >= 90 and me.scratchpad <= 250) {
						fms.FlightData.v1 = int(me.scratchpad);
						fms.FlightData.v1State = 2;
						mcdu.unit[me.id].scratchpadClear();
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				me.Value.v1Calc = math.round(fms.Speeds.v1.getValue());
				if (fms.FlightData.v1State == 0 and me.Value.v1Calc > 0) {
					fms.FlightData.v1 = me.Value.v1Calc;
					fms.FlightData.v1State = 1;
				}
			} else {
				if (fms.FlightData.v1State > 0) {
					fms.FlightData.v1 = 0;
					fms.FlightData.v1State = 0;
					mcdu.unit[me.id].scratchpadClear();
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			}
		} else if (k == "l5") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(2, 3) and mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad >= 90 and me.scratchpad <= 250) {
						fms.FlightData.vr = int(me.scratchpad);
						fms.FlightData.vrState = 2;
						mcdu.unit[me.id].scratchpadClear();
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				me.Value.vrCalc = math.round(fms.Speeds.vr.getValue());
				if (fms.FlightData.vrState == 0 and me.Value.vrCalc > 0) {
					fms.FlightData.vr = me.Value.vrCalc;
					fms.FlightData.vrState = 1;
				}
			} else {
				if (fms.FlightData.vrState > 0) {
					fms.FlightData.vr = 0;
					fms.FlightData.vrState = 0;
					mcdu.unit[me.id].scratchpadClear();
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			}
		} else if (k == "l6") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(2, 3) and mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad >= 90 and me.scratchpad <= 250) {
						fms.FlightData.v2 = int(me.scratchpad);
						fms.FlightData.v2State = 2;
						mcdu.unit[me.id].scratchpadClear();
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				me.Value.v2Calc = math.round(fms.Speeds.v2.getValue());
				if (fms.FlightData.v2State == 0 and me.Value.v2Calc > 0) {
					fms.FlightData.v2 = me.Value.v2Calc;
					fms.FlightData.v2State = 1;
				}
			} else {
				if (fms.FlightData.v2State > 0) {
					fms.FlightData.v2 = 0;
					fms.FlightData.v2State = 0;
					mcdu.unit[me.id].scratchpadClear();
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			}
		} else if (k == "r2") {
			if (me.scratchpadState == 2) {
				me.scratchpad = string.replace(me.scratchpad, "+", "");
				me.scratchpadSplit = split("/", me.scratchpad);
				if (size(me.scratchpadSplit) == 2) {
					if (mcdu.unit[me.id].stringLengthInRange(1, 4, me.scratchpadSplit[0]) and mcdu.unit[me.id].stringLengthInRange(1, 3, me.scratchpadSplit[1])) {
						# Check Slope
						if ((find("U", me.scratchpadSplit[0]) == 0 and find("D", me.scratchpadSplit[0]) == -1) or (find("D", me.scratchpadSplit[0]) == 0 and find("U", me.scratchpadSplit[0]) == -1)) {
							if (mcdu.unit[me.id].stringContains("+", me.scratchpadSplit[0]) or mcdu.unit[me.id].stringContains("-", me.scratchpadSplit[0])) {
								mcdu.unit[me.id].setMessage("FORMAT ERROR");
								return;
							}
							
							me.scratchpadSplit[0] = string.replace(me.scratchpadSplit[0], "U", "");
							me.scratchpadSplit[0] = string.replace(me.scratchpadSplit[0], "D", "-");
						}
						
						if (!mcdu.unit[me.id].stringDecimalLengthInRange(0, 1, me.scratchpadSplit[0])) {
							mcdu.unit[me.id].setMessage("FORMAT ERROR");
							return;
						}
						fms.FlightData.toSlope = me.scratchpadSplit[0] + 0;
						
						# Check Wind
						if ((find("H", me.scratchpadSplit[1]) == 0 and find("T", me.scratchpadSplit[1]) == -1) or (find("T", me.scratchpadSplit[1]) == 0 and find("H", me.scratchpadSplit[1]) == -1)) {
							if (mcdu.unit[me.id].stringContains("+", me.scratchpadSplit[1]) or mcdu.unit[me.id].stringContains("-", me.scratchpadSplit[1])) {
								mcdu.unit[me.id].setMessage("FORMAT ERROR");
								return;
							}
							
							me.scratchpadSplit[1] = string.replace(me.scratchpadSplit[1], "H", "");
							me.scratchpadSplit[1] = string.replace(me.scratchpadSplit[1], "T", "-");
						}
						
						if (!mcdu.unit[me.id].stringIsInt(me.scratchpadSplit[1])) {
							mcdu.unit[me.id].setMessage("FORMAT ERROR");
							return;
						}
						
						fms.FlightData.toWind = int(me.scratchpadSplit[1]);
						fms.EditFlightData.resetVspeeds();
						mcdu.unit[me.id].scratchpadClear();
					} else {
						mcdu.unit[me.id].setMessage("FORMAT ERROR");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r3") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 5)) {
					me.scratchpad = string.replace(me.scratchpad, "+", "");
					if (mcdu.unit[me.id].stringContains("F")) {
						me.Value.oatCEntry = math.round((string.replace(me.scratchpad, "F", "") - 32) / 1.8);
						if (me.Value.oatCEntry > -100 and me.Value.oatCEntry < 100) {
							fms.FlightData.oatC = me.Value.oatCEntry;
							fms.FlightData.oatUnit = 1;
							fms.EditFlightData.resetVspeeds();
							mcdu.unit[me.id].scratchpadClear();
						} else {
							mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
						}
					} else if (mcdu.unit[me.id].stringContains("C")) {
						me.Value.oatCEntry = int(string.replace(me.scratchpad, "C", ""));
						if (me.Value.oatCEntry > -100 and me.Value.oatCEntry < 100) {
							fms.FlightData.oatC = me.Value.oatCEntry; 
							fms.FlightData.oatUnit = 0;
							fms.EditFlightData.resetVspeeds();
							mcdu.unit[me.id].scratchpadClear();
						} else {
							mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
						}
					} else {
						mcdu.unit[me.id].setMessage("FORMAT ERROR");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 1) {
				fms.FlightData.oatUnit = !fms.FlightData.oatUnit;
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r4") {
			if (me.scratchpadState == 0) {
				fms.EditFlightData.insertToAlts(1);
				fms.FlightData.climbThrustAltSet = 0;
				mcdu.unit[me.id].scratchpadClear();
			} else if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 5) and mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad >= fms.FlightData.airportFromAlt + 1000) {
						fms.FlightData.climbThrustAlt = int(me.scratchpad);
						fms.FlightData.climbThrustAltSet = 1;
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
		} else if (k == "r5") {
			if (me.scratchpadState == 0) {
				fms.EditFlightData.insertToAlts(2);
				fms.FlightData.accelAltSet = 0;
				mcdu.unit[me.id].scratchpadClear();
			} else if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 5) and mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad >= fms.FlightData.airportFromAlt + 1000) {
						fms.FlightData.accelAlt = int(me.scratchpad);
						fms.FlightData.accelAltSet = 1;
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
		} else if (k == "r6") {
			if (me.scratchpadState == 0) {
				fms.EditFlightData.insertToAlts(3);
				fms.FlightData.accelAltEoSet = 0;
				mcdu.unit[me.id].scratchpadClear();
			} else if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 5) and mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad >= fms.FlightData.airportFromAlt + 400) {
						fms.FlightData.accelAltEo = int(me.scratchpad);
						fms.FlightData.accelAltEoSet = 1;
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
