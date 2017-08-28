# MD-11 FADEC by Joshua Davidson (it0uchpods)

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

setprop("/systems/thrust/n1/toga-lim", 0.0);
setprop("/systems/thrust/n1/mct-lim", 0.0);
setprop("/systems/thrust/n1/flx-lim", 0.0);
setprop("/systems/thrust/n1/clb-lim", 0.0);
setprop("/controls/engines/thrust-limit", "T/O");
setprop("/controls/engines/n1-limit", 0.0);
setprop("/systems/thrust/clbthrust-ft", "1500");

setlistener("/sim/signals/fdm-initialized", func {
#	fadecLoopT.start();
});

var fadecLoop = func {
	var n1toga = getprop("/systems/thrust/n1/toga-lim");
	var n1mct = getprop("/systems/thrust/n1/mct-lim");
	var n1flx = getprop("/systems/thrust/n1/flx-lim");
	var n1clb = getprop("/systems/thrust/n1/clb-lim");
}

# Timers
var fadecLoopT = maketimer(0.5, fadecLoop);