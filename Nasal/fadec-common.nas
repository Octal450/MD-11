# MD-11 FADEC by Joshua Davidson (Octal450)

# Copyright (c) 2019 Joshua Davidson (Octal450)

if (getprop("/options/eng") == "PW") {
	io.include("fadec-pw.nas");
} else {
	io.include("fadec-ge.nas");
}

var eprga = 0;
var eprto = 0;
var eprmct = 0;
var eprflx = 0;
var eprclb = 0;
var eprcrz = 0;
var n1ga = 0;
var n1to = 0;
var n1mct = 0;
var n1flx = 0;
var n1clb = 0;
var n1crz = 0;
var mode = 0;
setprop("/systems/thrust/epr/ga-lim", 1.0);
setprop("/systems/thrust/epr/to-lim", 1.0);
setprop("/systems/thrust/epr/mct-lim", 1.0);
setprop("/systems/thrust/epr/flx-lim", 1.0);
setprop("/systems/thrust/epr/clb-lim", 1.0);
setprop("/systems/thrust/epr/crz-lim", 1.0);
setprop("/systems/thrust/n1/ga-lim", 0.0);
setprop("/systems/thrust/n1/to-lim", 0.0);
setprop("/systems/thrust/n1/mct-lim", 0.0);
setprop("/systems/thrust/n1/flx-lim", 0.0);
setprop("/systems/thrust/n1/clb-lim", 0.0);
setprop("/systems/thrust/n1/crz-lim", 0.0);
setprop("/controls/engines/thrust-limit", "T/O");
setprop("/controls/engines/n1-limit", 0.0);
setprop("/controls/engines/epr-limit", 1.0);

var fadec_reset = func {
	setprop("/systems/thrust/clbthrust-ft", "1500");
	setprop("/controls/fadec/eng1-alnt", 0);
	setprop("/controls/fadec/eng2-alnt", 0);
	setprop("/controls/fadec/eng3-alnt", 0);
}

fadec_reset();

var fadecLoop = func {
	eprga = getprop("/systems/thrust/epr/ga-lim");
	eprto = getprop("/systems/thrust/epr/to-lim");
	eprmct = getprop("/systems/thrust/epr/mct-lim");
	eprflx = getprop("/systems/thrust/epr/flx-lim");
	eprclb = getprop("/systems/thrust/epr/clb-lim");
	eprcrz = getprop("/systems/thrust/epr/crz-lim");
	n1ga = getprop("/systems/thrust/n1/ga-lim");
	n1to = getprop("/systems/thrust/n1/to-lim");
	n1mct = getprop("/systems/thrust/n1/mct-lim");
	n1flx = getprop("/systems/thrust/n1/flx-lim");
	n1clb = getprop("/systems/thrust/n1/clb-lim");
	n1crz = getprop("/systems/thrust/n1/crz-lim");
	mode = getprop("/it-autoflight/mode/vert");
	flap = getprop("/controls/flight/flaps-input");
	if (mode == "G/A CLB") {
		setprop("/controls/engines/thrust-limit", "G/A");
		setprop("/controls/engines/n1-limit", n1ga);
		setprop("/controls/engines/epr-limit", eprga);
	} else if (mode == "T/O CLB") {
		setprop("/controls/engines/thrust-limit", "T/O");
		setprop("/controls/engines/n1-limit", n1to);
		setprop("/controls/engines/epr-limit", eprto);
	} else if (mode == "SPD CLB" or (mode == "V/S" and getprop("/it-autoflight/input/vs") >= 50) or flap >= 2) {
		setprop("/controls/engines/thrust-limit", "CLB");
		setprop("/controls/engines/n1-limit", n1clb);
		setprop("/controls/engines/epr-limit", eprclb);
	} else {
		setprop("/controls/engines/thrust-limit", "CRZ");
		setprop("/controls/engines/n1-limit", n1crz);
		setprop("/controls/engines/epr-limit", eprcrz);
	}
}
