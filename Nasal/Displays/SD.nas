# McDonnell Douglas MD-11 SD
# Copyright (c) 2025 Josh Davidson (Octal450)

var display = nil;
var config = nil;
var conseq = nil;
var elec = nil;
var engDials = nil;
var engTapes = nil;
var hyd = nil;
var misc = nil;
var status = nil;

var Value = {
	Apu: {
		n2: 0,
	},
	Config: {
		gearStatus: [0, 0, 0, 0],
	},
	Elec: {
		Bus: {
			dcBatDirect: 0,
		},
		Relay: {
			idgAcGen1: 0,
			idgAcGen2: 0,
			idgAcGen3: 0,
		},
		Source: {
			adgHertz: 0,
			adgVolt: 0,
		},
	},
	Eng: {
		fadecPowered: [0, 0, 0],
		oilPsi: [0, 0, 0],
		oilPsiScale: 160,
		oilQty: [0, 0, 0],
		oilQtyCline: [0, 0, 0],
		oilQtyClineQt: [0, 0, 0],
		oilTemp: [0, 0, 0],
		state: [0, 0, 0],
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
	Hyd: {
		psi: [0, 0, 0],
		qty: [0, 0, 0],
		qtyLow: [0, 0, 0],
		rmp13Valve: 0,
		rmp23Valve: 0,
		Schematic: {
			auxLine: 0,
			aux1Line: 0,
			aux2Line: 0,
			rmp13Line: 0,
			rmp13Line2: 0,
			rmp13Line2Thru: 0,
			rmp23Line: 0,
			rmp23Line2: 0,
			sys1Line: 0,
			sys1Line2: 0,
			sys1PumpLLine: 0,
			sys1PumpRLine: 0,
			sys2Line: 0,
			sys2Line2: 0,
			sys2PumpLLine: 0,
			sys2PumpRLine: 0,
			sys3Line: 0,
			sys3Line2: 0,
			sys3Line3: 0,
			sys3Line4: 0,
			sys3PumpLLine: 0,
			sys3PumpRLine: 0,
		},
	},
	Misc: {
		annunTestWow: 0,
		cg: 0,
		fuel: 0,
		gw: 0,
		tat: 0,
		wow: 0,
	},
};

var canvasBase = {
	init: func(canvasGroup, file) {
		var font_mapper = func(family, weight) {
			return "MD11DU.ttf";
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
		
		elec.setup();
		engDials.setup();
		engTapes.setup();
	},
	hidePages: func() {
		config.page.hide();
		conseq.page.hide();
		elec.page.hide();
		engDials.page.hide();
		engTapes.page.hide();
		hyd.page.hide();
		misc.page.hide();
		status.page.hide();
	},
	update: func() {
		if (systems.DUController.updateSd) {
			if (systems.DUController.sdPage == "CONFIG") {
				config.update();
			} else if (systems.DUController.sdPage == "CONSEQ") {
				conseq.update();
			} else if (systems.DUController.sdPage == "ELEC") {
				elec.update();
			} else if (systems.DUController.sdPage == "ENG") {
				if (systems.DUController.eadType == "PW-Tapes") { # Tape style EAD means tape style SD
					engTapes.update();
				} else if (systems.DUController.eadType == "GE-Tapes") { # Tape style EAD means tape style SD
					engTapes.update();
				} else {
					engDials.update();
				}
			} else if (systems.DUController.sdPage == "HYD") {
				hyd.update();
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
		"SpoilerL", "SpoilerL_error", "SpoilerR", "SpoilerR_error", "Stab", "Stab_box", "Stab_error", "StabGreen", "StabNeedle", "StabUnit"];
	},
	setup: func() {
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
		Value.Misc.wow = pts.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Error"].show();
		} else {
			me["Error"].hide();
		}
	},
};

var canvasElec = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasElec, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Ac1_box", "Ac1_off", "Ac2_box", "Ac2_off", "Ac3_box", "Ac3_off", "AcGndSvc_box", "AcGndSvc_off", "AcTie1", "AcTie2", "AcTie3", "Adg", "Adg_hz", "Adg_hz_box", "Adg_hz_error", "Adg_volt", "Adg_volt_box", "Adg_volt_error", "Alert_error", "Apu_hz",
		"Apu_hz_box", "Apu_hz_error", "Apu_load", "Apu_load_box", "Apu_load_error", "Apu_volt", "Apu_volt_box", "Apu_volt_error", "ApuGroup", "ApuPwr1", "ApuPwr2", "ApuPwr3", "Bat", "Bat_amp", "Bat_amp_error", "Bat_volt", "Bat_volt_box", "Bat_volt_error",
		"Dc1_box", "Dc1_off", "Dc2_box", "Dc2_off", "Dc3_box", "Dc3_off", "DcGndSvc_box", "DcGndSvc_off", "DcTie1", "DcTie3", "Disc1", "Disc2", "Disc3", "ExtPwr", "ExtPwr_hz", "ExtPwr_hz_box", "ExtPwr_hz_error", "ExtPwr_line", "ExtPwr_volt", "ExtPwr_volt_box",
		"ExtPwr_volt_error", "ExtPwrGroup", "Gen1", "Gen1_hz", "Gen1_hz_box", "Gen1_hz_error", "Gen1_load", "Gen1_load_box", "Gen1_load_error", "Gen1_volt", "Gen1_volt_box", "Gen1_volt_error", "Gen2", "Gen2_hz", "Gen2_hz_box", "Gen2_hz_error", "Gen2_load",
		"Gen2_load_box", "Gen2_load_error", "Gen2_volt", "Gen2_volt_box", "Gen2_volt_error", "Gen3", "Gen3_hz", "Gen3_hz_box", "Gen3_hz_error", "Gen3_load", "Gen3_load_box", "Gen3_load_error", "Gen3_volt", "Gen3_volt_box", "Gen3_volt_error", "GenBus1", "GenBus2",
		"GenBus3", "GlyPwrGroup", "GlyPwr_hz", "GlyPwr_hz_error", "GlyPwr_volt", "GlyPwr_volt_error", "LEmerAc_box", "LEmerAc_off", "LEmerDc_box", "LEmerDc_off", "REmerAc_box", "REmerAc_off", "REmerDc_box", "REmerDc_off", "Tr1_fill", "Tr1_load", "Tr1_load_error",
		"Tr1_stroke", "Tr1_volt", "Tr1_volt_error", "Tr2A_fill", "Tr2A_load", "Tr2A_load_error", "Tr2A_stroke", "Tr2A_volt", "Tr2A_volt_error", "Tr2B_fill", "Tr2B_load", "Tr2B_load_error", "Tr2B_stroke", "Tr2B_volt", "Tr2B_volt_error", "Tr3_fill", "Tr3_load",
		"Tr3_load_error", "Tr3_stroke", "Tr3_volt", "Tr3_volt_error"];
	},
	setup: func() {
		me["Apu_load_box"].hide();
		me["Apu_hz_box"].hide();
		me["Apu_volt_box"].hide();
		me["ExtPwr_hz_box"].hide();
		me["ExtPwr_volt_box"].hide();
		me["Gen1_load_box"].hide();
		me["Gen2_load_box"].hide();
		me["Gen3_load_box"].hide();
	},
	update: func() {
		Value.Misc.wow = pts.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Adg_hz_error"].show();
			me["Adg_volt_error"].show();
			me["Alert_error"].show();
			me["Apu_hz_error"].show();
			me["Apu_load_error"].show();
			me["Apu_volt_error"].show();
			me["Bat_amp_error"].show();
			me["Bat_volt_error"].show();
			me["ExtPwr_hz_error"].show();
			me["ExtPwr_volt_error"].show();
			me["Gen1_hz_error"].show();
			me["Gen1_load_error"].show();
			me["Gen1_volt_error"].show();
			me["Gen2_hz_error"].show();
			me["Gen2_load_error"].show();
			me["Gen2_volt_error"].show();
			me["Gen3_hz_error"].show();
			me["Gen3_load_error"].show();
			me["Gen3_volt_error"].show();
			me["GlyPwr_hz_error"].show();
			me["GlyPwr_volt_error"].show();
			me["Tr1_load_error"].show();
			me["Tr2A_load_error"].show();
			me["Tr2B_load_error"].show();
			me["Tr3_load_error"].show();
			me["Tr1_volt_error"].show();
			me["Tr2A_volt_error"].show();
			me["Tr2B_volt_error"].show();
			me["Tr3_volt_error"].show();
		} else {
			me["Adg_hz_error"].hide();
			me["Adg_volt_error"].hide();
			me["Alert_error"].hide();
			me["Apu_hz_error"].hide();
			me["Apu_load_error"].hide();
			me["Apu_volt_error"].hide();
			me["Bat_amp_error"].hide();
			me["Bat_volt_error"].hide();
			me["ExtPwr_hz_error"].hide();
			me["ExtPwr_volt_error"].hide();
			me["Gen1_hz_error"].hide();
			me["Gen1_load_error"].hide();
			me["Gen1_volt_error"].hide();
			me["Gen2_hz_error"].hide();
			me["Gen2_load_error"].hide();
			me["Gen2_volt_error"].hide();
			me["Gen3_hz_error"].hide();
			me["Gen3_load_error"].hide();
			me["Gen3_volt_error"].hide();
			me["GlyPwr_hz_error"].hide();
			me["GlyPwr_volt_error"].hide();
			me["Tr1_load_error"].hide();
			me["Tr2A_load_error"].hide();
			me["Tr2B_load_error"].hide();
			me["Tr3_load_error"].hide();
			me["Tr1_volt_error"].hide();
			me["Tr2A_volt_error"].hide();
			me["Tr2B_volt_error"].hide();
			me["Tr3_volt_error"].hide();
		}
		
		# Battery
		Value.Elec.Bus.dcBatDirect = math.round(systems.ELECTRICAL.Bus.dcBatDirect.getValue());
		me["Bat_volt"].setText(sprintf("%d", Value.Elec.Bus.dcBatDirect));
		
		if (Value.Elec.Bus.dcBatDirect < 22) {
			me["Bat"].setColor(0.9412, 0.7255, 0);
			me["Bat_volt"].setColor(0.9412, 0.7255, 0);
			me["Bat_volt_box"].show();
		} else {
			if (systems.ELECTRICAL.Rcb.dcBatLEmerDc.getBoolValue() or systems.ELECTRICAL.Relay.siLEmerAc.getBoolValue()) {
				me["Bat"].setColor(0, 1, 0);
				
				me["Bat_amp"].setText(sprintf("%d", math.round(math.max(systems.ELECTRICAL.Source.Bat1.amp.getValue(), systems.ELECTRICAL.Source.Bat2.amp.getValue()))));
				me["Bat_amp"].show();
			} else {
				me["Bat"].setColor(1, 1, 1);
				me["Bat_amp"].hide();
			}
			
			me["Bat_volt"].setColor(1, 1, 1);
			me["Bat_volt_box"].hide();
		}
		
		# Busses
		if (systems.ELECTRICAL.Lights.lEmerDc.getBoolValue()) {
			me["LEmerDc_box"].setColor(0.9412, 0.7255, 0);
			me["LEmerDc_off"].show();
		} else {
			me["LEmerDc_box"].setColor(0, 1, 0);
			me["LEmerDc_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.dc1.getBoolValue()) {
			me["Dc1_box"].setColor(0.9412, 0.7255, 0);
			me["Dc1_off"].show();
		} else {
			me["Dc1_box"].setColor(0, 1, 0);
			me["Dc1_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.dc2.getBoolValue()) {
			me["Dc2_box"].setColor(0.9412, 0.7255, 0);
			me["Dc2_off"].show();
		} else {
			me["Dc2_box"].setColor(0, 1, 0);
			me["Dc2_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.dcGndSvc.getBoolValue()) {
			me["DcGndSvc_box"].setColor(0.9412, 0.7255, 0);
			me["DcGndSvc_off"].show();
		} else {
			me["DcGndSvc_box"].setColor(0, 1, 0);
			me["DcGndSvc_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.dc3.getBoolValue()) {
			me["Dc3_box"].setColor(0.9412, 0.7255, 0);
			me["Dc3_off"].show();
		} else {
			me["Dc3_box"].setColor(0, 1, 0);
			me["Dc3_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.rEmerDc.getBoolValue()) {
			me["REmerDc_box"].setColor(0.9412, 0.7255, 0);
			me["REmerDc_off"].show();
		} else {
			me["REmerDc_box"].setColor(0, 1, 0);
			me["REmerDc_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.lEmerAc.getBoolValue()) {
			me["LEmerAc_box"].setColor(0.9412, 0.7255, 0);
			me["LEmerAc_off"].show();
		} else {
			me["LEmerAc_box"].setColor(0, 1, 0);
			me["LEmerAc_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.ac1.getBoolValue()) {
			me["Ac1_box"].setColor(0.9412, 0.7255, 0);
			me["Ac1_off"].show();
		} else {
			me["Ac1_box"].setColor(0, 1, 0);
			me["Ac1_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.ac2.getBoolValue()) {
			me["Ac2_box"].setColor(0.9412, 0.7255, 0);
			me["Ac2_off"].show();
		} else {
			me["Ac2_box"].setColor(0, 1, 0);
			me["Ac2_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.acGndSvc.getBoolValue()) {
			me["AcGndSvc_box"].setColor(0.9412, 0.7255, 0);
			me["AcGndSvc_off"].show();
		} else {
			me["AcGndSvc_box"].setColor(0, 1, 0);
			me["AcGndSvc_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.ac3.getBoolValue()) {
			me["Ac3_box"].setColor(0.9412, 0.7255, 0);
			me["Ac3_off"].show();
		} else {
			me["Ac3_box"].setColor(0, 1, 0);
			me["Ac3_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.rEmerAc.getBoolValue()) {
			me["REmerAc_box"].setColor(0.9412, 0.7255, 0);
			me["REmerAc_off"].show();
		} else {
			me["REmerAc_box"].setColor(0, 1, 0);
			me["REmerAc_off"].hide();
		}
		
		# TR's
		me["Tr1_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Tr1.volt.getValue())));
		me["Tr2A_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Tr2a.volt.getValue())));
		me["Tr2B_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Tr2b.volt.getValue())));
		me["Tr3_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Tr3.volt.getValue())));
		
		if (systems.ELECTRICAL.Failures.tr1.getBoolValue()) {
			me["Tr1_fill"].setColor(0.9412, 0.7255, 0);
			me["Tr1_fill"].setColorFill(0.9412, 0.7255, 0);
			me["Tr1_stroke"].setColor(0.9412, 0.7255, 0);
		} else {
			me["Tr1_fill"].setColor(1, 1, 1);
			me["Tr1_fill"].setColorFill(1, 1, 1);
			me["Tr1_stroke"].setColor(1, 1, 1);
		}
		
		if (systems.ELECTRICAL.Failures.tr2a.getBoolValue()) {
			me["Tr2A_fill"].setColor(0.9412, 0.7255, 0);
			me["Tr2A_fill"].setColorFill(0.9412, 0.7255, 0);
			me["Tr2A_stroke"].setColor(0.9412, 0.7255, 0);
		} else {
			me["Tr2A_fill"].setColor(1, 1, 1);
			me["Tr2A_fill"].setColorFill(1, 1, 1);
			me["Tr2A_stroke"].setColor(1, 1, 1);
		}
		
		if (systems.ELECTRICAL.Failures.tr2b.getBoolValue()) {
			me["Tr2B_fill"].setColor(0.9412, 0.7255, 0);
			me["Tr2B_fill"].setColorFill(0.9412, 0.7255, 0);
			me["Tr2B_stroke"].setColor(0.9412, 0.7255, 0);
		} else {
			me["Tr2B_fill"].setColor(1, 1, 1);
			me["Tr2B_fill"].setColorFill(1, 1, 1);
			me["Tr2B_stroke"].setColor(1, 1, 1);
		}
		
		if (systems.ELECTRICAL.Failures.tr3.getBoolValue()) {
			me["Tr3_fill"].setColor(0.9412, 0.7255, 0);
			me["Tr3_fill"].setColorFill(0.9412, 0.7255, 0);
			me["Tr3_stroke"].setColor(0.9412, 0.7255, 0);
		} else {
			me["Tr3_fill"].setColor(1, 1, 1);
			me["Tr3_fill"].setColorFill(1, 1, 1);
			me["Tr3_stroke"].setColor(1, 1, 1);
		}
		
		# Relays/RCBs
		Value.Elec.Relay.idgAcGen1 = systems.ELECTRICAL.Relay.idgAcGen1.getBoolValue();
		Value.Elec.Relay.idgAcGen2 = systems.ELECTRICAL.Relay.idgAcGen2.getBoolValue();
		Value.Elec.Relay.idgAcGen3 = systems.ELECTRICAL.Relay.idgAcGen3.getBoolValue();
		
		if (systems.ELECTRICAL.Rcb.dcTieDc1.getBoolValue()) {
			me["DcTie1"].setColor(0, 1, 0);
			me["DcTie1"].setTranslation(0, 10);
		} else {
			me["DcTie1"].setColor(1, 1, 1);
			me["DcTie1"].setTranslation(0, 0);
		}
		
		if (systems.ELECTRICAL.Rcb.dcTieDc3.getBoolValue()) {
			me["DcTie3"].setColor(0, 1, 0);
			me["DcTie3"].setTranslation(0, 10);
		} else {
			me["DcTie3"].setColor(1, 1, 1);
			me["DcTie3"].setTranslation(0, 0);
		}
		
		if (systems.ELECTRICAL.Relay.acTieAcGen1.getBoolValue()) {
			me["AcTie1"].setColor(0, 1, 0);
			me["AcTie1"].setTranslation(10, 0);
		} else {
			me["AcTie1"].setColor(1, 1, 1);
			me["AcTie1"].setTranslation(0, 0);
		}
		
		if (systems.ELECTRICAL.Relay.acTieAcGen2.getBoolValue()) {
			me["AcTie2"].setColor(0, 1, 0);
			me["AcTie2"].setTranslation(10, 0);
		} else {
			me["AcTie2"].setColor(1, 1, 1);
			me["AcTie2"].setTranslation(0, 0);
		}
		
		if (systems.ELECTRICAL.Relay.acTieAcGen3.getBoolValue()) {
			me["AcTie3"].setColor(0, 1, 0);
			me["AcTie3"].setTranslation(10, 0);
		} else {
			me["AcTie3"].setColor(1, 1, 1);
			me["AcTie3"].setTranslation(0, 0);
		}
		
		if (Value.Elec.Relay.idgAcGen1) {
			me["GenBus1"].setColor(0, 1, 0);
			me["GenBus1"].setTranslation(10, 0);
		} else {
			me["GenBus1"].setColor(1, 1, 1);
			me["GenBus1"].setTranslation(0, 0);
		}
		
		if (Value.Elec.Relay.idgAcGen2) {
			me["GenBus2"].setColor(0, 1, 0);
			me["GenBus2"].setTranslation(10, 0);
		} else {
			me["GenBus2"].setColor(1, 1, 1);
			me["GenBus2"].setTranslation(0, 0);
		}
		
		if (Value.Elec.Relay.idgAcGen3) {
			me["GenBus3"].setColor(0, 1, 0);
			me["GenBus3"].setTranslation(10, 0);
		} else {
			me["GenBus3"].setColor(1, 1, 1);
			me["GenBus3"].setTranslation(0, 0);
		}
		
		# IDG's
		me["Gen1_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Idg1.outputVolt.getValue())));
		me["Gen1_hz"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Idg1.outputHertz.getValue())));
		
		me["Gen2_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Idg2.outputVolt.getValue())));
		me["Gen2_hz"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Idg2.outputHertz.getValue())));
		
		me["Gen3_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Idg3.outputVolt.getValue())));
		me["Gen3_hz"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Idg3.outputHertz.getValue())));
		
		if (systems.ELECTRICAL.Failures.gen1.getBoolValue()) {
			me["Disc1"].setText("FAULT");
			me["Disc1"].show();
			
			me["Gen1"].setColor(0.9412, 0.7255, 0);
			me["Gen1_hz"].setColor(0.9412, 0.7255, 0);
			me["Gen1_hz_box"].show();
			me["Gen1_volt"].setColor(0.9412, 0.7255, 0);
			me["Gen1_volt_box"].show();
		} else {
			if (!systems.ELECTRICAL.Controls.genDrive1.getBoolValue()) {
				me["Disc1"].setText("DISC");
				me["Disc1"].show();
			} else {
				me["Disc1"].hide();
			}
			
			if (Value.Elec.Relay.idgAcGen1) {
				me["Gen1"].setColor(0, 1, 0);
			} else {
				me["Gen1"].setColor(1, 1, 1);
			}
			
			me["Gen1_hz"].setColor(1, 1, 1);
			me["Gen1_hz_box"].hide();
			me["Gen1_volt"].setColor(1, 1, 1);
			me["Gen1_volt_box"].hide();
		}
		
		if (systems.ELECTRICAL.Failures.gen2.getBoolValue()) {
			me["Disc2"].setText("FAULT");
			me["Disc2"].show();
			
			me["Gen2"].setColor(0.9412, 0.7255, 0);
			me["Gen2_hz"].setColor(0.9412, 0.7255, 0);
			me["Gen2_hz_box"].show();
			me["Gen2_volt"].setColor(0.9412, 0.7255, 0);
			me["Gen2_volt_box"].show();
		} else {
			if (!systems.ELECTRICAL.Controls.genDrive2.getBoolValue()) {
				me["Disc2"].setText("DISC");
				me["Disc2"].show();
			} else {
				me["Disc2"].hide();
			}
			
			if (Value.Elec.Relay.idgAcGen2) {
				me["Gen2"].setColor(0, 1, 0);
			} else {
				me["Gen2"].setColor(1, 1, 1);
			}
			
			me["Gen2_hz"].setColor(1, 1, 1);
			me["Gen2_hz_box"].hide();
			me["Gen2_volt"].setColor(1, 1, 1);
			me["Gen2_volt_box"].hide();
		}
		
		if (systems.ELECTRICAL.Failures.gen3.getBoolValue()) {
			me["Disc3"].setText("FAULT");
			me["Disc3"].show();
			
			me["Gen3"].setColor(0.9412, 0.7255, 0);
			me["Gen3_hz"].setColor(0.9412, 0.7255, 0);
			me["Gen3_hz_box"].show();
			me["Gen3_volt"].setColor(0.9412, 0.7255, 0);
			me["Gen3_volt_box"].show();
		} else {
			if (!systems.ELECTRICAL.Controls.genDrive3.getBoolValue()) {
				me["Disc3"].setText("DISC");
				me["Disc3"].show();
			} else {
				me["Disc3"].hide();
			}
			
			if (Value.Elec.Relay.idgAcGen3) {
				me["Gen3"].setColor(0, 1, 0);
			} else {
				me["Gen3"].setColor(1, 1, 1);
			}
			
			me["Gen3_hz"].setColor(1, 1, 1);
			me["Gen3_hz_box"].hide();
			me["Gen3_volt"].setColor(1, 1, 1);
			me["Gen3_volt_box"].hide();
		}
		
		# APU
		if (systems.APU.n2.getValue() >= 95) {
			me["Apu_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Apu.outputVolt.getValue())));
			me["Apu_hz"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Apu.outputHertz.getValue())));
			
			if (systems.ELECTRICAL.Relay.apuAcGen1.getBoolValue()) {
				me["ApuPwr1"].setColor(0, 1, 0);
			} else {
				me["ApuPwr1"].setColor(1, 1, 1);
			}
			
			if (systems.ELECTRICAL.Relay.apuAcGen2.getBoolValue()) {
				me["ApuPwr2"].setColor(0, 1, 0);
			} else {
				me["ApuPwr2"].setColor(1, 1, 1);
			}
			
			if (systems.ELECTRICAL.Relay.apuAcGen3.getBoolValue()) {
				me["ApuPwr3"].setColor(0, 1, 0);
			} else {
				me["ApuPwr3"].setColor(1, 1, 1);
			}
			
			me["ApuGroup"].show();
		} else {
			me["ApuGroup"].hide();
		}
		
		# EXT PWR and EXT GLY PWR
		if (systems.ELECTRICAL.Controls.groundCart.getBoolValue()) {
			me["ExtPwr_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Ext.volt.getValue())));
			me["ExtPwr_hz"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Ext.hertz.getValue())));
			me["GlyPwr_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Ext.voltGalley.getValue())));
			me["GlyPwr_hz"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Ext.hertzGalley.getValue())));
			
			if (systems.ELECTRICAL.Relay.extAcTie.getBoolValue()) {
				me["ExtPwr"].setColor(0, 1, 0);
			} else {
				me["ExtPwr"].setColor(1, 1, 1);
			}
			
			me["ExtPwrGroup"].show();
			me["GlyPwrGroup"].show();
		} else {
			me["ExtPwrGroup"].hide();
			me["GlyPwrGroup"].hide();
		}
		
		# ADG
		if (pts.Controls.Switches.adgHandle.getValue() == 1) {
			me["Adg"].setColor(0, 1, 0);
			
			Value.Elec.Source.adgHertz = math.round(systems.ELECTRICAL.Source.Adg.hertz.getValue());
			Value.Elec.Source.adgVolt = math.round(systems.ELECTRICAL.Source.Adg.volt.getValue());
			
			me["Adg_volt"].setText(sprintf("%d", Value.Elec.Source.adgVolt));
			me["Adg_volt"].show();
			me["Adg_hz"].setText(sprintf("%d", Value.Elec.Source.adgHertz));
			me["Adg_hz"].show();
			
			if (Value.Elec.Source.adgVolt < 112 or Value.Elec.Source.adgVolt > 118) {
				me["Adg_volt"].setColor(0.9412, 0.7255, 0);
				me["Adg_volt_box"].show();
			} else {
				me["Adg_volt"].setColor(1, 1, 1);
				me["Adg_volt_box"].hide();
			}
			if (Value.Elec.Source.adgHertz < 396 or Value.Elec.Source.adgHertz > 404) {
				me["Adg_hz"].setColor(0.9412, 0.7255, 0);
				me["Adg_hz_box"].show();
			} else {
				me["Adg_hz"].setColor(1, 1, 1);
				me["Adg_hz_box"].hide();
			}
		} else {
			me["Adg"].setColor(1, 1, 1);
			me["Adg_hz"].hide();
			me["Adg_hz_box"].hide();
			me["Adg_volt"].hide();
			me["Adg_volt_box"].hide();
		}
	},
};

var canvasEngBase = {
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
		"OilQty3_needle", "OilTemp1", "OilTemp1_box", "OilTemp1_error", "OilTemp1_needle", "OilTemp2", "OilTemp2_box", "OilTemp2_error", "OilTemp2_needle", "OilTemp3", "OilTemp3_box", "OilTemp3_error", "OilTemp3_needle", "PW_group", "Stab", "Stab_box",
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
		
		# Unsimulated stuff, fix later
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

var canvasHyd = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasHyd, canvasBase]};
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
		Value.Misc.tat = pts.Fdm.JSBSim.Propulsion.tatC.getValue();
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
		me["Sys1_temp"].setText(sprintf("%d", math.round(Value.Misc.tat)) ~ "gC");
		me["Sys2_temp"].setText(sprintf("%d", math.round(Value.Misc.tat)) ~ "gC");
		me["Sys3_temp"].setText(sprintf("%d", math.round(Value.Misc.tat)) ~ "gC");
		
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
		
		me["Sys1_qty_bar"].setTranslation(0, Value.Hyd.qty[0] * -6.3333);
		if (Value.Eng.state[0] == 3) {
			me["Sys1_qty_line"].setTranslation(0, math.round(systems.HYDRAULICS.Qty.sys1Preflight.getValue(), 0.1) * -6.3333);
			me["Sys1_qty_line"].show();
		} else {
			me["Sys1_qty_line"].hide();
		}
		
		me["Sys2_qty_bar"].setTranslation(0, Value.Hyd.qty[1] * -6.3333);
		if (Value.Eng.state[1] == 3) {
			me["Sys2_qty_line"].setTranslation(0, math.round(systems.HYDRAULICS.Qty.sys2Preflight.getValue(), 0.1) * -6.3333);
			me["Sys2_qty_line"].show();
		} else {
			me["Sys2_qty_line"].hide();
		}
		
		me["Sys3_qty_bar"].setTranslation(0, Value.Hyd.qty[2] * -6.3333);
		if (Value.Eng.state[2] == 3) {
			me["Sys3_qty_line"].setTranslation(0, math.round(systems.HYDRAULICS.Qty.sys3Preflight.getValue(), 0.1) * -6.3333);
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
		
		if (systems.HYDRAULICS.PumpCmd.rPump1.getValue() == 1) {
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
		} else if (systems.HYDRAULICS.PumpCmd.rPump1.getValue() == -1) {
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
		
		if (systems.HYDRAULICS.PumpCmd.rPump2.getValue() == 1) {
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
		} else if (systems.HYDRAULICS.PumpCmd.rPump2.getValue() == -1) {
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
		
		if (systems.HYDRAULICS.PumpCmd.rPump3.getValue() == 1) {
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
		} else if (systems.HYDRAULICS.PumpCmd.rPump3.getValue() == -1) {
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
		Value.Misc.wow = pts.Position.wow.getBoolValue();
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
		Value.Misc.wow = pts.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Error"].show();
		} else {
			me["Error"].hide();
		}
	},
};

var setup = func() {
	display = canvas.new({
		"name": "SD",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	
	display.addPlacement({"node": "sd.screen"});
	
	var configGroup = display.createGroup();
	var conseqGroup = display.createGroup();
	var elecGroup = display.createGroup();
	var engDialsGroup = display.createGroup();
	var engTapesGroup = display.createGroup();
	var hydGroup = display.createGroup();
	var miscGroup = display.createGroup();
	var statusGroup = display.createGroup();
	
	config = canvasConfig.new(configGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-CONFIG.svg");
	conseq = canvasConseq.new(conseqGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-CONSEQ.svg");
	elec = canvasElec.new(elecGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-ELEC.svg");
	engDials = canvasEngDials.new(engDialsGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-ENG-Dials.svg");
	engTapes = canvasEngTapes.new(engTapesGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-ENG-Tapes.svg");
	hyd = canvasHyd.new(hydGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-HYD.svg");
	misc = canvasMisc.new(miscGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-MISC.svg");
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
