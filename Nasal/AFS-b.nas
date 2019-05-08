# MD-11 AFS Interface
# Copyright (c) 2019 Joshua Davidson (Octal450)

var lat = "";
var vert = "";
var thrustLimMode = "";
var stopClampCheck = 0;
var stopThrottleReset = 0;
var clamp = 0;
var clampFMA = 0;
var thr = 0;
setprop("/controls/engines/throttle-max", 0);

setlistener("sim/signals/fdm-initialized", func {
	loopFMA.start();
});

var loopFMA = maketimer(0.05, func {
	vert = getprop("/it-autoflight/mode/vert");
	thrustLimMode = getprop("/controls/engines/thrust-limit");
	thr = getprop("/controls/engines/throttle-max");
	
	if (vert == "T/O CLB") {
		if (getprop("/it-autoflight/output/athr") == 1 and getprop("/instrumentation/airspeed-indicator/indicated-speed-kt") < 80) {
			if (thr >= 0.6) {
				clamp = 0;
			}
		} else {
			clamp = 1;
		}
	} else if (vert == "SPD CLB") {
		stopClampCheck = 0;
		stopThrottleReset = 0;
		clamp = 0;
	} else if (vert == "SPD DES") {
		if (thr <= 0.01) {
			stopClampCheck = 1;
			clamp = 1;
			if (stopThrottleReset != 1) {
				stopThrottleReset = 1;
				setprop("/controls/engines/engine[0]/throttle", 0);
				setprop("/controls/engines/engine[1]/throttle", 0);
				setprop("/controls/engines/engine[2]/throttle", 0);
			}
		} else if (stopClampCheck != 1) {
			stopThrottleReset = 0;
			clamp = 0;
		}
	} else {
		stopClampCheck = 0;
		stopThrottleReset = 0;
		clamp = 0;
	}
	
	if (getprop("/it-autoflight/output/clamp") != clamp) {
		setprop("/it-autoflight/output/clamp", clamp);
	}
	
	if (vert == "T/O CLB") {
		if (clamp) {
			clampFMA = 1;
		} else {
			clampFMA = 0;
		}
	} else if (vert == "SPD CLB") {
		clampFMA = 0;
	} else if (vert == "SPD DES") {
		clampFMA = 1;
	} else {
		clampFMA = 0;
	}
	
	if (vert == "SPD CLB" or vert == "T/O CLB") {
		if (clampFMA) {
			setprop("/modes/pfd/fma/pitch-mode", thrustLimMode ~ " CLAMP");
		} else {
			setprop("/modes/pfd/fma/pitch-mode", thrustLimMode ~ " THRUST");
		}
	} else if (vert == "SPD DES") {
		if (clampFMA) {
			setprop("/modes/pfd/fma/pitch-mode", "IDLE CLAMP");
		} else {
			setprop("/modes/pfd/fma/pitch-mode", "IDLE THRUST");
		}
	} else if (vert == "G/A CLB") {
		setprop("/modes/pfd/fma/pitch-mode", "GO AROUND");
	}
});

# Master Lateral
setlistener("/it-autoflight/mode/lat", func {
	updateLateral();
});

setlistener("/it-autoflight/internal/active-fms", func {
	updateLateral();
}, 0, 0);

var updateLateral = func {
	lat = getprop("/it-autoflight/mode/lat");
	if (lat == "HDG") {
		setprop("/modes/pfd/fma/roll-mode", "HEADING");
	} else if (lat == "LNAV") {
		setprop("/modes/pfd/fma/roll-mode", "NAV" ~ Custom.Internal.activeFMS.getValue());
	} else if (lat == "LOC") {
		setprop("/modes/pfd/fma/roll-mode", "LOC");
	} else if (lat == "ALGN") {
		setprop("/modes/pfd/fma/roll-mode", "ALIGN");
	} else if (lat == "T/O") {
		setprop("/modes/pfd/fma/roll-mode", "TAKEOFF");
	} else if (lat == "RLOU") {
		setprop("/modes/pfd/fma/roll-mode", "ROLLOUT");
	}
}

# Master Vertical
setlistener("/it-autoflight/mode/vert", func {
	vert = getprop("/it-autoflight/mode/vert");
	if (vert == "ALT HLD") {
		setprop("/modes/pfd/fma/pitch-mode", "HOLD");
	} else if (vert == "ALT CAP") {
		setprop("/modes/pfd/fma/pitch-mode", "HOLD");
	} else if (vert == "V/S") {
		setprop("/modes/pfd/fma/pitch-mode", "V/S");
	} else if (vert == "G/S") {
		setprop("/modes/pfd/fma/pitch-mode", "G/S");
	} else if (vert == "FPA") {
		setprop("/modes/pfd/fma/pitch-mode", "FPA");
	} else if (vert == "FLARE") {
		setprop("/modes/pfd/fma/pitch-mode", "FLARE");
	} else if (vert == "ROLLOUT") {
		setprop("/modes/pfd/fma/pitch-mode", "ROLLOUT");
	}
});

setlistener("/it-autoflight/output/lnav-armed", func {
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
	} else if (getprop("/it-autoflight/output/lnav-armed") == 1) {
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
