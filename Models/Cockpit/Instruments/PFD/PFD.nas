# McDonnell Douglas MD-11 PFD
# Copyright (c) 2020 Josh Davidson (Octal450)

var pfd1Display = nil;
var pfd2Display = nil;
var pfd1 = nil;
var pfd1Error = nil;
var pfd2 = nil;
var pfd2Error = nil;

# Slow update enable
var updatePfd1 = 0;
var updatePfd2 = 0;

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
	Asi: {
		flapGearMax: 0,
		ias: 0,
		mach: 0,
		preSel: 0,
		sel: 0,
		vmoMmo: 0,
		Tape: {
			flapGearMax: 0,
			ias: 0,
			preSel: 0,
			sel: 0,
			vmoMmo: 0,
		},
	},
	Iru: {
		aligned: [0, 0, 0],
		aligning: [0, 0, 0],
	},
	Misc: {
		minimums: 0,
	},
	Nav: {
		Freq: {
			selected: [0, 0],
			selectedInteger: [0, 0],
			selectedDecimal: [0, 0],
		},
		gsInRange: 0,
		inRange: 0,
		signalQuality: 0,
	},
	Ra: {
		agl: 0,
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
		"FMA_AP", "ASI_ias_group", "ASI_taxi_group", "ASI_taxi", "ASI_groundspeed", "ASI_v_speed", "ASI_scale", "ASI_bowtie_mach", "ASI", "ASI_mach", "ASI_mach_decimal", "ASI_bowtie_L", "ASI_bowtie_R", "ASI_presel", "ASI_sel", "ASI_trend_up", "ASI_trend_down",
		"ASI_vmo", "ASI_vmo_bar", "ASI_vmo_bar2", "ASI_flap_max", "AI_center", "AI_horizon", "AI_bank", "AI_slipskid", "AI_overbank_index", "AI_banklimit_L", "AI_banklimit_R", "AI_alphalim", "AI_group", "AI_group2", "AI_group3", "AI_error", "AI_fpv", "AI_fpd",
		"AI_arrow_up", "AI_arrow_dn", "FD_roll", "FD_pitch", "ALT_thousands", "ALT_hundreds", "ALT_tens", "ALT_scale", "ALT_scale_num", "ALT_one", "ALT_two", "ALT_three", "ALT_four", "ALT_five", "ALT_one_T", "ALT_two_T", "ALT_three_T", "ALT_four_T", "ALT_five_T",
		"ALT_presel", "ALT_sel", "ALT_agl", "ALT_bowtie", "VSI_needle_up", "VSI_needle_dn", "VSI_up", "VSI_down", "VSI_group", "VSI_error", "HDG", "HDG_dial", "HDG_presel", "HDG_sel", "HDG_group", "HDG_error", "TRK_pointer", "TCAS_OFF", "Slats", "Flaps",
		"Flaps_num", "Flaps_num2", "Flaps_num_boxes", "QNH", "LOC_scale", "LOC_pointer", "LOC_no", "GS_scale", "GS_pointer", "GS_no", "RA", "RA_box", "Minimums"];
	},
	update: func() {
		if (pts.Systems.Acconfig.errorCode.getValue() == "0x000") {
			pfd1Error.page.hide();
			pfd2Error.page.hide();
			if (systems.ELEC.Bus.lEmerAc.getValue() >= 110) {
				updatePfd1 = 1;
				pfd1.update();
				pfd1.page.show();
			} else {
				updatePfd1 = 0;
				pfd1.page.hide();
			}
			if (systems.ELEC.Bus.ac3.getValue() >= 110) {
				updatePfd2 = 1;
				pfd2.update();
				pfd2.page.show();
			} else {
				updatePfd2 = 0;
				pfd2.page.hide();
			}
		} else {
			updatePfd1 = 0;
			updatePfd2 = 0;
			pfd1.page.hide();
			pfd2.page.hide();
			pfd1Error.update();
			pfd2Error.update();
			pfd1Error.page.show();
			pfd2Error.page.show();
		}
	},
	updateSlow: func() { # Turned on of off by the fast update so that syncing is correct
		if (updatePfd1) {
			pfd1.updateSlow();
		}
		if (updatePfd2) {
			pfd2.updateSlow();
		}
	},
	updateBase: func() {
		Value.Iru.aligned[0] = systems.IRS.Iru.aligned[0].getBoolValue();
		Value.Iru.aligned[1] = systems.IRS.Iru.aligned[1].getBoolValue();
		Value.Iru.aligned[2] = systems.IRS.Iru.aligned[2].getBoolValue();
		Value.Iru.aligning[0] = systems.IRS.Iru.aligning[0].getBoolValue();
		Value.Iru.aligning[1] = systems.IRS.Iru.aligning[1].getBoolValue();
		Value.Iru.aligning[2] = systems.IRS.Iru.aligning[2].getBoolValue();
		
		# ASI
		me["ASI_v_speed"].hide(); # Not working yet
		
		Value.Asi.ias = pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue();
		Value.Asi.mach = pts.Instrumentation.AirspeedIndicator.indicatedMach.getValue();
		Value.Asi.trend = pts.Instrumentation.Pfd.speedTrend.getValue();
		
		if (Value.Asi.ias < 50) {
			if (Value.Iru.aligning[0] or Value.Iru.aligning[1] or Value.Iru.aligning[2]) {
				me["ASI_groundspeed"].setColor(0.9412,0.7255,0);
				me["ASI_groundspeed"].setText("NO");
				me["ASI_taxi"].setColor(0.9412,0.7255,0);
			} else if (!Value.Iru.aligned[0] and !Value.Iru.aligned[1] and !Value.Iru.aligned[2]) {
				me["ASI_groundspeed"].setColor(1,1,1);
				me["ASI_groundspeed"].setText("--");
				me["ASI_taxi"].setColor(1,1,1);
			} else {
				me["ASI_groundspeed"].setColor(1,1,1);
				me["ASI_groundspeed"].setText(sprintf("%3.0f", pts.Velocities.groundspeedKt.getValue()));
				me["ASI_taxi"].setColor(1,1,1);
			}
			
			me["ASI_ias_group"].hide();
			me["ASI_taxi_group"].show();
		} else {
			# Subtract 50, since the scale starts at 50, but don't allow less than 0, or more than 500 situations
			if (Value.Asi.ias <= 50) {
				Value.Asi.Tape.ias = 0;
			} else if (Value.Asi.ias >= 500) {
				Value.Asi.Tape.ias = 450;
			} else {
				Value.Asi.Tape.ias = Value.Asi.ias - 50;
			}
			
			Value.Asi.vmoMmo = pts.Controls.Fctl.vmoMmo.getValue();
			if (Value.Asi.vmoMmo <= 50) {
				Value.Asi.Tape.vmoMmo = 0 - Value.Asi.Tape.ias;
			} else if (Value.Asi.vmoMmo >= 500) {
				Value.Asi.Tape.vmoMmo = 450 - Value.Asi.Tape.ias;
			} else {
				Value.Asi.Tape.vmoMmo = Value.Asi.vmoMmo - 50 - Value.Asi.Tape.ias;
			}
			
			Value.Asi.flapGearMax = pts.Controls.Fctl.flapGearMax.getValue();
			if (Value.Asi.flapGearMax < 0) {
				Value.Asi.Tape.flapGearMax = 0;
				me["ASI_flap_max"].hide();
				me["ASI_vmo_bar"].show();
				me["ASI_vmo_bar2"].hide();
			} else if (Value.Asi.flapGearMax <= 50) {
				Value.Asi.Tape.flapGearMax = 0 - Value.Asi.Tape.ias;
				me["ASI_flap_max"].show();
				me["ASI_vmo_bar"].hide();
				me["ASI_vmo_bar2"].show();
			} else if (Value.Asi.flapGearMax >= 500) {
				Value.Asi.Tape.flapGearMax = 450 - Value.Asi.Tape.ias;
				me["ASI_flap_max"].show();
				me["ASI_vmo_bar"].hide();
				me["ASI_vmo_bar2"].show();
			} else {
				Value.Asi.Tape.flapGearMax = Value.Asi.flapGearMax - 50 - Value.Asi.Tape.ias;
				me["ASI_flap_max"].show();
				me["ASI_vmo_bar"].hide();
				me["ASI_vmo_bar2"].show();
			}
			
			me["ASI_scale"].setTranslation(0, Value.Asi.Tape.ias * 4.48656);
			me["ASI_vmo"].setTranslation(0, Value.Asi.Tape.vmoMmo * -4.48656);
			me["ASI_flap_max"].setTranslation(0, Value.Asi.Tape.flapGearMax * -4.48656);
			me["ASI"].setText(sprintf("%3.0f", math.round(Value.Asi.ias)));
			
			if (Value.Asi.mach >= 0.5) {
				if (Value.Asi.mach >= 0.999) {
					me["ASI_mach"].setText("999");
				} else {
					me["ASI_mach"].setText(sprintf("%3.0f", Value.Asi.mach * 1000));
				}
				me["ASI_bowtie_mach"].show();
			} else {
				me["ASI_bowtie_mach"].hide();
			}
			
			if (Value.Asi.ias > Value.Asi.vmoMmo + 0.5) {
				me["ASI"].setColor(1,0,0);
				me["ASI_bowtie_L"].setColor(1,0,0);
				me["ASI_bowtie_R"].setColor(1,0,0);
				me["ASI_mach"].setColor(1,0,0);
				me["ASI_mach_decimal"].setColor(1,0,0);
			} else if (Value.Asi.ias > Value.Asi.flapGearMax + 0.5 and Value.Asi.flapGearMax >= 0) {
				me["ASI"].setColor(0.9647,0.8196,0.07843);
				me["ASI_bowtie_L"].setColor(0.9647,0.8196,0.0784);
				me["ASI_bowtie_R"].setColor(0.9647,0.8196,0.0784);
				me["ASI_mach"].setColor(0.9647,0.8196,0.0784);
				me["ASI_mach_decimal"].setColor(0.9647,0.8196,0.0784);
			} else {
				me["ASI"].setColor(1,1,1);
				me["ASI_bowtie_L"].setColor(1,1,1);
				me["ASI_bowtie_R"].setColor(1,1,1);
				me["ASI_mach"].setColor(1,1,1);
				me["ASI_mach_decimal"].setColor(1,1,1);
			}
			
			Value.Asi.preSel = pts.Instrumentation.Pfd.iasPreSel.getValue();
			Value.Asi.sel = pts.Instrumentation.Pfd.iasSel.getValue();
			
			if (Value.Asi.preSel <= 50) {
				Value.Asi.Tape.preSel = 0 - Value.Asi.Tape.ias;
			} else if (Value.Asi.preSel >= 500) {
				Value.Asi.Tape.preSel = 450 - Value.Asi.Tape.ias;
			} else {
				Value.Asi.Tape.preSel = Value.Asi.preSel - 50 - Value.Asi.Tape.ias;
			}
			
			if (Value.Asi.sel <= 50) {
				Value.Asi.Tape.sel = 0 - Value.Asi.Tape.ias;
			} else if (Value.Asi.sel >= 500) {
				Value.Asi.Tape.sel = 450 - Value.Asi.Tape.ias;
			} else {
				Value.Asi.Tape.sel = Value.Asi.sel - 50 - Value.Asi.Tape.ias;
			}
			
			me["ASI_presel"].setTranslation(0, Value.Asi.Tape.preSel * -4.48656);
			me["ASI_sel"].setTranslation(0, Value.Asi.Tape.sel * -4.48656);
			
			# Let the whole ASI tape update before showing
			me["ASI_ias_group"].show();
			me["ASI_taxi_group"].hide();
		}
		
		# Keep trend outside if/else above so it animates nicely
		if (Value.Asi.trend >= 2) {
			me["ASI_trend_down"].hide();
			me["ASI_trend_up"].setTranslation(0, math.clamp(Value.Asi.trend, 0, 60) * -4.48656);
			me["ASI_trend_up"].show();
		} else if (Value.Asi.trend <= -2) {
			me["ASI_trend_down"].setTranslation(0, math.clamp(Value.Asi.trend, -60, 0) * -4.48656);
			me["ASI_trend_down"].show();
			me["ASI_trend_up"].hide();
		} else {
			me["ASI_trend_down"].hide();
			me["ASI_trend_up"].hide();
		}
		
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
		
		if (Value.Ai.pitch > 25) {
			me["AI_arrow_up"].setRotation(math.clamp(-Value.Ai.roll, -45, 45) * D2R);
			me["AI_arrow_dn"].hide();
			me["AI_arrow_up"].show();
		} else if (Value.Ai.pitch < -15) {
			me["AI_arrow_dn"].setRotation(math.clamp(-Value.Ai.roll, -45, 45) * D2R);
			me["AI_arrow_dn"].show();
			me["AI_arrow_up"].hide();
		} else {
			me["AI_arrow_dn"].hide();
			me["AI_arrow_up"].hide();
		}
		
		me["FD_pitch"].setTranslation(0, -afs.Fd.pitchBar.getValue() * 3.8);
		me["FD_roll"].setTranslation(afs.Fd.rollBar.getValue() * 2.2, 0);
		
		# Altitude
		# todo
		
		# ILS
		Value.Nav.inRange = pts.Instrumentation.Nav.inRange[0].getBoolValue();
		Value.Nav.signalQuality = pts.Instrumentation.Nav.signalQualityNorm[0].getValue();
		if (Value.Nav.inRange) {
			me["LOC_scale"].show();
			if (pts.Instrumentation.Nav.navLoc[0].getBoolValue() and Value.Nav.signalQuality > 0.99) {
				me["LOC_pointer"].setTranslation(pts.Instrumentation.Nav.headingNeedleDeflectionNorm[0].getValue() * 200, 0);
				me["LOC_pointer"].show();
				me["LOC_no"].hide();
			} else {
				me["LOC_pointer"].hide();
				me["LOC_no"].show();
			}
		} else {
			me["LOC_scale"].hide();
			me["LOC_pointer"].hide();
			me["LOC_no"].hide();
		}
		
		Value.Nav.gsInRange = pts.Instrumentation.Nav.gsInRange[0].getBoolValue();
		if (Value.Nav.inRange) {
			me["GS_scale"].show();
			if (Value.Nav.gsInRange and pts.Instrumentation.Nav.hasGs[0].getBoolValue() and Value.Nav.signalQuality > 0.99) {
				me["GS_pointer"].setTranslation(0, pts.Instrumentation.Nav.gsNeedleDeflectionNorm[0].getValue() * -204);
				me["GS_pointer"].show();
				me["GS_no"].hide();
			} else {
				me["GS_pointer"].hide();
				me["GS_no"].show();
			}
		} else {
			me["GS_scale"].hide();
			me["GS_pointer"].hide();
			me["GS_no"].hide();
		}
		
		# RA and Minimums - Move to slow
		Value.Ra.agl = pts.Position.gearAglFt.getValue();
		Value.Misc.minimums = pts.Controls.Switches.minimums.getValue();
		
		me["Minimums"].setText(sprintf("%4.0f", Value.Misc.minimums));
		
		if (Value.Ra.agl <= 2500) {
			if (Value.Ra.agl <= Value.Misc.minimums) {
				me["Minimums"].setColor(0.9412,0.7255,0);
				me["RA"].setColor(0.9412,0.7255,0);
				me["RA_box"].setColor(0.9412,0.7255,0);
			} else {
				me["Minimums"].setColor(1,1,1);
				me["RA"].setColor(1,1,1);
				me["RA_box"].setColor(1,1,1);
			}
			if (Value.Ra.agl <= 5) {
				me["RA"].setText(sprintf("%4.0f", math.round(Value.Ra.agl)));
			} else if (Value.Ra.agl <= 50) {
				me["RA"].setText(sprintf("%4.0f", math.round(Value.Ra.agl, 5)));
			} else {
				me["RA"].setText(sprintf("%4.0f", math.round(Value.Ra.agl, 10)));
			}
			me["RA"].show();
			me["RA_box"].show();
		} else {
			me["RA"].hide();
			me["RA_box"].hide();
		}
	},
	updateSlowBase: func() {
		
	},
};

var canvasPfd1 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvasPfd1, canvasBase]};
		m.init(canvas_group, file);
		
		return m;
	},
	update: func() {
		me.updateBase();
	},
	updateSlow: func() {
		# Provide the value to here and the base
		Value.Afs.fd1 = afs.Output.fd1.getBoolValue();
		
		# FD
		if (Value.Afs.fd1) {
			me["FD_pitch"].show();
			me["FD_roll"].show();
		} else {
			me["FD_pitch"].hide();
			me["FD_roll"].hide();
		}
		
		me.updateSlowBase();
	},
};

var canvasPfd2 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvasPfd2, canvasBase]};
		m.init(canvas_group, file);
		
		return m;
	},
	update: func() {
		me.updateBase();
	},
	updateSlow: func() {
		# Provide the value to here and the base
		Value.Afs.fd2 = afs.Output.fd2.getBoolValue();
		
		# FD
		if (Value.Afs.fd2) {
			me["FD_pitch"].show();
			me["FD_roll"].show();
		} else {
			me["FD_pitch"].hide();
			me["FD_roll"].hide();
		}
		
		me.updateSlowBase();
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
	pfdSlowUpdate.start();
	
	if (pts.Systems.Acconfig.Options.pfdRate.getValue() > 1) {
		rateApply();
	}
}

var rateApply = func() {
	pfdUpdate.restart(pts.Systems.Acconfig.Options.pfdRate.getValue() * 0.05);
	pfdSlowUpdate.restart(pts.Systems.Acconfig.Options.pfdRate.getValue() * 0.15);
}

var pfdUpdate = maketimer(0.05, func() {
	canvasBase.update();
});

var pfdSlowUpdate = maketimer(0.15, func() {
	canvasBase.updateSlow();
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
