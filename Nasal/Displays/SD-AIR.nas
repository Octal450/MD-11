# McDonnell Douglas MD-11 SD
# Copyright (c) 2026 Josh Davidson (Octal450)

var CanvasAir = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasAir, CanvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["AI_tail_group", "AI_wing_L_group", "AI_wing_R_group", "Airplane_pax_divide", "Alert_error", "APU", "APU_disag", "APU_group", "APU_line", "Bleed1", "Bleed1_conn", "Bleed1_conn2", "Bleed1_line", "Bleed1_line2", "Bleed1_line3", "Bleed1_psi",
		"Bleed1_psi_error", "Bleed1_psi_box", "Bleed1_temp_error", "Bleed2", "Bleed2_conn", "Bleed2_line", "Bleed2_line2", "Bleed2_psi", "Bleed2_psi_error", "Bleed2_psi_box", "Bleed2_temp_error", "Bleed3", "Bleed3_conn", "Bleed3_line", "Bleed3_line2",
		"Bleed3_psi", "Bleed3_psi_error", "Bleed3_psi_box", "Bleed3_temp_error", "Cabin_line", "CabinAft_dtemp", "CabinAft_duct", "CabinAft_dtemp_error", "CabinAft_line", "CabinAft_set", "CabinAft_set_error", "CabinAft_temp", "CabinAft_temp_error", "CabinAlt",
		"CabinAlt_box", "CabinAlt_box", "CabinAlt_error", "CabinDP", "CabinDP_error", "CabinFwd_dtemp_error", "CabinFwd_duct", "CabinFwd_set", "CabinFwd_set_error", "CabinFwd_temp_error", "CabinLand", "CabinLand_error", "CabinMid_dtemp_error", "CabinMid_duct",
		"CabinMid_set", "CabinMid_set_error", "CabinMid_temp_error", "CabinRate", "CabinRate_box", "CabinRate_error", "CabinRateDn", "CabinRateUp", "CargoAft_set", "CargoAft_set_error", "CargoAft_temp_error", "CargoFwd_set", "CargoFwd_set", "CargoFwd_set_error",
		"CargoFwd_temp_error", "CargoMid_temp_error", "Cockpit_dtemp_error", "Cockpit_duct", "Cockpit_set", "Cockpit_set_error", "Cockpit_temp_error", "Isol12", "Isol12_disag", "Isol12_line", "Isol13", "Isol13_disag", "Isol13_line", "Pack_line", "Pack1_circle",
		"Pack1_imp", "Pack1_line", "Pack1_temp_error", "Pack2_circle", "Pack2_imp", "Pack2_line", "Pack2_temp_error", "Pack3_circle", "Pack3_imp", "Pack3_line", "Pack3_temp_error", "Pax", "PaxGroup", "ZoneUnit"];
	},
	setup: func() {
		Value.Air.freighter = pts.Options.freighter.getBoolValue();
		if (Value.Air.freighter) { # Not shown on freighter
			me["Airplane_pax_divide"].hide();
			me["CabinAft_duct"].hide();
			me["CabinAft_dtemp"].hide();
			me["CabinAft_line"].hide();
			me["CabinAft_set"].hide();
			me["CabinAft_temp"].hide();
			me["PaxGroup"].hide();
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
		
		# Pax Load
		if (!Value.Air.freighter) {
			me["Pax"].setText(sprintf("%d", systems.PNEUMATICS.paxLoad.getValue()));
		}
		
		# Zone Temperatures
		Value.Air.cabinTempF = pts.Systems.Acconfig.Options.cabinTempF.getBoolValue();
		if (Value.Air.cabinTempF) {
			me["ZoneUnit"].setText("gF");
		} else {
			me["ZoneUnit"].setText("gC");
		}
		
		Value.Air.cockpitTarget = systems.PNEUMATICS.Hvac.cockpitTarget.getValue();
		Value.Air.cabinAftTarget = systems.PNEUMATICS.Hvac.cabinAftTarget.getValue();
		Value.Air.cabinFwdTarget = systems.PNEUMATICS.Hvac.cabinFwdTarget.getValue();
		Value.Air.cabinMidTarget = systems.PNEUMATICS.Hvac.cabinMidTarget.getValue();
		Value.Air.cargoAftTarget = systems.PNEUMATICS.Hvac.cargoAftTarget.getValue();
		Value.Air.cargoFwdTarget = systems.PNEUMATICS.Hvac.cargoFwdTarget.getValue();
		
		if (Value.Air.cockpitTarget >= 60) {
			me["Cockpit_set"].setText(sprintf("%d", math.round(condF2C(Value.Air.cockpitTarget))) ~ "g");
		} else {
			me["Cockpit_set"].setText("OFF");
		}
		
		if (Value.Air.cabinFwdTarget >= 60) {
			me["CabinFwd_set"].setText(sprintf("%d", math.round(condF2C(Value.Air.cabinFwdTarget))) ~ "g");
		} else {
			me["CabinFwd_set"].setText("OFF");
		}
		
		if (Value.Air.cabinMidTarget >= 60) {
			me["CabinMid_set"].setText(sprintf("%d", math.round(condF2C(Value.Air.cabinMidTarget))) ~ "g");
		} else {
			me["CabinMid_set"].setText("OFF");
		}
		
		if (!Value.Air.freighter) {
			if (Value.Air.cabinAftTarget >= 60) {
				me["CabinAft_set"].setText(sprintf("%d", math.round(condF2C(Value.Air.cabinAftTarget))) ~ "g");
			} else {
				me["CabinAft_set"].setText("OFF");
			}
		}
		
		if (Value.Air.cargoFwdTarget >= 35) {
			me["CargoFwd_set"].setText(sprintf("%d", math.round(condF2C(Value.Air.cargoFwdTarget))) ~ "g");
		} else {
			me["CargoFwd_set"].setText("OFF");
		}
		
		if (Value.Air.cargoAftTarget >= 35) {
			me["CargoAft_set"].setText(sprintf("%d", math.round(condF2C(Value.Air.cargoAftTarget))) ~ "g");
		} else {
			me["CargoAft_set"].setText("OFF");
		}
		
		# Packs
		if (systems.PNEUMATICS.PackCmd.pack1.getBoolValue()) {
			if (systems.PNEUMATICS.Lights.pack1Flow.getBoolValue()) {
				me["Pack1_circle"].setColor(0.9412, 0.7255, 0);
				me["Pack1_imp"].setColor(0.9412, 0.7255, 0);
			} else {
				me["Pack1_circle"].setColor(0, 1, 0);
				me["Pack1_imp"].setColor(0, 1, 0);
			}
			
			me["Pack1_imp"].show();
		} else {
			me["Pack1_circle"].setColor(1, 1, 1);
			me["Pack1_imp"].hide();
		}
		
		if (systems.PNEUMATICS.PackCmd.pack2.getBoolValue()) {
			if (systems.PNEUMATICS.Lights.pack2Flow.getBoolValue()) {
				me["Pack2_circle"].setColor(0.9412, 0.7255, 0);
				me["Pack2_imp"].setColor(0.9412, 0.7255, 0);
			} else {
				me["Pack2_circle"].setColor(0, 1, 0);
				me["Pack2_imp"].setColor(0, 1, 0);
			}
			
			me["Pack2_imp"].show();
		} else {
			me["Pack2_circle"].setColor(1, 1, 1);
			me["Pack2_imp"].hide();
		}
		
		if (systems.PNEUMATICS.PackCmd.pack3.getBoolValue()) {
			if (systems.PNEUMATICS.Lights.pack3Flow.getBoolValue()) {
				me["Pack3_circle"].setColor(0.9412, 0.7255, 0);
				me["Pack3_imp"].setColor(0.9412, 0.7255, 0);
			} else {
				me["Pack3_circle"].setColor(0, 1, 0);
				me["Pack3_imp"].setColor(0, 1, 0);
			}
			
			me["Pack3_imp"].show();
		} else {
			me["Pack3_circle"].setColor(1, 1, 1);
			me["Pack3_imp"].hide();
		}
		
		# ISOL Valves
		if (systems.PNEUMATICS.Controls.isol12.getBoolValue()) {
			me["Isol12"].setRotation(90 * D2R);
			
			if (systems.PNEUMATICS.Lights.isol12Disag.getBoolValue()) {
				me["Isol12"].setColor(0.9412, 0.7255, 0);
				me["Isol12_disag"].show();
			} else {
				me["Isol12"].setColor(0, 1, 0);
				me["Isol12_disag"].hide();
			}
		} else {
			me["Isol12"].setRotation(0);
			
			if (systems.PNEUMATICS.Lights.isol12Disag.getBoolValue()) {
				me["Isol12"].setColor(0.9412, 0.7255, 0);
				me["Isol12_disag"].show();
			} else {
				me["Isol12"].setColor(1, 1, 1);
				me["Isol12_disag"].hide();
			}
		}
		
		if (systems.PNEUMATICS.Controls.isol13.getBoolValue()) {
			me["Isol13"].setRotation(90 * D2R);
			
			if (systems.PNEUMATICS.Lights.isol13Disag.getBoolValue()) {
				me["Isol13"].setColor(0.9412, 0.7255, 0);
				me["Isol13_disag"].show();
			} else {
				me["Isol13"].setColor(0, 1, 0);
				me["Isol13_disag"].hide();
			}
		} else {
			me["Isol13"].setRotation(0);
			
			if (systems.PNEUMATICS.Lights.isol13Disag.getBoolValue()) {
				me["Isol13"].setColor(0.9412, 0.7255, 0);
				me["Isol13_disag"].show();
			} else {
				me["Isol13"].setColor(1, 1, 1);
				me["Isol13_disag"].hide();
			}
		}
		
		# Bleed Valves
		Value.Air.bleed1 = systems.PNEUMATICS.Controls.bleed1.getBoolValue();
		Value.Air.bleed2 = systems.PNEUMATICS.Controls.bleed2.getBoolValue();
		Value.Air.bleed3 = systems.PNEUMATICS.Controls.bleed3.getBoolValue();
		Value.Air.bleedApu = systems.PNEUMATICS.Controls.bleedApu.getBoolValue();
		
		me["Bleed1"].setRotation(Value.Air.bleed1 * 90 * D2R);
		if (Value.Air.bleed1 and systems.ENGINES.state[0].getValue() >= 2) {
			me["Bleed1"].setColor(0, 1, 0);
		} else {
			me["Bleed1"].setColor(1, 1, 1);
		}
		
		me["Bleed2"].setRotation(Value.Air.bleed2 * 90 * D2R);
		if (Value.Air.bleed2 and systems.ENGINES.state[1].getValue() >= 2) {
			me["Bleed2"].setColor(0, 1, 0);
		} else {
			me["Bleed2"].setColor(1, 1, 1);
		}
		
		
		me["Bleed3"].setRotation(Value.Air.bleed3 * 90 * D2R);
		if (Value.Air.bleed3 and systems.ENGINES.state[2].getValue() >= 2) {
			me["Bleed3"].setColor(0, 1, 0);
		} else {
			me["Bleed3"].setColor(1, 1, 1);
		}
		
		if (systems.APU.n2.getValue() >= 95) {
			me["APU"].setRotation(Value.Air.bleedApu * 90 * D2R);
			
			if (systems.PNEUMATICS.Lights.apuDisag.getBoolValue()) {
				me["APU"].setColor(0.9412, 0.7255, 0);
				me["APU_disag"].show();
			} else if (Value.Air.bleedApu) {
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
		
		# Schematic Lines Phase 1
		Value.Air.apuPsi = math.round(systems.PNEUMATICS.Psi.apu.getValue());
		Value.Air.eng1Psi = math.round(systems.PNEUMATICS.Psi.eng1.getValue());
		Value.Air.eng2Psi = math.round(systems.PNEUMATICS.Psi.eng2.getValue());
		Value.Air.eng3Psi = math.round(systems.PNEUMATICS.Psi.eng3.getValue());
		
		Value.Air.Schematic.apu = Value.Air.apuPsi > 10;
		Value.Air.Schematic.eng1 = Value.Air.eng1Psi > 10;
		Value.Air.Schematic.eng2 = Value.Air.eng2Psi > 10;
		Value.Air.Schematic.eng3 = Value.Air.eng3Psi > 10;
		Value.Air.Schematic.isol12 = systems.PNEUMATICS.Valve.isol12.getValue() == 1;
		Value.Air.Schematic.isol13 = systems.PNEUMATICS.Valve.isol13.getValue() == 1;
		Value.Air.Schematic.pack1 = systems.PNEUMATICS.Flow.pack1.getValue() >= 6;
		Value.Air.Schematic.pack2 = systems.PNEUMATICS.Flow.pack2.getValue() >= 6;
		Value.Air.Schematic.pack3 = systems.PNEUMATICS.Flow.pack3.getValue() >= 6;
		
		Value.Air.Schematic.bleed1Line = Value.Air.Schematic.eng1 and (Value.Air.Schematic.pack1 or (Value.Air.Schematic.isol12 and Value.Air.Schematic.pack2) or (Value.Air.Schematic.isol13 and Value.Air.Schematic.pack3));
		
		Value.Air.Schematic.bleed1Line2 = (Value.Air.Schematic.eng1 and (Value.Air.Schematic.pack1 or (Value.Air.Schematic.isol13 and Value.Air.Schematic.pack3))) or
			((Value.Air.Schematic.eng2 or Value.Air.Schematic.apu) and Value.Air.Schematic.isol12 and (Value.Air.Schematic.pack1 or (Value.Air.Schematic.isol13 and Value.Air.Schematic.pack3))) or
			(Value.Air.Schematic.eng3 and Value.Air.Schematic.isol13 and Value.Air.Schematic.isol12 and Value.Air.Schematic.pack2);
		
		Value.Air.Schematic.bleed1Line3 = Value.Air.Schematic.pack1 and (Value.Air.Schematic.eng1 or (Value.Air.Schematic.isol12 and Value.Air.Schematic.eng2) or (Value.Air.Schematic.isol12 and Value.Air.Schematic.apu) or
			(Value.Air.Schematic.isol13 and Value.Air.Schematic.eng3));
		
		Value.Air.Schematic.bleed2Line = Value.Air.Schematic.eng2 and (Value.Air.Schematic.pack2 or (Value.Air.Schematic.isol12 and Value.Air.Schematic.pack1) or (Value.Air.Schematic.isol12 and Value.Air.Schematic.isol13 and Value.Air.Schematic.pack3));
		
		Value.Air.Schematic.bleed2Line2 = Value.Air.Schematic.pack2 and (Value.Air.Schematic.eng2 or Value.Air.Schematic.apu or (Value.Air.Schematic.isol12 and Value.Air.Schematic.eng1) or
			(Value.Air.Schematic.isol12 and Value.Air.Schematic.isol13 and Value.Air.Schematic.eng3));
		
		Value.Air.Schematic.bleed3Line = Value.Air.Schematic.eng3 and (Value.Air.Schematic.pack3 or (Value.Air.Schematic.isol13 and Value.Air.Schematic.pack1) or (Value.Air.Schematic.isol13 and Value.Air.Schematic.isol12 and Value.Air.Schematic.pack2));
		
		Value.Air.Schematic.bleed3Line2 = Value.Air.Schematic.pack3 and (Value.Air.Schematic.eng3 or (Value.Air.Schematic.isol13 and Value.Air.Schematic.eng1) or (Value.Air.Schematic.isol13 and Value.Air.Schematic.isol12 and Value.Air.Schematic.eng2) or
			(Value.Air.Schematic.isol13 and Value.Air.Schematic.isol12 and Value.Air.Schematic.apu));
		
		Value.Air.Schematic.isol12Line = Value.Air.Schematic.isol12 and ((Value.Air.Schematic.eng1 and Value.Air.Schematic.pack2) or ((Value.Air.Schematic.eng2 or Value.Air.Schematic.apu) and
			(Value.Air.Schematic.pack1 or (Value.Air.Schematic.isol13 and Value.Air.Schematic.pack3))) or (Value.Air.Schematic.eng3 and Value.Air.Schematic.isol13 and Value.Air.Schematic.pack2));
		
		Value.Air.Schematic.isol13Line = Value.Air.Schematic.isol13 and ((Value.Air.Schematic.eng1 and Value.Air.Schematic.pack3) or (Value.Air.Schematic.eng3 and (Value.Air.Schematic.pack1 or (Value.Air.Schematic.isol12 and Value.Air.Schematic.pack2))) or
			((Value.Air.Schematic.eng2 or Value.Air.Schematic.apu) and Value.Air.Schematic.isol12 and Value.Air.Schematic.pack3));
		
		Value.Air.Schematic.apuLine = Value.Air.Schematic.apu and (Value.Air.Schematic.pack2 or (Value.Air.Schematic.isol12 and Value.Air.Schematic.pack1) or (Value.Air.Schematic.isol12 and Value.Air.Schematic.isol13 and Value.Air.Schematic.pack3));
		
		Value.Air.Schematic.bleed1Conn = (Value.Air.Schematic.bleed1Line + Value.Air.Schematic.bleed1Line2 + Value.Air.Schematic.isol12Line) > 1;
		Value.Air.Schematic.bleed1Conn2 = (Value.Air.Schematic.bleed1Line2 + Value.Air.Schematic.bleed1Line3 + Value.Air.Schematic.isol13Line) > 1;
		Value.Air.Schematic.bleed2Conn = (Value.Air.Schematic.bleed2Line + Value.Air.Schematic.bleed2Line2 + Value.Air.Schematic.isol12Line) > 1;
		Value.Air.Schematic.bleed3Conn = (Value.Air.Schematic.bleed3Line + Value.Air.Schematic.bleed3Line2 + Value.Air.Schematic.isol13Line) > 1;
		
		Value.Air.Schematic.pack1Line = Value.Air.Schematic.pack1 and (Value.Air.Schematic.eng1 or (Value.Air.Schematic.isol12 and Value.Air.Schematic.eng2) or (Value.Air.Schematic.isol12 and Value.Air.Schematic.apu) or
			(Value.Air.Schematic.isol13 and Value.Air.Schematic.eng3));
		
		Value.Air.Schematic.pack2Line = Value.Air.Schematic.pack2 and (Value.Air.Schematic.eng2 or Value.Air.Schematic.apu or (Value.Air.Schematic.isol12 and Value.Air.Schematic.eng1) or
			(Value.Air.Schematic.isol12 and Value.Air.Schematic.isol13 and Value.Air.Schematic.eng3));
		
		Value.Air.Schematic.pack3Line = Value.Air.Schematic.pack3 and (Value.Air.Schematic.eng3 or (Value.Air.Schematic.isol13 and Value.Air.Schematic.eng1) or (Value.Air.Schematic.isol13 and Value.Air.Schematic.isol12 and Value.Air.Schematic.eng2) or
			(Value.Air.Schematic.isol13 and Value.Air.Schematic.isol12 and Value.Air.Schematic.apu));
		
		Value.Air.Schematic.packLine = Value.Air.Schematic.pack2Line or Value.Air.Schematic.pack3Line;
		Value.Air.Schematic.cabinLine = Value.Air.Schematic.pack1Line or Value.Air.Schematic.packLine;
		
		# Schematic Lines Phase 2
		if (Value.Air.Schematic.cabinLine) {
			me["Cabin_line"].setColor(0, 1, 0);
			me["CabinFwd_duct"].setColor(0, 1, 0);
			me["CabinMid_duct"].setColor(0, 1, 0);
			me["Cockpit_duct"].setColor(0, 1, 0);
		} else {
			me["Cabin_line"].setColor(1, 1, 1);
			me["CabinFwd_duct"].setColor(1, 1, 1);
			me["CabinMid_duct"].setColor(1, 1, 1);
			me["Cockpit_duct"].setColor(1, 1, 1);
		}
		if (!Value.Air.freighter) {
			if (Value.Air.Schematic.cabinLine) {
				me["CabinAft_line"].setColor(0, 1, 0);
				me["CabinAft_duct"].setColor(0, 1, 0);
			} else {
				me["CabinAft_line"].setColor(1, 1, 1);
				me["CabinAft_duct"].setColor(1, 1, 1);
			}
		}
		
		if (Value.Air.Schematic.pack1Line) {
			me["Pack1_line"].setColor(0, 1, 0);
		} else {
			me["Pack1_line"].setColor(1, 1, 1);
		}
		if (Value.Air.Schematic.packLine) {
			me["Pack_line"].setColor(0, 1, 0);
		} else {
			me["Pack_line"].setColor(1, 1, 1);
		}
		if (Value.Air.Schematic.pack2Line) {
			me["Pack2_line"].setColor(0, 1, 0);
		} else {
			me["Pack2_line"].setColor(1, 1, 1);
		}
		if (Value.Air.Schematic.pack3Line) {
			me["Pack3_line"].setColor(0, 1, 0);
		} else {
			me["Pack3_line"].setColor(1, 1, 1);
		}
		
		if (Value.Air.Schematic.bleed1Line) {
			me["Bleed1_line"].setColor(0, 1, 0);
		} else {
			me["Bleed1_line"].setColor(1, 1, 1);
		}
		if (Value.Air.Schematic.bleed1Line2) {
			me["Bleed1_line2"].setColor(0, 1, 0);
		} else {
			me["Bleed1_line2"].setColor(1, 1, 1);
		}
		if (Value.Air.Schematic.bleed1Line3) {
			me["Bleed1_line3"].setColor(0, 1, 0);
		} else {
			me["Bleed1_line3"].setColor(1, 1, 1);
		}
		if (Value.Air.Schematic.bleed1Conn) {
			me["Bleed1_conn"].setColor(0, 1, 0);
		} else {
			me["Bleed1_conn"].setColor(1, 1, 1);
		}
		if (Value.Air.Schematic.bleed1Conn2) {
			me["Bleed1_conn2"].setColor(0, 1, 0);
		} else {
			me["Bleed1_conn2"].setColor(1, 1, 1);
		}
		
		if (Value.Air.Schematic.bleed2Line) {
			me["Bleed2_line"].setColor(0, 1, 0);
		} else {
			me["Bleed2_line"].setColor(1, 1, 1);
		}
		if (Value.Air.Schematic.bleed2Line2) {
			me["Bleed2_line2"].setColor(0, 1, 0);
		} else {
			me["Bleed2_line2"].setColor(1, 1, 1);
		}
		if (Value.Air.Schematic.bleed2Conn) {
			me["Bleed2_conn"].setColor(0, 1, 0);
		} else {
			me["Bleed2_conn"].setColor(1, 1, 1);
		}
		
		if (Value.Air.Schematic.bleed3Line) {
			me["Bleed3_line"].setColor(0, 1, 0);
		} else {
			me["Bleed3_line"].setColor(1, 1, 1);
		}
		if (Value.Air.Schematic.bleed3Line2) {
			me["Bleed3_line2"].setColor(0, 1, 0);
		} else {
			me["Bleed3_line2"].setColor(1, 1, 1);
		}
		if (Value.Air.Schematic.bleed3Conn) {
			me["Bleed3_conn"].setColor(0, 1, 0);
		} else {
			me["Bleed3_conn"].setColor(1, 1, 1);
		}
		
		if (Value.Air.Schematic.apuLine) {
			me["APU_line"].setColor(0, 1, 0);
		} else {
			me["APU_line"].setColor(1, 1, 1);
		}
		
		if (Value.Air.Schematic.isol12Line) {
			me["Isol12_line"].setColor(0, 1, 0);
		} else {
			me["Isol12_line"].setColor(1, 1, 1);
		}
		if (Value.Air.Schematic.isol13Line) {
			me["Isol13_line"].setColor(0, 1, 0);
		} else {
			me["Isol13_line"].setColor(1, 1, 1);
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

var condF2C = func(tempF) { # Converts F to C only if C is selected for zone units, round AFTER this
	if (Value.Air.cabinTempF) return tempF;
	return (tempF - 32) * (5/9);
}
