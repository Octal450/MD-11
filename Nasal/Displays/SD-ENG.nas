# McDonnell Douglas MD-11 SD
# Copyright (c) 2026 Josh Davidson (Octal450)

var CanvasEngBase = {
	updateEngBase: func() {
		Value.Eng.fadecPowered[0] = systems.FADEC.powered[0].getBoolValue();
		Value.Eng.fadecPowered[1] = systems.FADEC.powered[1].getBoolValue();
		Value.Eng.fadecPowered[2] = systems.FADEC.powered[2].getBoolValue();
		Value.Misc.wow = pts.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Alert_error"].show();
			me["APU_EGT_error"].show();
			me["APU_N1_error"].show();
			me["APU_N2_error"].show();
			me["APU_Qty_error"].show();
			me["CabinAlt_error"].show();
			me["CabinRate_error"].show();
			me["CG_error"].show();
			me["EmvComp1_error"].show();
			me["EmvComp2_error"].show();
			me["EmvComp3_error"].show();
			me["EmvTurb1_error"].show();
			me["EmvTurb2_error"].show();
			me["EmvTurb3_error"].show();
			me["Fuel_error"].show();
			me["GW_error"].show();
			me["NacelleTemp1_error"].show();
			me["NacelleTemp2_error"].show();
			me["NacelleTemp3_error"].show();
			me["OilPsi1_error"].show();
			me["OilPsi2_error"].show();
			me["OilPsi3_error"].show();
			me["OilQty1_error"].show();
			me["OilQty2_error"].show();
			me["OilQty3_error"].show();
			me["OilTemp1_error"].show();
			me["OilTemp2_error"].show();
			me["OilTemp3_error"].show();
			me["Stab_error"].show();
		} else {
			me["Alert_error"].hide();
			me["APU_EGT_error"].hide();
			me["APU_N1_error"].hide();
			me["APU_N2_error"].hide();
			me["APU_Qty_error"].hide();
			me["CabinAlt_error"].hide();
			me["CabinRate_error"].hide();
			me["CG_error"].hide();
			me["EmvComp1_error"].hide();
			me["EmvComp2_error"].hide();
			me["EmvComp3_error"].hide();
			me["EmvTurb1_error"].hide();
			me["EmvTurb2_error"].hide();
			me["EmvTurb3_error"].hide();
			me["Fuel_error"].hide();
			me["GW_error"].hide();
			me["NacelleTemp1_error"].hide();
			me["NacelleTemp2_error"].hide();
			me["NacelleTemp3_error"].hide();
			me["OilPsi1_error"].hide();
			me["OilPsi2_error"].hide();
			me["OilPsi3_error"].hide();
			me["OilQty1_error"].hide();
			me["OilQty2_error"].hide();
			me["OilQty3_error"].hide();
			me["OilTemp1_error"].hide();
			me["OilTemp2_error"].hide();
			me["OilTemp3_error"].hide();
			me["Stab_error"].hide();
		}
		
		# GW, Fuel, CG
		if (fms.flightData.gwLbs > 0) {
			Value.Misc.gw = math.round(fms.flightData.gwLbs * 1000, 100);
			me["GW"].setText(right(sprintf("%d", Value.Misc.gw), 3));
			me["GW_thousands"].setText(sprintf("%d", math.floor(Value.Misc.gw / 1000)));
			me["GW"].show();
			me["GW_thousands"].show();
		} else {
			me["GW"].hide();
			me["GW_thousands"].hide();
		}
		
		Value.Misc.fuel = math.round(pts.Consumables.Fuel.totalFuelLbs.getValue(), 100);
		me["Fuel_thousands"].setText(sprintf("%d", math.floor(Value.Misc.fuel / 1000)));
		me["Fuel"].setText(right(sprintf("%03d", Value.Misc.fuel), 3));
		
		Value.Misc.cg = fms.Internal.cgPercentMac.getValue();
		if (Value.Misc.cg > 0) {
			me["CG"].setText(sprintf("%4.1f", math.round(Value.Misc.cg, 0.1)));
			me["CG"].show();
		} else {
			me["CG"].hide();
		}
		
		# Stab
		Value.Fctl.stab = systems.FCS.stabilizerDeg.getValue();
		Value.Fctl.stabComp = fms.Internal.takeoffStabDeg.getValue();
		Value.Fctl.stabRound = math.round(Value.Fctl.stab, 0.1);
		me["Stab"].setText(sprintf("%4.1f", abs(Value.Fctl.stabRound)));
		me["StabNeedle"].setTranslation(Value.Fctl.stab * -12.62, 0);
		
		if (fms.Internal.phase >= 2) {
			me["Stab"].setColor(1, 1, 1);
			me["Stab_box"].hide();
			me["StabGreen"].hide();
			me["StabNeedle"].setColorFill(1, 1, 1);
			me["StabUnit"].setColor(1, 1, 1);
		} else {
			if (Value.Fctl.stabComp > 0) {
				me["StabGreen"].setTranslation(Value.Fctl.stabComp * 12.62, 0);
				me["StabGreen"].show();
				
				if (abs(Value.Fctl.stabRound - (Value.Fctl.stabComp * -1)) <= 2) {
					me["Stab"].setColor(0, 1, 0);
					me["Stab_box"].hide();
					me["StabNeedle"].setColorFill(0, 1, 0);
					me["StabUnit"].setColor(0, 1, 0);
				} else if (pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue() >= 79.5 or !Value.Misc.wow) {
					me["Stab"].setColor(1, 1, 1);
					me["Stab_box"].hide();
					me["StabNeedle"].setColorFill(1, 1, 1);
					me["StabUnit"].setColor(1, 1, 1);
				} else {
					me["Stab"].setColor(0.9412, 0.7255, 0);
					me["Stab_box"].show();
					me["StabNeedle"].setColorFill(0.9412, 0.7255, 0);
					me["StabUnit"].setColor(0.9412, 0.7255, 0);
				}
			} else {
				me["Stab"].setColor(0.9412, 0.7255, 0);
				me["Stab_box"].show();
				me["StabGreen"].hide();
				me["StabNeedle"].setColorFill(0.9412, 0.7255, 0);
				me["StabUnit"].setColor(0.9412, 0.7255, 0);
			}
		}
		
		if (Value.Fctl.stabRound > 0) {
			me["StabUnit"].setText("AND");
		} else {
			me["StabUnit"].setText("ANU");
		}
		
		# Nacelle Temp
		me["NacelleTemp1"].setText(sprintf("%d", math.round(systems.ENGINES.nacelleTemp[0].getValue())));
		me["NacelleTemp2"].setText(sprintf("%d", math.round(systems.ENGINES.nacelleTemp[1].getValue())));
		me["NacelleTemp3"].setText(sprintf("%d", math.round(systems.ENGINES.nacelleTemp[2].getValue())));
		
		# APU
		Value.Apu.n2 = systems.APU.n2.getValue();
		if (Value.Apu.n2 >= 1 or Value.Misc.annunTestWow) {
			me["APU_EGT"].setText(sprintf("%d", math.round(systems.APU.egt.getValue())));
			me["APU_N1"].setText(sprintf("%d", math.round(systems.APU.n1.getValue())));
			me["APU_N2"].setText(sprintf("%d", math.round(Value.Apu.n2)));
			me["APU_Qty"].setText(sprintf("%2.1f", math.round(systems.APU.oilQty.getValue(), 0.5)));
			me["APU"].show();
		} else {
			me["APU"].hide();
		}
	},
};

var CanvasEngDials = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasEngDials, CanvasEngBase, CanvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Alert_error", "APU", "APU_EGT", "APU_EGT_error", "APU_N1", "APU_N1_error", "APU_N2", "APU_N2_error", "APU_Qty", "APU_Qty_error", "CabinAlt", "CabinAlt_error", "CabinRate", "CabinRate_error", "CabinRateDn", "CabinRateUp", "CG", "CG_error",
		"EmvComp1", "EmvComp1_error", "EmvComp2", "EmvComp2_error", "EmvComp3", "EmvComp3_error", "EmvTurb1", "EmvTurb1_error", "EmvTurb2", "EmvTurb2_error", "EmvTurb3", "EmvTurb3_error", "Fuel", "Fuel_error", "Fuel_thousands", "GE_group", "GW", "GW_error",
		"GW_thousands", "NacelleTemp1", "NacelleTemp1_error", "NacelleTemp2", "NacelleTemp2_error", "NacelleTemp3", "NacelleTemp3_error", "OilPsi1", "OilPsi1_error", "OilPsi1_needle", "OilPsi2", "OilPsi2_error", "OilPsi2_needle", "OilPsi3", "OilPsi3_error",
		"OilPsi3_needle", "OilQty1", "OilQty1_box", "OilQty1_cline", "OilQty1_error", "OilQty1_needle", "OilQty2", "OilQty2_box", "OilQty2_cline", "OilQty2_error", "OilQty2_needle", "OilQty3", "OilQty3_box", "OilQty3_cline", "OilQty3_error", "OilQty3_needle",
		"OilTemp1", "OilTemp1_box", "OilTemp1_error", "OilTemp1_needle", "OilTemp2", "OilTemp2_box", "OilTemp2_error", "OilTemp2_needle", "OilTemp3", "OilTemp3_box", "OilTemp3_error", "OilTemp3_needle", "PW_group", "Stab", "Stab_box", "Stab_error", "StabGreen",
		"StabNeedle", "StabUnit"];
	},
	setup: func() {
		Value.Eng.type = pts.Options.eng.getValue();
		
		if (Value.Eng.type == "PW") {
			me["GE_group"].hide();
			me["PW_group"].show();
		} else {
			me["GE_group"].show();
			me["PW_group"].hide();
		}
		
		# Hide unimplemented objects
		me["CabinAlt"].setText("0");
		me["CabinRate"].setText("0");
		me["CabinRateDn"].hide();
		me["CabinRateUp"].hide();
	},
	update: func() {
		me.updateEngBase();
		
		# Oil Psi
		me["OilPsi1"].setText(sprintf("%d", systems.ENGINES.oilPsi[0].getValue()));
		me["OilPsi1_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilPsi[0].getValue() * D2R);
		
		me["OilPsi2"].setText(sprintf("%d", systems.ENGINES.oilPsi[1].getValue()));
		me["OilPsi2_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilPsi[1].getValue() * D2R);
		
		me["OilPsi3"].setText(sprintf("%d", systems.ENGINES.oilPsi[2].getValue()));
		me["OilPsi3_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilPsi[2].getValue() * D2R);
		
		# Oil Temp
		if (Value.Eng.fadecPowered[0]) {
			Value.Eng.oilTemp[0] = math.round(systems.ENGINES.oilTemp[0].getValue());
			
			me["OilTemp1"].setText(sprintf("%d", Value.Eng.oilTemp[0]));
			me["OilTemp1"].show();
			
			me["OilTemp1_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilTemp[0].getValue() * D2R);
			me["OilTemp1_needle"].show();
			
			if (Value.Eng.type == "PW") {
				if (Value.Eng.oilTemp[0] <= 50) {
					me["OilTemp1"].setColor(0.9412, 0.7255, 0);
					me["OilTemp1_box"].show();
					me["OilTemp1_needle"].setColorFill(0.9412, 0.7255, 0);
				} else {
					me["OilTemp1"].setColor(1, 1, 1);
					me["OilTemp1_box"].hide();
					me["OilTemp1_needle"].setColorFill(1, 1, 1);
				}
			} else {
				me["OilTemp1_box"].hide();
			}
		} else {
			me["OilTemp1"].hide();
			me["OilTemp1_box"].hide();
			me["OilTemp1_needle"].hide();
		}
		
		if (Value.Eng.fadecPowered[1]) {
			Value.Eng.oilTemp[1] = math.round(systems.ENGINES.oilTemp[1].getValue());
			
			me["OilTemp2"].setText(sprintf("%d", Value.Eng.oilTemp[1]));
			me["OilTemp2"].show();
			
			me["OilTemp2_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilTemp[1].getValue() * D2R);
			me["OilTemp2_needle"].show();
			
			if (Value.Eng.type == "PW") {
				if (Value.Eng.oilTemp[1] <= 50) {
					me["OilTemp2"].setColor(0.9412, 0.7255, 0);
					me["OilTemp2_box"].show();
					me["OilTemp2_needle"].setColorFill(0.9412, 0.7255, 0);
				} else {
					me["OilTemp2"].setColor(1, 1, 1);
					me["OilTemp2_box"].hide();
					me["OilTemp2_needle"].setColorFill(1, 1, 1);
				}
			} else {
				me["OilTemp2_box"].hide();
			}
		} else {
			me["OilTemp2"].hide();
			me["OilTemp2_box"].hide();
			me["OilTemp2_needle"].hide();
		}
		
		if (Value.Eng.fadecPowered[2]) {
			Value.Eng.oilTemp[2] = math.round(systems.ENGINES.oilTemp[2].getValue());
			
			me["OilTemp3"].setText(sprintf("%d", Value.Eng.oilTemp[2]));
			me["OilTemp3"].show();
			
			me["OilTemp3_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilTemp[2].getValue() * D2R);
			me["OilTemp3_needle"].show();
			
			if (Value.Eng.type == "PW") {
				if (Value.Eng.oilTemp[2] <= 50) {
					me["OilTemp3"].setColor(0.9412, 0.7255, 0);
					me["OilTemp3_box"].show();
					me["OilTemp3_needle"].setColorFill(0.9412, 0.7255, 0);
				} else {
					me["OilTemp3"].setColor(1, 1, 1);
					me["OilTemp3_box"].hide();
					me["OilTemp3_needle"].setColorFill(1, 1, 1);
				}
			} else {
				me["OilTemp3_box"].hide();
			}
		} else {
			me["OilTemp3"].hide();
			me["OilTemp3_box"].hide();
			me["OilTemp3_needle"].hide();
		}
		
		# Oil Qty
		Value.Eng.oilQty[0] = systems.ENGINES.oilQty[0].getValue();
		Value.Eng.oilQty[1] = systems.ENGINES.oilQty[1].getValue();
		Value.Eng.oilQty[2] = systems.ENGINES.oilQty[2].getValue();
		
		me["OilQty1"].setText(sprintf("%d", math.round(Value.Eng.oilQty[0])));
		me["OilQty1_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilQty[0].getValue() * D2R);
		
		me["OilQty2"].setText(sprintf("%d", math.round(Value.Eng.oilQty[1])));
		me["OilQty2_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilQty[1].getValue() * D2R);
		
		me["OilQty3"].setText(sprintf("%d", math.round(Value.Eng.oilQty[2])));
		me["OilQty3_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilQty[2].getValue() * D2R);
		
		if (Value.Eng.oilQty[0] <= 4) {
			me["OilQty1"].setColor(0.9412, 0.7255, 0);
			me["OilQty1_box"].show();
			me["OilQty1_needle"].setColorFill(0.9412, 0.7255, 0);
		} else {
			me["OilQty1"].setColor(1, 1, 1);
			me["OilQty1_box"].hide();
			me["OilQty1_needle"].setColorFill(1, 1, 1);
		}
		
		if (Value.Eng.oilQty[1] <= 4) {
			me["OilQty2"].setColor(0.9412, 0.7255, 0);
			me["OilQty2_box"].show();
			me["OilQty2_needle"].setColorFill(0.9412, 0.7255, 0);
		} else {
			me["OilQty2"].setColor(1, 1, 1);
			me["OilQty2_box"].hide();
			me["OilQty2_needle"].setColorFill(1, 1, 1);
		}
		
		if (Value.Eng.oilQty[2] <= 4) {
			me["OilQty3"].setColor(0.9412, 0.7255, 0);
			me["OilQty3_box"].show();
			me["OilQty3_needle"].setColorFill(0.9412, 0.7255, 0);
		} else {
			me["OilQty3"].setColor(1, 1, 1);
			me["OilQty3_box"].hide();
			me["OilQty3_needle"].setColorFill(1, 1, 1);
		}
		
		Value.Eng.oilQtyCline[0] = pts.Instrumentation.Sd.Eng.oilQtyCline[0].getValue();
		Value.Eng.oilQtyCline[1] = pts.Instrumentation.Sd.Eng.oilQtyCline[1].getValue();
		Value.Eng.oilQtyCline[2] = pts.Instrumentation.Sd.Eng.oilQtyCline[2].getValue();
		
		if (Value.Eng.oilQtyCline[0] != -45) {
			me["OilQty1_cline"].setRotation(Value.Eng.oilQtyCline[0] * D2R);
			me["OilQty1_cline"].show();
		} else {
			me["OilQty1_cline"].hide();
		}
		if (Value.Eng.oilQtyCline[1] != -45) {
			me["OilQty2_cline"].setRotation(Value.Eng.oilQtyCline[1] * D2R);
			me["OilQty2_cline"].show();
		} else {
			me["OilQty2_cline"].hide();
		}
		if (Value.Eng.oilQtyCline[2] != -45) {
			me["OilQty3_cline"].setRotation(Value.Eng.oilQtyCline[2] * D2R);
			me["OilQty3_cline"].show();
		} else {
			me["OilQty3_cline"].hide();
		}
	},
};

var CanvasEngTapes = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasEngTapes, CanvasEngBase, CanvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Alert_error", "APU", "APU_EGT", "APU_EGT_error", "APU_N1", "APU_N1_error", "APU_N2", "APU_N2_error", "APU_Qty", "APU_Qty_error", "CabinAlt", "CabinAlt_error", "CabinRate", "CabinRate_error", "CabinRateDn", "CabinRateUp", "CG", "CG_error",
		"EmvComp1", "EmvComp1_error", "EmvComp2", "EmvComp2_error", "EmvComp3", "EmvComp3_error", "EmvTurb1", "EmvTurb1_error", "EmvTurb2", "EmvTurb2_error", "EmvTurb3", "EmvTurb3_error", "Fuel", "Fuel_error", "Fuel_thousands", "GE_group", "GW", "GW_error",
		"GW_thousands", "NacelleTemp1", "NacelleTemp1_error", "NacelleTemp2", "NacelleTemp2_error", "NacelleTemp3", "NacelleTemp3_error", "OilPsi_bars", "OilPsi1", "OilPsi1_bar", "OilPsi1_error", "OilPsi2", "OilPsi2_bar", "OilPsi2_error", "OilPsi3",
		"OilPsi3_bar", "OilPsi3_error", "OilQty_bars", "OilQty1", "OilQty1_bar", "OilQty1_box", "OilQty1_cline", "OilQty1_error", "OilQty2", "OilQty2_bar", "OilQty2_box", "OilQty2_cline", "OilQty2_error", "OilQty3", "OilQty3_bar", "OilQty3_box", "OilQty3_cline",
		"OilQty3_error", "OilTemp_bars", "OilTemp1", "OilTemp1_bar", "OilTemp1_box", "OilTemp1_error", "OilTemp2", "OilTemp2_bar", "OilTemp2_box", "OilTemp2_error", "OilTemp3", "OilTemp3_bar", "OilTemp3_box", "OilTemp3_error", "PW_group", "Stab", "Stab_box",
		"Stab_error", "StabGreen", "StabNeedle", "StabUnit"];
	},
	setup: func() {
		Value.Eng.type = pts.Options.eng.getValue();
		
		if (Value.Eng.type == "PW") {
			me["GE_group"].hide();
			me["PW_group"].show();
		} else {
			me["GE_group"].show();
			me["PW_group"].hide();
		}
		
		# Hide unimplemented objects
		me["CabinAlt"].setText("0");
		me["CabinRate"].setText("0");
		me["CabinRateDn"].hide();
		me["CabinRateUp"].hide();
	},
	update: func() {
		me.updateEngBase();
		
		if (Value.Eng.type == "PW") {
			Value.Eng.oilPsiScale = 440;
		} else {
			Value.Eng.oilPsiScale = 160;
		}
		
		# Oil Psi
		Value.Eng.oilPsi[0] = systems.ENGINES.oilPsi[0].getValue();
		Value.Eng.oilPsi[1] = systems.ENGINES.oilPsi[1].getValue();
		Value.Eng.oilPsi[2] = systems.ENGINES.oilPsi[2].getValue();
		
		me["OilPsi1"].setText(sprintf("%d", Value.Eng.oilPsi[0]));
		me["OilPsi1_bar"].setTranslation(0, Value.Eng.oilPsi[0] / Value.Eng.oilPsiScale * -251);
		
		me["OilPsi2"].setText(sprintf("%d", systems.ENGINES.oilPsi[1].getValue()));
		me["OilPsi2_bar"].setTranslation(0, Value.Eng.oilPsi[1] / Value.Eng.oilPsiScale * -251);
		
		me["OilPsi3"].setText(sprintf("%d", systems.ENGINES.oilPsi[2].getValue()));
		me["OilPsi3_bar"].setTranslation(0, Value.Eng.oilPsi[2] / Value.Eng.oilPsiScale * -251);
		
		# Oil Temp
		if (Value.Eng.fadecPowered[0]) {
			Value.Eng.oilTemp[0] = math.round(systems.ENGINES.oilTemp[0].getValue());
			
			me["OilTemp1"].setText(sprintf("%d", Value.Eng.oilTemp[0]));
			me["OilTemp1"].show();
			
			me["OilTemp1_bar"].setTranslation(0, Value.Eng.oilTemp[0] / 190 * -251);
			me["OilTemp1_bar"].show();
			
			if (Value.Eng.type == "PW") {
				if (Value.Eng.oilTemp[0] <= 50) {
					me["OilTemp1"].setColor(0.9412, 0.7255, 0);
					me["OilTemp1_bar"].setColorFill(0.9412, 0.7255, 0);
					me["OilTemp1_box"].show();
				} else {
					me["OilTemp1"].setColor(1, 1, 1);
					me["OilTemp1_bar"].setColorFill(1, 1, 1);
					me["OilTemp1_box"].hide();
				}
			} else {
				me["OilTemp1_box"].hide();
			}
		} else {
			me["OilTemp1"].hide();
			me["OilTemp1_bar"].hide();
			me["OilTemp1_box"].hide();
		}
		
		if (Value.Eng.fadecPowered[1]) {
			Value.Eng.oilTemp[1] = math.round(systems.ENGINES.oilTemp[1].getValue());
			
			me["OilTemp2"].setText(sprintf("%d", Value.Eng.oilTemp[1]));
			me["OilTemp2"].show();
			
			me["OilTemp2_bar"].setTranslation(0, Value.Eng.oilTemp[1] / 190 * -251);
			me["OilTemp2_bar"].show();
			
			if (Value.Eng.type == "PW") {
				if (Value.Eng.oilTemp[1] <= 50) {
					me["OilTemp2"].setColor(0.9412, 0.7255, 0);
					me["OilTemp2_bar"].setColorFill(0.9412, 0.7255, 0);
					me["OilTemp2_box"].show();
				} else {
					me["OilTemp2"].setColor(1, 1, 1);
					me["OilTemp2_bar"].setColorFill(1, 1, 1);
					me["OilTemp2_box"].hide();
				}
			} else {
				me["OilTemp2_box"].hide();
			}
		} else {
			me["OilTemp2"].hide();
			me["OilTemp2_bar"].hide();
			me["OilTemp2_box"].hide();
		}
		
		if (Value.Eng.fadecPowered[2]) {
			Value.Eng.oilTemp[2] = math.round(systems.ENGINES.oilTemp[2].getValue());
			
			me["OilTemp3"].setText(sprintf("%d", Value.Eng.oilTemp[2]));
			me["OilTemp3"].show();
			
			me["OilTemp3_bar"].setTranslation(0, Value.Eng.oilTemp[2] / 190 * -251);
			me["OilTemp3_bar"].show();
			
			if (Value.Eng.type == "PW") {
				if (Value.Eng.oilTemp[2] <= 50) {
					me["OilTemp3"].setColor(0.9412, 0.7255, 0);
					me["OilTemp3_bar"].setColorFill(0.9412, 0.7255, 0);
					me["OilTemp3_box"].show();
				} else {
					me["OilTemp3"].setColor(1, 1, 1);
					me["OilTemp3_bar"].setColorFill(1, 1, 1);
					me["OilTemp3_box"].hide();
				}
			} else {
				me["OilTemp3_box"].hide();
			}
		} else {
			me["OilTemp3"].hide();
			me["OilTemp3_bar"].hide();
			me["OilTemp3_box"].hide();
		}
		
		# Oil Qty
		Value.Eng.oilQty[0] = systems.ENGINES.oilQty[0].getValue();
		Value.Eng.oilQty[1] = systems.ENGINES.oilQty[1].getValue();
		Value.Eng.oilQty[2] = systems.ENGINES.oilQty[2].getValue();
		
		me["OilQty1"].setText(sprintf("%d", math.round(Value.Eng.oilQty[0])));
		me["OilQty1_bar"].setTranslation(0, Value.Eng.oilQty[0] / 30 * -251);
		
		me["OilQty2"].setText(sprintf("%d", math.round(Value.Eng.oilQty[1])));
		me["OilQty2_bar"].setTranslation(0, Value.Eng.oilQty[1] / 30 * -251);
		
		me["OilQty3"].setText(sprintf("%d", math.round(Value.Eng.oilQty[2])));
		me["OilQty3_bar"].setTranslation(0, Value.Eng.oilQty[2] / 30 * -251);
		
		if (Value.Eng.oilQty[0] <= 4) {
			me["OilQty1"].setColor(0.9412, 0.7255, 0);
			me["OilQty1_bar"].setColorFill(0.9412, 0.7255, 0);
			me["OilQty1_box"].show();
		} else {
			me["OilQty1"].setColor(1, 1, 1);
			me["OilQty1_bar"].setColorFill(1, 1, 1);
			me["OilQty1_box"].hide();
		}
		
		if (Value.Eng.oilQty[1] <= 4) {
			me["OilQty2"].setColor(0.9412, 0.7255, 0);
			me["OilQty2_bar"].setColorFill(0.9412, 0.7255, 0);
			me["OilQty2_box"].show();
		} else {
			me["OilQty2"].setColor(1, 1, 1);
			me["OilQty2_bar"].setColorFill(1, 1, 1);
			me["OilQty2_box"].hide();
		}
		
		if (Value.Eng.oilQty[2] <= 4) {
			me["OilQty3"].setColor(0.9412, 0.7255, 0);
			me["OilQty3_bar"].setColorFill(0.9412, 0.7255, 0);
			me["OilQty3_box"].show();
		} else {
			me["OilQty3"].setColor(1, 1, 1);
			me["OilQty3_bar"].setColorFill(1, 1, 1);
			me["OilQty3_box"].hide();
		}
		
		Value.Eng.oilQtyClineQt[0] = pts.Instrumentation.Sd.Eng.oilQtyClineQt[0].getValue();
		Value.Eng.oilQtyClineQt[1] = pts.Instrumentation.Sd.Eng.oilQtyClineQt[1].getValue();
		Value.Eng.oilQtyClineQt[2] = pts.Instrumentation.Sd.Eng.oilQtyClineQt[2].getValue();
		
		if (Value.Eng.oilQtyClineQt[0] != -1) {
			me["OilQty1_cline"].setTranslation(0, Value.Eng.oilQtyClineQt[0] / 30 * -251);
			me["OilQty1_cline"].show();
		} else {
			me["OilQty1_cline"].hide();
		}
		if (Value.Eng.oilQtyClineQt[1] != -1) {
			me["OilQty2_cline"].setTranslation(0, Value.Eng.oilQtyClineQt[1] / 30 * -251);
			me["OilQty2_cline"].show();
		} else {
			me["OilQty2_cline"].hide();
		}
		if (Value.Eng.oilQtyClineQt[2] != -1) {
			me["OilQty3_cline"].setTranslation(0, Value.Eng.oilQtyClineQt[2] / 30 * -251);
			me["OilQty3_cline"].show();
		} else {
			me["OilQty3_cline"].hide();
		}
	},
};
