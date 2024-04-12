# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)

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
			C3: "---",
			C4S: "VFR",
			C4: "---",
			C5S: "VSR/V3",
			C5: "",
			C6S: "VCL",
			C6: "",
			
			LFont: [FONT.normal, FONT.small, FONT.normal, FONT.small, FONT.small, FONT.small],
			L1S: "FLEX",
			L1: "",
			L2S: "PACKS",
			L2: "OFF",
			L3S: "FLAP",
			L3: "",
			L4S: "V1",
			L4: "---",
			L5S: "VR",
			L5: "---",
			L6S: "V2",
			L6: "---",
			
			pageNum: "",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.small, FONT.small, FONT.small],
			R1S: "THRUST ",
			R1: "LIMITS>",
			R2S: "SLOPE/WIND",
			R2: "___._/____",
			R3S: "OAT",
			R3: "____",
			R4S: "CLB THRUST",
			R4: "----",
			R5S: "ACCEL",
			R5: "----",
			R6S: "EO ACCEL",
			R6: "----",
			
			title: "",
		};
		
		m.Value = {
			tocg: "",
			togw: "",
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
			me.Display.title = "TAKE OFF " ~ fms.FlightData.airportFrom;
		} else {
			me.Display.title = "TAKE OFF";
		}
		
		if (fms.FlightData.flexActive.getBoolValue()) {
			me.Display.L1 = sprintf("%d", fms.FlightData.flexTemp.getValue()) ~ "g";
		} else {
			me.Display.L1 = "*[ ]";
		}
		
		if (fms.FlightData.toPacks.getBoolValue()) {
			me.Display.L2 = "ON";
			me.Display.LFont[1] = FONT.normal;
		} else {
			me.Display.L2 = "OFF";
			me.Display.LFont[1] = FONT.small;
		}
		
		if (fms.FlightData.flaps > 0) {
			me.Display.L3 = sprintf("%4.1f", fms.FlightData.flaps);
		} else {
			me.Display.L3 = "__._";
		}
		
		if (fms.FlightData.tocg > 0) {
			me.Value.tocg = sprintf("%4.1f", fms.FlightData.tocg);
		} else {
			me.Value.tocg = "--.-";
		}
		if (fms.FlightData.togw > 0) {
			me.Value.togw = sprintf("%5.1f", fms.FlightData.togw);
		} else {
			me.Value.togw = "---.-";
		}
		me.Display.C1 = me.Value.tocg ~ "/" ~ me.Value.togw;
		
		if (pts.Options.eng.getValue() == "PW") {
			me.Display.C2 = sprintf("%4.2f", systems.FADEC.Limit.takeoff.getValue());
		} else {
			me.Display.C2 = sprintf("%5.1f", systems.FADEC.Limit.takeoff.getValue());
		}
		
		if (fms.FlightData.zfw > 0) {
			me.Display.C5 = sprintf("%d", math.round(fms.Speeds.vsr.getValue()));
			me.Display.C6 = sprintf("%d", math.round(fms.Speeds.vcl.getValue()));
		} else {
			me.Display.C5 = "---";
			me.Display.C6 = "---";
		}
	},
	softKey: func(k) {
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		if (k == "l1") {
			if (me.scratchpadState == 0) {
				fms.FlightData.flexActive.setBoolValue(0);
				fms.FlightData.flexTemp.setValue(30);
				mcdu.unit[me.id].scratchpadClear();
			} else if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 2) and mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad >= math.round(pts.Fdm.JSBsim.Propulsion.tatC.getValue()) and me.scratchpad <= 70) {
						fms.FlightData.flexActive.setBoolValue(1);
						fms.FlightData.flexTemp.setValue(me.scratchpad + 0); # Convert string to int
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
		} else if (k == "l2") {
			if (me.scratchpadState == 1) {
				fms.FlightData.toPacks.setBoolValue(!fms.FlightData.toPacks.getBoolValue());
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l3") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(1, 4) and mcdu.unit[me.id].stringDecimalLengthInRange(0, 1)) {
					if ((me.scratchpad >= 10 and me.scratchpad <= 25) or (me.scratchpad == 28 and pts.Systems.Acconfig.Options.deflectedAileronEquipped.getBoolValue())) {
						fms.FlightData.flaps = me.scratchpad;
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
