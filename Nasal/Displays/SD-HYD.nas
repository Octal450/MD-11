# McDonnell Douglas MD-11 SD
# Copyright (c) 2026 Josh Davidson (Octal450)

var CanvasHyd = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasHyd, CanvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Alert_error", "Aux_line", "Aux1_circle", "Aux1_imp", "Aux1_line", "Aux2_circle", "Aux2_imp", "Aux2_line", "Rmp13_disag", "Rmp13_line", "Rmp13_line2", "Rmp13_m1", "Rmp13_m2", "Rmp13_mc", "Rmp23_disag", "Rmp23_line", "Rmp23_line2", "Rmp23_m1",
		"Rmp23_m2", "Rmp23_mc", "Sys1_line", "Sys1_line2", "Sys1_psi", "Sys1_psi_box", "Sys1_psi_error", "Sys1_qty", "Sys1_qty_error", "Sys1_qty_bar", "Sys1_qty_bar_box", "Sys1_qty_box", "Sys1_qty_line", "Sys1_temp", "Sys1_temp_error", "Sys1PumpL_circle",
		"Sys1PumpL_imp", "Sys1PumpL_line", "Sys1PumpL_p", "Sys1PumpR_auto", "Sys1PumpR_circle", "Sys1PumpR_imp", "Sys1PumpR_line", "Sys1PumpR_p", "Sys2_line", "Sys2_line2", "Sys2_psi", "Sys2_psi_box", "Sys2_psi_error", "Sys2_qty", "Sys2_qty_bar",
		"Sys2_qty_bar_box", "Sys2_qty_box", "Sys2_qty_error", "Sys2_qty_line", "Sys2_temp", "Sys2_temp_error", "Sys2PumpL_circle", "Sys2PumpL_imp", "Sys2PumpL_line", "Sys2PumpL_p", "Sys2PumpR_auto", "Sys2PumpR_circle", "Sys2PumpR_imp", "Sys2PumpR_line",
		"Sys2PumpR_p", "Sys3_line", "Sys3_line2", "Sys3_line3", "Sys3_line4", "Sys3_psi", "Sys3_psi_box", "Sys3_psi_error", "Sys3_qty", "Sys3_qty_bar", "Sys3_qty_bar_box", "Sys3_qty_box", "Sys3_qty_error", "Sys3_qty_line", "Sys3_temp", "Sys3_temp_error",
		"Sys3PumpL_circle", "Sys3PumpL_imp", "Sys3PumpL_line", "Sys3PumpL_p", "Sys3PumpR_auto", "Sys3PumpR_circle", "Sys3PumpR_imp", "Sys3PumpR_line", "Sys3PumpR_p"];
	},
	update: func() {
		Value.Misc.oat = pts.Environment.temperatureDegC.getValue();
		Value.Misc.wow = pts.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Alert_error"].show();
			me["Sys1_psi_error"].show();
			me["Sys1_qty_error"].show();
			me["Sys1_temp_error"].show();
			me["Sys2_psi_error"].show();
			me["Sys2_qty_error"].show();
			me["Sys2_temp_error"].show();
			me["Sys3_psi_error"].show();
			me["Sys3_qty_error"].show();
			me["Sys3_temp_error"].show();
		} else {
			me["Alert_error"].hide();
			me["Sys1_psi_error"].hide();
			me["Sys1_qty_error"].hide();
			me["Sys1_temp_error"].hide();
			me["Sys2_psi_error"].hide();
			me["Sys2_qty_error"].hide();
			me["Sys2_temp_error"].hide();
			me["Sys3_psi_error"].hide();
			me["Sys3_qty_error"].hide();
			me["Sys3_temp_error"].hide();
		}
		
		# PSI
		Value.Hyd.psi[0] = math.round(systems.HYDRAULICS.Psi.sys1.getValue(), 10);
		Value.Hyd.psi[1] = math.round(systems.HYDRAULICS.Psi.sys2.getValue(), 10);
		Value.Hyd.psi[2] = math.round(systems.HYDRAULICS.Psi.sys3.getValue(), 10);
		
		me["Sys1_psi"].setText(sprintf("%d", Value.Hyd.psi[0], 10));
		me["Sys2_psi"].setText(sprintf("%d", Value.Hyd.psi[1], 10));
		me["Sys3_psi"].setText(sprintf("%d", Value.Hyd.psi[2], 10));
		
		if (Value.Hyd.psi[0] < 2400 or Value.Hyd.psi[0] > 3500) {
			me["Sys1_psi"].setColor(0.9412, 0.7255, 0);
			me["Sys1_psi_box"].show();
		} else {
			me["Sys1_psi"].setColor(1, 1, 1);
			me["Sys1_psi_box"].hide();
		}
		
		if (Value.Hyd.psi[1] < 2400 or Value.Hyd.psi[1] > 3500) {
			me["Sys2_psi"].setColor(0.9412, 0.7255, 0);
			me["Sys2_psi_box"].show();
		} else {
			me["Sys2_psi"].setColor(1, 1, 1);
			me["Sys2_psi_box"].hide();
		}
		
		if (Value.Hyd.psi[2] < 2400 or Value.Hyd.psi[2] > 3500) {
			me["Sys3_psi"].setColor(0.9412, 0.7255, 0);
			me["Sys3_psi_box"].show();
		} else {
			me["Sys3_psi"].setColor(1, 1, 1);
			me["Sys3_psi_box"].hide();
		}
		
		# Temp
		me["Sys1_temp"].setText(sprintf("%d", math.round(Value.Misc.oat)) ~ "gC");
		me["Sys2_temp"].setText(sprintf("%d", math.round(Value.Misc.oat)) ~ "gC");
		me["Sys3_temp"].setText(sprintf("%d", math.round(Value.Misc.oat)) ~ "gC");
		
		# Qty
		Value.Hyd.qty[0] = math.round(systems.HYDRAULICS.Qty.sys1.getValue(), 0.1);
		Value.Hyd.qty[1] = math.round(systems.HYDRAULICS.Qty.sys2.getValue(), 0.1);
		Value.Hyd.qty[2] = math.round(systems.HYDRAULICS.Qty.sys3.getValue(), 0.1);
		
		me["Sys1_qty"].setText(sprintf("%4.1f", Value.Hyd.qty[0]));
		me["Sys2_qty"].setText(sprintf("%4.1f", Value.Hyd.qty[1]));
		me["Sys3_qty"].setText(sprintf("%4.1f", Value.Hyd.qty[2]));
		
		Value.Eng.state[0] = systems.ENGINES.state[0].getValue();
		Value.Eng.state[1] = systems.ENGINES.state[1].getValue();
		Value.Eng.state[2] = systems.ENGINES.state[2].getValue();
		
		if (Value.Eng.state[0] < 3) Value.Hyd.qtyLow[0] = 3.8;
		else Value.Hyd.qtyLow[0] = 2.5;
		if (Value.Eng.state[1] < 3) Value.Hyd.qtyLow[1] = 3.8;
		else Value.Hyd.qtyLow[1] = 2.5;
		if (Value.Eng.state[2] < 3) Value.Hyd.qtyLow[2] = 3.8;
		else Value.Hyd.qtyLow[2] = 2.5;
		
		if (Value.Hyd.qty[0] < Value.Hyd.qtyLow[0]) {
			me["Sys1_qty"].setColor(0.9412, 0.7255, 0);
			me["Sys1_qty_bar"].setColorFill(0.9412, 0.7255, 0);
			me["Sys1_qty_bar_box"].setColor(0.9412, 0.7255, 0);
			me["Sys1_qty_box"].show();
		} else {
			me["Sys1_qty"].setColor(1, 1, 1);
			me["Sys1_qty_bar"].setColorFill(0.4706, 0.4706, 0.4706);
			me["Sys1_qty_bar_box"].setColor(1, 1, 1);
			me["Sys1_qty_box"].hide();
		}
		
		if (Value.Hyd.qty[1] < Value.Hyd.qtyLow[1]) {
			me["Sys2_qty"].setColor(0.9412, 0.7255, 0);
			me["Sys2_qty_bar"].setColorFill(0.9412, 0.7255, 0);
			me["Sys2_qty_bar_box"].setColor(0.9412, 0.7255, 0);
			me["Sys2_qty_box"].show();
		} else {
			me["Sys2_qty"].setColor(1, 1, 1);
			me["Sys2_qty_bar"].setColorFill(0.4706, 0.4706, 0.4706);
			me["Sys2_qty_bar_box"].setColor(1, 1, 1);
			me["Sys2_qty_box"].hide();
		}
		
		if (Value.Hyd.qty[2] < Value.Hyd.qtyLow[2]) {
			me["Sys3_qty"].setColor(0.9412, 0.7255, 0);
			me["Sys3_qty_bar"].setColorFill(0.9412, 0.7255, 0);
			me["Sys3_qty_bar_box"].setColor(0.9412, 0.7255, 0);
			me["Sys3_qty_box"].show();
		} else {
			me["Sys3_qty"].setColor(1, 1, 1);
			me["Sys3_qty_bar"].setColorFill(0.4706, 0.4706, 0.4706);
			me["Sys3_qty_bar_box"].setColor(1, 1, 1);
			me["Sys3_qty_box"].hide();
		}
		
		me["Sys1_qty_bar"].setTranslation(0, math.clamp(Value.Hyd.qty[0] * -6.6666, -80, 0));
		if (Value.Eng.state[0] == 3) {
			me["Sys1_qty_line"].setTranslation(0, math.clamp((systems.HYDRAULICS.Qty.sys1Preflight.getValue() * -6.6666), -80, -4));
			me["Sys1_qty_line"].show();
		} else {
			me["Sys1_qty_line"].hide();
		}
		
		me["Sys2_qty_bar"].setTranslation(0, math.clamp(Value.Hyd.qty[1] * -6.6666, -80, 0));
		if (Value.Eng.state[1] == 3) {
			me["Sys2_qty_line"].setTranslation(0, math.clamp((systems.HYDRAULICS.Qty.sys2Preflight.getValue() * -6.6666), -80, -4));
			me["Sys2_qty_line"].show();
		} else {
			me["Sys2_qty_line"].hide();
		}
		
		me["Sys3_qty_bar"].setTranslation(0, math.clamp(Value.Hyd.qty[2] * -6.6666, -80, 0));
		if (Value.Eng.state[2] == 3) {
			me["Sys3_qty_line"].setTranslation(0, math.clamp((systems.HYDRAULICS.Qty.sys3Preflight.getValue() * -6.6666), -80, -4));
			me["Sys3_qty_line"].show();
		} else {
			me["Sys3_qty_line"].hide();
		}
		
		# Pumps 1
		if (systems.HYDRAULICS.PumpCmd.lPump1.getBoolValue()) {
			if (systems.HYDRAULICS.Lights.lPump1Fault.getBoolValue()) {
				me["Sys1PumpL_circle"].setColor(0.9412, 0.7255, 0);
				me["Sys1PumpL_imp"].setColor(0.9412, 0.7255, 0);
				me["Sys1PumpL_p"].show();
			} else {
				me["Sys1PumpL_circle"].setColor(0, 1, 0);
				me["Sys1PumpL_imp"].setColor(0, 1, 0);
				me["Sys1PumpL_p"].hide();
			}
			
			me["Sys1PumpL_imp"].show();
		} else {
			me["Sys1PumpL_circle"].setColor(1, 1, 1);
			me["Sys1PumpL_imp"].hide();
			me["Sys1PumpL_p"].hide();
		}
		
		Value.Hyd.rPumpCmd[0] = systems.HYDRAULICS.PumpCmd.rPump1.getValue();
		if (Value.Hyd.rPumpCmd[0] == 1) {
			if (systems.HYDRAULICS.Lights.rPump1Fault.getBoolValue()) {
				me["Sys1PumpR_circle"].setColor(0.9412, 0.7255, 0);
				me["Sys1PumpR_imp"].setColor(0.9412, 0.7255, 0);
				me["Sys1PumpR_p"].show();
			} else {
				me["Sys1PumpR_circle"].setColor(0, 1, 0);
				me["Sys1PumpR_imp"].setColor(0, 1, 0);
				me["Sys1PumpR_p"].hide();
			}
			
			me["Sys1PumpR_auto"].hide();
			me["Sys1PumpR_imp"].show();
		} else if (Value.Hyd.rPumpCmd[0] == -1) {
			if (systems.HYDRAULICS.Lights.rPump1Fault.getBoolValue()) {
				me["Sys1PumpR_auto"].hide();
				me["Sys1PumpR_circle"].setColor(0.9412, 0.7255, 0);
				me["Sys1PumpR_imp"].setColor(0.9412, 0.7255, 0);
				me["Sys1PumpR_imp"].show();
				me["Sys1PumpR_p"].show();
			} else {
				me["Sys1PumpR_auto"].show();
				me["Sys1PumpR_circle"].setColor(1, 1, 1);
				me["Sys1PumpR_imp"].hide();
				me["Sys1PumpR_p"].hide();
			}
		} else {
			me["Sys1PumpR_auto"].hide();
			me["Sys1PumpR_circle"].setColor(1, 1, 1);
			me["Sys1PumpR_imp"].hide();
			me["Sys1PumpR_p"].hide();
		}
		
		# Pumps 2
		if (systems.HYDRAULICS.PumpCmd.lPump2.getBoolValue()) {
			if (systems.HYDRAULICS.Lights.lPump2Fault.getBoolValue()) {
				me["Sys2PumpL_circle"].setColor(0.9412, 0.7255, 0);
				me["Sys2PumpL_imp"].setColor(0.9412, 0.7255, 0);
				me["Sys2PumpL_p"].show();
			} else {
				me["Sys2PumpL_circle"].setColor(0, 1, 0);
				me["Sys2PumpL_imp"].setColor(0, 1, 0);
				me["Sys2PumpL_p"].hide();
			}
			
			me["Sys2PumpL_imp"].show();
		} else {
			me["Sys2PumpL_circle"].setColor(1, 1, 1);
			me["Sys2PumpL_imp"].hide();
			me["Sys2PumpL_p"].hide();
		}
		
		Value.Hyd.rPumpCmd[1] = systems.HYDRAULICS.PumpCmd.rPump2.getValue();
		if (Value.Hyd.rPumpCmd[1] == 1) {
			if (systems.HYDRAULICS.Lights.rPump2Fault.getBoolValue()) {
				me["Sys2PumpR_circle"].setColor(0.9412, 0.7255, 0);
				me["Sys2PumpR_imp"].setColor(0.9412, 0.7255, 0);
				me["Sys2PumpR_p"].show();
			} else {
				me["Sys2PumpR_circle"].setColor(0, 1, 0);
				me["Sys2PumpR_imp"].setColor(0, 1, 0);
				me["Sys2PumpR_p"].hide();
			}
			
			me["Sys2PumpR_auto"].hide();
			me["Sys2PumpR_imp"].show();
		} else if (Value.Hyd.rPumpCmd[1] == -1) {
			if (systems.HYDRAULICS.Lights.rPump2Fault.getBoolValue()) {
				me["Sys2PumpR_auto"].hide();
				me["Sys2PumpR_circle"].setColor(0.9412, 0.7255, 0);
				me["Sys2PumpR_imp"].setColor(0.9412, 0.7255, 0);
				me["Sys2PumpR_imp"].show();
				me["Sys2PumpR_p"].show();
			} else {
				me["Sys2PumpR_auto"].show();
				me["Sys2PumpR_circle"].setColor(1, 1, 1);
				me["Sys2PumpR_imp"].hide();
				me["Sys2PumpR_p"].hide();
			}
		} else {
			me["Sys2PumpR_auto"].hide();
			me["Sys2PumpR_circle"].setColor(1, 1, 1);
			me["Sys2PumpR_imp"].hide();
			me["Sys2PumpR_p"].hide();
		}
		
		# Pumps 3
		if (systems.HYDRAULICS.PumpCmd.lPump3.getBoolValue()) {
			if (systems.HYDRAULICS.Lights.lPump3Fault.getBoolValue()) {
				me["Sys3PumpL_circle"].setColor(0.9412, 0.7255, 0);
				me["Sys3PumpL_imp"].setColor(0.9412, 0.7255, 0);
				me["Sys3PumpL_p"].show();
			} else {
				me["Sys3PumpL_circle"].setColor(0, 1, 0);
				me["Sys3PumpL_imp"].setColor(0, 1, 0);
				me["Sys3PumpL_p"].hide();
			}
			
			me["Sys3PumpL_imp"].show();
		} else {
			me["Sys3PumpL_circle"].setColor(1, 1, 1);
			me["Sys3PumpL_imp"].hide();
			me["Sys3PumpL_p"].hide();
		}
		
		Value.Hyd.rPumpCmd[2] = systems.HYDRAULICS.PumpCmd.rPump3.getValue();
		if (Value.Hyd.rPumpCmd[2] == 1) {
			if (systems.HYDRAULICS.Lights.rPump3Fault.getBoolValue()) {
				me["Sys3PumpR_circle"].setColor(0.9412, 0.7255, 0);
				me["Sys3PumpR_imp"].setColor(0.9412, 0.7255, 0);
				me["Sys3PumpR_p"].show();
			} else {
				me["Sys3PumpR_circle"].setColor(0, 1, 0);
				me["Sys3PumpR_imp"].setColor(0, 1, 0);
				me["Sys3PumpR_p"].hide();
			}
			
			me["Sys3PumpR_auto"].hide();
			me["Sys3PumpR_imp"].show();
		} else if (Value.Hyd.rPumpCmd[2] == -1) {
			if (systems.HYDRAULICS.Lights.rPump3Fault.getBoolValue()) {
				me["Sys3PumpR_auto"].hide();
				me["Sys3PumpR_circle"].setColor(0.9412, 0.7255, 0);
				me["Sys3PumpR_imp"].setColor(0.9412, 0.7255, 0);
				me["Sys3PumpR_imp"].show();
				me["Sys3PumpR_p"].show();
			} else {
				me["Sys3PumpR_auto"].show();
				me["Sys3PumpR_circle"].setColor(1, 1, 1);
				me["Sys3PumpR_imp"].hide();
				me["Sys3PumpR_p"].hide();
			}
		} else {
			me["Sys3PumpR_auto"].hide();
			me["Sys3PumpR_circle"].setColor(1, 1, 1);
			me["Sys3PumpR_imp"].hide();
			me["Sys3PumpR_p"].hide();
		}
		
		# Aux Pumps
		if (systems.HYDRAULICS.PumpCmd.auxPump1.getBoolValue()) {
			me["Aux1_circle"].setColor(0, 1, 0);
			me["Aux1_imp"].show();
		} else {
			me["Aux1_circle"].setColor(1, 1, 1);
			me["Aux1_imp"].hide();
		}
		
		if (systems.HYDRAULICS.PumpCmd.auxPump2.getBoolValue()) {
			me["Aux2_circle"].setColor(0, 1, 0);
			me["Aux2_imp"].show();
		} else {
			me["Aux2_circle"].setColor(1, 1, 1);
			me["Aux2_imp"].hide();
		}
		
		# RMPs
		if (systems.HYDRAULICS.PumpCmd.rmp13.getBoolValue()) {
			me["Rmp13_m1"].setRotation(90 * D2R);
			me["Rmp13_m2"].setRotation(90 * D2R);
			
			if (systems.HYDRAULICS.Lights.rmp13Disag.getBoolValue()) {
				me["Rmp13_disag"].show();
				me["Rmp13_m1"].setColor(0.9412, 0.7255, 0);
				me["Rmp13_m2"].setColor(0.9412, 0.7255, 0);
				me["Rmp13_mc"].setColor(0.9412, 0.7255, 0);
			} else {
				me["Rmp13_disag"].hide();
				me["Rmp13_m1"].setColor(0, 1, 0);
				me["Rmp13_m2"].setColor(0, 1, 0);
				me["Rmp13_mc"].setColor(0, 1, 0);
			}
		} else {
			me["Rmp13_m1"].setRotation(0);
			me["Rmp13_m2"].setRotation(0);
			
			if (systems.HYDRAULICS.Lights.rmp13Disag.getBoolValue()) {
				me["Rmp13_disag"].show();
				me["Rmp13_m1"].setColor(0.9412, 0.7255, 0);
				me["Rmp13_m2"].setColor(0.9412, 0.7255, 0);
				me["Rmp13_mc"].setColor(0.9412, 0.7255, 0);
			} else {
				me["Rmp13_disag"].hide();
				me["Rmp13_m1"].setColor(1, 1, 1);
				me["Rmp13_m2"].setColor(1, 1, 1);
				me["Rmp13_mc"].setColor(1, 1, 1);
			}
		}
		
		if (systems.HYDRAULICS.PumpCmd.rmp23.getBoolValue()) {
			me["Rmp23_m1"].setRotation(90 * D2R);
			me["Rmp23_m2"].setRotation(90 * D2R);
			
			if (systems.HYDRAULICS.Lights.rmp23Disag.getBoolValue()) {
				me["Rmp23_disag"].show();
				me["Rmp23_m1"].setColor(0.9412, 0.7255, 0);
				me["Rmp23_m2"].setColor(0.9412, 0.7255, 0);
				me["Rmp23_mc"].setColor(0.9412, 0.7255, 0);
			} else {
				me["Rmp23_disag"].hide();
				me["Rmp23_m1"].setColor(0, 1, 0);
				me["Rmp23_m2"].setColor(0, 1, 0);
				me["Rmp23_mc"].setColor(0, 1, 0);
			}
		} else {
			me["Rmp23_m1"].setRotation(0);
			me["Rmp23_m2"].setRotation(0);
			
			if (systems.HYDRAULICS.Lights.rmp23Disag.getBoolValue()) {
				me["Rmp23_disag"].show();
				me["Rmp23_m1"].setColor(0.9412, 0.7255, 0);
				me["Rmp23_m2"].setColor(0.9412, 0.7255, 0);
				me["Rmp23_mc"].setColor(0.9412, 0.7255, 0);
			} else {
				me["Rmp23_disag"].hide();
				me["Rmp23_m1"].setColor(1, 1, 1);
				me["Rmp23_m2"].setColor(1, 1, 1);
				me["Rmp23_mc"].setColor(1, 1, 1);
			}
		}
		
		# Schematic Lines Phase 1
		Value.Hyd.Schematic.sys1PumpLLine = systems.HYDRAULICS.Psi.lPump1.getValue() >= 2400;
		Value.Hyd.Schematic.sys1PumpRLine = systems.HYDRAULICS.Psi.rPump1.getValue() >= 2400;
		Value.Hyd.Schematic.sys2PumpLLine = systems.HYDRAULICS.Psi.lPump2.getValue() >= 2400;
		Value.Hyd.Schematic.sys2PumpRLine = systems.HYDRAULICS.Psi.rPump2.getValue() >= 2400;
		Value.Hyd.Schematic.sys3PumpLLine = systems.HYDRAULICS.Psi.lPump3.getValue() >= 2400;
		Value.Hyd.Schematic.sys3PumpRLine = systems.HYDRAULICS.Psi.rPump3.getValue() >= 2400;
		
		Value.Hyd.Schematic.sys1Line2 = Value.Hyd.Schematic.sys1PumpLLine or Value.Hyd.Schematic.sys1PumpRLine;
		Value.Hyd.Schematic.sys2Line2 = Value.Hyd.Schematic.sys2PumpLLine or Value.Hyd.Schematic.sys2PumpRLine;
		Value.Hyd.Schematic.sys3Line4 = Value.Hyd.Schematic.sys3PumpLLine or Value.Hyd.Schematic.sys3PumpRLine;
		
		Value.Hyd.Schematic.aux1Line = systems.HYDRAULICS.Psi.auxPump1.getValue() >= 2400;
		Value.Hyd.Schematic.aux2Line = systems.HYDRAULICS.Psi.auxPump2.getValue() >= 2400;
		Value.Hyd.Schematic.auxLine = Value.Hyd.Schematic.aux1Line or Value.Hyd.Schematic.aux2Line;
		
		Value.Hyd.rmp13Valve = systems.HYDRAULICS.Valve.rmp13.getValue();
		Value.Hyd.rmp23Valve = systems.HYDRAULICS.Valve.rmp23.getValue();
		
		Value.Hyd.Schematic.rmp13Line2Thru = Value.Hyd.rmp13Valve == 1 and systems.HYDRAULICS.Psi.rmp1To3.getValue() >= 2400; # This is required so that SYS 1 powering SYS 2 thru SYS 3 shows properly
		Value.Hyd.Schematic.rmp23Line = Value.Hyd.rmp23Valve == 1 and (Value.Hyd.Schematic.sys2Line2 or systems.HYDRAULICS.Psi.rmp3To2.getValue() >= 2400 or systems.HYDRAULICS.Psi.rmp1Thru3To2.getValue() >= 2400);
		Value.Hyd.Schematic.rmp23Line2 = Value.Hyd.rmp23Valve == 1 and (Value.Hyd.Schematic.sys3Line4 or Value.Hyd.Schematic.rmp13Line2Thru or Value.Hyd.Schematic.auxLine or systems.HYDRAULICS.Psi.rmp2To3.getValue() >= 2400);
		
		Value.Hyd.Schematic.sys3Line3 = Value.Hyd.Schematic.sys3Line4 or Value.Hyd.Schematic.rmp23Line2;
		Value.Hyd.Schematic.sys3Line2 = Value.Hyd.Schematic.sys3Line3 or Value.Hyd.Schematic.auxLine;
		
		Value.Hyd.Schematic.rmp13Line = Value.Hyd.rmp13Valve == 1 and (Value.Hyd.Schematic.sys1Line2 or systems.HYDRAULICS.Psi.rmp3To1.getValue() >= 2400 or systems.HYDRAULICS.Psi.rmp2Thru3To1.getValue() >= 2400);
		Value.Hyd.Schematic.rmp13Line2 = Value.Hyd.rmp13Valve == 1 and (Value.Hyd.Schematic.sys3Line2 or systems.HYDRAULICS.Psi.rmp1To3.getValue() >= 2400);
		
		Value.Hyd.Schematic.sys1Line = Value.Hyd.Schematic.sys1Line2 or Value.Hyd.Schematic.rmp13Line;
		Value.Hyd.Schematic.sys2Line = Value.Hyd.Schematic.sys2Line2 or Value.Hyd.Schematic.rmp23Line;
		Value.Hyd.Schematic.sys3Line = Value.Hyd.Schematic.sys3Line2 or Value.Hyd.Schematic.rmp13Line2;
		
		# Schematic Lines Phase 2
		if (Value.Hyd.Schematic.auxLine) {
			me["Aux_line"].setColor(0, 1, 0);
		} else {
			me["Aux_line"].setColor(1, 1, 1);
		}
		if (Value.Hyd.Schematic.aux1Line) {
			me["Aux1_line"].setColor(0, 1, 0);
		} else {
			me["Aux1_line"].setColor(1, 1, 1);
		}
		if (Value.Hyd.Schematic.aux2Line) {
			me["Aux2_line"].setColor(0, 1, 0);
		} else {
			me["Aux2_line"].setColor(1, 1, 1);
		}
		
		if (Value.Hyd.Schematic.rmp13Line) {
			me["Rmp13_line"].setColor(0, 1, 0);
		} else {
			me["Rmp13_line"].setColor(1, 1, 1);
		}
		if (Value.Hyd.Schematic.rmp13Line2) {
			me["Rmp13_line2"].setColor(0, 1, 0);
		} else {
			me["Rmp13_line2"].setColor(1, 1, 1);
		}
		
		if (Value.Hyd.Schematic.rmp23Line) {
			me["Rmp23_line"].setColor(0, 1, 0);
		} else {
			me["Rmp23_line"].setColor(1, 1, 1);
		}
		if (Value.Hyd.Schematic.rmp23Line2) {
			me["Rmp23_line2"].setColor(0, 1, 0);
		} else {
			me["Rmp23_line2"].setColor(1, 1, 1);
		}
		
		if (Value.Hyd.Schematic.sys1Line) {
			me["Sys1_line"].setColor(0, 1, 0);
		} else {
			me["Sys1_line"].setColor(1, 1, 1);
		}
		if (Value.Hyd.Schematic.sys1Line2) {
			me["Sys1_line2"].setColor(0, 1, 0);
		} else {
			me["Sys1_line2"].setColor(1, 1, 1);
		}
		
		if (Value.Hyd.Schematic.sys2Line) {
			me["Sys2_line"].setColor(0, 1, 0);
		} else {
			me["Sys2_line"].setColor(1, 1, 1);
		}
		if (Value.Hyd.Schematic.sys2Line2) {
			me["Sys2_line2"].setColor(0, 1, 0);
		} else {
			me["Sys2_line2"].setColor(1, 1, 1);
		}
		
		if (Value.Hyd.Schematic.sys3Line) {
			me["Sys3_line"].setColor(0, 1, 0);
		} else {
			me["Sys3_line"].setColor(1, 1, 1);
		}
		if (Value.Hyd.Schematic.sys3Line2) {
			me["Sys3_line2"].setColor(0, 1, 0);
		} else {
			me["Sys3_line2"].setColor(1, 1, 1);
		}
		if (Value.Hyd.Schematic.sys3Line3) {
			me["Sys3_line3"].setColor(0, 1, 0);
		} else {
			me["Sys3_line3"].setColor(1, 1, 1);
		}
		if (Value.Hyd.Schematic.sys3Line4) {
			me["Sys3_line4"].setColor(0, 1, 0);
		} else {
			me["Sys3_line4"].setColor(1, 1, 1);
		}
		
		if (Value.Hyd.Schematic.sys1PumpLLine) {
			me["Sys1PumpL_line"].setColor(0, 1, 0);
		} else {
			me["Sys1PumpL_line"].setColor(1, 1, 1);
		}
		if (Value.Hyd.Schematic.sys1PumpRLine) {
			me["Sys1PumpR_line"].setColor(0, 1, 0);
		} else {
			me["Sys1PumpR_line"].setColor(1, 1, 1);
		}
		
		if (Value.Hyd.Schematic.sys2PumpLLine) {
			me["Sys2PumpL_line"].setColor(0, 1, 0);
		} else {
			me["Sys2PumpL_line"].setColor(1, 1, 1);
		}
		if (Value.Hyd.Schematic.sys2PumpRLine) {
			me["Sys2PumpR_line"].setColor(0, 1, 0);
		} else {
			me["Sys2PumpR_line"].setColor(1, 1, 1);
		}
		
		if (Value.Hyd.Schematic.sys3PumpLLine) {
			me["Sys3PumpL_line"].setColor(0, 1, 0);
		} else {
			me["Sys3PumpL_line"].setColor(1, 1, 1);
		}
		if (Value.Hyd.Schematic.sys3PumpRLine) {
			me["Sys3PumpR_line"].setColor(0, 1, 0);
		} else {
			me["Sys3PumpR_line"].setColor(1, 1, 1);
		}
	},
};
