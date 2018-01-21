# MD-11 Buttons
# Joshua Davidson (it0uchpods)

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

# Resets buttons to the default values
var variousReset = func {
	setprop("/controls/pneumatic/switches/bleedapu", 0); # Temporary until bleeds available
}

#setlistener("/sim/signals/fdm-initialized", func {
#	var state1 = getprop("/engines/engine[0]/state");
#	var state2 = getprop("/engines/engine[1]/state");
#	var state3 = getprop("/engines/engine[2]/state");
#	var Lrain = getprop("/controls/switches/LrainRpt");
#	var Rrain = getprop("/controls/switches/RrainRpt");
#	var OnLt = getprop("/controls/switches/emerCallLtO");
#	var CallLt = getprop("/controls/switches/emerCallLtC");
#	var wow = getprop("/gear/gear[1]/wow");
#	rainTimer.start();
#});

var toggleSTD = func {
	var Std = getprop("/modes/altimeter/std");
	if (Std == 1) {
		var oldqnh = getprop("/modes/altimeter/oldqnh");
		setprop("/instrumentation/altimeter/setting-inhg", oldqnh);
		setprop("/modes/altimeter/std", 0);
	} else if (Std == 0) {
		var qnh = getprop("/instrumentation/altimeter/setting-inhg");
		setprop("/modes/altimeter/oldqnh", qnh);
		setprop("/instrumentation/altimeter/setting-inhg", 29.92);
		setprop("/modes/altimeter/std", 1);
	}
}

var unSTD = func {
	var Std = getprop("/modes/altimeter/std");
	if (Std == 1) {
		var oldqnh = getprop("/modes/altimeter/oldqnh");
		setprop("/instrumentation/altimeter/setting-inhg", oldqnh);
		setprop("/modes/altimeter/std", 0);
	}
}
