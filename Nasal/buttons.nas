# MD-11 Buttons
# Joshua Davidson (it0uchpods)

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

# Resets buttons to the default values
#var variousReset = func {
#
#}

#setlistener("/sim/signals/fdm-initialized", func {
#	var stateL = getprop("/engines/engine[0]/state");
#	var stateR = getprop("/engines/engine[1]/state");
#	var Lrain = getprop("/controls/switches/LrainRpt");
#	var Rrain = getprop("/controls/switches/RrainRpt");
#	var OnLt = getprop("/controls/switches/emerCallLtO");
#	var CallLt = getprop("/controls/switches/emerCallLtC");
#	var wow = getprop("/gear/gear[1]/wow");
#	rainTimer.start();
#});

# FCU Buttons
setlistener("/it-autoflight/input/vs", func {
	setprop("/it-autoflight/input/vs-abs", abs(getprop("/it-autoflight/input/vs")));
});

setlistener("/it-autoflight/input/fpa", func {
	setprop("/it-autoflight/input/fpa-abs", abs(getprop("/it-autoflight/input/fpa")));
});

setlistener("/it-autoflight/input/spd-kts", func {
	setprop("/it-autoflight/custom/kts-sel", abs(getprop("/it-autoflight/input/spd-kts")));
});

setlistener("/it-autoflight/input/spd-mach", func {
	setprop("/it-autoflight/custom/mach-sel", abs(getprop("/it-autoflight/input/spd-mach")));
});

setlistener("/it-autoflight/input/hdg", func {
	setprop("/it-autoflight/custom/hdg-sel", abs(getprop("/it-autoflight/input/hdg")));
});

setlistener("/it-autoflight/output/vert", func {
	if (getprop("/it-autoflight/output/vert") == 1) {
		setprop("/it-autoflight/custom/vs-fpa", 0);
	}
});

setlistener("/it-autoflight/output/vert", func {
	if (getprop("/it-autoflight/output/vert") == 5) {
		setprop("/it-autoflight/custom/vs-fpa", 1);
	}
});