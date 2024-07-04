# McDonnell Douglas MD-11 EAD
# Copyright (c) 2024 Josh Davidson (Octal450)

var display = nil;
var geDials = nil;
var geTapes = nil;
var pwDials = nil;
var pwTapes = nil;

var Value = {
	barRest: 293,
	Du: {
		eprLimit: 0,
		n1Limit: 0,
	},
	egtScale: 1000,
	engType: "GE",
	Fadec: {
		activeMode: "T/O",
		egt: [0, 0, 0],
		engPowered: [0, 0, 0],
		epr: [0, 0, 0],
		eprFixed: [0, 0, 0],
		eprLimit: 0,
		eprLimitFixed: 0,
		n1: [0, 0, 0],
		n1Limit: 0,
		n1LimitFixed: 0,
		n2: [0, 0, 0],
		rating: "62K",
		revState: [0, 0, 0],
	},
	Ignition: {
		starter: [0, 0, 0],
	},
	Misc: {
		annunTestWow: 0,
		wow: 0,
	},
	needleRest: -44 * D2R,
	tat: 0,
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
		geDials.page.hide();
		geTapes.page.hide();
		pwDials.page.hide();
		pwTapes.page.hide();
		
		Value.engType = pts.Options.eng.getValue();
	},
	update: func() {
		if (systems.DUController.updateEad) {
			if (systems.DUController.eadType == "PW-Tapes") {
				pwTapes.update();
			} else if (systems.DUController.eadType == "GE-Tapes") {
				geTapes.update();
			} else if (systems.DUController.eadType == "PW-Dials") {
				pwDials.update();
			} else {
				geDials.update();
			}
		}
	},
	updateBase: func() {
		# Dials vs Tapes Specific
		Value.Ignition.starter[0] = systems.IGNITION.starter1.getBoolValue();
		Value.Ignition.starter[1] = systems.IGNITION.starter2.getBoolValue();
		Value.Ignition.starter[2] = systems.IGNITION.starter3.getBoolValue();
		
		if (systems.DUController.eadType == "GE-Tapes" or systems.DUController.eadType == "PW-Tapes") {
			me.updateBaseTapes();
		} else {
			me.updateBaseDials();
		}
		
		# FF
		me["FF1"].setText(sprintf("%d", math.round(pts.Engines.Engine.ffActual[0].getValue(), 10)));
		me["FF2"].setText(sprintf("%d", math.round(pts.Engines.Engine.ffActual[1].getValue(), 10)));
		me["FF3"].setText(sprintf("%d", math.round(pts.Engines.Engine.ffActual[2].getValue(), 10)));
		
		if (systems.ENGINE.cutoffSwitch[0].getBoolValue()) {
			me["FF1"].hide();
			me["FFOff1"].show();
		} else {
			me["FFOff1"].hide();
			me["FF1"].show();
		}
		
		if (systems.ENGINE.cutoffSwitch[1].getBoolValue()) {
			me["FF2"].hide();
			me["FFOff2"].show();
		} else {
			me["FFOff2"].hide();
			me["FF2"].show();
		}
		
		if (systems.ENGINE.cutoffSwitch[2].getBoolValue()) {
			me["FF3"].hide();
			me["FFOff3"].show();
		} else {
			me["FFOff3"].hide();
			me["FF3"].show();
		}
		
		# TAT Indication
		Value.tat = math.round(pts.Fdm.JSBsim.Propulsion.tatC.getValue());
		if (Value.tat < 0) {
			me["TAT"].setText(sprintf("%2.0f", Value.tat) ~ "gC");
		} else {
			me["TAT"].setText("+" ~ sprintf("%2.0f", Value.tat) ~ "gC");
		}
		
		# Reversers
		if (Value.Fadec.revState[0] != 0 and Value.Fadec.engPowered[0]) {
			me["REV1"].show();
		} else {
			me["REV1"].hide();
		}
		
		if (Value.Fadec.revState[0] == 2) {
			me["REV1"].setText("REV");
			if (!Value.Misc.wow) {
				me["REV1"].setColor(1, 0, 0);
			} else {
				me["REV1"].setColor(0, 1, 0);
			}
		} else {
			me["REV1"].setText("U/L");
			if (!Value.Misc.wow) {
				me["REV1"].setColor(1, 0, 0);
			} else {
				me["REV1"].setColor(0.9412, 0.7255, 0);
			}
		}
		
		if (Value.Fadec.revState[1] != 0 and Value.Fadec.engPowered[1]) {
			me["REV2"].show();
		} else {
			me["REV2"].hide();
		}
		
		if (Value.Fadec.revState[1] == 2) {
			me["REV2"].setText("REV");
			if (!Value.Misc.wow) {
				me["REV2"].setColor(1, 0, 0);
			} else {
				me["REV2"].setColor(0, 1, 0);
			}
		} else {
			me["REV2"].setText("U/L");
			if (!Value.Misc.wow) {
				me["REV2"].setColor(1, 0, 0);
			} else {
				me["REV2"].setColor(0.9412, 0.7255, 0);
			}
		}
		
		if (Value.Fadec.revState[2] != 0 and Value.Fadec.engPowered[2]) {
			me["REV3"].show();
		} else {
			me["REV3"].hide();
		}
		
		if (Value.Fadec.revState[2] == 2) {
			me["REV3"].setText("REV");
			if (!Value.Misc.wow) {
				me["REV3"].setColor(1, 0, 0);
			} else {
				me["REV3"].setColor(0, 1, 0);
			}
		} else {
			me["REV3"].setText("U/L");
			if (!Value.Misc.wow) {
				me["REV3"].setColor(1, 0, 0);
			} else {
				me["REV3"].setColor(0.9412, 0.7255, 0);
			}
		}
		
		# Lower Right Warnings
		if (pts.Instrumentation.Ead.configWarn.getBoolValue()) {
			me["Config"].show();
		} else {
			me["Config"].hide();
		}
	},
	updateBaseDials: func() {
		# EGT
		if (Value.Fadec.engPowered[0]) {
			me["EGT1"].setText(sprintf("%d", pts.Engines.Engine.egtActual[0].getValue()));
			me["EGT1_needle"].setRotation(pts.Instrumentation.Ead.egt[0].getValue() * D2R);
			
			if (systems.IGNITION.ign1.getBoolValue()) {
				me["EGT1_ignition"].show();
			} else {
				me["EGT1_ignition"].hide();
			}
			
			if (Value.Ignition.starter[0]) {
				me["EGT1_redstart"].show();
			} else {
				me["EGT1_redstart"].hide();
			}
			
			me["EGT1"].show();
			me["EGT1_needle"].show();
			me["EGT1_redline"].show();
			me["EGT1_yline"].show();
		} else {
			me["EGT1"].hide();
			me["EGT1_ignition"].hide();
			me["EGT1_needle"].hide();
			me["EGT1_redline"].hide();
			me["EGT1_redstart"].hide();
			me["EGT1_yline"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			me["EGT2"].setText(sprintf("%d", pts.Engines.Engine.egtActual[1].getValue()));
			me["EGT2_needle"].setRotation(pts.Instrumentation.Ead.egt[1].getValue() * D2R);
			
			if (systems.IGNITION.ign2.getBoolValue()) {
				me["EGT2_ignition"].show();
			} else {
				me["EGT2_ignition"].hide();
			}
			
			if (Value.Ignition.starter[1]) {
				me["EGT2_redstart"].show();
			} else {
				me["EGT2_redstart"].hide();
			}
			
			me["EGT2"].show();
			me["EGT2_needle"].show();
			me["EGT2_redline"].show();
			me["EGT2_yline"].show();
		} else {
			me["EGT2"].hide();
			me["EGT2_ignition"].hide();
			me["EGT2_needle"].hide();
			me["EGT2_redline"].hide();
			me["EGT2_redstart"].hide();
			me["EGT2_yline"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			me["EGT3"].setText(sprintf("%d", pts.Engines.Engine.egtActual[2].getValue()));
			me["EGT3_needle"].setRotation(pts.Instrumentation.Ead.egt[2].getValue() * D2R);
			
			if (systems.IGNITION.ign3.getBoolValue()) {
				me["EGT3_ignition"].show();
			} else {
				me["EGT3_ignition"].hide();
			}
			
			if (Value.Ignition.starter[2]) {
				me["EGT3_redstart"].show();
			} else {
				me["EGT3_redstart"].hide();
			}
			
			me["EGT3"].show();
			me["EGT3_needle"].show();
			me["EGT3_redline"].show();
			me["EGT3_yline"].show();
		} else {
			me["EGT3"].hide();
			me["EGT3_ignition"].hide();
			me["EGT3_needle"].hide();
			me["EGT3_redline"].hide();
			me["EGT3_redstart"].hide();
			me["EGT3_yline"].hide();
		}
		
		# N2
		if (Value.Fadec.engPowered[0]) {
			Value.Fadec.n2[0] = pts.Engines.Engine.n2Actual[0].getValue();
			
			if (Value.Fadec.n2[0] < 1.8) {
				Value.Fadec.n2[0] = 0;
				me["N21_needle"].setRotation(Value.needleRest);
			} else {
				me["N21_needle"].setRotation(pts.Instrumentation.Ead.n2[0].getValue() * D2R);
			}
			
			me["N21"].setText(sprintf("%d", Value.Fadec.n2[0] + 0.05));
			me["N21_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n2[0] + 0.05, 1))));
			
			if (Value.Ignition.starter[0] and systems.IGNITION.cutoff1.getBoolValue()) {
				me["N21_cline"].show();
			} else {
				me["N21_cline"].hide();
			}
			
			me["N21"].show();
			me["N21_decpnt"].show();
			me["N21_decimal"].show();
			me["N21_needle"].show();
			me["N21_redline"].show();
		} else {
			me["N21"].hide();
			me["N21_cline"].hide();
			me["N21_decpnt"].hide();
			me["N21_decimal"].hide();
			me["N21_needle"].hide();
			me["N21_redline"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			Value.Fadec.n2[1] = pts.Engines.Engine.n2Actual[1].getValue();
			
			if (Value.Fadec.n2[1] < 1.8) {
				Value.Fadec.n2[1] = 0;
				me["N22_needle"].setRotation(Value.needleRest);
			} else {
				me["N22_needle"].setRotation(pts.Instrumentation.Ead.n2[1].getValue() * D2R);
			}
			
			me["N22"].setText(sprintf("%d", Value.Fadec.n2[1] + 0.05));
			me["N22_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n2[1] + 0.05, 1))));
			
			if (Value.Ignition.starter[1] and systems.IGNITION.cutoff2.getBoolValue()) {
				me["N22_cline"].show();
			} else {
				me["N22_cline"].hide();
			}
			
			me["N22"].show();
			me["N22_decpnt"].show();
			me["N22_decimal"].show();
			me["N22_needle"].show();
			me["N22_redline"].show();
		} else {
			me["N22"].hide();
			me["N22_cline"].hide();
			me["N22_decpnt"].hide();
			me["N22_decimal"].hide();
			me["N22_needle"].hide();
			me["N22_redline"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			Value.Fadec.n2[2] = pts.Engines.Engine.n2Actual[2].getValue();
			
			if (Value.Fadec.n2[2] < 1.8) {
				Value.Fadec.n2[2] = 0;
				me["N23_needle"].setRotation(Value.needleRest);
			} else {
				me["N23_needle"].setRotation(pts.Instrumentation.Ead.n2[2].getValue() * D2R);
			}
			
			me["N23"].setText(sprintf("%d", Value.Fadec.n2[2] + 0.05));
			me["N23_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n2[2] + 0.05, 1))));
			
			if (Value.Ignition.starter[2] and systems.IGNITION.cutoff3.getBoolValue()) {
				me["N23_cline"].show();
			} else {
				me["N23_cline"].hide();
			}
			
			me["N23"].show();
			me["N23_decpnt"].show();
			me["N23_decimal"].show();
			me["N23_needle"].show();
			me["N23_redline"].show();
		} else {
			me["N23"].hide();
			me["N23_cline"].hide();
			me["N23_decpnt"].hide();
			me["N23_decimal"].hide();
			me["N23_needle"].hide();
			me["N23_redline"].hide();
		}
	},
	updateBaseTapes: func() {
		if (Value.engType == "PW") {
			Value.egtScale = 700;
		} else {
			Value.egtScale = 1000;
		}
		
		# EGT
		if (Value.Fadec.engPowered[0]) {
			Value.Fadec.egt[0] = pts.Engines.Engine.egtActual[0].getValue();
			
			me["EGT1"].setText(sprintf("%d", Value.Fadec.egt[0]));
			me["EGT1_bar"].setTranslation(0, Value.Fadec.egt[0] / Value.egtScale * -293);
			
			if (systems.IGNITION.ign1.getBoolValue()) {
				me["EGT1_ignition"].show();
			} else {
				me["EGT1_ignition"].hide();
			}
			
			if (Value.Ignition.starter[0]) {
				me["EGT1_redstart"].show();
			} else {
				me["EGT1_redstart"].hide();
			}
			
			me["EGT1"].show();
			me["EGT1_bar"].show();
			me["EGT1_redline"].show();
			me["EGT1_yline"].show();
		} else {
			me["EGT1"].hide();
			me["EGT1_bar"].hide();
			me["EGT1_ignition"].hide();
			me["EGT1_redline"].hide();
			me["EGT1_redstart"].hide();
			me["EGT1_yline"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			Value.Fadec.egt[1] = pts.Engines.Engine.egtActual[1].getValue();
			
			me["EGT2"].setText(sprintf("%d", Value.Fadec.egt[1]));
			me["EGT2_bar"].setTranslation(0, Value.Fadec.egt[1] / Value.egtScale * -293);
			
			if (systems.IGNITION.ign2.getBoolValue()) {
				me["EGT2_ignition"].show();
			} else {
				me["EGT2_ignition"].hide();
			}
			
			if (Value.Ignition.starter[1]) {
				me["EGT2_redstart"].show();
			} else {
				me["EGT2_redstart"].hide();
			}
			
			me["EGT2"].show();
			me["EGT2_bar"].show();
			me["EGT2_redline"].show();
			me["EGT2_yline"].show();
		} else {
			me["EGT2"].hide();
			me["EGT2_bar"].hide();
			me["EGT2_ignition"].hide();
			me["EGT2_redline"].hide();
			me["EGT2_redstart"].hide();
			me["EGT2_yline"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			Value.Fadec.egt[2] = pts.Engines.Engine.egtActual[2].getValue();
			
			me["EGT3"].setText(sprintf("%d", Value.Fadec.egt[2]));
			me["EGT3_bar"].setTranslation(0, Value.Fadec.egt[2] / Value.egtScale * -293);
			
			if (systems.IGNITION.ign3.getBoolValue()) {
				me["EGT3_ignition"].show();
			} else {
				me["EGT3_ignition"].hide();
			}
			
			if (Value.Ignition.starter[2]) {
				me["EGT3_redstart"].show();
			} else {
				me["EGT3_redstart"].hide();
			}
			
			me["EGT3"].show();
			me["EGT3_bar"].show();
			me["EGT3_redline"].show();
			me["EGT3_yline"].show();
		} else {
			me["EGT3"].hide();
			me["EGT3_bar"].hide();
			me["EGT3_ignition"].hide();
			me["EGT3_redline"].hide();
			me["EGT3_redstart"].hide();
			me["EGT3_yline"].hide();
		}
		
		# N2
		if (Value.Fadec.engPowered[0]) {
			Value.Fadec.n2[0] = pts.Engines.Engine.n2Actual[0].getValue();
			
			if (Value.Fadec.n2[0] < 1.8) {
				Value.Fadec.n2[0] = 0;
				me["N21_bar"].setTranslation(0, Value.barRest);
			} else {
				me["N21_bar"].setTranslation(0, Value.Fadec.n2[0] / 120 * -209);
			}
			
			me["N21"].setText(sprintf("%d", Value.Fadec.n2[0] + 0.05));
			me["N21_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n2[0] + 0.05, 1))));
			
			if (Value.Ignition.starter[0] and systems.IGNITION.cutoff1.getBoolValue()) {
				me["N21_cline"].show();
			} else {
				me["N21_cline"].hide();
			}
			
			me["N21_bar"].show();
			me["N21_group"].show();
			me["N21_redline"].show();
		} else {
			me["N21_bar"].hide();
			me["N21_cline"].hide();
			me["N21_group"].hide();
			me["N21_redline"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			Value.Fadec.n2[1] = pts.Engines.Engine.n2Actual[1].getValue();
			
			if (Value.Fadec.n2[1] < 1.8) {
				Value.Fadec.n2[1] = 0;
				me["N22_bar"].setTranslation(0, Value.barRest);
			} else {
				me["N22_bar"].setTranslation(0, Value.Fadec.n2[1] / 120 * -209);
			}
			
			me["N22"].setText(sprintf("%d", Value.Fadec.n2[1] + 0.05));
			me["N22_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n2[1] + 0.05, 1))));
			
			if (Value.Ignition.starter[1] and systems.IGNITION.cutoff2.getBoolValue()) {
				me["N22_cline"].show();
			} else {
				me["N22_cline"].hide();
			}
			
			me["N22_bar"].show();
			me["N22_group"].show();
			me["N22_redline"].show();
		} else {
			me["N22_bar"].hide();
			me["N22_cline"].hide();
			me["N22_group"].hide();
			me["N22_redline"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			Value.Fadec.n2[2] = pts.Engines.Engine.n2Actual[2].getValue();
			
			if (Value.Fadec.n2[2] < 1.8) {
				Value.Fadec.n2[2] = 0;
				me["N23_bar"].setTranslation(0, Value.barRest);
			} else {
				me["N23_bar"].setTranslation(0, Value.Fadec.n2[2] / 120 * -209);
			}
			
			me["N23"].setText(sprintf("%d", Value.Fadec.n2[2] + 0.05));
			me["N23_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n2[2] + 0.05, 1))));
			
			if (Value.Ignition.starter[2] and systems.IGNITION.cutoff3.getBoolValue()) {
				me["N23_cline"].show();
			} else {
				me["N23_cline"].hide();
			}
			
			me["N23_bar"].show();
			me["N23_group"].show();
			me["N23_redline"].show();
		} else {
			me["N23_bar"].hide();
			me["N23_cline"].hide();
			me["N23_group"].hide();
			me["N23_redline"].hide();
		}
	},
};

var canvasGeDials = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasGeDials, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Alert_error", "Config", "EGT1", "EGT1_error", "EGT1_ignition", "EGT1_needle", "EGT1_redline", "EGT1_redstart", "EGT1_yline", "EGT2", "EGT2_error", "EGT2_ignition", "EGT2_needle", "EGT2_redline", "EGT2_redstart", "EGT2_yline", "EGT3",
		"EGT3_error", "EGT3_ignition", "EGT3_needle", "EGT3_redline", "EGT3_redstart", "EGT3_yline", "FF1", "FF1_error", "FF2", "FF2_error", "FF3", "FF3_error", "FFOff1", "FFOff2", "FFOff3", "N11_box", "N11_decimal", "N11_decpnt", "N11_error", "N11_hundreds",
		"N11_lim", "N11_needle", "N11_ones", "N11_redline", "N11_tens", "N11_tens_zero", "N11_thr", "N12_box", "N12_decimal", "N12_decpnt", "N12_error", "N12_hundreds", "N12_lim", "N12_needle", "N12_ones", "N12_redline", "N12_tens", "N12_tens_zero", "N12_thr",
		"N13_box", "N13_decimal", "N13_decpnt", "N13_error", "N13_hundreds", "N13_lim", "N13_needle", "N13_ones", "N13_redline", "N13_tens", "N13_tens_zero", "N13_thr", "N1Lim", "N1Lim_decimal", "N1Lim_error", "N1LimMode", "N21", "N21_cline", "N21_decpnt",
		"N21_decimal", "N21_error", "N21_needle", "N21_redline", "N22", "N22_cline", "N22_decpnt", "N22_decimal", "N22_error", "N22_needle", "N22_redline", "N23", "N23_cline", "N23_decpnt", "N23_decimal", "N23_error", "N23_needle", "N23_redline", "REV1", "REV2",
		"REV3", "TAT", "TAT_error"];
	},
	update: func() {
		# Provide the value to here and the base
		Value.Fadec.engPowered[0] = systems.FADEC.engPowered[0].getBoolValue();
		Value.Fadec.engPowered[1] = systems.FADEC.engPowered[1].getBoolValue();
		Value.Fadec.engPowered[2] = systems.FADEC.engPowered[2].getBoolValue();
		Value.Fadec.revState[0] = systems.FADEC.revState[0].getValue();
		Value.Fadec.revState[1] = systems.FADEC.revState[1].getValue();
		Value.Fadec.revState[2] = systems.FADEC.revState[2].getValue();
		Value.Misc.wow = pts.Fdm.JSBsim.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Alert_error"].show();
			me["EGT1_error"].show();
			me["EGT2_error"].show();
			me["EGT3_error"].show();
			me["FF1_error"].show();
			me["FF2_error"].show();
			me["FF3_error"].show();
			me["N11_error"].show();
			me["N12_error"].show();
			me["N13_error"].show();
			me["N1Lim_error"].show();
			me["N21_error"].show();
			me["N22_error"].show();
			me["N23_error"].show();
			me["TAT_error"].show();
		} else {
			me["Alert_error"].hide();
			me["EGT1_error"].hide();
			me["EGT2_error"].hide();
			me["EGT3_error"].hide();
			me["FF1_error"].hide();
			me["FF2_error"].hide();
			me["FF3_error"].hide();
			me["N11_error"].hide();
			me["N12_error"].hide();
			me["N13_error"].hide();
			me["N1Lim_error"].hide();
			me["N21_error"].hide();
			me["N22_error"].hide();
			me["N23_error"].hide();
			me["TAT_error"].hide();
		}
		
		# N1 Limit
		Value.Fadec.activeMode = systems.FADEC.Limit.activeMode.getValue();
		Value.Fadec.n1Limit = systems.FADEC.Limit.active.getValue();
		Value.Fadec.n1LimitFixed = Value.Fadec.n1Limit + 0.05;
		
		if (Value.Fadec.activeMode == "T/O" and fms.FlightData.flexActive) {
			me["N1LimMode"].setText("T/O FLEX ( " ~ sprintf("%d", fms.FlightData.flexTemp) ~ "gC)");
		} else {
			me["N1LimMode"].setText(Value.Fadec.activeMode ~ " LIM");
		}
		
		me["N1Lim"].setText(sprintf("%d", math.floor(Value.Fadec.n1LimitFixed)));
		me["N1Lim_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n1LimitFixed, 1))));
		
		Value.Du.n1Limit = pts.Instrumentation.Ead.n1Limit.getValue();
		me["N11_lim"].setRotation(Value.Du.n1Limit * D2R);
		me["N12_lim"].setRotation(Value.Du.n1Limit * D2R);
		me["N13_lim"].setRotation(Value.Du.n1Limit * D2R);
		
		# N1
		if (Value.Fadec.engPowered[0]) {
			Value.Fadec.n1[0] = pts.Engines.Engine.n1Actual[0].getValue();
			
			if (Value.Fadec.n1[0] < 1.8) {
				Value.Fadec.n1[0] = 0;
				me["N11_needle"].setRotation(Value.needleRest);
			} else {
				me["N11_needle"].setRotation(pts.Instrumentation.Ead.n1[0].getValue() * D2R);
			}
			
			if (Value.Fadec.n1[0] < 99) { # Prepare to show the zero at 100
				me["N11_tens_zero"].hide();
			} else {
				me["N11_tens_zero"].show();
			}
			
			me["N11_hundreds"].setTranslation(0, genevaN1Hundreds(num(right(sprintf("%07.3f", Value.Fadec.n1[0]), 7))) * 34);
			me["N11_tens"].setTranslation(0, genevaN1Tens(num(right(sprintf("%06.3f", Value.Fadec.n1[0]), 6))) * 34);
			me["N11_ones"].setTranslation(0, genevaN1Ones(num(right(sprintf("%05.3f", Value.Fadec.n1[0]), 5))) * 34);
			me["N11_decimal"].setTranslation(0, (10 * math.round(math.mod(Value.Fadec.n1[0], 1), 0.001) * 34));
			
			me["N11_thr"].setRotation(pts.Instrumentation.Ead.n1Thr[0].getValue() * D2R);
			
			me["N11_box"].show();
			me["N11_decimal"].show();
			me["N11_decpnt"].show();
			me["N11_hundreds"].show();
			me["N11_needle"].show();
			me["N11_ones"].show();
			me["N11_redline"].show();
			me["N11_tens"].show();
			me["N11_thr"].show();
		} else {
			me["N11_box"].hide();
			me["N11_decimal"].hide();
			me["N11_decpnt"].hide();
			me["N11_hundreds"].hide();
			me["N11_needle"].hide();
			me["N11_ones"].hide();
			me["N11_redline"].hide();
			me["N11_tens"].hide();
			me["N11_thr"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			Value.Fadec.n1[1] = pts.Engines.Engine.n1Actual[1].getValue();
			
			if (Value.Fadec.n1[1] < 1.8) {
				Value.Fadec.n1[1] = 0;
				me["N12_needle"].setRotation(Value.needleRest);
			} else {
				me["N12_needle"].setRotation(pts.Instrumentation.Ead.n1[1].getValue() * D2R);
			}
			
			if (Value.Fadec.n1[1] < 99) { # Prepare to show the zero at 100
				me["N12_tens_zero"].hide();
			} else {
				me["N12_tens_zero"].show();
			}
			
			me["N12_hundreds"].setTranslation(0, genevaN1Hundreds(num(right(sprintf("%07.3f", Value.Fadec.n1[1]), 7))) * 34);
			me["N12_tens"].setTranslation(0, genevaN1Tens(num(right(sprintf("%06.3f", Value.Fadec.n1[1]), 6))) * 34);
			me["N12_ones"].setTranslation(0, genevaN1Ones(num(right(sprintf("%05.3f", Value.Fadec.n1[1]), 5))) * 34);
			me["N12_decimal"].setTranslation(0, (10 * math.round(math.mod(Value.Fadec.n1[1], 1), 0.001) * 34));
			
			me["N12_thr"].setRotation(pts.Instrumentation.Ead.n1Thr[1].getValue() * D2R);
			
			me["N12_box"].show();
			me["N12_decimal"].show();
			me["N12_decpnt"].show();
			me["N12_hundreds"].show();
			me["N12_needle"].show();
			me["N12_ones"].show();
			me["N12_redline"].show();
			me["N12_tens"].show();
			me["N12_thr"].show();
		} else {
			me["N12_box"].hide();
			me["N12_decimal"].hide();
			me["N12_decpnt"].hide();
			me["N12_hundreds"].hide();
			me["N12_needle"].hide();
			me["N12_ones"].hide();
			me["N12_redline"].hide();
			me["N12_tens"].hide();
			me["N12_thr"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			Value.Fadec.n1[2] = pts.Engines.Engine.n1Actual[2].getValue();
			
			if (Value.Fadec.n1[2] < 1.8) {
				Value.Fadec.n1[2] = 0;
				me["N13_needle"].setRotation(Value.needleRest);
			} else {
				me["N13_needle"].setRotation(pts.Instrumentation.Ead.n1[2].getValue() * D2R);
			}
			
			if (Value.Fadec.n1[2] < 99) { # Prepare to show the zero at 100
				me["N13_tens_zero"].hide();
			} else {
				me["N13_tens_zero"].show();
			}
			
			me["N13_hundreds"].setTranslation(0, genevaN1Hundreds(num(right(sprintf("%07.3f", Value.Fadec.n1[2]), 7))) * 34);
			me["N13_tens"].setTranslation(0, genevaN1Tens(num(right(sprintf("%06.3f", Value.Fadec.n1[2]), 6))) * 34);
			me["N13_ones"].setTranslation(0, genevaN1Ones(num(right(sprintf("%05.3f", Value.Fadec.n1[2]), 5))) * 34);
			me["N13_decimal"].setTranslation(0, (10 * math.round(math.mod(Value.Fadec.n1[2], 1), 0.001) * 34));
			
			me["N13_thr"].setRotation(pts.Instrumentation.Ead.n1Thr[2].getValue() * D2R);
			
			me["N13_box"].show();
			me["N13_decimal"].show();
			me["N13_decpnt"].show();
			me["N13_hundreds"].show();
			me["N13_needle"].show();
			me["N13_ones"].show();
			me["N13_redline"].show();
			me["N13_tens"].show();
			me["N13_thr"].show();
		} else {
			me["N13_box"].hide();
			me["N13_decimal"].hide();
			me["N13_decpnt"].hide();
			me["N13_hundreds"].hide();
			me["N13_needle"].hide();
			me["N13_ones"].hide();
			me["N13_redline"].hide();
			me["N13_tens"].hide();
			me["N13_thr"].hide();
		}
		
		me.updateBase();
	},
};

var canvasGeTapes = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasGeTapes, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Alert_error", "Config", "EGT_bars", "EGT1", "EGT1_bar", "EGT1_error", "EGT1_ignition", "EGT1_redline", "EGT1_redstart", "EGT1_yline", "EGT2", "EGT2_bar", "EGT2_error", "EGT2_ignition", "EGT2_redline", "EGT2_redstart", "EGT2_yline", "EGT3",
		"EGT3_bar", "EGT3_error", "EGT3_ignition", "EGT3_redline", "EGT3_redstart", "EGT3_yline", "FF1", "FF1_error", "FF2", "FF2_error", "FF3", "FF3_error", "FFOff1", "FFOff2", "FFOff3", "N1_bars", "N11", "N11_bar", "N11_decimal", "N11_error", "N11_group",
		"N11_lim", "N11_redline", "N11_thr", "N12", "N12_bar", "N12_decimal", "N12_error", "N12_group", "N12_lim", "N12_redline", "N12_thr", "N13", "N13_bar", "N13_decimal", "N13_error", "N13_group", "N13_lim", "N13_redline", "N13_thr", "N1Lim", "N1Lim_decimal",
		"N1Lim_error", "N1LimMode", "N2_bars", "N21", "N21_bar", "N21_cline", "N21_decimal", "N21_error", "N21_group", "N21_redline", "N22", "N22_bar", "N22_cline", "N22_decimal", "N22_error", "N22_group", "N22_redline", "N23", "N23_bar", "N23_cline",
		"N23_decimal", "N23_error", "N23_group", "N23_redline", "REV1", "REV2", "REV3", "TAT", "TAT_error"];
	},
	update: func() {
		# Provide the value to here and the base
		Value.Fadec.engPowered[0] = systems.FADEC.engPowered[0].getBoolValue();
		Value.Fadec.engPowered[1] = systems.FADEC.engPowered[1].getBoolValue();
		Value.Fadec.engPowered[2] = systems.FADEC.engPowered[2].getBoolValue();
		Value.Fadec.revState[0] = systems.FADEC.revState[0].getValue();
		Value.Fadec.revState[1] = systems.FADEC.revState[1].getValue();
		Value.Fadec.revState[2] = systems.FADEC.revState[2].getValue();
		Value.Misc.wow = pts.Fdm.JSBsim.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Alert_error"].show();
			me["EGT1_error"].show();
			me["EGT2_error"].show();
			me["EGT3_error"].show();
			me["FF1_error"].show();
			me["FF2_error"].show();
			me["FF3_error"].show();
			me["N11_error"].show();
			me["N12_error"].show();
			me["N13_error"].show();
			me["N1Lim_error"].show();
			me["N21_error"].show();
			me["N22_error"].show();
			me["N23_error"].show();
			me["TAT_error"].show();
		} else {
			me["Alert_error"].hide();
			me["EGT1_error"].hide();
			me["EGT2_error"].hide();
			me["EGT3_error"].hide();
			me["FF1_error"].hide();
			me["FF2_error"].hide();
			me["FF3_error"].hide();
			me["N11_error"].hide();
			me["N12_error"].hide();
			me["N13_error"].hide();
			me["N1Lim_error"].hide();
			me["N21_error"].hide();
			me["N22_error"].hide();
			me["N23_error"].hide();
			me["TAT_error"].hide();
		}
		
		# N1 Limit
		Value.Fadec.activeMode = systems.FADEC.Limit.activeMode.getValue();
		Value.Fadec.n1Limit = systems.FADEC.Limit.active.getValue();
		Value.Fadec.n1LimitFixed = Value.Fadec.n1Limit + 0.05;
		
		if (Value.Fadec.activeMode == "T/O" and fms.FlightData.flexActive) {
			me["N1LimMode"].setText("T/O FLEX ( " ~ sprintf("%d", fms.FlightData.flexTemp) ~ "gC)");
		} else {
			me["N1LimMode"].setText(Value.Fadec.activeMode ~ " LIM");
		}
		
		me["N1Lim"].setText(sprintf("%d", math.floor(Value.Fadec.n1LimitFixed)));
		me["N1Lim_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n1LimitFixed, 1))));
		
		me["N11_lim"].setTranslation(0, Value.Fadec.n1Limit / 120 * -293);
		me["N12_lim"].setTranslation(0, Value.Fadec.n1Limit / 120 * -293);
		me["N13_lim"].setTranslation(0, Value.Fadec.n1Limit / 120 * -293);
		
		# N1
		if (Value.Fadec.engPowered[0]) {
			Value.Fadec.n1[0] = pts.Engines.Engine.n1Actual[0].getValue();
			
			if (Value.Fadec.n1[0] < 1.8) {
				Value.Fadec.n1[0] = 0;
				me["N11_bar"].setTranslation(0, Value.barRest);
			} else {
				me["N11_bar"].setTranslation(0, Value.Fadec.n1[0] / 120 * -293);
			}
			me["N11_thr"].setTranslation(0, systems.FADEC.throttleN1[0].getValue() / 120 * -293);
			
			if (Value.Fadec.revState[0] != 0) {
				me["N11_group"].hide();
			} else {
				me["N11"].setText(sprintf("%d", Value.Fadec.n1[0] + 0.05));
				me["N11_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n1[0] + 0.05, 1))));
				me["N11_group"].show();
			}
			
			me["N11_bar"].show();
			me["N11_redline"].show();
			me["N11_thr"].show();
		} else {
			me["N11_bar"].hide();
			me["N11_group"].hide();
			me["N11_redline"].hide();
			me["N11_thr"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			Value.Fadec.n1[1] = pts.Engines.Engine.n1Actual[1].getValue();
			
			if (Value.Fadec.n1[1] < 1.8) {
				Value.Fadec.n1[1] = 0;
				me["N12_bar"].setTranslation(0, Value.barRest);
			} else {
				me["N12_bar"].setTranslation(0, Value.Fadec.n1[1] / 120 * -293);
			}
			me["N12_thr"].setTranslation(0, systems.FADEC.throttleN1[1].getValue() / 120 * -293);
			
			if (Value.Fadec.revState[1] != 0) {
				me["N12_group"].hide();
			} else {
				me["N12"].setText(sprintf("%d", Value.Fadec.n1[1] + 0.05));
				me["N12_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n1[1] + 0.05, 1))));
				me["N12_group"].show();
			}
			
			me["N12_bar"].show();
			me["N12_redline"].show();
			me["N12_thr"].show();
		} else {
			me["N12_bar"].hide();
			me["N12_group"].hide();
			me["N12_redline"].hide();
			me["N12_thr"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			Value.Fadec.n1[2] = pts.Engines.Engine.n1Actual[2].getValue();
			
			if (Value.Fadec.n1[2] < 1.8) {
				Value.Fadec.n1[2] = 0;
				me["N13_bar"].setTranslation(0, Value.barRest);
			} else {
				me["N13_bar"].setTranslation(0, Value.Fadec.n1[2] / 120 * -293);
			}
			me["N13_thr"].setTranslation(0, systems.FADEC.throttleN1[2].getValue() / 120 * -293);
			
			if (Value.Fadec.revState[2] != 0) {
				me["N13_group"].hide();
			} else {
				me["N13"].setText(sprintf("%d", Value.Fadec.n1[2] + 0.05));
				me["N13_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n1[2] + 0.05, 1))));
				me["N13_group"].show();
			}
			
			me["N13_bar"].show();
			me["N13_redline"].show();
			me["N13_thr"].show();
		} else {
			me["N13_bar"].hide();
			me["N13_group"].hide();
			me["N13_redline"].hide();
			me["N13_thr"].hide();
		}
		
		me.updateBase();
	},
};

var canvasPwDials = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasPwDials, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Alert_error", "Config", "EGT1", "EGT1_error", "EGT1_ignition", "EGT1_needle", "EGT1_redline", "EGT1_redstart", "EGT1_yline", "EGT2", "EGT2_error", "EGT2_ignition", "EGT2_needle", "EGT2_redline", "EGT2_redstart", "EGT2_yline", "EGT3",
		"EGT3_error", "EGT3_ignition", "EGT3_needle", "EGT3_redline", "EGT3_redstart", "EGT3_yline", "EGT_group", "EPR1_box", "EPR1_decpnt", "EPR1_error", "EPR1_hundreths", "EPR1_lim", "EPR1_needle", "EPR1_ones", "EPR1_tenths", "EPR1_thr", "EPR2_box",
		"EPR2_decpnt", "EPR2_error", "EPR2_hundreths", "EPR2_lim", "EPR2_needle", "EPR2_ones", "EPR2_tenths", "EPR2_thr", "EPR3_box", "EPR3_decpnt", "EPR3_error", "EPR3_hundreths", "EPR3_lim", "EPR3_needle", "EPR3_ones", "EPR3_tenths", "EPR3_thr", "EPRLim",
		"EPRLim_decimal", "EPRLim_error", "EPRLimMode", "FF1", "FF1_error", "FF2", "FF2_error", "FF3", "FF3_error", "FFOff1", "FFOff2", "FFOff3", "N11", "N11_decimal", "N11_decpnt", "N11_error", "N11_needle", "N11_redline", "N12", "N12_decimal", "N12_decpnt",
		"N12_error", "N12_needle", "N12_redline", "N13", "N13_decimal", "N13_decpnt", "N13_error", "N13_needle", "N13_redline", "N1_group", "N21", "N21_cline", "N21_decimal", "N21_decpnt", "N21_error", "N21_needle", "N21_redline", "N22", "N22_cline",
		"N22_decimal", "N22_decpnt", "N22_error", "N22_needle", "N22_redline", "N23", "N23_cline", "N23_decimal", "N23_decpnt", "N23_error", "N23_needle", "N23_redline", "REV1", "REV2", "REV3", "TAT", "TAT_error"];
	},
	setDials: func() {
		if (pts.Systems.Acconfig.Options.egtAboveN1.getBoolValue()) {
			me["EGT_group"].setTranslation(0, -153.127);
			me["N1_group"].setTranslation(0, 153.127);
		} else {
			me["EGT_group"].setTranslation(0, 0);
			me["N1_group"].setTranslation(0, 0);
		}
	},
	update: func() {
		# Provide the value to here and the base
		Value.Fadec.engPowered[0] = systems.FADEC.engPowered[0].getBoolValue();
		Value.Fadec.engPowered[1] = systems.FADEC.engPowered[1].getBoolValue();
		Value.Fadec.engPowered[2] = systems.FADEC.engPowered[2].getBoolValue();
		Value.Fadec.revState[0] = systems.FADEC.revState[0].getValue();
		Value.Fadec.revState[1] = systems.FADEC.revState[1].getValue();
		Value.Fadec.revState[2] = systems.FADEC.revState[2].getValue();
		Value.Misc.wow = pts.Fdm.JSBsim.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Alert_error"].show();
			me["EGT1_error"].show();
			me["EGT2_error"].show();
			me["EGT3_error"].show();
			me["EPR1_error"].show();
			me["EPR2_error"].show();
			me["EPR3_error"].show();
			me["EPRLim_error"].show();
			me["FF1_error"].show();
			me["FF2_error"].show();
			me["FF3_error"].show();
			me["N11_error"].show();
			me["N12_error"].show();
			me["N13_error"].show();
			me["N21_error"].show();
			me["N22_error"].show();
			me["N23_error"].show();
			me["TAT_error"].show();
		} else {
			me["Alert_error"].hide();
			me["EGT1_error"].hide();
			me["EGT2_error"].hide();
			me["EGT3_error"].hide();
			me["EPR1_error"].hide();
			me["EPR2_error"].hide();
			me["EPR3_error"].hide();
			me["EPRLim_error"].hide();
			me["FF1_error"].hide();
			me["FF2_error"].hide();
			me["FF3_error"].hide();
			me["N11_error"].hide();
			me["N12_error"].hide();
			me["N13_error"].hide();
			me["N21_error"].hide();
			me["N22_error"].hide();
			me["N23_error"].hide();
			me["TAT_error"].hide();
		}
		
		# EPR Limit
		Value.Fadec.activeMode = systems.FADEC.Limit.activeMode.getValue();
		Value.Fadec.eprLimit = systems.FADEC.Limit.active.getValue();
		Value.Fadec.eprLimitFixed = Value.Fadec.eprLimit + 0.005;
		
		if (Value.Fadec.activeMode == "T/O" or Value.Fadec.activeMode == "G/A") {
			if (systems.FADEC.Limit.pwDerate.getBoolValue()) {
				Value.Fadec.rating = "60K";
			} else {
				Value.Fadec.rating = "62K";
			}
			
			if (Value.Fadec.activeMode == "T/O" and fms.FlightData.flexActive) {
				me["EPRLimMode"].setText(Value.Fadec.rating ~ " T/O FLEX ( " ~ sprintf("%d", fms.FlightData.flexTemp) ~ "gC)");
			} else {
				me["EPRLimMode"].setText(Value.Fadec.rating ~ " " ~ Value.Fadec.activeMode ~ " LIM");
			}
		} else {
			me["EPRLimMode"].setText(Value.Fadec.activeMode ~ " LIM");
		}
		
		me["EPRLim"].setText(sprintf("%d", math.floor(Value.Fadec.eprLimitFixed)));
		me["EPRLim_decimal"].setText(sprintf("%02d", math.floor((Value.Fadec.eprLimitFixed - int(Value.Fadec.eprLimitFixed)) * 100)));
		
		Value.Du.eprLimit = pts.Instrumentation.Ead.eprLimit.getValue();
		me["EPR1_lim"].setRotation(Value.Du.eprLimit * D2R);
		me["EPR2_lim"].setRotation(Value.Du.eprLimit * D2R);
		me["EPR3_lim"].setRotation(Value.Du.eprLimit * D2R);
		
		# EPR
		if (Value.Fadec.engPowered[0]) {
			Value.Fadec.epr[0] = pts.Engines.Engine.eprActual[0].getValue();
			
			me["EPR1_ones"].setTranslation(0, genevaEprOnes(num(right(sprintf("%06.3f", Value.Fadec.epr[0] * 10), 6))) * 34);
			me["EPR1_tenths"].setTranslation(0, genevaEprTenths(num(right(sprintf("%05.3f", Value.Fadec.epr[0] * 10), 5))) * 34);
			me["EPR1_hundreths"].setTranslation(0, 10 * (math.round(math.mod(Value.Fadec.epr[0] * 10, 1), 0.0001) * 34));
			
			me["EPR1_needle"].setRotation(pts.Instrumentation.Ead.epr[0].getValue() * D2R);
			if (!systems.FADEC.n1Mode[0].getValue()) {
				me["EPR1_thr"].setRotation(pts.Instrumentation.Ead.eprThr[0].getValue() * D2R);
				me["EPR1_thr"].show();
			} else {
				me["EPR1_thr"].hide();
			}
			
			me["EPR1_box"].show();
			me["EPR1_decpnt"].show();
			me["EPR1_hundreths"].show();
			me["EPR1_needle"].show();
			me["EPR1_ones"].show();
			me["EPR1_tenths"].show();
		} else {
			me["EPR1_box"].hide();
			me["EPR1_decpnt"].hide();
			me["EPR1_hundreths"].hide();
			me["EPR1_needle"].hide();
			me["EPR1_ones"].hide();
			me["EPR1_tenths"].hide();
			me["EPR1_thr"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			Value.Fadec.epr[1] = pts.Engines.Engine.eprActual[1].getValue();
			
			me["EPR2_ones"].setTranslation(0, genevaEprOnes(num(right(sprintf("%06.3f", Value.Fadec.epr[1] * 10), 6))) * 34);
			me["EPR2_tenths"].setTranslation(0, genevaEprTenths(num(right(sprintf("%05.3f", Value.Fadec.epr[1] * 10), 5))) * 34);
			me["EPR2_hundreths"].setTranslation(0, 10 * (math.round(math.mod(Value.Fadec.epr[1] * 10, 1), 0.0001) * 34));
			
			me["EPR2_needle"].setRotation(pts.Instrumentation.Ead.epr[1].getValue() * D2R);
			if (!systems.FADEC.n1Mode[1].getValue()) {
				me["EPR2_thr"].setRotation(pts.Instrumentation.Ead.eprThr[1].getValue() * D2R);
				me["EPR2_thr"].show();
			} else {
				me["EPR2_thr"].hide();
			}
			
			me["EPR2_box"].show();
			me["EPR2_decpnt"].show();
			me["EPR2_hundreths"].show();
			me["EPR2_needle"].show();
			me["EPR2_ones"].show();
			me["EPR2_tenths"].show();
		} else {
			me["EPR2_box"].hide();
			me["EPR2_decpnt"].hide();
			me["EPR2_hundreths"].hide();
			me["EPR2_needle"].hide();
			me["EPR2_ones"].hide();
			me["EPR2_tenths"].hide();
			me["EPR2_thr"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			Value.Fadec.epr[2] = pts.Engines.Engine.eprActual[2].getValue();
			
			me["EPR3_ones"].setTranslation(0, genevaEprOnes(num(right(sprintf("%06.3f", Value.Fadec.epr[2] * 10), 6))) * 34);
			me["EPR3_tenths"].setTranslation(0, genevaEprTenths(num(right(sprintf("%05.3f", Value.Fadec.epr[2] * 10), 5))) * 34);
			me["EPR3_hundreths"].setTranslation(0, 10 * (math.round(math.mod(Value.Fadec.epr[2] * 10, 1), 0.0001) * 34));
			
			me["EPR3_needle"].setRotation(pts.Instrumentation.Ead.epr[2].getValue() * D2R);
			if (!systems.FADEC.n1Mode[2].getValue()) {
				me["EPR3_thr"].setRotation(pts.Instrumentation.Ead.eprThr[2].getValue() * D2R);
				me["EPR3_thr"].show();
			} else {
				me["EPR3_thr"].hide();
			}
			
			me["EPR3_box"].show();
			me["EPR3_decpnt"].show();
			me["EPR3_hundreths"].show();
			me["EPR3_needle"].show();
			me["EPR3_ones"].show();
			me["EPR3_tenths"].show();
		} else {
			me["EPR3_box"].hide();
			me["EPR3_decpnt"].hide();
			me["EPR3_hundreths"].hide();
			me["EPR3_needle"].hide();
			me["EPR3_ones"].hide();
			me["EPR3_tenths"].hide();
			me["EPR3_thr"].hide();
		}
		
		# N1
		if (Value.Fadec.engPowered[0]) {
			Value.Fadec.n1[0] = pts.Engines.Engine.n1Actual[0].getValue();
			
			if (Value.Fadec.n1[0] < 1.8) {
				Value.Fadec.n1[0] = 0;
				me["N11_needle"].setRotation(Value.needleRest);
			} else {
				me["N11_needle"].setRotation(pts.Instrumentation.Ead.n1[0].getValue() * D2R);
			}
			
			me["N11"].setText(sprintf("%d", Value.Fadec.n1[0] + 0.05));
			me["N11_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n1[0] + 0.05, 1))));
			
			me["N11"].show();
			me["N11_decimal"].show();
			me["N11_decpnt"].show();
			me["N11_needle"].show();
			me["N11_redline"].show();
		} else {
			me["N11"].hide();
			me["N11_decimal"].hide();
			me["N11_decpnt"].hide();
			me["N11_needle"].hide();
			me["N11_redline"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			Value.Fadec.n1[1] = pts.Engines.Engine.n1Actual[1].getValue();
			
			if (Value.Fadec.n1[1] < 1.8) {
				Value.Fadec.n1[1] = 0;
				me["N12_needle"].setRotation(Value.needleRest);
			} else {
				me["N12_needle"].setRotation(pts.Instrumentation.Ead.n1[1].getValue() * D2R);
			}
			
			me["N12"].setText(sprintf("%d", Value.Fadec.n1[1] + 0.05));
			me["N12_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n1[1] + 0.05, 1))));
			
			me["N12"].show();
			me["N12_decimal"].show();
			me["N12_decpnt"].show();
			me["N12_needle"].show();
			me["N12_redline"].show();
		} else {
			me["N12"].hide();
			me["N12_decimal"].hide();
			me["N12_decpnt"].hide();
			me["N12_needle"].hide();
			me["N12_redline"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			Value.Fadec.n1[2] = pts.Engines.Engine.n1Actual[2].getValue();
			
			if (Value.Fadec.n1[2] < 1.8) {
				Value.Fadec.n1[2] = 0;
				me["N13_needle"].setRotation(Value.needleRest);
			} else {
				me["N13_needle"].setRotation(pts.Instrumentation.Ead.n1[2].getValue() * D2R);
			}
			
			me["N13"].setText(sprintf("%d", Value.Fadec.n1[2] + 0.05));
			me["N13_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n1[2] + 0.05, 1))));
			
			me["N13"].show();
			me["N13_decimal"].show();
			me["N13_decpnt"].show();
			me["N13_needle"].show();
			me["N13_redline"].show();
		} else {
			me["N13"].hide();
			me["N13_decimal"].hide();
			me["N13_decpnt"].hide();
			me["N13_needle"].hide();
			me["N13_redline"].hide();
		}
		
		me.updateBase();
	},
};

var canvasPwTapes = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasPwTapes, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Alert_error", "Config", "EGT_bars", "EGT1", "EGT1_bar", "EGT1_error", "EGT1_ignition", "EGT1_redline", "EGT1_redstart", "EGT1_yline", "EGT2", "EGT2_bar", "EGT2_error", "EGT2_ignition", "EGT2_redline", "EGT2_redstart", "EGT2_yline", "EGT3",
		"EGT3_bar", "EGT3_error", "EGT3_ignition", "EGT3_redline", "EGT3_redstart", "EGT3_yline", "EPR_bars", "EPR1", "EPR1_bar", "EPR1_decimal", "EPR1_error", "EPR1_group", "EPR1_lim", "EPR1_thr", "EPR2", "EPR2_bar", "EPR2_decimal", "EPR2_error", "EPR2_group",
		"EPR2_lim", "EPR2_thr", "EPR3", "EPR3_bar", "EPR3_decimal", "EPR3_error", "EPR3_group", "EPR3_lim", "EPR3_thr", "EPRLim", "EPRLim_decimal", "EPRLim_error", "EPRLimMode", "FF1", "FF1_error", "FF2", "FF2_error", "FF3", "FF3_error", "FFOff1", "FFOff2",
		"FFOff3", "N11", "N11_decimal", "N11_error", "N11_group", "N12", "N12_decimal", "N12_error", "N12_group", "N13", "N13_decimal", "N13_error", "N13_group", "N2_bars", "N21", "N21_bar", "N21_cline", "N21_decimal", "N21_error", "N21_group", "N21_redline",
		"N22", "N22_bar", "N22_cline", "N22_decimal", "N22_error", "N22_group", "N22_redline", "N23", "N23_bar", "N23_cline", "N23_decimal", "N23_error", "N23_group", "N23_redline", "REV1", "REV2", "REV3", "TAT", "TAT_error"];
	},
	update: func() {
		# Provide the value to here and the base
		Value.Fadec.engPowered[0] = systems.FADEC.engPowered[0].getBoolValue();
		Value.Fadec.engPowered[1] = systems.FADEC.engPowered[1].getBoolValue();
		Value.Fadec.engPowered[2] = systems.FADEC.engPowered[2].getBoolValue();
		Value.Fadec.revState[0] = systems.FADEC.revState[0].getValue();
		Value.Fadec.revState[1] = systems.FADEC.revState[1].getValue();
		Value.Fadec.revState[2] = systems.FADEC.revState[2].getValue();
		Value.Misc.wow = pts.Fdm.JSBsim.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Alert_error"].show();
			me["EGT1_error"].show();
			me["EGT2_error"].show();
			me["EGT3_error"].show();
			me["EPR1_error"].show();
			me["EPR2_error"].show();
			me["EPR3_error"].show();
			me["FF1_error"].show();
			me["FF2_error"].show();
			me["FF3_error"].show();
			me["N11_error"].show();
			me["N12_error"].show();
			me["N13_error"].show();
			me["EPRLim_error"].show();
			me["N21_error"].show();
			me["N22_error"].show();
			me["N23_error"].show();
			me["TAT_error"].show();
		} else {
			me["Alert_error"].hide();
			me["EGT1_error"].hide();
			me["EGT2_error"].hide();
			me["EGT3_error"].hide();
			me["EPR1_error"].hide();
			me["EPR2_error"].hide();
			me["EPR3_error"].hide();
			me["FF1_error"].hide();
			me["FF2_error"].hide();
			me["FF3_error"].hide();
			me["N11_error"].hide();
			me["N12_error"].hide();
			me["N13_error"].hide();
			me["EPRLim_error"].hide();
			me["N21_error"].hide();
			me["N22_error"].hide();
			me["N23_error"].hide();
			me["TAT_error"].hide();
		}
		
		# EPR Limit
		Value.Fadec.activeMode = systems.FADEC.Limit.activeMode.getValue();
		Value.Fadec.eprLimit = systems.FADEC.Limit.active.getValue();
		Value.Fadec.eprLimitFixed = Value.Fadec.eprLimit + 0.005;
		
		if (Value.Fadec.activeMode == "T/O" or Value.Fadec.activeMode == "G/A") {
			if (systems.FADEC.Limit.pwDerate.getBoolValue()) {
				Value.Fadec.rating = "60K";
			} else {
				Value.Fadec.rating = "62K";
			}
			
			if (Value.Fadec.activeMode == "T/O" and fms.FlightData.flexActive) {
				me["EPRLimMode"].setText(Value.Fadec.rating ~ " T/O FLEX ( " ~ sprintf("%d", fms.FlightData.flexTemp) ~ "gC)");
			} else {
				me["EPRLimMode"].setText(Value.Fadec.rating ~ " " ~ Value.Fadec.activeMode ~ " LIM");
			}
		} else {
			me["EPRLimMode"].setText(Value.Fadec.activeMode ~ " LIM");
		}
		
		me["EPRLim"].setText(sprintf("%d", math.floor(Value.Fadec.eprLimitFixed)));
		me["EPRLim_decimal"].setText(sprintf("%02d", math.floor((Value.Fadec.eprLimitFixed - int(Value.Fadec.eprLimitFixed)) * 100)));
		
		me["EPR1_lim"].setTranslation(0, (Value.Fadec.eprLimit - 0.4) / 1.6 * -293);
		me["EPR2_lim"].setTranslation(0, (Value.Fadec.eprLimit - 0.4) / 1.6 * -293);
		me["EPR3_lim"].setTranslation(0, (Value.Fadec.eprLimit - 0.4) / 1.6 * -293);
		
		# EPR
		if (Value.Fadec.engPowered[0]) {
			Value.Fadec.epr[0] = pts.Engines.Engine.eprActual[0].getValue();
			Value.Fadec.eprFixed[0] = pts.Engines.Engine.eprActual[0].getValue() + 0.005;
			
			if (Value.Fadec.revState[0] != 0) {
				me["EPR1_group"].hide();
			} else {
				me["EPR1"].setText(sprintf("%d", math.floor(Value.Fadec.eprFixed[0])));
				me["EPR1_decimal"].setText(sprintf("%02d", math.floor((Value.Fadec.eprFixed[0] - int(Value.Fadec.eprFixed[0])) * 100)));
				me["EPR1_group"].show();
			}
			
			me["EPR1_bar"].setTranslation(0, (Value.Fadec.epr[0] - 0.4) / 1.6 * -293);
			if (!systems.FADEC.n1Mode[0].getValue()) {
				me["EPR1_thr"].setTranslation(0, (systems.FADEC.throttleEpr[0].getValue() - 0.4) / 1.6 * -293);
				me["EPR1_thr"].show();
			} else {
				me["EPR1_thr"].hide();
			}
			
			me["EPR1_bar"].show();
		} else {
			me["EPR1_bar"].hide();
			me["EPR1_group"].hide();
			me["EPR1_thr"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			Value.Fadec.epr[1] = pts.Engines.Engine.eprActual[1].getValue();
			Value.Fadec.eprFixed[1] = pts.Engines.Engine.eprActual[1].getValue() + 0.005;
			
			if (Value.Fadec.revState[1] != 0) {
				me["EPR2_group"].hide();
			} else {
				me["EPR2"].setText(sprintf("%d", math.floor(Value.Fadec.eprFixed[1])));
				me["EPR2_decimal"].setText(sprintf("%02d", math.floor((Value.Fadec.eprFixed[1] - int(Value.Fadec.eprFixed[1])) * 100)));
				me["EPR2_group"].show();
			}
			
			me["EPR2_bar"].setTranslation(0, (Value.Fadec.epr[1] - 0.4) / 1.6 * -293);
			if (!systems.FADEC.n1Mode[1].getValue()) {
				me["EPR2_thr"].setTranslation(0, (systems.FADEC.throttleEpr[1].getValue() - 0.4) / 1.6 * -293);
				me["EPR2_thr"].show();
			} else {
				me["EPR2_thr"].hide();
			}
			
			me["EPR2_bar"].show();
		} else {
			me["EPR2_bar"].hide();
			me["EPR2_group"].hide();
			me["EPR2_thr"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			Value.Fadec.epr[2] = pts.Engines.Engine.eprActual[2].getValue();
			Value.Fadec.eprFixed[2] = pts.Engines.Engine.eprActual[2].getValue() + 0.005;
			
			if (Value.Fadec.revState[2] != 0) {
				me["EPR3_group"].hide();
			} else {
				me["EPR3"].setText(sprintf("%d", math.floor(Value.Fadec.eprFixed[2])));
				me["EPR3_decimal"].setText(sprintf("%02d", math.floor((Value.Fadec.eprFixed[2] - int(Value.Fadec.eprFixed[2])) * 100)));
				me["EPR3_group"].show();
			}
			
			me["EPR3_bar"].setTranslation(0, (Value.Fadec.epr[2] - 0.4) / 1.6 * -293);
			if (!systems.FADEC.n1Mode[2].getValue()) {
				me["EPR3_thr"].setTranslation(0, (systems.FADEC.throttleEpr[2].getValue() - 0.4) / 1.6 * -293);
				me["EPR3_thr"].show();
			} else {
				me["EPR3_thr"].hide();
			}
			
			me["EPR3_bar"].show();
		} else {
			me["EPR3_bar"].hide();
			me["EPR3_group"].hide();
			me["EPR3_thr"].hide();
		}
		
		# N1
		if (Value.Fadec.engPowered[0]) {
			Value.Fadec.n1[0] = pts.Engines.Engine.n1Actual[0].getValue();
			
			if (Value.Fadec.n1[0] < 1.8) {
				Value.Fadec.n1[0] = 0;
			}
			
			if (Value.Fadec.n1[0] + 0.05 < 10) {
				me["N11_group"].setTranslation(-21.064, 0);
			} else if (Value.Fadec.n1[0] + 0.05 < 100) {
				me["N11_group"].setTranslation(-10.169, 0);
			} else {
				me["N11_group"].setTranslation(0, 0);
			}
			
			me["N11"].setText(sprintf("%d", Value.Fadec.n1[0] + 0.05));
			me["N11_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n1[0] + 0.05, 1))));
			me["N11_group"].show();
		} else {
			me["N11_group"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			Value.Fadec.n1[1] = pts.Engines.Engine.n1Actual[1].getValue();
			
			if (Value.Fadec.n1[1] < 1.8) {
				Value.Fadec.n1[1] = 0;
			}
			
			if (Value.Fadec.n1[1] + 0.05 < 10) {
				me["N12_group"].setTranslation(-21.064, 0);
			} else if (Value.Fadec.n1[1] + 0.05 < 100) {
				me["N12_group"].setTranslation(-10.169, 0);
			} else {
				me["N12_group"].setTranslation(0, 0);
			}
			
			me["N12"].setText(sprintf("%d", Value.Fadec.n1[1] + 0.05));
			me["N12_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n1[1] + 0.05, 1))));
			me["N12_group"].show();
		} else {
			me["N12_group"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			Value.Fadec.n1[2] = pts.Engines.Engine.n1Actual[2].getValue();
			
			if (Value.Fadec.n1[2] < 1.8) {
				Value.Fadec.n1[2] = 0;
			}
			
			if (Value.Fadec.n1[2] + 0.05 < 10) {
				me["N13_group"].setTranslation(-21.064, 0);
			} else if (Value.Fadec.n1[2] + 0.05 < 100) {
				me["N13_group"].setTranslation(-10.169, 0);
			} else {
				me["N13_group"].setTranslation(0, 0);
			}
			
			me["N13"].setText(sprintf("%d", Value.Fadec.n1[2] + 0.05));
			me["N13_decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n1[2] + 0.05, 1))));
			me["N13_group"].show();
		} else {
			me["N13_group"].hide();
		}
		
		me.updateBase();
	},
};

var init = func() {
	display = canvas.new({
		"name": "EAD",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	
	display.addPlacement({"node": "ead.screen"});
	
	var geDialsGroup = display.createGroup();
	var geTapesGroup = display.createGroup();
	var pwDialsGroup = display.createGroup();
	var pwTapesGroup = display.createGroup();
	
	geDials = canvasGeDials.new(geDialsGroup, "Aircraft/MD-11/Nasal/Displays/res/EAD-GE-Dials.svg");
	geTapes = canvasGeTapes.new(geTapesGroup, "Aircraft/MD-11/Nasal/Displays/res/EAD-GE-Tapes.svg");
	pwDials = canvasPwDials.new(pwDialsGroup, "Aircraft/MD-11/Nasal/Displays/res/EAD-PW-Dials.svg");
	pwTapes = canvasPwTapes.new(pwTapesGroup, "Aircraft/MD-11/Nasal/Displays/res/EAD-PW-Tapes.svg");
	
	canvasBase.setup();
	update.start();
	
	if (pts.Systems.Acconfig.Options.Du.eadFps.getValue() != 20) {
		rateApply();
	}
}

var rateApply = func() {
	update.restart(1 / pts.Systems.Acconfig.Options.Du.eadFps.getValue());
}

var update = maketimer(0.05, func() { # 20FPS
	canvasBase.update();
});

var showEad = func() {
	var dlg = canvas.Window.new([512, 512], "dialog", nil, 0).set("resize", 1);
	dlg.setCanvas(display);
	dlg.set("title", "Engine and Alert Display");
}

var genevaN1Hundreds = func(input) {
	var m = math.floor(input / 100);
	var s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	if (math.mod(input / 10, 1) < 0.9 or math.mod(input / 100, 1) < 0.9) s = 0;
	return m + s;
}

var genevaN1Tens = func(input) {
	var m = math.floor(input / 10);
	var s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	if (math.mod(input / 10, 1) < 0.9) s = 0;
	return m + s;
}

var genevaN1Ones = func(input) {
	var m = math.floor(input);
	var s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	return m + s;
}

var genevaEprOnes = func(input) {
	var m = math.floor(input / 10);
	var s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	if (math.mod(input / 10, 1) < 0.9) s = 0;
	return m + s;
}

var genevaEprTenths = func(input) {
	var m = math.floor(input);
	var s = math.max(0, (math.mod(input, 1) - 0.9) * 10);
	return m + s;
}
