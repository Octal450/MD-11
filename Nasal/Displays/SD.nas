# McDonnell Douglas MD-11 SD
# Copyright (c) 2024 Josh Davidson (Octal450)

var display = nil;
var config = nil;
var conseq = nil;
var eng = nil;
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
		oilQty: [0, 0, 0],
		oilQtyCline: [0, 0, 0],
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
		stabText: 0,
	},
	Misc: {
		fuel: 0,
		gw: 0,
	},
};

var canvasBase = {
	init: func(canvasGroup, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
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
		
		config.setup();
		eng.setup();
	},
	hidePages: func() {
		config.page.hide();
		conseq.page.hide();
		eng.page.hide();
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
				eng.update();
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
		return ["AileronLDown", "AileronLUp", "AileronRDown", "AileronRUp", "CenterPressL", "CenterPressR", "CenterStatus", "ElevatorLDown", "ElevatorLUp", "ElevatorRDown", "ElevatorRUp", "Flap1", "Flap2", "Flap3", "Flap4", "FlapBox", "LeftPressLAft",
		"LeftPressLFwd", "LeftPressRAft", "LeftPressRFwd", "LeftStatus", "NosePressL", "NosePressR", "NoseStatus", "RightPressLAft", "RightPressLFwd", "RightPressRAft", "RightPressRFwd", "RightStatus", "RudderLowerLeft", "RudderLowerRight", "RudderUpperLeft",
		"RudderUpperRight", "SlatExt", "SpoilerL", "SpoilerR", "Stab", "StabBox", "StabNeedle", "StabUnit"];
	},
	setup: func() {
		# Unsimulated stuff, fix later
		me["StabBox"].hide();
	},
	update: func() {
		# Stab
		Value.Fctl.stab = pts.Fdm.JSBsim.Hydraulics.Stabilizer.finalDeg.getValue();
		Value.Fctl.stabText = math.round(abs(Value.Fctl.stab), 0.1);
		
		me["Stab"].setText(sprintf("%2.1f", Value.Fctl.stabText));
		me["StabNeedle"].setTranslation(Value.Fctl.stab * -12.6451613, 0);
		
		if (Value.Fctl.stab > 0 and Value.Fctl.stabText > 0) {
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
				me["AileronLUp"].setColorFill(0,1,0);
			} else {
				me["AileronLUp"].setColorFill(0,0,0);
			}
			me["AileronLUp"].setTranslation(0, math.clamp(Value.Fctl.aileronL, -20, 0) * 2.04915);
			me["AileronLUp"].show();
		} else if (Value.Fctl.aileronL >= 0.5) {
			me["AileronLUp"].hide();
			if (Value.Fctl.aileronL >= 19.8) {
				me["AileronLDown"].setColorFill(0,1,0);
			} else {
				me["AileronLDown"].setColorFill(0,0,0);
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
				me["AileronRUp"].setColorFill(0,1,0);
			} else {
				me["AileronRUp"].setColorFill(0,0,0);
			}
			me["AileronRUp"].setTranslation(0, math.clamp(Value.Fctl.aileronR, -20, 0) * 2.04915);
			me["AileronRUp"].show();
		} else if (Value.Fctl.aileronR >= 0.5) {
			me["AileronRUp"].hide();
			if (Value.Fctl.aileronR >= 19.8) {
				me["AileronRDown"].setColorFill(0,1,0);
			} else {
				me["AileronRDown"].setColorFill(0,0,0);
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
				me["SpoilerL"].setColorFill(0,1,0);
			} else {
				me["SpoilerL"].setColorFill(0,0,0);
			}
			me["SpoilerL"].setTranslation(0, Value.Fctl.spoilerL * -0.68305);
			me["SpoilerL"].show();
		} else {
			me["SpoilerL"].hide();
		}
		
		if (Value.Fctl.spoilerR >= 1.5) {
			if (Value.Fctl.spoilerR >= 59.4) {
				me["SpoilerR"].setColorFill(0,1,0);
			} else {
				me["SpoilerR"].setColorFill(0,0,0);
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
			if (Value.Fctl.elevatorL <= -19.9) {
				me["ElevatorLUp"].setColorFill(0,1,0);
			} else {
				me["ElevatorLUp"].setColorFill(0,0,0);
			}
			me["ElevatorLUp"].setTranslation(0, math.clamp(Value.Fctl.elevatorL, -20.1, 0) * 1.29269);
			me["ElevatorLUp"].show();
		} else if (Value.Fctl.elevatorL >= 0.5) {
			me["ElevatorLUp"].hide();
			if (Value.Fctl.elevatorL >= 17) {
				me["ElevatorLDown"].setColorFill(0,1,0);
			} else {
				me["ElevatorLDown"].setColorFill(0,0,0);
			}
			me["ElevatorLDown"].setTranslation(0, math.clamp(Value.Fctl.elevatorL, 0, 17.2) * 1.29269);
			me["ElevatorLDown"].show();
		} else {
			me["ElevatorLDown"].hide();
			me["ElevatorLUp"].hide();
		}
		
		if (Value.Fctl.elevatorR <= -0.5) {
			me["ElevatorRDown"].hide();
			if (Value.Fctl.elevatorR <= -19.9) {
				me["ElevatorRUp"].setColorFill(0,1,0);
			} else {
				me["ElevatorRUp"].setColorFill(0,0,0);
			}
			me["ElevatorRUp"].setTranslation(0, math.clamp(Value.Fctl.elevatorR, -20.1, 0) * 1.29269);
			me["ElevatorRUp"].show();
		} else if (Value.Fctl.elevatorR >= 0.5) {
			me["ElevatorRUp"].hide();
			if (Value.Fctl.elevatorR >= 17) {
				me["ElevatorRDown"].setColorFill(0,1,0);
			} else {
				me["ElevatorRDown"].setColorFill(0,0,0);
			}
			me["ElevatorRDown"].setTranslation(0, math.clamp(Value.Fctl.elevatorR, 0, 17.2) * 1.29269);
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
				me["RudderUpperLeft"].setColorFill(0,1,0);
			} else {
				me["RudderUpperLeft"].setColorFill(0,0,0);
			}
			me["RudderUpperLeft"].setTranslation(math.clamp(Value.Fctl.rudderUpper, -30, 0) * 0.69943, 0);
			me["RudderUpperLeft"].show();
		} else if (Value.Fctl.rudderUpper >= 0.8) {
			me["RudderUpperLeft"].hide();
			if (Value.Fctl.rudderUpper >= 29.7) {
				me["RudderUpperRight"].setColorFill(0,1,0);
			} else {
				me["RudderUpperRight"].setColorFill(0,0,0);
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
				me["RudderLowerLeft"].setColorFill(0,1,0);
			} else {
				me["RudderLowerLeft"].setColorFill(0,0,0);
			}
			me["RudderLowerLeft"].setTranslation(math.clamp(Value.Fctl.rudderLower, -30, 0) * 0.69943, 0);
			me["RudderLowerLeft"].show();
		} else if (Value.Fctl.rudderLower >= 0.8) {
			me["RudderLowerLeft"].hide();
			if (Value.Fctl.rudderLower >= 29.7) {
				me["RudderLowerRight"].setColorFill(0,1,0);
			} else {
				me["RudderLowerRight"].setColorFill(0,0,0);
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
		
		if (Value.Config.gearStatus[0] == 0) {
			me["NoseStatus"].hide();
		} else {
			if (Value.Config.gearStatus[0] == 2) {
				me["NoseStatus"].setColor(0,1,0);
			} else {
				me["NoseStatus"].setColor(1,0,0);
			}
			me["NoseStatus"].show();
		}
		
		if (Value.Config.gearStatus[1] == 0) {
			me["LeftStatus"].hide();
		} else {
			if (Value.Config.gearStatus[1] == 2) {
				me["LeftStatus"].setColor(0,1,0);
			} else {
				me["LeftStatus"].setColor(1,0,0);
			}
			me["LeftStatus"].show();
		}
		
		if (Value.Config.gearStatus[2] == 0) {
			me["RightStatus"].hide();
		} else {
			if (Value.Config.gearStatus[2] == 2) {
				me["RightStatus"].setColor(0,1,0);
			} else {
				me["RightStatus"].setColor(1,0,0);
			}
			me["RightStatus"].show();
		}
		
		if (Value.Config.gearStatus[3] == 0) {
			me["CenterStatus"].hide();
		} else {
			if (Value.Config.gearStatus[3] == 2) {
				me["CenterStatus"].setColor(0,1,0);
			} else {
				me["CenterStatus"].setColor(1,0,0);
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
		return [];
	},
	update: func() {
	},
};

var canvasEng = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasEng, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["APU", "APU-EGT", "APU-N1", "APU-N2", "APU-QTY", "CabinRateDn", "CabinRateUp", "Cg", "Fuel", "Fuel-thousands", "GEGroup", "GW", "GW-thousands", "NacelleTemp1", "NacelleTemp2", "NacelleTemp3", "PWGroup", "OilPsi1", "OilPsi1-needle", "OilPsi2",
		"OilPsi2-needle", "OilPsi3", "OilPsi3-needle", "OilQty1", "OilQty1-box", "OilQty1-cline", "OilQty1-needle", "OilQty2", "OilQty2-box", "OilQty2-cline", "OilQty2-needle", "OilQty3", "OilQty3-box", "OilQty3-cline", "OilQty3-needle", "OilTemp1",
		"OilTemp1-box", "OilTemp1-needle", "OilTemp2", "OilTemp2-box", "OilTemp2-needle", "OilTemp3", "OilTemp3-box", "OilTemp3-needle", "Stab", "StabBox", "StabNeedle", "StabUnit"];
	},
	setup: func() {
		Value.Eng.type = pts.Options.eng.getValue();
		
		if (Value.Eng.type == "GE") {
			me["GEGroup"].show();
			me["PWGroup"].hide();
		} else {
			me["GEGroup"].hide();
			me["PWGroup"].show();
		}
		
		# Unsimulated stuff, fix later
		me["CabinRateDn"].hide();
		me["CabinRateUp"].hide();
		me["StabBox"].hide();
	},
	update: func() {
		# GW, Fuel, CG
		Value.Misc.gw = math.round(pts.Fdm.JSBsim.Inertia.weightLbs.getValue(), 100);
		me["GW-thousands"].setText(sprintf("%d", math.floor(Value.Misc.gw / 1000)));
		me["GW"].setText(right(sprintf("%d", Value.Misc.gw), 3));
		
		Value.Misc.fuel = math.round(pts.Consumables.Fuel.totalFuelLbs.getValue(), 100);
		me["Fuel-thousands"].setText(sprintf("%d", math.floor(Value.Misc.fuel / 1000)));
		me["Fuel"].setText(right(sprintf("%03d", Value.Misc.fuel), 3));
		
		me["Cg"].setText(sprintf("%4.1f", math.round(pts.Fdm.JSBsim.Inertia.cgPercentMac.getValue(), 0.1)));
		
		# Stab
		Value.Fctl.stab = pts.Fdm.JSBsim.Hydraulics.Stabilizer.finalDeg.getValue();
		Value.Fctl.stabText = math.round(abs(Value.Fctl.stab), 0.1);
		
		me["Stab"].setText(sprintf("%2.1f", Value.Fctl.stabText));
		me["StabNeedle"].setTranslation(Value.Fctl.stab * -12.6451613, 0);
		
		if (Value.Fctl.stab > 0 and Value.Fctl.stabText > 0) {
			me["StabUnit"].setText("AND");
		} else {
			me["StabUnit"].setText("ANU");
		}
		
		# Oil Psi
		me["OilPsi1"].setText(sprintf("%d", pts.Engines.Engine.oilPsi[0].getValue()));
		me["OilPsi1-needle"].setRotation(pts.Instrumentation.Sd.Eng.oilPsi[0].getValue() * D2R);
		
		me["OilPsi2"].setText(sprintf("%d", pts.Engines.Engine.oilPsi[1].getValue()));
		me["OilPsi2-needle"].setRotation(pts.Instrumentation.Sd.Eng.oilPsi[1].getValue() * D2R);
		
		me["OilPsi3"].setText(sprintf("%d", pts.Engines.Engine.oilPsi[2].getValue()));
		me["OilPsi3-needle"].setRotation(pts.Instrumentation.Sd.Eng.oilPsi[2].getValue() * D2R);
		
		# Oil Temp
		Value.Eng.oilTemp[0] = math.round(pts.Engines.Engine.oilTemp[0].getValue());
		Value.Eng.oilTemp[1] = math.round(pts.Engines.Engine.oilTemp[1].getValue());
		Value.Eng.oilTemp[2] = math.round(pts.Engines.Engine.oilTemp[2].getValue());
		
		me["OilTemp1"].setText(sprintf("%d", Value.Eng.oilTemp[0]));
		me["OilTemp1-needle"].setRotation(pts.Instrumentation.Sd.Eng.oilTemp[0].getValue() * D2R);
		
		me["OilTemp2"].setText(sprintf("%d", Value.Eng.oilTemp[1]));
		me["OilTemp2-needle"].setRotation(pts.Instrumentation.Sd.Eng.oilTemp[1].getValue() * D2R);
		
		me["OilTemp3"].setText(sprintf("%d", Value.Eng.oilTemp[2]));
		me["OilTemp3-needle"].setRotation(pts.Instrumentation.Sd.Eng.oilTemp[2].getValue() * D2R);
		
		if (Value.Eng.type == "PW") {
			if (Value.Eng.oilTemp[0] <= 50) {
				me["OilTemp1"].setColor(0.9647,0.8196,0.07843);
				me["OilTemp1-box"].show();
				me["OilTemp1-needle"].setColor(0.9647,0.8196,0.07843);
			} else {
				me["OilTemp1"].setColor(1,1,1);
				me["OilTemp1-box"].hide();
				me["OilTemp1-needle"].setColor(1,1,1);
			}
			
			if (Value.Eng.oilTemp[1] <= 50) {
				me["OilTemp2"].setColor(0.9647,0.8196,0.07843);
				me["OilTemp2-box"].show();
				me["OilTemp2-needle"].setColor(0.9647,0.8196,0.07843);
			} else {
				me["OilTemp2"].setColor(1,1,1);
				me["OilTemp2-box"].hide();
				me["OilTemp2-needle"].setColor(1,1,1);
			}
			
			if (Value.Eng.oilTemp[2] <= 50) {
				me["OilTemp3"].setColor(0.9647,0.8196,0.07843);
				me["OilTemp3-box"].show();
				me["OilTemp3-needle"].setColor(0.9647,0.8196,0.07843);
			} else {
				me["OilTemp3"].setColor(1,1,1);
				me["OilTemp3-box"].hide();
				me["OilTemp3-needle"].setColor(1,1,1);
			}
		}
		
		# Oil Qty
		Value.Eng.oilQty[0] = math.round(pts.Engines.Engine.oilQty[0].getValue());
		Value.Eng.oilQty[1] = math.round(pts.Engines.Engine.oilQty[1].getValue());
		Value.Eng.oilQty[2] = math.round(pts.Engines.Engine.oilQty[2].getValue());
		
		me["OilQty1"].setText(sprintf("%d", Value.Eng.oilQty[0]));
		me["OilQty1-needle"].setRotation(pts.Instrumentation.Sd.Eng.oilQty[0].getValue() * D2R);
		
		me["OilQty2"].setText(sprintf("%d", Value.Eng.oilQty[1]));
		me["OilQty2-needle"].setRotation(pts.Instrumentation.Sd.Eng.oilQty[1].getValue() * D2R);
		
		me["OilQty3"].setText(sprintf("%d", Value.Eng.oilQty[2]));
		me["OilQty3-needle"].setRotation(pts.Instrumentation.Sd.Eng.oilQty[2].getValue() * D2R);
		
		if (Value.Eng.oilQty[0] <= 4) {
			me["OilQty1"].setColor(0.9647,0.8196,0.07843);
			me["OilQty1-box"].show();
			me["OilQty1-needle"].setColor(0.9647,0.8196,0.07843);
		} else {
			me["OilQty1"].setColor(1,1,1);
			me["OilQty1-box"].hide();
			me["OilQty1-needle"].setColor(1,1,1);
		}
		
		if (Value.Eng.oilQty[1] <= 4) {
			me["OilQty2"].setColor(0.9647,0.8196,0.07843);
			me["OilQty2-box"].show();
			me["OilQty2-needle"].setColor(0.9647,0.8196,0.07843);
		} else {
			me["OilQty2"].setColor(1,1,1);
			me["OilQty2-box"].hide();
			me["OilQty2-needle"].setColor(1,1,1);
		}
		
		if (Value.Eng.oilQty[2] <= 4) {
			me["OilQty3"].setColor(0.9647,0.8196,0.07843);
			me["OilQty3-box"].show();
			me["OilQty3-needle"].setColor(0.9647,0.8196,0.07843);
		} else {
			me["OilQty3"].setColor(1,1,1);
			me["OilQty3-box"].hide();
			me["OilQty3-needle"].setColor(1,1,1);
		}
		
		Value.Eng.oilQtyCline[0] = pts.Instrumentation.Sd.Eng.oilQtyCline[0].getValue();
		Value.Eng.oilQtyCline[1] = pts.Instrumentation.Sd.Eng.oilQtyCline[1].getValue();
		Value.Eng.oilQtyCline[2] = pts.Instrumentation.Sd.Eng.oilQtyCline[2].getValue();
		
		if (Value.Eng.oilQtyCline[0] != -1) {
			me["OilQty1-cline"].setRotation(Value.Eng.oilQtyCline[0] * D2R);
			me["OilQty1-cline"].show();
		} else {
			me["OilQty1-cline"].hide();
		}
		if (Value.Eng.oilQtyCline[1] != -1) {
			me["OilQty2-cline"].setRotation(Value.Eng.oilQtyCline[1] * D2R);
			me["OilQty2-cline"].show();
		} else {
			me["OilQty2-cline"].hide();
		}
		if (Value.Eng.oilQtyCline[2] != -1) {
			me["OilQty3-cline"].setRotation(Value.Eng.oilQtyCline[2] * D2R);
			me["OilQty3-cline"].show();
		} else {
			me["OilQty3-cline"].hide();
		}
		
		# Nacelle Temp
		me["NacelleTemp1"].setText(sprintf("%d", math.round(pts.Engines.Engine.nacelleTemp[0].getValue())));
		me["NacelleTemp2"].setText(sprintf("%d", math.round(pts.Engines.Engine.nacelleTemp[1].getValue())));
		me["NacelleTemp3"].setText(sprintf("%d", math.round(pts.Engines.Engine.nacelleTemp[2].getValue())));
		
		# APU
		Value.Apu.n2 = systems.APU.n2.getValue();
		if (Value.Apu.n2 >= 1) {
			me["APU-EGT"].setText(sprintf("%d", math.round(systems.APU.egt.getValue())));
			me["APU-N1"].setText(sprintf("%d", math.round(systems.APU.n1.getValue())));
			me["APU-N2"].setText(sprintf("%d", math.round(Value.Apu.n2)));
			me["APU-QTY"].setText(sprintf("%2.1f", math.round(systems.APU.oilQty.getValue(), 0.5)));
			me["APU"].show();
		} else {
			me["APU"].hide();
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
		return [];
	},
	update: func() {
	},
};

var canvasStatus = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasStatus, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return [];
	},
	update: func() {
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
	var engGroup = display.createGroup();
	var miscGroup = display.createGroup();
	var statusGroup = display.createGroup();
	
	config = canvasConfig.new(configGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-CONFIG.svg");
	conseq = canvasConseq.new(conseqGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-CONSEQ.svg");
	eng = canvasEng.new(engGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-ENG.svg");
	misc = canvasStatus.new(miscGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-MISC.svg");
	status = canvasStatus.new(statusGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-STATUS.svg");
	
	canvasBase.setup();
	update.start();
	
	if (pts.Systems.Acconfig.Options.Du.sdFps.getValue() != 10) {
		rateApply();
	}
}

var rateApply = func() {
	update.restart(1 / pts.Systems.Acconfig.Options.Du.sdFps.getValue()); # 10FPS
}

var update = maketimer(0.1, func() { # 10FPS
	canvasBase.update();
});

var showSd = func() {
	var dlg = canvas.Window.new([512, 512], "dialog", nil, 0).set("resize", 1);
	dlg.setCanvas(display);
	dlg.set("title", "System Display");
}
