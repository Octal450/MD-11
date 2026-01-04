# McDonnell Douglas MD-11 PFD
# Copyright (c) 2026 Josh Davidson (Octal450)

var pfd1 = nil;
var pfd1Display = nil;
var pfd2 = nil;
var pfd2Display = nil;
var xx1 = nil;
var xx2 = nil;

var Value = {
	Afs: {
		alt: 0,
		altSel: 0,
		apDisc: [0, 0],
		ap1: 0,
		ap1Avail: 0,
		ap2: 0,
		ap2Avail: 0,
		apSound: 0,
		ats: 0,
		atsFlash: 0,
		atsWarn: 0,
		bit: [0, 0],
		fd: [0, 0],
		fmsSpdDriving: 0,
		hdg: 0,
		hdgPreSel: 0,
		kts: 0,
		ktsPreSel: 0,
		ktsMach: 0,
		ktsMachFms: 0,
		ktsMachFmsEcon: 0,
		ktsMachPreSel: 0,
		lat: 0,
		mach: 0,
		machPreSel: 0,
		land: "",
		pitch: "",
		pitchArm: "",
		roll: "",
		rollArm: "",
		spdPitchAvail: 0,
		spdProt: 0,
		thrust: "",
		vert: 0,
		vertText: "",
		vs: 0,
	},
	Ai: {
		alpha: 0,
		bankLimit: 0,
		center: nil,
		pitch: 0,
		pliAnimate: [0, 0],
		roll: 0,
		slipSkid: 0,
		stallAlphaDeg: 0,
		stallWarnAlphaDeg: 0,
	},
	Alt: {
		alert: 0,
		indicated: 0,
		indicatedAbs: 0,
		preSel: 0,
		sel: 0,
		Tape: {
			five: 0,
			fiveI: 0,
			fiveT: "",
			four: 0,
			fourI: 0,
			fourT: "",
			hundreds: 0,
			hundredsGeneva: 0,
			middleOffset: 0,
			middleText: 0,
			offset: 0,
			one: 0,
			oneI: 0,
			oneT: "",
			tenThousands: 0,
			tenThousandsGeneva: 0,
			thousands: 0,
			thousandsGeneva: 0,
			three: 0,
			threeI: 0,
			threeT: "",
			tens: 0,
			two: 0,
			twoI: 0,
			twoT: "",
		},
	},
	Asi: {
		f15: 0,
		f28: 0,
		f35: 0,
		f50: 0,
		flapGearMax: 0,
		fms: 0,
		fmsEcon: 0,
		hideV1: 0,
		hideVr: 0,
		ias: 0,
		mach: 0,
		preSel: 0,
		sel: 0,
		showFmsEcon: 0,
		showPreSel: 0,
		showTaxi: 0,
		trend: 0,
		vfr: 0,
		vmin: 0,
		vmoMmo: 0,
		vsr: 0,
		vss: 0,
		Tape: {
			f15: 0,
			f28: 0,
			f35: 0,
			f50: 0,
			flapGearMax: 0,
			fms: 0,
			fmsEcon: 0,
			fr: 0,
			ge: 0,
			gr: 0,
			ias: 0,
			preSel: 0,
			se: 0,
			sel: 0,
			sr: 0,
			v1: 0,
			v1Final: 0,
			v2: 0,
			v2Final: 0,
			vmin: 0,
			vmoMmo: 0,
			vr: 0,
			vrFinal: 0,
			vss: 0,
		},
	},
	Hdg: {
		hideHdgSel: 0,
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
		mainAvail: [0, 0, 0],
		source: [0, 1],
	},
	Misc: {
		annunTestWow: 0,
		blinkFast: 0,
		blinkMed: 0,
		blinkMed2: 0,
		flapsCmd: 0,
		flapsOut: 0,
		flapsPos: 0,
		gearOut: 0,
		innerMarker: 0,
		middleMarker: 0,
		minimums: 0,
		minimumsMode: 0,
		minimumsRefAlt: 0,
		outerMarker: 0,
		risingRunwayTBar: 0,
		slatsCmd: 0,
		slatsOut: 0,
		slatsPos: 0,
		twoEngineOn: 0,
		wow: 0,
	},
	Nav: {
		gsInRange: 0,
		gsNeedleDeflectionNorm: 0,
		hasGs: 0,
		headingNeedleDeflectionNorm: 0,
		navLoc: 0,
		selectedMhz: 0,
		signalQuality: 0,
	},
	Qnh: {
		inhg: 0,
	},
	Ra: {
		agl: 0,
		below: 0,
		time: -10,
	},
	Vs: {
		digit: 0,
		indicated: 0,
	},
};

var canvasBase = {
	init: func(canvasGroup, file) {
		var font_mapper = func(family, weight) {
			return "MD11DU.ttf";
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
		
		me.aiBackgroundTrans = me["AI_background"].createTransform();
		me.aiBackgroundRot = me["AI_background"].createTransform();
		
		me.aiScaleTrans = me["AI_scale"].createTransform();
		me.aiScaleRot = me["AI_scale"].createTransform();
		
		me.fpdTrans = me["FPD"].createTransform();
		me.fpdRot = me["FPD"].createTransform();
		
		me.fpvTrans = me["FPV"].createTransform();
		me.fpvRot = me["FPV"].createTransform();
		
		me.fdVTrans = me["FD_v"].createTransform();
		me.fdVRot = me["FD_v"].createTransform();
		
		me.page = canvasGroup;
		
		return me;
	},
	getKeys: func() {
		return ["AI_background", "AI_bank", "AI_bank_mask", "AI_banklimit_L", "AI_banklimit_R", "AI_center", "AI_dual_cue", "AI_error", "AI_group", "AI_group2", "AI_group3", "AI_group4", "AI_overbank_index", "AI_PLI", "AI_PLI_dual_cue", "AI_PLI_single_cue",
		"AI_rising_runway", "AI_rising_runway_E", "AI_scale", "AI_slipskid", "AI_slipskid_t", "AI_single_cue", "ALT_agl", "ALT_bowtie", "ALT_error", "ALT_five", "ALT_five_T", "ALT_fms", "ALT_fms_dn", "ALT_fms_up", "ALT_four", "ALT_four_T", "ALT_hundreds",
		"ALT_hundreds_zero", "ALT_minimums", "ALT_minus", "ALT_one", "ALT_one_T", "ALT_presel", "ALT_scale", "ALT_sel", "ALT_sel_dn", "ALT_sel_dn_text", "ALT_sel_dn_text_T", "ALT_sel_up", "ALT_sel_up_text", "ALT_sel_up_text_T", "ALT_tens", "ALT_tens_dash",
		"ALT_tenthousands", "ALT_thousands", "ALT_thousands_zero", "ALT_three", "ALT_three_T", "ALT_two", "ALT_two_T", "ASI", "ASI_bowtie", "ASI_bowtie_L", "ASI_bowtie_mach", "ASI_bowtie_R", "ASI_error", "ASI_f15", "ASI_f15_p", "ASI_f15_t", "ASI_f28",
		"ASI_f28_p", "ASI_f28_t", "ASI_f35", "ASI_f35_p", "ASI_f35_t", "ASI_f50", "ASI_f50_p", "ASI_f50_t", "ASI_flap_max", "ASI_fms", "ASI_fms_dn", "ASI_fms_econ", "ASI_fms_econ_mach_text", "ASI_fms_mach_text", "ASI_fms_up", "ASI_fr", "ASI_fr_p", "ASI_fr_t",
		"ASI_ge", "ASI_ge_p", "ASI_ge_t", "ASI_gr", "ASI_gr_p", "ASI_gr_t", "ASI_groundspeed", "ASI_ias_group", "ASI_mach", "ASI_mach_decimal", "ASI_mach_presel", "ASI_mach_presel_text", "ASI_mach_sel", "ASI_mach_sel_dn", "ASI_mach_sel_up", "ASI_mach_sel_text",
		"ASI_presel", "ASI_ref_bugs", "ASI_scale", "ASI_se", "ASI_se_p", "ASI_se_t", "ASI_sel", "ASI_sel_dn", "ASI_sel_dn_text", "ASI_sel_up", "ASI_sel_up_text", "ASI_sr", "ASI_sr_p", "ASI_sr_t", "ASI_taxi", "ASI_taxi_group", "ASI_trend_dn", "ASI_trend_up",
		"ASI_v_bugs", "ASI_v1_bug", "ASI_v1_bug_n", "ASI_v1_bug_p", "ASI_v1_bug_v", "ASI_v1_box", "ASI_v1_dash", "ASI_v1_text", "ASI_v2_bug", "ASI_v2_bug_n", "ASI_v2_bug_p", "ASI_v2_bug_v", "ASI_v2_box", "ASI_v2_dash", "ASI_v2_text", "ASI_vr_bug", "ASI_vr_bug_n",
		"ASI_vr_bug_p", "ASI_vr_bug_v", "ASI_vr_box", "ASI_vr_dash", "ASI_vr_text", "ASI_vmin", "ASI_vmin_bar", "ASI_vmo", "ASI_vmo_bar", "ASI_vmo_bar2", "ASI_vss", "Comparators", "FD_error", "FD_group", "FD_group2", "FD_pitch", "FD_roll", "FD_v", "Flaps_error",
		"Flaps", "Flaps_dn", "Flaps_num", "Flaps_num2", "Flaps_num_boxes", "Flaps_up", "FMA_altitude", "FMA_altitude_T", "FMA_AP", "FMA_AP_pitch_off_box", "FMA_AP_thrust_off_box", "FMA_ATS_pitch_off", "FMA_ATS_pitch_off_box", "FMA_ATS_pitch_off_text",
		"FMA_ATS_thrust_off", "FMA_ATS_thrust_off_box", "FMA_ATS_thrust_off_text", "FMA_land", "FMA_pitch", "FMA_pitch_arm", "FMA_pitch_land", "FMA_roll", "FMA_roll_arm", "FMA_speed", "FMA_thrust", "FMA_thrust_arm", "FPD", "FPV", "GS_error", "GS_no",
		"GS_pointer", "GS_scale", "HDG", "HDG_dial", "HDG_error", "HDG_error2", "HDG_group", "HDG_group2", "HDG_magtru", "HDG_mode", "HDG_presel", "HDG_sel", "HDG_sel_left_text", "HDG_sel_right_text", "ILS_alt", "ILS_DME", "ILS_info", "Inner_marker", "IRS_aux",
		"LOC_error", "LOC_no", "LOC_pointer", "LOC_scale", "Middle_marker", "Minimums", "MinimumsMode", "Outer_marker", "QFE_disab", "QNH", "RA", "RA_box", "RA_error", "RA_group", "Slats", "Slats_auto", "Slats_dn", "Slats_no", "Slats_up", "TCAS", "TCAS_1",
		"TCAS_2", "TRK_pointer", "VSI_bug_dn", "VSI_bug_up", "VSI_dn", "VSI_error", "VSI_group", "VSI_needle_dn", "VSI_needle_up", "VSI_up"];
	},
	setup: func() {
		# Hide the pages by default
		pfd1.page.hide();
		pfd1.setup();
		pfd2.page.hide();
		pfd2.setup();
		xx1.page.hide();
		xx2.page.hide();
	},
	update: func() {
		if (systems.DUController.updatePfd1) {
			pfd1.update();
		}
		if (systems.DUController.updatePfd2) {
			pfd2.update();
		}
	},
	updateBase: func(n) {
		Value.Afs.ap1 = afs.Output.ap1.getBoolValue();
		Value.Afs.ap2 = afs.Output.ap2.getBoolValue();
		Value.Afs.ats = afs.Output.athr.getBoolValue();
		if (n == 0) Value.Afs.bit[0] = systems.FCC.bit1.getBoolValue();
		if (n == 1) Value.Afs.bit[1] = systems.FCC.bit2.getBoolValue();
		if (n == 0) Value.Afs.fd[0] = afs.Output.fd1.getBoolValue();
		if (n == 1) Value.Afs.fd[1] = afs.Output.fd2.getBoolValue();
		Value.Afs.hdg = afs.Internal.hdg.getValue();
		Value.Afs.hdgPreSel = afs.Input.hdg.getValue();
		Value.Afs.kts = afs.Internal.kts.getValue();
		Value.Afs.ktsPreSel = afs.Input.kts.getValue();
		Value.Afs.ktsMach = pts.Instrumentation.Pfd.ktsMachSel.getBoolValue();
		Value.Afs.ktsMachFms = pts.Instrumentation.Pfd.ktsMachFms.getBoolValue();
		Value.Afs.ktsMachFmsEcon = pts.Instrumentation.Pfd.ktsMachFmsEcon.getBoolValue();
		Value.Afs.ktsMachPreSel = pts.Instrumentation.Pfd.ktsMachPreSel.getBoolValue();
		Value.Afs.lat = afs.Output.lat.getValue();
		Value.Afs.land = afs.Text.land.getValue();
		Value.Afs.mach = afs.Internal.mach.getValue();
		Value.Afs.machPreSel = afs.Input.mach.getValue();
		Value.Afs.pitch = afs.Fma.pitch.getValue();
		Value.Afs.pitchArm = afs.Fma.pitchArm.getValue();
		Value.Afs.roll = afs.Fma.roll.getValue();
		Value.Afs.rollArm = afs.Fma.rollArm.getValue();
		Value.Afs.spdPitchAvail = afs.Internal.spdPitchAvail.getBoolValue();
		Value.Afs.thrust = afs.Text.spd.getValue();
		Value.Afs.vert = afs.Output.vert.getValue();
		Value.Afs.vertText = afs.Text.vert.getValue();
		Value.Ai.alpha = pts.Fdm.JSBSim.Aero.alphaDegDamped.getValue();
		Value.Ai.stallAlphaDeg = systems.FCC.stallAlphaDeg.getValue();
		Value.Ai.stallWarnAlphaDeg = systems.FCC.stallWarnAlphaDeg.getValue();
		Value.Asi.flapGearMax = fms.Speeds.flapGearMax.getValue();
		Value.Asi.fms = pts.Instrumentation.Pfd.spdFms.getValue();
		Value.Asi.fmsEcon = pts.Instrumentation.Pfd.spdFmsEcon.getValue();
		Value.Asi.ias = pts.Instrumentation.AirspeedIndicator.indicatedSpeedKt.getValue();
		Value.Asi.mach = pts.Instrumentation.AirspeedIndicator.indicatedMach.getValue();
		Value.Asi.preSel = pts.Instrumentation.Pfd.spdPreSel.getValue();
		Value.Asi.sel = pts.Instrumentation.Pfd.spdSel.getValue();
		Value.Asi.trend = pts.Instrumentation.Pfd.speedTrend.getValue();
		Value.Asi.vfr = fms.Speeds.vfr.getValue();
		Value.Asi.vmin = fms.Speeds.vminTape.getValue();
		Value.Asi.vmoMmo = fms.Speeds.vmoMmo.getValue();
		Value.Asi.vsr = fms.Speeds.vsr.getValue();
		Value.Asi.vss = fms.Speeds.vssTape.getValue();
		Value.Iru.aligned[0] = systems.IRS.Iru.aligned[0].getBoolValue();
		Value.Iru.aligned[1] = systems.IRS.Iru.aligned[1].getBoolValue();
		Value.Iru.aligned[2] = systems.IRS.Iru.aligned[2].getBoolValue();
		Value.Iru.aligning[0] = systems.IRS.Iru.aligning[0].getBoolValue();
		Value.Iru.aligning[1] = systems.IRS.Iru.aligning[1].getBoolValue();
		Value.Iru.aligning[2] = systems.IRS.Iru.aligning[2].getBoolValue();
		Value.Iru.mainAvail[0] = systems.IRS.Iru.mainAvail[0].getBoolValue();
		Value.Iru.mainAvail[1] = systems.IRS.Iru.mainAvail[1].getBoolValue();
		Value.Iru.mainAvail[2] = systems.IRS.Iru.mainAvail[2].getBoolValue();
		Value.Misc.blinkFast = pts.Systems.Libraries.blinkFast.getBoolValue();
		Value.Misc.blinkMed = pts.Systems.Libraries.blinkMed.getBoolValue();
		Value.Misc.blinkMed2 = pts.Systems.Libraries.blinkMed2.getBoolValue();
		Value.Misc.elapsedSec = pts.Sim.Time.elapsedSec.getValue();
		Value.Misc.flapsCmd = systems.FCS.flapsCmd.getValue();
		Value.Misc.flapsPos = systems.FCS.flapsDeg.getValue();
		Value.Misc.flapsOut = Value.Misc.flapsCmd >= 0.1 or Value.Misc.flapsPos >= 0.1;
		Value.Misc.gearOut = systems.GEAR.allNorm.getValue() > 0;
		Value.Misc.slatsCmd = systems.FCS.slatsCmd.getValue();
		Value.Misc.slatsPos = systems.FCS.slatsDeg.getValue();
		Value.Misc.slatsOut = Value.Misc.slatsCmd >= 0.1 or Value.Misc.slatsPos >= 0.1;
		Value.Misc.twoEngineOn = systems.ENGINES.twoEngineOn.getBoolValue();
		Value.Misc.wow = pts.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["ALT_error"].show();
			me["ASI_error"].show();
			me["Comparators"].show();
			me["FD_error"].show();
			me["Flaps_error"].show();
			me["HDG_error2"].show();
			me["GS_error"].show();
			me["ILS_alt"].show();
			me["LOC_error"].show();
			me["RA_error"].show();
		} else {
			me["ALT_error"].hide();
			me["ASI_error"].hide();
			me["Comparators"].hide();
			me["FD_error"].hide();
			me["Flaps_error"].hide();
			me["HDG_error2"].hide();
			me["GS_error"].hide();
			me["ILS_alt"].hide();
			me["LOC_error"].hide();
			me["RA_error"].hide();
		}
		
		# IRS
		if (Value.Iru.aligned[Value.Iru.source[n]]) {
			if (Value.Misc.annunTestWow) {
				me["AI_error"].show();
				me["HDG_error"].show();
				me["VSI_error"].show();
			} else {
				me["AI_error"].hide();
				me["HDG_error"].hide();
				me["VSI_error"].hide();
			}
			
			me["AI_group"].show();
			me["AI_group2"].show();
			me["AI_group3"].show();
			me["AI_group4"].show();
			me["AI_scale"].show();
			me["FD_group"].show();
			me["FD_group2"].show();
			me["HDG_group"].show();
			me["HDG_group2"].show();
			me["VSI_group"].show();
			
			Value.Ai.pliAnimate[n] = 1;
		} else if (Value.Iru.aligning[Value.Iru.source[n]]) {
			if (Value.Misc.annunTestWow) {
				me["AI_error"].show();
				me["HDG_error"].show();
				me["VSI_error"].show();
			} else {
				me["AI_error"].hide();
				me["HDG_error"].hide();
				me["VSI_error"].hide();
			}
			
			if (systems.IRS.Iru.attAvail[Value.Iru.source[n]].getBoolValue()) {
				me["AI_group"].show();
				me["AI_group2"].show();
				me["AI_group3"].show();
				me["AI_group4"].show();
				
				if (systems.IRS.Iru.alignTimer[Value.Iru.source[n]].getValue() >= 31) {
					me["AI_scale"].show();
				} else {
					me["AI_scale"].hide();
				}
				
				Value.Ai.pliAnimate[n] = 1;
			} else {
				me["AI_group"].hide();
				me["AI_group2"].hide();
				me["AI_group3"].hide();
				me["AI_group4"].hide();
				me["AI_scale"].hide();
				
				Value.Ai.pliAnimate[n] = 0;
			}
			
			if (Value.Iru.mainAvail[Value.Iru.source[n]]) {
				me["FD_group"].show();
				me["FD_group2"].show();
				me["HDG_group"].show();
				me["HDG_group2"].show();
				me["VSI_group"].show();
			} else {
				me["FD_group"].hide();
				me["FD_group2"].hide();
				me["HDG_group"].hide();
				me["HDG_group2"].hide();
				me["VSI_group"].hide();
			}
		} else {
			me["AI_error"].show();
			me["AI_group"].hide();
			me["AI_group2"].hide();
			me["AI_group3"].hide();
			me["AI_group4"].hide();
			me["AI_scale"].hide();
			me["FD_group"].hide();
			me["FD_group2"].hide();
			me["HDG_error"].show();
			me["HDG_group"].hide();
			me["HDG_group2"].hide();
			me["VSI_error"].show();
			me["VSI_group"].hide();
			
			Value.Ai.pliAnimate[n] = 0;
		}
		
		# ASI
		if (Value.Asi.ias > 450) {
			Value.Asi.ias = 450;
		}
		
		# Subtract 50, since the scale starts at 50, but don't allow less than 0, or more than 450 situations
		if (Value.Asi.ias < 50) {
			Value.Asi.Tape.ias = 0;
		} else if (Value.Asi.ias > 450) {
			Value.Asi.Tape.ias = 400;
		} else {
			Value.Asi.Tape.ias = Value.Asi.ias - 50;
		}
		
		if (Value.Asi.preSel < 50) {
			Value.Asi.Tape.preSel = 0 - Value.Asi.Tape.ias;
		} else if (Value.Asi.preSel > 450) {
			Value.Asi.Tape.preSel = 400 - Value.Asi.Tape.ias;
		} else {
			Value.Asi.Tape.preSel = Value.Asi.preSel - 50 - Value.Asi.Tape.ias;
		}
		
		if (Value.Asi.fmsEcon < 50) {
			Value.Asi.Tape.fmsEcon = 0 - Value.Asi.Tape.ias;
		} else if (Value.Asi.fmsEcon > 450) {
			Value.Asi.Tape.fmsEcon = 400 - Value.Asi.Tape.ias;
		} else {
			Value.Asi.Tape.fmsEcon = Value.Asi.fmsEcon - 50 - Value.Asi.Tape.ias;
		}
		
		# Sometimes clipped by V speed box code below
		if (Value.Asi.sel < 50) {
			Value.Asi.Tape.sel = 0 - Value.Asi.Tape.ias;
		} else if (Value.Asi.sel > 450) {
			Value.Asi.Tape.sel = 400 - Value.Asi.Tape.ias;
		} else {
			Value.Asi.Tape.sel = Value.Asi.sel - 50 - Value.Asi.Tape.ias;
		}
		
		# Sometimes clipped by V speed box code below
		if (Value.Asi.fms < 50) {
			Value.Asi.Tape.fms = 0 - Value.Asi.Tape.ias;
		} else if (Value.Asi.fms > 450) {
			Value.Asi.Tape.fms = 400 - Value.Asi.Tape.ias;
		} else {
			Value.Asi.Tape.fms = Value.Asi.fms - 50 - Value.Asi.Tape.ias;
		}
		
		# V Speed Bugs/Boxes
		if (fms.Internal.phase <= 1) {
			if (Value.Asi.hideV1 or Value.Asi.hideVr) { # If VR is hidden, hide V1 also
				me["ASI_v1_box"].hide();
				me["ASI_v1_bug"].hide();
				me["ASI_v1_dash"].hide();
				me["ASI_v1_text"].hide();
			} else {
				if (fms.flightData.v1 > 0) {
					Value.Asi.Tape.v1 = fms.flightData.v1 - 50 - Value.Asi.Tape.ias;
					
					if (fms.flightData.v1State == 1) {
						me["ASI_v1_bug_n"].setColor(0.9608, 0, 0.7765);
						me["ASI_v1_bug_p"].setColor(0.9608, 0, 0.7765);
						me["ASI_v1_bug_v"].setColor(0.9608, 0, 0.7765);
						me["ASI_v1_box"].setColor(0.9608, 0, 0.7765);
						me["ASI_v1_text"].setColor(0.9608, 0, 0.7765);
					} else {
						me["ASI_v1_bug_n"].setColor(1, 1, 1);
						me["ASI_v1_bug_p"].setColor(1, 1, 1);
						me["ASI_v1_bug_v"].setColor(1, 1, 1);
						me["ASI_v1_box"].setColor(1, 1, 1);
						me["ASI_v1_text"].setColor(1, 1, 1);
					}
					
					Value.Asi.Tape.v1Final = math.clamp((Value.Asi.Tape.v1 * -4.4866) + 146.259, 0, 1000); # Offset from center: 146.259
					if (Value.Asi.Tape.v1Final > 0.0001) {
						me["ASI_v1_box"].hide();
						me["ASI_v1_text"].hide();
					} else {
						me["ASI_v1_box"].show();
						me["ASI_v1_text"].setText(sprintf("%03d", fms.flightData.v1));
						me["ASI_v1_text"].show();
					}
					
					me["ASI_v1_bug"].setTranslation(0, Value.Asi.Tape.v1Final);
					me["ASI_v1_dash"].hide();
				} else {
					if (Value.Misc.twoEngineOn) {
						me["ASI_v1_bug_n"].setColor(0.9412, 0.7255, 0);
						me["ASI_v1_bug_p"].setColor(0.9412, 0.7255, 0);
						me["ASI_v1_bug_v"].setColor(0.9412, 0.7255, 0);
						me["ASI_v1_box"].setColor(0.9412, 0.7255, 0);
						me["ASI_v1_dash"].setColor(0.9412, 0.7255, 0);
						me["ASI_v1_text"].setColor(0.9412, 0.7255, 0);
					} else {
						me["ASI_v1_bug_n"].setColor(1, 1, 1);
						me["ASI_v1_bug_p"].setColor(1, 1, 1);
						me["ASI_v1_bug_v"].setColor(1, 1, 1);
						me["ASI_v1_box"].setColor(1, 1, 1);
						me["ASI_v1_dash"].setColor(1, 1, 1);
						me["ASI_v1_text"].setColor(1, 1, 1);
					}
				
					me["ASI_v1_bug"].setTranslation(0, 0);
					me["ASI_v1_bug"].show();
					me["ASI_v1_box"].show();
					me["ASI_v1_dash"].show();
					me["ASI_v1_text"].hide();
				}
			}
			
			if (Value.Asi.hideVr) {
				me["ASI_vr_box"].hide();
				me["ASI_vr_bug"].hide();
				me["ASI_vr_dash"].hide();
				me["ASI_vr_text"].hide();
			} else {
				if (fms.flightData.vr > 0) {
					Value.Asi.Tape.vr = fms.flightData.vr - 50 - Value.Asi.Tape.ias;
					
					if (fms.flightData.vrState == 1) {
						me["ASI_vr_bug_n"].setColor(0.9608, 0, 0.7765);
						me["ASI_vr_bug_p"].setColor(0.9608, 0, 0.7765);
						me["ASI_vr_bug_v"].setColor(0.9608, 0, 0.7765);
						me["ASI_vr_box"].setColor(0.9608, 0, 0.7765);
						me["ASI_vr_text"].setColor(0.9608, 0, 0.7765);
					} else {
						me["ASI_vr_bug_n"].setColor(1, 1, 1);
						me["ASI_vr_bug_p"].setColor(1, 1, 1);
						me["ASI_vr_bug_v"].setColor(1, 1, 1);
						me["ASI_vr_box"].setColor(1, 1, 1);
						me["ASI_vr_text"].setColor(1, 1, 1);
					}
					
					Value.Asi.Tape.vrFinal = math.clamp((Value.Asi.Tape.vr * -4.4866) + 190.259, 0, 1000); # Offset from center: 190.259
					if (Value.Asi.Tape.vrFinal > 0.0001) {
						me["ASI_vr_box"].hide();
						me["ASI_vr_text"].hide();
					} else {
						me["ASI_vr_box"].show();
						me["ASI_vr_text"].setText(sprintf("%03d", fms.flightData.vr));
						me["ASI_vr_text"].show();
					}
					
					me["ASI_vr_bug"].setTranslation(0, Value.Asi.Tape.vrFinal);
					me["ASI_vr_bug"].show();
					me["ASI_vr_dash"].hide();
					
					if (Value.Asi.ias >= fms.flightData.vr) {
						Value.Asi.hideV1 = 1;
					}
				} else {
					Value.Asi.hideV1 = 0;
					
					if (Value.Misc.twoEngineOn) {
						me["ASI_vr_bug_n"].setColor(0.9412, 0.7255, 0);
						me["ASI_vr_bug_p"].setColor(0.9412, 0.7255, 0);
						me["ASI_vr_bug_v"].setColor(0.9412, 0.7255, 0);
						me["ASI_vr_box"].setColor(0.9412, 0.7255, 0);
						me["ASI_vr_dash"].setColor(0.9412, 0.7255, 0);
						me["ASI_vr_text"].setColor(0.9412, 0.7255, 0);
					} else {
						me["ASI_vr_bug_n"].setColor(1, 1, 1);
						me["ASI_vr_bug_p"].setColor(1, 1, 1);
						me["ASI_vr_bug_v"].setColor(1, 1, 1);
						me["ASI_vr_box"].setColor(1, 1, 1);
						me["ASI_vr_dash"].setColor(1, 1, 1);
						me["ASI_vr_text"].setColor(1, 1, 1);
					}
					
					me["ASI_vr_bug"].setTranslation(0, 0);
					me["ASI_vr_bug"].show();
					me["ASI_vr_box"].show();
					me["ASI_vr_dash"].show();
					me["ASI_vr_text"].hide();
				}
			}
			
			if (fms.flightData.v2 > 0) {
				Value.Asi.Tape.v2 = fms.flightData.v2 - 50 - Value.Asi.Tape.ias;
				
				if (fms.flightData.v2State == 1) {
					me["ASI_v2_bug_n"].setColor(0.9608, 0, 0.7765);
					me["ASI_v2_bug_p"].setColor(0.9608, 0, 0.7765);
					me["ASI_v2_bug_v"].setColor(0.9608, 0, 0.7765);
					me["ASI_v2_box"].setColor(0.9608, 0, 0.7765);
					me["ASI_v2_text"].setColor(0.9608, 0, 0.7765);
				} else {
					me["ASI_v2_bug_n"].setColor(1, 1, 1);
					me["ASI_v2_bug_p"].setColor(1, 1, 1);
					me["ASI_v2_bug_v"].setColor(1, 1, 1);
					me["ASI_v2_box"].setColor(1, 1, 1);
					me["ASI_v2_text"].setColor(1, 1, 1);
				}
				
				Value.Asi.Tape.v2Final = math.clamp((Value.Asi.Tape.v2 * -4.4866) + 234.259, 0, 1000); # Offset from center: 234.259
				if (Value.Asi.Tape.v2Final > 0.0001) {
					me["ASI_v2_box"].hide();
					me["ASI_v2_text"].hide();
				} else {
					# Keep sel/fms bug by the box maximum
					if (Value.Asi.Tape.sel > 52.21349) {
						Value.Asi.Tape.sel = 52.21349;
					}
					if (Value.Asi.Tape.fms > 52.21349) {
						Value.Asi.Tape.fms = 52.21349;
					}
					
					me["ASI_v2_box"].show();
					me["ASI_v2_text"].setText(sprintf("%03d", fms.flightData.v2));
					me["ASI_v2_text"].show();
				}
				
				me["ASI_v2_bug"].setTranslation(0, Value.Asi.Tape.v2Final);
				me["ASI_v2_bug"].show();
				me["ASI_v2_dash"].hide();
				
				if (Value.Asi.ias >= fms.flightData.v2) {
					Value.Asi.hideVr = 1;
				}
			} else {
				Value.Asi.hideVr = 0;
				
				if (Value.Misc.twoEngineOn) {
					me["ASI_v2_bug_n"].setColor(0.9412, 0.7255, 0);
					me["ASI_v2_bug_p"].setColor(0.9412, 0.7255, 0);
					me["ASI_v2_bug_v"].setColor(0.9412, 0.7255, 0);
					me["ASI_v2_box"].setColor(0.9412, 0.7255, 0);
					me["ASI_v2_dash"].setColor(0.9412, 0.7255, 0);
					me["ASI_v2_text"].setColor(0.9412, 0.7255, 0);
				} else {
					me["ASI_v2_bug_n"].setColor(1, 1, 1);
					me["ASI_v2_bug_p"].setColor(1, 1, 1);
					me["ASI_v2_bug_v"].setColor(1, 1, 1);
					me["ASI_v2_box"].setColor(1, 1, 1);
					me["ASI_v2_dash"].setColor(1, 1, 1);
					me["ASI_v2_text"].setColor(1, 1, 1);
				}
				
				me["ASI_v2_bug"].setTranslation(0, 0);
				me["ASI_v2_bug"].show();
				me["ASI_v2_box"].show();
				me["ASI_v2_dash"].show();
				me["ASI_v2_text"].hide();
			}
		} else {
			Value.Asi.hideV1 = 0;
			Value.Asi.hideVr = 0;
			me["ASI_v1_bug"].hide();
			me["ASI_v1_box"].hide();
			me["ASI_v1_dash"].hide();
			me["ASI_v1_text"].hide();
			me["ASI_v2_bug"].hide();
			me["ASI_v2_box"].hide();
			me["ASI_v2_dash"].hide();
			me["ASI_v2_text"].hide();
			me["ASI_vr_bug"].hide();
			me["ASI_vr_box"].hide();
			me["ASI_vr_dash"].hide();
			me["ASI_vr_text"].hide();
		}
		
		if (Value.Asi.ias < 53 and Value.Misc.wow) {
			Value.Asi.showTaxi = 1;
			
			if (Value.Iru.aligning[0] or Value.Iru.aligning[1] or Value.Iru.aligning[2]) {
				me["ASI_groundspeed"].setColor(0.9412, 0.7255, 0);
				me["ASI_groundspeed"].setText("NO");
				me["ASI_taxi"].setColor(0.9412, 0.7255, 0);
			} else if (!Value.Iru.aligned[Value.Iru.source[n]]) {
				me["ASI_groundspeed"].setColor(1, 1, 1);
				me["ASI_groundspeed"].setText("--");
				me["ASI_taxi"].setColor(1, 1, 1);
			} else {
				me["ASI_groundspeed"].setColor(1, 1, 1);
				me["ASI_groundspeed"].setText(sprintf("%d", math.round(pts.Velocities.groundspeedKt.getValue())));
				me["ASI_taxi"].setColor(1, 1, 1);
			}
			
			me["ASI_bowtie"].hide();
			me["ASI_ias_group"].hide();
			me["ASI_taxi_group"].show();
		} else {
			Value.Asi.showTaxi = 0;
			
			if (Value.Asi.vmoMmo <= 50) {
				Value.Asi.Tape.vmoMmo = 0 - Value.Asi.Tape.ias;
			} else if (Value.Asi.vmoMmo >= 450) {
				Value.Asi.Tape.vmoMmo = 400 - Value.Asi.Tape.ias;
			} else {
				Value.Asi.Tape.vmoMmo = Value.Asi.vmoMmo - 50 - Value.Asi.Tape.ias;
			}
			
			if (Value.Asi.flapGearMax == 0) {
				Value.Asi.Tape.flapGearMax = 0;
				me["ASI_flap_max"].hide();
				me["ASI_vmo_bar"].show();
				me["ASI_vmo_bar2"].hide();
			} else if (Value.Asi.flapGearMax <= 50) {
				Value.Asi.Tape.flapGearMax = 0 - Value.Asi.Tape.ias;
				me["ASI_flap_max"].show();
				me["ASI_vmo_bar"].hide();
				me["ASI_vmo_bar2"].show();
			} else if (Value.Asi.flapGearMax >= 450) {
				Value.Asi.Tape.flapGearMax = 400 - Value.Asi.Tape.ias;
				me["ASI_flap_max"].show();
				me["ASI_vmo_bar"].hide();
				me["ASI_vmo_bar2"].show();
			} else {
				Value.Asi.Tape.flapGearMax = Value.Asi.flapGearMax - 50 - Value.Asi.Tape.ias;
				me["ASI_flap_max"].show();
				me["ASI_vmo_bar"].hide();
				me["ASI_vmo_bar2"].show();
			}
			
			Value.Asi.Tape.vmin = Value.Asi.vss - math.clamp(Value.Asi.vmin, 0, fms.Speeds.vmax.getValue());
			
			if (Value.Asi.vss == 0) {
				me["ASI_vss"].hide();
			} else if (Value.Asi.vss <= 50) {
				Value.Asi.Tape.vss = 0 - Value.Asi.Tape.ias;
				me["ASI_vss"].show();
			} else if (Value.Asi.vss >= 450) {
				Value.Asi.Tape.vss = 400 - Value.Asi.Tape.ias;
				me["ASI_vss"].show();
			} else {
				Value.Asi.Tape.vss = Value.Asi.vss - 50 - Value.Asi.Tape.ias;
				me["ASI_vss"].show();
			}
			
			me["ASI_scale"].setTranslation(0, Value.Asi.Tape.ias * 4.4866);
			me["ASI_vmo"].setTranslation(0, Value.Asi.Tape.vmoMmo * -4.4866);
			me["ASI_flap_max"].setTranslation(0, Value.Asi.Tape.flapGearMax * -4.4866);
			me["ASI_vss"].setTranslation(0, Value.Asi.Tape.vss * -4.4866);
			me["ASI_vmin"].setTranslation(0, Value.Asi.Tape.vmin * 4.4866);
			me["ASI_vmin_bar"].setTranslation(0, Value.Asi.Tape.vmin * 4.4866);
			me["ASI"].setText(sprintf("%3.0f", math.round(Value.Asi.ias)));
			
			if (Value.Asi.mach > 0.465) {
				if (Value.Asi.mach >= 0.999) {
					me["ASI_mach"].setText("999");
				} else {
					me["ASI_mach"].setText(sprintf("%3.0f", Value.Asi.mach * 1000));
				}
				me["ASI_bowtie_mach"].show();
			} else if (Value.Asi.mach >= 0.445) {
				if (Value.Asi.mach >= 0.999) {
					me["ASI_mach"].setText("999");
				} else {
					me["ASI_mach"].setText(sprintf("%3.0f", Value.Asi.mach * 1000));
				}
			} else if (Value.Asi.mach < 0.445) {
				me["ASI_bowtie_mach"].hide();
			}
			
			if (Value.Asi.ias > Value.Asi.vmoMmo or Value.Ai.alpha >= Value.Ai.stallAlphaDeg) {
				me["ASI"].setColor(1, 0, 0);
				me["ASI_bowtie_L"].setColor(1, 0, 0);
				me["ASI_bowtie_R"].setColor(1, 0, 0);
				me["ASI_mach"].setColor(1, 0, 0);
				me["ASI_mach_decimal"].setColor(1, 0, 0);
			} else if (Value.Asi.ias < Value.Asi.vss) {
				me["ASI"].setColor(1, 0, 0);
				me["ASI_bowtie_L"].setColor(1, 0, 0);
				me["ASI_bowtie_R"].setColor(1, 0, 0);
				me["ASI_mach"].setColor(1, 0, 0);
				me["ASI_mach_decimal"].setColor(1, 0, 0);
			} else if (Value.Ai.alpha >= Value.Ai.stallWarnAlphaDeg and Value.Misc.slatsPos >= 0.1) {
				me["ASI"].setColor(0.9412, 0.7255, 0);
				me["ASI_bowtie_L"].setColor(0.9412, 0.7255, 0);
				me["ASI_bowtie_R"].setColor(0.9412, 0.7255, 0);
				me["ASI_mach"].setColor(0.9412, 0.7255, 0);
				me["ASI_mach_decimal"].setColor(0.9412, 0.7255, 0);
			} else if (Value.Asi.ias > Value.Asi.flapGearMax and Value.Asi.flapGearMax > 0) {
				me["ASI"].setColor(0.9412, 0.7255, 0);
				me["ASI_bowtie_L"].setColor(0.9412, 0.7255, 0);
				me["ASI_bowtie_R"].setColor(0.9412, 0.7255, 0);
				me["ASI_mach"].setColor(0.9412, 0.7255, 0);
				me["ASI_mach_decimal"].setColor(0.9412, 0.7255, 0);
			} else if (Value.Asi.ias < Value.Asi.vmin) {
				me["ASI"].setColor(0.9412, 0.7255, 0);
				me["ASI_bowtie_L"].setColor(0.9412, 0.7255, 0);
				me["ASI_bowtie_R"].setColor(0.9412, 0.7255, 0);
				me["ASI_mach"].setColor(0.9412, 0.7255, 0);
				me["ASI_mach_decimal"].setColor(0.9412, 0.7255, 0);
			} else {
				me["ASI"].setColor(1, 1, 1);
				me["ASI_bowtie_L"].setColor(1, 1, 1);
				me["ASI_bowtie_R"].setColor(1, 1, 1);
				me["ASI_mach"].setColor(1, 1, 1);
				me["ASI_mach_decimal"].setColor(1, 1, 1);
			}
			
			# Reference Speed Bugs
			if (Value.Misc.gearOut) {
				Value.Asi.Tape.gr = fms.Speeds.gearRetMax.getValue() - 50 - Value.Asi.Tape.ias;
				if (Value.Asi.Tape.gr > 0) {
					me["ASI_gr_p"].setColor(0, 1, 0);
					me["ASI_gr_t"].setColor(0, 1, 0);
				} else {
					me["ASI_gr_p"].setColor(0.9412, 0.7255, 0);
					me["ASI_gr_t"].setColor(0.9412, 0.7255, 0);
				}
				me["ASI_gr"].setTranslation(0, Value.Asi.Tape.gr * -4.4866);
				me["ASI_gr"].show();
			} else {
				me["ASI_gr"].hide();
			}
			
			Value.Asi.Tape.ge = fms.Speeds.gearExtMax.getValue() - 50 - Value.Asi.Tape.ias;
			if (Value.Asi.Tape.ge > 0) {
				me["ASI_ge_p"].setColor(0, 1, 0);
				me["ASI_ge_t"].setColor(0, 1, 0);
			} else {
				me["ASI_ge_p"].setColor(0.9412, 0.7255, 0);
				me["ASI_ge_t"].setColor(0.9412, 0.7255, 0);
			}
			me["ASI_ge"].setTranslation(0, Value.Asi.Tape.ge * -4.4866);
			
			if (Value.Misc.slatsOut and Value.Asi.vsr > 0) {
				Value.Asi.Tape.sr = Value.Asi.vsr - 50 - Value.Asi.Tape.ias;
				if (Value.Asi.Tape.sr < 0) {
					me["ASI_sr_p"].setColor(0, 1, 0);
					me["ASI_sr_t"].setColor(0, 1, 0);
				} else {
					me["ASI_sr_p"].setColor(0.9412, 0.7255, 0);
					me["ASI_sr_t"].setColor(0.9412, 0.7255, 0);
				}
				me["ASI_sr"].setTranslation(0, Value.Asi.Tape.sr * -4.4866);
				me["ASI_sr"].show();
			} else {
				me["ASI_sr"].hide();
			}
			
			if (!Value.Misc.slatsOut) {
				Value.Asi.Tape.se = fms.Speeds.slatMax.getValue() - 50 - Value.Asi.Tape.ias;
				if (Value.Asi.Tape.se > 0) {
					me["ASI_se_p"].setColor(0, 1, 0);
					me["ASI_se_t"].setColor(0, 1, 0);
				} else {
					me["ASI_se_p"].setColor(0.9412, 0.7255, 0);
					me["ASI_se_t"].setColor(0.9412, 0.7255, 0);
				}
				me["ASI_se"].setTranslation(0, Value.Asi.Tape.se * -4.4866);
				me["ASI_se"].show();
			} else {
				me["ASI_se"].hide();
			}
			
			if (Value.Misc.flapsOut and Value.Asi.vfr > 0) {
				Value.Asi.Tape.fr = Value.Asi.vfr - 50 - Value.Asi.Tape.ias;
				if (Value.Asi.Tape.fr < 0) {
					me["ASI_fr_p"].setColor(0, 1, 0);
					me["ASI_fr_t"].setColor(0, 1, 0);
				} else {
					me["ASI_fr_p"].setColor(0.9412, 0.7255, 0);
					me["ASI_fr_t"].setColor(0.9412, 0.7255, 0);
				}
				me["ASI_fr"].setTranslation(0, Value.Asi.Tape.fr * -4.4866);
				me["ASI_fr"].show();
			} else {
				me["ASI_fr"].hide();
			}
			
			Value.Asi.f15 = fms.Speeds.flap15Max.getValue();
			Value.Asi.f28 = fms.Speeds.flap28Max.getValue();
			Value.Asi.f35 = fms.Speeds.flap35Max.getValue();
			Value.Asi.f50 = fms.Speeds.flap50Max.getValue();
			
			if (Value.Misc.flapsCmd >= 49.9 or Value.Misc.flapsPos >= 49.9) {
				me["ASI_f15"].hide();
				me["ASI_f28"].hide();
				me["ASI_f35"].hide();
				me["ASI_f50"].hide();
			} else if ((Value.Misc.flapsCmd >= 34.9 or Value.Misc.flapsPos >= 34.9 or (Value.Asi.ias < Value.Asi.f50 and Value.Misc.slatsOut)) and Value.Afs.vertText != "T/O CLB") {
				me["ASI_f15"].hide();
				me["ASI_f28"].hide();
				me["ASI_f35"].hide();
				
				Value.Asi.Tape.f50 = Value.Asi.f50 - 50 - Value.Asi.Tape.ias;
				if (Value.Asi.Tape.f50 > 0) {
					me["ASI_f50_p"].setColor(0, 1, 0);
					me["ASI_f50_t"].setColor(0, 1, 0);
				} else {
					me["ASI_f50_p"].setColor(0.9412, 0.7255, 0);
					me["ASI_f50_t"].setColor(0.9412, 0.7255, 0);
				}
				me["ASI_f50"].setTranslation(0, Value.Asi.Tape.f50 * -4.4866);
				me["ASI_f50"].show();
			} else if ((Value.Misc.flapsCmd >= 27.9 or Value.Misc.flapsPos >= 27.9 or (Value.Asi.ias < Value.Asi.f35 and Value.Misc.slatsOut)) and Value.Afs.vertText != "T/O CLB") {
				me["ASI_f15"].hide();
				me["ASI_f28"].hide();
				
				Value.Asi.Tape.f35 = Value.Asi.f35 - 50 - Value.Asi.Tape.ias;
				if (Value.Asi.Tape.f35 > 0) {
					me["ASI_f35_p"].setColor(0, 1, 0);
					me["ASI_f35_t"].setColor(0, 1, 0);
				} else {
					me["ASI_f35_p"].setColor(0.9412, 0.7255, 0);
					me["ASI_f35_t"].setColor(0.9412, 0.7255, 0);
				}
				me["ASI_f35"].setTranslation(0, Value.Asi.Tape.f35 * -4.4866);
				me["ASI_f35"].show();
				
				me["ASI_f50"].hide();
			} else if ((Value.Misc.flapsCmd >= 14.9 or Value.Misc.flapsPos >= 14.9 or (Value.Asi.ias < Value.Asi.f28 and Value.Misc.slatsOut)) and Value.Afs.vertText != "T/O CLB") {
				me["ASI_f15"].hide();
				
				Value.Asi.Tape.f28 = Value.Asi.f28 - 50 - Value.Asi.Tape.ias;
				if (Value.Asi.Tape.f28 > 0) {
					me["ASI_f28_p"].setColor(0, 1, 0);
					me["ASI_f28_t"].setColor(0, 1, 0);
				} else {
					me["ASI_f28_p"].setColor(0.9412, 0.7255, 0);
					me["ASI_f28_t"].setColor(0.9412, 0.7255, 0);
				}
				me["ASI_f28"].setTranslation(0, Value.Asi.Tape.f28 * -4.4866);
				me["ASI_f28"].show();
				
				me["ASI_f35"].hide();
				me["ASI_f50"].hide();
			} else if (Value.Misc.slatsOut and Value.Afs.vertText != "T/O CLB") {
				Value.Asi.Tape.f15 = Value.Asi.f15 - 50 - Value.Asi.Tape.ias;
				if (Value.Asi.Tape.f15 > 0) {
					me["ASI_f15_p"].setColor(0, 1, 0);
					me["ASI_f15_t"].setColor(0, 1, 0);
				} else {
					me["ASI_f15_p"].setColor(0.9412, 0.7255, 0);
					me["ASI_f15_t"].setColor(0.9412, 0.7255, 0);
				}
				me["ASI_f15"].setTranslation(0, Value.Asi.Tape.f15 * -4.4866);
				me["ASI_f15"].show();
				
				me["ASI_f28"].hide();
				me["ASI_f35"].hide();
				me["ASI_f50"].hide();
			} else {
				me["ASI_f15"].hide();
				me["ASI_f28"].hide();
				me["ASI_f35"].hide();
				me["ASI_f50"].hide();
			}
			
			# Let the whole ASI tape update before showing
			me["ASI_bowtie"].show();
			me["ASI_ias_group"].show();
			me["ASI_taxi_group"].hide();
		}
		
		if (Value.Asi.trend >= 2) {
			me["ASI_trend_dn"].hide();
			me["ASI_trend_up"].setTranslation(0, math.clamp(Value.Asi.trend, 0, 60) * -4.4866);
			me["ASI_trend_up"].show();
		} else if (Value.Asi.trend <= -2) {
			me["ASI_trend_dn"].setTranslation(0, math.clamp(Value.Asi.trend, -60, 0) * -4.4866);
			me["ASI_trend_dn"].show();
			me["ASI_trend_up"].hide();
		} else {
			me["ASI_trend_dn"].hide();
			me["ASI_trend_up"].hide();
		}
		
		# ASI Pre-Sel/Sel
		Value.Asi.showPreSel = afs.Output.showSpd.getBoolValue();
		
		if (Value.Asi.fms > 0 and fms.FmsSpd.pfdDriving) {
			Value.Afs.fmsSpdDriving = 1;
		} else {
			Value.Afs.fmsSpdDriving = 0;
		}
		
		if (Value.Asi.fmsEcon > 0 and fms.FmsSpd.pfdShowEconPreSel) {
			Value.Asi.showFmsEcon = 1;
		} else {
			Value.Asi.showFmsEcon = 0;
		}
		
		if (Value.Asi.Tape.preSel < -60 or Value.Asi.Tape.preSel > 60 or Value.Asi.showTaxi or afs.Internal.syncedSpd or !Value.Asi.showPreSel) {
			me["ASI_mach_presel"].hide();
			me["ASI_mach_presel_text"].hide();
			me["ASI_presel"].hide();
		} else {
			if (Value.Asi.preSel > Value.Asi.vmoMmo and Value.Asi.flapGearMax > 0) {
				me["ASI_mach_presel"].setColor(1, 0, 0);
				me["ASI_mach_presel_text"].setColor(1, 0, 0);
				me["ASI_presel"].setColor(1, 0, 0);
			} else if (Value.Asi.preSel > Value.Asi.vmoMmo - 5) { # No flapGearMax bar
				me["ASI_mach_presel"].setColor(1, 0, 0);
				me["ASI_mach_presel_text"].setColor(1, 0, 0);
				me["ASI_presel"].setColor(1, 0, 0);
			} else if (Value.Asi.preSel < Value.Asi.vss) {
				me["ASI_mach_presel"].setColor(1, 0, 0);
				me["ASI_mach_presel_text"].setColor(1, 0, 0);
				me["ASI_presel"].setColor(1, 0, 0);
			} else if (Value.Asi.preSel > Value.Asi.flapGearMax - 5 and Value.Asi.flapGearMax > 0) {
				me["ASI_mach_presel"].setColor(0.9412, 0.7255, 0);
				me["ASI_mach_presel_text"].setColor(0.9412, 0.7255, 0);
				me["ASI_presel"].setColor(0.9412, 0.7255, 0);
			} else if (Value.Asi.preSel < Value.Asi.vmin + 5) {
				me["ASI_mach_presel"].setColor(0.9412, 0.7255, 0);
				me["ASI_mach_presel_text"].setColor(0.9412, 0.7255, 0);
				me["ASI_presel"].setColor(0.9412, 0.7255, 0);
			} else {
				me["ASI_mach_presel"].setColor(1, 1, 1);
				me["ASI_mach_presel_text"].setColor(1, 1, 1);
				me["ASI_presel"].setColor(1, 1, 1);
			}
			
			if (Value.Afs.ktsMachPreSel) {
				me["ASI_mach_presel"].setTranslation(0, Value.Asi.Tape.preSel * -4.4866);
				me["ASI_mach_presel_text"].setTranslation(0, Value.Asi.Tape.preSel * -4.4866);
				me["ASI_mach_presel_text"].setText("." ~ sprintf("%3.0f", Value.Afs.machPreSel * 1000));
				
				me["ASI_mach_presel"].show();
				me["ASI_mach_presel_text"].show();
				me["ASI_presel"].hide();
			} else {
				me["ASI_presel"].setTranslation(0, Value.Asi.Tape.preSel * -4.4866);
				
				me["ASI_mach_presel"].hide();
				me["ASI_mach_presel_text"].hide();
				me["ASI_presel"].show();
			}
		}
		if (Value.Asi.Tape.sel < -60 or Value.Asi.Tape.sel > 60 or !Value.Afs.spdPitchAvail or Value.Afs.fmsSpdDriving) {
			me["ASI_mach_sel"].hide();
			me["ASI_mach_sel_text"].hide();
			me["ASI_sel"].hide();
		} else {
			if (Value.Afs.ktsMach) {
				me["ASI_mach_sel"].setTranslation(0, Value.Asi.Tape.sel * -4.4866);
				me["ASI_mach_sel_text"].setTranslation(0, Value.Asi.Tape.sel * -4.4866);
				me["ASI_mach_sel_text"].setText("." ~ sprintf("%3.0f", Value.Afs.mach * 1000));
				
				me["ASI_mach_sel_text"].show();
				me["ASI_mach_sel"].show();
				me["ASI_sel"].hide();
			} else {
				me["ASI_sel"].setTranslation(0, Value.Asi.Tape.sel * -4.4866);
				
				me["ASI_mach_sel"].hide();
				me["ASI_mach_sel_text"].hide();
				me["ASI_sel"].show();
			}
		}
		if (Value.Asi.Tape.fms < -60 or Value.Asi.Tape.fms > 60 or !Value.Afs.spdPitchAvail or Value.Asi.fms == 0) {
			me["ASI_fms"].hide();
			me["ASI_fms_mach_text"].hide();
		} else {
			if (Value.Afs.ktsMachFms) {
				me["ASI_fms_mach_text"].setTranslation(0, Value.Asi.Tape.fms * -4.4866);
				me["ASI_fms_mach_text"].setText("." ~ sprintf("%3.0f", fms.FmsSpd.mach * 1000));
				me["ASI_fms_mach_text"].show();
			} else {
				me["ASI_fms_mach_text"].hide();
			}
			
			if (Value.Afs.fmsSpdDriving) {
				me["ASI_fms"].setColorFill(0.9608, 0, 0.7765, 1);
			} else {
				me["ASI_fms"].setColorFill(0, 0, 0, 0.004); # Alpha = 0 doesn't work
			}
			
			me["ASI_fms"].setTranslation(0, Value.Asi.Tape.fms * -4.4866);
			me["ASI_fms"].show();
		}
		if (Value.Asi.Tape.fmsEcon < -60 or Value.Asi.Tape.fmsEcon > 60 or !Value.Afs.spdPitchAvail or Value.Asi.fmsEcon == 0 or !Value.Asi.showFmsEcon) {
			me["ASI_fms_econ"].hide();
			me["ASI_fms_econ_mach_text"].hide();
		} else {
			if (Value.Afs.ktsMachFmsEcon) {
				me["ASI_fms_econ_mach_text"].setTranslation(0, Value.Asi.Tape.fmsEcon * -4.4866);
				me["ASI_fms_econ_mach_text"].setText("." ~ sprintf("%3.0f", fms.FmsSpd.econMachCalc * 1000));
				me["ASI_fms_econ_mach_text"].show();
			} else {
				me["ASI_fms_econ_mach_text"].hide();
			}
			
			me["ASI_fms_econ"].setTranslation(0, Value.Asi.Tape.fmsEcon * -4.4866);
			me["ASI_fms_econ"].show();
		}
		
		if ((Value.Asi.Tape.preSel > 60 or Value.Asi.showTaxi) and !afs.Internal.syncedSpd and Value.Asi.showPreSel) {
			me["ASI_fms_up"].hide();
			
			if (Value.Asi.preSel > Value.Asi.vmoMmo and Value.Asi.flapGearMax > 0) {
				me["ASI_mach_sel_up"].setColor(1, 0, 0);
				me["ASI_sel_up"].setColor(1, 0, 0);
				me["ASI_sel_up_text"].setColor(1, 0, 0);
			} else if (Value.Asi.preSel > Value.Asi.vmoMmo - 5) { # No flapGearMax bar
				me["ASI_mach_sel_up"].setColor(1, 0, 0);
				me["ASI_sel_up"].setColor(1, 0, 0);
				me["ASI_sel_up_text"].setColor(1, 0, 0);
			} else if (Value.Asi.preSel < Value.Asi.vss) {
				me["ASI_mach_sel_up"].setColor(1, 0, 0);
				me["ASI_sel_up"].setColor(1, 0, 0);
				me["ASI_sel_up_text"].setColor(1, 0, 0);
			} else if (Value.Asi.preSel > Value.Asi.flapGearMax - 5 and Value.Asi.flapGearMax > 0) {
				me["ASI_mach_sel_up"].setColor(0.9412, 0.7255, 0);
				me["ASI_sel_up"].setColor(0.9412, 0.7255, 0);
				me["ASI_sel_up_text"].setColor(0.9412, 0.7255, 0);
			} else if (Value.Asi.preSel < Value.Asi.vmin + 5) {
				me["ASI_mach_sel_up"].setColor(0.9412, 0.7255, 0);
				me["ASI_sel_up"].setColor(0.9412, 0.7255, 0);
				me["ASI_sel_up_text"].setColor(0.9412, 0.7255, 0);
			} else {
				me["ASI_mach_sel_up"].setColor(1, 1, 1);
				me["ASI_sel_up"].setColor(1, 1, 1);
				me["ASI_sel_up_text"].setColor(1, 1, 1);
			}
			
			if (Value.Afs.ktsMachPreSel) {
				me["ASI_mach_sel_up"].setColorFill(0, 0, 0);
				me["ASI_sel_up_text"].setText("." ~ sprintf("%3.0f", Value.Afs.machPreSel * 1000));
				
				me["ASI_mach_sel_up"].show();
				me["ASI_sel_up"].hide();
			} else {
				me["ASI_sel_up"].setColorFill(0, 0, 0);
				me["ASI_sel_up_text"].setText(sprintf("%3.0f", Value.Afs.ktsPreSel));
				
				me["ASI_mach_sel_up"].hide();
				me["ASI_sel_up"].show();
			}
			
			me["ASI_sel_up_text"].show();
		} else if (Value.Asi.Tape.sel > 60 and Value.Afs.spdPitchAvail and !Value.Afs.fmsSpdDriving) { # It will never go outside envelope
			me["ASI_fms_up"].hide();
			me["ASI_mach_sel_up"].setColor(1, 1, 1);
			me["ASI_sel_up"].setColor(1, 1, 1);
			me["ASI_sel_up_text"].setColor(1, 1, 1);
			
			if (Value.Afs.ktsMach) {
				me["ASI_mach_sel_up"].setColorFill(1, 1, 1);
				me["ASI_sel_up_text"].setText("." ~ sprintf("%3.0f", Value.Afs.mach * 1000));
				
				me["ASI_mach_sel_up"].show();
				me["ASI_sel_up"].hide();
			} else {
				me["ASI_sel_up"].setColorFill(1, 1, 1);
				me["ASI_sel_up_text"].setText(sprintf("%3.0f", Value.Afs.kts));
				
				me["ASI_mach_sel_up"].hide();
				me["ASI_sel_up"].show();
			}
			
			me["ASI_sel_up_text"].show();
		} else if (Value.Asi.Tape.fms > 60 and Value.Afs.spdPitchAvail and Value.Asi.fms != 0) { # It will never go outside envelope
			if (Value.Afs.fmsSpdDriving) {
				me["ASI_fms_up"].setColorFill(0.9608, 0, 0.7765);
			} else {
				me["ASI_fms_up"].setColorFill(0, 0, 0);
			}
			
			me["ASI_fms_up"].show();
			me["ASI_mach_sel_up"].hide();
			me["ASI_sel_up"].hide();
			me["ASI_sel_up_text"].setColor(0.9608, 0, 0.7765);
			
			if (fms.FmsSpd.ktsMach) {
				me["ASI_sel_up_text"].setText("." ~ sprintf("%3.0f", fms.FmsSpd.mach * 1000));
			} else {
				me["ASI_sel_up_text"].setText(sprintf("%3.0f", fms.FmsSpd.kts));
			}
			
			me["ASI_sel_up_text"].show();
		} else if (Value.Asi.Tape.fmsEcon > 60 and Value.Afs.spdPitchAvail and Value.Asi.fmsEcon != 0 and Value.Asi.showFmsEcon) { # It will never go outside envelope
			me["ASI_fms_up"].setColorFill(0, 0, 0);
			me["ASI_fms_up"].show();
			me["ASI_mach_sel_up"].hide();
			me["ASI_sel_up"].hide();
			me["ASI_sel_up_text"].setColor(0.9608, 0, 0.7765);
			
			if (fms.FmsSpd.ktsMach) {
				me["ASI_sel_up_text"].setText("." ~ sprintf("%3.0f", fms.FmsSpd.econMachCalc * 1000));
			} else {
				me["ASI_sel_up_text"].setText(sprintf("%3.0f", fms.FmsSpd.econKtsCalc));
			}
			
			me["ASI_sel_up_text"].show();
		} else {
			me["ASI_fms_up"].hide();
			me["ASI_mach_sel_up"].hide();
			me["ASI_sel_up"].hide();
			me["ASI_sel_up_text"].hide();
		}
		
		if (Value.Asi.Tape.preSel < -60 and !Value.Asi.showTaxi and !afs.Internal.syncedSpd and Value.Asi.showPreSel) {
			me["ASI_fms_dn"].hide();
			
			if (Value.Asi.preSel > Value.Asi.vmoMmo and Value.Asi.flapGearMax > 0) {
				me["ASI_mach_sel_dn"].setColor(1, 0, 0);
				me["ASI_sel_dn"].setColor(1, 0, 0);
				me["ASI_sel_dn_text"].setColor(1, 0, 0);
			} else if (Value.Asi.preSel > Value.Asi.vmoMmo - 5) { # No flapGearMax bar
				me["ASI_mach_sel_dn"].setColor(1, 0, 0);
				me["ASI_sel_dn"].setColor(1, 0, 0);
				me["ASI_sel_dn_text"].setColor(1, 0, 0);
			} else if (Value.Asi.preSel < Value.Asi.vss) {
				me["ASI_mach_sel_dn"].setColor(1, 0, 0);
				me["ASI_sel_dn"].setColor(1, 0, 0);
				me["ASI_sel_dn_text"].setColor(1, 0, 0);
			} else if (Value.Asi.preSel > Value.Asi.flapGearMax - 5 and Value.Asi.flapGearMax > 0) {
				me["ASI_mach_sel_dn"].setColor(0.9412, 0.7255, 0);
				me["ASI_sel_dn"].setColor(0.9412, 0.7255, 0);
				me["ASI_sel_dn_text"].setColor(0.9412, 0.7255, 0);
			} else if (Value.Asi.preSel < Value.Asi.vmin + 5) {
				me["ASI_mach_sel_dn"].setColor(0.9412, 0.7255, 0);
				me["ASI_sel_dn"].setColor(0.9412, 0.7255, 0);
				me["ASI_sel_dn_text"].setColor(0.9412, 0.7255, 0);
			} else {
				me["ASI_mach_sel_dn"].setColor(1, 1, 1);
				me["ASI_sel_dn"].setColor(1, 1, 1);
				me["ASI_sel_dn_text"].setColor(1, 1, 1);
			}
			
			if (Value.Afs.ktsMachPreSel) {
				me["ASI_mach_sel_dn"].setColorFill(0, 0, 0);
				me["ASI_sel_dn_text"].setText("." ~ sprintf("%3.0f", Value.Afs.machPreSel * 1000));
				
				me["ASI_mach_sel_dn"].show();
				me["ASI_sel_dn"].hide();
			} else {
				me["ASI_sel_dn"].setColorFill(0, 0, 0);
				me["ASI_sel_dn_text"].setText(sprintf("%3.0f", Value.Afs.ktsPreSel));
				
				me["ASI_mach_sel_dn"].hide();
				me["ASI_sel_dn"].show();
			}
			
			me["ASI_sel_dn_text"].show();
		} else if (Value.Asi.Tape.sel < -60 and Value.Afs.spdPitchAvail and !Value.Asi.showTaxi and !Value.Afs.fmsSpdDriving) { # It will never go outside envelope
			me["ASI_fms_dn"].hide();
			me["ASI_mach_sel_dn"].setColor(1, 1, 1);
			me["ASI_sel_dn"].setColor(1, 1, 1);
			me["ASI_sel_dn_text"].setColor(1, 1, 1);
			
			if (Value.Afs.ktsMach) {
				me["ASI_mach_sel_dn"].setColorFill(1, 1, 1);
				me["ASI_sel_dn_text"].setText("." ~ sprintf("%3.0f", Value.Afs.mach * 1000));
				
				me["ASI_mach_sel_dn"].show();
				me["ASI_sel_dn"].hide();
			} else {
				me["ASI_sel_dn"].setColorFill(1, 1, 1);
				me["ASI_sel_dn_text"].setText(sprintf("%3.0f", Value.Afs.kts));
				
				me["ASI_mach_sel_dn"].hide();
				me["ASI_sel_dn"].show();
			}
			
			me["ASI_sel_dn_text"].show();
		} else if (Value.Asi.Tape.fms < -60 and Value.Afs.spdPitchAvail and !Value.Asi.showTaxi and Value.Asi.fms != 0) { # It will never go outside envelope
			if (Value.Afs.fmsSpdDriving) {
				me["ASI_fms_dn"].setColorFill(0.9608, 0, 0.7765);
			} else {
				me["ASI_fms_dn"].setColorFill(0, 0, 0);
			}
			
			me["ASI_fms_dn"].show();
			me["ASI_mach_sel_dn"].hide();
			me["ASI_sel_dn"].hide();
			me["ASI_sel_dn_text"].setColor(0.9608, 0, 0.7765);
			
			if (fms.FmsSpd.ktsMach) {
				me["ASI_sel_dn_text"].setText("." ~ sprintf("%3.0f", fms.FmsSpd.mach * 1000));
			} else {
				me["ASI_sel_dn_text"].setText(sprintf("%3.0f", fms.FmsSpd.kts));
			}
			
			me["ASI_sel_dn_text"].show();
		} else if (Value.Asi.Tape.fmsEcon < -60 and Value.Afs.spdPitchAvail and !Value.Asi.showTaxi and Value.Asi.fms != 0 and Value.Asi.showFmsEcon) { # It will never go outside envelope
			me["ASI_fms_dn"].setColorFill(0, 0, 0);
			me["ASI_fms_dn"].show();
			me["ASI_mach_sel_dn"].hide();
			me["ASI_sel_dn"].hide();
			me["ASI_sel_dn_text"].setColor(0.9608, 0, 0.7765);
			
			if (fms.FmsSpd.ktsMach) {
				me["ASI_sel_dn_text"].setText("." ~ sprintf("%3.0f", fms.FmsSpd.econMachCalc * 1000));
			} else {
				me["ASI_sel_dn_text"].setText(sprintf("%3.0f", fms.FmsSpd.econKtsCalc));
			}
			
			me["ASI_sel_dn_text"].show();
		} else {
			me["ASI_fms_dn"].hide();
			me["ASI_mach_sel_dn"].hide();
			me["ASI_sel_dn"].hide();
			me["ASI_sel_dn_text"].hide();
		}
		
		# AI
		if (systems.DUController.singleCueFd) {
			me["AI_dual_cue"].hide();
			me["AI_PLI_dual_cue"].hide();
			me["AI_PLI_single_cue"].show();
			me["AI_single_cue"].show();
		} else {
			me["AI_dual_cue"].show();
			me["AI_PLI_dual_cue"].show();
			me["AI_PLI_single_cue"].hide();
			me["AI_single_cue"].hide();
		}
		
		Value.Ai.bankLimit = afs.Internal.bankLimit.getValue() - 25; # Because SVG has it set to 25
		Value.Ai.pitch = pts.Orientation.pitchDeg.getValue();
		Value.Ai.roll = pts.Orientation.rollDeg.getValue();
		Value.Hdg.track = pts.Instrumentation.Pfd.trackBug[0].getValue();
		
		me.aiBackgroundTrans.setTranslation(0, math.clamp(Value.Ai.pitch * 10.2462, -202, 202));
		me.aiBackgroundRot.setRotation(-Value.Ai.roll * D2R, Value.Ai.center);
		
		me.aiScaleTrans.setTranslation(0, Value.Ai.pitch * 10.2462);
		me.aiScaleRot.setRotation(-Value.Ai.roll * D2R, Value.Ai.center);
		me["AI_bank_mask"].setRotation(-Value.Ai.roll * D2R, Value.Ai.center);
		
		Value.Ai.slipSkid = pts.Instrumentation.Pfd.slipSkid.getValue() * 7;
		if (abs(Value.Ai.slipSkid) >= 26.888) {
			me["AI_slipskid_t"].setColorFill(0.9412, 0.7255, 0);
		} else {
			me["AI_slipskid_t"].setColorFill(1, 1, 1);
		}
		me["AI_slipskid"].setTranslation(Value.Ai.slipSkid, 0);
		me["AI_bank"].setRotation(-Value.Ai.roll * D2R);
		
		me["AI_banklimit_L"].setRotation(Value.Ai.bankLimit * -D2R);
		me["AI_banklimit_R"].setRotation(Value.Ai.bankLimit * D2R);
		
		if (abs(Value.Ai.roll) >= 30.5) {
			me["AI_overbank_index"].show();
		} else {
			me["AI_overbank_index"].hide();
		}
		
		if (Value.Afs.fd[n] and !Value.Afs.bit[n]) {
			if (systems.DUController.singleCueFd) {
				me["FD_pitch"].hide();
				me["FD_roll"].hide();
				
				if (Value.Afs.spdPitchAvail) {
					me.fdVTrans.setTranslation(0, afs.Fd.pitchBar.getValue() * -10.2462);
					me.fdVRot.setRotation(afs.Fd.rollBar.getValue() * D2R, me["AI_center"].getCenter());
					me["FD_v"].show();
				} else {
					me["FD_v"].hide();
				}
			} else {
				if (Value.Afs.spdPitchAvail) {
					me["FD_pitch"].setTranslation(0, afs.Fd.pitchBar.getValue() * -10.2462);
					me["FD_pitch"].show();
				} else {
					me["FD_pitch"].hide();
				}
				
				me["FD_roll"].setTranslation(afs.Fd.rollBar.getValue() * 2.2, 0);
				me["FD_roll"].show();
				me["FD_v"].hide();
			}
		} else {
			me["FD_pitch"].hide();
			me["FD_roll"].hide();
			me["FD_v"].hide();
		}
		
		if (Value.Afs.vert == 5) {
			me.fpdTrans.setTranslation(0, (Value.Ai.pitch - afs.Input.fpa.getValue()) * 10.2462);
			me.fpdRot.setRotation(-Value.Ai.roll * D2R, Value.Ai.center);
			me["FPD"].show();
		} else {
			me["FPD"].hide();
		}
		
		if (afs.Input.vsFpa.getBoolValue()) {
			me.fpvTrans.setTranslation(math.clamp(Value.Hdg.track, -20, 20) * 10.2462, math.clamp(Value.Ai.alpha, -20, 20) * 10.2462);
			me.fpvRot.setRotation(-Value.Ai.roll * D2R, Value.Ai.center);
			me["FPV"].setRotation(Value.Ai.roll * D2R); # It shouldn't be rotated, only the axis should be
			me["FPV"].show();
		} else {
			me["FPV"].hide();
		}
		
		if (Value.Ai.pliAnimate[n]) {
			me["AI_PLI"].setTranslation(0, math.clamp(Value.Ai.stallAlphaDeg - Value.Ai.alpha, -20, 20) * -10.2462);
		} else {
			me["AI_PLI"].setTranslation(0, -95);
		}
		
		if (Value.Ai.alpha >= Value.Ai.stallAlphaDeg) {
			me["AI_banklimit_L"].setColor(1, 0, 0);
			me["AI_banklimit_R"].setColor(1, 0, 0);
			me["AI_PLI_dual_cue"].setColor(1, 0, 0);
			me["AI_PLI_single_cue"].setColor(1, 0, 0);
		} else if (Value.Ai.alpha >= Value.Ai.stallWarnAlphaDeg and Value.Misc.slatsPos >= 0.1) {
			me["AI_banklimit_L"].setColor(1, 1, 1);
			me["AI_banklimit_R"].setColor(1, 1, 1);
			me["AI_PLI_dual_cue"].setColor(0.9412, 0.7255, 0);
			me["AI_PLI_single_cue"].setColor(0.9412, 0.7255, 0);
		} else {
			me["AI_banklimit_L"].setColor(1, 1, 1);
			me["AI_banklimit_R"].setColor(1, 1, 1);
			me["AI_PLI_dual_cue"].setColor(0.3412, 0.7882, 0.9922);
			me["AI_PLI_single_cue"].setColor(0.3412, 0.7882, 0.9922);
		}
		
		# ALT
		Value.Alt.indicated = pts.Instrumentation.Altimeter.indicatedAltitudeFt.getValue();
		Value.Alt.Tape.offset = Value.Alt.indicated / 500 - int(Value.Alt.indicated / 500);
		Value.Alt.Tape.middleText = roundAboutAlt(Value.Alt.indicated / 100) * 100;
		Value.Alt.Tape.middleOffset = nil;
		Value.Vs.indicated = afs.Internal.vs.getValue();
		
		if (Value.Alt.Tape.offset > 0.5) {
			Value.Alt.Tape.middleOffset = -(Value.Alt.Tape.offset - 1) * 254.51;
		} else {
			Value.Alt.Tape.middleOffset = -Value.Alt.Tape.offset * 254.51;
		}
		me["ALT_scale"].setTranslation(0, -Value.Alt.Tape.middleOffset);
		me["ALT_scale"].update();
		
		Value.Alt.Tape.fiveI = (Value.Alt.Tape.middleText + 1000) * 0.001;
		Value.Alt.Tape.five = int(Value.Alt.Tape.fiveI);
		Value.Alt.Tape.fiveT = sprintf("%01d", abs(Value.Alt.Tape.five));
		
		if (Value.Alt.Tape.fiveI == 0) {
			me["ALT_five"].setText("00"); # Only God knows why...
		} else {
			me["ALT_five"].setText(sprintf("%03d", abs(1000 * (Value.Alt.Tape.fiveI - Value.Alt.Tape.five))));
		}
		if (Value.Alt.Tape.fiveT == 0) {
			me["ALT_five_T"].setText("");
		} else {
			me["ALT_five_T"].setText(Value.Alt.Tape.fiveT);
		}
		
		Value.Alt.Tape.fourI = (Value.Alt.Tape.middleText + 500) * 0.001;
		Value.Alt.Tape.four = int(Value.Alt.Tape.fourI);
		Value.Alt.Tape.fourT = sprintf("%01d", abs(Value.Alt.Tape.four));
		
		if (Value.Alt.Tape.fourI == 0) {
			me["ALT_four"].setText("00"); # Only God knows why...
		} else {
			me["ALT_four"].setText(sprintf("%03d", abs(1000 * (Value.Alt.Tape.fourI - Value.Alt.Tape.four))));
		}
		if (Value.Alt.Tape.fourT == 0) {
			me["ALT_four_T"].setText("");
		} else {
			me["ALT_four_T"].setText(Value.Alt.Tape.fourT);
		}
		
		Value.Alt.Tape.threeI = Value.Alt.Tape.middleText * 0.001;
		Value.Alt.Tape.three = int(Value.Alt.Tape.threeI);
		Value.Alt.Tape.threeT = sprintf("%01d", abs(Value.Alt.Tape.three));
		
		if (Value.Alt.Tape.threeI == 0) {
			me["ALT_three"].setText("00"); # Only God knows why...
		} else {
			me["ALT_three"].setText(sprintf("%03d", abs(1000 * (Value.Alt.Tape.threeI - Value.Alt.Tape.three))));
		}
		if (Value.Alt.Tape.threeT == 0) {
			me["ALT_three_T"].setText("");
		} else {
			me["ALT_three_T"].setText(Value.Alt.Tape.threeT);
		}
		
		Value.Alt.Tape.twoI = (Value.Alt.Tape.middleText - 500) * 0.001;
		Value.Alt.Tape.two = int(Value.Alt.Tape.twoI);
		Value.Alt.Tape.twoT = sprintf("%01d", abs(Value.Alt.Tape.two));
		
		if (Value.Alt.Tape.twoI == 0) {
			me["ALT_two"].setText("00"); # Only God knows why...
		} else {
			me["ALT_two"].setText(sprintf("%03d", abs(1000 * (Value.Alt.Tape.twoI - Value.Alt.Tape.two))));
		}
		if (Value.Alt.Tape.twoT == 0) {
			me["ALT_two_T"].setText("");
		} else {
			me["ALT_two_T"].setText(Value.Alt.Tape.twoT);
		}
		
		Value.Alt.Tape.oneI = (Value.Alt.Tape.middleText - 1000) * 0.001;
		Value.Alt.Tape.one = int(Value.Alt.Tape.oneI);
		Value.Alt.Tape.oneT = sprintf("%01d", abs(Value.Alt.Tape.one));
		
		if (Value.Alt.Tape.oneI == 0) {
			me["ALT_one"].setText("00"); # Only God knows why...
		} else {
			me["ALT_one"].setText(sprintf("%03d", abs(1000 * (Value.Alt.Tape.oneI - Value.Alt.Tape.one))));
		}
		if (Value.Alt.Tape.oneT == 0) {
			me["ALT_one_T"].setText("");
		} else {
			me["ALT_one_T"].setText(Value.Alt.Tape.oneT);
		}
		
		if (Value.Alt.indicated < 0) {
			if (Value.Alt.indicated < -9980) {
				me["ALT_minus"].setTranslation(-22.172, 0);
			} else {
				me["ALT_minus"].setTranslation(0, 0);
			}
			me["ALT_minus"].show();
		} else {
			me["ALT_minus"].hide();
		}
		
		Value.Alt.indicatedAbs = abs(Value.Alt.indicated);
		
		if (Value.Alt.indicatedAbs < 9900) { # Prepare to show the zero at 10000
			me["ALT_thousands_zero"].hide();
		} else {
			me["ALT_thousands_zero"].show();
		}
		
		if (Value.Alt.indicatedAbs < 900) { # Prepare to show the zero at 1000
			me["ALT_hundreds_zero"].hide();
		} else {
			me["ALT_hundreds_zero"].show();
		}
		
		Value.Alt.Tape.tenThousands = num(right(sprintf("%05d", Value.Alt.indicatedAbs), 5)) / 100; # Unlikely it would be above 99999 but lets account for it anyways
		Value.Alt.Tape.tenThousandsGeneva = genevaAltTenThousands(Value.Alt.Tape.tenThousands);
		me["ALT_tenthousands"].setTranslation(0, Value.Alt.Tape.tenThousandsGeneva * 41);
		
		Value.Alt.Tape.thousands = num(right(sprintf("%04d", Value.Alt.indicatedAbs), 4)) / 100;
		Value.Alt.Tape.thousandsGeneva = genevaAltThousands(Value.Alt.Tape.thousands);
		me["ALT_thousands"].setTranslation(0, Value.Alt.Tape.thousandsGeneva * 41);
		
		Value.Alt.Tape.hundreds = num(right(sprintf("%03d", Value.Alt.indicatedAbs), 3)) / 100;
		Value.Alt.Tape.hundredsGeneva = genevaAltHundreds(Value.Alt.Tape.hundreds);
		me["ALT_hundreds"].setTranslation(0, Value.Alt.Tape.hundredsGeneva * 41);
		
		if (abs(Value.Vs.indicated) >= 2975) {
			me["ALT_tens"].hide();
			me["ALT_tens_dash"].show();
		} else {
			Value.Alt.Tape.tens = num(right(sprintf("%02d", Value.Alt.indicatedAbs), 2));
			me["ALT_tens"].setTranslation(0, Value.Alt.Tape.tens * 2.05);
			me["ALT_tens"].show();
			me["ALT_tens_dash"].hide();
		}
		
		Value.Alt.alert = systems.WARNINGS.altitudeAlert.getValue();
		Value.Misc.innerMarker = pts.Instrumentation.MarkerBeacon.inner.getBoolValue();
		Value.Misc.middleMarker = pts.Instrumentation.MarkerBeacon.middle.getBoolValue();
		Value.Misc.outerMarker = pts.Instrumentation.MarkerBeacon.outer.getBoolValue();
		if (Value.Alt.alert == 1 or (Value.Alt.alert == 2 and Value.Misc.blinkMed)) {
			me["ALT_bowtie"].setColor(0.9412, 0.7255, 0);
		} else if (Value.Misc.innerMarker) {
			me["ALT_bowtie"].setColor(0, 0, 0);
		} else if (Value.Misc.middleMarker) {
			me["ALT_bowtie"].setColor(0.9412, 0.7255, 0);
		} else if (Value.Misc.outerMarker) {
			me["ALT_bowtie"].setColor(0.3412, 0.7882, 0.9922);
		} else {
			me["ALT_bowtie"].setColor(1, 1, 1);
		}
		
		# ALT Pre-Sel/Sel
		Value.Afs.alt = afs.Internal.alt.getValue();
		Value.Afs.altSel = afs.Input.alt.getValue();
		
		Value.Alt.preSel = Value.Afs.altSel - Value.Alt.indicated;
		Value.Alt.sel = Value.Afs.alt - Value.Alt.indicated;
		
		if (Value.Alt.preSel < -525 or Value.Alt.preSel > 525 or afs.Internal.syncedAlt) {
			me["ALT_presel"].hide();
		} else  {
			me["ALT_presel"].setTranslation(0, (Value.Alt.preSel / 100) * -50.9016);
			me["ALT_presel"].show();
		}
		if (Value.Alt.sel < -525 or Value.Alt.sel > 525) {
			me["ALT_sel"].hide();
		} else  {
			me["ALT_sel"].setTranslation(0, (Value.Alt.sel / 100) * -50.9016);
			me["ALT_sel"].show();
		}
		
		if (Value.Alt.preSel > 525 and !afs.Internal.syncedAlt) {
			me["ALT_sel_up"].setColorFill(0, 0, 0);
			me["ALT_sel_up"].show();
			if (Value.Afs.altSel == 0) {
				me["ALT_sel_up_text"].setText("0");
			} else {
				me["ALT_sel_up_text"].setText(right(sprintf("%03d", Value.Afs.altSel), 3));
			}
			me["ALT_sel_up_text"].show();
			if (Value.Afs.altSel < 1000) {
				me["ALT_sel_up_text_T"].hide();
			} else {
				me["ALT_sel_up_text_T"].setText(sprintf("%2.0f", math.floor(Value.Afs.altSel / 1000)));
				me["ALT_sel_up_text_T"].show();
			}
		} else if (Value.Alt.sel > 525) {
			me["ALT_sel_up"].setColorFill(1, 1, 1);
			me["ALT_sel_up"].show();
			if (Value.Afs.alt == 0) {
				me["ALT_sel_up_text"].setText("0");
			} else {
				me["ALT_sel_up_text"].setText(right(sprintf("%03d", Value.Afs.alt), 3));
			}
			me["ALT_sel_up_text"].show();
			if (Value.Afs.alt < 1000) {
				me["ALT_sel_up_text_T"].hide();
			} else {
				me["ALT_sel_up_text_T"].setText(sprintf("%2.0f", math.floor(Value.Afs.alt / 1000)));
				me["ALT_sel_up_text_T"].show();
			}
		} else {
			me["ALT_sel_up"].hide();
			me["ALT_sel_up_text"].hide();
			me["ALT_sel_up_text_T"].hide();
		}
		
		if (Value.Alt.preSel < -525 and !afs.Internal.syncedAlt) {
			me["ALT_sel_dn"].setColorFill(0, 0, 0);
			me["ALT_sel_dn"].show();
			if (Value.Afs.altSel == 0) {
				me["ALT_sel_dn_text"].setText("0");
			} else {
				me["ALT_sel_dn_text"].setText(right(sprintf("%03d", Value.Afs.altSel), 3));
			}
			me["ALT_sel_dn_text"].show();
			if (Value.Afs.altSel < 1000) {
				me["ALT_sel_dn_text_T"].hide();
			} else {
				me["ALT_sel_dn_text_T"].setText(sprintf("%2.0f", math.floor(Value.Afs.altSel / 1000)));
				me["ALT_sel_dn_text_T"].show();
			}
		} else if (Value.Alt.sel < -525) {
			me["ALT_sel_dn"].setColorFill(1, 1, 1);
			me["ALT_sel_dn"].show();
			if (Value.Afs.alt == 0) {
				me["ALT_sel_dn_text"].setText("0");
			} else {
				me["ALT_sel_dn_text"].setText(right(sprintf("%03d", Value.Afs.alt), 3));
			}
			me["ALT_sel_dn_text"].show();
			if (Value.Afs.alt < 1000) {
				me["ALT_sel_dn_text_T"].hide();
			} else {
				me["ALT_sel_dn_text_T"].setText(sprintf("%2.0f", math.floor(Value.Afs.alt / 1000)));
				me["ALT_sel_dn_text_T"].show();
			}
		} else {
			me["ALT_sel_dn"].hide();
			me["ALT_sel_dn_text"].hide();
			me["ALT_sel_dn_text_T"].hide();
		}
		
		Value.Ra.agl = pts.Position.gearAglFt.getValue();
		me["ALT_agl"].setTranslation(0, (math.clamp(Value.Ra.agl, -700, 700) / 100) * 50.9016);
		
		Value.Misc.minimums = pts.Systems.Misc.minimums.getValue();
		Value.Misc.minimumsMode = pts.Systems.Misc.minimumsMode.getBoolValue();
		Value.Misc.minimumsRefAlt = pts.Systems.Misc.minimumsRefAlt.getValue();
		
		me["ALT_minimums"].setRotation(Value.Misc.minimumsMode * 180 * D2R);
		me["ALT_minimums"].setTranslation(Value.Misc.minimumsMode * 16.451, (math.clamp(Value.Misc.minimumsRefAlt - Value.Misc.minimums, -700, 700) / 100) * 50.9016);
		
		if (Value.Misc.minimumsRefAlt <= Value.Misc.minimums) {
			me["ALT_minimums"].setColorFill(0.9412, 0.7255, 0);
		} else {
			me["ALT_minimums"].setColorFill(1, 1, 1);
		}
		
		if (pts.Instrumentation.Altimeter.qfe.getBoolValue()) {
			me["QFE_disab"].show();
		} else {
			me["QFE_disab"].hide();
		}
		
		# VS
		Value.Vs.digit = pts.Instrumentation.Pfd.vsDigit.getValue();
		
		if (Value.Vs.indicated > 95) {
			me["VSI_needle_dn"].hide();
			me["VSI_needle_up"].setTranslation(0, pts.Instrumentation.Pfd.vsNeedleUp.getValue());
			me["VSI_needle_up"].show();
			if (Value.Vs.digit > 0) {
				me["VSI_up"].setText(sprintf("%1.1f", Value.Vs.digit));
				me["VSI_up"].show();
			} else {
				me["VSI_up"].hide();
			}
		} else if (Value.Vs.indicated < -95) {
			me["VSI_needle_dn"].setTranslation(0, pts.Instrumentation.Pfd.vsNeedleDn.getValue());
			me["VSI_needle_dn"].show();
			me["VSI_needle_up"].hide();
			if (Value.Vs.digit > 0) {
				me["VSI_dn"].setText(sprintf("%1.1f", Value.Vs.digit));
				me["VSI_dn"].show();
			} else {
				me["VSI_dn"].hide();
			}
		} else if (abs(Value.Vs.indicated) < 50) {
			me["VSI_dn"].hide();
			me["VSI_needle_dn"].show();
			me["VSI_needle_dn"].setTranslation(0, 0);
			me["VSI_up"].hide();
			me["VSI_needle_up"].show();
			me["VSI_needle_up"].setTranslation(0, 0);
		}
		
		Value.Afs.vs = afs.Input.vs.getValue();
		if (Value.Afs.vert == 1) {
			if (Value.Afs.vs >= 50) {
				me["VSI_bug_dn"].hide();
				me["VSI_bug_up"].setTranslation(0, pts.Instrumentation.Pfd.vsBugUp.getValue());
				me["VSI_bug_up"].show();
			} else if (Value.Afs.vs <= -50) {
				me["VSI_bug_dn"].setTranslation(0, pts.Instrumentation.Pfd.vsBugDn.getValue());
				me["VSI_bug_dn"].show();
				me["VSI_bug_up"].hide();
			} else {
				me["VSI_bug_up"].hide();
				me["VSI_bug_dn"].hide();
			}
		} else {
			me["VSI_bug_up"].hide();
			me["VSI_bug_dn"].hide();
		}
		
		# ILS LOC
		Value.Misc.risingRunwayTBar = pts.Systems.Acconfig.Options.risingRunwayTBar.getBoolValue();
		Value.Nav.headingNeedleDeflectionNorm = pts.Instrumentation.Nav.headingNeedleDeflectionNorm[2].getValue();
		Value.Nav.navLoc = pts.Instrumentation.Nav.navLoc[2].getBoolValue();
		Value.Nav.selectedMhz = pts.Instrumentation.Nav.Frequencies.selectedMhz[2].getValue();
		Value.Nav.signalQuality = pts.Instrumentation.Nav.signalQualityNorm[2].getValue();
		
		if (Value.Misc.annunTestWow) {
			me["LOC_no"].setColor(0.9412, 0.7255, 0);
			me["LOC_no"].show();
		} else {
			if (Value.Nav.selectedMhz != 0 and (!Value.Nav.navLoc or Value.Nav.signalQuality < 0.99)) {
				me["LOC_no"].setColor(0.3412, 0.7882, 0.9922);
				me["LOC_no"].show();
			} else {
				me["LOC_no"].hide();
			}
		}
		
		if (Value.Nav.selectedMhz != 0) {
			if (Value.Nav.navLoc and Value.Nav.signalQuality >= 0.99) {
				if (Value.Ra.agl <= 300 and !Value.Misc.wow and (Value.Afs.roll == "LOC" or Value.Afs.roll == "ALIGN") and abs(Value.Nav.headingNeedleDeflectionNorm) > 0.105) { # 1/4 Dot
					me["LOC_pointer"].setColor(0.9412, 0.7255, 0);
					
					if (Value.Misc.blinkMed) {
						if (Value.Misc.risingRunwayTBar) {
							if (systems.DUController.singleCueFd) {
								me["AI_rising_runway"].setTranslation(Value.Nav.headingNeedleDeflectionNorm * 200, (math.clamp(Value.Ra.agl, 0, 200) * 0.677455) + 11.893);
							} else {
								me["AI_rising_runway"].setTranslation(Value.Nav.headingNeedleDeflectionNorm * 200, math.clamp(Value.Ra.agl, 0, 200) * 0.73767);
							}
							
							if (Value.Ra.agl <= 2500) {
								me["AI_rising_runway"].show();
								me["AI_rising_runway_E"].show();
							} else {
								me["AI_rising_runway"].hide();
								me["AI_rising_runway_E"].hide();
							}
						} else {
							me["AI_rising_runway"].hide();
							me["AI_rising_runway_E"].hide();
						}
						
						me["LOC_pointer"].setTranslation(Value.Nav.headingNeedleDeflectionNorm * 200, 0);
						me["LOC_pointer"].show();
					} else {
						me["AI_rising_runway"].hide();
						me["LOC_pointer"].hide();
					}
				} else {
					if (Value.Misc.risingRunwayTBar) {
						if (systems.DUController.singleCueFd) {
							me["AI_rising_runway"].setTranslation(Value.Nav.headingNeedleDeflectionNorm * 200, (math.clamp(Value.Ra.agl, 0, 200) * 0.677455) + 11.893);
						} else {
							me["AI_rising_runway"].setTranslation(Value.Nav.headingNeedleDeflectionNorm * 200, math.clamp(Value.Ra.agl, 0, 200) * 0.73767);
						}
						
						if (Value.Ra.agl <= 2500) {
							me["AI_rising_runway"].show();
							me["AI_rising_runway_E"].show();
						} else {
							me["AI_rising_runway"].hide();
							me["AI_rising_runway_E"].hide();
						}
					} else {
						me["AI_rising_runway"].hide();
						me["AI_rising_runway_E"].hide();
					}
					
					me["LOC_pointer"].setColor(0.9608, 0, 0.7765);
					me["LOC_pointer"].setTranslation(Value.Nav.headingNeedleDeflectionNorm * 200, 0);
					me["LOC_pointer"].show();
				}
			} else {
				me["AI_rising_runway"].hide();
				me["AI_rising_runway_E"].hide();
				me["LOC_pointer"].hide();
			}
			
			me["LOC_scale"].show();
		} else {
			me["AI_rising_runway"].hide();
			me["AI_rising_runway_E"].hide();
			me["LOC_pointer"].hide();
			me["LOC_scale"].hide();
		}
		
		# RA Rising Runway
		if (Value.Misc.risingRunwayTBar) { # When T-bar equipped, RA doesn't move
			me["RA_group"].setTranslation(0, 0);
		} else {
			me["RA_group"].setTranslation(0, (430 - math.clamp(Value.Ra.agl, 0, 430)) * -0.48135);
		}
		
		# ILS G/S
		Value.Nav.gsNeedleDeflectionNorm = pts.Instrumentation.Nav.gsNeedleDeflectionNorm[2].getValue();
		Value.Nav.gsInRange = pts.Instrumentation.Nav.gsInRange[2].getBoolValue();
		Value.Nav.hasGs = pts.Instrumentation.Nav.hasGs[2].getBoolValue();
		
		if (Value.Misc.annunTestWow) {
			me["GS_no"].setColor(0.9412, 0.7255, 0);
			me["GS_no"].show();
		} else {
			if (Value.Nav.selectedMhz != 0 and (!Value.Nav.gsInRange or !Value.Nav.hasGs or Value.Nav.signalQuality < 0.99)) {
				me["GS_no"].setColor(0.3412, 0.7882, 0.9922);
				me["GS_no"].show();
			} else {
				me["GS_no"].hide();
			}
		}
		
		if (Value.Nav.selectedMhz != 0) {
			if (Value.Nav.gsInRange and Value.Nav.hasGs and Value.Nav.signalQuality >= 0.99) {
				if (Value.Ra.agl >= 100 and Value.Ra.agl <= 500 and Value.Afs.pitch == "G/S" and abs(Value.Nav.gsNeedleDeflectionNorm) > 0.41) { # One Dot
					me["GS_pointer"].setColor(0.9412, 0.7255, 0);
					
					if (Value.Misc.blinkMed) {
						me["GS_pointer"].setTranslation(0, Value.Nav.gsNeedleDeflectionNorm * -204);
						me["GS_pointer"].show();
					} else {
						me["GS_pointer"].hide();
					}
				} else {
					me["GS_pointer"].setColor(0.9608, 0, 0.7765);
					me["GS_pointer"].setTranslation(0, Value.Nav.gsNeedleDeflectionNorm * -204);
					me["GS_pointer"].show();
				}
			} else {
				me["GS_pointer"].hide();
			}
			me["GS_scale"].show();
		} else {
			me["GS_pointer"].hide();
			me["GS_scale"].hide();
		}
		
		# ILS DME
		if (Value.Nav.selectedMhz != 0) {
			if (Value.Nav.signalQuality >= 0.99) {
				if (pts.Instrumentation.Dme.inRange[2].getBoolValue()) {
					me["ILS_DME"].setText(sprintf("%3.1f", math.round(pts.Instrumentation.Dme.indicatedDistanceNm[2].getValue(), 0.1)));
					me["ILS_DME"].show();
				} else {
					me["ILS_DME"].hide();
				}
				me["ILS_info"].setText(pts.Instrumentation.Nav.navId[2].getValue());
				me["ILS_info"].show();
			} else {
				me["ILS_DME"].hide();
				me["ILS_info"].setText(sprintf("%6.2f", pts.Instrumentation.Nav.Frequencies.selectedMhz[2].getValue()));
				me["ILS_info"].show();
			}
		} else {
			me["ILS_DME"].hide();
			me["ILS_info"].hide();
		}
		
		# Marker Beacons
		if (Value.Misc.innerMarker) {
			me["Inner_marker"].show();
			me["Middle_marker"].hide();
			me["Outer_marker"].hide();
		} else if (Value.Misc.middleMarker) {
			me["Inner_marker"].hide();
			me["Middle_marker"].show();
			me["Outer_marker"].hide();
		} else if (Value.Misc.outerMarker) {
			me["Inner_marker"].hide();
			me["Middle_marker"].hide();
			me["Outer_marker"].show();
		} else {
			me["Inner_marker"].hide();
			me["Middle_marker"].hide();
			me["Outer_marker"].hide();
		}
		
		# RA and Minimums
		if (Value.Misc.minimumsMode) {
			me["Minimums"].setTranslation(-78.333, 0);
			me["MinimumsMode"].setTranslation(88.538, 0);
			me["MinimumsMode"].setText("BARO");
		} else {
			me["Minimums"].setTranslation(0, 0);
			me["MinimumsMode"].setTranslation(0, 0);
			me["MinimumsMode"].setText("RA");
		}
		
		me["Minimums"].setText(sprintf("%4.0f", Value.Misc.minimums));
		
		if (Value.Ra.agl <= 2500) {
			if (Value.Misc.minimumsRefAlt <= Value.Misc.minimums) {
				me["Minimums"].setColor(0.9412, 0.7255, 0);
				me["RA"].setColor(0.9412, 0.7255, 0);
				me["RA_box"].setColor(0.9412, 0.7255, 0);
				
				if (!Value.Ra.below) {
					Value.Ra.below = 1;
					if (!Value.Misc.wow) { # Start blinking
						Value.Ra.time = Value.Misc.elapsedSec;
					} else { # Don't starting blinking
						Value.Ra.time = -10;
					}
				}
			} else {
				me["Minimums"].setColor(1, 1, 1);
				me["RA"].setColor(1, 1, 1);
				me["RA_box"].setColor(1, 1, 1);
				Value.Ra.below = 0;
				Value.Ra.time = -10;
			}
			
			if (Value.Ra.time + 5 >= Value.Misc.elapsedSec) {
				if (Value.Misc.blinkFast) {
					me["Minimums"].show();
				} else {
					me["Minimums"].hide();
				}
			} else if (Value.Misc.blinkFast) { # So that it doesn't interrupt its blink
				me["Minimums"].show();
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
		if (pts.Instrumentation.Efis.Mfd.trueNorth[n].getBoolValue()) {
			me["HDG_magtru"].setColor(0.3412, 0.7882, 0.9922);
			me["HDG_magtru"].setText("TRU");
		} else {
			me["HDG_magtru"].setColor(1, 1, 1);
			me["HDG_magtru"].setText("MAG");
		}
		
		Value.Hdg.indicated = pts.Instrumentation.Pfd.hdgDeg[n].getValue();
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
			if (afs.Internal.syncedHdg) {
				me["HDG_presel"].hide();
			} else {
				me["HDG_presel"].setRotation(Value.Hdg.Tape.preSel * D2R);
				me["HDG_presel"].show();
			}
			
			if (Value.Hdg.preSel < -35 and !afs.Internal.syncedHdg) {
				me["HDG_sel_left_text"].setText(right(sprintf("%03d", Value.Afs.hdgPreSel), 3));
				me["HDG_sel_left_text"].show();
			} else if (Value.Hdg.sel < -35 and Value.Afs.lat == 0) {
				me["HDG_sel_left_text"].setText(right(sprintf("%03d", Value.Afs.hdg), 3));
				me["HDG_sel_left_text"].show();
			} else {
				me["HDG_sel_left_text"].hide();
			}
			
			if (Value.Hdg.preSel > 35 and !afs.Internal.syncedHdg) {
				me["HDG_sel_right_text"].setText(right(sprintf("%03d", Value.Afs.hdgPreSel), 3));
				me["HDG_sel_right_text"].show();
			} else if (Value.Hdg.sel > 35 and Value.Afs.lat == 0) {
				me["HDG_sel_right_text"].setText(right(sprintf("%03d", Value.Afs.hdg), 3));
				me["HDG_sel_right_text"].show();
			} else {
				me["HDG_sel_right_text"].hide();
			}
			
			if (!afs.Internal.syncedHdg) {
				if (Value.Hdg.preSel < -35 and Value.Hdg.sel < -35) {
					Value.Hdg.hideHdgSel = 1;
				} else if (Value.Hdg.preSel > 35 and Value.Hdg.sel > 35) {
					Value.Hdg.hideHdgSel = 1;
				} else {
					Value.Hdg.hideHdgSel = 0;
				}
			} else {
				Value.Hdg.hideHdgSel = 0;
			}
			
			if (Value.Afs.lat == 0 and !Value.Hdg.hideHdgSel) {
				me["HDG_sel"].setRotation(Value.Hdg.Tape.sel * D2R);
				me["HDG_sel"].show();
			} else {
				me["HDG_sel"].hide();
			}
		} else {
			me["HDG_presel"].hide();
			me["HDG_sel"].hide();
			me["HDG_sel_left_text"].hide();
			me["HDG_sel_right_text"].hide();
		}
		
		if (!Value.Misc.wow) {
			me["TRK_pointer"].setRotation(Value.Hdg.track * D2R);
			me["TRK_pointer"].show();
		} else {
			me["TRK_pointer"].hide();
		}
		
		# FMA
		if (Value.Afs.fd[n]) {
			if (Value.Afs.land == "OFF" and !(afs.Fma.Blink.active[2] and afs.Fma.Blink.hide[2]) and !Value.Afs.bit[n]) {
				me["FMA_pitch"].setText(sprintf("%s", Value.Afs.pitch));
				me["FMA_pitch"].show();
			} else {
				me["FMA_pitch"].hide();
			}
			
			if (afs.Fma.Blink.active[1] and afs.Fma.Blink.hide[1]) {
				me["FMA_roll"].hide();
			} else {
				if (Value.Afs.roll == "HEADING" or Value.Afs.roll == "TRACK") {
					me["FMA_roll"].setText(sprintf("%s", Value.Afs.roll ~ " " ~ sprintf("%03d", Value.Afs.hdg)));
				} else {
					me["FMA_roll"].setText(sprintf("%s", Value.Afs.roll));
				}
				me["FMA_roll"].show();
			}
			
			if ((afs.Fma.Blink.active[0] and afs.Fma.Blink.hide[0]) or  Value.Afs.bit[n]) {
				me["FMA_thrust"].hide();
			} else {
				me["FMA_thrust"].setText(sprintf("%s", Value.Afs.thrust));
				me["FMA_thrust"].show();
			}
		} else {
			if (Value.Afs.thrust == "PITCH") {
				if ((Value.Afs.ap1 or Value.Afs.ap2) and !(afs.Fma.Blink.active[0] and afs.Fma.Blink.hide[0])) {
					me["FMA_thrust"].setText(sprintf("%s", Value.Afs.thrust));
					me["FMA_thrust"].show();
				} else {
					me["FMA_thrust"].hide();
				}
				
				if (Value.Afs.ats and Value.Afs.land == "OFF" and !(afs.Fma.Blink.active[2] and afs.Fma.Blink.hide[2])) {
					me["FMA_pitch"].setText(sprintf("%s", Value.Afs.pitch));
					me["FMA_pitch"].show();
				} else {
					me["FMA_pitch"].hide();
				}
			} else {
				if ((Value.Afs.ap1 or Value.Afs.ap2) and Value.Afs.land == "OFF" and !(afs.Fma.Blink.active[2] and afs.Fma.Blink.hide[2])) {
					me["FMA_pitch"].setText(sprintf("%s", Value.Afs.pitch));
					me["FMA_pitch"].show();
				} else {
					me["FMA_pitch"].hide();
				}
				
				if (Value.Afs.ats and !(afs.Fma.Blink.active[0] and afs.Fma.Blink.hide[0])) {
					me["FMA_thrust"].setText(sprintf("%s", Value.Afs.thrust));
					me["FMA_thrust"].show();
				} else {
					me["FMA_thrust"].hide();
				}
			}
			
			if (Value.Afs.ap1 or Value.Afs.ap2) {
				if (Value.Afs.roll == "HEADING" or Value.Afs.roll == "TRACK") {
					me["FMA_roll"].setText(sprintf("%s", Value.Afs.roll ~ " " ~ sprintf("%03d", Value.Afs.hdg)));
				} else {
					me["FMA_roll"].setText(sprintf("%s", Value.Afs.roll));
				}
				
				if (afs.Fma.Blink.active[1] and afs.Fma.Blink.hide[1]) {
					me["FMA_roll"].hide();
				} else {
					me["FMA_roll"].show();
				}
			} else {
				me["FMA_roll"].hide();
			}
		}
		
		if (fms.FmsSpd.active and Value.Afs.thrust != "RETARD") { # Only if the actual FMS SPD mode is active and not in RETARD, this excludes takeoff speed guidance
			me["FMA_thrust"].setColor(0.9608, 0, 0.7765);
		} else {
			me["FMA_thrust"].setColor(1, 1, 1);
		}
		
		Value.Afs.spdProt = afs.Output.spdProt.getValue();
		if (Value.Afs.ats and Value.Afs.spdProt != 0) {
			if (Value.Misc.blinkMed) {
				if (Value.Afs.spdProt == 2) {
					me["FMA_thrust_arm"].setText("HI SPEED");
				} else {
					me["FMA_thrust_arm"].setText("LO SPEED");
				}
			} else {
				me["FMA_thrust_arm"].setText("PROTECTION");
			}
		} else {
			me["FMA_thrust_arm"].setText("");
		}
		
		me["FMA_pitch_arm"].setText(sprintf("%s", Value.Afs.pitchArm));
		me["FMA_roll_arm"].setText(sprintf("%s", Value.Afs.rollArm));
		
		if (Value.Afs.land == "DUAL") {
			me["FMA_roll"].setColor(0, 1, 0);
		} else if (Value.Afs.roll == "NAV1" or Value.Afs.roll == "NAV2") {
			me["FMA_roll"].setColor(0.9608, 0, 0.7765);
		} else {
			me["FMA_roll"].setColor(1, 1, 1);
		}
		
		if (Value.Afs.rollArm == "NAV ARMED") {
			me["FMA_roll_arm"].setColor(0.9608, 0, 0.7765);
		} else {
			me["FMA_roll_arm"].setColor(1, 1, 1);
		}
		
		if (Value.Afs.land != "OFF" and (Value.Afs.ap1 or Value.Afs.ap2 or Value.Afs.fd[n])) {
			if (Value.Afs.land == "DUAL") {
				me["FMA_land"].setColor(0, 1, 0);
				me["FMA_land"].setText("DUAL LAND");
				me["FMA_pitch_land"].setColor(0, 1, 0);
			} else if (Value.Afs.land == "SINGLE") {
				me["FMA_land"].setColor(1, 1, 1);
				me["FMA_land"].setText("SINGLE LAND");
				me["FMA_pitch_land"].setColor(1, 1, 1);
			} else {
				me["FMA_land"].setColor(1, 1, 1);
				me["FMA_land"].setText("APPR ONLY");
				me["FMA_pitch_land"].setColor(1, 1, 1);
			}
			
			me["FMA_altitude"].hide();
			me["FMA_altitude_T"].hide();
			me["FMA_pitch_land"].setText(sprintf("%s", Value.Afs.pitch));
			
			if (afs.Fma.Blink.active[2] and afs.Fma.Blink.hide[2]) {
				me["FMA_land"].hide();
				me["FMA_pitch_land"].hide();
			} else {
				me["FMA_land"].show();
				me["FMA_pitch_land"].show();
			}
		} else {
			if (Value.Afs.pitch != "G/S" and Value.Afs.pitch != "FLARE" and Value.Afs.pitch != "ROLLOUT") { # FLARE and ROLLOUT should never happen with LAND OFF, but just in case
				if (Value.Afs.alt == 0) {
					me["FMA_altitude"].setText("0");
				} else {
					me["FMA_altitude"].setText(right(sprintf("%03d", Value.Afs.alt), 3));
				}
				me["FMA_altitude"].show();
				if (Value.Afs.alt < 1000) {
					me["FMA_altitude_T"].hide();
				} else {
					me["FMA_altitude_T"].setText(sprintf("%2.0f", math.floor(Value.Afs.alt / 1000)));
					me["FMA_altitude_T"].show();
				}
			} else {
				me["FMA_altitude"].hide();
				me["FMA_altitude_T"].hide();
			}
			
			me["FMA_land"].hide();
			me["FMA_pitch_land"].hide();
		}
		
		if (Value.Afs.pitch == "ROLLOUT") {
			me["FMA_pitch_land"].setTranslation(-10, 0);
		} else {
			me["FMA_pitch_land"].setTranslation(0, 0);
		}
		
		if (fms.FmsSpd.active) {
			me["FMA_speed"].setColor(0.9608, 0, 0.7765);
		} else if (Value.Afs.ktsMach == fms.FmsSpd.ktsMach) {
			if (fms.FmsSpd.ktsMach) {
				if (abs(Value.Afs.mach - fms.FmsSpd.mach) <= 0.00105 or Value.Afs.fmsSpdDriving) { # 0.00105 to fix floating point error issue
					me["FMA_speed"].setColor(0.9608, 0, 0.7765);
				} else {
					me["FMA_speed"].setColor(1, 1, 1);
				}
			} else {
				if (abs(Value.Afs.kts - fms.FmsSpd.kts) <= 1 or Value.Afs.fmsSpdDriving) {
					me["FMA_speed"].setColor(0.9608, 0, 0.7765);
				} else {
					me["FMA_speed"].setColor(1, 1, 1);
				}
			}
		} else {
			me["FMA_speed"].setColor(1, 1, 1);
		}
		
		if (Value.Afs.thrust == "RETARD" or !Value.Afs.spdPitchAvail or Value.Afs.bit[n]) {
			me["FMA_speed"].hide();
		} else {
			if (Value.Afs.ktsMach) {
				me["FMA_speed"].setText("." ~ sprintf("%3.0f", Value.Afs.mach * 1000));
			} else {
				me["FMA_speed"].setText(sprintf("%3.0f", Value.Afs.kts));
			}
			me["FMA_speed"].show();
		}
		
		Value.Afs.apDisc[0] = pts.Controls.Cockpit.apDisc[0].getBoolValue();
		Value.Afs.apDisc[1] = pts.Controls.Cockpit.apDisc[1].getBoolValue();
		Value.Afs.ap1Avail = afs.Input.ap1AvailPfd.getBoolValue();
		Value.Afs.ap2Avail = afs.Input.ap2AvailPfd.getBoolValue();
		Value.Afs.apSound = afs.Sound.apOff.getBoolValue();
		Value.Afs.apWarn = afs.Warning.ap.getBoolValue();
		Value.Afs.atsFlash = afs.Warning.atsFlash.getBoolValue();
		Value.Afs.atsWarn = afs.Warning.ats.getBoolValue();
		
		if (Value.Afs.atsFlash) {
			me["FMA_ATS_pitch_off_box"].setColor(1, 0, 0);
			me["FMA_ATS_pitch_off_text"].setColor(1, 0, 0);
			me["FMA_ATS_thrust_off_box"].setColor(1, 0, 0);
			me["FMA_ATS_thrust_off_text"].setColor(1, 0, 0);
		} else if (!afs.Input.athrAvail.getBoolValue()) {
			me["FMA_ATS_pitch_off_box"].setColor(0.9412, 0.7255, 0);
			me["FMA_ATS_pitch_off_text"].setColor(0.9412, 0.7255, 0);
			me["FMA_ATS_thrust_off_box"].setColor(0.9412, 0.7255, 0);
			me["FMA_ATS_thrust_off_text"].setColor(0.9412, 0.7255, 0);
		} else {
			me["FMA_ATS_pitch_off_box"].setColor(1, 1, 1);
			me["FMA_ATS_pitch_off_text"].setColor(1, 1, 1);
			me["FMA_ATS_thrust_off_box"].setColor(1, 1, 1);
			me["FMA_ATS_thrust_off_text"].setColor(1, 1, 1);
		}
		
		if (Value.Afs.apSound) {
			me["FMA_AP_pitch_off_box"].setColor(1, 0, 0);
			me["FMA_AP_thrust_off_box"].setColor(1, 0, 0);
		} else if (!Value.Afs.ap1Avail and !Value.Afs.ap2Avail) {
			me["FMA_AP_pitch_off_box"].setColor(0.9412, 0.7255, 0);
			me["FMA_AP_thrust_off_box"].setColor(0.9412, 0.7255, 0);
		} else if ((Value.Afs.apDisc[0] or Value.Afs.apDisc[1]) and !Value.Afs.ap1 and !Value.Afs.ap2) {
			me["FMA_AP_pitch_off_box"].setColor(0.9412, 0.7255, 0);
			me["FMA_AP_thrust_off_box"].setColor(0.9412, 0.7255, 0);
		} else {
			me["FMA_AP_pitch_off_box"].setColor(1, 1, 1);
			me["FMA_AP_thrust_off_box"].setColor(1, 1, 1);
		}
		
		if (Value.Afs.ats == 1) {
			if (Value.Afs.spdProt != 0 and Value.Afs.thrust == "PITCH") {
				if (Value.Misc.blinkMed2) {
					me["FMA_ATS_pitch_off"].show();
				} else {
					me["FMA_ATS_pitch_off"].hide();
				}
				me["FMA_ATS_thrust_off"].hide();
			} else if (Value.Afs.spdProt != 0) {
				me["FMA_ATS_pitch_off"].hide();
				if (Value.Misc.blinkMed2) {
					me["FMA_ATS_thrust_off"].show();
				} else {
					me["FMA_ATS_thrust_off"].hide();
				}
			} else {
				me["FMA_ATS_pitch_off"].hide();
				me["FMA_ATS_thrust_off"].hide();
			}
		} else if (Value.Afs.atsFlash and !Value.Afs.atsWarn) {
			me["FMA_ATS_pitch_off"].hide();
			me["FMA_ATS_thrust_off"].hide();
		} else if (Value.Afs.atsFlash and Value.Afs.atsWarn and Value.Afs.thrust == "PITCH" and !Value.Afs.bit[n]) {
			me["FMA_ATS_pitch_off"].show();
			me["FMA_ATS_thrust_off"].hide();
		} else if (Value.Afs.atsFlash and Value.Afs.atsWarn) {
			me["FMA_ATS_pitch_off"].hide();
			me["FMA_ATS_thrust_off"].show();
		} else if (Value.Afs.thrust == "PITCH" and !Value.Afs.bit[n]) {
			me["FMA_ATS_pitch_off"].show();
			me["FMA_ATS_thrust_off"].hide();
		} else {
			me["FMA_ATS_pitch_off"].hide();
			me["FMA_ATS_thrust_off"].show();
		}
		
		if (Value.Afs.ap1 or Value.Afs.ap2) {
			me["FMA_AP"].setColor(0.3412, 0.7882, 0.9922);
			if (Value.Afs.land == "DUAL") {
				me["FMA_AP"].setText("AP");
			} else if (Value.Afs.ap1) {
				me["FMA_AP"].setText("AP1");
			} else if (Value.Afs.ap2) {
				me["FMA_AP"].setText("AP2");
			}
			me["FMA_AP"].show();
		} else if (Value.Afs.apSound and !Value.Afs.apWarn) {
			me["FMA_AP"].hide();
		} else if (Value.Afs.apSound and Value.Afs.apWarn) {
			me["FMA_AP"].setColor(1, 0, 0);
			me["FMA_AP"].setText("AP OFF");
			me["FMA_AP"].show();
		} else if (Value.Afs.apDisc[0] or Value.Afs.apDisc[1] or (!Value.Afs.ap1Avail and !Value.Afs.ap2Avail)) {
			me["FMA_AP"].setColor(0.9412, 0.7255, 0);
			me["FMA_AP"].setText("AP OFF");
			me["FMA_AP"].show();
		} else {
			me["FMA_AP"].setColor(1, 1, 1);
			me["FMA_AP"].setText("AP OFF");
			me["FMA_AP"].show();
		}
		
		if (Value.Afs.ap1 or Value.Afs.ap2) {
			me["FMA_AP_pitch_off_box"].hide();
			me["FMA_AP_thrust_off_box"].hide();
		} else if (Value.Afs.apSound and !Value.Afs.apWarn) {
			me["FMA_AP_pitch_off_box"].hide();
			me["FMA_AP_thrust_off_box"].hide();
		} else if (Value.Afs.apSound and Value.Afs.apWarn and Value.Afs.thrust == "PITCH" and !Value.Afs.bit[n]) {
			me["FMA_AP_pitch_off_box"].show();
			me["FMA_AP_thrust_off_box"].hide();
		} else if (Value.Afs.apSound and Value.Afs.apWarn) {
			me["FMA_AP_pitch_off_box"].hide();
			me["FMA_AP_thrust_off_box"].show();
		} else if (Value.Afs.thrust == "PITCH" and !Value.Afs.bit[n]) {
			me["FMA_AP_pitch_off_box"].show();
			me["FMA_AP_thrust_off_box"].hide();
		} else {
			me["FMA_AP_pitch_off_box"].hide();
			me["FMA_AP_thrust_off_box"].show();
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
			me["QNH"].setText(sprintf("%d", pts.Instrumentation.Altimeter.settingHpa.getValue()));
		} else if (Value.Qnh.inhg == 1) {
			me["QNH"].setText(sprintf("%5.2f", pts.Instrumentation.Altimeter.settingInhg.getValue()));
		}
		
		# Slats/Flaps
		if (Value.Misc.slatsOut and !(Value.Misc.slatsPos >= 30.9 and Value.Misc.flapsOut)) {
			me["Slats"].show();
			if (pts.Controls.Flight.autoSlatTimer.getValue() > 0) {
				me["Slats_auto"].show();
				me["Slats_dn"].hide();
				me["Slats_up"].hide();
			} else if (Value.Misc.slatsCmd - Value.Misc.slatsPos >= 0.1) {
				me["Slats_auto"].hide();
				me["Slats_dn"].show();
				me["Slats_up"].hide();
			} else if (Value.Misc.slatsCmd - Value.Misc.slatsPos <= -0.1) {
				me["Slats_auto"].hide();
				me["Slats_dn"].hide();
				me["Slats_up"].show();
			} else {
				me["Slats_auto"].hide();
				me["Slats_dn"].hide();
				me["Slats_up"].hide();
			}
		} else {
			me["Slats"].hide();
			me["Slats_auto"].hide();
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
		
		if (!Value.Misc.slatsOut and pts.Controls.Flight.slatStow.getBoolValue() and systems.FCS.flapsInput.getValue() >= 1) {
			me["Slats_no"].show();
		} else {
			me["Slats_no"].hide();
		}
		
		if (Value.Misc.flapsOut and Value.Misc.flapsCmd - 0.1 >= systems.FCS.flapsMaxDeg.getValue()) {
			me["Flaps_dn"].hide();
			me["Flaps_up"].hide();
			me["Flaps_num"].setColor(0.9412, 0.7255, 0);
			me["Flaps_num_boxes"].show();
			me["Flaps_num2"].setText(sprintf("%2.0f", Value.Misc.flapsCmd));
			me["Flaps_num2"].show();
		} else {
			if (Value.Misc.flapsCmd - Value.Misc.flapsPos >= 0.1) {
				me["Flaps_dn"].show();
				me["Flaps_up"].hide();
			} else if (Value.Misc.flapsCmd - Value.Misc.flapsPos <= -0.1) {
				me["Flaps_dn"].hide();
				me["Flaps_up"].show();
			} else {
				me["Flaps_dn"].hide();
				me["Flaps_up"].hide();
			}
			me["Flaps_num"].setColor(1, 1, 1);
			me["Flaps_num_boxes"].hide();
			me["Flaps_num2"].hide();
		}
		
		# Warnings
		if (!Value.Misc.annunTestWow and (Value.Iru.mainAvail[0] or Value.Iru.mainAvail[1] or Value.Iru.mainAvail[2])) {
			if (instruments.XPDR.tcasMode.getValue() >= 2) {
				me["TCAS"].hide();
			} else {
				me["TCAS_1"].setColor(1, 1, 1);
				me["TCAS_2"].setColor(1, 1, 1);
				me["TCAS_2"].setText("OFF");
				me["TCAS"].show();
			}
		} else {
			me["TCAS_1"].setColor(0.9412, 0.7255, 0);
			me["TCAS_2"].setColor(0.9412, 0.7255, 0);
			me["TCAS_2"].setText("FAIL");
			me["TCAS"].show();
		}
	},
};

var canvasPfd1 = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasPfd1, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	setup: func() {
		# Hide unimplemented objects
		me["ALT_fms"].hide();
		me["ALT_fms_dn"].hide();
		me["ALT_fms_up"].hide();
	},
	update: func() {
		if (pts.Instrumentation.Du.irsCapt.getBoolValue()) {
			Value.Iru.source[0] = 2; # AUX
			me["IRS_aux"].show();
		} else {
			Value.Iru.source[0] = 0;
			me["IRS_aux"].hide();
		}
		
		me.updateBase(0);
	},
};

var canvasPfd2 = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasPfd2, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	setup: func() {
		me["ILS_alt"].setText("ILS1");
		
		# Hide unimplemented objects
		me["ALT_fms"].hide();
		me["ALT_fms_dn"].hide();
		me["ALT_fms_up"].hide();
	},
	update: func() {
		if (pts.Instrumentation.Du.irsFo.getBoolValue()) {
			Value.Iru.source[1] = 2; # AUX
			me["IRS_aux"].show();
		} else {
			Value.Iru.source[1] = 1;
			me["IRS_aux"].hide();
		}
		
		me.updateBase(1);
	},
};

var canvasXx = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasXx]};
		canvas.parsesvg(canvasGroup, file);
		m.page = canvasGroup;
		
		return m;
	},
};

var setup = func() {
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
	var pfd2Group = pfd2Display.createGroup();
	var xx1Group = pfd1Display.createGroup();
	var xx2Group = pfd2Display.createGroup();
	
	pfd1 = canvasPfd1.new(pfd1Group, "Aircraft/MD-11/Nasal/Displays/res/PFD.svg");
	pfd2 = canvasPfd2.new(pfd2Group, "Aircraft/MD-11/Nasal/Displays/res/PFD.svg");
	xx1 = canvasXx.new(xx1Group, "Aircraft/MD-11/Nasal/Displays/res/XX.svg");
	xx2 = canvasXx.new(xx2Group, "Aircraft/MD-11/Nasal/Displays/res/XX.svg");
	
	canvasBase.setup();
	update.start();
	
	if (pts.Systems.Acconfig.Options.Du.pfdFps.getValue() != 20) {
		rateApply();
	}
}

var rateApply = func() {
	update.restart(1 / pts.Systems.Acconfig.Options.Du.pfdFps.getValue());
}

var update = maketimer(0.05, func() { # 20FPS
	canvasBase.update();
});

var showPfd1 = func() {
	var dlg = canvas.Window.new([512, 512], "dialog", nil, 0).set("resize", 1);
	dlg.setCanvas(pfd1Display);
	dlg.set("title", "Captain's PFD");
}

var showPfd2 = func() {
	var dlg = canvas.Window.new([512, 512], "dialog", nil, 0).set("resize", 1);
	dlg.setCanvas(pfd2Display);
	dlg.set("title", "First Officer's PFD");
}

var m = 0;
var s = 0;
var y = 0;

var roundAbout = func(x) { # Unused but left here for reference
	y = x - int(x);
	return y < 0.5 ? int(x) : 1 + int(x);
}

var roundAboutAlt = func(x) { # For altitude tape numbers
	y = x * 0.2 - int(x * 0.2);
	return y < 0.5 ? 5 * int(x * 0.2) : 5 + 5 * int(x * 0.2);
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
