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
		return ["Config", "EGT1", "EGT1-ignition", "EGT1-needle", "EGT1-redline", "EGT1-redstart", "EGT1-yline", "EGT2", "EGT2-ignition", "EGT2-needle", "EGT2-redline", "EGT2-redstart", "EGT2-yline", "EGT3", "EGT3-ignition", "EGT3-needle", "EGT3-redline",
		"EGT3-redstart", "EGT3-yline", "FF1", "FF2", "FF3", "FFOff1", "FFOff2", "FFOff3", "FlexGroup", "FlexTemp", "N11-box", "N11-decimal", "N11-decpnt", "N11-hundreds", "N11-lim", "N11-needle", "N11-ones", "N11-redline", "N11-tens", "N11-tens-zero", "N11-thr",
		"N12-box", "N12-decimal", "N12-decpnt", "N12-hundreds", "N12-lim", "N12-needle", "N12-ones", "N12-redline", "N12-tens", "N12-tens-zero", "N12-thr", "N13-box", "N13-decimal", "N13-decpnt", "N13-hundreds", "N13-lim", "N13-needle", "N13-ones", "N13-redline",
		"N13-tens", "N13-tens-zero", "N13-thr", "N1Lim", "N1Lim-decimal", "N1LimMode", "N1LimText", "N21", "N21-decpnt", "N21-decimal", "N21-needle", "N21-cline", "N21-redline", "N22", "N22-decpnt", "N22-decimal", "N22-needle", "N22-cline", "N22-redline", "N23",
		"N23-decpnt", "N23-decimal", "N23-needle", "N23-cline", "N23-redline", "REV1", "REV2", "REV3", "TAT"];
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
			me["N11-box"].show();
			me["N11-decimal"].show();
			me["N11-decpnt"].show();
			me["N11-hundreds"].show();
			me["N11-needle"].show();
			me["N11-ones"].show();
			me["N11-redline"].show();
			me["N11-tens"].show();
			me["N11-thr"].show();
			
			Value.Fadec.n1[0] = pts.Engines.Engine.n1Actual[0].getValue();
			
			if (Value.Fadec.n1[0] < 1.8) {
				Value.Fadec.n1[0] = 0;
				me["N11-needle"].setRotation(Value.needleRest);
			} else {
				me["N11-needle"].setRotation(pts.Instrumentation.Ead.n1[0].getValue() * D2R);
			}
			
			if (Value.Fadec.n1[0] < 99) { # Prepare to show the zero at 100
				me["N11-tens-zero"].hide();
			} else {
				me["N11-tens-zero"].show();
			}
			
			me["N11-hundreds"].setTranslation(0, genevaN1Hundreds(num(right(sprintf("%07.3f", Value.Fadec.n1[0]), 7))) * 33.75);
			me["N11-tens"].setTranslation(0, genevaN1Tens(num(right(sprintf("%06.3f", Value.Fadec.n1[0]), 6))) * 33.75);
			me["N11-ones"].setTranslation(0, genevaN1Ones(num(right(sprintf("%05.3f", Value.Fadec.n1[0]), 5))) * 33.75);
			me["N11-decimal"].setTranslation(0, (10 * math.round(math.mod(Value.Fadec.n1[0], 1), 0.001) * 33.75));
			
			me["N11-thr"].setRotation(pts.Instrumentation.Ead.n1Thr[0].getValue() * D2R);
		} else {
			me["N11-box"].hide();
			me["N11-decimal"].hide();
			me["N11-decpnt"].hide();
			me["N11-hundreds"].hide();
			me["N11-needle"].hide();
			me["N11-ones"].hide();
			me["N11-redline"].hide();
			me["N11-tens"].hide();
			me["N11-thr"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			me["N12-box"].show();
			me["N12-decimal"].show();
			me["N12-decpnt"].show();
			me["N12-hundreds"].show();
			me["N12-needle"].show();
			me["N12-ones"].show();
			me["N12-redline"].show();
			me["N12-tens"].show();
			me["N12-thr"].show();
			
			Value.Fadec.n1[1] = pts.Engines.Engine.n1Actual[1].getValue();
			
			if (Value.Fadec.n1[1] < 1.8) {
				Value.Fadec.n1[1] = 0;
				me["N12-needle"].setRotation(Value.needleRest);
			} else {
				me["N12-needle"].setRotation(pts.Instrumentation.Ead.n1[1].getValue() * D2R);
			}
			
			if (Value.Fadec.n1[1] < 99) { # Prepare to show the zero at 100
				me["N12-tens-zero"].hide();
			} else {
				me["N12-tens-zero"].show();
			}
			
			me["N12-hundreds"].setTranslation(0, genevaN1Hundreds(num(right(sprintf("%07.3f", Value.Fadec.n1[1]), 7))) * 33.75);
			me["N12-tens"].setTranslation(0, genevaN1Tens(num(right(sprintf("%06.3f", Value.Fadec.n1[1]), 6))) * 33.75);
			me["N12-ones"].setTranslation(0, genevaN1Ones(num(right(sprintf("%05.3f", Value.Fadec.n1[1]), 5))) * 33.75);
			me["N12-decimal"].setTranslation(0, (10 * math.round(math.mod(Value.Fadec.n1[1], 1), 0.001) * 33.75));
			
			me["N12-thr"].setRotation(pts.Instrumentation.Ead.n1Thr[1].getValue() * D2R);
		} else {
			me["N12-box"].hide();
			me["N12-decimal"].hide();
			me["N12-decpnt"].hide();
			me["N12-hundreds"].hide();
			me["N12-needle"].hide();
			me["N12-ones"].hide();
			me["N12-redline"].hide();
			me["N12-tens"].hide();
			me["N12-thr"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			me["N13-box"].show();
			me["N13-decimal"].show();
			me["N13-decpnt"].show();
			me["N13-hundreds"].show();
			me["N13-needle"].show();
			me["N13-ones"].show();
			me["N13-redline"].show();
			me["N13-tens"].show();
			me["N13-thr"].show();
			
			Value.Fadec.n1[2] = pts.Engines.Engine.n1Actual[2].getValue();
			
			if (Value.Fadec.n1[2] < 1.8) {
				Value.Fadec.n1[2] = 0;
				me["N13-needle"].setRotation(Value.needleRest);
			} else {
				me["N13-needle"].setRotation(pts.Instrumentation.Ead.n1[2].getValue() * D2R);
			}
			
			if (Value.Fadec.n1[2] < 99) { # Prepare to show the zero at 100
				me["N13-tens-zero"].hide();
			} else {
				me["N13-tens-zero"].show();
			}
			
			me["N13-hundreds"].setTranslation(0, genevaN1Hundreds(num(right(sprintf("%07.3f", Value.Fadec.n1[2]), 7))) * 33.75);
			me["N13-tens"].setTranslation(0, genevaN1Tens(num(right(sprintf("%06.3f", Value.Fadec.n1[2]), 6))) * 33.75);
			me["N13-ones"].setTranslation(0, genevaN1Ones(num(right(sprintf("%05.3f", Value.Fadec.n1[2]), 5))) * 33.75);
			me["N13-decimal"].setTranslation(0, (10 * math.round(math.mod(Value.Fadec.n1[2], 1), 0.001) * 33.75));
			
			me["N13-thr"].setRotation(pts.Instrumentation.Ead.n1Thr[2].getValue() * D2R);
		} else {
			me["N13-box"].hide();
			me["N13-decimal"].hide();
			me["N13-decpnt"].hide();
			me["N13-hundreds"].hide();
			me["N13-needle"].hide();
			me["N13-ones"].hide();
			me["N13-redline"].hide();
			me["N13-tens"].hide();
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
		return ["Config", "EGT1", "EGT1-ignition", "EGT1-needle", "EGT1-redline", "EGT1-redstart", "EGT1-yline", "EGT2", "EGT2-ignition", "EGT2-needle", "EGT2-redline", "EGT2-redstart", "EGT2-yline", "EGT3", "EGT3-ignition", "EGT3-needle", "EGT3-redline",
		"EGT3-redstart", "EGT3-yline", "EPR1-box", "EPR1-decpnt", "EPR1-hundreths", "EPR1-lim", "EPR1-needle", "EPR1-ones", "EPR1-tenths", "EPR1-thr", "EPR2-box", "EPR2-decpnt", "EPR2-hundreths", "EPR2-lim", "EPR2-needle", "EPR2-ones", "EPR2-tenths", "EPR2-thr",
		"EPR3-box", "EPR3-decpnt", "EPR3-hundreths", "EPR3-lim", "EPR3-needle", "EPR3-ones", "EPR3-tenths", "EPR3-thr", "EPRLim", "EPRLim-decimal", "EPRLimMode", "EPRLimModeGroup", "EPRLimText", "FF1", "FF2", "FF3", "FFOff1", "FFOff2", "FFOff3", "FlexGroup",
		"FlexTemp", "N11", "N11-decimal", "N11-decpnt", "N11-needle", "N11-redline", "N12", "N12-decimal", "N12-decpnt", "N12-needle", "N12-redline", "N13", "N13-decimal", "N13-decpnt", "N13-needle", "N13-redline", "N21", "N21-cline", "N21-decimal", "N21-decpnt", 
		"N21-needle", "N21-redline", "N22", "N22-cline", "N22-decimal", "N22-decpnt", "N22-needle", "N22-redline", "N23", "N23-cline", "N23-decimal", "N23-decpnt", "N23-needle", "N23-redline", "REV1", "REV2", "REV3", "TAT"];
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
		Value.Fadec.eprLimitFixed = systems.FADEC.Limit.active.getValue() + 0.005;
		
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
			me["EPR1-box"].show();
			me["EPR1-decpnt"].show();
			me["EPR1-hundreths"].show();
			me["EPR1-needle"].show();
			me["EPR1-ones"].show();
			me["EPR1-tenths"].show();
			me["EPR1-thr"].show();
			
			Value.Fadec.epr[0] = pts.Engines.Engine.eprActual[0].getValue();
			
			me["EPR1-ones"].setTranslation(0, genevaEprOnes(num(right(sprintf("%06.3f", Value.Fadec.epr[0] * 10), 6))) * 33.75);
			me["EPR1-tenths"].setTranslation(0, genevaEprTenths(num(right(sprintf("%05.3f", Value.Fadec.epr[0] * 10), 5))) * 33.75);
			me["EPR1-hundreths"].setTranslation(0, 10 * (math.round(math.mod(Value.Fadec.epr[0] * 10, 1), 0.0001) * 33.75));
			
			me["EPR1-needle"].setRotation(pts.Instrumentation.Ead.epr[0].getValue() * D2R);
			me["EPR1-thr"].setRotation(pts.Instrumentation.Ead.eprThr[0].getValue() * D2R);
		} else {
			me["EPR1-box"].hide();
			me["EPR1-decpnt"].hide();
			me["EPR1-hundreths"].hide();
			me["EPR1-needle"].hide();
			me["EPR1-ones"].hide();
			me["EPR1-tenths"].hide();
			me["EPR1-thr"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			me["EPR2-box"].show();
			me["EPR2-decpnt"].show();
			me["EPR2-hundreths"].show();
			me["EPR2-needle"].show();
			me["EPR2-ones"].show();
			me["EPR2-tenths"].show();
			me["EPR2-thr"].show();
			
			Value.Fadec.epr[1] = pts.Engines.Engine.eprActual[1].getValue();
			
			me["EPR2-ones"].setTranslation(0, genevaEprOnes(num(right(sprintf("%06.3f", Value.Fadec.epr[1] * 10), 6))) * 33.75);
			me["EPR2-tenths"].setTranslation(0, genevaEprTenths(num(right(sprintf("%05.3f", Value.Fadec.epr[1] * 10), 5))) * 33.75);
			me["EPR2-hundreths"].setTranslation(0, 10 * (math.round(math.mod(Value.Fadec.epr[1] * 10, 1), 0.0001) * 33.75));
			
			me["EPR2-needle"].setRotation(pts.Instrumentation.Ead.epr[1].getValue() * D2R);
			me["EPR2-thr"].setRotation(pts.Instrumentation.Ead.eprThr[1].getValue() * D2R);
		} else {
			me["EPR2-box"].hide();
			me["EPR2-decpnt"].hide();
			me["EPR2-hundreths"].hide();
			me["EPR2-needle"].hide();
			me["EPR2-ones"].hide();
			me["EPR2-tenths"].hide();
			me["EPR2-thr"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			me["EPR3-box"].show();
			me["EPR3-decpnt"].show();
			me["EPR3-hundreths"].show();
			me["EPR3-needle"].show();
			me["EPR3-ones"].show();
			me["EPR3-tenths"].show();
			me["EPR3-thr"].show();
			
			Value.Fadec.epr[2] = pts.Engines.Engine.eprActual[2].getValue();
			
			me["EPR3-ones"].setTranslation(0, genevaEprOnes(num(right(sprintf("%06.3f", Value.Fadec.epr[2] * 10), 6))) * 33.75);
			me["EPR3-tenths"].setTranslation(0, genevaEprTenths(num(right(sprintf("%05.3f", Value.Fadec.epr[2] * 10), 5))) * 33.75);
			me["EPR3-hundreths"].setTranslation(0, 10 * (math.round(math.mod(Value.Fadec.epr[2] * 10, 1), 0.0001) * 33.75));
			
			me["EPR3-needle"].setRotation(pts.Instrumentation.Ead.epr[2].getValue() * D2R);
			me["EPR3-thr"].setRotation(pts.Instrumentation.Ead.eprThr[2].getValue() * D2R);
		} else {
			me["EPR3-box"].hide();
			me["EPR3-decpnt"].hide();
			me["EPR3-hundreths"].hide();
			me["EPR3-needle"].hide();
			me["EPR3-ones"].hide();
			me["EPR3-tenths"].hide();
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
	
	ge = canvasGe.new(geGroup, "Aircraft/MD-11/Nasal/Displays/res/EAD-GE.svg");
	pw = canvasPw.new(pwGroup, "Aircraft/MD-11/Nasal/Displays/res/EAD-PW.svg");
	
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
