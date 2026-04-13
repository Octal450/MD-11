# McDonnell Douglas MD-11 SD
# Copyright (c) 2026 Josh Davidson (Octal450)

var CanvasFuel = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasFuel, CanvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["AFIValve", "AFIValve_disag", "AFIValve_line", "Alert_error", "APU", "APU_line", "CG", "CG_error", "Eng1_line", "Eng1_line2", "Eng1Used", "Eng1Used_error", "Eng2_conn", "Eng2_line", "Eng2_line2", "Eng2_line3", "Eng2TankTail_text", "Eng2Used",
		"Eng2Used_error", "Eng3_line", "Eng3_line2", "Eng3Used", "Eng3Used_error", "Fuel", "Fuel_error", "Fuel_thousands", "GW", "GW_error", "GW_label", "GW_thousands", "GW_units", "ManifoldAux_conn", "ManifoldAux_conn2", "ManifoldAux_conn3",
		"ManifoldAux_conn4", "ManifoldAux_line", "ManifoldAux_line2", "ManifoldAux_line3", "ManifoldAux_line4", "ManifoldAux_line5", "ManifoldAux_line6", "ManifoldAux_line7", "ManifoldAux_line8", "ManifoldAux_line9", "ManifoldAux_line10", "ManifoldAux_line11",
		"Tank1_error", "Tank1_qty", "Tank1_qty_bar", "Tank1Aft_circle", "Tank1Aft_imp", "Tank1Aft_line", "Tank1Aft_line2", "Tank1Aft_p", "Tank1Fill", "Tank1Fwd_circle", "Tank1Fwd_imp", "Tank1Fwd_line", "Tank1Fwd_p", "Tank1Trans_circle", "Tank1Trans_conn",
		"Tank1Trans_imp", "Tank1Trans_line", "Tank1Trans_p", "Tank1TransFill_line", "Tank2_error", "Tank2_qty", "Tank2_qty_bar", "Tank2Aft_line", "Tank2AftAPU_conn", "Tank2AftAPU_line", "Tank2AftAPU_line2", "Tank2AftFwd_conn", "Tank2AftL_circle",
		"Tank2AftL_imp", "Tank2AftL_line", "Tank2AftL_p", "Tank2AftR_circle", "Tank2AftR_imp", "Tank2AftR_line", "Tank2AftR_line2", "Tank2AftR_p", "Tank2APU_circle", "Tank2APU_imp", "Tank2APU_line", "Tank2APU_p", "Tank2Fill", "Tank2Fwd_circle", "Tank2Fwd_imp",
		"Tank2Fwd_line", "Tank2Fwd_p", "Tank2Trans_circle", "Tank2Trans_conn", "Tank2Trans_imp", "Tank2Trans_line", "Tank2Trans_p", "Tank2TransFill_line", "Tank3_error", "Tank3_qty", "Tank3_qty_bar", "Tank3Aft_circle", "Tank3Aft_imp", "Tank3Aft_line",
		"Tank3Aft_line2", "Tank3Aft_p", "Tank3Fill", "Tank3Fwd_circle", "Tank3Fwd_imp", "Tank3Fwd_line", "Tank3Fwd_p", "Tank3Temp", "Tank3Temp_box", "Tank3Temp_error", "Tank3Trans_circle", "Tank3Trans_conn", "Tank3Trans_imp", "Tank3Trans_line", "Tank3Trans_p",
		"Tank3TransFill_line", "TankAux_qty", "TankAuxFill", "TankAuxLower_error", "TankAuxLower_qty_bar", "TankAuxLowerL_circle", "TankAuxLowerL_imp", "TankAuxLowerL_line", "TankAuxLowerL_p", "TankAuxLowerR_circle", "TankAuxLowerR_imp", "TankAuxLowerR_line",
		"TankAuxLowerR_p", "TankAuxUpper_error", "TankAuxUpper_qty_bar", "TankAuxUpperL_circle", "TankAuxUpperL_imp", "TankAuxUpperL_line", "TankAuxUpperL_p", "TankAuxUpperR_circle", "TankAuxUpperR_imp", "TankAuxUpperR_line", "TankAuxUpperR_p", "TankTail_error",
		"TankTail_qty", "TankTail_qty_bar", "TankTailEng2_circle", "TankTailEng2_imp", "TankTailEng2_line", "TankTailEng2_p", "TankTailEng2_text", "TankTailFill", "TankTailL_circle", "TankTailL_imp", "TankTailL_line", "TankTailL_p", "TankTailR_circle",
		"TankTailR_imp", "TankTailR_line", "TankTailR_p", "TankTailTemp", "TankTailTemp_box", "TankTailTemp_error", "TipLow1", "TipLow3", "XFeed1", "XFeed1_disag", "XFeed1_line", "XFeed2", "XFeed2_disag", "XFeed2_line", "XFeed3", "XFeed3_disag", "XFeed3_line"];
	},
	setup: func() {
		# Hide unimplemented objects
		me["GW"].hide();
		me["GW_label"].hide();
		me["GW_thousands"].hide();
		me["GW_units"].hide();
	},
	update: func() {
		Value.Misc.wow = pts.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Alert_error"].show();
			me["CG_error"].show();
			me["Eng1Used_error"].show();
			me["Eng2Used_error"].show();
			me["Eng3Used_error"].show();
			me["Fuel_error"].show();
			me["GW_error"].show();
			me["Tank1_error"].show();
			me["Tank2_error"].show();
			me["Tank3_error"].show();
			me["Tank3Temp_error"].show();
			me["TankAuxLower_error"].show();
			me["TankAuxUpper_error"].show();
			me["TankTail_error"].show();
			me["TankTailTemp_error"].show();
		} else {
			me["Alert_error"].hide();
			me["CG_error"].hide();
			me["Eng1Used_error"].hide();
			me["Eng2Used_error"].hide();
			me["Eng3Used_error"].hide();
			me["Fuel_error"].hide();
			me["GW_error"].hide();
			me["Tank1_error"].hide();
			me["Tank2_error"].hide();
			me["Tank3_error"].hide();
			me["Tank3Temp_error"].hide();
			me["TankAuxLower_error"].hide();
			me["TankAuxUpper_error"].hide();
			me["TankTail_error"].hide();
			me["TankTailTemp_error"].hide();
		}
		
		# CG, GW, Fuel Total
		Value.Misc.cg = fms.Internal.cgPercentMac.getValue();
		if (Value.Misc.cg > 0) {
			me["CG"].setText(sprintf("%4.1f", math.round(Value.Misc.cg, 0.1)));
			me["CG"].show();
		} else {
			me["CG"].hide();
		}
		
		# GW (except error X) is hidden in most pictures but is in FCOM, need to investigate what makes it show, hidden in setup() for now
		#if (fms.flightData.gwLbs > 0) {
		#	Value.Misc.gw = math.round(fms.flightData.gwLbs * 1000, 100);
		#	me["GW"].setText(right(sprintf("%d", Value.Misc.gw), 3));
		#	me["GW_thousands"].setText(sprintf("%d", math.floor(Value.Misc.gw / 1000)));
		#	me["GW"].show();
		#	me["GW_thousands"].show();
		#} else {
		#	me["GW"].hide();
		#	me["GW_thousands"].hide();
		#}
		
		Value.Misc.fuel = math.round(pts.Consumables.Fuel.totalFuelLbs.getValue(), 100);
		me["Fuel_thousands"].setText(sprintf("%d", math.floor(Value.Misc.fuel / 1000)));
		me["Fuel"].setText(right(sprintf("%03d", Value.Misc.fuel), 3));
		
		# Fuel Used
		me["Eng1Used"].setText(sprintf("%d", math.round(pts.Instrumentation.Sd.Fuel.fu[0].getValue(), 10)));
		me["Eng2Used"].setText(sprintf("%d", math.round(pts.Instrumentation.Sd.Fuel.fu[1].getValue(), 10)));
		me["Eng3Used"].setText(sprintf("%d", math.round(pts.Instrumentation.Sd.Fuel.fu[2].getValue(), 10)));
		
		# Fuel Tank Quantity
		Value.Fuel.qty[0] = pts.Fdm.JSBSim.Propulsion.Tank.contentLbs[0].getValue() + pts.Fdm.JSBSim.Propulsion.Tank.contentLbs[1].getValue();
		Value.Fuel.qty[1] = pts.Fdm.JSBSim.Propulsion.Tank.contentLbs[2].getValue();
		Value.Fuel.qty[2] = pts.Fdm.JSBSim.Propulsion.Tank.contentLbs[3].getValue() + pts.Fdm.JSBSim.Propulsion.Tank.contentLbs[4].getValue();
		Value.Fuel.qty[3] = pts.Fdm.JSBSim.Propulsion.Tank.contentLbs[5].getValue();
		Value.Fuel.qty[4] = pts.Fdm.JSBSim.Propulsion.Tank.contentLbs[6].getValue();
		Value.Fuel.qty[5] = pts.Fdm.JSBSim.Propulsion.Tank.contentLbs[7].getValue();
		
		me["Tank1_qty_bar"].setTranslation(0, math.clamp(Value.Fuel.qty[0] * -(56 / 40500), -56, 0));
		me["Tank1_qty"].setText(sprintf("%d", math.round(Value.Fuel.qty[0], 50)));
		
		me["Tank2_qty_bar"].setTranslation(0, math.clamp(Value.Fuel.qty[1] * -(76 / 64050), -76, 0));
		me["Tank2_qty"].setText(sprintf("%d", math.round(Value.Fuel.qty[1], 50)));
		
		me["Tank3_qty_bar"].setTranslation(0, math.clamp(Value.Fuel.qty[2] * -(56 / 40500), -56, 0));
		me["Tank3_qty"].setText(sprintf("%d", math.round(Value.Fuel.qty[2], 50)));
		
		me["TankAuxUpper_qty_bar"].setTranslation(0, math.clamp(Value.Fuel.qty[3] * -(56 / 87120), -56, 0));
		me["TankAuxLower_qty_bar"].setTranslation(0, math.clamp(Value.Fuel.qty[4] * -(38 / 11010), -38, 0));
		me["TankAux_qty"].setText(sprintf("%d", math.round(Value.Fuel.qty[3] + Value.Fuel.qty[4], 50)));
		
		me["TankTail_qty_bar"].setTranslation(0, math.clamp(Value.Fuel.qty[5] * -(38 / 13130), -38, 0));
		me["TankTail_qty"].setText(sprintf("%d", math.round(Value.Fuel.qty[5], 50)));
		
		# Tank 1 Pumps/Transfer Pump
		if (systems.FUEL.PumpCmd.fwdPump1.getBoolValue()) {
			if (systems.FUEL.Lights.fwdPump1PsiLow.getBoolValue()) {
				me["Tank1Fwd_circle"].setColor(0.9412, 0.7255, 0);
				me["Tank1Fwd_imp"].setColor(0.9412, 0.7255, 0);
				me["Tank1Fwd_p"].show();
			} else {
				me["Tank1Fwd_circle"].setColor(0, 1, 0);
				me["Tank1Fwd_imp"].setColor(0, 1, 0);
				me["Tank1Fwd_p"].hide();
			}
			
			me["Tank1Fwd_imp"].show();
		} else {
			me["Tank1Fwd_circle"].setColor(1, 1, 1);
			me["Tank1Fwd_imp"].hide();
			me["Tank1Fwd_p"].hide();
		}
		
		if (systems.FUEL.PumpCmd.aftPump1.getBoolValue()) {
			if (systems.FUEL.Lights.aftPump1PsiLow.getBoolValue()) {
				me["Tank1Aft_circle"].setColor(0.9412, 0.7255, 0);
				me["Tank1Aft_imp"].setColor(0.9412, 0.7255, 0);
				me["Tank1Aft_p"].show();
			} else {
				me["Tank1Aft_circle"].setColor(0, 1, 0);
				me["Tank1Aft_imp"].setColor(0, 1, 0);
				me["Tank1Aft_p"].hide();
			}
			
			me["Tank1Aft_imp"].show();
		} else {
			me["Tank1Aft_circle"].setColor(1, 1, 1);
			me["Tank1Aft_imp"].hide();
			me["Tank1Aft_p"].hide();
		}
		
		if (systems.FUEL.PumpCmd.trans1.getBoolValue()) {
			if (systems.FUEL.Lights.trans1PsiLow.getBoolValue()) {
				me["Tank1Trans_circle"].setColor(0.9412, 0.7255, 0);
				me["Tank1Trans_imp"].setColor(0.9412, 0.7255, 0);
				me["Tank1Trans_p"].show();
			} else {
				me["Tank1Trans_circle"].setColor(0, 1, 0);
				me["Tank1Trans_imp"].setColor(0, 1, 0);
				me["Tank1Trans_p"].hide();
			}
			
			me["Tank1Trans_imp"].show();
		} else {
			me["Tank1Trans_circle"].setColor(1, 1, 1);
			me["Tank1Trans_imp"].hide();
			me["Tank1Trans_p"].hide();
		}
		
		# X-Feed and Fill 1
		if (systems.FUEL.Controls.xFeed1.getBoolValue()) {
			me["XFeed1"].setRotation(90 * D2R);
			
			if (systems.FUEL.Lights.xFeed1Disag.getBoolValue()) {
				me["XFeed1_disag"].show();
				me["XFeed1"].setColor(0.9412, 0.7255, 0);
			} else {
				me["XFeed1_disag"].hide();
				me["XFeed1"].setColor(0, 1, 0);
			}
		} else {
			me["XFeed1"].setRotation(0);
			
			if (systems.FUEL.Lights.xFeed1Disag.getBoolValue()) {
				me["XFeed1"].setColor(0.9412, 0.7255, 0);
				me["XFeed1_disag"].show();
			} else {
				me["XFeed1"].setColor(1, 1, 1);
				me["XFeed1_disag"].hide();
			}
		}
		
		Value.Fuel.fill1 = systems.FUEL.Lights.fillStatus1.getValue();
		if (Value.Fuel.fill1 > 0) {
			if (Value.Fuel.fill1 == 2) {
				me["Tank1Fill"].setColor(0, 1, 0);
			} else {
				me["Tank1Fill"].setColor(1, 1, 1);
			}
			
			me["Tank1Fill"].show();
		} else {
			me["Tank1Fill"].hide();
		}
		
		# Tank 2 Pumps/Transfer Pump (APU located below schematic)
		if (systems.FUEL.PumpCmd.fwdPump2.getBoolValue()) {
			if (systems.FUEL.Lights.fwdPump2PsiLow.getBoolValue()) {
				me["Tank2Fwd_circle"].setColor(0.9412, 0.7255, 0);
				me["Tank2Fwd_imp"].setColor(0.9412, 0.7255, 0);
				me["Tank2Fwd_p"].show();
			} else {
				me["Tank2Fwd_circle"].setColor(0, 1, 0);
				me["Tank2Fwd_imp"].setColor(0, 1, 0);
				me["Tank2Fwd_p"].hide();
			}
			
			me["Tank2Fwd_imp"].show();
		} else {
			me["Tank2Fwd_circle"].setColor(1, 1, 1);
			me["Tank2Fwd_imp"].hide();
			me["Tank2Fwd_p"].hide();
		}
		
		if (systems.FUEL.PumpCmd.aftPump2L.getBoolValue()) {
			if (systems.FUEL.Lights.aftPump2LPsiLow.getBoolValue()) {
				me["Tank2AftL_circle"].setColor(0.9412, 0.7255, 0);
				me["Tank2AftL_imp"].setColor(0.9412, 0.7255, 0);
				me["Tank2AftL_p"].show();
			} else {
				me["Tank2AftL_circle"].setColor(0, 1, 0);
				me["Tank2AftL_imp"].setColor(0, 1, 0);
				me["Tank2AftL_p"].hide();
			}
			
			me["Tank2AftL_imp"].show();
		} else {
			me["Tank2AftL_circle"].setColor(1, 1, 1);
			me["Tank2AftL_imp"].hide();
			me["Tank2AftL_p"].hide();
		}
		
		if (systems.FUEL.PumpCmd.aftPump2R.getBoolValue()) {
			if (systems.FUEL.Lights.aftPump2RPsiLow.getBoolValue()) {
				me["Tank2AftR_circle"].setColor(0.9412, 0.7255, 0);
				me["Tank2AftR_imp"].setColor(0.9412, 0.7255, 0);
				me["Tank2AftR_p"].show();
			} else {
				me["Tank2AftR_circle"].setColor(0, 1, 0);
				me["Tank2AftR_imp"].setColor(0, 1, 0);
				me["Tank2AftR_p"].hide();
			}
			
			me["Tank2AftR_imp"].show();
		} else {
			me["Tank2AftR_circle"].setColor(1, 1, 1);
			me["Tank2AftR_imp"].hide();
			me["Tank2AftR_p"].hide();
		}
		
		if (systems.FUEL.PumpCmd.trans2.getBoolValue()) {
			if (systems.FUEL.Lights.trans2PsiLow.getBoolValue()) {
				me["Tank2Trans_circle"].setColor(0.9412, 0.7255, 0);
				me["Tank2Trans_imp"].setColor(0.9412, 0.7255, 0);
				me["Tank2Trans_p"].show();
			} else {
				me["Tank2Trans_circle"].setColor(0, 1, 0);
				me["Tank2Trans_imp"].setColor(0, 1, 0);
				me["Tank2Trans_p"].hide();
			}
			
			me["Tank2Trans_imp"].show();
		} else {
			me["Tank2Trans_circle"].setColor(1, 1, 1);
			me["Tank2Trans_imp"].hide();
			me["Tank2Trans_p"].hide();
		}
		
		# X-Feed and Fill 2
		if (systems.FUEL.Controls.xFeed2.getBoolValue()) {
			me["XFeed2"].setRotation(90 * D2R);
			
			if (systems.FUEL.Lights.xFeed2Disag.getBoolValue()) {
				me["XFeed2"].setColor(0.9412, 0.7255, 0);
				me["XFeed2_disag"].show();
			} else {
				me["XFeed2"].setColor(0, 1, 0);
				me["XFeed2_disag"].hide();
			}
		} else {
			me["XFeed2"].setRotation(0);
			
			if (systems.FUEL.Lights.xFeed2Disag.getBoolValue()) {
				me["XFeed2"].setColor(0.9412, 0.7255, 0);
				me["XFeed2_disag"].show();
			} else {
				me["XFeed2"].setColor(1, 1, 1);
				me["XFeed2_disag"].hide();
			}
		}
		
		Value.Fuel.fill2 = systems.FUEL.Lights.fillStatus2.getValue();
		if (Value.Fuel.fill2 > 0) {
			if (Value.Fuel.fill2 == 2) {
				me["Tank2Fill"].setColor(0, 1, 0);
			} else {
				me["Tank2Fill"].setColor(1, 1, 1);
			}
			
			me["Tank2Fill"].show();
		} else {
			me["Tank2Fill"].hide();
		}
		
		# Tank 3 Pumps/Transfer Pump
		if (systems.FUEL.PumpCmd.fwdPump3.getBoolValue()) {
			if (systems.FUEL.Lights.fwdPump3PsiLow.getBoolValue()) {
				me["Tank3Fwd_circle"].setColor(0.9412, 0.7255, 0);
				me["Tank3Fwd_imp"].setColor(0.9412, 0.7255, 0);
				me["Tank3Fwd_p"].show();
			} else {
				me["Tank3Fwd_circle"].setColor(0, 1, 0);
				me["Tank3Fwd_imp"].setColor(0, 1, 0);
				me["Tank3Fwd_p"].hide();
			}
			
			me["Tank3Fwd_imp"].show();
		} else {
			me["Tank3Fwd_circle"].setColor(1, 1, 1);
			me["Tank3Fwd_imp"].hide();
			me["Tank3Fwd_p"].hide();
		}
		
		if (systems.FUEL.PumpCmd.aftPump3.getBoolValue()) {
			if (systems.FUEL.Lights.aftPump3PsiLow.getBoolValue()) {
				me["Tank3Aft_circle"].setColor(0.9412, 0.7255, 0);
				me["Tank3Aft_imp"].setColor(0.9412, 0.7255, 0);
				me["Tank3Aft_p"].show();
			} else {
				me["Tank3Aft_circle"].setColor(0, 1, 0);
				me["Tank3Aft_imp"].setColor(0, 1, 0);
				me["Tank3Aft_p"].hide();
			}
			
			me["Tank3Aft_imp"].show();
		} else {
			me["Tank3Aft_circle"].setColor(1, 1, 1);
			me["Tank3Aft_imp"].hide();
			me["Tank3Aft_p"].hide();
		}
		
		if (systems.FUEL.PumpCmd.trans3.getBoolValue()) {
			if (systems.FUEL.Lights.trans3PsiLow.getBoolValue()) {
				me["Tank3Trans_circle"].setColor(0.9412, 0.7255, 0);
				me["Tank3Trans_imp"].setColor(0.9412, 0.7255, 0);
				me["Tank3Trans_p"].show();
			} else {
				me["Tank3Trans_circle"].setColor(0, 1, 0);
				me["Tank3Trans_imp"].setColor(0, 1, 0);
				me["Tank3Trans_p"].hide();
			}
			
			me["Tank3Trans_imp"].show();
		} else {
			me["Tank3Trans_circle"].setColor(1, 1, 1);
			me["Tank3Trans_imp"].hide();
			me["Tank3Trans_p"].hide();
		}
		
		# X-Feed and Fill 3
		if (systems.FUEL.Controls.xFeed3.getBoolValue()) {
			me["XFeed3"].setRotation(90 * D2R);
			
			if (systems.FUEL.Lights.xFeed3Disag.getBoolValue()) {
				me["XFeed3"].setColor(0.9412, 0.7255, 0);
				me["XFeed3_disag"].show();
			} else {
				me["XFeed3"].setColor(0, 1, 0);
				me["XFeed3_disag"].hide();
			}
		} else {
			me["XFeed3"].setRotation(0);
			
			if (systems.FUEL.Lights.xFeed3Disag.getBoolValue()) {
				me["XFeed3"].setColor(0.9412, 0.7255, 0);
				me["XFeed3_disag"].show();
			} else {
				me["XFeed3"].setColor(1, 1, 1);
				me["XFeed3_disag"].hide();
			}
		}
		
		Value.Fuel.fill3 = systems.FUEL.Lights.fillStatus3.getValue();
		if (Value.Fuel.fill3 > 0) {
			if (Value.Fuel.fill3 == 2) {
				me["Tank3Fill"].setColor(0, 1, 0);
			} else {
				me["Tank3Fill"].setColor(1, 1, 1);
			}
			
			me["Tank3Fill"].show();
		} else {
			me["Tank3Fill"].hide();
		}
		
		# Tip Low Warning
		if (systems.FUEL.Lights.tipLow1.getBoolValue()) {
			me["TipLow1"].show();
		} else {
			me["TipLow1"].hide();
		}
		
		if (systems.FUEL.Lights.tipLow3.getBoolValue()) {
			me["TipLow3"].show();
		} else {
			me["TipLow3"].hide();
		}
		
		# Aux Tank Transfer Pumps
		if (systems.FUEL.PumpCmd.transAuxUpperL.getBoolValue()) {
			if (systems.FUEL.Lights.transAuxUpperLPsiLow.getBoolValue()) {
				me["TankAuxUpperL_circle"].setColor(0.9412, 0.7255, 0);
				me["TankAuxUpperL_imp"].setColor(0.9412, 0.7255, 0);
				me["TankAuxUpperL_p"].show();
			} else {
				me["TankAuxUpperL_circle"].setColor(0, 1, 0);
				me["TankAuxUpperL_imp"].setColor(0, 1, 0);
				me["TankAuxUpperL_p"].hide();
			}
			
			me["TankAuxUpperL_imp"].show();
		} else {
			me["TankAuxUpperL_circle"].setColor(1, 1, 1);
			me["TankAuxUpperL_imp"].hide();
			me["TankAuxUpperL_p"].hide();
		}
		
		if (systems.FUEL.PumpCmd.transAuxUpperR.getBoolValue()) {
			if (systems.FUEL.Lights.transAuxUpperRPsiLow.getBoolValue()) {
				me["TankAuxUpperR_circle"].setColor(0.9412, 0.7255, 0);
				me["TankAuxUpperR_imp"].setColor(0.9412, 0.7255, 0);
				me["TankAuxUpperR_p"].show();
			} else {
				me["TankAuxUpperR_circle"].setColor(0, 1, 0);
				me["TankAuxUpperR_imp"].setColor(0, 1, 0);
				me["TankAuxUpperR_p"].hide();
			}
			
			me["TankAuxUpperR_imp"].show();
		} else {
			me["TankAuxUpperR_circle"].setColor(1, 1, 1);
			me["TankAuxUpperR_imp"].hide();
			me["TankAuxUpperR_p"].hide();
		}
		
		if (systems.FUEL.PumpCmd.transAuxLowerL.getBoolValue()) {
			if (systems.FUEL.Lights.transAuxLowerLPsiLow.getBoolValue()) {
				me["TankAuxLowerL_circle"].setColor(0.9412, 0.7255, 0);
				me["TankAuxLowerL_imp"].setColor(0.9412, 0.7255, 0);
				me["TankAuxLowerL_p"].show();
			} else {
				me["TankAuxLowerL_circle"].setColor(0, 1, 0);
				me["TankAuxLowerL_imp"].setColor(0, 1, 0);
				me["TankAuxLowerL_p"].hide();
			}
			
			me["TankAuxLowerL_imp"].show();
		} else {
			me["TankAuxLowerL_circle"].setColor(1, 1, 1);
			me["TankAuxLowerL_imp"].hide();
			me["TankAuxLowerL_p"].hide();
		}
		
		if (systems.FUEL.PumpCmd.transAuxLowerR.getBoolValue()) {
			if (systems.FUEL.Lights.transAuxLowerRPsiLow.getBoolValue()) {
				me["TankAuxLowerR_circle"].setColor(0.9412, 0.7255, 0);
				me["TankAuxLowerR_imp"].setColor(0.9412, 0.7255, 0);
				me["TankAuxLowerR_p"].show();
			} else {
				me["TankAuxLowerR_circle"].setColor(0, 1, 0);
				me["TankAuxLowerR_imp"].setColor(0, 1, 0);
				me["TankAuxLowerR_p"].hide();
			}
			
			me["TankAuxLowerR_imp"].show();
		} else {
			me["TankAuxLowerR_circle"].setColor(1, 1, 1);
			me["TankAuxLowerR_imp"].hide();
			me["TankAuxLowerR_p"].hide();
		}
		
		# Aux Tank Upper Fill
		Value.Fuel.fillAuxUpper = systems.FUEL.Lights.fillStatusAuxUpper.getValue();
		if (Value.Fuel.fillAuxUpper > 0) {
			if (Value.Fuel.fillAuxUpper == 2) {
				me["TankAuxFill"].setColor(0, 1, 0);
			} else {
				me["TankAuxFill"].setColor(1, 1, 1);
			}
			
			me["TankAuxFill"].show();
		} else {
			me["TankAuxFill"].hide();
		}
		
		# Auxiliary Fill Isolation Valve
		if (systems.FUEL.Fsc.afiCmd.getBoolValue()) {
			me["AFIValve"].setRotation(90 * D2R);
			
			if (systems.FUEL.Lights.afiDisag.getBoolValue()) {
				me["AFIValve"].setColor(0.9412, 0.7255, 0);
				me["AFIValve_disag"].show();
			} else {
				me["AFIValve"].setColor(0, 1, 0);
				me["AFIValve_disag"].hide();
			}
		} else {
			me["AFIValve"].setRotation(0);
			
			if (systems.FUEL.Lights.afiDisag.getBoolValue()) {
				me["AFIValve"].setColor(0.9412, 0.7255, 0);
				me["AFIValve_disag"].show();
			} else {
				me["AFIValve"].setColor(1, 1, 1);
				me["AFIValve_disag"].hide();
			}
		}
		
		# Tail Tank Transfer Pumps
		if (systems.FUEL.PumpCmd.transTailL.getBoolValue()) {
			if (systems.FUEL.Lights.transTailLPsiLow.getBoolValue()) {
				me["TankTailL_circle"].setColor(0.9412, 0.7255, 0);
				me["TankTailL_imp"].setColor(0.9412, 0.7255, 0);
				me["TankTailL_p"].show();
			} else {
				me["TankTailL_circle"].setColor(0, 1, 0);
				me["TankTailL_imp"].setColor(0, 1, 0);
				me["TankTailL_p"].hide();
			}
			
			me["TankTailL_imp"].show();
		} else {
			me["TankTailL_circle"].setColor(1, 1, 1);
			me["TankTailL_imp"].hide();
			me["TankTailL_p"].hide();
		}
		
		if (systems.FUEL.PumpCmd.transTailR.getBoolValue()) {
			if (systems.FUEL.Lights.transTailRPsiLow.getBoolValue()) {
				me["TankTailR_circle"].setColor(0.9412, 0.7255, 0);
				me["TankTailR_imp"].setColor(0.9412, 0.7255, 0);
				me["TankTailR_p"].show();
			} else {
				me["TankTailR_circle"].setColor(0, 1, 0);
				me["TankTailR_imp"].setColor(0, 1, 0);
				me["TankTailR_p"].hide();
			}
			
			me["TankTailR_imp"].show();
		} else {
			me["TankTailR_circle"].setColor(1, 1, 1);
			me["TankTailR_imp"].hide();
			me["TankTailR_p"].hide();
		}
		
		if (systems.FUEL.PumpCmd.altPump.getBoolValue()) {
			if (systems.FUEL.Lights.altPumpPsiLow.getBoolValue()) {
				me["TankTailEng2_circle"].setColor(0.9412, 0.7255, 0);
				me["TankTailEng2_imp"].setColor(0.9412, 0.7255, 0);
				me["TankTailEng2_p"].show();
			} else {
				me["TankTailEng2_circle"].setColor(0, 1, 0);
				me["TankTailEng2_imp"].setColor(0, 1, 0);
				me["TankTailEng2_p"].hide();
			}
			
			me["TankTailEng2_imp"].show();
		} else {
			me["TankTailEng2_circle"].setColor(1, 1, 1);
			me["TankTailEng2_imp"].hide();
			me["TankTailEng2_p"].hide();
		}
		
		# Tail Tank Upper Fill
		Value.Fuel.fillTail = systems.FUEL.Lights.fillStatusTail.getValue();
		if (Value.Fuel.fillTail > 0) {
			if (Value.Fuel.fillTail == 2) {
				me["TankTailFill"].setColor(0, 1, 0);
			} else {
				me["TankTailFill"].setColor(1, 1, 1);
			}
			
			me["ManifoldAux_line11"].show();
			me["TankTailFill"].show();
		} else {
			me["ManifoldAux_line11"].hide();
			me["TankTailFill"].hide();
		}
		
		# Cutoffs
		Value.Fuel.cutoff[0] = systems.ENGINES.Controls.cutoff[0].getBoolValue();
		Value.Fuel.cutoff[1] = systems.ENGINES.Controls.cutoff[1].getBoolValue();
		Value.Fuel.cutoff[2] = systems.ENGINES.Controls.cutoff[2].getBoolValue();
		Value.Fuel.cutoff[3] = systems.APU.cutoffCmd.getBoolValue();
		Value.Fuel.cutoff[4] = !(!Value.Fuel.cutoff[1] or !Value.Fuel.cutoff[3]);
		
		# Schematic Lines Phase 1
		Value.Fuel.Schematic.tank1AftLine = systems.FUEL.PumpPsi.aftPump1.getValue() >= 15;
		Value.Fuel.Schematic.tank1FwdLine = systems.FUEL.PumpPsi.fwdPump1.getValue() >= 15;
		Value.Fuel.Schematic.tank1TransLine = systems.FUEL.PumpPsi.trans1.getValue() >= 15;
		Value.Fuel.Schematic.tank2AftLLine = systems.FUEL.PumpPsi.aftPump2L.getValue() >= 15;
		Value.Fuel.Schematic.tank2AftRLine = systems.FUEL.PumpPsi.aftPump2R.getValue() >= 15;
		Value.Fuel.Schematic.tank2APULine = systems.FUEL.PumpPsi.apuStartPump.getValue() >= 15;
		Value.Fuel.Schematic.tank2FwdLine = systems.FUEL.PumpPsi.fwdPump2.getValue() >= 15;
		Value.Fuel.Schematic.tank2TransLine = systems.FUEL.PumpPsi.trans2.getValue() >= 15;
		Value.Fuel.Schematic.tank3AftLine = systems.FUEL.PumpPsi.aftPump3.getValue() >= 15;
		Value.Fuel.Schematic.tank3FwdLine = systems.FUEL.PumpPsi.fwdPump3.getValue() >= 15;
		Value.Fuel.Schematic.tank3TransLine = systems.FUEL.PumpPsi.trans3.getValue() >= 15;
		Value.Fuel.Schematic.tankAuxLowerLLine = systems.FUEL.PumpPsi.transAuxLowerL.getValue() >= 15;
		Value.Fuel.Schematic.tankAuxLowerRLine = systems.FUEL.PumpPsi.transAuxLowerR.getValue() >= 15;
		Value.Fuel.Schematic.tankAuxUpperLLine = systems.FUEL.PumpPsi.transAuxUpperL.getValue() >= 15;
		Value.Fuel.Schematic.tankAuxUpperRLine = systems.FUEL.PumpPsi.transAuxUpperR.getValue() >= 15;
		Value.Fuel.Schematic.tankTailEng2Line = systems.FUEL.PumpPsi.altPump.getValue() >= 15;
		Value.Fuel.Schematic.tankTailLLine = systems.FUEL.PumpPsi.transTailL.getValue() >= 15;
		Value.Fuel.Schematic.tankTailRLine = systems.FUEL.PumpPsi.transTailR.getValue() >= 15;
		
		Value.Fuel.Schematic.tank1AftLine2 = Value.Fuel.Schematic.tank1AftLine and !Value.Fuel.cutoff[0];
		Value.Fuel.Schematic.tank2AftRLine2 = Value.Fuel.Schematic.tank2AftRLine and !Value.Fuel.cutoff[4];
		Value.Fuel.Schematic.tank3AftLine2 = Value.Fuel.Schematic.tank3AftLine and !Value.Fuel.cutoff[2];
		
		Value.Fuel.Schematic.tank2AftLine = (Value.Fuel.Schematic.tank2AftLLine and !Value.Fuel.cutoff[4]) or Value.Fuel.Schematic.tank2AftRLine2;
		
		Value.Fuel.Schematic.tank2AftApuLine2 = (Value.Fuel.Schematic.tank2AftLine or Value.Fuel.Schematic.tank2APULine) and !Value.Fuel.cutoff[4];
		Value.Fuel.Schematic.tank2AftApuLine = ((Value.Fuel.Schematic.tank2AftLine or Value.Fuel.Schematic.tank2APULine) and !Value.Fuel.cutoff[1]) or ((Value.Fuel.Schematic.tank2FwdLine or Value.Fuel.Schematic.xFeed2Line) and !Value.Fuel.cutoff[3]);
		
		Value.Fuel.afiValve = systems.FUEL.Valve.afi.getValue() == 1;
		Value.Fuel.xFeed1 = systems.FUEL.Valve.xFeed1.getValue() == 1 and !Value.Fuel.cutoff[0];
		Value.Fuel.xFeed2 = systems.FUEL.Valve.xFeed2.getValue() == 1 and !Value.Fuel.cutoff[4];
		Value.Fuel.xFeed3 = systems.FUEL.Valve.xFeed3.getValue() == 1 and !Value.Fuel.cutoff[2];
		
		Value.Fuel.Schematic.afiValveTailLine = Value.Fuel.afiValve and Value.Fuel.fillTail and
			(Value.Fuel.Schematic.tank1TransLine or Value.Fuel.Schematic.tank2TransLine or Value.Fuel.Schematic.tank3TransLine or Value.Fuel.Schematic.tankAuxUpperLLine or Value.Fuel.Schematic.tankAuxUpperRLine);
		
		Value.Fuel.Schematic.afiValveMainLine = Value.Fuel.afiValve and (Value.Fuel.fill1 == 2 or Value.Fuel.fill2 == 2 or Value.Fuel.fill3 == 2 or Value.Fuel.xFeed1 or Value.Fuel.xFeed2 or Value.Fuel.xFeed3) and
			(Value.Fuel.Schematic.tankAuxLowerLLine or Value.Fuel.Schematic.tankAuxLowerRLine or Value.Fuel.Schematic.tankTailLLine or Value.Fuel.Schematic.tankTailRLine);
		
		Value.Fuel.Schematic.afiValveLine = Value.Fuel.Schematic.afiValveTailLine or Value.Fuel.Schematic.afiValveMainLine;
		
		Value.Fuel.Schematic.xFeed1Line = Value.Fuel.xFeed1 and
			(Value.Fuel.Schematic.tank1TransLine or Value.Fuel.Schematic.tank2TransLine or Value.Fuel.Schematic.tank3TransLine or Value.Fuel.Schematic.tankAuxUpperLLine or Value.Fuel.Schematic.tankAuxUpperRLine or Value.Fuel.Schematic.afiValveMainLine);
		
		Value.Fuel.Schematic.xFeed2Line = Value.Fuel.xFeed2 and
			(Value.Fuel.Schematic.tank1TransLine or Value.Fuel.Schematic.tank2TransLine or Value.Fuel.Schematic.tank3TransLine or Value.Fuel.Schematic.tankAuxUpperLLine or Value.Fuel.Schematic.tankAuxUpperRLine or Value.Fuel.Schematic.afiValveMainLine);
		
		Value.Fuel.Schematic.xFeed3Line = Value.Fuel.xFeed3 and
			(Value.Fuel.Schematic.tank1TransLine or Value.Fuel.Schematic.tank2TransLine or Value.Fuel.Schematic.tank3TransLine or Value.Fuel.Schematic.tankAuxUpperLLine or Value.Fuel.Schematic.tankAuxUpperRLine or Value.Fuel.Schematic.afiValveMainLine);
		
		Value.Fuel.Schematic.tank1TransFillLine = (Value.Fuel.fill1 == 2 and
			(Value.Fuel.Schematic.tank2TransLine or Value.Fuel.Schematic.tank3TransLine or Value.Fuel.Schematic.tankAuxUpperLLine or Value.Fuel.Schematic.tankAuxUpperRLine or Value.Fuel.Schematic.afiValveMainLine)) or
			(Value.Fuel.Schematic.xFeed1Line and
			(Value.Fuel.Schematic.tank1TransLine or Value.Fuel.Schematic.tank2TransLine or Value.Fuel.Schematic.tank3TransLine or Value.Fuel.Schematic.tankAuxUpperLLine or Value.Fuel.Schematic.tankAuxUpperRLine or Value.Fuel.Schematic.afiValveMainLine));
		
		Value.Fuel.Schematic.tank2TransFillLine = (Value.Fuel.fill2 == 2 and
			(Value.Fuel.Schematic.tank1TransLine or Value.Fuel.Schematic.tank3TransLine or Value.Fuel.Schematic.tankAuxUpperLLine or Value.Fuel.Schematic.tankAuxUpperRLine or Value.Fuel.Schematic.afiValveMainLine)) or
			(Value.Fuel.Schematic.xFeed2Line and
			(Value.Fuel.Schematic.tank1TransLine or Value.Fuel.Schematic.tank2TransLine or Value.Fuel.Schematic.tank3TransLine or Value.Fuel.Schematic.tankAuxUpperLLine or Value.Fuel.Schematic.tankAuxUpperRLine or Value.Fuel.Schematic.afiValveMainLine));
		
		Value.Fuel.Schematic.tank3TransFillLine = (Value.Fuel.fill3 == 2 and
			(Value.Fuel.Schematic.tank1TransLine or Value.Fuel.Schematic.tank2TransLine or Value.Fuel.Schematic.tankAuxUpperLLine or Value.Fuel.Schematic.tankAuxUpperRLine or Value.Fuel.Schematic.afiValveMainLine)) or
			(Value.Fuel.Schematic.xFeed3Line and
			(Value.Fuel.Schematic.tank1TransLine or Value.Fuel.Schematic.tank2TransLine or Value.Fuel.Schematic.tank3TransLine or Value.Fuel.Schematic.tankAuxUpperLLine or Value.Fuel.Schematic.tankAuxUpperRLine or Value.Fuel.Schematic.afiValveMainLine));
		
		Value.Fuel.Schematic.manifoldAuxLine = (Value.Fuel.Schematic.tank1TransLine and (Value.Fuel.fill2 == 2 or Value.Fuel.fill3 == 2 or Value.Fuel.xFeed2 or Value.Fuel.xFeed3)) or
			((Value.Fuel.fill1 == 2 or Value.Fuel.xFeed1) and (Value.Fuel.Schematic.tank2TransLine or Value.Fuel.Schematic.tank3TransLine or Value.Fuel.Schematic.tankAuxUpperLLine or Value.Fuel.Schematic.tankAuxUpperRLine)) or
			(Value.Fuel.Schematic.tank1TransLine and Value.Fuel.Schematic.afiValveTailLine) or ((Value.Fuel.fill1 == 2 or Value.Fuel.Schematic.xFeed1Line) and Value.Fuel.Schematic.afiValveMainLine);
		
		Value.Fuel.Schematic.manifoldAuxLine2 = ((Value.Fuel.Schematic.tank1TransLine or Value.Fuel.Schematic.tankAuxUpperLLine) and (Value.Fuel.fill2 == 2 or Value.Fuel.fill3 == 2 or Value.Fuel.xFeed2 or Value.Fuel.xFeed3)) or
			((Value.Fuel.Schematic.tankAuxUpperRLine or Value.Fuel.Schematic.tank2TransLine or Value.Fuel.Schematic.tank3TransLine) and (Value.Fuel.fill1 == 2 or Value.Fuel.xFeed1)) or
			((Value.Fuel.Schematic.tank1TransLine or Value.Fuel.Schematic.tankAuxUpperLLine) and Value.Fuel.Schematic.afiValveTailLine) or ((Value.Fuel.fill1 == 2 or Value.Fuel.Schematic.xFeed1Line) and Value.Fuel.Schematic.afiValveMainLine);
		
		Value.Fuel.Schematic.manifoldAuxLine3 = ((Value.Fuel.Schematic.tank1TransLine or Value.Fuel.Schematic.tankAuxUpperLLine or Value.Fuel.Schematic.tankAuxUpperRLine) and
			(Value.Fuel.fill2 == 2 or Value.Fuel.fill3 == 2 or Value.Fuel.xFeed2 or Value.Fuel.xFeed3)) or
			((Value.Fuel.Schematic.tank2TransLine or Value.Fuel.Schematic.tank3TransLine) and (Value.Fuel.fill1 == 2 or Value.Fuel.xFeed1)) or
			((Value.Fuel.Schematic.tank1TransLine or Value.Fuel.Schematic.tankAuxUpperLLine or Value.Fuel.Schematic.tankAuxUpperRLine) and Value.Fuel.Schematic.afiValveTailLine) or
			((Value.Fuel.fill1 == 2 or Value.Fuel.Schematic.xFeed1Line) and Value.Fuel.Schematic.afiValveMainLine);
		
		Value.Fuel.Schematic.manifoldAuxLine4 = ((Value.Fuel.Schematic.tank1TransLine or Value.Fuel.Schematic.tank3TransLine or Value.Fuel.Schematic.tankAuxUpperLLine or Value.Fuel.Schematic.tankAuxUpperRLine) and
			(Value.Fuel.fill2 == 2 or Value.Fuel.Schematic.xFeed2Line)) or
			(Value.Fuel.Schematic.tank2TransLine and (Value.Fuel.fill1 == 2 or Value.Fuel.fill3 == 2 or Value.Fuel.Schematic.xFeed1Line or Value.Fuel.Schematic.xFeed3Line or Value.Fuel.Schematic.afiValveTailLine)) or
			((Value.Fuel.fill2 == 2 or Value.Fuel.Schematic.xFeed2Line) and Value.Fuel.Schematic.afiValveMainLine);
		
		Value.Fuel.Schematic.manifoldAuxLine5 = ((Value.Fuel.Schematic.tank1TransLine or Value.Fuel.Schematic.tank2TransLine or Value.Fuel.Schematic.tankAuxUpperLLine or Value.Fuel.Schematic.tankAuxUpperRLine) and
			(Value.Fuel.fill3 == 2 or Value.Fuel.Schematic.xFeed3Line)) or
			(Value.Fuel.Schematic.tank3TransLine and (Value.Fuel.fill1 == 2 or Value.Fuel.fill2 == 2 or Value.Fuel.Schematic.xFeed1Line or Value.Fuel.Schematic.xFeed2Line or Value.Fuel.Schematic.afiValveTailLine)) or
			((Value.Fuel.fill3 == 2 or Value.Fuel.Schematic.xFeed3Line) and Value.Fuel.Schematic.afiValveMainLine);
		
		Value.Fuel.Schematic.manifoldAuxLine6 = (Value.Fuel.fillAuxUpper == 2 and (Value.Fuel.Schematic.tankAuxLowerLLine or Value.Fuel.Schematic.tankAuxLowerRLine or Value.Fuel.Schematic.tankTailLLine or Value.Fuel.Schematic.tankTailRLine)) or
			(Value.Fuel.Schematic.afiValveTailLine and Value.Fuel.fillTail == 2) or Value.Fuel.Schematic.afiValveMainLine;
		
		Value.Fuel.Schematic.manifoldAuxLine7 = (Value.Fuel.fillAuxUpper == 2 and (Value.Fuel.Schematic.tankAuxLowerLLine or Value.Fuel.Schematic.tankAuxLowerRLine)) or
			(Value.Fuel.fillTail == 2 and (Value.Fuel.Schematic.tankAuxLowerLLine or Value.Fuel.Schematic.tankAuxLowerRLine)) or
			(Value.Fuel.Schematic.afiValveMainLine and (Value.Fuel.Schematic.tankAuxLowerLLine or Value.Fuel.Schematic.tankAuxLowerRLine));
		
		Value.Fuel.Schematic.manifoldAuxLine8 = (Value.Fuel.fillAuxUpper == 2 and Value.Fuel.Schematic.tankAuxLowerLLine) or (Value.Fuel.fillTail == 2 and Value.Fuel.Schematic.tankAuxLowerLLine) or
			(Value.Fuel.Schematic.afiValveMainLine and Value.Fuel.Schematic.tankAuxLowerLLine);
		
		Value.Fuel.Schematic.manifoldAuxLine9 = (Value.Fuel.fillAuxUpper == 2 and (Value.Fuel.Schematic.tankTailLLine or Value.Fuel.Schematic.tankTailRLine)) or
			(Value.Fuel.Schematic.afiValveTailLine and Value.Fuel.fillTail == 2) or (Value.Fuel.fillTail == 2 and (Value.Fuel.Schematic.tankAuxLowerLLine or Value.Fuel.Schematic.tankAuxLowerRLine)) or
			(Value.Fuel.Schematic.afiValveMainLine and (Value.Fuel.Schematic.tankTailLLine or Value.Fuel.Schematic.tankTailRLine));
		
		Value.Fuel.Schematic.manifoldAuxLine10 = (Value.Fuel.fillAuxUpper == 2 and Value.Fuel.Schematic.tankTailRLine) or (Value.Fuel.Schematic.afiValveTailLine and Value.Fuel.fillTail == 2) or
			(Value.Fuel.fillTail == 2 and (Value.Fuel.Schematic.tankAuxLowerLLine or Value.Fuel.Schematic.tankAuxLowerRLine)) or (Value.Fuel.Schematic.afiValveMainLine and Value.Fuel.Schematic.tankTailRLine);
		
		Value.Fuel.Schematic.manifoldAuxLine11 = (Value.Fuel.Schematic.afiValveLine and Value.Fuel.fillTail == 2) or (Value.Fuel.fillTail == 2 and (Value.Fuel.Schematic.tankAuxLowerLLine or Value.Fuel.Schematic.tankAuxLowerRLine));
		
		Value.Fuel.Schematic.manifoldAuxConn = (Value.Fuel.Schematic.manifoldAuxLine + Value.Fuel.Schematic.manifoldAuxLine2 + Value.Fuel.Schematic.tankAuxUpperLLine) > 1;
		Value.Fuel.Schematic.manifoldAuxConn2 = (Value.Fuel.Schematic.manifoldAuxLine2 + Value.Fuel.Schematic.manifoldAuxLine3 + Value.Fuel.Schematic.tankAuxUpperRLine) > 1;
		Value.Fuel.Schematic.manifoldAuxConn3 = (Value.Fuel.Schematic.manifoldAuxLine3 + Value.Fuel.Schematic.manifoldAuxLine4 + Value.Fuel.Schematic.manifoldAuxLine5 + Value.Fuel.Schematic.afiValveLine) > 1;
		Value.Fuel.Schematic.manifoldAuxConn4 = (Value.Fuel.Schematic.manifoldAuxLine6 + Value.Fuel.Schematic.manifoldAuxLine7 + Value.Fuel.Schematic.manifoldAuxLine9) > 1;
		
		Value.Fuel.Schematic.tank1TransConn = (Value.Fuel.Schematic.tank1TransLine + Value.Fuel.Schematic.tank1TransFillLine + Value.Fuel.Schematic.manifoldAuxLine) > 1;
		Value.Fuel.Schematic.tank2TransConn = (Value.Fuel.Schematic.tank2TransLine + Value.Fuel.Schematic.tank2TransFillLine + Value.Fuel.Schematic.manifoldAuxLine4) > 1;
		Value.Fuel.Schematic.tank3TransConn = (Value.Fuel.Schematic.tank3TransLine + Value.Fuel.Schematic.tank3TransFillLine + Value.Fuel.Schematic.manifoldAuxLine5) > 1;
		
		Value.Fuel.Schematic.eng1Line2 = Value.Fuel.Schematic.tank1AftLine2 or (Value.Fuel.Schematic.tank1FwdLine and !Value.Fuel.cutoff[0]);
		Value.Fuel.Schematic.eng1Line = Value.Fuel.Schematic.eng1Line2 or Value.Fuel.Schematic.xFeed1Line;
		
		Value.Fuel.Schematic.eng2Line3 = ((Value.Fuel.Schematic.tank2AftLine or Value.Fuel.Schematic.tank2APULine or Value.Fuel.Schematic.tank2FwdLine) and !Value.Fuel.cutoff[1]) or (Value.Fuel.Schematic.xFeed2Line and !Value.Fuel.cutoff[3]);
		Value.Fuel.Schematic.eng2Line2 = (Value.Fuel.Schematic.tank2AftLine or Value.Fuel.Schematic.tank2APULine or Value.Fuel.Schematic.tank2FwdLine or Value.Fuel.Schematic.xFeed2Line) and !Value.Fuel.cutoff[1];
		Value.Fuel.Schematic.eng2Line = Value.Fuel.Schematic.eng2Line2 or (Value.Fuel.Schematic.tankTailEng2Line and !Value.Fuel.cutoff[1]);
		Value.Fuel.Schematic.eng2Conn = (Value.Fuel.Schematic.eng2Line2 + Value.Fuel.Schematic.eng2Line3 + Value.Fuel.Schematic.xFeed2Line) > 1;
		
		Value.Fuel.Schematic.apuLine = (Value.Fuel.Schematic.tank2AftLine or Value.Fuel.Schematic.tank2APULine or Value.Fuel.Schematic.tank2FwdLine or Value.Fuel.Schematic.xFeed2Line) and !Value.Fuel.cutoff[3];
		Value.Fuel.Schematic.tank2AftApuConn = (Value.Fuel.Schematic.tank2AftApuLine + Value.Fuel.Schematic.tank2AftApuLine2 + Value.Fuel.Schematic.apuLine) > 1;
		Value.Fuel.Schematic.tank2AftFwdConn = (Value.Fuel.Schematic.tank2AftApuLine + Value.Fuel.Schematic.eng2Line3 + Value.Fuel.Schematic.tank2FwdLine) > 1;
		
		Value.Fuel.Schematic.eng3Line2 = Value.Fuel.Schematic.tank3AftLine2 or (Value.Fuel.Schematic.tank3FwdLine and !Value.Fuel.cutoff[2]);
		Value.Fuel.Schematic.eng3Line = Value.Fuel.Schematic.eng3Line2 or Value.Fuel.Schematic.xFeed3Line;
		
		# Schematic Lines Phase 2
		if (Value.Fuel.Schematic.eng1Line) {
			me["Eng1_line"].setColor(0, 1, 0);
		} else {
			me["Eng1_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.eng1Line2) {
			me["Eng1_line2"].setColor(0, 1, 0);
		} else {
			me["Eng1_line2"].setColor(1, 1, 1);
		}
		
		if (Value.Fuel.Schematic.eng2Line) {
			me["Eng2_line"].setColor(0, 1, 0);
		} else {
			me["Eng2_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.eng2Line2) {
			me["Eng2_line2"].setColor(0, 1, 0);
		} else {
			me["Eng2_line2"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.eng2Line3) {
			me["Eng2_line3"].setColor(0, 1, 0);
		} else {
			me["Eng2_line3"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.eng2Conn) {
			me["Eng2_conn"].setColor(0, 1, 0);
		} else {
			me["Eng2_conn"].setColor(1, 1, 1);
		}
		
		if (Value.Fuel.Schematic.apuLine) {
			me["APU_line"].setColor(0, 1, 0);
		} else {
			me["APU_line"].setColor(1, 1, 1);
		}
		
		if (Value.Fuel.Schematic.eng3Line) {
			me["Eng3_line"].setColor(0, 1, 0);
		} else {
			me["Eng3_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.eng3Line2) {
			me["Eng3_line2"].setColor(0, 1, 0);
		} else {
			me["Eng3_line2"].setColor(1, 1, 1);
		}
		
		if (Value.Fuel.Schematic.tank2AftApuLine) {
			me["Tank2AftAPU_line"].setColor(0, 1, 0);
		} else {
			me["Tank2AftAPU_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank2AftApuLine2) {
			me["Tank2AftAPU_line2"].setColor(0, 1, 0);
		} else {
			me["Tank2AftAPU_line2"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank2AftApuConn) {
			me["Tank2AftAPU_conn"].setColor(0, 1, 0);
		} else {
			me["Tank2AftAPU_conn"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank2AftFwdConn) {
			me["Tank2AftFwd_conn"].setColor(0, 1, 0);
		} else {
			me["Tank2AftFwd_conn"].setColor(1, 1, 1);
		}
		
		if (Value.Fuel.Schematic.tank1AftLine) {
			me["Tank1Aft_line"].setColor(0, 1, 0);
		} else {
			me["Tank1Aft_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank1AftLine2) {
			me["Tank1Aft_line2"].setColor(0, 1, 0);
		} else {
			me["Tank1Aft_line2"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank1FwdLine) {
			me["Tank1Fwd_line"].setColor(0, 1, 0);
		} else {
			me["Tank1Fwd_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.xFeed1Line) {
			me["XFeed1_line"].setColor(0, 1, 0);
		} else {
			me["XFeed1_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank1TransFillLine) {
			me["Tank1TransFill_line"].setColor(0, 1, 0);
		} else {
			me["Tank1TransFill_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank1TransConn) {
			me["Tank1Trans_conn"].setColor(0, 1, 0);
		} else {
			me["Tank1Trans_conn"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank1TransLine) {
			me["Tank1Trans_line"].setColor(0, 1, 0);
		} else {
			me["Tank1Trans_line"].setColor(1, 1, 1);
		}
		
		if (Value.Fuel.Schematic.tank2AftLine) {
			me["Tank2Aft_line"].setColor(0, 1, 0);
		} else {
			me["Tank2Aft_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank2AftLLine) {
			me["Tank2AftL_line"].setColor(0, 1, 0);
		} else {
			me["Tank2AftL_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank2AftRLine) {
			me["Tank2AftR_line"].setColor(0, 1, 0);
		} else {
			me["Tank2AftR_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank2AftRLine2) {
			me["Tank2AftR_line2"].setColor(0, 1, 0);
		} else {
			me["Tank2AftR_line2"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank2APULine) {
			me["Tank2APU_line"].setColor(0, 1, 0);
		} else {
			me["Tank2APU_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank2FwdLine) {
			me["Tank2Fwd_line"].setColor(0, 1, 0);
		} else {
			me["Tank2Fwd_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.xFeed2Line) {
			me["XFeed2_line"].setColor(0, 1, 0);
		} else {
			me["XFeed2_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank2TransFillLine) {
			me["Tank2TransFill_line"].setColor(0, 1, 0);
		} else {
			me["Tank2TransFill_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank2TransConn) {
			me["Tank2Trans_conn"].setColor(0, 1, 0);
		} else {
			me["Tank2Trans_conn"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank2TransLine) {
			me["Tank2Trans_line"].setColor(0, 1, 0);
		} else {
			me["Tank2Trans_line"].setColor(1, 1, 1);
		}
		
		if (Value.Fuel.Schematic.tank3AftLine) {
			me["Tank3Aft_line"].setColor(0, 1, 0);
		} else {
			me["Tank3Aft_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank3AftLine2) {
			me["Tank3Aft_line2"].setColor(0, 1, 0);
		} else {
			me["Tank3Aft_line2"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank3FwdLine) {
			me["Tank3Fwd_line"].setColor(0, 1, 0);
		} else {
			me["Tank3Fwd_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.xFeed3Line) {
			me["XFeed3_line"].setColor(0, 1, 0);
		} else {
			me["XFeed3_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank3TransFillLine) {
			me["Tank3TransFill_line"].setColor(0, 1, 0);
		} else {
			me["Tank3TransFill_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank3TransConn) {
			me["Tank3Trans_conn"].setColor(0, 1, 0);
		} else {
			me["Tank3Trans_conn"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tank3TransLine) {
			me["Tank3Trans_line"].setColor(0, 1, 0);
		} else {
			me["Tank3Trans_line"].setColor(1, 1, 1);
		}
		
		if (Value.Fuel.Schematic.manifoldAuxLine) {
			me["ManifoldAux_line"].setColor(0, 1, 0);
		} else {
			me["ManifoldAux_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.manifoldAuxLine2) {
			me["ManifoldAux_line2"].setColor(0, 1, 0);
		} else {
			me["ManifoldAux_line2"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.manifoldAuxLine3) {
			me["ManifoldAux_line3"].setColor(0, 1, 0);
		} else {
			me["ManifoldAux_line3"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.manifoldAuxLine4) {
			me["ManifoldAux_line4"].setColor(0, 1, 0);
		} else {
			me["ManifoldAux_line4"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.manifoldAuxLine5) {
			me["ManifoldAux_line5"].setColor(0, 1, 0);
		} else {
			me["ManifoldAux_line5"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.manifoldAuxLine6) {
			me["ManifoldAux_line6"].setColor(0, 1, 0);
		} else {
			me["ManifoldAux_line6"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.manifoldAuxLine7) {
			me["ManifoldAux_line7"].setColor(0, 1, 0);
		} else {
			me["ManifoldAux_line7"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.manifoldAuxLine8) {
			me["ManifoldAux_line8"].setColor(0, 1, 0);
		} else {
			me["ManifoldAux_line8"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.manifoldAuxLine9) {
			me["ManifoldAux_line9"].setColor(0, 1, 0);
		} else {
			me["ManifoldAux_line9"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.manifoldAuxLine10) {
			me["ManifoldAux_line10"].setColor(0, 1, 0);
		} else {
			me["ManifoldAux_line10"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.manifoldAuxLine11) {
			me["ManifoldAux_line11"].setColor(0, 1, 0);
		} else {
			me["ManifoldAux_line11"].setColor(1, 1, 1);
		}
		
		if (Value.Fuel.Schematic.manifoldAuxConn) {
			me["ManifoldAux_conn"].setColor(0, 1, 0);
		} else {
			me["ManifoldAux_conn"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.manifoldAuxConn2) {
			me["ManifoldAux_conn2"].setColor(0, 1, 0);
		} else {
			me["ManifoldAux_conn2"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.manifoldAuxConn3) {
			me["ManifoldAux_conn3"].setColor(0, 1, 0);
		} else {
			me["ManifoldAux_conn3"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.manifoldAuxConn4) {
			me["ManifoldAux_conn4"].setColor(0, 1, 0);
		} else {
			me["ManifoldAux_conn4"].setColor(1, 1, 1);
		}
		
		if (Value.Fuel.Schematic.afiValveLine) {
			me["AFIValve_line"].setColor(0, 1, 0);
		} else {
			me["AFIValve_line"].setColor(1, 1, 1);
		}
		
		if (Value.Fuel.Schematic.tankAuxUpperLLine) {
			me["TankAuxUpperL_line"].setColor(0, 1, 0);
		} else {
			me["TankAuxUpperL_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tankAuxUpperRLine) {
			me["TankAuxUpperR_line"].setColor(0, 1, 0);
		} else {
			me["TankAuxUpperR_line"].setColor(1, 1, 1);
		}
		
		if (Value.Fuel.Schematic.tankAuxLowerLLine) {
			me["TankAuxLowerL_line"].setColor(0, 1, 0);
		} else {
			me["TankAuxLowerL_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tankAuxLowerRLine) {
			me["TankAuxLowerR_line"].setColor(0, 1, 0);
		} else {
			me["TankAuxLowerR_line"].setColor(1, 1, 1);
		}
		
		if (Value.Fuel.Schematic.tankTailLLine) {
			me["TankTailL_line"].setColor(0, 1, 0);
		} else {
			me["TankTailL_line"].setColor(1, 1, 1);
		}
		if (Value.Fuel.Schematic.tankTailRLine) {
			me["TankTailR_line"].setColor(0, 1, 0);
		} else {
			me["TankTailR_line"].setColor(1, 1, 1);
		}
		
		if (Value.Fuel.Schematic.tankTailEng2Line) {
			me["Eng2TankTail_text"].setColor(0, 1, 0);
			me["TankTailEng2_line"].setColor(0, 1, 0);
			me["TankTailEng2_text"].setColor(0, 1, 0);
		} else {
			me["Eng2TankTail_text"].setColor(1, 1, 1);
			me["TankTailEng2_line"].setColor(1, 1, 1);
			me["TankTailEng2_text"].setColor(1, 1, 1);
		}
		
		# APU
		if (!Value.Fuel.cutoff[3] or systems.APU.Controls.start.getBoolValue() or Value.Fuel.Schematic.tank2APULine or Value.Fuel.Schematic.apuLine) {
			me["APU"].show();
			me["APU_line"].show();
			me["Tank2APU_circle"].show();
			me["Tank2APU_line"].show();
		
			if (systems.FUEL.PumpCmd.apuStartPump.getBoolValue()) {
				if (systems.FUEL.Lights.apuStartPumpPsiLow.getBoolValue()) {
					me["Tank2APU_circle"].setColor(0.9412, 0.7255, 0);
					me["Tank2APU_imp"].setColor(0.9412, 0.7255, 0);
					me["Tank2APU_p"].show();
				} else {
					me["Tank2APU_circle"].setColor(0, 1, 0);
					me["Tank2APU_imp"].setColor(0, 1, 0);
					me["Tank2APU_p"].hide();
				}
				
				me["Tank2APU_imp"].show();
			} else {
				me["Tank2APU_circle"].setColor(1, 1, 1);
				me["Tank2APU_imp"].hide();
				me["Tank2APU_p"].hide();
			}
		} else {
			me["APU"].hide();
			me["APU_line"].hide();
			me["Tank2APU_circle"].hide();
			me["Tank2APU_line"].hide();
			me["Tank2APU_imp"].hide();
			me["Tank2APU_p"].hide();
		}
		
		# Fuel Temperature
		Value.Fuel.tank3Temp = math.round(systems.FUEL.Temp.tank3.getValue());
		if (Value.Fuel.tank3Temp < 0) {
			me["Tank3Temp"].setText(sprintf("%2.0f", Value.Fuel.tank3Temp) ~ "gC");
			
			if (Value.Fuel.tank3Temp < -37) { # FMS Freeze + 3
				me["Tank3Temp_box"].show();
			} else {
				me["Tank3Temp_box"].hide();
			}
		} else {
			me["Tank3Temp"].setText("+" ~ sprintf("%2.0f", Value.Fuel.tank3Temp) ~ "gC");
			me["Tank3Temp_box"].hide();
		}
		
		Value.Fuel.tankTailTemp = math.round(systems.FUEL.Temp.tankTail.getValue());
		if (Value.Fuel.tankTailTemp < 0) {
			me["TankTailTemp"].setText(sprintf("%2.0f", Value.Fuel.tankTailTemp) ~ "gC");
			
			if (Value.Fuel.tankTailTemp < -37) { # FMS Freeze + 3
				me["TankTailTemp_box"].show();
			} else {
				me["TankTailTemp_box"].hide();
			}
		} else {
			me["TankTailTemp"].setText("+" ~ sprintf("%2.0f", Value.Fuel.tankTailTemp) ~ "gC");
			me["TankTailTemp_box"].hide();
		}
	},
};
