# McDonnell Douglas MD-11 EAD
# Copyright (c) 2020 Josh Davidson (Octal450)

var EAD_GE = nil;
var EAD_PW = nil;
var EAD_display = nil;
var eprFixed = 1.00;
setprop("/DU/EAD/EPR[0]", 0);
setprop("/DU/EAD/EPR[1]", 0);
setprop("/DU/EAD/EPR[2]", 0);
setprop("/DU/EAD/EPRthr[0]", 0);
setprop("/DU/EAD/EPRthr[1]", 0);
setprop("/DU/EAD/EPRthr[2]", 0);
setprop("/DU/EAD/EPRLimit", 0);
setprop("/DU/EAD/EGT[0]", 0);
setprop("/DU/EAD/EGT[1]", 0);
setprop("/DU/EAD/EGT[2]", 0);

var Value = {
	Fadec: {
		activeMode: "T/O",
		engPowered: [0, 0, 0],
		eprFixed: [0, 0, 0],
		eprLimFixed: 0,
		revState: [0, 0, 0],
	},
	Tat: 0,
};

var canvas_EAD_base = {
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

				var clip_rect = sprintf("rect(%d,%d, %d,%d)", 
				tran_rect[1], # 0 ys
				tran_rect[2], # 1 xe
				tran_rect[3], # 2 ye
				tran_rect[0]); #3 xs
				#   coordinates are top,right,bottom,left (ys, xe, ye, xs) ref: l621 of simgear/canvas/CanvasElement.cxx
				me[key].set("clip", clip_rect);
				me[key].set("clip-frame", canvas.Element.PARENT);
			}
		}

		me.page = canvas_group;

		return me;
	},
	getKeys: func() {
		return [];
	},
	update: func() {
		if (systems.ELEC.Bus.lEmerAc.getValue() >= 110) {
			if (getprop("/options/eng") == "GE") {
				EAD_GE.page.show();
				EAD_PW.page.hide();
				EAD_GE.update();
			} else if (getprop("/options/eng") == "PW") {
				EAD_GE.page.hide();
				EAD_PW.page.show();
				EAD_PW.update();
			}
		} else {
			EAD_GE.page.hide();
			EAD_PW.page.hide();
		}
	},
	updateBase: func() {
		# TAT Indication
		Value.Tat = math.round(pts.Fdm.JSBsim.Propulsion.tatC.getValue());
		if (Value.Tat < 0) {
			me["TAT"].setText(sprintf("%2.0f", Value.Tat));
		} else {
			me["TAT"].setText("+" ~ sprintf("%2.0f", Value.Tat));
		}
		
		# Reversers
		Value.Fadec.revState[0] = systems.FADEC.revState[0].getValue();
		Value.Fadec.revState[1] = systems.FADEC.revState[1].getValue();
		Value.Fadec.revState[2] = systems.FADEC.revState[2].getValue();
		
		if (Value.Fadec.revState[0] != 0 and systems.FADEC.engPowered[0].getBoolValue()) {
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
		
		if (Value.Fadec.revState[1] != 0 and systems.FADEC.engPowered[1].getBoolValue()) {
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
		
		if (Value.Fadec.revState[2] != 0 and systems.FADEC.engPowered[2].getBoolValue()) {
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
	},
};

var canvas_EAD_GE = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_EAD_GE, canvas_EAD_base]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["N11","N11-decpnt","N11-decimal","N11-box","N11-needle","N11-lim","N11-thr","N11-redline","EGT1","EGT1-needle","EGT1-redstart","EGT1-yline","EGT1-redline","EGT1-ignition","N21","N21-decpnt","N21-decimal","N21-needle","N21-cline","N21-redline",
		"FF1","FFOff1","N12","N12-decpnt","N12-decimal","N12-box","N12-needle","N12-lim","N12-thr","N12-redline","EGT2","EGT2-needle","EGT2-redstart","EGT2-yline","EGT2-redline","EGT2-ignition","N22","N22-decpnt","N22-decimal","N22-needle","N22-cline",
		"N22-redline","FF2","FFOff2","N13","N13-decpnt","N13-decimal","N13-box","N13-needle","N13-lim","N13-thr","N13-redline","EGT3","EGT3-needle","EGT3-redstart","EGT3-yline","EGT3-redline","EGT3-ignition","N23","N23-decpnt","N23-decimal","N23-needle",
		"N23-cline","N23-redline","FF3","FFOff3","N1Lim","N1Lim-decimal","N1LimMode","REV1","REV2","REV3","TAT"];
	},
	update: func() {
		Value.Fadec.engPowered[0] = systems.FADEC.engPowered[0].getBoolValue();
		Value.Fadec.engPowered[1] = systems.FADEC.engPowered[1].getBoolValue();
		Value.Fadec.engPowered[2] = systems.FADEC.engPowered[2].getBoolValue();
		
		# N1
		me["N11"].setText(sprintf("%d", getprop("/engines/engine[0]/n1-actual") + 0.03));
		me["N11-decimal"].setTranslation(0, math.round((10 * math.mod(getprop("/engines/engine[0]/n1-actual"), 1)) * 33.65, 0.1));
		me["N12"].setText(sprintf("%d", getprop("/engines/engine[1]/n1-actual") + 0.03));
		me["N12-decimal"].setTranslation(0, math.round((10 * math.mod(getprop("/engines/engine[1]/n1-actual"), 1)) * 33.65, 0.1));
		me["N13"].setText(sprintf("%d", getprop("/engines/engine[2]/n1-actual") + 0.03));
		me["N13-decimal"].setTranslation(0, math.round((10 * math.mod(getprop("/engines/engine[2]/n1-actual"), 1)) * 33.65, 0.1));
		
		me["N11-needle"].setRotation((getprop("/DU/EAD/N1[0]") + 90) * D2R);
		me["N11-thr"].setRotation((getprop("/DU/EAD/N1thr[0]") + 90) * D2R);
		me["N11-lim"].setRotation((getprop("/DU/EAD/N1Limit") + 90) * D2R);
		me["N12-needle"].setRotation((getprop("/DU/EAD/N1[1]") + 90) * D2R);
		me["N12-thr"].setRotation((getprop("/DU/EAD/N1thr[1]") + 90) * D2R);
		me["N12-lim"].setRotation((getprop("/DU/EAD/N1Limit") + 90) * D2R);
		me["N13-needle"].setRotation((getprop("/DU/EAD/N1[2]") + 90) * D2R);
		me["N13-thr"].setRotation((getprop("/DU/EAD/N1thr[2]") + 90) * D2R);
		me["N13-lim"].setRotation((getprop("/DU/EAD/N1Limit") + 90) * D2R);
		
		if (Value.Fadec.engPowered[0]) {
			me["N11"].show();
			me["N11-thr"].show();
			me["N11-decpnt"].show();
			me["N11-decimal"].show();
			me["N11-box"].show();
			me["N11-needle"].show();
			me["N11-redline"].show();
		} else {
			me["N11"].hide();
			me["N11-thr"].hide();
			me["N11-decpnt"].hide();
			me["N11-decimal"].hide();
			me["N11-box"].hide();
			me["N11-needle"].hide();
			me["N11-redline"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			me["N12"].show();
			me["N12-thr"].show();
			me["N12-decpnt"].show();
			me["N12-decimal"].show();
			me["N12-box"].show();
			me["N12-needle"].show();
			me["N12-redline"].show();
		} else {
			me["N12"].hide();
			me["N12-thr"].hide();
			me["N12-decpnt"].hide();
			me["N12-decimal"].hide();
			me["N12-box"].hide();
			me["N12-needle"].hide();
			me["N12-redline"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			me["N13"].show();
			me["N13-thr"].show();
			me["N13-decpnt"].show();
			me["N13-decimal"].show();
			me["N13-box"].show();
			me["N13-needle"].show();
			me["N13-redline"].show();
		} else {
			me["N13"].hide();
			me["N13-thr"].hide();
			me["N13-decpnt"].hide();
			me["N13-decimal"].hide();
			me["N13-box"].hide();
			me["N13-needle"].hide();
			me["N13-redline"].hide();
		}
		
		# EGT
		me["EGT1"].setText(sprintf("%d", getprop("/engines/engine[0]/egt-actual")));
		me["EGT2"].setText(sprintf("%d", getprop("/engines/engine[1]/egt-actual")));
		me["EGT3"].setText(sprintf("%d", getprop("/engines/engine[2]/egt-actual")));
		
		me["EGT1-needle"].setRotation((getprop("/DU/EAD/EGT[0]") + 90) * D2R);
		me["EGT2-needle"].setRotation((getprop("/DU/EAD/EGT[1]") + 90) * D2R);
		me["EGT3-needle"].setRotation((getprop("/DU/EAD/EGT[2]") + 90) * D2R);
		
		if (Value.Fadec.engPowered[0]) {
			me["EGT1"].show();
			me["EGT1-needle"].show();
			me["EGT1-yline"].show();
			me["EGT1-redline"].show();
		} else {
			me["EGT1"].hide();
			me["EGT1-needle"].hide();
			me["EGT1-yline"].hide();
			me["EGT1-redline"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			me["EGT2"].show();
			me["EGT2-needle"].show();
			me["EGT2-yline"].show();
			me["EGT2-redline"].show();
		} else {
			me["EGT2"].hide();
			me["EGT2-needle"].hide();
			me["EGT2-yline"].hide();
			me["EGT2-redline"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			me["EGT3"].show();
			me["EGT3-needle"].show();
			me["EGT3-yline"].show();
			me["EGT3-redline"].show();
		} else {
			me["EGT3"].hide();
			me["EGT3-needle"].hide();
			me["EGT3-yline"].hide();
			me["EGT3-redline"].hide();
		}
		
		if (getprop("/controls/engines/ignition-1") == 1 and Value.Fadec.engPowered[0]) {
			me["EGT1-ignition"].show();
		} else {
			me["EGT1-ignition"].hide();
		}
		
		if (getprop("/controls/engines/ignition-2") == 1 and Value.Fadec.engPowered[1]) {
			me["EGT2-ignition"].show();
		} else {
			me["EGT2-ignition"].hide();
		}
		
		if (getprop("/controls/engines/ignition-3") == 1 and Value.Fadec.engPowered[2]) {
			me["EGT3-ignition"].show();
		} else {
			me["EGT3-ignition"].hide();
		}
		
		if (getprop("/controls/engines/engine[0]/start-switch") == 1 and Value.Fadec.engPowered[0]) {
			me["EGT1-redstart"].show();
		} else {
			me["EGT1-redstart"].hide();
		}
		
		if (getprop("/controls/engines/engine[1]/start-switch") == 1 and Value.Fadec.engPowered[1]) {
			me["EGT2-redstart"].show();
		} else {
			me["EGT2-redstart"].hide();
		}
		
		if (getprop("/controls/engines/engine[2]/start-switch") == 1 and Value.Fadec.engPowered[2]) {
			me["EGT3-redstart"].show();
		} else {
			me["EGT3-redstart"].hide();
		}
		
		# N2
		me["N21"].setText(sprintf("%d", getprop("/engines/engine[0]/n2-actual") + 0.05));
		me["N21-decimal"].setText(sprintf("%d", int(10 * math.mod(getprop("/engines/engine[0]/n2-actual") + 0.05, 1))));
		me["N22"].setText(sprintf("%d", getprop("/engines/engine[1]/n2-actual") + 0.05));
		me["N22-decimal"].setText(sprintf("%d", int(10 * math.mod(getprop("/engines/engine[1]/n2-actual") + 0.05, 1))));
		me["N23"].setText(sprintf("%d", getprop("/engines/engine[2]/n2-actual") + 0.05));
		me["N23-decimal"].setText(sprintf("%d", int(10 * math.mod(getprop("/engines/engine[2]/n2-actual") + 0.05, 1))));
		
		me["N21-needle"].setRotation((getprop("/DU/EAD/N2[0]") + 90) * D2R);
		me["N22-needle"].setRotation((getprop("/DU/EAD/N2[1]") + 90) * D2R);
		me["N23-needle"].setRotation((getprop("/DU/EAD/N2[2]") + 90) * D2R);
		
		if (Value.Fadec.engPowered[0]) {
			me["N21"].show();
			me["N21-decpnt"].show();
			me["N21-decimal"].show();
			me["N21-needle"].show();
			me["N21-redline"].show();
		} else {
			me["N21"].hide();
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
		} else {
			me["N22"].hide();
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
		} else {
			me["N23"].hide();
			me["N23-decpnt"].hide();
			me["N23-decimal"].hide();
			me["N23-needle"].hide();
			me["N23-redline"].hide();
		}
		
		if (getprop("/controls/engines/engine[0]/starter") == 1 and getprop("/controls/engines/engine[0]/cutoff") == 1 and Value.Fadec.engPowered[0]) {
			me["N21-cline"].show();
		} else {
			me["N21-cline"].hide();
		}
		
		if (getprop("/controls/engines/engine[1]/starter") == 1 and getprop("/controls/engines/engine[1]/cutoff") == 1 and Value.Fadec.engPowered[1]) {
			me["N22-cline"].show();
		} else {
			me["N22-cline"].hide();
		}
		
		if (getprop("/controls/engines/engine[2]/starter") == 1 and getprop("/controls/engines/engine[2]/cutoff") == 1 and Value.Fadec.engPowered[2]) {
			me["N23-cline"].show();
		} else {
			me["N23-cline"].hide();
		}
		
		# FF
		me["FF1"].setText(sprintf("%d", math.round(getprop("/engines/engine[0]/fuel-flow_actual"), 10)));
		me["FF2"].setText(sprintf("%d", math.round(getprop("/engines/engine[1]/fuel-flow_actual"), 10)));
		me["FF3"].setText(sprintf("%d", math.round(getprop("/engines/engine[2]/fuel-flow_actual"), 10)));
		
		if (Value.Fadec.engPowered[0]) {
			me["FF1"].show();
		} else {
			me["FF1"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			me["FF2"].show();
		} else {
			me["FF2"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			me["FF3"].show();
		} else {
			me["FF3"].hide();
		}
		
		if (getprop("/controls/engines/engine[0]/cutoff") == 1) {
			me["FFOff1"].show();
		} else {
			me["FFOff1"].hide();
		}
		
		if (getprop("/controls/engines/engine[1]/cutoff") == 1) {
			me["FFOff2"].show();
		} else {
			me["FFOff2"].hide();
		}
		
		if (getprop("/controls/engines/engine[2]/cutoff") == 1) {
			me["FFOff3"].show();
		} else {
			me["FFOff3"].hide();
		}
		
		# N1 Limit
		me["N1LimMode"].setText(sprintf("%s", getprop("/fdm/jsbsim/fadec/limit/active-mode")));
		me["N1Lim"].setText(sprintf("%d", math.floor(getprop("/fdm/jsbsim/fadec/limit/active") + 0.05)));
		me["N1Lim-decimal"].setText(sprintf("%d", int(10 * math.mod(getprop("/fdm/jsbsim/fadec/limit/active") + 0.05, 1))));
		
		me.updateBase();
	},
};

var canvas_EAD_PW = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_EAD_PW, canvas_EAD_base]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["EPR1","EPR1-decpnt","EPR1-T","EPR1-H","EPR1-box","EPR1-needle","EPR1-lim","EPR1-thr","N11","N11-decpnt","N11-decimal","N11-needle","N11-redline","EGT1","EGT1-needle","EGT1-redstart","EGT1-yline","EGT1-redline","EGT1-ignition","N21","N21-decpnt",
		"N21-decimal","N21-needle","N21-cline","N21-redline","FF1","FFOff1","EPR2","EPR2-decpnt","EPR2-T","EPR2-H","EPR2-box","EPR2-needle","EPR2-lim","EPR2-thr","N12","N12-decpnt","N12-decimal","N12-needle","N12-redline","EGT2","EGT2-needle","EGT2-redstart",
		"EGT2-yline","EGT2-redline","EGT2-ignition","N22","N22-decpnt","N22-decimal","N22-needle","N22-cline","N22-redline","FF2","FFOff2","EPR3","EPR3-decpnt","EPR3-T","EPR3-H","EPR3-box","EPR3-needle","EPR3-lim","EPR3-thr","N13","N13-decpnt","N13-decimal",
		"N13-needle","N13-redline","EGT3","EGT3-needle","EGT3-redstart","EGT3-yline","EGT3-redline","EGT3-ignition","N23","N23-decpnt","N23-decimal","N23-needle","N23-cline","N23-redline","FF3","FFOff3","EPRLim","EPRLim-decimal","EPRLimRating","EPRLimMode",
		"EPRLimModeGroup","REV1","REV2","REV3","TAT"];
	},
	update: func() {
		Value.Fadec.engPowered[0] = systems.FADEC.engPowered[0].getBoolValue();
		Value.Fadec.engPowered[1] = systems.FADEC.engPowered[1].getBoolValue();
		Value.Fadec.engPowered[2] = systems.FADEC.engPowered[2].getBoolValue();
		
		# EPR
		Value.Fadec.eprFixed[0] = getprop("/engines/engine[0]/epr-actual") + 0.003;
		Value.Fadec.eprFixed[1] = getprop("/engines/engine[1]/epr-actual") + 0.003;
		Value.Fadec.eprFixed[2] = getprop("/engines/engine[2]/epr-actual") + 0.003;
		me["EPR1"].setText(sprintf("%d", Value.Fadec.eprFixed[0]));
		me["EPR1-T"].setText(sprintf("%d", math.floor((Value.Fadec.eprFixed[0] - int(Value.Fadec.eprFixed[0])) * 10)));
		me["EPR1-H"].setTranslation(0, math.round((10 * math.mod(getprop("/engines/engine[0]/epr-actual") * 10, 1)) * 33.65, 0.1));
		me["EPR2"].setText(sprintf("%d", Value.Fadec.eprFixed[1]));
		me["EPR2-T"].setText(sprintf("%d", math.floor((Value.Fadec.eprFixed[1] - int(Value.Fadec.eprFixed[1])) * 10)));
		me["EPR2-H"].setTranslation(0, math.round((10 * math.mod(getprop("/engines/engine[1]/epr-actual") * 10, 1)) * 33.65, 0.1));
		me["EPR3"].setText(sprintf("%d", Value.Fadec.eprFixed[2]));
		me["EPR3-T"].setText(sprintf("%d", math.floor((Value.Fadec.eprFixed[2] - int(Value.Fadec.eprFixed[2])) * 10)));
		me["EPR3-H"].setTranslation(0, math.round((10 * math.mod(getprop("/engines/engine[2]/epr-actual") * 10, 1)) * 33.65, 0.1));
		
		me["EPR1-needle"].setRotation((getprop("/DU/EAD/EPR[0]") + 90) * D2R);
		me["EPR1-thr"].setRotation((getprop("/DU/EAD/EPRthr[0]") + 90) * D2R);
		me["EPR1-lim"].setRotation((getprop("/DU/EAD/EPRLimit") + 90) * D2R);
		me["EPR2-needle"].setRotation((getprop("/DU/EAD/EPR[1]") + 90) * D2R);
		me["EPR2-thr"].setRotation((getprop("/DU/EAD/EPRthr[1]") + 90) * D2R);
		me["EPR2-lim"].setRotation((getprop("/DU/EAD/EPRLimit") + 90) * D2R);
		me["EPR3-needle"].setRotation((getprop("/DU/EAD/EPR[2]") + 90) * D2R);
		me["EPR3-thr"].setRotation((getprop("/DU/EAD/EPRthr[2]") + 90) * D2R);
		me["EPR3-lim"].setRotation((getprop("/DU/EAD/EPRLimit") + 90) * D2R);
		
		if (Value.Fadec.engPowered[0]) {
			me["EPR1"].show();
			me["EPR1-thr"].show();
			me["EPR1-decpnt"].show();
			me["EPR1-T"].show();
			me["EPR1-H"].show();
			me["EPR1-box"].show();
			me["EPR1-needle"].show();
		} else {
			me["EPR1"].hide();
			me["EPR1-thr"].hide();
			me["EPR1-decpnt"].hide();
			me["EPR1-T"].hide();
			me["EPR1-H"].hide();
			me["EPR1-box"].hide();
			me["EPR1-needle"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			me["EPR2"].show();
			me["EPR2-thr"].show();
			me["EPR2-decpnt"].show();
			me["EPR2-T"].show();
			me["EPR2-H"].show();
			me["EPR2-box"].show();
			me["EPR2-needle"].show();
		} else {
			me["EPR2"].hide();
			me["EPR2-thr"].hide();
			me["EPR2-decpnt"].hide();
			me["EPR2-T"].hide();
			me["EPR2-H"].hide();
			me["EPR2-box"].hide();
			me["EPR2-needle"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			me["EPR3"].show();
			me["EPR3-thr"].show();
			me["EPR3-decpnt"].show();
			me["EPR3-T"].show();
			me["EPR3-H"].show();
			me["EPR3-box"].show();
			me["EPR3-needle"].show();
		} else {
			me["EPR3"].hide();
			me["EPR3-thr"].hide();
			me["EPR3-decpnt"].hide();
			me["EPR3-T"].hide();
			me["EPR3-H"].hide();
			me["EPR3-box"].hide();
			me["EPR3-needle"].hide();
		}
		
		# N1
		me["N11"].setText(sprintf("%d", getprop("/engines/engine[0]/n1-actual") + 0.05));
		me["N11-decimal"].setText(sprintf("%d", int(10 * math.mod(getprop("/engines/engine[0]/n1-actual") + 0.05, 1))));
		me["N12"].setText(sprintf("%d", getprop("/engines/engine[1]/n1-actual") + 0.05));
		me["N12-decimal"].setText(sprintf("%d", int(10 * math.mod(getprop("/engines/engine[1]/n1-actual") + 0.05, 1))));
		me["N13"].setText(sprintf("%d", getprop("/engines/engine[2]/n1-actual") + 0.05));
		me["N13-decimal"].setText(sprintf("%d", int(10 * math.mod(getprop("/engines/engine[2]/n1-actual") + 0.05, 1))));
		
		me["N11-needle"].setRotation((getprop("/DU/EAD/N1[0]") + 90) * D2R);
		me["N12-needle"].setRotation((getprop("/DU/EAD/N1[1]") + 90) * D2R);
		me["N13-needle"].setRotation((getprop("/DU/EAD/N1[2]") + 90) * D2R);
		
		if (Value.Fadec.engPowered[0]) {
			me["N11"].show();
			me["N11-decpnt"].show();
			me["N11-decimal"].show();
			me["N11-needle"].show();
			me["N11-redline"].show();
		} else {
			me["N11"].hide();
			me["N11-decpnt"].hide();
			me["N11-decimal"].hide();
			me["N11-needle"].hide();
			me["N11-redline"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			me["N12"].show();
			me["N12-decpnt"].show();
			me["N12-decimal"].show();
			me["N12-needle"].show();
			me["N12-redline"].show();
		} else {
			me["N12"].hide();
			me["N12-decpnt"].hide();
			me["N12-decimal"].hide();
			me["N12-needle"].hide();
			me["N12-redline"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			me["N13"].show();
			me["N13-decpnt"].show();
			me["N13-decimal"].show();
			me["N13-needle"].show();
			me["N13-redline"].show();
		} else {
			me["N13"].hide();
			me["N13-decpnt"].hide();
			me["N13-decimal"].hide();
			me["N13-needle"].hide();
			me["N13-redline"].hide();
		}
		
		# EGT
		me["EGT1"].setText(sprintf("%d", getprop("/engines/engine[0]/egt-actual")));
		me["EGT2"].setText(sprintf("%d", getprop("/engines/engine[1]/egt-actual")));
		me["EGT3"].setText(sprintf("%d", getprop("/engines/engine[2]/egt-actual")));
		
		me["EGT1-needle"].setRotation((getprop("/DU/EAD/EGT[0]") + 90) * D2R);
		me["EGT2-needle"].setRotation((getprop("/DU/EAD/EGT[1]") + 90) * D2R);
		me["EGT3-needle"].setRotation((getprop("/DU/EAD/EGT[2]") + 90) * D2R);
		
		if (Value.Fadec.engPowered[0]) {
			me["EGT1"].show();
			me["EGT1-needle"].show();
			me["EGT1-yline"].show();
			me["EGT1-redline"].show();
		} else {
			me["EGT1"].hide();
			me["EGT1-needle"].hide();
			me["EGT1-yline"].hide();
			me["EGT1-redline"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			me["EGT2"].show();
			me["EGT2-needle"].show();
			me["EGT2-yline"].show();
			me["EGT2-redline"].show();
		} else {
			me["EGT2"].hide();
			me["EGT2-needle"].hide();
			me["EGT2-yline"].hide();
			me["EGT2-redline"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			me["EGT3"].show();
			me["EGT3-needle"].show();
			me["EGT3-yline"].show();
			me["EGT3-redline"].show();
		} else {
			me["EGT3"].hide();
			me["EGT3-needle"].hide();
			me["EGT3-yline"].hide();
			me["EGT3-redline"].hide();
		}
		
		if (getprop("/controls/engines/ignition-1") == 1 and Value.Fadec.engPowered[0]) {
			me["EGT1-ignition"].show();
		} else {
			me["EGT1-ignition"].hide();
		}
		
		if (getprop("/controls/engines/ignition-2") == 1 and Value.Fadec.engPowered[1]) {
			me["EGT2-ignition"].show();
		} else {
			me["EGT2-ignition"].hide();
		}
		
		if (getprop("/controls/engines/ignition-3") == 1 and Value.Fadec.engPowered[2]) {
			me["EGT3-ignition"].show();
		} else {
			me["EGT3-ignition"].hide();
		}
		
		if (getprop("/controls/engines/engine[0]/start-switch") == 1 and Value.Fadec.engPowered[0]) {
			me["EGT1-redstart"].show();
		} else {
			me["EGT1-redstart"].hide();
		}
		
		if (getprop("/controls/engines/engine[1]/start-switch") == 1 and Value.Fadec.engPowered[1]) {
			me["EGT2-redstart"].show();
		} else {
			me["EGT2-redstart"].hide();
		}
		
		if (getprop("/controls/engines/engine[2]/start-switch") == 1 and Value.Fadec.engPowered[2]) {
			me["EGT3-redstart"].show();
		} else {
			me["EGT3-redstart"].hide();
		}
		
		# N2
		me["N21"].setText(sprintf("%d", getprop("/engines/engine[0]/n2-actual") + 0.05));
		me["N21-decimal"].setText(sprintf("%d", int(10 * math.mod(getprop("/engines/engine[0]/n2-actual") + 0.05, 1))));
		me["N22"].setText(sprintf("%d", getprop("/engines/engine[1]/n2-actual") + 0.05));
		me["N22-decimal"].setText(sprintf("%d", int(10 * math.mod(getprop("/engines/engine[1]/n2-actual") + 0.05, 1))));
		me["N23"].setText(sprintf("%d", getprop("/engines/engine[2]/n2-actual") + 0.05));
		me["N23-decimal"].setText(sprintf("%d", int(10 * math.mod(getprop("/engines/engine[2]/n2-actual") + 0.05, 1))));
		
		me["N21-needle"].setRotation((getprop("/DU/EAD/N2[0]") + 90) * D2R);
		me["N22-needle"].setRotation((getprop("/DU/EAD/N2[1]") + 90) * D2R);
		me["N23-needle"].setRotation((getprop("/DU/EAD/N2[2]") + 90) * D2R);
		
		if (Value.Fadec.engPowered[0]) {
			me["N21"].show();
			me["N21-decpnt"].show();
			me["N21-decimal"].show();
			me["N21-needle"].show();
			me["N21-redline"].show();
		} else {
			me["N21"].hide();
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
		} else {
			me["N22"].hide();
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
		} else {
			me["N23"].hide();
			me["N23-decpnt"].hide();
			me["N23-decimal"].hide();
			me["N23-needle"].hide();
			me["N23-redline"].hide();
		}
		
		if (getprop("/controls/engines/engine[0]/starter") == 1 and getprop("/controls/engines/engine[0]/cutoff") == 1 and Value.Fadec.engPowered[0]) {
			me["N21-cline"].show();
		} else {
			me["N21-cline"].hide();
		}
		
		if (getprop("/controls/engines/engine[1]/starter") == 1 and getprop("/controls/engines/engine[1]/cutoff") == 1 and Value.Fadec.engPowered[1]) {
			me["N22-cline"].show();
		} else {
			me["N22-cline"].hide();
		}
		
		if (getprop("/controls/engines/engine[2]/starter") == 1 and getprop("/controls/engines/engine[2]/cutoff") == 1 and Value.Fadec.engPowered[2]) {
			me["N23-cline"].show();
		} else {
			me["N23-cline"].hide();
		}
		
		# FF
		me["FF1"].setText(sprintf("%d", math.round(getprop("/engines/engine[0]/fuel-flow_actual"), 10)));
		me["FF2"].setText(sprintf("%d", math.round(getprop("/engines/engine[1]/fuel-flow_actual"), 10)));
		me["FF3"].setText(sprintf("%d", math.round(getprop("/engines/engine[2]/fuel-flow_actual"), 10)));
		
		if (Value.Fadec.engPowered[0]) {
			me["FF1"].show();
		} else {
			me["FF1"].hide();
		}
		
		if (Value.Fadec.engPowered[1]) {
			me["FF2"].show();
		} else {
			me["FF2"].hide();
		}
		
		if (Value.Fadec.engPowered[2]) {
			me["FF3"].show();
		} else {
			me["FF3"].hide();
		}
		
		if (getprop("/controls/engines/engine[0]/cutoff") == 1) {
			me["FFOff1"].show();
		} else {
			me["FFOff1"].hide();
		}
		
		if (getprop("/controls/engines/engine[1]/cutoff") == 1) {
			me["FFOff2"].show();
		} else {
			me["FFOff2"].hide();
		}
		
		if (getprop("/controls/engines/engine[2]/cutoff") == 1) {
			me["FFOff3"].show();
		} else {
			me["FFOff3"].hide();
		}
		
		# EPR Limit
		Value.Fadec.eprLimFixed = systems.FADEC.Limit.active.getValue() + 0.006;
		Value.Fadec.activeMode = systems.FADEC.Limit.activeMode.getValue();
		me["EPRLimMode"].setText(sprintf("%s", Value.Fadec.activeMode));
		if (Value.Fadec.activeMode != "T/O" and Value.Fadec.activeMode != "G/A") {
			me["EPRLimRating"].hide();
			me["EPRLimModeGroup"].setTranslation(-90, 0);
		} else {
			me["EPRLimModeGroup"].setTranslation(0, 0);
			me["EPRLimRating"].show();
		}
		me["EPRLim"].setText(sprintf("%1.0f", math.floor(Value.Fadec.eprLimFixed)));
		me["EPRLim-decimal"].setText(sprintf("%d", math.floor((Value.Fadec.eprLimFixed - int(Value.Fadec.eprLimFixed)) * 100)));
		
		me.updateBase();
	},
};

setlistener("sim/signals/fdm-initialized", func {
	EAD_display = canvas.new({
		"name": "EAD",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	EAD_display.addPlacement({"node": "ead.screen"});
	var group_EAD_GE = EAD_display.createGroup();
	var group_EAD_PW = EAD_display.createGroup();

	EAD_GE = canvas_EAD_GE.new(group_EAD_GE, "Aircraft/MD-11/Models/cockpit/instruments/EAD/res/ge.svg");
	EAD_PW = canvas_EAD_PW.new(group_EAD_PW, "Aircraft/MD-11/Models/cockpit/instruments/EAD/res/pw.svg");

	EAD_update.start();
	if (getprop("/systems/acconfig/options/ead-rate") > 1) {
		rateApply();
	}
});

var rateApply = func {
	EAD_update.restart(0.05 * getprop("/systems/acconfig/options/ead-rate"));
}

var EAD_update = maketimer(0.05, func {
	canvas_EAD_base.update();
});

var showEAD = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(EAD_display);
	dlg.set("title", "EAD");
}
