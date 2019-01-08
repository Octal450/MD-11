# MD-11 PFD

# Copyright (c) 2019 Joshua Davidson (it0uchpods)

var PFD_1 = nil;
var PFD_2 = nil;
var PFD_1_mismatch = nil;
var PFD_2_mismatch = nil;
var PFD1_display = nil;
var PFD2_display = nil;
var updateL = 0;
var updateR = 0;
var ASI = 0;
var ASImax = 0;
var ASIflapmax = 0;
var ASIpresel = 0;
var ASIpreseldiff = 0;
var ASIsel = 0;
var ASIseldiff = 0;
var ASItrend = 0;
var pitch = 0;
var roll = 0;
var alpha = 0;
var altTens = 0;
var altPolarity = "";
var HDG = "000";
var HDGraw = 0;
var HDGpresel = 0;
var HDGsel = 0;
var LOC = 0;
var GS = 0;
var ap1 = props.globals.getNode("/it-autoflight/output/ap1", 1);
var ap2 = props.globals.getNode("/it-autoflight/output/ap2", 1);
var athr = props.globals.getNode("/it-autoflight/output/athr", 1);
var fd1 = props.globals.getNode("/it-autoflight/output/fd1", 1);
var fd2 = props.globals.getNode("/it-autoflight/output/fd2", 1);
var apvert = props.globals.getNode("/it-autoflight/output/vert", 1);
var throttle_mode = props.globals.getNode("/it-autoflight/mode/thr", 1);
var roll_mode = props.globals.getNode("/modes/pfd/fma/roll-mode", 1);
var roll_mode_armed = props.globals.getNode("/modes/pfd/fma/roll-mode-armed", 1);
var pitch_mode = props.globals.getNode("/modes/pfd/fma/pitch-mode", 1);
var pitch_mode_armed = props.globals.getNode("/modes/pfd/fma/pitch-mode-armed", 1);
var speed = props.globals.getNode("/instrumentation/airspeed-indicator/indicated-speed-kt", 1);
var mach = props.globals.getNode("/instrumentation/airspeed-indicator/indicated-mach", 1);
var IASmax = props.globals.getNode("/controls/fctl/vmo-mmo", 1);
var IASpresel = props.globals.getNode("/it-autoflight/internal/ias-presel", 1);
var IASsel = props.globals.getNode("/it-autoflight/internal/ias-sel", 1);
var altpresel = props.globals.getNode("/instrumentation/pfd/alt-presel", 1);
var altsel = props.globals.getNode("/instrumentation/pfd/alt-sel", 1);
var ASItrend = props.globals.getNode("/instrumentation/pfd/speed-lookahead", 1);
var IASflapmax = props.globals.getNode("/controls/fctl/flap-gear-max", 1);
var pitch = props.globals.getNode("/orientation/pitch-deg", 1);
var roll = props.globals.getNode("/orientation/roll-deg", 1);
var alpha = props.globals.getNode("/fdm/jsbsim/aero/alpha-deg-damped", 1);
var banklimit = props.globals.getNode("/instrumentation/pfd/bank-limit", 1);
var ac1 = props.globals.getNode("/systems/electrical/bus/ac1", 1);
var ac2 = props.globals.getNode("/systems/electrical/bus/ac2", 1);
var ac3 = props.globals.getNode("/systems/electrical/bus/ac3", 1);
var wow1 = props.globals.getNode("/gear/gear[1]/wow", 1);
var wow2 = props.globals.getNode("/gear/gear[2]/wow", 1);
var apmode = props.globals.getNode("/modes/pfd/fma/ap-mode", 1);
var hdgprediff = props.globals.getNode("/instrumentation/pfd/hdg-pre-diff", 1);
var hdgdiff = props.globals.getNode("/instrumentation/pfd/hdg-diff", 1);
var trackdiff = props.globals.getNode("/instrumentation/pfd/track-hdg-diff", 1);
var showhdg = props.globals.getNode("/it-autoflight/custom/show-hdg", 1);
var hdgscale = props.globals.getNode("/instrumentation/pfd/heading-scale", 1);
var aplat = props.globals.getNode("/it-autoflight/output/lat", 1);
var vspfd = props.globals.getNode("/it-autoflight/internal/vert-speed-fpm-pfd", 1);
var internalvs = props.globals.getNode("/it-autoflight/internal/vert-speed-fpm", 1);
var vsup = props.globals.getNode("/instrumentation/pfd/vs-needle-up", 1);
var vsdn = props.globals.getNode("/instrumentation/pfd/vs-needle-dn", 1);
var gs = props.globals.getNode("/velocities/groundspeed-kt", 1);
var altitude = props.globals.getNode("/instrumentation/altimeter/indicated-altitude-ft", 1);
var IR0align = props.globals.getNode("/instrumentation/irs/ir[0]/aligned", 1);
var IR1align = props.globals.getNode("/instrumentation/irs/ir[1]/aligned", 1);
var IR2align = props.globals.getNode("/instrumentation/irs/ir[2]/aligned", 1);
var eng0state = props.globals.getNode("/engines/engine[0]/state", 1);
var eng1state = props.globals.getNode("/engines/engine[1]/state", 1);
var eng2state = props.globals.getNode("/engines/engine[2]/state", 1);
var gearagl = props.globals.getNode("/position/gear-agl-ft", 1);
var ktsmach = props.globals.getNode("/it-autoflight/input/kts-mach", 1);
var aphdg = props.globals.getNode("/it-autoflight/input/hdg", 1);
var apspd = props.globals.getNode("/it-autoflight/input/spd-kts", 1);
var apmach = props.globals.getNode("/it-autoflight/input/spd-mach", 1);
var apalt = props.globals.getNode("/it-autoflight/internal/alt", 1);
var slat = props.globals.getNode("/fdm/jsbsim/fcc/slat/cmd-deg", 1);
var flap = props.globals.getNode("/fdm/jsbsim/fcc/flap/input-deg", 1);
var flapmaxdeg = props.globals.getNode("/fdm/jsbsim/fcc/flap/max-deg", 1);
var skid = props.globals.getNode("/instrumentation/slip-skid-ball/indicated-slip-skid", 1);
var fdroll = props.globals.getNode("/it-autoflight/fd/roll-bar", 1);
var fdpitch = props.globals.getNode("/it-autoflight/fd/pitch-bar", 1);
var altmode = props.globals.getNode("/modes/altimeter/inhg", 1);
var altmodestd = props.globals.getNode("/modes/altimeter/std", 1);
var altin = props.globals.getNode("/instrumentation/altimeter/setting-inhg", 1);
var althp = props.globals.getNode("/instrumentation/altimeter/setting-hpa", 1);
var fpa = props.globals.getNode("/it-autoflight/input/fpa", 1);
var apfpa = props.globals.getNode("/it-autoflight/custom/vs-fpa", 1);
var rate = props.globals.getNode("/systems/acconfig/options/pfd-rate", 1);
var mismatch = props.globals.getNode("/systems/acconfig/mismatch-code", 1);
var nav0defl = props.globals.getNode("/instrumentation/nav[0]/heading-needle-deflection-norm", 1);
var gs0defl = props.globals.getNode("/instrumentation/nav[0]/gs-needle-deflection-norm", 1);
var nav0range = props.globals.getNode("/instrumentation/nav[0]/in-range", 1);
var gs0range = props.globals.getNode("/instrumentation/nav[0]/gs-in-range", 1);
var nav0signal = props.globals.getNode("/instrumentation/nav[0]/signal-quality-norm", 1);
var hasgs = props.globals.getNode("/instrumentation/nav[0]/has-gs", 1);
var navloc = props.globals.getNode("/instrumentation/nav[0]/nav-loc", 1);

var canvas_PFD_base = {
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
		
		me.AI_horizon_trans = me["AI_horizon"].createTransform();
		me.AI_horizon_rot = me["AI_horizon"].createTransform();
		
		me.AI_fpd_trans = me["AI_fpd"].createTransform();
		me.AI_fpd_rot = me["AI_fpd"].createTransform();
		
		me.page = canvas_group;
		
		return me;
	},
	getKeys: func() {
		return ["FMA_Speed","FMA_Thrust","FMA_Roll","FMA_Roll_Arm","FMA_Pitch","FMA_Pitch_Arm","FMA_Altitude_Thousand","FMA_Altitude","FMA_ATS_Thrust_Off","FMA_ATS_Pitch_Off","FMA_AP_Pitch_Off_Box","FMA_AP_Thrust_Off_Box","FMA_AP","ASI_v_speed","ASI_Taxi",
		"ASI_GroundSpd","ASI_scale","ASI_bowtie","ASI_bowtie_mach","ASI","ASI_mach","ASI_mach_decimal","ASI_bowtie_L","ASI_bowtie_R","ASI_presel","ASI_sel","ASI_trend_up","ASI_trend_down","ASI_max","ASI_max_bar","ASI_max_bar2","ASI_max_flap","AI_center",
		"AI_horizon","AI_bank","AI_slipskid","AI_overbank_index","AI_banklimit_L","AI_banklimit_R","AI_alphalim","AI_group","AI_group2","AI_error","AI_fpv","AI_fpd","AI_arrow","FD_roll","FD_pitch","ALT_thousands","ALT_hundreds","ALT_tens","ALT_scale","ALT_one",
		"ALT_two","ALT_three","ALT_four","ALT_five","ALT_one_T","ALT_two_T","ALT_three_T","ALT_four_T","ALT_five_T","ALT_presel","ALT_sel","VSI_needle_up","VSI_needle_dn","VSI_up","VSI_down","VSI_group","VSI_error","HDG","HDG_dial","HDG_presel","HDG_sel",
		"HDG_group","HDG_error","TRK_pointer","TCAS_OFF","Slats","Flaps","Flaps_num","Flaps_num2","Flaps_num_boxes","QNH","LOC_scale","LOC_pointer","LOC_no","GS_scale","GS_pointer","GS_no","RA","RA_box"];
	},
	update: func() {
		if (mismatch.getValue() == "0x000") {
			PFD_1_mismatch.page.hide();
			PFD_2_mismatch.page.hide();
			if (ac1.getValue() >= 110 or ac2.getValue() >= 110 or ac3.getValue() >= 110) {
				PFD_1.updateFast();
				PFD_2.updateFast();
				PFD_1.update();
				PFD_2.update();
				updateL = 1;
				updateR = 1;
				PFD_1.page.show();
				PFD_2.page.show();
			} else {
				updateL = 0;
				updateR = 0;
				PFD_1.page.hide();
				PFD_2.page.hide();
			}
		} else {
			updateL = 0;
			updateR = 0;
			PFD_1.page.hide();
			PFD_2.page.hide();
			PFD_1_mismatch.update();
			PFD_2_mismatch.update();
			PFD_1_mismatch.page.show();
			PFD_2_mismatch.page.show();
		}
	},
	updateSlow: func() {
		if (updateL) {
			PFD_1.update();
		}
		if (updateR) {
			PFD_2.update();
		}
	},
	updateCommon: func () {
		ap1x = ap1.getValue();
		ap2x = ap2.getValue();
		fd1x = fd1.getValue();
		fd2x = fd2.getValue();
		athrx = athr.getValue();
		throttle_modex = throttle_mode.getValue();
		roll_modex = roll_mode.getValue();
		roll_mode_armedx = roll_mode_armed.getValue();
		pitch_modex = pitch_mode.getValue();
		pitch_mode_armedx = pitch_mode_armed.getValue();
		
		# FMA
		if (fd1x == 1 or fd2x == 1 or ap1x == 1 or ap2x == 1) {
			me["FMA_Thrust"].show();
			me["FMA_Roll"].show();
			me["FMA_Roll_Arm"].show();
			me["FMA_Pitch"].show();
			me["FMA_Pitch_Arm"].show();
		} else {
			if (throttle_modex != "PITCH" and athrx == 1) {
				me["FMA_Thrust"].show();
			} else {
				me["FMA_Thrust"].hide();
			}
			me["FMA_Roll"].hide();
			me["FMA_Roll_Arm"].hide();
			if (throttle_modex == "PITCH" and athrx == 1) {
				me["FMA_Pitch"].show();
				me["FMA_Pitch_Arm"].show();
			} else {
				me["FMA_Pitch"].hide();
				me["FMA_Pitch_Arm"].hide();
			}
		}
		
		if (athrx == 1) {
			me["FMA_ATS_Pitch_Off"].hide();
			me["FMA_ATS_Thrust_Off"].hide();
		} elsif (throttle_modex == "PITCH") {
			me["FMA_ATS_Pitch_Off"].show();
			me["FMA_ATS_Thrust_Off"].hide();
		} else {
			me["FMA_ATS_Pitch_Off"].hide();
			me["FMA_ATS_Thrust_Off"].show();
		}
		
		eng0statex = eng0state.getValue();
		eng1statex = eng1state.getValue();
		eng2statex = eng2state.getValue();
		IR0alignx = IR0align.getValue();
		IR1alignx = IR1align.getValue();
		IR2alignx = IR2align.getValue();
		wow1x = wow1.getValue();
		wow2x = wow2.getValue();
		
		if (ap1x == 1 or ap2x == 1) {
			me["FMA_AP"].setColor(0.3215,0.8078,1);
			me["FMA_AP"].setText(sprintf("%s", apmode.getValue()));
			me["FMA_AP_Pitch_Off_Box"].hide();
			me["FMA_AP_Thrust_Off_Box"].hide();
		} elsif (throttle_modex == "PITCH") {
			if (IR0alignx == 0 and IR1alignx == 0 and IR2alignx == 0) {
				me["FMA_AP"].setColor(1,0.7843,0);
			} elsif (eng0statex != 3 and eng1statex != 3 and eng2statex != 3 and wow1x != 0 and wow2x != 0) {
				me["FMA_AP"].setColor(1,0.7843,0);
			} else {
				me["FMA_AP"].setColor(1,1,1);
			}
			me["FMA_AP"].setText("AP OFF");
			me["FMA_AP_Pitch_Off_Box"].show();
			me["FMA_AP_Thrust_Off_Box"].hide();
		} else {
			if (IR0alignx == 0 and IR1alignx == 0 and IR2alignx == 0) {
				me["FMA_AP"].setColor(1,0.7843,0);
			} elsif (eng0statex != 3 and eng1statex != 3 and eng2statex != 3 and wow1x != 0 and wow2x != 0) {
				me["FMA_AP"].setColor(1,0.7843,0);
			} else {
				me["FMA_AP"].setColor(1,1,1);
			}
			me["FMA_AP"].setText("AP OFF");
			me["FMA_AP_Pitch_Off_Box"].hide();
			me["FMA_AP_Thrust_Off_Box"].show();
		}
		
		if (eng0statex != 3 and eng1statex != 3 and eng2statex != 3) {
			me["FMA_ATS_Pitch_Off"].setColor(1,0.7843,0);
			me["FMA_ATS_Thrust_Off"].setColor(1,0.7843,0);
		} else {
			me["FMA_ATS_Pitch_Off"].setColor(1,1,1);
			me["FMA_ATS_Thrust_Off"].setColor(1,1,1);
		}
		
		if (IR0alignx == 0 and IR1alignx == 0 and IR2alignx == 0) {
			me["FMA_AP_Pitch_Off_Box"].setColor(1,0.7843,0);
			me["FMA_AP_Thrust_Off_Box"].setColor(1,0.7843,0);
		} elsif (eng0statex != 3 and eng0statex != 3 and eng0statex != 3 and wow1x != 0 and wow2x != 0) {
			me["FMA_AP_Pitch_Off_Box"].setColor(1,0.7843,0);
			me["FMA_AP_Thrust_Off_Box"].setColor(1,0.7843,0);
		} else {
			me["FMA_AP_Pitch_Off_Box"].setColor(1,1,1);
			me["FMA_AP_Thrust_Off_Box"].setColor(1,1,1);
		}
		
		if (ktsmach.getValue() == 1) {
			me["FMA_Speed"].setText(sprintf("%0.3f", apmach.getValue()));
		} else {
			me["FMA_Speed"].setText(sprintf("%3.0f", apspd.getValue()));
		}
		
		me["FMA_Thrust"].setText(sprintf("%s", throttle_modex));
		if (roll_modex == "HEADING") {
			me["FMA_Roll"].setText(sprintf("%s", roll_modex ~ " " ~ aphdg.getValue()));
		} else {
			me["FMA_Roll"].setText(sprintf("%s", roll_modex));
		}
		me["FMA_Roll_Arm"].setText(sprintf("%s", roll_mode_armedx));
		me["FMA_Pitch"].setText(sprintf("%s", pitch_modex));
		me["FMA_Pitch_Arm"].setText(sprintf("%s", pitch_mode_armedx));
		
		if (roll_modex == "NAV1" or roll_modex == "NAV2") {
			me["FMA_Roll"].setColor(0.9607,0,0.7764);
		} else {
			me["FMA_Roll"].setColor(1,1,1);
		}
		
		if (roll_mode_armedx == "NAV ARMED") {
			me["FMA_Roll_Arm"].setColor(0.9607,0,0.7764);
		} else {
			me["FMA_Roll_Arm"].setColor(1,1,1);
		}
		
		apaltx = apalt.getValue();
		me["FMA_Altitude_Thousand"].setText(sprintf("%2.0f", math.floor(apaltx / 1000)));
		me["FMA_Altitude"].setText(right(sprintf("%03d", apaltx), 3));
		
		# QNH
		altmodex = altmode.getValue();
		if (altmodestd.getValue() == 1) {
			if (altmodex == 0) {
				me["QNH"].setText("1013");
			} elsif (altmodex == 1) {
				me["QNH"].setText("29.92");
			}
		} elsif (altmodex == 0) {
			me["QNH"].setText(sprintf("%4.0f", althp.getValue()));
		} elsif (altmodex == 1) {
			me["QNH"].setText(sprintf("%2.2f", altin.getValue()));
		}
		
		# Slats/Flaps
		flapx = flap.getValue();
		if (slat.getValue() > 0.1 and flapx <= 0.1) {
			me["Slats"].show();
		} else {
			me["Slats"].hide();
		}
		
		if (flapx > 0.1) {
			me["Flaps"].show();
			me["Flaps_num"].setText(sprintf("%2.0f", flapx));
			me["Flaps_num"].show();
		} else {
			me["Flaps"].hide();
			me["Flaps_num"].hide();
		}
		
		if (flapx > 0.1 and flapx - 0.1 > flapmaxdeg.getValue()) {
			me["Flaps_num"].setColor(0.9647,0.8196,0.0784);
			me["Flaps_num_boxes"].show();
			me["Flaps_num2"].setText(sprintf("%2.0f", flapx));
			me["Flaps_num2"].show();
		} else {
			me["Flaps_num"].setColor(1,1,1);
			me["Flaps_num_boxes"].hide();
			me["Flaps_num2"].hide();
		}
		
		# Misc
		me["TCAS_OFF"].hide();
	},
	updateCommonFast: func() {
		# Airspeed
		me["ASI_v_speed"].hide();
		
		speedx = speed.getValue();
		if (speedx >= 50) {
			me["ASI_GroundSpd"].hide();
			me["ASI_Taxi"].hide();
			me["ASI_bowtie"].show();
			me["ASI_scale"].show();
			me["ASI_presel"].show();
			me["ASI_sel"].show();
			me["ASI_max"].show();
			me["ASI_max_flap"].show();
		} else {
			me["ASI_GroundSpd"].setText(sprintf("%3.0f", gs.getValue()));
			me["ASI_GroundSpd"].show();
			me["ASI_Taxi"].show();
			me["ASI_bowtie"].hide();
			me["ASI_scale"].hide();
			me["ASI_presel"].hide();
			me["ASI_sel"].hide();
			me["ASI_max"].hide();
			me["ASI_max_flap"].hide();
		}
		
		# Subtract 50, since the scale starts at 50, but don"t allow less than 0, or more than 500 situations
		if (speedx <= 50) {
			ASI = 0;
		} elsif (speedx >= 500) {
			ASI = 450;
		} else {
			ASI = speedx - 50;
		}
		
		IASmaxx = IASmax.getValue();
		if (IASmaxx <= 50) {
			ASImax = 0 - ASI;
		} elsif (IASmaxx >= 500) {
			ASImax = 450 - ASI;
		} else {
			ASImax = IASmaxx - 50 - ASI;
		}
		
		IASflapmaxx = IASflapmax.getValue();
		if (IASflapmaxx < 0) {
			ASIflapmax = 0;
			me["ASI_max_bar"].show();
			me["ASI_max_bar2"].hide();
			me["ASI_max_flap"].hide();
		} elsif (IASflapmaxx <= 50) {
			ASIflapmax = 0 - ASI;
			me["ASI_max_bar"].hide();
			me["ASI_max_bar2"].show();
			me["ASI_max_flap"].show();
		} elsif (IASflapmaxx >= 500) {
			ASIflapmax = 450 - ASI;
			me["ASI_max_bar"].hide();
			me["ASI_max_bar2"].show();
			me["ASI_max_flap"].show();
		} else {
			ASIflapmax = IASflapmaxx - 50 - ASI;
			me["ASI_max_bar"].hide();
			me["ASI_max_bar2"].show();
			me["ASI_max_flap"].show();
		}
		
		me["ASI_scale"].setTranslation(0, ASI * 4.48656);
		me["ASI_max"].setTranslation(0, ASImax * -4.48656);
		me["ASI_max_flap"].setTranslation(0, ASIflapmax * -4.48656);
		me["ASI"].setText(sprintf("%3.0f", speedx));
		
		if (speedx > IASmaxx) {
			me["ASI"].setColor(1,0,0);
			me["ASI_mach"].setColor(1,0,0);
			me["ASI_mach_decimal"].setColor(1,0,0);
			me["ASI_bowtie_L"].setColor(1,0,0);
			me["ASI_bowtie_R"].setColor(1,0,0);
		} elsif (speedx > IASflapmaxx and IASflapmaxx >= 0) {
			me["ASI"].setColor(0.9647,0.8196,0.07843);
			me["ASI_mach"].setColor(0.9647,0.8196,0.0784);
			me["ASI_mach_decimal"].setColor(0.9647,0.8196,0.0784);
			me["ASI_bowtie_L"].setColor(0.9647,0.8196,0.0784);
			me["ASI_bowtie_R"].setColor(0.9647,0.8196,0.0784);
		} else {
			me["ASI"].setColor(1,1,1);
			me["ASI_mach"].setColor(1,1,1);
			me["ASI_mach_decimal"].setColor(1,1,1);
			me["ASI_bowtie_L"].setColor(1,1,1);
			me["ASI_bowtie_R"].setColor(1,1,1);
		}
		
		machx = mach.getValue();
		if (machx >= 0.5) {
			me["ASI_bowtie_mach"].show();
		} else {
			me["ASI_bowtie_mach"].hide();
		}
		
		if (machx >= 0.999) {
			me["ASI_mach"].setText("999");
		} else {
			me["ASI_mach"].setText(sprintf("%3.0f", machx * 1000));
		}
		
		IASpreselx = IASpresel.getValue();
		if (IASpreselx <= 50) {
			ASIpresel = 0 - ASI;
		} elsif (IASpreselx >= 500) {
			ASIpresel = 450 - ASI;
		} else {
			ASIpresel = IASpreselx - 50 - ASI;
		}
		
		me["ASI_presel"].setTranslation(0, ASIpresel * -4.48656);
		
		IASselx = IASsel.getValue();
		if (IASselx <= 50) {
			ASIsel = 0 - ASI;
		} elsif (IASselx >= 500) {
			ASIsel = 450 - ASI;
		} else {
			ASIsel = IASselx - 50 - ASI;
		}
		
		me["ASI_sel"].setTranslation(0, ASIsel * -4.48656);
		
		ASItrendx = ASItrend.getValue() - ASI;
		me["ASI_trend_up"].setTranslation(0, math.clamp(ASItrendx, 0, 60) * -4.48656);
		me["ASI_trend_down"].setTranslation(0, math.clamp(ASItrendx, -60, 0) * -4.48656);
		
		if (ASItrendx >= 2) {
			me["ASI_trend_up"].show();
			me["ASI_trend_down"].hide();
		} elsif (ASItrendx <= -2) {
			me["ASI_trend_down"].show();
			me["ASI_trend_up"].hide();
		} else {
			me["ASI_trend_up"].hide();
			me["ASI_trend_down"].hide();
		}
		
		# Attitude
		pitchx = pitch.getValue() or 0;
		rollx =  roll.getValue() or 0;
		alphax =  alpha.getValue() or 0;
		
		me.AI_horizon_trans.setTranslation(0, pitchx * 10.246);
		me.AI_horizon_rot.setRotation(-rollx * D2R, me["AI_center"].getCenter());
		
		trackdiffx = trackdiff.getValue();
		me["AI_fpv"].setTranslation(math.clamp(trackdiffx, -20, 20) * 10.246, math.clamp(alphax, -20, 20) * 10.246);
		if (apfpa.getValue() == 1) {
			me["AI_fpv"].show();
		} else {
			me["AI_fpv"].hide();
		}
		
		if (apvert.getValue() == 5) {
			me.AI_fpd_trans.setTranslation(0, (pitchx - alphax + (alphax * math.cos(rollx / 57.2957795131)) - fpa.getValue()) * 10.246);
			me.AI_fpd_rot.setRotation(-rollx * D2R, me["AI_center"].getCenter());
			me["AI_fpd"].show();
		} else {
			me["AI_fpd"].hide();
		}
		
		me["AI_arrow"].setRotation(math.clamp(-rollx, -45, 45) * D2R);
		if (pitchx > 25) {
			me["AI_arrow"].show();
		} else {
			me["AI_arrow"].hide();
		}
		
		me["AI_alphalim"].setTranslation(0, math.clamp(16 - alphax, -20, 20) * -10.246);
		if (alphax >= 15.5) {
			me["AI_alphalim"].setColor(1,0,0);
		} else {
			me["AI_alphalim"].setColor(0.2156,0.5019,0.6627);
		}
		
		fdrollx = fdroll.getValue();
		fdpitchx = fdpitch.getValue();
		if (fdrollx != nil) {
			me["FD_roll"].setTranslation((fdrollx) * 2.2, 0);
		}
		if (fdpitchx != nil) {
			me["FD_pitch"].setTranslation(0, -(fdpitchx) * 3.8);
		}
		
		me["AI_slipskid"].setTranslation(math.clamp(skid.getValue(), -7, 7) * -15, 0);
		me["AI_bank"].setRotation(-rollx * D2R);
		
		if (abs(rollx) >= 30.5) {
			me["AI_overbank_index"].show();
		} else {
			me["AI_overbank_index"].hide();
		}
		
		banklimitx = banklimit.getValue();
		me["AI_banklimit_L"].setRotation(banklimitx * -D2R);
		me["AI_banklimit_R"].setRotation(banklimitx * D2R);
		
		# Altitude
		me.altitudex = altitude.getValue();
		me.altOffset = me.altitudex / 500 - int(me.altitudex / 500);
		me.middleAltText = roundaboutAlt(me.altitudex / 100) * 100;
		me.middleAltOffset = nil;
		if (me.altOffset > 0.5) {
			me.middleAltOffset = -(me.altOffset - 1) * 254.508;
		} else {
			me.middleAltOffset = -me.altOffset * 254.508;
		}
		me["ALT_scale"].setTranslation(0, -me.middleAltOffset);
		me["ALT_scale"].update();
		me.five = int((me.middleAltText + 1000) * 0.001);
		me["ALT_five"].setText(sprintf("%03d", abs(1000 * (((me.middleAltText + 1000) * 0.001) - me.five))));
		me.fiveT = sprintf("%01d", abs(me.five));
		if (me.fiveT == 0) {
			me["ALT_five_T"].setText(" ");
		} else {
			me["ALT_five_T"].setText(me.fiveT);
		}
		me.four = int((me.middleAltText + 500) * 0.001);
		me["ALT_four"].setText(sprintf("%03d", abs(1000 * (((me.middleAltText + 500) * 0.001) - me.four))));
		me.fourT = sprintf("%01d", abs(me.four));
		if (me.fourT == 0) {
			me["ALT_four_T"].setText(" ");
		} else {
			me["ALT_four_T"].setText(me.fourT);
		}
		me.three = int(me.middleAltText * 0.001);
		me["ALT_three"].setText(sprintf("%03d", abs(1000 * ((me.middleAltText  * 0.001) - me.three))));
		me.threeT = sprintf("%01d", abs(me.three));
		if (me.threeT == 0) {
			me["ALT_three_T"].setText(" ");
		} else {
			me["ALT_three_T"].setText(me.threeT);
		}
		me.two = int((me.middleAltText - 500) * 0.001);
		me["ALT_two"].setText(sprintf("%03d", abs(1000 * (((me.middleAltText - 500) * 0.001) - me.two))));
		me.twoT = sprintf("%01d", abs(me.two));
		if (me.twoT == 0) {
			me["ALT_two_T"].setText(" ");
		} else {
			me["ALT_two_T"].setText(me.twoT);
		}
		me.one = int((me.middleAltText - 1000) * 0.001);
		me["ALT_one"].setText(sprintf("%03d", abs(1000 * (((me.middleAltText - 1000) * 0.001) - me.one))));
		me.oneT = sprintf("%01d", abs(me.one));
		if (me.oneT == 0) {
			me["ALT_one_T"].setText(" ");
		} else {
			me["ALT_one_T"].setText(me.oneT);
		}
		
		altitudex = altitude.getValue();
		if (altitudex < 0) {
			altPolarity = "-";
		} else {
			altPolarity = "";
		}
		me["ALT_thousands"].setText(sprintf("%s%d", altPolarity, math.abs(int(altitudex / 1000))));
		me["ALT_hundreds"].setText(sprintf("%d", math.floor(num(right(sprintf("%03d", abs(altitudex)), 3)) / 100)));
		altTens = num(right(sprintf("%02d", altitudex), 2));
		me["ALT_tens"].setTranslation(0, altTens * 2.1325);
		
		me["ALT_presel"].setTranslation(0, (altpresel.getValue() / 100) * -50.9016);
		me["ALT_sel"].setTranslation(0, (altsel.getValue() / 100) * -50.9016);
		
		# Vertical Speed
		internalvsx = internalvs.getValue();
		if (internalvsx <= -50) {
			me["VSI_needle_up"].hide();
		} else {
			me["VSI_needle_up"].show();
		}
		if (internalvsx >= 50) {
			me["VSI_needle_dn"].hide();
		} else {
			me["VSI_needle_dn"].show();
		}
		
		vspfdx = vspfd.getValue();
		if (internalvsx > 10 and vspfdx > 0) {
			me["VSI_up"].show();
		} else {
			me["VSI_up"].hide();
		}
		if (internalvsx < -10 and vspfdx > 0) {
			me["VSI_down"].show();
		} else {
			me["VSI_down"].hide();
		}
		
		me["VSI_up"].setText(sprintf("%1.1f", vspfdx));
		me["VSI_down"].setText(sprintf("%1.1f", vspfdx));
		me["VSI_needle_up"].setTranslation(0, vsup.getValue());
		me["VSI_needle_dn"].setTranslation(0, vsdn.getValue());
		
		# Heading
		hdgscalex = hdgscale.getValue();
		HDGraw = hdgscalex + 0.5;
		if (HDGraw > 359) {
			HDGraw = HDGraw - 360;
		}
		if (HDGraw < 0) {
			HDGraw = HDGraw + 360;
		}
		HDG = sprintf("%03d", HDGraw);
		if (HDG == "360") {
			HDG == "000";
		}
		me["HDG"].setText(HDG);
		me["HDG_dial"].setRotation(hdgscalex * -D2R);
		
		showhdgx = showhdg.getValue();
		if (showhdgx == 1) {
			me["HDG_presel"].show();
		} else {
			me["HDG_presel"].hide();
		}
		if (showhdgx == 1 and aplat.getValue() == 0) {
			me["HDG_sel"].show();
		} else {
			me["HDG_sel"].hide();
		}
		
		hdgprediffx =  hdgprediff.getValue();
		if (hdgprediffx <= 35 and hdgprediffx >= -35) {
			HDGpresel = hdgprediffx;
		} elsif (hdgprediffx > 35) {
			HDGpresel = 35;
		} elsif (hdgprediffx < -35) {
			HDGpresel = -35;
		}
		me["HDG_presel"].setRotation(HDGpresel * D2R);
		
		hdgdiffx = hdgdiff.getValue();
		if (hdgdiffx <= 35 and hdgdiffx >= -35) {
			HDGsel = hdgdiffx;
		} elsif (hdgdiffx > 35) {
			HDGsel = 35;
		} elsif (hdgdiffx < -35) {
			HDGsel = -35;
		}
		me["HDG_sel"].setRotation(HDGsel * D2R);
		
		me["TRK_pointer"].setRotation(trackdiffx * D2R);
		
		# ILS
		LOC = nav0defl.getValue() or 0;
		GS = gs0defl.getValue() or 0;
		me["LOC_pointer"].setTranslation(LOC * 200, 0);
		me["GS_pointer"].setTranslation(0, GS * -204);
		
		if (nav0range.getValue() == 1) {
			me["LOC_scale"].show();
			if (navloc.getValue() == 1 and nav0signal.getValue() > 0.99) {
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
		if (gs0range.getValue() == 1) {
			me["GS_scale"].show();
			if (hasgs.getValue() == 1 and nav0signal.getValue() > 0.99) {
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
		
		# Misc
		gearaglx = gearagl.getValue();
		if (gearaglx <= 2500) {
			me["RA"].setText(sprintf("%4.0f", gearaglx));
			me["RA"].show();
			me["RA_box"].show();
		} else {
			me["RA"].hide();
			me["RA_box"].hide();
		}
	},
};

var canvas_PFD_1 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_1, canvas_PFD_base]};
		m.init(canvas_group, file);

		return m;
	},
	update: func() {
		fd1x = fd1.getValue();
		
		if (fd1x == 1) {
			me["FD_roll"].show();
		} else {
			me["FD_roll"].hide();
		}
		
		if (fd1x == 1) {
			me["FD_pitch"].show();
		} else {
			me["FD_pitch"].hide();
		}
		
		if (IR0align.getValue() == 1) {
			me["AI_group"].show();
			me["AI_group2"].show();
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
			me["HDG_group"].hide();
			me["VSI_group"].hide();
		}
		
		me.updateCommon();
	},
	updateFast: func() {
		me.updateCommonFast();
	},
};

var canvas_PFD_2 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_PFD_2, canvas_PFD_base]};
		m.init(canvas_group, file);

		return m;
	},
	update: func() {
		fd2x = fd2.getValue();
		
		if (fd2x == 1) {
			me["FD_roll"].show();
		} else {
			me["FD_roll"].hide();
		}
		
		if (fd2x == 1) {
			me["FD_pitch"].show();
		} else {
			me["FD_pitch"].hide();
		}
		
		if (IR1align.getValue() == 1) {
			me["AI_group"].show();
			me["AI_group2"].show();
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
			me["HDG_group"].hide();
			me["VSI_group"].hide();
		}
		
		me.updateCommon();
	},
	updateFast: func() {
		me.updateCommonFast();
	},
};

var canvas_PFD_1_mismatch = {
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
		var m = {parents: [canvas_PFD_1_mismatch]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["ERRCODE"];
	},
	update: func() {
		me["ERRCODE"].setText(mismatch.getValue());
	},
};

var canvas_PFD_2_mismatch = {
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
		var m = {parents: [canvas_PFD_2_mismatch]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["ERRCODE"];
	},
	update: func() {
		me["ERRCODE"].setText(mismatch.getValue());
	},
};

setlistener("sim/signals/fdm-initialized", func {
	PFD1_display = canvas.new({
		"name": "PFD1",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	PFD2_display = canvas.new({
		"name": "PFD2",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	PFD1_display.addPlacement({"node": "pfd1.screen"});
	PFD2_display.addPlacement({"node": "pfd2.screen"});
	var group_pfd1 = PFD1_display.createGroup();
	var group_pfd1_mismatch = PFD1_display.createGroup();
	var group_pfd2 = PFD2_display.createGroup();
	var group_pfd2_mismatch = PFD2_display.createGroup();

	PFD_1 = canvas_PFD_1.new(group_pfd1, "Aircraft/IDG-MD-11X/Models/cockpit/instruments/PFD/res/pfd.svg");
	PFD_1_mismatch = canvas_PFD_1_mismatch.new(group_pfd1_mismatch, "Aircraft/IDG-MD-11X/Models/cockpit/instruments/Common/res/mismatch.svg");
	PFD_2 = canvas_PFD_2.new(group_pfd2, "Aircraft/IDG-MD-11X/Models/cockpit/instruments/PFD/res/pfd.svg");
	PFD_2_mismatch = canvas_PFD_2_mismatch.new(group_pfd2_mismatch, "Aircraft/IDG-MD-11X/Models/cockpit/instruments/Common/res/mismatch.svg");
	
	PFD_update.start();
	PFD_update_fast.start();
	if (rate.getValue() > 1) {
		rateApply();
	}
});

var rateApply = func {
	ratex = rate.getValue();
	PFD_update.restart(0.15 * ratex);
	PFD_update_fast.restart(0.05 * ratex);
}

var PFD_update = maketimer(0.15, func {
	canvas_PFD_base.updateSlow();
});

var PFD_update_fast = maketimer(0.05, func {
	canvas_PFD_base.update();
});

var showPFD1 = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(PFD1_display);
}

var showPFD2 = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(PFD2_display);
}

var roundabout = func(x) {
	var y = x - int(x);
	return y < 0.5 ? int(x) : 1 + int(x);
};

var roundaboutAlt = func(x) {
	var y = x * 0.2 - int(x * 0.2);
	return y < 0.5 ? 5 * int(x * 0.2) : 5 + 5 * int(x * 0.2);
};
