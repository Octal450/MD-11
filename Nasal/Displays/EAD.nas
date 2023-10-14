# McDonnell Douglas MD-11 EAD
# Copyright (c) 2023 Josh Davidson (Octal450)

var display = nil;
var ge = nil;
var pw = nil;

var Value = {
	Du: {
		eprLimit: 0,
		n1Limit: 0,
	},
	Fadec: {
		activeMode: "T/O",
		engPowered: [0, 0, 0],
		epr: [0, 0, 0],
		eprFixed: [0, 0, 0],
		eprLimitFixed: 0,
		flexActive: 0,
		n1: [0, 0, 0],
		n1LimitFixed: 0,
		n2: [0, 0, 0],
		revState: [0, 0, 0],
	},
	Ignition: {
		starter: [0, 0, 0],
	},
	needleRest: -44 * D2R,
	tat: 0,
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
		if (systems.DUController.eadType == "GE") {
			ge.page.hide();
			pw.page.hide();
			ge.setup();
		} else {
			ge.page.hide();
			pw.page.hide();
			pw.setup();
		}
	},
	update: func() {
		if (systems.DUController.updateEad) {
			if (systems.DUController.eadType == "GE") {
				ge.update();
			} else {
				pw.update();
			}
		}
	},
	updateBase: func() {
		# TAT Indication
		Value.tat = math.round(pts.Fdm.JSBsim.Propulsion.tatC.getValue());
		if (Value.tat < 0) {
			me["TAT"].setText(sprintf("%2.0f", Value.tat));
		} else {
			me["TAT"].setText("+" ~ sprintf("%2.0f", Value.tat));
		}
		
		Value.Ignition.starter[0] = systems.IGNITION.starter1.getBoolValue();
		Value.Ignition.starter[1] = systems.IGNITION.starter2.getBoolValue();
		Value.Ignition.starter[2] = systems.IGNITION.starter3.getBoolValue();
		
		# EGT
		if (Value.Fadec.engPowered[0]) {
			me["EGT1"].show();
			me["EGT1-needle"].show();
			me["EGT1-redline"].show();
			me["EGT1-yline"].show();
			
			me["EGT1"].setText(sprintf("%d", pts.Engines.Engine.egtActual[0].getValue()));
			
			me["EGT1-needle"].setRotation(pts.Instrumentation.Ead.egt[0].getValue() * D2R);
			
			if (systems.IGNITION.ign1.getBoolValue()) {
				me["EGT1-ignition"].show();
			} else {
				me["EGT1-ignition"].hide();
			}
			
			if (Value.Ignition.starter[0]) {
				me["EGT1-redstart"].show();
			} else {
				me["EGT1-redstart"].hide();
			}
		} else {
			me["EGT1"].hide();
			me["EGT1-ignition"].hide();
			me["EGT1-needle"].hide();
			me["EGT1-redline"].hide();
			me["EGT1-redstart"].hide();
			me["EGT1-yline"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			me["EGT2"].show();
			me["EGT2-needle"].show();
			me["EGT2-redline"].show();
			me["EGT2-yline"].show();
			
			me["EGT2"].setText(sprintf("%d", pts.Engines.Engine.egtActual[1].getValue()));
			
			me["EGT2-needle"].setRotation(pts.Instrumentation.Ead.egt[1].getValue() * D2R);
			
			if (systems.IGNITION.ign2.getBoolValue()) {
				me["EGT2-ignition"].show();
			} else {
				me["EGT2-ignition"].hide();
			}
			
			if (Value.Ignition.starter[1]) {
				me["EGT2-redstart"].show();
			} else {
				me["EGT2-redstart"].hide();
			}
		} else {
			me["EGT2"].hide();
			me["EGT2-ignition"].hide();
			me["EGT2-needle"].hide();
			me["EGT2-redline"].hide();
			me["EGT2-redstart"].hide();
			me["EGT2-yline"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			me["EGT3"].show();
			me["EGT3-needle"].show();
			me["EGT3-redline"].show();
			me["EGT3-yline"].show();
			
			me["EGT3"].setText(sprintf("%d", pts.Engines.Engine.egtActual[2].getValue()));
			
			me["EGT3-needle"].setRotation(pts.Instrumentation.Ead.egt[2].getValue() * D2R);
			
			if (systems.IGNITION.ign3.getBoolValue()) {
				me["EGT3-ignition"].show();
			} else {
				me["EGT3-ignition"].hide();
			}
			
			if (Value.Ignition.starter[2]) {
				me["EGT3-redstart"].show();
			} else {
				me["EGT3-redstart"].hide();
			}
		} else {
			me["EGT3"].hide();
			me["EGT3-ignition"].hide();
			me["EGT3-needle"].hide();
			me["EGT3-redline"].hide();
			me["EGT3-redstart"].hide();
			me["EGT3-yline"].hide();
		}
		
		# N2
		if (Value.Fadec.engPowered[0]) {
			me["N21"].show();
			me["N21-decpnt"].show();
			me["N21-decimal"].show();
			me["N21-needle"].show();
			me["N21-redline"].show();
			
			Value.Fadec.n2[0] = pts.Engines.Engine.n2Actual[0].getValue();
			
			if (Value.Fadec.n2[0] < 1.8) {
				Value.Fadec.n2[0] = 0;
				me["N21-needle"].setRotation(Value.needleRest);
			} else {
				me["N21-needle"].setRotation(pts.Instrumentation.Ead.n2[0].getValue() * D2R);
			}
			
			me["N21"].setText(sprintf("%d", Value.Fadec.n2[0] + 0.05));
			me["N21-decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n2[0] + 0.05, 1))));
			
			if (Value.Ignition.starter[0] and systems.IGNITION.cutoff1.getBoolValue()) {
				me["N21-cline"].show();
			} else {
				me["N21-cline"].hide();
			}
		} else {
			me["N21"].hide();
			me["N21-cline"].hide();
			me["N21-decpnt"].hide();
			me["N21-decimal"].hide();
			me["N21-needle"].hide();
			me["N21-redline"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			me["N22"].show();
			me["N22-decpnt"].show();
			me["N22-decimal"].show();
			me["N22-needle"].show();
			me["N22-redline"].show();
			
			Value.Fadec.n2[1] = pts.Engines.Engine.n2Actual[1].getValue();
			
			if (Value.Fadec.n2[1] < 1.8) {
				Value.Fadec.n2[1] = 0;
				me["N22-needle"].setRotation(Value.needleRest);
			} else {
				me["N22-needle"].setRotation(pts.Instrumentation.Ead.n2[1].getValue() * D2R);
			}
			
			me["N22"].setText(sprintf("%d", Value.Fadec.n2[1] + 0.05));
			me["N22-decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n2[1] + 0.05, 1))));
			
			if (Value.Ignition.starter[1] and systems.IGNITION.cutoff2.getBoolValue()) {
				me["N22-cline"].show();
			} else {
				me["N22-cline"].hide();
			}
		} else {
			me["N22"].hide();
			me["N22-cline"].hide();
			me["N22-decpnt"].hide();
			me["N22-decimal"].hide();
			me["N22-needle"].hide();
			me["N22-redline"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			me["N23"].show();
			me["N23-decpnt"].show();
			me["N23-decimal"].show();
			me["N23-needle"].show();
			me["N23-redline"].show();
			
			Value.Fadec.n2[2] = pts.Engines.Engine.n2Actual[2].getValue();
			
			if (Value.Fadec.n2[2] < 1.8) {
				Value.Fadec.n2[2] = 0;
				me["N23-needle"].setRotation(Value.needleRest);
			} else {
				me["N23-needle"].setRotation(pts.Instrumentation.Ead.n2[2].getValue() * D2R);
			}
			
			me["N23"].setText(sprintf("%d", Value.Fadec.n2[2] + 0.05));
			me["N23-decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n2[2] + 0.05, 1))));
			
			if (Value.Ignition.starter[2] and systems.IGNITION.cutoff3.getBoolValue()) {
				me["N23-cline"].show();
			} else {
				me["N23-cline"].hide();
			}
		} else {
			me["N23"].hide();
			me["N23-cline"].hide();
			me["N23-decpnt"].hide();
			me["N23-decimal"].hide();
			me["N23-needle"].hide();
			me["N23-redline"].hide();
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
		
		# Reversers
		Value.Fadec.revState[0] = systems.FADEC.revState[0].getValue();
		Value.Fadec.revState[1] = systems.FADEC.revState[1].getValue();
		Value.Fadec.revState[2] = systems.FADEC.revState[2].getValue();
		
		if (Value.Fadec.revState[0] != 0 and Value.Fadec.engPowered[0]) {
			me["REV1"].show();
		} else {
			me["REV1"].hide();
		}
		
		if (Value.Fadec.revState[0] == 2) {
			me["REV1"].setText("REV");
			me["REV1"].setColor(0,1,0);
		} else {
			me["REV1"].setText("U/L");
			me["REV1"].setColor(1,1,0);
		}
		
		if (Value.Fadec.revState[1] != 0 and Value.Fadec.engPowered[1]) {
			me["REV2"].show();
		} else {
			me["REV2"].hide();
		}
		
		if (Value.Fadec.revState[1] == 2) {
			me["REV2"].setText("REV");
			me["REV2"].setColor(0,1,0);
		} else {
			me["REV2"].setText("U/L");
			me["REV2"].setColor(1,1,0);
		}
		
		if (Value.Fadec.revState[2] != 0 and Value.Fadec.engPowered[2]) {
			me["REV3"].show();
		} else {
			me["REV3"].hide();
		}
		
		if (Value.Fadec.revState[2] == 2) {
			me["REV3"].setText("REV");
			me["REV3"].setColor(0,1,0);
		} else {
			me["REV3"].setText("U/L");
			me["REV3"].setColor(1,1,0);
		}
		
		# Lower Right Warnings
		if (pts.Instrumentation.Ead.configWarn.getBoolValue()) {
			me["Config"].show();
		} else {
			me["Config"].hide();
		}
	},
};

var canvasGe = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasGe, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["N11", "N11-decpnt", "N11-decimal", "N11-box", "N11-needle", "N11-lim", "N11-thr", "N11-redline", "EGT1", "EGT1-needle", "EGT1-redstart", "EGT1-yline", "EGT1-redline", "EGT1-ignition", "N21", "N21-decpnt", "N21-decimal", "N21-needle", "N21-cline",
		"N21-redline", "FF1", "FFOff1", "N12", "N12-decpnt", "N12-decimal", "N12-box", "N12-needle", "N12-lim", "N12-thr", "N12-redline", "EGT2", "EGT2-needle", "EGT2-redstart", "EGT2-yline", "EGT2-redline", "EGT2-ignition", "N22", "N22-decpnt", "N22-decimal",
		"N22-needle", "N22-cline", "N22-redline", "FF2", "FFOff2", "N13", "N13-decpnt", "N13-decimal", "N13-box", "N13-needle", "N13-lim", "N13-thr", "N13-redline", "EGT3", "EGT3-needle", "EGT3-redstart", "EGT3-yline", "EGT3-redline", "EGT3-ignition", "N23",
		"N23-decpnt", "N23-decimal", "N23-needle", "N23-cline", "N23-redline", "FF3", "FFOff3", "N1Lim", "N1Lim-decimal", "N1LimMode", "N1LimText", "FlexGroup", "FlexTemp", "REV1", "REV2", "REV3", "TAT", "Config"];
	},
	setup: func() {
	},
	update: func() {
		# Provide the value to here and the base
		Value.Fadec.engPowered[0] = systems.FADEC.engPowered[0].getBoolValue();
		Value.Fadec.engPowered[1] = systems.FADEC.engPowered[1].getBoolValue();
		Value.Fadec.engPowered[2] = systems.FADEC.engPowered[2].getBoolValue();
		
		# N1 Limit
		Value.Fadec.activeMode = systems.FADEC.Limit.activeMode.getValue();
		Value.Fadec.n1LimitFixed = systems.FADEC.Limit.active.getValue() + 0.05;
		
		if (Value.Fadec.activeMode == "T/O" and systems.FADEC.Limit.flexActive.getBoolValue()) {
			me["FlexTemp"].setText(sprintf("%d", systems.FADEC.Limit.flexTemp.getValue()));
			me["FlexGroup"].show();
			me["N1LimText"].setText("FLEX");
		} else {
			me["FlexGroup"].hide();
			me["N1LimText"].setText("LIM");
		}
		
		me["N1LimMode"].setText(sprintf("%s", Value.Fadec.activeMode));
		me["N1Lim"].setText(sprintf("%d", math.floor(Value.Fadec.n1LimitFixed)));
		me["N1Lim-decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n1LimitFixed, 1))));
		
		# N1
		if (Value.Fadec.engPowered[0]) {
			me["N11"].show();
			me["N11-box"].show();
			me["N11-decimal"].show();
			me["N11-decpnt"].show();
			me["N11-needle"].show();
			me["N11-redline"].show();
			me["N11-thr"].show();
			
			Value.Fadec.n1[0] = pts.Engines.Engine.n1Actual[0].getValue();
			
			if (Value.Fadec.n1[0] < 1.8) {
				Value.Fadec.n1[0] = 0;
				me["N11-needle"].setRotation(Value.needleRest);
			} else {
				me["N11-needle"].setRotation(pts.Instrumentation.Ead.n1[0].getValue() * D2R);
			}
			
			me["N11"].setText(sprintf("%d", Value.Fadec.n1[0] + 0.03));
			me["N11-decimal"].setTranslation(0, math.round((10 * math.mod(Value.Fadec.n1[0], 1)) * 33.65, 0.1));
			
			me["N11-thr"].setRotation(pts.Instrumentation.Ead.n1Thr[0].getValue() * D2R);
		} else {
			me["N11"].hide();
			me["N11-box"].hide();
			me["N11-decimal"].hide();
			me["N11-decpnt"].hide();
			me["N11-needle"].hide();
			me["N11-redline"].hide();
			me["N11-thr"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			me["N12"].show();
			me["N12-box"].show();
			me["N12-decimal"].show();
			me["N12-decpnt"].show();
			me["N12-needle"].show();
			me["N12-redline"].show();
			me["N12-thr"].show();
			
			Value.Fadec.n1[1] = pts.Engines.Engine.n1Actual[1].getValue();
			
			if (Value.Fadec.n1[1] < 1.8) {
				Value.Fadec.n1[1] = 0;
				me["N12-needle"].setRotation(Value.needleRest);
			} else {
				me["N12-needle"].setRotation(pts.Instrumentation.Ead.n1[1].getValue() * D2R);
			}
			
			me["N12"].setText(sprintf("%d", Value.Fadec.n1[1] + 0.03));
			me["N12-decimal"].setTranslation(0, math.round((10 * math.mod(Value.Fadec.n1[1], 1)) * 33.65, 0.1));
			
			me["N12-thr"].setRotation(pts.Instrumentation.Ead.n1Thr[1].getValue() * D2R);
		} else {
			me["N12"].hide();
			me["N12-box"].hide();
			me["N12-decimal"].hide();
			me["N12-decpnt"].hide();
			me["N12-needle"].hide();
			me["N12-redline"].hide();
			me["N12-thr"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			me["N13"].show();
			me["N13-box"].show();
			me["N13-decimal"].show();
			me["N13-decpnt"].show();
			me["N13-needle"].show();
			me["N13-redline"].show();
			me["N13-thr"].show();
			
			Value.Fadec.n1[2] = pts.Engines.Engine.n1Actual[2].getValue();
			
			if (Value.Fadec.n1[2] < 1.8) {
				Value.Fadec.n1[2] = 0;
				me["N13-needle"].setRotation(Value.needleRest);
			} else {
				me["N13-needle"].setRotation(pts.Instrumentation.Ead.n1[2].getValue() * D2R);
			}
			
			me["N13"].setText(sprintf("%d", Value.Fadec.n1[2] + 0.03));
			me["N13-decimal"].setTranslation(0, math.round((10 * math.mod(Value.Fadec.n1[2], 1)) * 33.65, 0.1));
			
			me["N13-thr"].setRotation(pts.Instrumentation.Ead.n1Thr[2].getValue() * D2R);
		} else {
			me["N13"].hide();
			me["N13-box"].hide();
			me["N13-decimal"].hide();
			me["N13-decpnt"].hide();
			me["N13-needle"].hide();
			me["N13-redline"].hide();
			me["N13-thr"].hide();
		}
		
		Value.Du.n1Limit = pts.Instrumentation.Ead.n1Limit.getValue();
		me["N11-lim"].setRotation(Value.Du.n1Limit * D2R);
		me["N12-lim"].setRotation(Value.Du.n1Limit * D2R);
		me["N13-lim"].setRotation(Value.Du.n1Limit * D2R);
		
		me.updateBase();
	},
};

var canvasPw = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasPw, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["EPR1", "EPR1-decpnt", "EPR1-T", "EPR1-H", "EPR1-box", "EPR1-needle", "EPR1-lim", "EPR1-thr", "N11", "N11-decpnt", "N11-decimal", "N11-needle", "N11-redline", "EGT1", "EGT1-needle", "EGT1-redstart", "EGT1-yline", "EGT1-redline", "EGT1-ignition",
		"N21", "N21-decpnt", "N21-decimal", "N21-needle", "N21-cline", "N21-redline", "FF1", "FFOff1", "EPR2", "EPR2-decpnt", "EPR2-T", "EPR2-H", "EPR2-box", "EPR2-needle", "EPR2-lim", "EPR2-thr", "N12", "N12-decpnt", "N12-decimal", "N12-needle", "N12-redline",
		"EGT2", "EGT2-needle", "EGT2-redstart", "EGT2-yline", "EGT2-redline", "EGT2-ignition", "N22", "N22-decpnt", "N22-decimal", "N22-needle", "N22-cline", "N22-redline", "FF2", "FFOff2", "EPR3", "EPR3-decpnt", "EPR3-T", "EPR3-H", "EPR3-box", "EPR3-needle",
		"EPR3-lim", "EPR3-thr", "N13", "N13-decpnt", "N13-decimal", "N13-needle", "N13-redline", "EGT3", "EGT3-needle", "EGT3-redstart", "EGT3-yline", "EGT3-redline", "EGT3-ignition", "N23", "N23-decpnt", "N23-decimal", "N23-needle", "N23-cline", "N23-redline",
		"FF3", "FFOff3", "EPRLim", "EPRLim-decimal", "EPRLimMode", "EPRLimText", "EPRLimModeGroup", "FlexGroup", "FlexTemp", "REV1", "REV2", "REV3", "TAT", "Config"];
	},
	setup: func() {
	},
	update: func() {
		# Provide the value to here and the base
		Value.Fadec.engPowered[0] = systems.FADEC.engPowered[0].getBoolValue();
		Value.Fadec.engPowered[1] = systems.FADEC.engPowered[1].getBoolValue();
		Value.Fadec.engPowered[2] = systems.FADEC.engPowered[2].getBoolValue();
		
		# EPR Limit
		Value.Fadec.activeMode = systems.FADEC.Limit.activeMode.getValue();
		Value.Fadec.eprLimitFixed = systems.FADEC.Limit.active.getValue() + 0.006;
		
		if (Value.Fadec.activeMode == "T/O" and systems.FADEC.Limit.flexActive.getBoolValue()) {
			me["EPRLimText"].setText("FLEX");
			me["FlexTemp"].setText(sprintf("%d", systems.FADEC.Limit.flexTemp.getValue()));
			me["FlexGroup"].show();
		} else {
			me["EPRLimText"].setText("LIM");
			me["FlexGroup"].hide();
		}
		
		me["EPRLimMode"].setText(sprintf("%s", Value.Fadec.activeMode));
		me["EPRLim"].setText(sprintf("%1.0f", math.floor(Value.Fadec.eprLimitFixed)));
		me["EPRLim-decimal"].setText(sprintf("%d", math.floor((Value.Fadec.eprLimitFixed - int(Value.Fadec.eprLimitFixed)) * 100)));
		
		# EPR
		if (Value.Fadec.engPowered[0]) {
			me["EPR1"].show();
			me["EPR1-box"].show();
			me["EPR1-decpnt"].show();
			me["EPR1-H"].show();
			me["EPR1-needle"].show();
			me["EPR1-T"].show();
			me["EPR1-thr"].show();
			
			Value.Fadec.epr[0] = pts.Engines.Engine.eprActual[0].getValue();
			Value.Fadec.eprFixed[0] = Value.Fadec.epr[0] + 0.003;
			
			me["EPR1"].setText(sprintf("%d", Value.Fadec.eprFixed[0]));
			me["EPR1-T"].setText(sprintf("%d", math.floor((Value.Fadec.eprFixed[0] - int(Value.Fadec.eprFixed[0])) * 10)));
			me["EPR1-H"].setTranslation(0, math.round((10 * math.mod(Value.Fadec.epr[0] * 10, 1)) * 33.65, 0.1));
			
			me["EPR1-needle"].setRotation(pts.Instrumentation.Ead.epr[0].getValue() * D2R);
			me["EPR1-thr"].setRotation(pts.Instrumentation.Ead.eprThr[0].getValue() * D2R);
		} else {
			me["EPR1"].hide();
			me["EPR1-box"].hide();
			me["EPR1-decpnt"].hide();
			me["EPR1-H"].hide();
			me["EPR1-needle"].hide();
			me["EPR1-T"].hide();
			me["EPR1-thr"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			me["EPR2"].show();
			me["EPR2-box"].show();
			me["EPR2-decpnt"].show();
			me["EPR2-H"].show();
			me["EPR2-needle"].show();
			me["EPR2-T"].show();
			me["EPR2-thr"].show();
			
			Value.Fadec.epr[1] = pts.Engines.Engine.eprActual[1].getValue();
			Value.Fadec.eprFixed[1] = Value.Fadec.epr[1] + 0.003;
			
			me["EPR2"].setText(sprintf("%d", Value.Fadec.eprFixed[1]));
			me["EPR2-T"].setText(sprintf("%d", math.floor((Value.Fadec.eprFixed[1] - int(Value.Fadec.eprFixed[1])) * 10)));
			me["EPR2-H"].setTranslation(0, math.round((10 * math.mod(Value.Fadec.epr[1] * 10, 1)) * 33.65, 0.1));
			
			me["EPR2-needle"].setRotation(pts.Instrumentation.Ead.epr[1].getValue() * D2R);
			me["EPR2-thr"].setRotation(pts.Instrumentation.Ead.eprThr[1].getValue() * D2R);
		} else {
			me["EPR2"].hide();
			me["EPR2-box"].hide();
			me["EPR2-decpnt"].hide();
			me["EPR2-H"].hide();
			me["EPR2-needle"].hide();
			me["EPR2-T"].hide();
			me["EPR2-thr"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			me["EPR3"].show();
			me["EPR3-box"].show();
			me["EPR3-decpnt"].show();
			me["EPR3-H"].show();
			me["EPR3-needle"].show();
			me["EPR3-T"].show();
			me["EPR3-thr"].show();
			
			Value.Fadec.epr[2] = pts.Engines.Engine.eprActual[2].getValue();
			Value.Fadec.eprFixed[2] = Value.Fadec.epr[2] + 0.003;
			
			me["EPR3"].setText(sprintf("%d", Value.Fadec.eprFixed[2]));
			me["EPR3-T"].setText(sprintf("%d", math.floor((Value.Fadec.eprFixed[2] - int(Value.Fadec.eprFixed[2])) * 10)));
			me["EPR3-H"].setTranslation(0, math.round((10 * math.mod(Value.Fadec.epr[2] * 10, 1)) * 33.65, 0.1));
			
			me["EPR3-needle"].setRotation(pts.Instrumentation.Ead.epr[2].getValue() * D2R);
			me["EPR3-thr"].setRotation(pts.Instrumentation.Ead.eprThr[2].getValue() * D2R);
		} else {
			me["EPR3"].hide();
			me["EPR3-box"].hide();
			me["EPR3-decpnt"].hide();
			me["EPR3-H"].hide();
			me["EPR3-needle"].hide();
			me["EPR3-T"].hide();
			me["EPR3-thr"].hide();
		}
		
		Value.Du.eprLimit = pts.Instrumentation.Ead.eprLimit.getValue();
		me["EPR1-lim"].setRotation(Value.Du.eprLimit * D2R);
		me["EPR2-lim"].setRotation(Value.Du.eprLimit * D2R);
		me["EPR3-lim"].setRotation(Value.Du.eprLimit * D2R);
		
		# N1
		if (Value.Fadec.engPowered[0]) {
			me["N11"].show();
			me["N11-decimal"].show();
			me["N11-decpnt"].show();
			me["N11-needle"].show();
			me["N11-redline"].show();
			
			Value.Fadec.n1[0] = pts.Engines.Engine.n1Actual[0].getValue();
			
			if (Value.Fadec.n1[0] < 1.8) {
				Value.Fadec.n1[0] = 0;
				me["N11-needle"].setRotation(Value.needleRest);
			} else {
				me["N11-needle"].setRotation(pts.Instrumentation.Ead.n1[0].getValue() * D2R);
			}
			
			me["N11"].setText(sprintf("%d", Value.Fadec.n1[0] + 0.05));
			me["N11-decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n1[0] + 0.05, 1))));
		} else {
			me["N11"].hide();
			me["N11-decimal"].hide();
			me["N11-decpnt"].hide();
			me["N11-needle"].hide();
			me["N11-redline"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			me["N12"].show();
			me["N12-decimal"].show();
			me["N12-decpnt"].show();
			me["N12-needle"].show();
			me["N12-redline"].show();
			
			Value.Fadec.n1[1] = pts.Engines.Engine.n1Actual[1].getValue();
			
			if (Value.Fadec.n1[1] < 1.8) {
				Value.Fadec.n1[1] = 0;
				me["N12-needle"].setRotation(Value.needleRest);
			} else {
				me["N12-needle"].setRotation(pts.Instrumentation.Ead.n1[1].getValue() * D2R);
			}
			
			me["N12"].setText(sprintf("%d", Value.Fadec.n1[1] + 0.05));
			me["N12-decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n1[1] + 0.05, 1))));
		} else {
			me["N12"].hide();
			me["N12-decimal"].hide();
			me["N12-decpnt"].hide();
			me["N12-needle"].hide();
			me["N12-redline"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			me["N13"].show();
			me["N13-decimal"].show();
			me["N13-decpnt"].show();
			me["N13-needle"].show();
			me["N13-redline"].show();
			
			Value.Fadec.n1[2] = pts.Engines.Engine.n1Actual[2].getValue();
			
			if (Value.Fadec.n1[2] < 1.8) {
				Value.Fadec.n1[2] = 0;
				me["N13-needle"].setRotation(Value.needleRest);
			} else {
				me["N13-needle"].setRotation(pts.Instrumentation.Ead.n1[2].getValue() * D2R);
			}
			
			me["N13"].setText(sprintf("%d", Value.Fadec.n1[2] + 0.05));
			me["N13-decimal"].setText(sprintf("%d", int(10 * math.mod(Value.Fadec.n1[2] + 0.05, 1))));
		} else {
			me["N13"].hide();
			me["N13-decimal"].hide();
			me["N13-decpnt"].hide();
			me["N13-needle"].hide();
			me["N13-redline"].hide();
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
	
	var geGroup = display.createGroup();
	var pwGroup = display.createGroup();
	
	ge = canvasGe.new(geGroup, "Aircraft/MD-11/Nasal/Displays/res/GE.svg");
	pw = canvasPw.new(pwGroup, "Aircraft/MD-11/Nasal/Displays/res/PW.svg");
	
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
