# McDonnell Douglas MD-11 PFD
# Copyright (c) 2020 Josh Davidson (Octal450)

var pfd1Display = nil;
var pfd2Display = nil;
var pfd1 = nil;
var pfd1Error = nil;
var pfd2 = nil;
var pfd2Error = nil;
setprop("test1", 0);
setprop("test2", 0);

var Value = {
	Afs: {
		ap1: 0,
		ap2: 0,
		ats: 0,
		fd1: 0,
		fd2: 0,
		lat: 0,
		vert: 0,
	},
	Ai: {
		bankLimit: 0,
		pitch: 0,
		roll: 0,
	},
	Nav: {
		Freq: {
			selected: [0, 0],
			selectedInteger: [0, 0],
			selectedDecimal: [0, 0],
		},
		gsInRange: [0, 0],
		inRange: [0, 0],
		signalQuality: [0, 0],
	},
};

var canvasBase = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
			
			var clip_el = canvas_group.getElementById(key ~ "_clip");
			if (clip_el != nil) {
				clip_el.setVisible(0);
				var tran_rect = clip_el.getTransformedBounds();
				
				var clip_rect = sprintf("rect(%d, %d, %d, %d)", 
					tran_rect[1], # 0 ys
					tran_rect[2], # 1 xe
					tran_rect[3], # 2 ye
					tran_rect[0] # 3 xs
				);
				
				# Coordinates are top, right, bottom, left (ys, xe, ye, xs) ref: l621 of simgear/canvas/CanvasElement.cxx
				me[key].set("clip", clip_rect);
				me[key].set("clip-frame", canvas.Element.PARENT);
			}
		}
		
		me.aiHorizonTrans = me["AI_horizon"].createTransform();
		me.aiHorizonRot = me["AI_horizon"].createTransform();
		
		me.AI_fpv_trans = me["AI_fpv"].createTransform();
		me.AI_fpv_rot = me["AI_fpv"].createTransform();
		
		me.AI_fpd_trans = me["AI_fpd"].createTransform();
		me.AI_fpd_rot = me["AI_fpd"].createTransform();
		
		me.page = canvas_group;
		
		return me;
	},
	getKeys: func() {
		return ["FMA_Speed", "FMA_Thrust", "FMA_Roll", "FMA_Roll_Arm", "FMA_Pitch", "FMA_Pitch_Land", "FMA_Land", "FMA_Pitch_Arm", "FMA_Altitude_Thousand", "FMA_Altitude", "FMA_ATS_Thrust_Off", "FMA_ATS_Pitch_Off", "FMA_AP_Pitch_Off_Box", "FMA_AP_Thrust_Off_Box",
		"FMA_AP", "ASI_v_speed", "ASI_Taxi", "ASI_GroundSpd", "ASI_scale", "ASI_bowtie", "ASI_bowtie_mach", "ASI", "ASI_mach", "ASI_mach_decimal", "ASI_bowtie_L", "ASI_bowtie_R", "ASI_presel", "ASI_sel", "ASI_trend_up", "ASI_trend_down", "ASI_max", "ASI_max_bar",
		"ASI_max_bar2", "ASI_max_flap", "AI_center", "AI_horizon", "AI_bank", "AI_slipskid", "AI_overbank_index", "AI_banklimit_L", "AI_banklimit_R", "AI_alphalim", "AI_group", "AI_group2", "AI_group3", "AI_error", "AI_fpv", "AI_fpd", "AI_arrow_up", "AI_arrow_dn",
		"FD_roll", "FD_pitch", "ALT_thousands", "ALT_hundreds", "ALT_tens", "ALT_scale", "ALT_scale_num", "ALT_one", "ALT_two", "ALT_three", "ALT_four", "ALT_five", "ALT_one_T", "ALT_two_T", "ALT_three_T", "ALT_four_T", "ALT_five_T", "ALT_presel", "ALT_sel",
		"ALT_agl", "ALT_bowtie", "VSI_needle_up", "VSI_needle_dn", "VSI_up", "VSI_down", "VSI_group", "VSI_error", "HDG", "HDG_dial", "HDG_presel", "HDG_sel", "HDG_group", "HDG_error", "TRK_pointer", "TCAS_OFF", "Slats", "Flaps", "Flaps_num", "Flaps_num2",
		"Flaps_num_boxes", "QNH", "LOC_scale", "LOC_pointer", "LOC_no", "GS_scale", "GS_pointer", "GS_no", "RA", "RA_box", "Minimums"];
	},
	update: func() {
		if (pts.Systems.Acconfig.errorCode.getValue() == "0x000") {
			pfd1Error.page.hide();
			pfd2Error.page.hide();
			pfd1.update();
			pfd2.update();
		} else {
			pfd1.page.hide();
			pfd2.page.hide();
			pfd1Error.update();
			pfd2Error.update();
			pfd1Error.page.show();
			pfd2Error.page.show();
		}
	},
	updateBase: func() {
		# AI
		Value.Ai.alpha = pts.Fdm.JSBsim.Aero.alphaDegDamped.getValue();
		Value.Ai.bankLimit = pts.Instrumentation.Pfd.bankLimit.getValue();
		Value.Ai.pitch = pts.Orientation.pitchDeg.getValue();
		Value.Ai.roll = pts.Orientation.rollDeg.getValue();
		
		AICenter = me["AI_center"].getCenter();
		
		me.aiHorizonTrans.setTranslation(0, Value.Ai.pitch * 10.246);
		me.aiHorizonRot.setRotation(-Value.Ai.roll * D2R, AICenter);
		
		me["AI_slipskid"].setTranslation(pts.Instrumentation.Pfd.slipSkid.getValue() * 7, 0);
		me["AI_bank"].setRotation(-Value.Ai.roll * D2R);
		
		me["AI_banklimit_L"].setRotation(Value.Ai.bankLimit * -D2R);
		me["AI_banklimit_R"].setRotation(Value.Ai.bankLimit * D2R);
		
		if (abs(Value.Ai.roll) >= 30.5) {
			me["AI_overbank_index"].show();
		} else {
			me["AI_overbank_index"].hide();
		}
		
		if (afs.Output.vsFpa.getBoolValue()) {
			me.AI_fpv_trans.setTranslation(math.clamp(pts.Instrumentation.Pfd.trackHdgDiff.getValue(), -20, 20) * 10.246, math.clamp(Value.Ai.alpha, -20, 20) * 10.246);
			me.AI_fpv_rot.setRotation(-Value.Ai.roll * D2R, AICenter);
			me["AI_fpv"].setRotation(Value.Ai.roll * D2R); # It shouldn't be rotated, only the axis should be
			me["AI_fpv"].show();
		} else {
			me["AI_fpv"].hide();
		}
		
		if (afs.Output.vert.getValue() == 5) {
			me.AI_fpd_trans.setTranslation(0, (Value.Ai.pitch - afs.Input.fpa.getValue()) * 10.246);
			me.AI_fpd_rot.setRotation(-Value.Ai.roll * D2R, AICenter);
			me["AI_fpd"].show();
		} else {
			me["AI_fpd"].hide();
		}
		
		me["AI_alphalim"].setTranslation(0, math.clamp(16 - Value.Ai.alpha, -20, 20) * -10.246);
		if (Value.Ai.alpha >= 15.5) {
			me["AI_alphalim"].setColor(1,0,0);
		} else {
			me["AI_alphalim"].setColor(0.2156,0.5019,0.6627);
		}
		
		me["AI_arrow_up"].setRotation(math.clamp(-Value.Ai.roll, -45, 45) * D2R);
		me["AI_arrow_dn"].setRotation(math.clamp(-Value.Ai.roll, -45, 45) * D2R);
		if (Value.Ai.pitch > 25) {
			me["AI_arrow_up"].show();
			me["AI_arrow_dn"].hide();
		} else if (Value.Ai.pitch < -15) {
			me["AI_arrow_up"].hide();
			me["AI_arrow_dn"].show();
		} else {
			me["AI_arrow_up"].hide();
			me["AI_arrow_dn"].hide();
		}
	},
};

var canvasPfd1 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvasPfd1, canvasBase]};
		m.init(canvas_group, file);
		
		return m;
	},
	update: func() {
		# Provide the value to here and the base
		Value.Afs.fd1 = afs.Output.fd1.getBoolValue();
		
		# FD
		if (Value.Afs.fd1) {
			me["FD_pitch"].show();
			me["FD_roll"].show();
			
			me["FD_pitch"].setTranslation(0, -afs.Fd.pitchBar.getValue() * 3.8);
			me["FD_roll"].setTranslation(afs.Fd.rollBar.getValue() * 2.2, 0);
		} else {
			me["FD_pitch"].hide();
			me["FD_roll"].hide();
		}
		
		me.updateBase();
	},
};

var canvasPfd2 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvasPfd2, canvasBase]};
		m.init(canvas_group, file);
		
		return m;
	},
	update: func() {
		# Provide the value to here and the base
		Value.Afs.fd2 = afs.Output.fd2.getBoolValue();
		
		# FD
		if (Value.Afs.fd2) {
			me["FD_pitch"].show();
			me["FD_roll"].show();
			
			me["FD_pitch"].setTranslation(0, -afs.Fd.pitchBar.getValue() * 3.8);
			me["FD_roll"].setTranslation(afs.Fd.rollBar.getValue() * 2.2, 0);
		} else {
			me["FD_pitch"].hide();
			me["FD_roll"].hide();
		}
		
		me.updateBase();
	},
};

var canvasPfd1Error = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}
		
		me.page = canvas_group;
		
		return me;
	},
	new: func(canvas_group, file) {
		var m = {parents: [canvasPfd1Error]};
		m.init(canvas_group, file);
		
		return m;
	},
	getKeys: func() {
		return ["Error_Code"];
	},
	update: func() {
		me["Error_Code"].setText(pts.Systems.Acconfig.errorCode.getValue());
	},
};

var canvasPfd2Error = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}
		
		me.page = canvas_group;
		
		return me;
	},
	new: func(canvas_group, file) {
		var m = {parents: [canvasPfd2Error]};
		m.init(canvas_group, file);
		
		return m;
	},
	getKeys: func() {
		return ["Error_Code"];
	},
	update: func() {
		me["Error_Code"].setText(pts.Systems.Acconfig.errorCode.getValue());
	},
};

var init = func() {
	pfd1Display = canvas.new({
		"name": "PFD1",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	pfd2Display = canvas.new({
		"name": "PFD2",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	
	pfd1Display.addPlacement({"node": "pfd1.screen"});
	pfd2Display.addPlacement({"node": "pfd2.screen"});
	
	var pfd1Group = pfd1Display.createGroup();
	var pfd1ErrorGroup = pfd1Display.createGroup();
	var pfd2Group = pfd2Display.createGroup();
	var pfd2ErrorGroup = pfd2Display.createGroup();
	
	pfd1 = canvasPfd1.new(pfd1Group, "Aircraft/MD-11/Models/Cockpit/Instruments/PFD/res/PFD.svg");
	pfd1Error = canvasPfd1Error.new(pfd1ErrorGroup, "Aircraft/MD-11/Models/Cockpit/Instruments/PFD/res/Error.svg");
	pfd2 = canvasPfd2.new(pfd2Group, "Aircraft/MD-11/Models/Cockpit/Instruments/PFD/res/PFD.svg");
	pfd2Error = canvasPfd2Error.new(pfd2ErrorGroup, "Aircraft/MD-11/Models/Cockpit/Instruments/PFD/res/Error.svg");
	
	pfdUpdate.start();
	
	if (pts.Systems.Acconfig.Options.pfdRate.getValue() > 1) {
		rateApply();
	}
}

var rateApply = func() {
	pfdUpdate.restart(pts.Systems.Acconfig.Options.pfdRate.getValue() * 0.05);
}

var pfdUpdate = maketimer(0.05, func() {
	canvasBase.update();
});

var showPfd1 = func() {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(pfd1Display);
	dlg.set("title", "Captain's PFD");
}

var showPfd2 = func() {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(pfd2Display);
	dlg.set("title", "First Officers's PFD");
}

var roundAbout = func(x) { # Unused but left here for reference
	var y = x - int(x);
	return y < 0.5 ? int(x) : 1 + int(x);
};

var roundAboutAlt = func(x) { # For altitude tape numbers
	var y = x * 0.2 - int(x * 0.2);
	return y < 0.5 ? 5 * int(x * 0.2) : 5 + 5 * int(x * 0.2);
};
