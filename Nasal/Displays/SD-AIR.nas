# McDonnell Douglas MD-11 SD
# Copyright (c) 2026 Josh Davidson (Octal450)

var CanvasAir = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasAir, CanvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["AI_tail_group", "AI_wing_L_group", "AI_wing_R_group", "Alert_error", "APU", "APU_disag", "APU_group", "Bleed1", "Bleed1_psi", "Bleed1_psi_error", "Bleed1_psi_box", "Bleed1_temp_error", "Bleed2", "Bleed2_psi", "Bleed2_psi_error",
		"Bleed2_psi_box", "Bleed2_temp_error", "Bleed3", "Bleed3_psi", "Bleed3_psi_error", "Bleed3_psi_box", "Bleed3_temp_error", "CabinAft_duct", "CabinAft_dtemp", "CabinAft_dtemp_error", "CabinAft_line", "CabinAft_set", "CabinAft_set_error", "CabinAft_temp",
		"CabinAft_temp_error", "CabinAlt", "CabinAlt_box", "CabinAlt_box", "CabinAlt_error", "CabinDP", "CabinDP_error", "CabinFwd_dtemp_error", "CabinFwd_set_error", "CabinFwd_temp_error", "CabinLand", "CabinLand_error", "CabinMid_dtemp_error",
		"CabinMid_set_error", "CabinMid_temp_error", "CabinRate", "CabinRate_box", "CabinRate_error", "CabinRateDn", "CabinRateUp", "CargoAft_set_error", "CargoAft_temp_error", "CargoFwd_set_error", "CargoFwd_temp_error", "CargoMid_temp_error",
		"Cockpit_dtemp_error", "Cockpit_set_error", "Cockpit_temp_error", "Pack1_temp_error", "Pack2_temp_error", "Pack3_temp_error", "ZoneUnit"];
	},
	setup: func() {
		Value.Air.freighter = pts.Options.freighter.getBoolValue();
		if (Value.Air.freighter) {
			me["CabinAft_duct"].hide();
			me["CabinAft_dtemp"].hide();
			me["CabinAft_line"].hide();
			me["CabinAft_set"].hide();
			me["CabinAft_temp"].hide();
		}
		
		# Hide unimplemented objects
		me["AI_tail_group"].hide();
		me["AI_wing_L_group"].hide();
		me["AI_wing_R_group"].hide();
		me["CabinAlt"].setText("0");
		me["CabinAlt_box"].hide();
		me["CabinDP"].setText("0");
		me["CabinRate"].setText("0");
		me["CabinRate_box"].hide();
		me["CabinRateDn"].hide();
	},
	update: func() {
		Value.Misc.wow = pts.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Alert_error"].show();
			me["Bleed1_psi_error"].show();
			me["Bleed1_temp_error"].show();
			me["Bleed2_psi_error"].show();
			me["Bleed2_temp_error"].show();
			me["Bleed3_psi_error"].show();
			me["Bleed3_temp_error"].show();
			me["CabinAlt_error"].show();
			me["CabinDP_error"].show();
			me["CabinLand_error"].show();
			me["CabinRate_error"].show();
			me["CabinFwd_dtemp_error"].show();
			me["CabinFwd_set_error"].show();
			me["CabinFwd_temp_error"].show();
			me["CabinMid_dtemp_error"].show();
			me["CabinMid_set_error"].show();
			me["CabinMid_temp_error"].show();
			me["CargoAft_set_error"].show();
			me["CargoAft_temp_error"].show();
			me["CargoFwd_set_error"].show();
			me["CargoFwd_temp_error"].show();
			me["CargoMid_temp_error"].show();
			me["Cockpit_dtemp_error"].show();
			me["Cockpit_set_error"].show();
			me["Cockpit_temp_error"].show();
			me["Pack1_temp_error"].show();
			me["Pack2_temp_error"].show();
			me["Pack3_temp_error"].show();
			
			if (!Value.Air.freighter) {
				me["CabinAft_dtemp_error"].show();
				me["CabinAft_set_error"].show();
				me["CabinAft_temp_error"].show();
			} else {
				me["CabinAft_dtemp_error"].hide();
				me["CabinAft_set_error"].hide();
				me["CabinAft_temp_error"].hide();
			}
		} else {
			me["Alert_error"].hide();
			me["Bleed1_psi_error"].hide();
			me["Bleed1_temp_error"].hide();
			me["Bleed2_psi_error"].hide();
			me["Bleed2_temp_error"].hide();
			me["Bleed3_psi_error"].hide();
			me["Bleed3_temp_error"].hide();
			me["CabinAft_dtemp_error"].hide();
			me["CabinAft_set_error"].hide();
			me["CabinAft_temp_error"].hide();
			me["CabinAlt_error"].hide();
			me["CabinDP_error"].hide();
			me["CabinLand_error"].hide();
			me["CabinRate_error"].hide();
			me["CabinFwd_dtemp_error"].hide();
			me["CabinFwd_set_error"].hide();
			me["CabinFwd_temp_error"].hide();
			me["CabinMid_dtemp_error"].hide();
			me["CabinMid_set_error"].hide();
			me["CabinMid_temp_error"].hide();
			me["CargoAft_set_error"].hide();
			me["CargoAft_temp_error"].hide();
			me["CargoFwd_set_error"].hide();
			me["CargoFwd_temp_error"].hide();
			me["CargoMid_temp_error"].hide();
			me["Cockpit_dtemp_error"].hide();
			me["Cockpit_set_error"].hide();
			me["Cockpit_temp_error"].hide();
			me["Pack1_temp_error"].hide();
			me["Pack2_temp_error"].hide();
			me["Pack3_temp_error"].hide();
		}
		
		Value.Air.cabinTempF = pts.Systems.Acconfig.Options.cabinTempF.getBoolValue();
		if (Value.Air.cabinTempF) {
			me["ZoneUnit"].setText("gF");
		} else {
			me["ZoneUnit"].setText("gC");
		}
		
		# Bleed Valves
		Value.Air.bleed1 = systems.PNEUMATICS.Controls.bleed1.getBoolValue();
		Value.Air.eng1Psi = math.round(systems.PNEUMATICS.Psi.eng1.getValue());
		
		me["Bleed1"].setRotation(Value.Air.bleed1 * 90 * D2R);
		if (Value.Air.eng1Psi > 10) {
			me["Bleed1"].setColor(0, 1, 0);
		} else {
			me["Bleed1"].setColor(1, 1, 1);
		}
		
		Value.Air.bleed2 = systems.PNEUMATICS.Controls.bleed2.getBoolValue();
		Value.Air.eng2Psi = math.round(systems.PNEUMATICS.Psi.eng2.getValue());
		
		me["Bleed2"].setRotation(Value.Air.bleed2 * 90 * D2R);
		if (Value.Air.eng2Psi > 10) {
			me["Bleed2"].setColor(0, 1, 0);
		} else {
			me["Bleed2"].setColor(1, 1, 1);
		}
		
		Value.Air.bleed3 = systems.PNEUMATICS.Controls.bleed3.getBoolValue();
		Value.Air.eng3Psi = math.round(systems.PNEUMATICS.Psi.eng3.getValue());
		
		me["Bleed3"].setRotation(Value.Air.bleed3 * 90 * D2R);
		if (Value.Air.eng3Psi > 10) {
			me["Bleed3"].setColor(0, 1, 0);
		} else {
			me["Bleed3"].setColor(1, 1, 1);
		}
		
		Value.Air.bleedApu = systems.PNEUMATICS.Controls.bleedApu.getBoolValue();
		Value.Air.apuPsi = math.round(systems.PNEUMATICS.Psi.apu.getValue());
		
		if (systems.APU.n2.getValue() >= 95) {
			me["APU"].setRotation(Value.Air.bleedApu * 90 * D2R);
			
			if (systems.PNEUMATICS.Lights.apuDisag.getBoolValue()) {
				me["APU"].setColor(0.9412, 0.7255, 0);
				me["APU_disag"].show();
			} else if (Value.Air.apuPsi > 10) {
				me["APU"].setColor(0, 1, 0);
				me["APU_disag"].hide();
			} else {
				me["APU"].setColor(1, 1, 1);
				me["APU_disag"].hide();
			}
			
			me["APU_group"].show();
		} else {
			me["APU_group"].hide();
		}
		
		# Bleed Pressure
		Value.Air.bleed1Psi = math.round(systems.PNEUMATICS.Psi.bleed1.getValue());
		Value.Air.bleed2Psi = math.round(systems.PNEUMATICS.Psi.bleed2.getValue());
		Value.Air.bleed3Psi = math.round(systems.PNEUMATICS.Psi.bleed3.getValue());
		
		me["Bleed1_psi"].setText(sprintf("%d", Value.Air.bleed1Psi));
		if (Value.Air.bleed1Psi <= 10) {
			me["Bleed1_psi"].setColor(0.9412, 0.7255, 0);
			me["Bleed1_psi_box"].show();
		} else {
			me["Bleed1_psi"].setColor(1, 1, 1);
			me["Bleed1_psi_box"].hide();
		}
		
		me["Bleed2_psi"].setText(sprintf("%d", Value.Air.bleed2Psi));
		if (Value.Air.bleed2Psi <= 10) {
			me["Bleed2_psi"].setColor(0.9412, 0.7255, 0);
			me["Bleed2_psi_box"].show();
		} else {
			me["Bleed2_psi"].setColor(1, 1, 1);
			me["Bleed2_psi_box"].hide();
		}
		
		me["Bleed3_psi"].setText(sprintf("%d", Value.Air.bleed3Psi));
		if (Value.Air.bleed3Psi <= 10) {
			me["Bleed3_psi"].setColor(0.9412, 0.7255, 0);
			me["Bleed3_psi_box"].show();
		} else {
			me["Bleed3_psi"].setColor(1, 1, 1);
			me["Bleed3_psi_box"].hide();
		}
		
		# Cabin Pressurization
		if (fms.flightData.airportToAlt > -2000) {
			me["CabinLand"].setText(sprintf("%d", fms.flightData.airportToAlt));
			me["CabinLand"].setColor(0.9608, 0, 0.7765);
		} else {
			me["CabinLand"].setText("----");
			me["CabinLand"].setColor(0.9412, 0.7255, 0);
		}
	},
};
