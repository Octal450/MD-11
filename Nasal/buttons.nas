# MD-11 Buttons
# Joshua Davidson (it0uchpods)

# Copyright (c) 2019 Joshua Davidson (it0uchpods)

# Resets buttons to the default values
var variousReset = func {
	setprop("/controls/lighting/beacon", 0);
	setprop("/controls/lighting/landing-light[0]", 0);
	setprop("/controls/lighting/landing-light[1]", 0);
	setprop("/controls/lighting/logo-lights", 0);
	setprop("/controls/lighting/nav-lights", 0);
	setprop("/controls/lighting/strobe", 0);
	setprop("/controls/switches/minimums", 200);
}

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
