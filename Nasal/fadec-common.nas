# MD-11 FADEC by Joshua Davidson (it0uchpods)

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

setprop("/systems/thrust/n1/toga-lim", 0.0);
setprop("/systems/thrust/n1/mct-lim", 0.0);
setprop("/systems/thrust/n1/flx-lim", 0.0);
setprop("/systems/thrust/n1/clb-lim", 0.0);
setprop("/systems/thrust/n1/crz-lim", 0.0);
setprop("/controls/engines/thrust-limit", "T/O");
setprop("/controls/engines/n1-limit", 0.0);
setprop("/systems/thrust/clbthrust-ft", "1500");

setlistener("/sim/signals/fdm-initialized", func {
	fadecLoopT.start();
});

var fadecLoop = func {
	var n1toga = getprop("/systems/thrust/n1/toga-lim");
	var n1mct = getprop("/systems/thrust/n1/mct-lim");
	var n1flx = getprop("/systems/thrust/n1/flx-lim");
	var n1clb = getprop("/systems/thrust/n1/clb-lim");
	var n1crz = getprop("/systems/thrust/n1/crz-lim");
	var mode = getprop("/modes/pfd/fma/pitch-mode");
	if (getprop("/position/gear-agl-ft") < getprop("/systems/thrust/clbthrust-ft")) {
		setprop("/controls/engines/thrust-limit", "T/O");
		setprop("/controls/engines/n1-limit", n1toga);
	} else {
		if (mode == "CLB THRUST" or (mode == "V/S" and getprop("/it-autoflight/input/vs") >= 100)) {
			setprop("/controls/engines/thrust-limit", "CLB");
			setprop("/controls/engines/n1-limit", n1clb);
		} else {
			setprop("/controls/engines/thrust-limit", "CRZ");
			setprop("/controls/engines/n1-limit", n1crz);
		}
	}
}

# Timers
var fadecLoopT = maketimer(0.5, fadecLoop);