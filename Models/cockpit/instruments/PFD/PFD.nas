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
var ap1 = getprop("/it-autoflight/output/ap1");
var ap2 = getprop("/it-autoflight/output/ap2");
var fd1 = getprop("/it-autoflight/output/fd1");
var fd2 = getprop("/it-autoflight/output/fd2");
var throttle_mode = getprop("/it-autoflight/mode/thr");
var roll_mode = getprop("/modes/pfd/fma/roll-mode");
var roll_mode_armed = getprop("/modes/pfd/fma/roll-mode-armed");
var pitch_mode = getprop("/modes/pfd/fma/pitch-mode");
var pitch_mode_armed = getprop("/modes/pfd/fma/pitch-mode-armed");
var wow1 = getprop("/gear/gear[1]/wow");
var wow2 = getprop("/gear/gear[2]/wow");
setprop("/it-autoflight/internal/ias-presel", 0);
setprop("/it-autoflight/internal/ias-sel", 0);
setprop("/instrumentation/pfd/alt-presel", 0);
setprop("/instrumentation/pfd/alt-sel", 0);
setprop("/instrumentation/pfd/bank-limit", 0);
setprop("/instrumentation/pfd/hdg-pre-diff", 0);
setprop("/instrumentation/pfd/hdg-diff", 0);
setprop("/instrumentation/pfd/heading-scale", 0);
setprop("/instrumentation/pfd/speed-lookahead", 0);
setprop("/instrumentation/pfd/track-deg", 0);
setprop("/instrumentation/pfd/track-hdg-diff", 0);
setprop("/instrumentation/pfd/vs-needle-up", 0);
setprop("/instrumentation/pfd/vs-needle-dn", 0);
setprop("/position/gear-agl-ft", 0);

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
		
		me.page = canvas_group;
		
		return me;
	},
	getKeys: func() {
		return ["FMA_Speed","FMA_Thrust","FMA_Roll","FMA_Roll_Arm","FMA_Pitch","FMA_Pitch_Arm","FMA_Altitude_Thousand","FMA_Altitude","FMA_ATS_Thrust_Off","FMA_ATS_Pitch_Off","FMA_AP_Pitch_Off_Box","FMA_AP_Thrust_Off_Box","FMA_AP","ASI_v_speed","ASI_Taxi",
		"ASI_GroundSpd","ASI_scale","ASI_bowtie","ASI_bowtie_mach","ASI","ASI_mach","ASI_presel","ASI_sel","ASI_trend_up","ASI_trend_down","AI_center","AI_horizon","AI_bank","AI_slipskid","AI_banklimit_L","AI_banklimit_R","AI_alphalim","AI_group","AI_group2",
		"AI_error","AI_fpv","AI_arrow","FD_roll","FD_pitch","ALT_thousands","ALT_hundreds","ALT_tens","ALT_scale","ALT_one","ALT_two","ALT_three","ALT_four","ALT_five","ALT_one_T","ALT_two_T","ALT_three_T","ALT_four_T","ALT_five_T","ALT_presel","ALT_sel",
		"VSI_needle_up","VSI_needle_dn","VSI_up","VSI_down","VSI_group","VSI_error","HDG","HDG_dial","HDG_presel","HDG_sel","HDG_group","HDG_error","TRK_pointer","TCAS_OFF","Slats","Flaps","Flaps_num","QNH","LOC_scale","LOC_pointer","LOC_no","GS_scale",
		"GS_pointer","GS_no","RA","RA_box"];
	},
	update: func() {
		if (getprop("/systems/acconfig/mismatch-code") == "0x000") {
			PFD_1_mismatch.page.hide();
			PFD_2_mismatch.page.hide();
			if (getprop("/systems/electrical/bus/ac1") >= 110 or getprop("/systems/electrical/bus/ac2") >= 110 or getprop("/systems/electrical/bus/ac3") >= 110) {
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
		ap1 = getprop("/it-autoflight/output/ap1");
		ap2 = getprop("/it-autoflight/output/ap2");
		fd1 = getprop("/it-autoflight/output/fd1");
		fd2 = getprop("/it-autoflight/output/fd2");
		athr = getprop("/it-autoflight/output/athr");
		throttle_mode = getprop("/it-autoflight/mode/thr");
		roll_mode = getprop("/modes/pfd/fma/roll-mode");
		roll_mode_armed = getprop("/modes/pfd/fma/roll-mode-armed");
		pitch_mode = getprop("/modes/pfd/fma/pitch-mode");
		pitch_mode_armed = getprop("/modes/pfd/fma/pitch-mode-armed");
		
		# FMA
		if (fd1 == 1 or fd2 == 1 or ap1 == 1 or ap2 == 1) {
			me["FMA_Thrust"].show();
			me["FMA_Roll"].show();
			me["FMA_Roll_Arm"].show();
			me["FMA_Pitch"].show();
			me["FMA_Pitch_Arm"].show();
		} else {
			if (throttle_mode != "PITCH" and athr == 1) {
				me["FMA_Thrust"].show();
			} else {
				me["FMA_Thrust"].hide();
			}
			me["FMA_Roll"].hide();
			me["FMA_Roll_Arm"].hide();
			if (throttle_mode == "PITCH" and athr == 1) {
				me["FMA_Pitch"].show();
				me["FMA_Pitch_Arm"].show();
			} else {
				me["FMA_Pitch"].hide();
				me["FMA_Pitch_Arm"].hide();
			}
		}
		
		if (athr == 1) {
			me["FMA_ATS_Pitch_Off"].hide();
			me["FMA_ATS_Thrust_Off"].hide();
		} else if (throttle_mode == "PITCH") {
			me["FMA_ATS_Pitch_Off"].show();
			me["FMA_ATS_Thrust_Off"].hide();
		} else {
			me["FMA_ATS_Pitch_Off"].hide();
			me["FMA_ATS_Thrust_Off"].show();
		}
		
		if (ap1 == 1 or ap2 == 1) {
			me["FMA_AP"].setColor(0.3215,0.8078,1);
			me["FMA_AP"].setText(sprintf("%s", getprop("/modes/pfd/fma/ap-mode")));
			me["FMA_AP_Pitch_Off_Box"].hide();
			me["FMA_AP_Thrust_Off_Box"].hide();
		} else if (throttle_mode == "PITCH") {
			if (getprop("/instrumentation/irs/ir[0]/aligned") == 0 and getprop("/instrumentation/irs/ir[1]/aligned") == 0 and getprop("/instrumentation/irs/ir[2]/aligned") == 0) {
				me["FMA_AP"].setColor(1,0.7843,0);
			} else {
				me["FMA_AP"].setColor(1,1,1);
			}
			me["FMA_AP"].setText("AP OFF");
			me["FMA_AP_Pitch_Off_Box"].show();
			me["FMA_AP_Thrust_Off_Box"].hide();
		} else {
			if (getprop("/instrumentation/irs/ir[0]/aligned") == 0 and getprop("/instrumentation/irs/ir[1]/aligned") == 0 and getprop("/instrumentation/irs/ir[2]/aligned") == 0) {
				me["FMA_AP"].setColor(1,0.7843,0);
			} else {
				me["FMA_AP"].setColor(1,1,1);
			}
			me["FMA_AP"].setText("AP OFF");
			me["FMA_AP_Pitch_Off_Box"].hide();
			me["FMA_AP_Thrust_Off_Box"].show();
		}
		
		if (getprop("/engines/engine[0]/state") != 3 and getprop("/engines/engine[1]/state") != 3 and getprop("/engines/engine[2]/state") != 3) {
			me["FMA_ATS_Pitch_Off"].setColor(1,0.7843,0);
			me["FMA_ATS_Thrust_Off"].setColor(1,0.7843,0);
		} else {
			me["FMA_ATS_Pitch_Off"].setColor(1,1,1);
			me["FMA_ATS_Thrust_Off"].setColor(1,1,1);
		}
		
		if (getprop("/instrumentation/irs/ir[0]/aligned") == 0 and getprop("/instrumentation/irs/ir[1]/aligned") == 0 and getprop("/instrumentation/irs/ir[2]/aligned") == 0) {
			me["FMA_AP_Pitch_Off_Box"].setColor(1,0.7843,0);
			me["FMA_AP_Thrust_Off_Box"].setColor(1,0.7843,0);
		} else {
			me["FMA_AP_Pitch_Off_Box"].setColor(1,1,1);
			me["FMA_AP_Thrust_Off_Box"].setColor(1,1,1);
		}
		
		if (getprop("/it-autoflight/input/kts-mach") == 1) {
			me["FMA_Speed"].setText(sprintf("%0.3f", getprop("/it-autoflight/input/spd-mach")));
		} else {
			me["FMA_Speed"].setText(sprintf("%3.0f", getprop("/it-autoflight/input/spd-kts")));
		}
		
		me["FMA_Thrust"].setText(sprintf("%s", throttle_mode));
		if (roll_mode == "HEADING") {
			me["FMA_Roll"].setText(sprintf("%s", roll_mode ~ " " ~ getprop("/it-autoflight/input/hdg")));
		} else {
			me["FMA_Roll"].setText(sprintf("%s", roll_mode));
		}
		me["FMA_Roll_Arm"].setText(sprintf("%s", roll_mode_armed));
		me["FMA_Pitch"].setText(sprintf("%s", pitch_mode));
		me["FMA_Pitch_Arm"].setText(sprintf("%s", pitch_mode_armed));
		
		if (roll_mode == "NAV1" or roll_mode == "NAV2") {
			me["FMA_Roll"].setColor(0.9607,0,0.7764);
		} else {
			me["FMA_Roll"].setColor(1,1,1);
		}
		
		if (roll_mode_armed == "NAV ARMED") {
			me["FMA_Roll_Arm"].setColor(0.9607,0,0.7764);
		} else {
			me["FMA_Roll_Arm"].setColor(1,1,1);
		}
		
		me["FMA_Altitude_Thousand"].setText(sprintf("%2.0f", math.floor(getprop("/it-autoflight/internal/alt") / 1000)));
		me["FMA_Altitude"].setText(right(sprintf("%03d", getprop("/it-autoflight/internal/alt")), 3));
		
		# QNH
		if (getprop("/modes/altimeter/std") == 1) {
			if (getprop("/modes/altimeter/inhg") == 0) {
				me["QNH"].setText("1013");
			} else if (getprop("/modes/altimeter/inhg") == 1) {
				me["QNH"].setText("29.92");
			}
		} else if (getprop("/modes/altimeter/inhg") == 0) {
			me["QNH"].setText(sprintf("%4.0f", getprop("/instrumentation/altimeter/setting-hpa")));
		} else if (getprop("/modes/altimeter/inhg") == 1) {
			me["QNH"].setText(sprintf("%2.2f", getprop("/instrumentation/altimeter/setting-inhg")));
		}
		
		# Slats/Flaps
		if (getprop("/controls/flight/slats") > 0 and getprop("/controls/flight/flap-txt") == 0) {
			me["Slats"].show();
		} else {
			me["Slats"].hide();
		}
		
		if (getprop("/controls/flight/flap-txt") > 0) {
			me["Flaps"].show();
			me["Flaps_num"].show();
			me["Flaps_num"].setText(sprintf("%2.0f", getprop("/controls/flight/flap-txt")));
		} else {
			me["Flaps"].hide();
			me["Flaps_num"].hide();
		}
		
		# Misc
		me["TCAS_OFF"].hide();
	},
	updateCommonFast: func() {
		# Airspeed
		me["ASI_v_speed"].hide();
		
		if (getprop("/instrumentation/airspeed-indicator/indicated-speed-kt") >= 50) {
			me["ASI_GroundSpd"].hide();
			me["ASI_Taxi"].hide();
			me["ASI_bowtie"].show();
			me["ASI_scale"].show();
			me["ASI_presel"].show();
			me["ASI_sel"].show();
		} else {
			me["ASI_GroundSpd"].setText(sprintf("%3.0f", getprop("/velocities/groundspeed-kt")));
			me["ASI_GroundSpd"].show();
			me["ASI_Taxi"].show();
			me["ASI_bowtie"].hide();
			me["ASI_scale"].hide();
			me["ASI_presel"].hide();
			me["ASI_sel"].hide();
		}
		
		# Subtract 50, since the scale starts at 50, but don"t allow less than 0, or more than 500 situations
		if (getprop("/instrumentation/airspeed-indicator/indicated-speed-kt") <= 50) {
			ASI = 0;
		} else if (getprop("/instrumentation/airspeed-indicator/indicated-speed-kt") >= 500) {
			ASI = 450;
		} else {
			ASI = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt") - 50;
		}
		
		me["ASI_scale"].setTranslation(0, ASI * 4.48656);
		me["ASI"].setText(sprintf("%3.0f", getprop("/instrumentation/airspeed-indicator/indicated-speed-kt")));
		
		if (getprop("/instrumentation/airspeed-indicator/indicated-mach") >= 0.5) {
			me["ASI_bowtie_mach"].show();
		} else {
			me["ASI_bowtie_mach"].hide();
		}
		
		if (getprop("/instrumentation/airspeed-indicator/indicated-mach") >= 0.999) {
			me["ASI_mach"].setText("999");
		} else {
			me["ASI_mach"].setText(sprintf("%3.0f", getprop("/instrumentation/airspeed-indicator/indicated-mach") * 1000));
		}
		
		if (getprop("/it-autoflight/internal/ias-presel") <= 50) {
			ASIpresel = 0 - ASI;
		} else if (getprop("/it-autoflight/internal/ias-presel") >= 500) {
			ASIpresel = 450 - ASI;
		} else {
			ASIpresel = getprop("/it-autoflight/internal/ias-presel") - 50 - ASI;
		}
		
		me["ASI_presel"].setTranslation(0, ASIpresel * -4.48656);
		
		if (getprop("/it-autoflight/internal/ias-sel") <= 50) {
			ASIsel = 0 - ASI;
		} else if (getprop("/it-autoflight/internal/ias-sel") >= 500) {
			ASIsel = 450 - ASI;
		} else {
			ASIsel = getprop("/it-autoflight/internal/ias-sel") - 50 - ASI;
		}
		
		me["ASI_sel"].setTranslation(0, ASIsel * -4.48656);
		
		ASItrend = getprop("/instrumentation/pfd/speed-lookahead") - ASI;
		me["ASI_trend_up"].setTranslation(0, math.clamp(ASItrend, 0, 60) * -4.48656);
		me["ASI_trend_down"].setTranslation(0, math.clamp(ASItrend, -60, 0) * -4.48656);
		
		if (ASItrend >= 2) {
			me["ASI_trend_up"].show();
			me["ASI_trend_down"].hide();
		} else if (ASItrend <= -2) {
			me["ASI_trend_down"].show();
			me["ASI_trend_up"].hide();
		} else {
			me["ASI_trend_up"].hide();
			me["ASI_trend_down"].hide();
		}
		
		# Attitude
		pitch = getprop("/orientation/pitch-deg") or 0;
		roll =  getprop("/orientation/roll-deg") or 0;
		alpha =  getprop("/fdm/jsbsim/aero/alpha-deg-damped") or 0;
		
		me.AI_horizon_trans.setTranslation(0, pitch * 10.246);
		me.AI_horizon_rot.setRotation(-roll * D2R, me["AI_center"].getCenter());
		
		me["AI_fpv"].setTranslation(math.clamp(getprop("/instrumentation/pfd/track-hdg-diff"), -20, 20) * 10.246, math.clamp(alpha, -20, 20) * 10.246);
		if (getprop("/it-autoflight/custom/vs-fpa") == 1) {
			me["AI_fpv"].show();
		} else {
			me["AI_fpv"].hide();
		}
		
		me["AI_arrow"].setRotation(math.clamp(-roll, -45, 45) * D2R);
		if (pitch > 25) {
			me["AI_arrow"].show();
		} else {
			me["AI_arrow"].hide();
		}
		
		me["AI_alphalim"].setTranslation(0, math.clamp(16 - alpha, -20, 20) * -10.246);
		if (alpha >= 15.5) {
			me["AI_alphalim"].setColor(1,0,0);
		} else {
			me["AI_alphalim"].setColor(0.2156,0.5019,0.6627);
		}
		
		if (getprop("/it-autoflight/fd/roll-bar") != nil) {
			me["FD_roll"].setTranslation((getprop("/it-autoflight/fd/roll-bar")) * 2.2, 0);
		}
		if (getprop("/it-autoflight/fd/pitch-bar") != nil) {
			me["FD_pitch"].setTranslation(0, -(getprop("/it-autoflight/fd/pitch-bar")) * 3.8);
		}
		
		me["AI_slipskid"].setTranslation(math.clamp(getprop("/instrumentation/slip-skid-ball/indicated-slip-skid"), -7, 7) * -15, 0);
		me["AI_bank"].setRotation(-roll * D2R);
		
		me["AI_banklimit_L"].setRotation(getprop("/instrumentation/pfd/bank-limit") * -D2R);
		me["AI_banklimit_R"].setRotation(getprop("/instrumentation/pfd/bank-limit") * D2R);
		
		# Altitude
		me.altitude = getprop("/instrumentation/altimeter/indicated-altitude-ft");
		me.altOffset = me.altitude / 500 - int(me.altitude / 500);
		me.middleAltText = roundaboutAlt(me.altitude / 100) * 100;
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
		
		if (getprop("/instrumentation/altimeter/indicated-altitude-ft") < 0) {
			altPolarity = "-";
		} else {
			altPolarity = "";
		}
		me["ALT_thousands"].setText(sprintf("%s%d", altPolarity, math.abs(int(getprop("/instrumentation/altimeter/indicated-altitude-ft") / 1000))));
		me["ALT_hundreds"].setText(sprintf("%d", math.floor(num(right(sprintf("%03d", abs(getprop("/instrumentation/altimeter/indicated-altitude-ft"))), 3)) / 100)));
		altTens = num(right(sprintf("%02d", getprop("/instrumentation/altimeter/indicated-altitude-ft")), 2));
		me["ALT_tens"].setTranslation(0, altTens * 2.1325);
		
		me["ALT_presel"].setTranslation(0, (getprop("/instrumentation/pfd/alt-presel") / 100) * -50.9016);
		me["ALT_sel"].setTranslation(0, (getprop("/instrumentation/pfd/alt-sel") / 100) * -50.9016);
		
		# Vertical Speed
		if (getprop("/it-autoflight/internal/vert-speed-fpm") <= -75) {
			me["VSI_needle_up"].hide();
		} else {
			me["VSI_needle_up"].show();
		}
		if (getprop("/it-autoflight/internal/vert-speed-fpm") >= 75) {
			me["VSI_needle_dn"].hide();
		} else {
			me["VSI_needle_dn"].show();
		}
		
		if (getprop("/it-autoflight/internal/vert-speed-fpm") > 10 and getprop("/it-autoflight/internal/vert-speed-fpm-pfd") > 0) {
			me["VSI_up"].show();
		} else {
			me["VSI_up"].hide();
		}
		if (getprop("/it-autoflight/internal/vert-speed-fpm") < -10 and getprop("/it-autoflight/internal/vert-speed-fpm-pfd") > 0) {
			me["VSI_down"].show();
		} else {
			me["VSI_down"].hide();
		}
		
		me["VSI_up"].setText(sprintf("%1.1f", getprop("/it-autoflight/internal/vert-speed-fpm-pfd")));
		me["VSI_down"].setText(sprintf("%1.1f", getprop("/it-autoflight/internal/vert-speed-fpm-pfd")));
		me["VSI_needle_up"].setTranslation(0, getprop("/instrumentation/pfd/vs-needle-up"));
		me["VSI_needle_dn"].setTranslation(0, getprop("/instrumentation/pfd/vs-needle-dn"));
		
		# Heading
		HDGraw = getprop("/instrumentation/pfd/heading-scale") + 0.5;
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
		me["HDG_dial"].setRotation(getprop("/instrumentation/pfd/heading-scale") * -D2R);
		
		if (getprop("/it-autoflight/custom/show-hdg") == 1) {
			me["HDG_presel"].show();
		} else {
			me["HDG_presel"].hide();
		}
		if (getprop("/it-autoflight/custom/show-hdg") == 1 and getprop("/it-autoflight/output/lat") == 0) {
			me["HDG_sel"].show();
		} else {
			me["HDG_sel"].hide();
		}
		
		if (getprop("/instrumentation/pfd/hdg-pre-diff") <= 35 and getprop("/instrumentation/pfd/hdg-pre-diff") >= -35) {
			HDGpresel = getprop("/instrumentation/pfd/hdg-pre-diff");
		} else if (getprop("/instrumentation/pfd/hdg-pre-diff") > 35) {
			HDGpresel = 35;
		} else if (getprop("/instrumentation/pfd/hdg-pre-diff") < -35) {
			HDGpresel = -35;
		}
		me["HDG_presel"].setRotation(HDGpresel * D2R);
		
		if (getprop("/instrumentation/pfd/hdg-diff") <= 35 and getprop("/instrumentation/pfd/hdg-diff") >= -35) {
			HDGsel = getprop("/instrumentation/pfd/hdg-diff");
		} else if (getprop("/instrumentation/pfd/hdg-diff") > 35) {
			HDGsel = 35;
		} else if (getprop("/instrumentation/pfd/hdg-diff") < -35) {
			HDGsel = -35;
		}
		me["HDG_sel"].setRotation(HDGsel * D2R);
		
		me["TRK_pointer"].setRotation(getprop("/instrumentation/pfd/track-hdg-diff") * D2R);
		
		# ILS
		LOC = getprop("/instrumentation/nav[0]/heading-needle-deflection-norm") or 0;
		GS = getprop("/instrumentation/nav[0]/gs-needle-deflection-norm") or 0;
		me["LOC_pointer"].setTranslation(LOC * 200, 0);
		me["GS_pointer"].setTranslation(0, GS * -204);
		
		if (getprop("/instrumentation/nav[0]/in-range") == 1) {
			me["LOC_scale"].show();
			if (getprop("/instrumentation/nav[0]/nav-loc") == 1 and getprop("/instrumentation/nav[0]/signal-quality-norm") > 0.99) {
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
		if (getprop("/instrumentation/nav[0]/gs-in-range") == 1) {
			me["GS_scale"].show();
			if (getprop("/instrumentation/nav[0]/has-gs") == 1 and getprop("/instrumentation/nav[0]/signal-quality-norm") > 0.99) {
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
		if (getprop("/position/gear-agl-ft") <= 2500) {
			me["RA"].setText(sprintf("%4.0f", getprop("/position/gear-agl-ft")));
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
		fd1 = getprop("/it-autoflight/output/fd1");
		fd2 = getprop("/it-autoflight/output/fd2");
		
		if (fd1 == 1) {
			me["FD_roll"].show();
		} else {
			me["FD_roll"].hide();
		}
		
		if (fd1 == 1) {
			me["FD_pitch"].show();
		} else {
			me["FD_pitch"].hide();
		}
		
		if (getprop("/instrumentation/irs/ir[0]/aligned") == 1) {
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
		fd1 = getprop("/it-autoflight/output/fd1");
		fd2 = getprop("/it-autoflight/output/fd2");
		
		if (fd2 == 1) {
			me["FD_roll"].show();
		} else {
			me["FD_roll"].hide();
		}
		
		if (fd2 == 1) {
			me["FD_pitch"].show();
		} else {
			me["FD_pitch"].hide();
		}
		
		if (getprop("/instrumentation/irs/ir[1]/aligned") == 1) {
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
		me["ERRCODE"].setText(getprop("/systems/acconfig/mismatch-code"));
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
		me["ERRCODE"].setText(getprop("/systems/acconfig/mismatch-code"));
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
	if (getprop("/systems/acconfig/options/pfd-rate") > 1) {
		rateApply();
	}
});

var rateApply = func {
	PFD_update.restart(0.15 * getprop("/systems/acconfig/options/pfd-rate"));
	PFD_update_fast.restart(0.05 * getprop("/systems/acconfig/options/pfd-rate"));
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
