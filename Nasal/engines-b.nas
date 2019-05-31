# MD-11 JSB Engine System

# Copyright (c) 2019 Joshua Davidson (Octal450)

var engines = props.globals.getNode("/engines").getChildren("engine");
if (getprop("/options/eng") == "PW") {
	var egt_min = 323;
} else {
	var egt_min = 342;
}
var egt_start = 421;
var egt_max = 562;
var start_time = 10;
var egt_lightup_time = 4;
var egt_lightdn_time = 10;
var shutdown_time = 20;
var egt_shutdown_time = 20;
var IGN1 = 0;
var IGN2 = 0;
var IGN3 = 0;
var IGNTOGA = 0;
var thr1 = 0;
var thr2 = 0;
var state1 = 0;
var state2 = 0;
var state3 = 0;
var wow0 = 1;
setprop("/controls/engines/packs-off", 0);
setprop("/controls/engines/ign-packs", 0);
setprop("/controls/engines/ign-packs-time", -1000);

var eng_init = func {
	setprop("/controls/engines/ign-a", 0);
	setprop("/controls/engines/ign-b", 0);
	setprop("/controls/engines/ign-a-enabled", 0);
	setprop("/controls/engines/ign-b-enabled", 0);
	setprop("/controls/engines/ign-ovrd", 0);
	setprop("/controls/engines/ignition-1", 0);
	setprop("/controls/engines/ignition-2", 0);
	setprop("/controls/engines/ignition-3", 0);
	setprop("/controls/engines/engine[0]/start-switch", 0);
	setprop("/controls/engines/engine[1]/start-switch", 0);
	setprop("/controls/engines/engine[2]/start-switch", 0);
}

var eng_loop = func {
	thr1 = getprop("/controls/engines/engine[0]/throttle");
	thr2 = getprop("/controls/engines/engine[1]/throttle");
	state1 = getprop("/engines/engine[0]/state");
	state2 = getprop("/engines/engine[1]/state");
	state3 = getprop("/engines/engine[2]/state");
	wow0 = getprop("/gear/gear[0]/wow");
	
	if (getprop("/systems/electrical/bus/l-emer-ac") >= 110 and getprop("/controls/engines/ign-a") == 1) {
		IGN1 = 1;
		IGN2 = 1;
		IGN3 = 1;
		if (getprop("/controls/engines/ign-a-enabled") != 1) {
			setprop("/controls/engines/ign-a-enabled", 1);
		}
		if (getprop("/controls/engines/ign-b-enabled") != 0) {
			setprop("/controls/engines/ign-b-enabled", 0);
		}
	} else if (getprop("/systems/electrical/bus/r-emer-ac") >= 110 and getprop("/controls/engines/ign-b") == 1) {
		IGN1 = 1;
		IGN2 = 1;
		IGN3 = 1;
		if (getprop("/controls/engines/ign-a-enabled") != 0) {
			setprop("/controls/engines/ign-a-enabled", 0);
		}
		if (getprop("/controls/engines/ign-b-enabled") != 1) {
			setprop("/controls/engines/ign-b-enabled", 1);
		}
	} else {
		IGN1 = 0;
		IGN2 = 0;
		IGN3 = 0;
		if (getprop("/controls/engines/ign-a-enabled") != 0) {
			setprop("/controls/engines/ign-a-enabled", 0);
		}
		if (getprop("/controls/engines/ign-b-enabled") != 0) {
			setprop("/controls/engines/ign-b-enabled", 0);
		}
	}
	
	if ((getprop("/controls/engines/thrust-limit") == "T/O" or getprop("/controls/engines/thrust-limit") == "G/A") and (thr1 >= 0.7 or thr2 >= 0.7)) {
		IGNTOGA = 1;
	} else {
		IGNTOGA = 0;
	}
	
	if (getprop("/controls/engines/ign-packs") != 1 and (getprop("/controls/engines/ign-a") == 1 or getprop("/controls/engines/ign-b") == 1) and (state1 != 3 or state2 != 3 or state3 != 3) and wow0 == 1) {
		setprop("/controls/engines/ign-packs", 1);
		setprop("/controls/engines/ign-packs-time", getprop("/sim/time/elapsed-sec"));
	} else if (getprop("/controls/engines/ign-packs") != 0 and getprop("/controls/engines/ign-a") == 0 and getprop("/controls/engines/ign-b") == 0) {
		setprop("/controls/engines/ign-packs", 0);
		setprop("/controls/engines/ign-packs-time", -1000)
	}
	
	if (getprop("/controls/engines/ign-packs-time") + 120 >= getprop("/sim/time/elapsed-sec") and (state1 != 3 or state2 != 3 or state3 != 3) and wow0 == 1) {
		setprop("/controls/engines/packs-off", 1);
	} else if (IGNTOGA == 1) {
		setprop("/controls/engines/packs-off", 1);
	} else if (state1 != 1 and state2 != 1 and state3 != 1 and state1 != 2 and state2 != 2 and state3 != 2) {
		setprop("/controls/engines/packs-off", 0);
	}
	
	if ((getprop("/controls/engines/ign-ovrd") == 1 or state1 == 1 or (state1 == 2 and getprop("/engines/engine[0]/n2-actual") < 43.0) or IGNTOGA == 1) and IGN1 == 1) {
		setprop("/controls/engines/ignition-1", 1);
	} else {
		setprop("/controls/engines/ignition-1", 0);
	}
	
	if ((getprop("/controls/engines/ign-ovrd") == 1 or state2 == 1 or (state2 == 2 and getprop("/engines/engine[1]/n2-actual") < 43.0) or IGNTOGA == 1) and IGN2 == 1) {
		setprop("/controls/engines/ignition-2", 1);
	} else {
		setprop("/controls/engines/ignition-2", 0);
	}
	
	if ((getprop("/controls/engines/ign-ovrd") == 1 or state3 == 1 or (state3 == 2 and getprop("/engines/engine[2]/n2-actual") < 43.0) or IGNTOGA == 1) and IGN3 == 1) {
		setprop("/controls/engines/ignition-3", 1);
	} else {
		setprop("/controls/engines/ignition-3", 0);
	}
}

# Trigger Startups and Stops
setlistener("/controls/engines/engine[0]/start-switch", func {
	if (getprop("/controls/engines/engine[0]/start-switch") == 1 and getprop("/engines/engine[0]/state") == 0) {
		if (getprop("/systems/acconfig/autoconfig-running") != 1) {
			start_one_check();
		}
	} else if (getprop("/engines/engine[0]/state") == 1 or (getprop("/engines/engine[0]/state") == 2 and getprop("/engines/engine[0]/n2-actual") < 42.0)) {
		cutoff_one();
	} else {
		setprop("/controls/engines/engine[0]/start-switch", 0);
	}
});

setlistener("/controls/engines/engine[0]/cutoff-switch", func {
	if (getprop("/controls/engines/engine[0]/cutoff-switch") == 1) {
		cutoff_one();
	}
});

var cutoff_one = func {
	eng_one_auto_start.stop();
	eng_one_n2_check.stop();
	setprop("/controls/engines/engine[0]/starter", 0);
	setprop("/controls/engines/engine[0]/cutoff", 1);
	setprop("/controls/engines/engine[0]/start-switch", 0);
	setprop("/engines/engine[0]/state", 0);
	interpolate(engines[0].getNode("egt-actual"), 0, egt_shutdown_time);
	eng_one_n2_check.stop();
}

var fast_start_one = func {
	setprop("/controls/engines/engine[0]/cutoff-switch", 0);
	setprop("/controls/engines/engine[0]/cutoff", 0);
	setprop("/engines/engine[0]/out-of-fuel", 0);
	setprop("/engines/engine[0]/run", 1);

	setprop("/engines/engine[0]/cutoff", 0);
	setprop("/engines/engine[0]/starter", 0);

	setprop("/fdm/jsbsim/propulsion/set-running", 0);
	
	setprop("/engines/engine[0]/state", 3);
}

var start_one_check = func {
	if (getprop("/controls/engines/packs-off") != 1) {
		setprop("/controls/engines/ign-packs-time", getprop("/sim/time/elapsed-sec"));
		settimer(start_one_check, 1);
	} else {
		if (IGN1 == 1 and getprop("/controls/engines/engine[0]/start-switch") == 1 and getprop("/systems/pneumatics/total-psi") >= 28) {
			auto_start_one();
		} else {
			setprop("/controls/engines/engine[0]/start-switch", 0);
		}
	}
}

setlistener("/controls/engines/engine[1]/start-switch", func {
	if (getprop("/controls/engines/engine[1]/start-switch") == 1 and getprop("/engines/engine[1]/state") == 0) {
		if (getprop("/systems/acconfig/autoconfig-running") != 1) {
			start_two_check();
		}
	} else if (getprop("/engines/engine[1]/state") == 1 or (getprop("/engines/engine[1]/state") == 2 and getprop("/engines/engine[1]/n2-actual") < 42.0)) {
		cutoff_two();
	} else {
		setprop("/controls/engines/engine[1]/start-switch", 0);
	}
});

setlistener("/controls/engines/engine[1]/cutoff-switch", func {
	if (getprop("/controls/engines/engine[1]/cutoff-switch") == 1) {
		cutoff_two();
	}
});

var cutoff_two = func {
	eng_two_auto_start.stop();
	eng_two_n2_check.stop();
	setprop("/controls/engines/engine[1]/starter", 0);
	setprop("/controls/engines/engine[1]/cutoff", 1);
	setprop("/controls/engines/engine[1]/start-switch", 0);
	setprop("/engines/engine[1]/state", 0);
	interpolate(engines[1].getNode("egt-actual"), 0, egt_shutdown_time);
	eng_two_n2_check.stop();
}

var fast_start_two = func {
	setprop("/controls/engines/engine[1]/cutoff-switch", 0);
	setprop("/controls/engines/engine[1]/cutoff", 0);
	setprop("/engines/engine[1]/out-of-fuel", 0);
	setprop("/engines/engine[1]/run", 1);

	setprop("/engines/engine[1]/cutoff", 0);
	setprop("/engines/engine[1]/starter", 0);

	setprop("/fdm/jsbsim/propulsion/set-running", 1);
	
	setprop("/engines/engine[1]/state", 3);
}

var start_two_check = func {
	if (getprop("/controls/engines/packs-off") != 1) {
		setprop("/controls/engines/ign-packs-time", getprop("/sim/time/elapsed-sec"));
		settimer(start_two_check, 1);
	} else {
		if (IGN1 == 1 and getprop("/controls/engines/engine[1]/start-switch") == 1 and getprop("/systems/pneumatics/total-psi") >= 28) {
			auto_start_two();
		} else {
			setprop("/controls/engines/engine[1]/start-switch", 0);
		}
	}
}

setlistener("/controls/engines/engine[2]/start-switch", func {
	if (getprop("/controls/engines/engine[2]/start-switch") == 1 and getprop("/engines/engine[2]/state") == 0) {
		if (getprop("/systems/acconfig/autoconfig-running") != 1) {
			start_three_check();
		}
	} else if (getprop("/engines/engine[2]/state") == 1 or (getprop("/engines/engine[2]/state") == 2 and getprop("/engines/engine[2]/n2-actual") < 42.0)) {
		cutoff_three();
	} else {
		setprop("/controls/engines/engine[2]/start-switch", 0);
	}
});

setlistener("/controls/engines/engine[2]/cutoff-switch", func {
	if (getprop("/controls/engines/engine[2]/cutoff-switch") == 1) {
		cutoff_three();
	}
});

var cutoff_three = func {
	eng_three_auto_start.stop();
	eng_three_n2_check.stop();
	setprop("/controls/engines/engine[2]/starter", 0);
	setprop("/controls/engines/engine[2]/cutoff", 1);
	setprop("/controls/engines/engine[2]/start-switch", 0);
	setprop("/engines/engine[2]/state", 0);
	interpolate(engines[2].getNode("egt-actual"), 0, egt_shutdown_time);
	eng_three_n2_check.stop();
}

var fast_start_three = func {
	setprop("/controls/engines/engine[2]/cutoff-switch", 0);
	setprop("/controls/engines/engine[2]/cutoff", 0);
	setprop("/engines/engine[2]/out-of-fuel", 0);
	setprop("/engines/engine[2]/run", 1);

	setprop("/engines/engine[2]/cutoff", 0);
	setprop("/engines/engine[2]/starter", 0);

	setprop("/fdm/jsbsim/propulsion/set-running", 2);
	
	setprop("/engines/engine[2]/state", 3);
}

var start_three_check = func {
	if (getprop("/controls/engines/packs-off") != 1) {
		setprop("/controls/engines/ign-packs-time", getprop("/sim/time/elapsed-sec"));
		settimer(start_three_check, 1);
	} else {
		if (IGN1 == 1 and getprop("/controls/engines/engine[2]/start-switch") == 1 and getprop("/systems/pneumatics/total-psi") >= 28) {
			auto_start_three();
		} else {
			setprop("/controls/engines/engine[2]/start-switch", 0);
		}
	}
}

# Start Engine One
var auto_start_one = func {
	setprop("/engines/engine[0]/state", 1);
	setprop("/controls/engines/engine[0]/starter", 1);
	eng_one_auto_start.start();
}

var eng_one_auto_start = maketimer(0.5, func {
	if (getprop("/engines/engine[0]/n2-actual") >= 15.5 and getprop("/controls/engines/engine[0]/cutoff-switch") == 0) {
		eng_one_auto_start.stop();
		setprop("/engines/engine[0]/state", 2);
		setprop("/controls/engines/engine[0]/cutoff", 0);
		interpolate(engines[0].getNode("egt-actual"), egt_start, egt_lightup_time);
		eng_one_egt_check.start();
		eng_one_n2_check.start();
	}
});

var eng_one_egt_check = maketimer(0.5, func {
	if (getprop("/engines/engine[0]/egt-actual") >= egt_start) {
		eng_one_egt_check.stop();
		interpolate(engines[0].getNode("egt-actual"), egt_min, egt_lightdn_time);
	}
});

var eng_one_n2_check = maketimer(0.5, func {
	if (getprop("/engines/engine[0]/n2-actual") >= 43.0) {
		setprop("/controls/engines/engine[0]/start-switch", 0);
	}
	if (getprop("/engines/engine[0]/n2-actual") >= 57.0) {
		eng_one_n2_check.stop();
		setprop("/engines/engine[0]/state", 3);
	}
});

# Start Engine Two
var auto_start_two = func {
	setprop("/engines/engine[1]/state", 1);
	setprop("/controls/engines/engine[1]/starter", 1);
	eng_two_auto_start.start();
}

var eng_two_auto_start = maketimer(0.5, func {
	if (getprop("/engines/engine[1]/n2-actual") >= 15.5 and getprop("/controls/engines/engine[1]/cutoff-switch") == 0) {
		eng_two_auto_start.stop();
		setprop("/engines/engine[1]/state", 2);
		setprop("/controls/engines/engine[1]/cutoff", 0);
		interpolate(engines[1].getNode("egt-actual"), egt_start, egt_lightup_time);
		eng_two_egt_check.start();
		eng_two_n2_check.start();
	}
});

var eng_two_egt_check = maketimer(0.5, func {
	if (getprop("/engines/engine[1]/egt-actual") >= egt_start) {
		eng_two_egt_check.stop();
		interpolate(engines[1].getNode("egt-actual"), egt_min, egt_lightdn_time);
	}
});

var eng_two_n2_check = maketimer(0.5, func {
	if (getprop("/engines/engine[1]/n2-actual") >= 43.0) {
		setprop("/controls/engines/engine[1]/start-switch", 0);
	}
	if (getprop("/engines/engine[1]/n2-actual") >= 57.0) {
		eng_two_n2_check.stop();
		setprop("/engines/engine[1]/state", 3);
	}
});

# Start Engine Three
var auto_start_three = func {
	setprop("/engines/engine[2]/state", 1);
	setprop("/controls/engines/engine[2]/starter", 1);
	eng_three_auto_start.start();
}

var eng_three_auto_start = maketimer(0.5, func {
	if (getprop("/engines/engine[2]/n2-actual") >= 15.5 and getprop("/controls/engines/engine[2]/cutoff-switch") == 0) {
		eng_three_auto_start.stop();
		setprop("/engines/engine[2]/state", 2);
		setprop("/controls/engines/engine[2]/cutoff", 0);
		interpolate(engines[2].getNode("egt-actual"), egt_start, egt_lightup_time);
		eng_three_egt_check.start();
		eng_three_n2_check.start();
	}
});

var eng_three_egt_check = maketimer(0.5, func {
	if (getprop("/engines/engine[2]/egt-actual") >= egt_start) {
		eng_three_egt_check.stop();
		interpolate(engines[2].getNode("egt-actual"), egt_min, egt_lightdn_time);
	}
});

var eng_three_n2_check = maketimer(0.5, func {
	if (getprop("/engines/engine[2]/n2-actual") >= 43.0) {
		setprop("/controls/engines/engine[2]/start-switch", 0);
	}
	if (getprop("/engines/engine[2]/n2-actual") >= 57.0) {
		eng_three_n2_check.stop();
		setprop("/engines/engine[2]/state", 3);
	}
});

# Various Other Stuff
setlistener("/controls/engines/ign-a-enabled", func {
	ign_kill_check();
});
setlistener("/controls/engines/ign-b-enabled", func {
	ign_kill_check();
});

var ign_kill_check = func {
	if (getprop("/engines/engine[0]/state") == 0 and getprop("/controls/engines/engine[0]/start-switch") == 1) {
		start_one_check();
	}
	if (getprop("/engines/engine[1]/state") == 0 and getprop("/controls/engines/engine[1]/start-switch") == 1) {
		start_two_check();
	}
	if (getprop("/engines/engine[2]/state") == 0 and getprop("/controls/engines/engine[2]/start-switch") == 1) {
		start_three_check();
	}
	if (getprop("/controls/engines/ign-a-enabled") == 0 or getprop("/controls/engines/ign-b-enabled") == 0) {
		if (getprop("/engines/engine[0]/state") == 1 or getprop("/engines/engine[0]/state") == 2) {
			setprop("/controls/engines/engine[0]/starter", 0);
			setprop("/controls/engines/engine[0]/cutoff", 1);
			setprop("/engines/engine[0]/state", 0);
			interpolate(engines[0].getNode("egt-actual"), 0, egt_shutdown_time);
		}
		if (getprop("/engines/engine[1]/state") == 1 or getprop("/engines/engine[1]/state") == 2) {
			setprop("/controls/engines/engine[1]/starter", 0);
			setprop("/controls/engines/engine[1]/cutoff", 1);
			setprop("/engines/engine[1]/state", 0);
			interpolate(engines[1].getNode("egt-actual"), 0, egt_shutdown_time);
		}
		if (getprop("/engines/engine[2]/state") == 1 or getprop("/engines/engine[2]/state") == 2) {
			setprop("/controls/engines/engine[2]/starter", 0);
			setprop("/controls/engines/engine[2]/cutoff", 1);
			setprop("/engines/engine[2]/state", 0);
			interpolate(engines[2].getNode("egt-actual"), 0, egt_shutdown_time);
		}
	}
}

setlistener("/systems/pneumatics/total-psi", func {
	if (getprop("/systems/pneumatics/total-psi") < 12) {
		if (getprop("/engines/engine[0]/state") == 1 or getprop("/engines/engine[0]/state") == 2) {
			setprop("/controls/engines/engine[0]/starter", 0);
			setprop("/controls/engines/engine[0]/cutoff", 1);
			setprop("/engines/engine[0]/state", 0);
			interpolate(engines[0].getNode("egt-actual"), 0, egt_shutdown_time);
		}
		if (getprop("/engines/engine[1]/state") == 1 or getprop("/engines/engine[1]/state") == 2) {
			setprop("/controls/engines/engine[1]/starter", 0);
			setprop("/controls/engines/engine[1]/cutoff", 1);
			setprop("/engines/engine[1]/state", 0);
			interpolate(engines[1].getNode("egt-actual"), 0, egt_shutdown_time);
		}
		if (getprop("/engines/engine[2]/state") == 1 or getprop("/engines/engine[2]/state") == 2) {
			setprop("/controls/engines/engine[2]/starter", 0);
			setprop("/controls/engines/engine[2]/cutoff", 1);
			setprop("/engines/engine[2]/state", 0);
			interpolate(engines[2].getNode("egt-actual"), 0, egt_shutdown_time);
		}
	}
}, 0, 0);
