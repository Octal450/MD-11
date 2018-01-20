# MD-11 PFD
# Joshua Davidson (it0uchpods)

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

var PFD_1 = nil;
var PFD_2 = nil;
var PFD1_display = nil;
var PFD2_display = nil;
var wow1 = getprop("/gear/gear[1]/wow");
var wow2 = getprop("/gear/gear[2]/wow");
var pitch = 0;
var roll = 0;
var HDG = "000";
var HDGBug = 0;
var throttle_mode = getprop("/it-autoflight/mode/thr");
var roll_mode = getprop("/modes/pfd/fma/roll-mode");
var roll_mode_armed = getprop("/modes/pfd/fma/roll-mode-armed");
var pitch_mode = getprop("/modes/pfd/fma/pitch-mode");
var pitch_mode_armed = getprop("/modes/pfd/fma/pitch-mode-armed");
setprop("/instrumentation/pfd/hdg-diff", 0);
setprop("/instrumentation/pfd/heading-scale", 0);
setprop("/instrumentation/pfd/track-deg", 0);
setprop("/instrumentation/pfd/vs-needle-up", 0);
setprop("/instrumentation/pfd/vs-needle-dn", 0);

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
		
		me.page = canvas_group;
		
		return me;
	},
	getKeys: func() {
		return ["FMA_Speed","FMA_Thrust","FMA_Roll","FMA_Roll_Arm","FMA_Pitch","FMA_Pitch_Arm","FMA_Altitude_Thousand","FMA_Altitude","FMA_ATS_Thrust_Off","FMA_ATS_Pitch_Off","FMA_AP_Pitch_Off_Box","FMA_AP_Thrust_Off_Box","FMA_AP","ASI_v_speed","ASI_Taxi",
		"ASI_GroundSpd","FD_roll","FD_pitch","VSI_needle_up","VSI_needle_dn","HDG","HDG_dial","HDG_Bug","TCAS_OFF","Slats","Flaps","Flaps_num","QNH"];
	},
	update: func() {
		if (getprop("/options/test-canvas") == 1) {
			PFD_1.update();
		}
	},
	updateCommon: func () {
		throttle_mode = getprop("/it-autoflight/mode/thr");
		roll_mode = getprop("/modes/pfd/fma/roll-mode");
		roll_mode_armed = getprop("/modes/pfd/fma/roll-mode-armed");
		pitch_mode = getprop("/modes/pfd/fma/pitch-mode");
		pitch_mode_armed = getprop("/modes/pfd/fma/pitch-mode-armed");
		
		# FMA
		if (getprop("/it-autoflight/output/athr") == 1) {
			me["FMA_ATS_Pitch_Off"].hide();
			me["FMA_ATS_Thrust_Off"].hide();
		} else if (throttle_mode == "PITCH") {
			me["FMA_ATS_Pitch_Off"].show();
			me["FMA_ATS_Thrust_Off"].hide();
		} else {
			me["FMA_ATS_Pitch_Off"].hide();
			me["FMA_ATS_Thrust_Off"].show();
		}
		
		if (getprop("/it-autoflight/output/ap1") == 1 or getprop("/it-autoflight/output/ap2") == 1) {
			me["FMA_AP"].setColor(0.3215,0.8078,1);
			me["FMA_AP"].setText(sprintf("%s", getprop("/modes/pfd/fma/ap-mode")));
			me["FMA_AP_Pitch_Off_Box"].hide();
			me["FMA_AP_Thrust_Off_Box"].hide();
		} else if (throttle_mode == "PITCH") {
			me["FMA_AP"].setColor(1,1,1);
			me["FMA_AP"].setText("AP OFF");
			me["FMA_AP_Pitch_Off_Box"].show();
			me["FMA_AP_Thrust_Off_Box"].hide();
		} else {
			me["FMA_AP"].setColor(1,1,1);
			me["FMA_AP"].setText("AP OFF");
			me["FMA_AP_Pitch_Off_Box"].hide();
			me["FMA_AP_Thrust_Off_Box"].show();
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
		
		# Airspeed
		me["ASI_v_speed"].hide();
		
		if (getprop("/instrumentation/airspeed-indicator/indicated-speed-kt") >= 60) {
			me["ASI_GroundSpd"].hide();
			me["ASI_Taxi"].hide();
		} else {
			me["ASI_GroundSpd"].setText(sprintf("%3.0f", getprop("/velocities/groundspeed-kt")));
			me["ASI_GroundSpd"].show();
			me["ASI_Taxi"].show();
		}
		
		# Attitude
		if (getprop("/it-autoflight/fd/roll-bar") != nil) {
			me["FD_roll"].setTranslation((getprop("/it-autoflight/fd/roll-bar")) * 2.2, 0);
		}
		if (getprop("/it-autoflight/fd/pitch-bar") != nil) {
			me["FD_pitch"].setTranslation(0, -(getprop("/it-autoflight/fd/pitch-bar")) * 3.8);
		}
		
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
		
		me["VSI_needle_up"].setTranslation(0, getprop("/instrumentation/pfd/vs-needle-up"));
		me["VSI_needle_dn"].setTranslation(0, getprop("/instrumentation/pfd/vs-needle-dn"));
		
		# Heading
		HDG = sprintf("%03d", getprop("/instrumentation/pfd/heading-scale"));
		if (HDG == "360") {
			HDG == "000";
		}
		me["HDG"].setText(HDG);
		me["HDG_dial"].setRotation(getprop("/instrumentation/pfd/heading-scale") * -D2R);
		
		if (getprop("/it-autoflight/output/lat") == 0) {
			me["HDG_Bug"].show();
		} else {
			me["HDG_Bug"].hide();
		}
		
		if (getprop("/instrumentation/pfd/hdg-diff") <= 35 and getprop("/instrumentation/pfd/hdg-diff") >= -35) {
			HDGBug = getprop("/instrumentation/pfd/hdg-diff");
		} else if (getprop("/instrumentation/pfd/hdg-diff") > 35) {
			HDGBug = 35;
		} else if (getprop("/instrumentation/pfd/hdg-diff") < -35) {
			HDGBug = -35;
		}
		me["HDG_Bug"].setRotation(HDGBug * D2R);
		
		# QNH
		if (getprop("/modes/altimeter/std") == 1) {
			me["QNH"].setText("29.92");
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
		
		me.updateCommon();
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
		
		me.updateCommon();
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
#	PFD1_display.addPlacement({"node": "pfd1.screen"});
#	PFD2_display.addPlacement({"node": "pfd2.screen"});
	var group_pfd1 = PFD1_display.createGroup();
	var group_pfd2 = PFD2_display.createGroup();

	PFD_1 = canvas_PFD_1.new(group_pfd1, "Aircraft/IDG-MD-11X/Models/cockpit/instruments/PFD-WIP/res/pfd.svg");
	PFD_2 = canvas_PFD_2.new(group_pfd2, "Aircraft/IDG-MD-11X/Models/cockpit/instruments/PFD-WIP/res/pfd.svg");
	
	PFD_update.start();
});

var PFD_update = maketimer(0.05, func {
	canvas_PFD_base.update();
});

var showPFD1 = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(PFD1_display);
}

#var showPFD2 = func {
#	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
#	dlg.setCanvas(PFD2_display);
#}

var roundabout = func(x) {
	var y = x - int(x);
	return y < 0.5 ? int(x) : 1 + int(x);
};

var roundaboutAlt = func(x) {
	var y = x * 0.2 - int(x * 0.2);
	return y < 0.5 ? 5 * int(x * 0.2) : 5 + 5 * int(x * 0.2);
};
