# McDonnell Douglas MD-11 SD
# Copyright (c) 2026 Josh Davidson (Octal450)

var CanvasConfig = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasConfig, CanvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Alert_error", "AileronL_error", "AileronLDown", "AileronLUp", "AileronR_error", "AileronRDown", "AileronRUp", "CenterPressL", "CenterPressR", "CenterStatus", "ElevatorL_error", "ElevatorLDown", "ElevatorLUp", "ElevatorR_error", "ElevatorRDown",
		"ElevatorRUp", "ELFGroup", "ELFNeedle", "Flap1", "Flap1_error", "Flap2", "Flap2_error", "Flap3", "Flap3_error", "Flap4", "Flap4_error", "FlapBox", "GearTest", "LeftPressLAft", "LeftPressLFwd", "LeftPressRAft", "LeftPressRFwd", "LeftStatus", "NosePressL",
		"NosePressR", "NoseStatus", "RightPressLAft", "RightPressLFwd", "RightPressRAft", "RightPressRFwd", "RightStatus", "RudderLower_error", "RudderLowerLeft", "RudderLowerRight", "RudderUpper_error", "RudderUpperLeft", "RudderUpperRight", "SlatExt",
		"SpoilerL", "SpoilerL_error", "SpoilerR", "SpoilerR_error", "Stab", "Stab_box", "Stab_error", "StabGreen", "StabNeedle", "StabUnit"];
	},
	update: func() {
		Value.Misc.wow = pts.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Alert_error"].show();
			me["AileronL_error"].show();
			me["AileronR_error"].show();
			me["ElevatorL_error"].show();
			me["ElevatorR_error"].show();
			me["Flap1_error"].show();
			me["Flap2_error"].show();
			me["Flap3_error"].show();
			me["Flap4_error"].show();
			me["GearTest"].show();
			me["RudderLower_error"].show();
			me["RudderUpper_error"].show();
			me["SpoilerL_error"].show();
			me["SpoilerR_error"].show();
			me["Stab_error"].show();
		} else {
			me["Alert_error"].hide();
			me["AileronL_error"].hide();
			me["AileronR_error"].hide();
			me["ElevatorL_error"].hide();
			me["ElevatorR_error"].hide();
			me["Flap1_error"].hide();
			me["Flap2_error"].hide();
			me["Flap3_error"].hide();
			me["Flap4_error"].hide();
			me["GearTest"].hide();
			me["RudderLower_error"].hide();
			me["RudderUpper_error"].hide();
			me["SpoilerL_error"].hide();
			me["SpoilerR_error"].hide();
			me["Stab_error"].hide();
		}
		
		# Elevator Feel Speed
		if (systems.FCC.ElevatorFeel.auto.getBoolValue()) {
			me["ELFGroup"].hide();
		} else {
			me["ELFNeedle"].setTranslation(0, (systems.FCC.ElevatorFeel.speed.getValue() - 120) * -0.7166055);
			me["ELFGroup"].show();
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
		
		# Ailerons
		if (systems.FCS.deflectedAileronActive.getBoolValue()) { # When ailerons are deflected, the green box occurs earlier
			Value.Fctl.aileronDeflGreen = -8.6;
		} else {
			Value.Fctl.aileronDeflGreen = -19.8;
		}
		
		Value.Fctl.aileronL = pts.Instrumentation.Sd.Config.aileronL.getValue();
		Value.Fctl.aileronR = pts.Instrumentation.Sd.Config.aileronR.getValue();
		
		if (Value.Fctl.aileronL <= -0.5) {
			me["AileronLDown"].hide();
			if (Value.Fctl.aileronL <= Value.Fctl.aileronDeflGreen) {
				me["AileronLUp"].setColorFill(0, 1, 0);
			} else {
				me["AileronLUp"].setColorFill(0, 0, 0);
			}
			me["AileronLUp"].setTranslation(0, math.clamp(Value.Fctl.aileronL, -20, 0) * 2.05);
			me["AileronLUp"].show();
		} else if (Value.Fctl.aileronL >= 0.5) {
			me["AileronLUp"].hide();
			if (Value.Fctl.aileronL >= 19.8) {
				me["AileronLDown"].setColorFill(0, 1, 0);
			} else {
				me["AileronLDown"].setColorFill(0, 0, 0);
			}
			me["AileronLDown"].setTranslation(0, math.clamp(Value.Fctl.aileronL, 0, 20) * 2.05);
			me["AileronLDown"].show();
		} else {
			me["AileronLDown"].hide();
			me["AileronLUp"].hide();
		}
		
		if (Value.Fctl.aileronR <= -0.5) {
			me["AileronRDown"].hide();
			if (Value.Fctl.aileronR <= Value.Fctl.aileronDeflGreen) {
				me["AileronRUp"].setColorFill(0, 1, 0);
			} else {
				me["AileronRUp"].setColorFill(0, 0, 0);
			}
			me["AileronRUp"].setTranslation(0, math.clamp(Value.Fctl.aileronR, -20, 0) * 2.05);
			me["AileronRUp"].show();
		} else if (Value.Fctl.aileronR >= 0.5) {
			me["AileronRUp"].hide();
			if (Value.Fctl.aileronR >= 19.8) {
				me["AileronRDown"].setColorFill(0, 1, 0);
			} else {
				me["AileronRDown"].setColorFill(0, 0, 0);
			}
			me["AileronRDown"].setTranslation(0, math.clamp(Value.Fctl.aileronR, 0, 20) * 2.05);
			me["AileronRDown"].show();
		} else {
			me["AileronRDown"].hide();
			me["AileronRUp"].hide();
		}
		
		# Spoilers
		Value.Fctl.spoilerL = systems.FCS.spoilerL.getValue();
		Value.Fctl.spoilerR = systems.FCS.spoilerR.getValue();
		
		if (Value.Fctl.spoilerL >= 1.5) {
			if (Value.Fctl.spoilerL >= 59.4) {
				me["SpoilerL"].setColorFill(0, 1, 0);
			} else {
				me["SpoilerL"].setColorFill(0, 0, 0);
			}
			me["SpoilerL"].setTranslation(0, Value.Fctl.spoilerL * -0.68333);
			me["SpoilerL"].show();
		} else {
			me["SpoilerL"].hide();
		}
		
		if (Value.Fctl.spoilerR >= 1.5) {
			if (Value.Fctl.spoilerR >= 59.4) {
				me["SpoilerR"].setColorFill(0, 1, 0);
			} else {
				me["SpoilerR"].setColorFill(0, 0, 0);
			}
			me["SpoilerR"].setTranslation(0, Value.Fctl.spoilerR * -0.68333);
			me["SpoilerR"].show();
		} else {
			me["SpoilerR"].hide();
		}
		
		# Elevators
		Value.Fctl.elevatorL = pts.Instrumentation.Sd.Config.elevatorL.getValue();
		Value.Fctl.elevatorR = pts.Instrumentation.Sd.Config.elevatorR.getValue();
		
		if (Value.Fctl.elevatorL <= -0.5) {
			me["ElevatorLDown"].hide();
			if (Value.Fctl.elevatorL <= -21.8) {
				me["ElevatorLUp"].setColorFill(0, 1, 0);
			} else {
				me["ElevatorLUp"].setColorFill(0, 0, 0);
			}
			me["ElevatorLUp"].setTranslation(0, math.clamp(Value.Fctl.elevatorL, -22, 0) * 1.18181);
			me["ElevatorLUp"].show();
		} else if (Value.Fctl.elevatorL >= 0.5) {
			me["ElevatorLUp"].hide();
			if (Value.Fctl.elevatorL >= 19.8) {
				me["ElevatorLDown"].setColorFill(0, 1, 0);
			} else {
				me["ElevatorLDown"].setColorFill(0, 0, 0);
			}
			me["ElevatorLDown"].setTranslation(0, math.clamp(Value.Fctl.elevatorL, 0, 20) * 1.18181);
			me["ElevatorLDown"].show();
		} else {
			me["ElevatorLDown"].hide();
			me["ElevatorLUp"].hide();
		}
		
		if (Value.Fctl.elevatorR <= -0.5) {
			me["ElevatorRDown"].hide();
			if (Value.Fctl.elevatorR <= -21.8) {
				me["ElevatorRUp"].setColorFill(0, 1, 0);
			} else {
				me["ElevatorRUp"].setColorFill(0, 0, 0);
			}
			me["ElevatorRUp"].setTranslation(0, math.clamp(Value.Fctl.elevatorR, -22, 0) * 1.18181);
			me["ElevatorRUp"].show();
		} else if (Value.Fctl.elevatorR >= 0.5) {
			me["ElevatorRUp"].hide();
			if (Value.Fctl.elevatorR >= 19.8) {
				me["ElevatorRDown"].setColorFill(0, 1, 0);
			} else {
				me["ElevatorRDown"].setColorFill(0, 0, 0);
			}
			me["ElevatorRDown"].setTranslation(0, math.clamp(Value.Fctl.elevatorR, 0, 20) * 1.18181);
			me["ElevatorRDown"].show();
		} else {
			me["ElevatorRDown"].hide();
			me["ElevatorRUp"].hide();
		}
		
		# Rudders
		Value.Fctl.rudderUpper = systems.FCS.rudderUpperDeg.getValue();
		Value.Fctl.rudderLower = systems.FCS.rudderLowerDeg.getValue();
		
		if (Value.Fctl.rudderUpper <= -0.8) {
			me["RudderUpperRight"].hide();
			if (Value.Fctl.rudderUpper <= -29.7) {
				me["RudderUpperLeft"].setColorFill(0, 1, 0);
			} else {
				me["RudderUpperLeft"].setColorFill(0, 0, 0);
			}
			me["RudderUpperLeft"].setTranslation(math.clamp(Value.Fctl.rudderUpper, -30, 0) * 0.7, 0);
			me["RudderUpperLeft"].show();
		} else if (Value.Fctl.rudderUpper >= 0.8) {
			me["RudderUpperLeft"].hide();
			if (Value.Fctl.rudderUpper >= 29.7) {
				me["RudderUpperRight"].setColorFill(0, 1, 0);
			} else {
				me["RudderUpperRight"].setColorFill(0, 0, 0);
			}
			me["RudderUpperRight"].setTranslation(math.clamp(Value.Fctl.rudderUpper, 0, 30) * 0.7, 0);
			me["RudderUpperRight"].show();
		} else {
			me["RudderUpperLeft"].hide();
			me["RudderUpperRight"].hide();
		}
		
		if (Value.Fctl.rudderLower <= -0.8) {
			me["RudderLowerRight"].hide();
			if (Value.Fctl.rudderLower <= -29.7) {
				me["RudderLowerLeft"].setColorFill(0, 1, 0);
			} else {
				me["RudderLowerLeft"].setColorFill(0, 0, 0);
			}
			me["RudderLowerLeft"].setTranslation(math.clamp(Value.Fctl.rudderLower, -30, 0) * 0.7, 0);
			me["RudderLowerLeft"].show();
		} else if (Value.Fctl.rudderLower >= 0.8) {
			me["RudderLowerLeft"].hide();
			if (Value.Fctl.rudderLower >= 29.7) {
				me["RudderLowerRight"].setColorFill(0, 1, 0);
			} else {
				me["RudderLowerRight"].setColorFill(0, 0, 0);
			}
			me["RudderLowerRight"].setTranslation(math.clamp(Value.Fctl.rudderLower, 0, 30) * 0.7, 0);
			me["RudderLowerRight"].show();
		} else {
			me["RudderLowerLeft"].hide();
			me["RudderLowerRight"].hide();
		}
		
		# Flaps and Slats
		Value.Fctl.flapDeg = math.round(systems.FCS.flapsDeg.getValue());
		if (Value.Fctl.flapDeg >= 0.1) {
			me["Flap1"].setText(sprintf("%d", Value.Fctl.flapDeg));
			me["Flap2"].setText(sprintf("%d", Value.Fctl.flapDeg));
			me["Flap3"].setText(sprintf("%d", Value.Fctl.flapDeg));
			me["Flap4"].setText(sprintf("%d", Value.Fctl.flapDeg));
			me["FlapBox"].show();
		} else {
			me["Flap1"].setText("");
			me["Flap2"].setText("");
			me["Flap3"].setText("");
			me["Flap4"].setText("");
			me["FlapBox"].hide();
		}
		
		if (systems.FCS.slatsDeg.getValue() >= 0.1) {
			me["SlatExt"].show();
		} else {
			me["SlatExt"].hide();
		}
		
		# Tire Pressure
		me["NosePressL"].setText(sprintf("%d", math.round(systems.GEAR.TirePressurePsi.noseL.getValue())));
		me["NosePressR"].setText(sprintf("%d", math.round(systems.GEAR.TirePressurePsi.noseR.getValue())));
		
		me["LeftPressLAft"].setText(sprintf("%d", math.round(systems.GEAR.TirePressurePsi.leftLAft.getValue())));
		me["LeftPressLFwd"].setText(sprintf("%d", math.round(systems.GEAR.TirePressurePsi.leftLFwd.getValue())));
		me["LeftPressRAft"].setText(sprintf("%d", math.round(systems.GEAR.TirePressurePsi.leftRAft.getValue())));
		me["LeftPressRFwd"].setText(sprintf("%d", math.round(systems.GEAR.TirePressurePsi.leftRFwd.getValue())));
		
		me["CenterPressL"].setText(sprintf("%d", math.round(systems.GEAR.TirePressurePsi.centerL.getValue())));
		me["CenterPressR"].setText(sprintf("%d", math.round(systems.GEAR.TirePressurePsi.centerR.getValue())));
		
		me["RightPressLAft"].setText(sprintf("%d", math.round(systems.GEAR.TirePressurePsi.rightLAft.getValue())));
		me["RightPressLFwd"].setText(sprintf("%d", math.round(systems.GEAR.TirePressurePsi.rightLFwd.getValue())));
		me["RightPressRAft"].setText(sprintf("%d", math.round(systems.GEAR.TirePressurePsi.rightRAft.getValue())));
		me["RightPressRFwd"].setText(sprintf("%d", math.round(systems.GEAR.TirePressurePsi.rightRFwd.getValue())));
		
		# Gear Status Indications
		Value.Config.gearStatus[0] = systems.GEAR.status[0].getValue();
		Value.Config.gearStatus[1] = systems.GEAR.status[1].getValue();
		Value.Config.gearStatus[2] = systems.GEAR.status[2].getValue();
		Value.Config.gearStatus[3] = systems.GEAR.status[3].getValue();
		
		if (Value.Config.gearStatus[0] == 0 or Value.Misc.annunTestWow) {
			me["NoseStatus"].hide();
		} else {
			if (Value.Config.gearStatus[0] == 2) {
				me["NoseStatus"].setColor(0, 1, 0);
			} else {
				me["NoseStatus"].setColor(1, 0, 0);
			}
			me["NoseStatus"].show();
		}
		
		if (Value.Config.gearStatus[1] == 0 or Value.Misc.annunTestWow) {
			me["LeftStatus"].hide();
		} else {
			if (Value.Config.gearStatus[1] == 2) {
				me["LeftStatus"].setColor(0, 1, 0);
			} else {
				me["LeftStatus"].setColor(1, 0, 0);
			}
			me["LeftStatus"].show();
		}
		
		if (Value.Config.gearStatus[2] == 0 or Value.Misc.annunTestWow) {
			me["RightStatus"].hide();
		} else {
			if (Value.Config.gearStatus[2] == 2) {
				me["RightStatus"].setColor(0, 1, 0);
			} else {
				me["RightStatus"].setColor(1, 0, 0);
			}
			me["RightStatus"].show();
		}
		
		if (Value.Config.gearStatus[3] == 0 or Value.Misc.annunTestWow) {
			me["CenterStatus"].hide();
		} else {
			if (Value.Config.gearStatus[3] == 2) {
				me["CenterStatus"].setColor(0, 1, 0);
			} else {
				me["CenterStatus"].setColor(1, 0, 0);
			}
			me["CenterStatus"].show();
		}
	},
};
