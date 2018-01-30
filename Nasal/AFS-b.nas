# McDonnell Douglas MD-11 FMA System
# Joshua Davidson (it0uchpods/411)

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

setlistener("sim/signals/fdm-initialized", func {
	loopFMA.start();
});

var loopFMA = maketimer(0.05, func {
	var vert = getprop("/it-autoflight/mode/vert");
	var thrustLimMode = getprop("/controls/engines/thrust-limit");
	if (vert == "SPD CLB" or vert == "T/O CLB" or vert == "G/A CLB") {
		setprop("/modes/pfd/fma/pitch-mode", thrustLimMode ~ " THRUST");
	}
});

# Master Lateral
setlistener("/it-autoflight/mode/lat", func {
	var lat = getprop("/it-autoflight/mode/lat");
	if (lat == "HDG") {
		setprop("/modes/pfd/fma/roll-mode", "HEADING");
	} else if (lat == "LNAV") {
		setprop("/modes/pfd/fma/roll-mode", "NAV1");
	} else if (lat == "LOC") {
		setprop("/modes/pfd/fma/roll-mode", "LOC");
	} else if (lat == "ALGN") {
		setprop("/modes/pfd/fma/roll-mode", "ALIGN");
	} else if (lat == "T/O") {
		setprop("/modes/pfd/fma/roll-mode", "TAKEOFF");
	} else if (lat == "RLOU") {
		setprop("/modes/pfd/fma/roll-mode", "ROLLOUT");
	}
});

# Master Vertical
setlistener("/it-autoflight/mode/vert", func {
	var vert = getprop("/it-autoflight/mode/vert");
	if (vert == "ALT HLD") {
		setprop("/modes/pfd/fma/pitch-mode", "HOLD");
	} else if (vert == "ALT CAP") {
		setprop("/modes/pfd/fma/pitch-mode", "HOLD");
	} else if (vert == "V/S") {
		setprop("/modes/pfd/fma/pitch-mode", "V/S");
	} else if (vert == "G/S") {
		setprop("/modes/pfd/fma/pitch-mode", "G/S");
	} else if (vert == "SPD DES") {
		setprop("/modes/pfd/fma/pitch-mode", "IDLE CLAMP");
	} else if (vert == "FPA") {
		setprop("/modes/pfd/fma/pitch-mode", "FPA");
	} else if (vert == "LAND") {
		setprop("/modes/pfd/fma/pitch-mode", "G/S");
	} else if (vert == "FLARE") {
		setprop("/modes/pfd/fma/pitch-mode", "FLARE");
	} else if (vert == "ROLLOUT") {
		setprop("/modes/pfd/fma/pitch-mode", "ROLLOUT");
	}
});

setlistener("/it-autoflight/input/lat-arm", func {
	lateral_arm();
});

# Arm LOC
setlistener("/it-autoflight/output/loc-armed", func {
	lateral_arm();
});

var lateral_arm = func {
	var loca = getprop("/it-autoflight/output/loc-armed");
	if (loca) {
		setprop("/modes/pfd/fma/roll-mode-armed", "LAND ARMED");
	} else if (getprop("/it-autoflight/input/lat-arm") == 1) {
		setprop("/modes/pfd/fma/roll-mode-armed", "NAV ARMED");
	} else {
		setprop("/modes/pfd/fma/roll-mode-armed", "");
	}
	appr_arm();
}

# Arm G/S
setlistener("/it-autoflight/output/appr-armed", func {
	appr_arm();
});

var appr_arm = func {
	var loca = getprop("/it-autoflight/output/loc-armed");
	var appa = getprop("/it-autoflight/output/appr-armed");
	if (appa and !loca) {
		setprop("/modes/pfd/fma/pitch-mode-armed", "LAND ARMED");
	} else {
		setprop("/modes/pfd/fma/pitch-mode-armed", "");
	}
}

# AP
var ap = func {
	var ap1 = getprop("/it-autoflight/output/ap1");
	var ap2 = getprop("/it-autoflight/output/ap2");
	if (ap1 and ap2) {
		setprop("/modes/pfd/fma/ap-mode", "AP1");
	} else if (ap1 and !ap2) {
		setprop("/modes/pfd/fma/ap-mode", "AP1");
	} else if (ap2 and !ap1) {
		setprop("/modes/pfd/fma/ap-mode", "AP2");
	} else if (!ap1 and !ap2) {
		setprop("/modes/pfd/fma/ap-mode", "");
	}
}

setlistener("/it-autoflight/output/ap1", func {
	ap();
});
setlistener("/it-autoflight/output/ap2", func {
	ap();
});
