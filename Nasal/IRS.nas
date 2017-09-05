# MD11 irs system
# Jonathan Redpath

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

#####################
# Initializing Vars #
#####################

setprop("/systems/electrical/bus/ac1", 0);
setprop("/systems/electrical/bus/l-emer-ac", 0);
setprop("/systems/electrical/bus/r-emer-ac", 0);
var ttn = 0;
var knob = 0;

# aux is [2]

# TODO:
# fast alignment
# off nav light


setlistener("/sim/signals/fdm-initialized", func {
	var gs = getprop("/velocities/groundspeed-kt");
});

var irs_init = func {
	setprop("/controls/irs/numm", 0);
	setprop("/instrumentation/irs/ir[0]/aligned",0); # is aligned
	setprop("/instrumentation/irs/ir[1]/aligned",0);
	setprop("/instrumentation/irs/ir[2]/aligned",0);
	setprop("/instrumentation/irs/ir[0]/ttn",0);
	setprop("/instrumentation/irs/ir[1]/ttn",0);
	setprop("/instrumentation/irs/ir[2]/ttn",0);
	setprop("/controls/irs/ir[0]/align",0); # is aligning
	setprop("/controls/irs/ir[1]/align",0);
	setprop("/controls/irs/ir[2]/align",0);
	setprop("/controls/irs/ir[0]/knob", 0);
	setprop("/controls/irs/ir[1]/knob", 0);
	setprop("/controls/irs/ir[2]/knob", 0);
	setprop("/controls/irs/ir[0]/navofflt",0);
	setprop("/controls/irs/ir[1]/navofflt",0);
	setprop("/controls/irs/ir[2]/navofflt",0);
	setprop("/controls/irs/mcducbtn",0);
	setprop("/controls/irs/mcdu/mode1", ""); # INVAL ALIGN NAV ATT or off (blank)
	setprop("/controls/irs/mcdu/mode2", "");
	setprop("/controls/irs/mcdu/mode3", "");
	setprop("/controls/irs/mcdu/status1", ""); # see smith thales p487
	setprop("/controls/irs/mcdu/status2", "");
	setprop("/controls/irs/mcdu/status3", "");
	setprop("/controls/irs/mcdu/hdg", ""); # only shown if in ATT mode
	setprop("/controls/irs/mcdu/avgdrift1", "");
	setprop("/controls/irs/mcdu/avgdrift2", "");
	setprop("/controls/irs/mcdu/avgdrift3", "");
}

var ir_align_loop = func(i) {
	ttn = getprop("/instrumentation/irs/ir[" ~ i ~ "]/ttn");
	if ((ttn >= 0) and (ttn < 0.99)) { # Make it less sensitive
		ir_align_finish(i);
	} else {
		setprop("/instrumentation/irs/ir[" ~ i ~ "]/ttn", ttn - 1);
	}
	gs = getprop("/velocities/groundspeed-kt");
	if (gs > 2) {
		ir_align_abort(i);
	}

}

var ir0_align_loop_timer = maketimer(1, func{ir_align_loop(0)});
var ir1_align_loop_timer = maketimer(1, func{ir_align_loop(1)});
var ir2_align_loop_timer = maketimer(1, func{ir_align_loop(2)});

var ir_align_start = func(i) {
	if (((i == 0) and !ir0_align_loop_timer.isRunning) or
			((i == 1) and !ir1_align_loop_timer.isRunning) or
			((i == 2) and !ir2_align_loop_timer.isRunning)) {
		setprop("/instrumentation/irs/ir[" ~ i ~ "]/ttn", 600); # 10 minutes
		# todo: fast alignment
		if (i == 0) {
			ir0_align_loop_timer.start();
		} else if (i == 1) {
			ir1_align_loop_timer.start();
		} else if (i == 2) {
			ir2_align_loop_timer.start();
		}
		setprop("/controls/irs/ir[" ~ i ~ "]/align", 1);
	}
}

var ir_align_finish = func(i) {
	setprop("/instrumentation/irs/ir[" ~ i ~ "]/aligned", 1);
	if (i == 0) {
		ir0_align_loop_timer.stop();
	} else if (i == 1) {
		ir1_align_loop_timer.stop();
	} else if (i == 2) {
		ir2_align_loop_timer.stop();
	}
	setprop("/controls/irs/ir[" ~ i ~ "]/align", 0);
}

var ir_align_abort = func(i) {
	setprop("/controls/irs/ir[" ~ i ~ "]/fault", 1);
	if (i == 0) {
		ir0_align_loop_timer.stop();
	} else if (i == 1) {
		ir1_align_loop_timer.stop();
	} else if (i == 2) {
		ir2_align_loop_timer.stop();
	}
	setprop("/controls/irs/ir[" ~ i ~ "]/align", 0);
}

var ir_knob_move = func(i) {
	knob = getprop("/controls/irs/ir[" ~ i ~ "]/knob");
	if (knob == 1) {
		setprop("/controls/irs/ir[" ~ i ~ "]/align", 0);
		setprop("/controls/irs/ir[" ~ i ~ "]/fault", 0);
		setprop("/instrumentation/irs/ir[" ~ i ~ "]/aligned", 0);
		if (i == 0) {
			ir0_align_loop_timer.stop();
		} else if (i == 1) {
			ir1_align_loop_timer.stop();
		} else if (i == 2) {
			ir2_align_loop_timer.stop();
		}
	} else if (knob == 2) {
		# if ( !getprop("/instrumentation/irs/ir[" ~ i ~ "]/aligned") and
				# (getprop("/systems/electrical/bus/ac1") > 110) ) {
		if (!getprop("/instrumentation/irs/ir[" ~ i ~ "]/aligned")) {
			ir_align_start(i);
		}
	}
}

setlistener("/controls/irs/ir[0]/knob", func {
	ir_knob_move(0);
	knobmcducheck();
});
setlistener("/controls/irs/ir[1]/knob", func {
	ir_knob_move(1);
	knobmcducheck();
});
setlistener("/controls/irs/ir[2]/knob", func {
	ir_knob_move(2);
	knobmcducheck();
});

var knobmcducheck = func {
	if (getprop("/controls/irs/ir[0]/knob") == 1 and getprop("/controls/irs/ir[1]/knob") == 1 and getprop("/controls/irs/ir[2]/knob") == 1) {
		setprop("/controls/irs/mcducbtn", 0);
	}
}

var skip_irs = func {
	if (getprop("/controls/irs/ir[0]/knob") == 2) {
		setprop("/instrumentation/irs/ir[0]/display/ttn",1); # Set it to 1 so it counts down from 1 to 0
	}
	if (getprop("/controls/irs/ir[1]/knob") == 2) {
		setprop("/instrumentation/irs/ir[1]/display/ttn",1);
	}
	if (getprop("/controls/irs/ir[2]/knob") == 2) {
		setprop("/instrumentation/irs/ir[2]/display/ttn",1);
	}
}

var fast_irs = func {
	if (getprop("/controls/irs/ir[0]/knob") == 2) {
		setprop("/instrumentation/irs/ir[0]/display/ttn", 180); # this is the fast alignment, NOT a "cheat"
	}
	if (getprop("/controls/irs/ir[1]/knob") == 2) {
		setprop("/instrumentation/irs/ir[1]/display/ttn", 180); 
	}
	if (getprop("/controls/irs/ir[2]/knob") == 2) {
		setprop("/instrumentation/irs/ir[2]/display/ttn", 180);
	}
}

var irs_skip = setlistener("/controls/irs/skip", func {
	if (getprop("/controls/irs/skip") == 1) {
		skip_irs();
	}
});
