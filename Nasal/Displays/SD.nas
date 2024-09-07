# McDonnell Douglas MD-11 SD
# Copyright (c) 2024 Josh Davidson (Octal450)

var display = nil;
var config = nil;
var conseq = nil;
var engDials = nil;
var engTapes = nil;
var misc = nil;
var status = nil;

var Value = {
	Apu: {
		n2: 0,
	},
	Config: {
		gearStatus: [0, 0, 0, 0],
	},
	Eng: {
		oilPsi: [0, 0, 0],
		oilPsiScale: 160,
		oilQty: [0, 0, 0],
		oilQtyCline: [0, 0, 0],
		oilQtyClineQt: [0, 0, 0],
		oilTemp: [0, 0, 0],
		type: "GE",
	},
	Fctl: {
		aileronDeflGreen: 0,
		aileronL: 0,
		aileronR: 0,
		elevatorL: 0,
		elevatorR: 0,
		flapDeg: 0,
		rudderLower: 0,
		rudderUpper: 0,
		spoilerL: 0,
		spoilerR: 0,
		stab: 0,
		stabComp: 0,
		stabRound: 0,
	},
	Misc: {
		annunTestWow: 0,
		cg: 0,
		fuel: 0,
		gw: 0,
		wow: 0,
	},
};

var canvasBase = {
	init: func(canvasGroup, file) {
		var font_mapper = func(family, weight) {
			return "DULarge.ttf";
		};
		
		canvas.parsesvg(canvasGroup, file, {"font-mapper": font_mapper});
		
		var svgKeys = me.getKeys();
		foreach(var key; svgKeys) {
			me[key] = canvasGroup.getElementById(key);
			
			var clip_el = canvasGroup.getElementById(key ~ "_clip");
			if (clip_el != nil) {
				clip_el.setVisible(0);
				var tranRect = clip_el.getTransformedBounds();
				
				var clip_rect = sprintf("rect(%d, %d, %d, %d)", 
					tranRect[1], # 0 ys
					tranRect[2], # 1 xe
					tranRect[3], # 2 ye
					tranRect[0] # 3 xs
				);
				
				# Coordinates are top, right, bottom, left (ys, xe, ye, xs) ref: l621 of simgear/canvas/CanvasElement.cxx
				me[key].set("clip", clip_rect);
				me[key].set("clip-frame", canvas.Element.PARENT);
			}
		}
		
		me.page = canvasGroup;
		
		return me;
	},
	getKeys: func() {
		return [];
	},
	setup: func() {
		# Hide the pages by default
		me.hidePages();
		
		engDials.setup();
		engTapes.setup();
	},
	hidePages: func() {
		config.page.hide();
		conseq.page.hide();
		engDials.page.hide();
		engTapes.page.hide();
		misc.page.hide();
		status.page.hide();
	},
	update: func() {
		if (systems.DUController.updateSd) {
			if (systems.DUController.sdPage == "CONFIG") {
				config.update();
			} else if (systems.DUController.sdPage == "CONSEQ") {
				conseq.update();
			} else if (systems.DUController.sdPage == "ENG") {
				if (systems.DUController.eadType == "PW-Tapes") { # Tape style EAD means tape style SD
					engTapes.update();
				} else if (systems.DUController.eadType == "GE-Tapes") { # Tape style EAD means tape style SD
					engTapes.update();
				} else {
					engDials.update();
				}
			} else if (systems.DUController.sdPage == "MISC") {
				misc.update();
			} else if (systems.DUController.sdPage == "STATUS") {
				status.update();
			}
		}
	},
};

var canvasConfig = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasConfig, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Alert_error", "AileronL_error", "AileronLDown", "AileronLUp", "AileronR_error", "AileronRDown", "AileronRUp", "CenterPressL", "CenterPressR", "CenterStatus", "ElevatorL_error", "ElevatorLDown", "ElevatorLUp", "ElevatorR_error", "ElevatorRDown",
		"ElevatorRUp", "ELFGroup", "ELFNeedle", "Flap1", "Flap1_error", "Flap2", "Flap2_error", "Flap3", "Flap3_error", "Flap4", "Flap4_error", "FlapBox", "GearTest", "LeftPressLAft", "LeftPressLFwd", "LeftPressRAft", "LeftPressRFwd", "LeftStatus", "NosePressL",
		"NosePressR", "NoseStatus", "RightPressLAft", "RightPressLFwd", "RightPressRAft", "RightPressRFwd", "RightStatus", "RudderLower_error", "RudderLowerLeft", "RudderLowerRight", "RudderUpper_error", "RudderUpperLeft", "RudderUpperRight", "SlatExt",
		"SpoilerL", "SpoilerL_error", "SpoilerR", "SpoilerR_error", "Stab", "Stab_error", "StabBox", "StabGreen", "StabNeedle", "StabUnit"];
	},
	setup: func() {
	},
	update: func() {
		Value.Misc.wow = pts.Fdm.JSBsim.Position.wow.getBoolValue();
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
		Value.Fctl.stab = pts.Fdm.JSBsim.Hydraulics.Stabilizer.finalDeg.getValue();
		Value.Fctl.stabComp = fms.Internal.takeoffStabDeg.getValue();
		Value.Fctl.stabRound = math.round(Value.Fctl.stab, 0.1);
		me["Stab"].setText(sprintf("%4.1f", abs(Value.Fctl.stabRound)));
		me["StabNeedle"].setTranslation(Value.Fctl.stab * -12.62, 0);
		
		if (fms.Internal.phase >= 2 or pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue() >= 80 or !Value.Misc.wow) {
			me["Stab"].setColor(1, 1, 1);
			me["StabBox"].hide();
			me["StabGreen"].hide();
			me["StabNeedle"].setColorFill(1, 1, 1);
		} else {
			if (Value.Fctl.stabComp > 0) {
				me["StabGreen"].setTranslation(Value.Fctl.stabComp * 12.62, 0);
				me["StabGreen"].show();
				
				if (abs(Value.Fctl.stabRound - (Value.Fctl.stabComp * -1)) <= 2) {
					me["Stab"].setColor(0, 1, 0);
					me["StabBox"].hide();
					me["StabNeedle"].setColorFill(0, 1, 0);
				} else {
					me["Stab"].setColor(0.9647, 0.8196, 0.0784);
					me["StabBox"].show();
					me["StabNeedle"].setColorFill(0.9647, 0.8196, 0.0784);
				}
			} else {
				me["Stab"].setColor(0.9647, 0.8196, 0.0784);
				me["StabBox"].show();
				me["StabGreen"].hide();
				me["StabNeedle"].setColorFill(0.9647, 0.8196, 0.0784);
			}
		}
		
		if (Value.Fctl.stabRound > 0) {
			me["StabUnit"].setText("AND");
		} else {
			me["StabUnit"].setText("ANU");
		}
		
		# Ailerons
		if (pts.Fdm.JSBsim.Hydraulics.DeflectedAileron.active.getBoolValue()) { # When ailerons are deflected, the green box occurs earlier
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
			me["AileronLUp"].setTranslation(0, math.clamp(Value.Fctl.aileronL, -20, 0) * 2.04915);
			me["AileronLUp"].show();
		} else if (Value.Fctl.aileronL >= 0.5) {
			me["AileronLUp"].hide();
			if (Value.Fctl.aileronL >= 19.8) {
				me["AileronLDown"].setColorFill(0, 1, 0);
			} else {
				me["AileronLDown"].setColorFill(0, 0, 0);
			}
			me["AileronLDown"].setTranslation(0, math.clamp(Value.Fctl.aileronL, 0, 20) * 2.04915);
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
			me["AileronRUp"].setTranslation(0, math.clamp(Value.Fctl.aileronR, -20, 0) * 2.04915);
			me["AileronRUp"].show();
		} else if (Value.Fctl.aileronR >= 0.5) {
			me["AileronRUp"].hide();
			if (Value.Fctl.aileronR >= 19.8) {
				me["AileronRDown"].setColorFill(0, 1, 0);
			} else {
				me["AileronRDown"].setColorFill(0, 0, 0);
			}
			me["AileronRDown"].setTranslation(0, math.clamp(Value.Fctl.aileronR, 0, 20) * 2.04915);
			me["AileronRDown"].show();
		} else {
			me["AileronRDown"].hide();
			me["AileronRUp"].hide();
		}
		
		# Spoilers
		Value.Fctl.spoilerL = pts.Fdm.JSBsim.Fcs.spoilerL.getValue();
		Value.Fctl.spoilerR = pts.Fdm.JSBsim.Fcs.spoilerR.getValue();
		
		if (Value.Fctl.spoilerL >= 1.5) {
			if (Value.Fctl.spoilerL >= 59.4) {
				me["SpoilerL"].setColorFill(0, 1, 0);
			} else {
				me["SpoilerL"].setColorFill(0, 0, 0);
			}
			me["SpoilerL"].setTranslation(0, Value.Fctl.spoilerL * -0.68305);
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
			me["SpoilerR"].setTranslation(0, Value.Fctl.spoilerR * -0.68305);
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
			me["ElevatorLUp"].setTranslation(0, math.clamp(Value.Fctl.elevatorL, -22, 0) * 1.18105);
			me["ElevatorLUp"].show();
		} else if (Value.Fctl.elevatorL >= 0.5) {
			me["ElevatorLUp"].hide();
			if (Value.Fctl.elevatorL >= 19.8) {
				me["ElevatorLDown"].setColorFill(0, 1, 0);
			} else {
				me["ElevatorLDown"].setColorFill(0, 0, 0);
			}
			me["ElevatorLDown"].setTranslation(0, math.clamp(Value.Fctl.elevatorL, 0, 20) * 1.18105);
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
			me["ElevatorRUp"].setTranslation(0, math.clamp(Value.Fctl.elevatorR, -22, 0) * 1.18105);
			me["ElevatorRUp"].show();
		} else if (Value.Fctl.elevatorR >= 0.5) {
			me["ElevatorRUp"].hide();
			if (Value.Fctl.elevatorR >= 19.8) {
				me["ElevatorRDown"].setColorFill(0, 1, 0);
			} else {
				me["ElevatorRDown"].setColorFill(0, 0, 0);
			}
			me["ElevatorRDown"].setTranslation(0, math.clamp(Value.Fctl.elevatorR, 0, 20) * 1.18105);
			me["ElevatorRDown"].show();
		} else {
			me["ElevatorRDown"].hide();
			me["ElevatorRUp"].hide();
		}
		
		# Rudders
		Value.Fctl.rudderUpper = pts.Fdm.JSBsim.Hydraulics.RudderUpper.finalDeg.getValue();
		Value.Fctl.rudderLower = pts.Fdm.JSBsim.Hydraulics.RudderLower.finalDeg.getValue();
		
		if (Value.Fctl.rudderUpper <= -0.8) {
			me["RudderUpperRight"].hide();
			if (Value.Fctl.rudderUpper <= -29.7) {
				me["RudderUpperLeft"].setColorFill(0, 1, 0);
			} else {
				me["RudderUpperLeft"].setColorFill(0, 0, 0);
			}
			me["RudderUpperLeft"].setTranslation(math.clamp(Value.Fctl.rudderUpper, -30, 0) * 0.69943, 0);
			me["RudderUpperLeft"].show();
		} else if (Value.Fctl.rudderUpper >= 0.8) {
			me["RudderUpperLeft"].hide();
			if (Value.Fctl.rudderUpper >= 29.7) {
				me["RudderUpperRight"].setColorFill(0, 1, 0);
			} else {
				me["RudderUpperRight"].setColorFill(0, 0, 0);
			}
			me["RudderUpperRight"].setTranslation(math.clamp(Value.Fctl.rudderUpper, 0, 30) * 0.69943, 0);
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
			me["RudderLowerLeft"].setTranslation(math.clamp(Value.Fctl.rudderLower, -30, 0) * 0.69943, 0);
			me["RudderLowerLeft"].show();
		} else if (Value.Fctl.rudderLower >= 0.8) {
			me["RudderLowerLeft"].hide();
			if (Value.Fctl.rudderLower >= 29.7) {
				me["RudderLowerRight"].setColorFill(0, 1, 0);
			} else {
				me["RudderLowerRight"].setColorFill(0, 0, 0);
			}
			me["RudderLowerRight"].setTranslation(math.clamp(Value.Fctl.rudderLower, 0, 30) * 0.69943, 0);
			me["RudderLowerRight"].show();
		} else {
			me["RudderLowerLeft"].hide();
			me["RudderLowerRight"].hide();
		}
		
		# Flaps and Slats
		if (pts.Fdm.JSBsim.Fcs.slatPosDeg.getValue() >= 0.1) {
			me["SlatExt"].show();
		} else {
			me["SlatExt"].hide();
		}
		
		Value.Fctl.flapDeg = math.round(pts.Fdm.JSBsim.Fcs.flapPosDeg.getValue());
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

var canvasConseq = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasConseq, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Error"];
	},
	update: func() {
		Value.Misc.wow = pts.Fdm.JSBsim.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Error"].show();
		} else {
			me["Error"].hide();
		}
	},
};

var canvasEngBase = {
	updateEngBase: func() {
		Value.Misc.wow = pts.Fdm.JSBsim.Position.wow.getBoolValue();
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
		if (fms.FlightData.gwLbs > 0) {
			Value.Misc.gw = math.round(fms.FlightData.gwLbs * 1000, 100);
			me["GW"].setText(right(sprintf("%d", Value.Misc.gw), 3));
			me["GW_thousands"].setText(sprintf("%d", math.floor(Value.Misc.gw / 1000)));
			me["GW"].show();
			me["GW_thousands"].show();
			me["GW_units"].show();
		} else {
			me["GW"].hide();
			me["GW_thousands"].hide();
			me["GW_units"].hide();
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
		Value.Fctl.stab = pts.Fdm.JSBsim.Hydraulics.Stabilizer.finalDeg.getValue();
		Value.Fctl.stabComp = fms.Internal.takeoffStabDeg.getValue();
		Value.Fctl.stabRound = math.round(Value.Fctl.stab, 0.1);
		me["Stab"].setText(sprintf("%4.1f", abs(Value.Fctl.stabRound)));
		me["StabNeedle"].setTranslation(Value.Fctl.stab * -12.62, 0);
		
		if (fms.Internal.phase >= 2 or pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue() >= 80 or !Value.Misc.wow) {
			me["Stab"].setColor(1, 1, 1);
			me["StabBox"].hide();
			me["StabGreen"].hide();
			me["StabNeedle"].setColorFill(1, 1, 1);
		} else {
			if (Value.Fctl.stabComp > 0) {
				me["StabGreen"].setTranslation(Value.Fctl.stabComp * 12.62, 0);
				me["StabGreen"].show();
				
				if (abs(Value.Fctl.stabRound - (Value.Fctl.stabComp * -1)) <= 2) {
					me["Stab"].setColor(0, 1, 0);
					me["StabBox"].hide();
					me["StabNeedle"].setColorFill(0, 1, 0);
				} else {
					me["Stab"].setColor(0.9647, 0.8196, 0.0784);
					me["StabBox"].show();
					me["StabNeedle"].setColorFill(0.9647, 0.8196, 0.0784);
				}
			} else {
				me["Stab"].setColor(0.9647, 0.8196, 0.0784);
				me["StabBox"].show();
				me["StabGreen"].hide();
				me["StabNeedle"].setColorFill(0.9647, 0.8196, 0.0784);
			}
		}
		
		if (Value.Fctl.stabRound > 0) {
			me["StabUnit"].setText("AND");
		} else {
			me["StabUnit"].setText("ANU");
		}
		
		# Nacelle Temp
		me["NacelleTemp1"].setText(sprintf("%d", math.round(pts.Engines.Engine.nacelleTemp[0].getValue())));
		me["NacelleTemp2"].setText(sprintf("%d", math.round(pts.Engines.Engine.nacelleTemp[1].getValue())));
		me["NacelleTemp3"].setText(sprintf("%d", math.round(pts.Engines.Engine.nacelleTemp[2].getValue())));
		
		# APU
		Value.Apu.n2 = systems.APU.n2.getValue();
		if (Value.Apu.n2 >= 1.8 or Value.Misc.annunTestWow) {
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

var canvasEngDials = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasEngDials, canvasEngBase, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Alert_error", "APU", "APU_EGT", "APU_EGT_error", "APU_N1", "APU_N1_error", "APU_N2", "APU_N2_error", "APU_Qty", "APU_Qty_error", "CabinAlt", "CabinAlt_error", "CabinRate", "CabinRate_error", "CabinRateDn", "CabinRateUp", "CG", "CG_error",
		"EmvComp1", "EmvComp1_error", "EmvComp2", "EmvComp2_error", "EmvComp3", "EmvComp3_error", "EmvTurb1", "EmvTurb1_error", "EmvTurb2", "EmvTurb2_error", "EmvTurb3", "EmvTurb3_error", "Fuel", "Fuel_error", "Fuel_thousands", "GE_group", "GW", "GW_error",
		"GW_thousands", "GW_units", "NacelleTemp1", "NacelleTemp1_error", "NacelleTemp2", "NacelleTemp2_error", "NacelleTemp3", "NacelleTemp3_error", "OilPsi1", "OilPsi1_error", "OilPsi1_needle", "OilPsi2", "OilPsi2_error", "OilPsi2_needle", "OilPsi3",
		"OilPsi3_error", "OilPsi3_needle", "OilQty1", "OilQty1_box", "OilQty1_cline", "OilQty1_error", "OilQty1_needle", "OilQty2", "OilQty2_box", "OilQty2_cline", "OilQty2_error", "OilQty2_needle", "OilQty3", "OilQty3_box", "OilQty3_cline", "OilQty3_error",
		"OilQty3_needle", "OilTemp1", "OilTemp1_box", "OilTemp1_error", "OilTemp1_needle", "OilTemp2", "OilTemp2_box", "OilTemp2_error", "OilTemp2_needle", "OilTemp3", "OilTemp3_box", "OilTemp3_error", "OilTemp3_needle", "PW_group", "Stab", "Stab_error",
		"StabBox", "StabGreen", "StabNeedle", "StabUnit"];
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
		
		# Unsimulated stuff, fix later
		me["CabinAlt"].setText("0");
		me["CabinRate"].setText("0");
		me["CabinRateDn"].hide();
		me["CabinRateUp"].hide();
	},
	update: func() {
		me.updateEngBase();
		
		# Oil Psi
		me["OilPsi1"].setText(sprintf("%d", pts.Engines.Engine.oilPsi[0].getValue()));
		me["OilPsi1_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilPsi[0].getValue() * D2R);
		
		me["OilPsi2"].setText(sprintf("%d", pts.Engines.Engine.oilPsi[1].getValue()));
		me["OilPsi2_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilPsi[1].getValue() * D2R);
		
		me["OilPsi3"].setText(sprintf("%d", pts.Engines.Engine.oilPsi[2].getValue()));
		me["OilPsi3_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilPsi[2].getValue() * D2R);
		
		# Oil Temp
		Value.Eng.oilTemp[0] = math.round(pts.Engines.Engine.oilTemp[0].getValue());
		Value.Eng.oilTemp[1] = math.round(pts.Engines.Engine.oilTemp[1].getValue());
		Value.Eng.oilTemp[2] = math.round(pts.Engines.Engine.oilTemp[2].getValue());
		
		me["OilTemp1"].setText(sprintf("%d", Value.Eng.oilTemp[0]));
		me["OilTemp1_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilTemp[0].getValue() * D2R);
		
		me["OilTemp2"].setText(sprintf("%d", Value.Eng.oilTemp[1]));
		me["OilTemp2_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilTemp[1].getValue() * D2R);
		
		me["OilTemp3"].setText(sprintf("%d", Value.Eng.oilTemp[2]));
		me["OilTemp3_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilTemp[2].getValue() * D2R);
		
		if (Value.Eng.type == "PW") {
			if (Value.Eng.oilTemp[0] <= 50) {
				me["OilTemp1"].setColor(0.9647, 0.8196, 0.0784);
				me["OilTemp1_box"].show();
				me["OilTemp1_needle"].setColorFill(0.9647, 0.8196, 0.0784);
			} else {
				me["OilTemp1"].setColor(1, 1, 1);
				me["OilTemp1_box"].hide();
				me["OilTemp1_needle"].setColorFill(1, 1, 1);
			}
			
			if (Value.Eng.oilTemp[1] <= 50) {
				me["OilTemp2"].setColor(0.9647, 0.8196, 0.0784);
				me["OilTemp2_box"].show();
				me["OilTemp2_needle"].setColorFill(0.9647, 0.8196, 0.0784);
			} else {
				me["OilTemp2"].setColor(1, 1, 1);
				me["OilTemp2_box"].hide();
				me["OilTemp2_needle"].setColorFill(1, 1, 1);
			}
			
			if (Value.Eng.oilTemp[2] <= 50) {
				me["OilTemp3"].setColor(0.9647, 0.8196, 0.0784);
				me["OilTemp3_box"].show();
				me["OilTemp3_needle"].setColorFill(0.9647, 0.8196, 0.0784);
			} else {
				me["OilTemp3"].setColor(1, 1, 1);
				me["OilTemp3_box"].hide();
				me["OilTemp3_needle"].setColorFill(1, 1, 1);
			}
		} else {
			me["OilTemp1_box"].hide();
			me["OilTemp2_box"].hide();
			me["OilTemp3_box"].hide();
		}
		
		# Oil Qty
		Value.Eng.oilQty[0] = pts.Engines.Engine.oilQty[0].getValue();
		Value.Eng.oilQty[1] = pts.Engines.Engine.oilQty[1].getValue();
		Value.Eng.oilQty[2] = pts.Engines.Engine.oilQty[2].getValue();
		
		me["OilQty1"].setText(sprintf("%d", math.round(Value.Eng.oilQty[0])));
		me["OilQty1_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilQty[0].getValue() * D2R);
		
		me["OilQty2"].setText(sprintf("%d", math.round(Value.Eng.oilQty[1])));
		me["OilQty2_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilQty[1].getValue() * D2R);
		
		me["OilQty3"].setText(sprintf("%d", math.round(Value.Eng.oilQty[2])));
		me["OilQty3_needle"].setRotation(pts.Instrumentation.Sd.Eng.oilQty[2].getValue() * D2R);
		
		if (Value.Eng.oilQty[0] <= 4) {
			me["OilQty1"].setColor(0.9647, 0.8196, 0.0784);
			me["OilQty1_box"].show();
			me["OilQty1_needle"].setColorFill(0.9647, 0.8196, 0.0784);
		} else {
			me["OilQty1"].setColor(1, 1, 1);
			me["OilQty1_box"].hide();
			me["OilQty1_needle"].setColorFill(1, 1, 1);
		}
		
		if (Value.Eng.oilQty[1] <= 4) {
			me["OilQty2"].setColor(0.9647, 0.8196, 0.0784);
			me["OilQty2_box"].show();
			me["OilQty2_needle"].setColorFill(0.9647, 0.8196, 0.0784);
		} else {
			me["OilQty2"].setColor(1, 1, 1);
			me["OilQty2_box"].hide();
			me["OilQty2_needle"].setColorFill(1, 1, 1);
		}
		
		if (Value.Eng.oilQty[2] <= 4) {
			me["OilQty3"].setColor(0.9647, 0.8196, 0.0784);
			me["OilQty3_box"].show();
			me["OilQty3_needle"].setColorFill(0.9647, 0.8196, 0.0784);
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

var canvasEngTapes = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasEngTapes, canvasEngBase, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Alert_error", "APU", "APU_EGT", "APU_EGT_error", "APU_N1", "APU_N1_error", "APU_N2", "APU_N2_error", "APU_Qty", "APU_Qty_error", "CabinAlt", "CabinAlt_error", "CabinRate", "CabinRate_error", "CabinRateDn", "CabinRateUp", "CG", "CG_error",
		"EmvComp1", "EmvComp1_error", "EmvComp2", "EmvComp2_error", "EmvComp3", "EmvComp3_error", "EmvTurb1", "EmvTurb1_error", "EmvTurb2", "EmvTurb2_error", "EmvTurb3", "EmvTurb3_error", "Fuel", "Fuel_error", "Fuel_thousands", "GE_group", "GW", "GW_error",
		"GW_thousands", "GW_units", "NacelleTemp1", "NacelleTemp1_error", "NacelleTemp2", "NacelleTemp2_error", "NacelleTemp3", "NacelleTemp3_error", "OilPsi_bars", "OilPsi1", "OilPsi1_bar", "OilPsi1_error", "OilPsi2", "OilPsi2_bar", "OilPsi2_error", "OilPsi3",
		"OilPsi3_bar", "OilPsi3_error", "OilQty_bars", "OilQty1", "OilQty1_bar", "OilQty1_box", "OilQty1_cline", "OilQty1_error", "OilQty2", "OilQty2_bar", "OilQty2_box", "OilQty2_cline", "OilQty2_error", "OilQty3", "OilQty3_bar", "OilQty3_box", "OilQty3_cline",
		"OilQty3_error", "OilTemp_bars", "OilTemp1", "OilTemp1_bar", "OilTemp1_box", "OilTemp1_error", "OilTemp2", "OilTemp2_bar", "OilTemp2_box", "OilTemp2_error", "OilTemp3", "OilTemp3_bar", "OilTemp3_box", "OilTemp3_error", "PW_group", "Stab", "Stab_error",
		"StabBox", "StabGreen", "StabNeedle", "StabUnit"];
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
		
		# Unsimulated stuff, fix later
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
		Value.Eng.oilPsi[0] = pts.Engines.Engine.oilPsi[0].getValue();
		Value.Eng.oilPsi[1] = pts.Engines.Engine.oilPsi[1].getValue();
		Value.Eng.oilPsi[2] = pts.Engines.Engine.oilPsi[2].getValue();
		
		me["OilPsi1"].setText(sprintf("%d", Value.Eng.oilPsi[0]));
		me["OilPsi1_bar"].setTranslation(0, Value.Eng.oilPsi[0] / Value.Eng.oilPsiScale * -251);
		
		me["OilPsi2"].setText(sprintf("%d", pts.Engines.Engine.oilPsi[1].getValue()));
		me["OilPsi2_bar"].setTranslation(0, Value.Eng.oilPsi[1] / Value.Eng.oilPsiScale * -251);
		
		me["OilPsi3"].setText(sprintf("%d", pts.Engines.Engine.oilPsi[2].getValue()));
		me["OilPsi3_bar"].setTranslation(0, Value.Eng.oilPsi[2] / Value.Eng.oilPsiScale * -251);
		
		# Oil Temp
		Value.Eng.oilTemp[0] = math.round(pts.Engines.Engine.oilTemp[0].getValue());
		Value.Eng.oilTemp[1] = math.round(pts.Engines.Engine.oilTemp[1].getValue());
		Value.Eng.oilTemp[2] = math.round(pts.Engines.Engine.oilTemp[2].getValue());
		
		me["OilTemp1"].setText(sprintf("%d", Value.Eng.oilTemp[0]));
		me["OilTemp1_bar"].setTranslation(0, Value.Eng.oilTemp[0] / 190 * -251);
		
		me["OilTemp2"].setText(sprintf("%d", Value.Eng.oilTemp[1]));
		me["OilTemp2_bar"].setTranslation(0, Value.Eng.oilTemp[1] / 190 * -251);
		
		me["OilTemp3"].setText(sprintf("%d", Value.Eng.oilTemp[2]));
		me["OilTemp3_bar"].setTranslation(0, Value.Eng.oilTemp[2] / 190 * -251);
		
		if (Value.Eng.type == "PW") {
			if (Value.Eng.oilTemp[0] <= 50) {
				me["OilTemp1"].setColor(0.9647, 0.8196, 0.0784);
				me["OilTemp1_bar"].setColorFill(0.9647, 0.8196, 0.0784);
				me["OilTemp1_box"].show();
			} else {
				me["OilTemp1"].setColor(1, 1, 1);
				me["OilTemp1_bar"].setColorFill(1, 1, 1);
				me["OilTemp1_box"].hide();
			}
			
			if (Value.Eng.oilTemp[1] <= 50) {
				me["OilTemp2"].setColor(0.9647, 0.8196, 0.0784);
				me["OilTemp2_bar"].setColorFill(0.9647, 0.8196, 0.0784);
				me["OilTemp2_box"].show();
			} else {
				me["OilTemp2"].setColor(1, 1, 1);
				me["OilTemp2_bar"].setColorFill(1, 1, 1);
				me["OilTemp2_box"].hide();
			}
			
			if (Value.Eng.oilTemp[2] <= 50) {
				me["OilTemp3"].setColor(0.9647, 0.8196, 0.0784);
				me["OilTemp3_bar"].setColorFill(0.9647, 0.8196, 0.0784);
				me["OilTemp3_box"].show();
			} else {
				me["OilTemp3"].setColor(1, 1, 1);
				me["OilTemp3_bar"].setColorFill(1, 1, 1);
				me["OilTemp3_box"].hide();
			}
		} else {
			me["OilTemp1_box"].hide();
			me["OilTemp2_box"].hide();
			me["OilTemp3_box"].hide();
		}
		
		# Oil Qty
		Value.Eng.oilQty[0] = pts.Engines.Engine.oilQty[0].getValue();
		Value.Eng.oilQty[1] = pts.Engines.Engine.oilQty[1].getValue();
		Value.Eng.oilQty[2] = pts.Engines.Engine.oilQty[2].getValue();
		
		me["OilQty1"].setText(sprintf("%d", math.round(Value.Eng.oilQty[0])));
		me["OilQty1_bar"].setTranslation(0, Value.Eng.oilQty[0] / 30 * -251);
		
		me["OilQty2"].setText(sprintf("%d", math.round(Value.Eng.oilQty[1])));
		me["OilQty2_bar"].setTranslation(0, Value.Eng.oilQty[1] / 30 * -251);
		
		me["OilQty3"].setText(sprintf("%d", math.round(Value.Eng.oilQty[2])));
		me["OilQty3_bar"].setTranslation(0, Value.Eng.oilQty[2] / 30 * -251);
		
		if (Value.Eng.oilQty[0] <= 4) {
			me["OilQty1"].setColor(0.9647, 0.8196, 0.0784);
			me["OilQty1_bar"].setColorFill(0.9647, 0.8196, 0.0784);
			me["OilQty1_box"].show();
		} else {
			me["OilQty1"].setColor(1, 1, 1);
			me["OilQty1_bar"].setColorFill(1, 1, 1);
			me["OilQty1_box"].hide();
		}
		
		if (Value.Eng.oilQty[1] <= 4) {
			me["OilQty2"].setColor(0.9647, 0.8196, 0.0784);
			me["OilQty2_bar"].setColorFill(0.9647, 0.8196, 0.0784);
			me["OilQty2_box"].show();
		} else {
			me["OilQty2"].setColor(1, 1, 1);
			me["OilQty2_bar"].setColorFill(1, 1, 1);
			me["OilQty2_box"].hide();
		}
		
		if (Value.Eng.oilQty[2] <= 4) {
			me["OilQty3"].setColor(0.9647, 0.8196, 0.0784);
			me["OilQty3_bar"].setColorFill(0.9647, 0.8196, 0.0784);
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

var canvasMisc = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasMisc, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Error"];
	},
	update: func() {
		Value.Misc.wow = pts.Fdm.JSBsim.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Error"].show();
		} else {
			me["Error"].hide();
		}
	},
};

var canvasStatus = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasStatus, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Error"];
	},
	update: func() {
		Value.Misc.wow = pts.Fdm.JSBsim.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Error"].show();
		} else {
			me["Error"].hide();
		}
	},
};

var init = func() {
	display = canvas.new({
		"name": "SD",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	
	display.addPlacement({"node": "sd.screen"});
	
	var configGroup = display.createGroup();
	var conseqGroup = display.createGroup();
	var engDialsGroup = display.createGroup();
	var engTapesGroup = display.createGroup();
	var miscGroup = display.createGroup();
	var statusGroup = display.createGroup();
	
	config = canvasConfig.new(configGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-CONFIG.svg");
	conseq = canvasConseq.new(conseqGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-CONSEQ.svg");
	engDials = canvasEngDials.new(engDialsGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-ENG-Dials.svg");
	engTapes = canvasEngTapes.new(engTapesGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-ENG-Tapes.svg");
	misc = canvasStatus.new(miscGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-MISC.svg");
	status = canvasStatus.new(statusGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-STATUS.svg");
	
	canvasBase.setup();
	update.start();
	
	if (pts.Systems.Acconfig.Options.Du.sdFps.getValue() != 20) {
		rateApply();
	}
}

var rateApply = func() {
	update.restart(1 / pts.Systems.Acconfig.Options.Du.sdFps.getValue());
}

var update = maketimer(0.05, func() { # 20FPS
	canvasBase.update();
});

var showSd = func() {
	var dlg = canvas.Window.new([512, 512], "dialog", nil, 0).set("resize", 1);
	dlg.setCanvas(display);
	dlg.set("title", "System Display");
}
