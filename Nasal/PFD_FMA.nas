# McDonnell Douglas MD-11 FMA System
# Joshua Davidson (it0uchpods/411)

########################################
# Copyright (c) MD-11 Development Team #
########################################

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
		setprop("/modes/pfd/fma/roll-mode", "    TAKEOFF");
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
	} else if (vert == "SPD CLB") {
		setprop("/modes/pfd/fma/pitch-mode", "CLB THRUST");
	} else if (vert == "SPD DES") {
		setprop("/modes/pfd/fma/pitch-mode", "IDLE CLAMP");
	} else if (vert == "FPA") {
		setprop("/modes/pfd/fma/pitch-mode", "FPA");
	} else if (vert == "LAND") {
		setprop("/modes/pfd/fma/pitch-mode", "G/S");
	} else if (vert == "FLARE") {
		setprop("/modes/pfd/fma/pitch-mode", "FLARE");
	} else if (vert == "T/O CLB") {
		setprop("/modes/pfd/fma/pitch-mode", "T/O CLAMP");
	} else if (vert == "G/A CLB") {
		setprop("/modes/pfd/fma/pitch-mode", "G/A THRUST");
	}
});

# Master VNAV
setlistener("/it-autoflight/mode/prof", func {
	var prof = getprop("/it-autoflight/mode/prof");
	if (prof == "VNAV HLD") {
		setprop("/modes/pfd/fma/pitch-mode", "HOLD");
	} else if (prof == "VNAV CAP") {
		setprop("/modes/pfd/fma/pitch-mode", "HOLD");
	} else if (prof == "VNAV SPD") {
		vnav_clbdes();
	} else if (prof == "VNAV PTH") {
		vnav_clbdes();
	}
});

var vnav_clbdes = func {
	var vert = getprop("/it-autoflight/output/vert");
	if (vert == 8) {
		var prof = getprop("/it-autoflight/internal/prof-mode");
		if (prof == "XX") {
			# Do nothing
		} else if (prof == "DES") {
			setprop("/modes/pfd/fma/pitch-mode", "IDLE CLAMP");
		} else if (prof == "CLB") {
			setprop("/modes/pfd/fma/pitch-mode", "CLB THRUST");
		}
	}
}

# Arm LOC
setlistener("/it-autoflight/output/loc-armed", func {
	var loca = getprop("/it-autoflight/output/loc-armed");
	if (loca) {
		setprop("/modes/pfd/fma/roll-mode-armed", "LOC ARMED");
	} else {
		setprop("/modes/pfd/fma/roll-mode-armed", " ");
	}
});

# Arm G/S
setlistener("/it-autoflight/output/appr-armed", func {
	var appa = getprop("/it-autoflight/output/appr-armed");
	if (appa) {
		setprop("/modes/pfd/fma/pitch-mode-armed", "G/S ARMED");
	} else {
		setprop("/modes/pfd/fma/pitch-mode-armed", " ");
	}
});
