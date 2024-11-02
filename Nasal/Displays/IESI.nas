# McDonnell Douglas MD-11 IESI
# Copyright (c) 2024 Josh Davidson (Octal450)

var display = nil;
var iesi = nil;

var Value = {
	Ai: {
		center: nil,
		pitch: 0,
		roll: 0,
		slipSkid: 0,
	},
	Alt: {
		indicated: 0,
		indicatedAbs: 0,
		Tape: {
			eight: 0,
			eightT: "",
			five: 0,
			fiveT: "",
			four: 0,
			fourT: "",
			hundreds: 0,
			hundredsGeneva: 0,
			middleOffset: 0,
			middleText: 0,
			offset: 0,
			one: 0,
			oneT: "",
			seven: 0,
			sevenT: "",
			six: 0,
			sixT: "",
			tenThousands: 0,
			tenThousandsGeneva: 0,
			thousands: 0,
			thousandsGeneva: 0,
			three: 0,
			threeT: "",
			tens: 0,
			two: 0,
			twoT: "",
		},
	},
	Asi: {
		ias: 0,
		mach: 0,
		machLatch: 0,
		Tape: {
			ias: 0,
			tens: 0,
			tensGeneva: 0,
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
		
		Value.Ai.center = me["AI_center"].getCenter();
		me.aiHorizonTrans = me["AI_horizon"].createTransform();
		me.aiHorizonRot = me["AI_horizon"].createTransform();
		
		me.page = canvasGroup;
		
		return me;
	},
	getKeys: func() {
		return ["AI_bank", "AI_center", "AI_horizon", "AI_init", "AI_init_secs", "AI_mask", "AI_slipskid", "ALT_eight", "ALT_five", "ALT_four", "ALT_hundreds", "ALT_meters", "ALT_minus", "ALT_one", "ALT_scale", "ALT_seven", "ALT_six", "ALT_tens",
		"ALT_tenthousands", "ALT_thousands", "ALT_three", "ALT_two", "ASI", "ASI_mach", "ASI_scale", "ASI_hundreds", "ASI_ones", "ASI_tens", "HDG_one", "HDG_two", "HDG_three", "HDG_four", "HDG_five", "HDG_six", "HDG_seven", "HDG_eight", "HDG_nine", "HDG_error",
		"HDG_scale", "QNH", "QNH_type"];
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
		
		Value.Asi.Tape.ias = Value.Asi.ias - 40; # Subtract 40, since the scale starts at 40
		me["ASI_scale"].setTranslation(0, Value.Asi.Tape.ias * 5.55785);
		
		Value.Asi.Tape.hundreds = num(right(sprintf("%07.3f", Value.Asi.ias), 7)) / 10; # Unlikely it would be above 999 but lets account for it anyways
		Value.Asi.Tape.hundredsGeneva = genevaAsiHundreds(Value.Asi.Tape.hundreds);
		me["ASI_hundreds"].setTranslation(0, Value.Asi.Tape.hundredsGeneva * 57.47);
		
		Value.Asi.Tape.tens = num(right(sprintf("%06.3f", Value.Asi.ias), 6)) / 10;
		Value.Asi.Tape.tensGeneva = genevaAsiTens(Value.Asi.Tape.tens);
		me["ASI_tens"].setTranslation(0, Value.Asi.Tape.tensGeneva * 57.47);
		
		me["ASI_ones"].setTranslation(0, (10 * math.mod(Value.Asi.ias / 10, 1)) * 57.47);
		
		if (Value.Asi.mach > 0.47) { # Match PFD logic
			machLatch = 1;
			if (Value.Asi.mach >= 0.999) {
				me["ASI_mach"].setText("999");
			} else {
				me["ASI_mach"].setText("M . " ~ sprintf("%03d", Value.Asi.mach * 1000));
			}
		} else if (Value.Asi.mach < 0.45) {
			machLatch = 0;
			me["ASI_mach"].setText("M");
		} else if (machLatch = 1) {
			if (Value.Asi.mach >= 0.999) {
				me["ASI_mach"].setText("999");
			} else {
				me["ASI_mach"].setText("M . " ~ sprintf("%03d", Value.Asi.mach * 1000));
			}
		}
		
		# AI
		if (systems.DUController.CounterIesi.secs <= 0) {
			Value.Ai.pitch = pts.Orientation.pitchDeg.getValue();
			Value.Ai.roll = pts.Orientation.rollDeg.getValue();
			
			me.aiHorizonTrans.setTranslation(0, Value.Ai.pitch * 6.6644);
			me.aiHorizonRot.setRotation(-Value.Ai.roll * D2R, Value.Ai.center);
			
			Value.Ai.slipSkid = pts.Instrumentation.Iesi.slipSkid.getValue() * 4.235;
			if (abs(Value.Ai.slipSkid) >= 16.268) {
				me["AI_slipskid"].setColorFill(0.9412, 0.7255, 0);
			} else {
				me["AI_slipskid"].setColorFill(1, 1, 1);
			}
			me["AI_slipskid"].setTranslation(Value.Ai.slipSkid, 0);
			me["AI_bank"].setRotation(-Value.Ai.roll * D2R);
			
			me["AI_horizon"].show();
			me["AI_init"].hide();
		} else {
			me["AI_horizon"].hide();
			me["AI_init"].show();
			me["AI_init_secs"].setText(sprintf("%d", systems.DUController.CounterIesi.secs) ~ " SECS");
		}
		
		# ALT
		if (Value.Alt.indicated < 0) {
			if (Value.Alt.indicated >= -998) {
				me["ALT_minus"].setTranslation(29.072, 0);
				me["ALT_thousands"].hide();
			} else {
				me["ALT_minus"].setTranslation(0, 0);
				me["ALT_thousands"].show();
			}
			
			me["ALT_minus"].show();
			me["ALT_tenthousands"].hide();
		} else {
			me["ALT_minus"].hide();
			me["ALT_thousands"].show();
			me["ALT_tenthousands"].show();
		}
		
		Value.Alt.indicated = pts.Instrumentation.Altimeter.indicatedAltitudeFt.getValue();
		Value.Alt.indicatedAbs = abs(Value.Alt.indicated);
		Value.Alt.Tape.offset = Value.Alt.indicated / 200 - int(Value.Alt.indicated / 200);
		Value.Alt.Tape.middleText = right(sprintf("%03d", abs(roundAboutAlt(Value.Alt.indicated / 100))), 1) * 100;
		if (Value.Alt.indicated < 0) Value.Alt.Tape.middleText = Value.Alt.Tape.middleText * -1;
		Value.Alt.Tape.middleOffset = nil;
		
		if (Value.Alt.Tape.offset > 0.5) {
			Value.Alt.Tape.middleOffset = -(Value.Alt.Tape.offset - 1) * 83.3;
		} else {
			Value.Alt.Tape.middleOffset = -Value.Alt.Tape.offset * 83.3;
		}
		me["ALT_scale"].setTranslation(0, -Value.Alt.Tape.middleOffset);
		me["ALT_scale"].update();
		
		Value.Alt.Tape.eight = Value.Alt.Tape.middleText + 600;
		me["ALT_eight"].setText(right(sprintf("%03d", abs(Value.Alt.Tape.eight)), 3));
		
		Value.Alt.Tape.seven = Value.Alt.Tape.middleText + 400;
		me["ALT_seven"].setText(right(sprintf("%03d", abs(Value.Alt.Tape.seven)), 3));
		
		Value.Alt.Tape.six = Value.Alt.Tape.middleText + 200;
		me["ALT_six"].setText(right(sprintf("%03d", abs(Value.Alt.Tape.six)), 3));
		
		Value.Alt.Tape.five = Value.Alt.Tape.middleText;
		me["ALT_five"].setText(right(sprintf("%03d", abs(Value.Alt.Tape.five)), 3));
		
		Value.Alt.Tape.four = Value.Alt.Tape.middleText - 200;
		me["ALT_four"].setText(right(sprintf("%03d", abs(Value.Alt.Tape.four)), 3));
		
		Value.Alt.Tape.three = Value.Alt.Tape.middleText - 400;
		me["ALT_three"].setText(right(sprintf("%03d", abs(Value.Alt.Tape.three)), 3));
		
		Value.Alt.Tape.two = Value.Alt.Tape.middleText - 600;
		me["ALT_two"].setText(right(sprintf("%03d", abs(Value.Alt.Tape.two)), 3));
		
		Value.Alt.Tape.one = Value.Alt.Tape.middleText - 800;
		me["ALT_one"].setText(right(sprintf("%03d", abs(Value.Alt.Tape.one)), 3));
		
		Value.Alt.Tape.tenThousands = num(right(sprintf("%05d", Value.Alt.indicatedAbs), 5)) / 100; # Unlikely it would be above 99999 but lets account for it anyways
		Value.Alt.Tape.tenThousandsGeneva = genevaAltTenThousands(Value.Alt.Tape.tenThousands);
		me["ALT_tenthousands"].setTranslation(0, Value.Alt.Tape.tenThousandsGeneva * 57.47);
		
		Value.Alt.Tape.thousands = num(right(sprintf("%04d", Value.Alt.indicatedAbs), 4)) / 100;
		Value.Alt.Tape.thousandsGeneva = genevaAltThousands(Value.Alt.Tape.thousands);
		me["ALT_thousands"].setTranslation(0, Value.Alt.Tape.thousandsGeneva * 57.47);
		
		Value.Alt.Tape.hundreds = num(right(sprintf("%03d", Value.Alt.indicatedAbs), 3)) / 100;
		Value.Alt.Tape.hundredsGeneva = genevaAltHundreds(Value.Alt.Tape.hundreds);
		me["ALT_hundreds"].setTranslation(0, Value.Alt.Tape.hundredsGeneva * 57.47);
		
		Value.Alt.Tape.tens = num(right(sprintf("%02d", Value.Alt.indicatedAbs), 2));
		me["ALT_tens"].setTranslation(0, Value.Alt.Tape.tens * 2.392);
		
		me["ALT_meters"].setText(sprintf("%d", math.round(Value.Alt.indicated * FT2M)) ~ "M");
		
		# QNH
		Value.Qnh.inhg = pts.Instrumentation.Altimeter.inhg.getBoolValue();
		if (pts.Instrumentation.Altimeter.std.getBoolValue()) {
			me["QNH"].hide();
			me["QNH_type"].setText("STD");
		} else if (Value.Qnh.inhg == 0) {
			me["QNH"].setText(sprintf("%d", pts.Instrumentation.Altimeter.settingHpa.getValue()));
			me["QNH"].show();
			me["QNH_type"].setText("HP");
		} else if (Value.Qnh.inhg == 1) {
			me["QNH"].setText(sprintf("%2.2f", pts.Instrumentation.Altimeter.settingInhg.getValue()));
			me["QNH"].show();
			me["QNH_type"].setText("IN");
		}
		
		# HDG
		if (systems.IRS.Iru.mainAvail[2].getBoolValue()) {
			Value.Hdg.indicated = pts.Orientation.headingMagneticDeg.getValue();
			Value.Hdg.offset = Value.Hdg.indicated / 10 - int(Value.Hdg.indicated / 10);
			Value.Hdg.middleText = roundAbout(Value.Hdg.indicated / 10);
			Value.Hdg.middleOffset = nil;
			
			if (Value.Hdg.middleText == 36) {
				Value.Hdg.middleText = 0;
			}
			
			Value.Hdg.leftText1 = Value.Hdg.middleText == 0 ? 35 : Value.Hdg.middleText - 1;
			Value.Hdg.rightText1 = Value.Hdg.middleText == 35 ? 0 : Value.Hdg.middleText + 1;
			Value.Hdg.leftText2 = Value.Hdg.leftText1 == 0 ? 35 : Value.Hdg.leftText1 - 1;
			Value.Hdg.rightText2 = Value.Hdg.rightText1 == 35 ? 0 : Value.Hdg.rightText1 + 1;
			Value.Hdg.leftText3 = Value.Hdg.leftText2 == 0 ? 35 : Value.Hdg.leftText2 - 1;
			Value.Hdg.rightText3 = Value.Hdg.rightText2 == 35 ? 0 : Value.Hdg.rightText2 + 1;
			Value.Hdg.leftText4 = Value.Hdg.leftText3 == 0 ? 35 : Value.Hdg.leftText3 - 1;
			Value.Hdg.rightText4 = Value.Hdg.rightText3 == 35 ? 0 :Value.Hdg.rightText3 + 1;
			
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

var setup = func() {
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
	
	if (pts.Systems.Acconfig.Options.Du.iesiFps.getValue() != 20) {
		rateApply();
	}
}

var rateApply = func() {
	update.restart(1 / pts.Systems.Acconfig.Options.Du.iesiFps.getValue());
}

var update = maketimer(0.05, func() { # 20FPS
	canvasBase.update();
});

var showIesi = func() {
	var dlg = canvas.Window.new([256, 220], "dialog", nil, 0).set("resize", 1);
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

var m = 0;
var s = 0;
var y = 0;

var roundAboutAlt = func(x) { # For altitude tape numbers
	y = x * 0.5 - int(x * 0.5);
	return y < 0.5 ? 2 * int(x * 0.5) : 2 + 2 * int(x * 0.5);
}

var genevaAsiHundreds = func(input) {
	m = math.floor(input / 10);
	s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	if (math.mod(input / 10, 1) < 0.9) s = 0;
	return m + s;
}

var genevaAsiTens = func(input) {
	m = math.floor(input);
	s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	return m + s;
}

var genevaAltTenThousands = func(input) {
	m = math.floor(input / 100);
	s = math.max(0, (math.mod(input, 1) - 0.8) * 5);
	if (math.mod(input / 10, 1) < 0.9 or math.mod(input / 100, 1) < 0.9) s = 0;
	return m + s;
}

var genevaAltThousands = func(input) {
	m = math.floor(input / 10);
	s = math.max(0, (math.mod(input, 1) - 0.8) * 5);
	if (math.mod(input / 10, 1) < 0.9) s = 0;
	return m + s;
}

var genevaAltHundreds = func(input) {
	m = math.floor(input);
	s = math.max(0, (math.mod(input, 1) - 0.8) * 5);
	return m + s;
}
