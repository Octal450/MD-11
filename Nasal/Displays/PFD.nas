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
		alt: 0,
		ap1: 0,
		ap1Avail: 0,
		ap2: 0,
		ap2Avail: 0,
		apSound: 0,
		apYokeButton1: 0,
		apYokeButton2: 0,
		ats: 0,
		atsFlash: 0,
		atsWarn: 0,
		fd1: 0,
		fd2: 0,
		land: "",
		pitch: "",
		pitchArm: "",
		roll: "",
		rollArm: "",
		throttle: "",
	},
	Ai: {
		bankLimit: 0,
		pitch: 0,
		roll: 0,
	},
	Alt: {
		indicated: 0,
		Tape: {
			five: 0,
			fiveT: "000",
			four: 0,
			fourT: "000",
			middleAltOffset: 0,
			middleAltText: 0,
			offset: 0,
			one: 0,
			oneT: "000",
			three: 0,
			threeT: "000",
			two: 0,
			twoT: "000",
		},
	},
	Asi: {
		flapGearMax: 0,
		ias: 0,
		mach: 0,
		preSel: 0,
		sel: 0,
		stall: 0,
		vmoMmo: 0,
		Tape: {
			flapGearMax: 0,
			ias: 0,
			preSel: 0,
			sel: 0,
			stall: 0,
			vmoMmo: 0,
		},
	},
	Hdg: {
		indicated: 0,
		preSel: 0,
		sel: 0,
		showHdg: 0,
		Tape: {
			preSel: 0,
			sel: 0,
		},
		text: 0,
		track: 0,
	},
	Iru: {
		aligned: [0, 0, 0],
		aligning: [0, 0, 0],
	},
	Misc: {
		flapsCmd: 0,
		flapsOut: 0,
		flapsPos: 0,
		minimums: 0,
		slatsCmd: 0,
		slatsOut: 0,
		slatsPos: 0,
	},
	Nav: {
		gsInRange: 0,
		inRange: 0,
		signalQuality: 0,
	},
	Qnh: {
		inhg: 0,
	},
	Ra: {
		agl: 0,
	},
	Vs: {
		digit: 0,
		indicated: 0,
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
		
		me.AI_fpv_trans = me["AI_fpv"].createTransform();
		me.AI_fpv_rot = me["AI_fpv"].createTransform();
		
		me.AI_fpd_trans = me["AI_fpd"].createTransform();
		me.AI_fpd_rot = me["AI_fpd"].createTransform();
		
		me.page = canvasGroup;
		
		return me;
	},
	getKeys: func() {
		return ["FMA_Speed", "FMA_Thrust", "FMA_Roll", "FMA_Roll_Arm", "FMA_Pitch", "FMA_Pitch_Land", "FMA_Land", "FMA_Pitch_Arm", "FMA_Altitude_Thousand", "FMA_Altitude", "FMA_ATS_Thrust_Off", "FMA_ATS_Pitch_Off", "FMA_AP_Pitch_Off_Box", "FMA_AP_Thrust_Off_Box",
		"FMA_AP", "ASI_ias_group", "ASI_taxi_group", "ASI_taxi", "ASI_groundspeed", "ASI_v_speed", "ASI_scale", "ASI_bowtie_mach", "ASI", "ASI_mach", "ASI_mach_decimal", "ASI_bowtie_L", "ASI_bowtie_R", "ASI_presel", "ASI_sel", "ASI_trend_up", "ASI_trend_down",
		"ASI_vmo", "ASI_vmo_bar", "ASI_vmo_bar2", "ASI_flap_max", "ASI_stall", "ASI_stall_warn", "AI_center", "AI_horizon", "AI_bank", "AI_slipskid", "AI_overbank_index", "AI_banklimit_L", "AI_banklimit_R", "AI_alphalim", "AI_group", "AI_group2", "AI_group3",
		"AI_error", "AI_fpv", "AI_fpd", "AI_arrow_up", "AI_arrow_dn", "FD_roll", "FD_pitch", "ALT_thousands", "ALT_hundreds", "ALT_tens", "ALT_scale", "ALT_scale_num", "ALT_one", "ALT_two", "ALT_three", "ALT_four", "ALT_five", "ALT_one_T", "ALT_two_T",
		"ALT_three_T", "ALT_four_T", "ALT_five_T", "ALT_presel", "ALT_sel", "ALT_agl", "ALT_bowtie", "VSI_needle_up", "VSI_needle_dn", "VSI_up", "VSI_down", "VSI_group", "VSI_error", "HDG", "HDG_dial", "HDG_presel", "HDG_sel", "HDG_group", "HDG_error",
		"TRK_pointer", "TCAS_OFF", "Slats", "Slats_up", "Slats_dn", "Flaps", "Flaps_up", "Flaps_dn", "Flaps_num", "Flaps_num2", "Flaps_num_boxes", "QNH", "LOC_scale", "LOC_pointer", "LOC_no", "GS_scale", "GS_pointer", "GS_no", "RA", "RA_box", "Minimums"];
	},
	setup: func() {
		# Hide the pages by default
		pfd1.page.hide();
		pfd1Error.page.hide();
		pfd2.page.hide();
		pfd2Error.page.hide();
	},
	update: func() {
		if (systems.DUController.updatePfd1) {
			pfd1.update();
		}
		if (systems.DUController.updatePfd2) {
			pfd2.update();
		}
	},
	updateSlow: func() {
		if (systems.DUController.updatePfd1) {
			pfd1.updateSlow();
		}
		if (systems.DUController.updatePfd2) {
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
			
			Value.Asi.vmoMmo = pts.Fdm.JSBsim.Fcc.Speeds.vmoMmo.getValue();
			if (Value.Asi.vmoMmo <= 50) {
				Value.Asi.Tape.vmoMmo = 0 - Value.Asi.Tape.ias;
			} else if (Value.Asi.vmoMmo >= 500) {
				Value.Asi.Tape.vmoMmo = 450 - Value.Asi.Tape.ias;
			} else {
				Value.Asi.Tape.vmoMmo = Value.Asi.vmoMmo - 50 - Value.Asi.Tape.ias;
			}
			
			Value.Asi.flapGearMax = pts.Fdm.JSBsim.Fcc.Speeds.flapGearMax.getValue();
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
			
			Value.Asi.stall = pts.Fdm.JSBsim.Fcc.Speeds.stall.getValue();
			if (Value.Asi.stall < 0) {
				me["ASI_stall"].hide();
			} else if (Value.Asi.stall <= 50) {
				Value.Asi.Tape.stall = 0 - Value.Asi.Tape.ias;
				me["ASI_stall"].show();
			} else if (Value.Asi.stall >= 500) {
				Value.Asi.Tape.stall = 450 - Value.Asi.Tape.ias;
				me["ASI_stall"].show();
			} else {
				Value.Asi.Tape.stall = Value.Asi.stall - 50 - Value.Asi.Tape.ias;
				me["ASI_stall"].show();
			}
			
			me["ASI_scale"].setTranslation(0, Value.Asi.Tape.ias * 4.48656);
			me["ASI_vmo"].setTranslation(0, Value.Asi.Tape.vmoMmo * -4.48656);
			me["ASI_flap_max"].setTranslation(0, Value.Asi.Tape.flapGearMax * -4.48656);
			me["ASI_stall"].setTranslation(0, Value.Asi.Tape.stall * -4.48656);
			me["ASI_stall"].setTranslation(0, Value.Asi.Tape.stall * -4.48656);
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
			} else if (Value.Asi.ias < Value.Asi.stall - 0.5) {
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
		Value.Hdg.track = pts.Instrumentation.Pfd.trackBug.getValue();
		
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
			me.AI_fpv_trans.setTranslation(math.clamp(Value.Hdg.track, -20, 20) * 10.246, math.clamp(Value.Ai.alpha, -20, 20) * 10.246);
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
		
		# ALT
		Value.Alt.indicated = pts.Instrumentation.Altimeter.indicatedAltitudeFt.getValue();
		Value.Alt.Tape.offset = Value.Alt.indicated / 500 - int(Value.Alt.indicated / 500);
		Value.Alt.Tape.middleAltText = roundAboutAlt(Value.Alt.indicated / 100) * 100;
		Value.Alt.Tape.middleAltOffset = nil;
		
		if (Value.Alt.Tape.offset > 0.5) {
			Value.Alt.Tape.middleAltOffset = -(Value.Alt.Tape.offset - 1) * 254.508;
		} else {
			Value.Alt.Tape.middleAltOffset = -Value.Alt.Tape.offset * 254.508;
		}
		
		me["ALT_scale"].setTranslation(0, -Value.Alt.Tape.middleAltOffset);
		me["ALT_scale_num"].setTranslation(0, -Value.Alt.Tape.middleAltOffset);
		me["ALT_scale"].update();
		me["ALT_scale_num"].update();
		
		Value.Alt.Tape.five = int((Value.Alt.Tape.middleAltText + 1000) * 0.001);
		me["ALT_five"].setText(sprintf("%03d", abs(1000 * (((Value.Alt.Tape.middleAltText + 1000) * 0.001) - Value.Alt.Tape.five))));
		Value.Alt.Tape.fiveT = sprintf("%01d", abs(Value.Alt.Tape.five));
		
		if (Value.Alt.Tape.fiveT == 0) {
			me["ALT_five_T"].setText(" ");
		} else {
			me["ALT_five_T"].setText(Value.Alt.Tape.fiveT);
		}
		
		Value.Alt.Tape.four = int((Value.Alt.Tape.middleAltText + 500) * 0.001);
		me["ALT_four"].setText(sprintf("%03d", abs(1000 * (((Value.Alt.Tape.middleAltText + 500) * 0.001) - Value.Alt.Tape.four))));
		Value.Alt.Tape.fourT = sprintf("%01d", abs(Value.Alt.Tape.four));
		
		if (Value.Alt.Tape.fourT == 0) {
			me["ALT_four_T"].setText(" ");
		} else {
			me["ALT_four_T"].setText(Value.Alt.Tape.fourT);
		}
		
		Value.Alt.Tape.three = int(Value.Alt.Tape.middleAltText * 0.001);
		me["ALT_three"].setText(sprintf("%03d", abs(1000 * ((Value.Alt.Tape.middleAltText  * 0.001) - Value.Alt.Tape.three))));
		Value.Alt.Tape.threeT = sprintf("%01d", abs(Value.Alt.Tape.three));
		
		if (Value.Alt.Tape.threeT == 0) {
			me["ALT_three_T"].setText(" ");
		} else {
			me["ALT_three_T"].setText(Value.Alt.Tape.threeT);
		}
		
		Value.Alt.Tape.two = int((Value.Alt.Tape.middleAltText - 500) * 0.001);
		me["ALT_two"].setText(sprintf("%03d", abs(1000 * (((Value.Alt.Tape.middleAltText - 500) * 0.001) - Value.Alt.Tape.two))));
		Value.Alt.Tape.twoT = sprintf("%01d", abs(Value.Alt.Tape.two));
		
		if (Value.Alt.Tape.twoT == 0) {
			me["ALT_two_T"].setText(" ");
		} else {
			me["ALT_two_T"].setText(Value.Alt.Tape.twoT);
		}
		
		Value.Alt.Tape.one = int((Value.Alt.Tape.middleAltText - 1000) * 0.001);
		me["ALT_one"].setText(sprintf("%03d", abs(1000 * (((Value.Alt.Tape.middleAltText - 1000) * 0.001) - Value.Alt.Tape.one))));
		Value.Alt.Tape.oneT = sprintf("%01d", abs(Value.Alt.Tape.one));
		
		if (Value.Alt.Tape.oneT == 0) {
			me["ALT_one_T"].setText(" ");
		} else {
			me["ALT_one_T"].setText(Value.Alt.Tape.oneT);
		}
		
		if (Value.Alt.indicated < 0) {
			altPolarity = "-";
		} else {
			altPolarity = "";
		}
		
		me["ALT_thousands"].setText(sprintf("%s%d", altPolarity, math.abs(int(Value.Alt.indicated / 1000))));
		me["ALT_hundreds"].setText(sprintf("%d", math.floor(num(right(sprintf("%03d", abs(Value.Alt.indicated)), 3)) / 100)));
		altTens = num(right(sprintf("%02d", Value.Alt.indicated), 2));
		me["ALT_tens"].setTranslation(0, altTens * 2.1325);
		
		if (afs.Internal.altAlert.getBoolValue()) {
			me["ALT_bowtie"].setColor(0.9412,0.7255,0);
		} else {
			me["ALT_bowtie"].setColor(1,1,1);
		}
		
		me["ALT_presel"].setTranslation(0, (pts.Instrumentation.Pfd.altPreSel.getValue() / 100) * -50.9016);
		me["ALT_sel"].setTranslation(0, (pts.Instrumentation.Pfd.altSel.getValue() / 100) * -50.9016);
		
		Value.Ra.agl = pts.Position.gearAglFt.getValue();
		me["ALT_agl"].setTranslation(0, (math.clamp(Value.Ra.agl, -700, 700) / 100) * 50.9016);
		
		# VS
		Value.Vs.digit = pts.Instrumentation.Pfd.vsDigit.getValue();
		Value.Vs.indicated = afs.Internal.vs.getValue();
		
		if (Value.Vs.indicated > -50) {
			me["VSI_needle_up"].setTranslation(0, pts.Instrumentation.Pfd.vsNeedleUp.getValue());
			me["VSI_needle_up"].show();
		} else {
			me["VSI_needle_up"].hide();
		}
		if (Value.Vs.indicated < 50) {
			me["VSI_needle_dn"].setTranslation(0, pts.Instrumentation.Pfd.vsNeedleDn.getValue());
			me["VSI_needle_dn"].show();
		} else {
			me["VSI_needle_dn"].hide();
		}
		
		if (Value.Vs.indicated > 10 and Value.Vs.digit > 0) {
			me["VSI_up"].setText(sprintf("%1.1f", Value.Vs.digit));
			me["VSI_up"].show();
		} else {
			me["VSI_up"].hide();
		}
		if (Value.Vs.indicated < -10 and Value.Vs.digit > 0) {
			me["VSI_down"].setText(sprintf("%1.1f", Value.Vs.digit));
			me["VSI_down"].show();
		} else {
			me["VSI_down"].hide();
		}
		
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
		
		# RA and Minimums
		Value.Misc.minimums = pts.Controls.Switches.minimums.getValue();
		
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
		
		# HDG
		Value.Hdg.indicated = pts.Instrumentation.Pfd.hdgScale.getValue();
		Value.Hdg.indicatedFixed = Value.Hdg.indicated + 0.5;
		
		if (Value.Hdg.indicatedFixed > 359) {
			Value.Hdg.indicatedFixed = Value.Hdg.indicatedFixed - 360;
		}
		if (Value.Hdg.indicatedFixed < 0) {
			Value.Hdg.indicatedFixed = Value.Hdg.indicatedFixed + 360;
		}
		Value.Hdg.text = sprintf("%03d", Value.Hdg.indicatedFixed);
		
		if (Value.Hdg.text == "360") {
			Value.Hdg.text == "000";
		}
		me["HDG"].setText(Value.Hdg.text);
		me["HDG_dial"].setRotation(Value.Hdg.indicated * -D2R);
		
		Value.Hdg.preSel = pts.Instrumentation.Pfd.hdgPreSel.getValue();
		Value.Hdg.sel = pts.Instrumentation.Pfd.hdgSel.getValue();
		Value.Hdg.showHdg = afs.Output.showHdg.getBoolValue();
		
		if (Value.Hdg.preSel <= 35 and Value.Hdg.preSel >= -35) {
			Value.Hdg.Tape.preSel = Value.Hdg.preSel;
		} else if (Value.Hdg.preSel > 35) {
			Value.Hdg.Tape.preSel = 35;
		} else if (Value.Hdg.preSel < -35) {
			Value.Hdg.Tape.preSel = -35;
		}
		if (Value.Hdg.sel <= 35 and Value.Hdg.sel >= -35) {
			Value.Hdg.Tape.sel = Value.Hdg.sel;
		} else if (Value.Hdg.sel > 35) {
			Value.Hdg.Tape.sel = 35;
		} else if (Value.Hdg.sel < -35) {
			Value.Hdg.Tape.sel = -35;
		}
		
		if (Value.Hdg.showHdg) {
			me["HDG_presel"].setRotation(Value.Hdg.Tape.preSel * D2R);
			me["HDG_presel"].show();
		} else {
			me["HDG_presel"].hide();
		}
		if (Value.Hdg.showHdg and afs.Output.lat.getValue() == 0) {
			me["HDG_sel"].setRotation(Value.Hdg.Tape.sel * D2R);
			me["HDG_sel"].show();
		} else {
			me["HDG_sel"].hide();
		}
		
		me["TRK_pointer"].setRotation(Value.Hdg.track * D2R);
	},
	updateSlowBase: func() {
		# FMA
		me["FMA_Pitch_Arm"].setText(sprintf("%s", Value.Afs.pitchArm));
		me["FMA_Roll_Arm"].setText(sprintf("%s", Value.Afs.rollArm));
		
		if (Value.Afs.land == "DUAL") {
			me["FMA_Roll"].setColor(0,1,0);
		} else if (Value.Afs.roll == "NAV1" or Value.Afs.roll == "NAV2") {
			me["FMA_Roll"].setColor(0.9607,0,0.7764);
		} else {
			me["FMA_Roll"].setColor(1,1,1);
		}
		
		if (Value.Afs.rollArm == "NAV ARMED") {
			me["FMA_Roll_Arm"].setColor(0.9607,0,0.7764);
		} else {
			me["FMA_Roll_Arm"].setColor(1,1,1);
		}
		
		if (Value.Afs.land == "DUAL") {
			me["FMA_Altitude"].hide();
			me["FMA_Altitude_Thousand"].hide();
			me["FMA_Land"].setColor(0,1,0);
			me["FMA_Land"].setText("DUAL LAND");
			me["FMA_Land"].show();
			me["FMA_Pitch_Land"].setColor(0,1,0);
			me["FMA_Pitch_Land"].setText(sprintf("%s", Value.Afs.pitch));
			me["FMA_Pitch_Land"].show();
		} else if (Value.Afs.land == "SINGLE") {
			me["FMA_Altitude"].hide();
			me["FMA_Altitude_Thousand"].hide();
			me["FMA_Land"].setColor(1,1,1);
			me["FMA_Land"].setText("SINGLE LAND");
			me["FMA_Land"].show();
			me["FMA_Pitch_Land"].setColor(1,1,1);
			me["FMA_Pitch_Land"].setText(sprintf("%s", Value.Afs.pitch));
			me["FMA_Pitch_Land"].show();
		} else if (Value.Afs.land == "APPR") {
			me["FMA_Altitude"].hide();
			me["FMA_Altitude_Thousand"].hide();
			me["FMA_Land"].setColor(1,1,1);
			me["FMA_Land"].setText("APPR ONLY");
			me["FMA_Land"].show();
			me["FMA_Pitch_Land"].setColor(1,1,1);
			me["FMA_Pitch_Land"].setText(sprintf("%s", Value.Afs.pitch));
			me["FMA_Pitch_Land"].show();
		} else {
			Value.Afs.alt = afs.Internal.alt.getValue();
			me["FMA_Altitude"].setText(right(sprintf("%03d", Value.Afs.alt), 3));
			me["FMA_Altitude"].show();
			if (Value.Afs.alt < 1000) {
				me["FMA_Altitude_Thousand"].hide();
			} else {
				me["FMA_Altitude_Thousand"].setText(sprintf("%2.0f", math.floor(Value.Afs.alt / 1000)));
				me["FMA_Altitude_Thousand"].show();
			}
			me["FMA_Land"].hide();
			me["FMA_Pitch_Land"].hide();
		}
		
		if (Value.Afs.pitch == "ROLLOUT") {
			me["FMA_Pitch_Land"].setTranslation(-10, 0);
		} else {
			me["FMA_Pitch_Land"].setTranslation(0, 0);
		}
		
		if (Value.Afs.throttle == "RETARD") {
			me["FMA_Speed"].hide();
		} else {
			if (afs.Internal.ktsMach.getBoolValue()) {
				me["FMA_Speed"].setText("." ~ sprintf("%03d", afs.Internal.mach.getValue() * 1000));
			} else {
				me["FMA_Speed"].setText(sprintf("%03d", afs.Internal.kts.getValue()));
			}
			me["FMA_Speed"].show();
		}
		
		Value.Afs.ap1Avail = afs.Output.ap1Avail.getBoolValue();
		Value.Afs.ap2Avail = afs.Output.ap2Avail.getBoolValue();
		Value.Afs.apSound = afs.Sound.apOff.getBoolValue();
		Value.Afs.apWarn = afs.Warning.ap.getBoolValue();
		Value.Afs.apYokeButton1 = pts.Controls.Switches.apYokeButton1.getBoolValue();
		Value.Afs.apYokeButton2 = pts.Controls.Switches.apYokeButton2.getBoolValue();
		Value.Afs.atsFlash = afs.Warning.atsFlash.getBoolValue();
		Value.Afs.atsWarn = afs.Warning.ats.getBoolValue();
		
		if (Value.Afs.atsFlash) {
			me["FMA_ATS_Pitch_Off"].setColor(1,0,0);
			me["FMA_ATS_Thrust_Off"].setColor(1,0,0);
		} else if (!afs.Output.athrAvail.getBoolValue()) {
			me["FMA_ATS_Pitch_Off"].setColor(0.9412,0.7255,0);
			me["FMA_ATS_Thrust_Off"].setColor(0.9412,0.7255,0);
		} else {
			me["FMA_ATS_Pitch_Off"].setColor(1,1,1);
			me["FMA_ATS_Thrust_Off"].setColor(1,1,1);
		}
		
		if (Value.Afs.apSound) {
			me["FMA_AP_Pitch_Off_Box"].setColor(1,0,0);
			me["FMA_AP_Thrust_Off_Box"].setColor(1,0,0);
		} else if (!Value.Afs.ap1Avail and !Value.Afs.ap2Avail) {
			me["FMA_AP_Pitch_Off_Box"].setColor(0.9412,0.7255,0);
			me["FMA_AP_Thrust_Off_Box"].setColor(0.9412,0.7255,0);
		} else if ((Value.Afs.apYokeButton1 or Value.Afs.apYokeButton2) and !Value.Afs.ap1 and !Value.Afs.ap2) {
			me["FMA_AP_Pitch_Off_Box"].setColor(0.9412,0.7255,0);
			me["FMA_AP_Thrust_Off_Box"].setColor(0.9412,0.7255,0);
		} else {
			me["FMA_AP_Pitch_Off_Box"].setColor(1,1,1);
			me["FMA_AP_Thrust_Off_Box"].setColor(1,1,1);
		}
		
		if (Value.Afs.ats == 1) {
			me["FMA_ATS_Pitch_Off"].hide();
			me["FMA_ATS_Thrust_Off"].hide();
		} else if (Value.Afs.atsFlash and !Value.Afs.atsWarn) {
			me["FMA_ATS_Pitch_Off"].hide();
			me["FMA_ATS_Thrust_Off"].hide();
		} else if (Value.Afs.atsFlash and Value.Afs.atsWarn and Value.Afs.throttle == "PITCH") {
			me["FMA_ATS_Pitch_Off"].show();
			me["FMA_ATS_Thrust_Off"].hide();
		} else if (Value.Afs.atsFlash and Value.Afs.atsWarn and Value.Afs.throttle != "PITCH") {
			me["FMA_ATS_Pitch_Off"].hide();
			me["FMA_ATS_Thrust_Off"].show();
		} else if (Value.Afs.throttle == "PITCH") {
			me["FMA_ATS_Pitch_Off"].show();
			me["FMA_ATS_Thrust_Off"].hide();
		} else {
			me["FMA_ATS_Pitch_Off"].hide();
			me["FMA_ATS_Thrust_Off"].show();
		}
		
		if (Value.Afs.ap1 or Value.Afs.ap2) {
			me["FMA_AP"].setColor(0.3215,0.8078,1);
			me["FMA_AP"].setText(sprintf("%s", afs.Fma.ap.getValue()));
			me["FMA_AP"].show();
		} else if (Value.Afs.apSound and !Value.Afs.apWarn) {
			me["FMA_AP"].hide();
		} else if (Value.Afs.apSound and Value.Afs.apWarn) {
			me["FMA_AP"].setColor(1,0,0);
			me["FMA_AP"].setText("AP OFF");
			me["FMA_AP"].show();
		} else if (Value.Afs.apYokeButton1 or Value.Afs.apYokeButton2 or (!Value.Afs.ap1Avail and !Value.Afs.ap2Avail)) {
			me["FMA_AP"].setColor(0.9412,0.7255,0);
			me["FMA_AP"].setText("AP OFF");
			me["FMA_AP"].show();
		} else {
			me["FMA_AP"].setColor(1,1,1);
			me["FMA_AP"].setText("AP OFF");
			me["FMA_AP"].show();
		}
		
		if (Value.Afs.ap1 or Value.Afs.ap2) {
			me["FMA_AP_Pitch_Off_Box"].hide();
			me["FMA_AP_Thrust_Off_Box"].hide();
		} else if (Value.Afs.apSound and !Value.Afs.apWarn) {
			me["FMA_AP_Pitch_Off_Box"].hide();
			me["FMA_AP_Thrust_Off_Box"].hide();
		} else if (Value.Afs.apSound and Value.Afs.apWarn and Value.Afs.throttle == "PITCH") {
			me["FMA_AP_Pitch_Off_Box"].show();
			me["FMA_AP_Thrust_Off_Box"].hide();
		} else if (Value.Afs.apSound and Value.Afs.apWarn and Value.Afs.throttle != "PITCH") {
			me["FMA_AP_Pitch_Off_Box"].hide();
			me["FMA_AP_Thrust_Off_Box"].show();
		} else if (Value.Afs.throttle == "PITCH") {
			me["FMA_AP_Pitch_Off_Box"].show();
			me["FMA_AP_Thrust_Off_Box"].hide();
		} else {
			me["FMA_AP_Pitch_Off_Box"].hide();
			me["FMA_AP_Thrust_Off_Box"].show();
		}
		
		# QNH
		Value.Qnh.inhg = pts.Instrumentation.Altimeter.inhg.getBoolValue();
		if (pts.Instrumentation.Altimeter.std.getBoolValue()) {
			if (Value.Qnh.inhg == 0) {
				me["QNH"].setText("1013");
			} else if (Value.Qnh.inhg == 1) {
				me["QNH"].setText("29.92");
			}
		} else if (Value.Qnh.inhg == 0) {
			me["QNH"].setText(sprintf("%4.0f", pts.Instrumentation.Altimeter.settingHpa.getValue()));
		} else if (Value.Qnh.inhg == 1) {
			me["QNH"].setText(sprintf("%2.2f", pts.Instrumentation.Altimeter.settingInhg.getValue()));
		}
		
		# Minimums
		me["Minimums"].setText(sprintf("%4.0f", Value.Misc.minimums)); # Variable update in updateBase
		
		# Slats/Flaps
		Value.Misc.flapsCmd = pts.Controls.Flight.flapsCmd.getValue();
		Value.Misc.flapsPos = pts.Fdm.JSBsim.Fcs.flapPosDeg.getValue();
		Value.Misc.slatsCmd = pts.Controls.Flight.slatsCmd.getValue();
		Value.Misc.slatsPos = pts.Fdm.JSBsim.Fcs.slatPosDeg.getValue();
		
		Value.Misc.flapsOut = Value.Misc.flapsCmd > 0.1 or Value.Misc.flapsPos > 0.1;
		Value.Misc.slatsOut = Value.Misc.slatsCmd > 0.1 or Value.Misc.slatsPos > 0.1;
		
		if (Value.Misc.slatsOut and !(Value.Misc.slatsPos > 30.9 and Value.Misc.flapsOut)) {
			me["Slats"].show();
			if (Value.Misc.slatsCmd - Value.Misc.slatsPos > 0.1) {
				me["Slats_dn"].show();
				me["Slats_up"].hide();
			} else if (Value.Misc.slatsCmd - Value.Misc.slatsPos < -0.1) {
				me["Slats_dn"].hide();
				me["Slats_up"].show();
			} else {
				me["Slats_dn"].hide();
				me["Slats_up"].hide();
			}
		} else {
			me["Slats"].hide();
			me["Slats_up"].hide();
			me["Slats_dn"].hide();
		}
		
		if (Value.Misc.flapsOut) {
			me["Flaps"].show();
			me["Flaps_num"].setText(sprintf("%2.0f", Value.Misc.flapsCmd));
			me["Flaps_num"].show();
		} else {
			me["Flaps"].hide();
			me["Flaps_num"].hide();
		}
		
		if (Value.Misc.flapsOut and Value.Misc.flapsCmd - 0.1 > pts.Fdm.JSBsim.Fcc.Flap.maxDeg.getValue()) {
			me["Flaps_dn"].hide();
			me["Flaps_up"].hide();
			me["Flaps_num"].setColor(0.9647,0.8196,0.0784);
			me["Flaps_num_boxes"].show();
			me["Flaps_num2"].setText(sprintf("%2.0f", Value.Misc.flapsCmd));
			me["Flaps_num2"].show();
		} else {
			if (Value.Misc.flapsCmd - Value.Misc.flapsPos > 0.1) {
				me["Flaps_dn"].show();
				me["Flaps_up"].hide();
			} else if (Value.Misc.flapsCmd - Value.Misc.flapsPos < -0.1) {
				me["Flaps_dn"].hide();
				me["Flaps_up"].show();
			} else {
				me["Flaps_dn"].hide();
				me["Flaps_up"].hide();
			}
			me["Flaps_num"].setColor(1,1,1);
			me["Flaps_num_boxes"].hide();
			me["Flaps_num2"].hide();
		}
		
		# TCAS Off
		if (pts.Instrumentation.Transponder.Inputs.knobMode.getValue() == 5) {
			me["TCAS_OFF"].hide();
		} else {
			me["TCAS_OFF"].show();
		}
	},
};

var canvasPfd1 = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasPfd1, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	update: func() {
		me.updateBase();
	},
	updateSlow: func() {
		# Provide the value to here and the base
		Value.Afs.ap1 = afs.Output.ap1.getBoolValue();
		Value.Afs.ap2 = afs.Output.ap2.getBoolValue();
		Value.Afs.ats = afs.Output.athr.getBoolValue();
		Value.Afs.fd1 = afs.Output.fd1.getBoolValue();
		Value.Afs.land = afs.Text.land.getValue();
		Value.Afs.pitch = afs.Fma.pitch.getValue();
		Value.Afs.pitchArm = afs.Fma.pitchArm.getValue();
		Value.Afs.roll = afs.Fma.roll.getValue();
		Value.Afs.rollArm = afs.Fma.rollArm.getValue();
		Value.Afs.throttle = afs.Text.thr.getValue();
		
		# FMA
		if (Value.Afs.fd1) {
			if (Value.Afs.land == "OFF") {
				me["FMA_Pitch"].setText(sprintf("%s", Value.Afs.pitch));
				me["FMA_Pitch"].show();
			} else {
				me["FMA_Pitch"].hide();
			}
			if (Value.Afs.roll == "HEADING" or Value.Afs.roll == "TRACK") {
				me["FMA_Roll"].setText(sprintf("%s", Value.Afs.roll ~ " " ~ sprintf("%03d", afs.Internal.hdg.getValue())));
			} else {
				me["FMA_Roll"].setText(sprintf("%s", Value.Afs.roll));
			}
			me["FMA_Roll"].show();
			me["FMA_Thrust"].setText(sprintf("%s", Value.Afs.throttle));
			me["FMA_Thrust"].show();
		} else {
			if (Value.Afs.throttle == "PITCH") {
				if (Value.Afs.ap1 or Value.Afs.ap2) {
					me["FMA_Thrust"].setText(sprintf("%s", Value.Afs.throttle));
					me["FMA_Thrust"].show();
				} else {
					me["FMA_Thrust"].hide();
				}
				if (Value.Afs.ats and Value.Afs.land == "OFF") {
					me["FMA_Pitch"].setText(sprintf("%s", Value.Afs.pitch));
					me["FMA_Pitch"].show();
				} else {
					me["FMA_Pitch"].hide();
				}
			} else {
				if ((Value.Afs.ap1 or Value.Afs.ap2) and Value.Afs.land == "OFF") {
					me["FMA_Pitch"].setText(sprintf("%s", Value.Afs.pitch));
					me["FMA_Pitch"].show();
				} else {
					me["FMA_Pitch"].hide();
				}
				if (Value.Afs.ats) {
					me["FMA_Thrust"].setText(sprintf("%s", Value.Afs.throttle));
					me["FMA_Thrust"].show();
				} else {
					me["FMA_Thrust"].hide();
				}
			}
			
			if (Value.Afs.ap1 or Value.Afs.ap2) {
				if (Value.Afs.roll == "HEADING" or Value.Afs.roll == "TRACK") {
					me["FMA_Roll"].setText(sprintf("%s", Value.Afs.roll ~ " " ~ sprintf("%03d", afs.Internal.hdg.getValue())));
				} else {
					me["FMA_Roll"].setText(sprintf("%s", Value.Afs.roll));
				}
				me["FMA_Roll"].show();
			} else {
				me["FMA_Roll"].hide();
			}
		}
		
		# FD
		if (Value.Afs.fd1) {
			me["FD_pitch"].show();
			me["FD_roll"].show();
		} else {
			me["FD_pitch"].hide();
			me["FD_roll"].hide();
		}
		
		if (Value.Iru.aligned[0]) { # Variable update in updateBase
			me["AI_group"].show();
			me["AI_group2"].show();
			me["AI_group3"].show();
			me["HDG_group"].show();
			me["VSI_group"].show();
			me["AI_error"].hide();
			me["HDG_error"].hide();
			me["VSI_error"].hide();
		} else {
			me["AI_error"].show();
			me["HDG_error"].show();
			me["VSI_error"].show();
			me["AI_group"].hide();
			me["AI_group2"].hide();
			me["AI_group3"].hide();
			me["HDG_group"].hide();
			me["VSI_group"].hide();
		}
		
		me.updateSlowBase();
	},
};

var canvasPfd2 = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasPfd2, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	update: func() {
		me.updateBase();
	},
	updateSlow: func() {
		# Provide the value to here and the base
		Value.Afs.ap1 = afs.Output.ap1.getBoolValue();
		Value.Afs.ap2 = afs.Output.ap2.getBoolValue();
		Value.Afs.ats = afs.Output.athr.getBoolValue();
		Value.Afs.fd2 = afs.Output.fd2.getBoolValue();
		Value.Afs.land = afs.Text.land.getValue();
		Value.Afs.pitch = afs.Fma.pitch.getValue();
		Value.Afs.pitchArm = afs.Fma.pitchArm.getValue();
		Value.Afs.roll = afs.Fma.roll.getValue();
		Value.Afs.rollArm = afs.Fma.rollArm.getValue();
		Value.Afs.throttle = afs.Text.thr.getValue();
		
		# FMA
		if (Value.Afs.fd2) {
			me["FMA_Pitch"].setText(sprintf("%s", Value.Afs.pitch));
			me["FMA_Pitch"].show();
			if (Value.Afs.roll == "HEADING" or Value.Afs.roll == "TRACK") {
				me["FMA_Roll"].setText(sprintf("%s", Value.Afs.roll ~ " " ~ sprintf("%03d", afs.Internal.hdg.getValue())));
			} else {
				me["FMA_Roll"].setText(sprintf("%s", Value.Afs.roll));
			}
			me["FMA_Roll"].show();
			me["FMA_Thrust"].setText(sprintf("%s", Value.Afs.throttle));
			me["FMA_Thrust"].show();
		} else {
			if (Value.Afs.throttle == "PITCH") {
				if (Value.Afs.ats) {
					me["FMA_Pitch"].setText(sprintf("%s", Value.Afs.pitch));
					me["FMA_Pitch"].show();
				} else {
					me["FMA_Pitch"].hide();
				}
				if (Value.Afs.ap1 or Value.Afs.ap2) {
					me["FMA_Thrust"].setText(sprintf("%s", Value.Afs.throttle));
					me["FMA_Thrust"].show();
				} else {
					me["FMA_Thrust"].hide();
				}
			} else {
				if (Value.Afs.ap1 or Value.Afs.ap2) {
					me["FMA_Pitch"].setText(sprintf("%s", Value.Afs.pitch));
					me["FMA_Pitch"].show();
				} else {
					me["FMA_Pitch"].hide();
				}
				if (Value.Afs.ats) {
					me["FMA_Thrust"].setText(sprintf("%s", Value.Afs.throttle));
					me["FMA_Thrust"].show();
				} else {
					me["FMA_Thrust"].hide();
				}
			}
			
			if (Value.Afs.ap1 or Value.Afs.ap2) {
				if (Value.Afs.roll == "HEADING" or Value.Afs.roll == "TRACK") {
					me["FMA_Roll"].setText(sprintf("%s", Value.Afs.roll ~ " " ~ sprintf("%03d", afs.Internal.hdg.getValue())));
				} else {
					me["FMA_Roll"].setText(sprintf("%s", Value.Afs.roll));
				}
				me["FMA_Roll"].show();
			} else {
				me["FMA_Roll"].hide();
			}
		}
		
		# FD
		if (Value.Afs.fd2) {
			me["FD_pitch"].show();
			me["FD_roll"].show();
		} else {
			me["FD_pitch"].hide();
			me["FD_roll"].hide();
		}
		
		if (Value.Iru.aligned[1]) { # Variable update in updateBase
			me["AI_group"].show();
			me["AI_group2"].show();
			me["AI_group3"].show();
			me["HDG_group"].show();
			me["VSI_group"].show();
			me["AI_error"].hide();
			me["HDG_error"].hide();
			me["VSI_error"].hide();
		} else {
			me["AI_error"].show();
			me["HDG_error"].show();
			me["VSI_error"].show();
			me["AI_group"].hide();
			me["AI_group2"].hide();
			me["AI_group3"].hide();
			me["HDG_group"].hide();
			me["VSI_group"].hide();
		}
		
		me.updateSlowBase();
	},
};

var canvasPfd1Error = {
	init: func(canvasGroup, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(canvasGroup, file, {"font-mapper": font_mapper});
		
		var svgKeys = me.getKeys();
		foreach(var key; svgKeys) {
			me[key] = canvasGroup.getElementById(key);
		}
		
		me.page = canvasGroup;
		
		return me;
	},
	new: func(canvasGroup, file) {
		var m = {parents: [canvasPfd1Error]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Error_Code"];
	},
	update: func() {
		me["Error_Code"].setText(acconfig.SYSTEM.Error.code.getValue());
	},
};

var canvasPfd2Error = {
	init: func(canvasGroup, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(canvasGroup, file, {"font-mapper": font_mapper});
		
		var svgKeys = me.getKeys();
		foreach(var key; svgKeys) {
			me[key] = canvasGroup.getElementById(key);
		}
		
		me.page = canvasGroup;
		
		return me;
	},
	new: func(canvasGroup, file) {
		var m = {parents: [canvasPfd2Error]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Error_Code"];
	},
	update: func() {
		me["Error_Code"].setText(acconfig.SYSTEM.Error.code.getValue());
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
	
	canvasBase.setup();
	pfdUpdate.start();
	pfdSlowUpdate.start();
	
	if (pts.Systems.Acconfig.Options.Du.pfdFps.getValue() != 20) {
		rateApply();
	}
}

var rateApply = func() {
	pfdUpdate.restart(1 / pts.Systems.Acconfig.Options.Du.pfdFps.getValue());
	pfdSlowUpdate.restart(1 / (pts.Systems.Acconfig.Options.Du.pfdFps.getValue() * 0.5)); # 10 / 20 = 0.5
}

var pfdUpdate = maketimer(0.05, func() { # 20FPS
	canvasBase.update();
});

var pfdSlowUpdate = maketimer(0.1, func() { # 10FPS
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
