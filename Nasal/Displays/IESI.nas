# McDonnell Douglas MD-11 IESI
# Copyright (c) 2021 Josh Davidson (Octal450)

var iesiDisplay = nil;
var iesi = nil;

var Value = {
	Ai: {
		pitch: 0,
		roll: 0,
	},
	Asi: {
		ias: 0,
		mach: 0,
		machLatch: 0,
		Tape: {
			ias: 0,
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
		return ["AI_bank", "AI_bank_mask", "AI_center", "AI_horizon", "AI_slipskid", "ASI", "ASI_mach", "ASI_scale", "ASI_tape", "QNH", "QNH_type"];
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
setprop("test", 0);
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
		Value.Ai.pitch = pts.Orientation.pitchDeg.getValue();
		Value.Ai.roll = pts.Orientation.rollDeg.getValue();
		
		AICenter = me["AI_center"].getCenter();
		
		me.aiHorizonTrans.setTranslation(0, Value.Ai.pitch * 6.668);
		me.aiHorizonRot.setRotation(-Value.Ai.roll * D2R, AICenter);
		
		me["AI_slipskid"].setTranslation(pts.Instrumentation.Pfd.slipSkid.getValue() * 4.05, 0);
		me["AI_bank"].setRotation(-Value.Ai.roll * D2R);
		me["AI_bank_mask"].setRotation(-Value.Ai.roll * D2R);
		
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
	},
};

var init = func() {
	iesiDisplay = canvas.new({
		"name": "IESI",
		"size": [512, 439],
		"view": [512, 439],
		"mipmapping": 1
	});
	
	iesiDisplay.addPlacement({"node": "iesi.screen"});
	
	var iesiGroup = iesiDisplay.createGroup();
	
	iesi = canvasIesi.new(iesiGroup, "Aircraft/MD-11/Nasal/Displays/res/IESI.svg");
	
	canvasBase.setup();
	iesiUpdate.start();
	
	if (pts.Systems.Acconfig.Options.Du.iesiFps.getValue() != 10) {
		rateApply();
	}
}

var rateApply = func() {
	iesiUpdate.restart(1 / pts.Systems.Acconfig.Options.Du.iesiFps.getValue());
}

var iesiUpdate = maketimer(0.1, func() { # 10FPS
	canvasBase.update();
});

var showIesi = func() {
	var dlg = canvas.Window.new([256, 220], "dialog").set("resize", 1);
	dlg.setCanvas(iesiDisplay);
	dlg.set("title", "Integrated Electronic Standby");
}
