# McDonnell Douglas MD-11 IESI
# Copyright (c) 2022 Josh Davidson (Octal450)

var display = nil;
var iesi = nil;

var Value = {
	Ai: {
		pitch: 0,
		roll: 0,
	},
	Alt: {
		indicated: 0,
	},
	Asi: {
		ias: 0,
		mach: 0,
		machLatch: 0,
		Tape: {
			ias: 0,
		},
	},
	Hdg: {
		indicated: 0,
		Tape: {
			leftText1: "0",
			leftText2: "0",
			leftText3: "0",
			leftText4: "0",
			middleOffset: 0,
			middleText: 0,
			offset: 0,
			rightText1: "0",
			rightText2: "0",
			rightText3: "0",
			rightText4: "0",
		},
	},
	Qnh: {
		inhg: 0,
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
		
		me.aiHorizonTrans = me["AI_horizon"].createTransform();
		me.aiHorizonRot = me["AI_horizon"].createTransform();
		
		me.page = canvasGroup;
		
		return me;
	},
	getKeys: func() {
		return ["AI_bank", "AI_bank_mask", "AI_center", "AI_horizon", "AI_init", "AI_init_secs", "AI_slipskid", "ALT_meters", "ASI", "ASI_mach", "ASI_scale", "ASI_tape", "HDG_one", "HDG_two", "HDG_three", "HDG_four", "HDG_five", "HDG_six", "HDG_seven",
		"HDG_eight", "HDG_nine", "HDG_error", "HDG_scale", "QNH", "QNH_type"];
	},
	setup: func() {
		# Hide the pages by default
		iesi.page.hide();
	},
	update: func() {
		if (systems.DUController.updateIesi) {
			iesi.update();
		}
	},
};

var canvasIesi = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasIesi, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	update: func() {
		# ASI
		Value.Asi.ias = math.clamp(pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue(), 40, 500);
		Value.Asi.mach = pts.Instrumentation.AirspeedIndicator.indicatedMach.getValue();
		
		# Subtract 40, since the scale starts at 40
		Value.Asi.Tape.ias = Value.Asi.ias - 40;
		
		me["ASI"].setText(sprintf("%d", (Value.Asi.ias / 10) + 0.03));
		me["ASI_scale"].setTranslation(0, Value.Asi.Tape.ias * 5.559);
		me["ASI_tape"].setTranslation(0, math.round((10 * math.mod(Value.Asi.ias / 10, 1)) * 52.58, 0.1));
		
		if (Value.Asi.mach > 0.47) { # Match PFD logic
			machLatch = 1;
			if (Value.Asi.mach >= 0.999) {
				me["ASI_mach"].setText("999");
			} else {
				me["ASI_mach"].setText("M . " ~ sprintf("%3.0f", Value.Asi.mach * 1000));
			}
		} else if (Value.Asi.mach < 0.45) {
			machLatch = 0;
			me["ASI_mach"].setText("M");
		} else if (machLatch = 1) {
			if (Value.Asi.mach >= 0.999) {
				me["ASI_mach"].setText("999");
			} else {
				me["ASI_mach"].setText("M . " ~ sprintf("%3.0f", Value.Asi.mach * 1000));
			}
		}
		
		# AI
		if (systems.DUController.counterIesi.secs <= 0) {
			Value.Ai.pitch = pts.Orientation.pitchDeg.getValue();
			Value.Ai.roll = pts.Orientation.rollDeg.getValue();
			
			AICenter = me["AI_center"].getCenter();
			
			me.aiHorizonTrans.setTranslation(0, Value.Ai.pitch * 6.668);
			me.aiHorizonRot.setRotation(-Value.Ai.roll * D2R, AICenter);
			
			me["AI_slipskid"].setTranslation(pts.Instrumentation.Pfd.slipSkid.getValue() * 4.05, 0);
			me["AI_bank"].setRotation(-Value.Ai.roll * D2R);
			me["AI_bank_mask"].setRotation(-Value.Ai.roll * D2R);
			
			me["AI_bank_mask"].show();
			me["AI_horizon"].show();
			me["AI_init"].hide();
		} else {
			me["AI_bank_mask"].hide();
			me["AI_horizon"].hide();
			me["AI_init"].show();
			me["AI_init_secs"].setText(sprintf("%d", systems.DUController.counterIesi.secs) ~ " SECS");
		}
		
		# ALT
		Value.Alt.indicated = pts.Instrumentation.Altimeter.indicatedAltitudeFt.getValue();
		me["ALT_meters"].setText(sprintf("%d", math.round(Value.Alt.indicated * FT2M)) ~ "M");
		
		# QNH
		Value.Qnh.inhg = pts.Instrumentation.Altimeter.inhg.getBoolValue();
		if (pts.Instrumentation.Altimeter.std.getBoolValue()) {
			me["QNH"].hide();
			me["QNH_type"].setText("STD");
		} else if (Value.Qnh.inhg == 0) {
			me["QNH"].setText(sprintf("%4.0f", pts.Instrumentation.Altimeter.settingHpa.getValue()));
			me["QNH"].show();
			me["QNH_type"].setText("HP");
		} else if (Value.Qnh.inhg == 1) {
			me["QNH"].setText(sprintf("%2.2f", pts.Instrumentation.Altimeter.settingInhg.getValue()));
			me["QNH"].show();
			me["QNH_type"].setText("IN");
		}
		
		# HDG
		if (systems.IRS.Iru.aligned[2].getBoolValue()) {
			Value.Hdg.indicated = pts.Orientation.headingMagneticDeg.getValue();
			Value.Hdg.offset = Value.Hdg.indicated / 10 - int(Value.Hdg.indicated / 10);
			Value.Hdg.middleText = roundAbout(Value.Hdg.indicated / 10);
			Value.Hdg.middleOffset = nil;
			
			if (Value.Hdg.middleText == 36) {
				Value.Hdg.middleText = 0;
			}
			
			Value.Hdg.leftText1 = Value.Hdg.middleText == 0?35:Value.Hdg.middleText - 1;
			Value.Hdg.rightText1 = Value.Hdg.middleText == 35?0:Value.Hdg.middleText + 1;
			Value.Hdg.leftText2 = Value.Hdg.leftText1 == 0?35:Value.Hdg.leftText1 - 1;
			Value.Hdg.rightText2 = Value.Hdg.rightText1 == 35?0:Value.Hdg.rightText1 + 1;
			Value.Hdg.leftText3 = Value.Hdg.leftText2 == 0?35:Value.Hdg.leftText2 - 1;
			Value.Hdg.rightText3 = Value.Hdg.rightText2 == 35?0:Value.Hdg.rightText2 + 1;
			Value.Hdg.leftText4 = Value.Hdg.leftText3 == 0?35:Value.Hdg.leftText3 - 1;
			Value.Hdg.rightText4 = Value.Hdg.rightText3 == 35?0:Value.Hdg.rightText3 + 1;
			
			if (Value.Hdg.offset > 0.5) {
				Value.Hdg.middleOffset = -(Value.Hdg.offset - 1) * 60.5;
			} else {
				Value.Hdg.middleOffset = -Value.Hdg.offset * 60.5;
			}
			
			me["HDG_scale"].setTranslation(Value.Hdg.middleOffset, 0);
			me["HDG_scale"].update();
			
			me["HDG_five"].setText(hdgText(Value.Hdg.middleText));
			me["HDG_six"].setText(hdgText(Value.Hdg.rightText1));
			me["HDG_four"].setText(hdgText(Value.Hdg.leftText1));
			me["HDG_seven"].setText(hdgText(Value.Hdg.rightText2));
			me["HDG_three"].setText(hdgText(Value.Hdg.leftText2));
			me["HDG_eight"].setText(hdgText(Value.Hdg.rightText3));
			me["HDG_two"].setText(hdgText(Value.Hdg.leftText3));
			me["HDG_nine"].setText(hdgText(Value.Hdg.rightText4));
			me["HDG_one"].setText(hdgText(Value.Hdg.leftText4));
			
			me["HDG_error"].hide();
			me["HDG_scale"].show();
		} else {
			me["HDG_error"].show();
			me["HDG_scale"].hide();
		}
	},
};

var init = func() {
	display = canvas.new({
		"name": "IESI",
		"size": [512, 439],
		"view": [512, 439],
		"mipmapping": 1
	});
	
	display.addPlacement({"node": "iesi.screen"});
	
	var iesiGroup = display.createGroup();
	
	iesi = canvasIesi.new(iesiGroup, "Aircraft/MD-11/Nasal/Displays/res/IESI.svg");
	
	canvasBase.setup();
	update.start();
	
	if (pts.Systems.Acconfig.Options.Du.iesiFps.getValue() != 10) {
		rateApply();
	}
}

var rateApply = func() {
	update.restart(1 / pts.Systems.Acconfig.Options.Du.iesiFps.getValue());
}

var update = maketimer(0.1, func() { # 10FPS
	canvasBase.update();
});

var showIesi = func() {
	var dlg = canvas.Window.new([256, 220], "dialog").set("resize", 1);
	dlg.setCanvas(display);
	dlg.set("title", "Integrated Electronic Standby");
}

var roundAbout = func(x) {
	var y = x - int(x);
	return y < 0.5 ? int(x) : 1 + int(x);
}

var hdgOutput = "";
var hdgText = func(x) {
	if (x == 0) {
		return "N";
	} else if (x == 9) {
		return "E";
	} else if (x == 18) {
		return "S";
	} else if (x == 27) {
		return "W";
	} else {
		hdgOutput = sprintf("%d", x);
		return hdgOutput;
	}
}
