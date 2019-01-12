# MD-11 FADEC by Joshua Davidson (it0uchpods)

# Copyright (c) 2019 Joshua Davidson (it0uchpods)

if (getprop("/options/eng") == "PW") {
	io.include("fadec-pw.nas");
} else {
	io.include("fadec-ge.nas");
}

var eprtoga = 0;
var eprmct = 0;
var eprflx = 0;
var eprclb = 0;
var eprcrz = 0;
var n1toga = 0;
var n1mct = 0;
var n1flx = 0;
var n1clb = 0;
var n1crz = 0;
var mode = 0;
setprop("/systems/thrust/epr/toga-lim", 1.0);
setprop("/systems/thrust/epr/mct-lim", 1.0);
setprop("/systems/thrust/epr/flx-lim", 1.0);
setprop("/systems/thrust/epr/clb-lim", 1.0);
setprop("/systems/thrust/epr/crz-lim", 1.0);
setprop("/systems/thrust/n1/toga-lim", 0.0);
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
	eprtoga = getprop("/systems/thrust/epr/toga-lim");
	eprmct = getprop("/systems/thrust/epr/mct-lim");
	eprflx = getprop("/systems/thrust/epr/flx-lim");
	eprclb = getprop("/systems/thrust/epr/clb-lim");
	eprcrz = getprop("/systems/thrust/epr/crz-lim");
	n1toga = getprop("/systems/thrust/n1/toga-lim");
	n1mct = getprop("/systems/thrust/n1/mct-lim");
	n1flx = getprop("/systems/thrust/n1/flx-lim");
	n1clb = getprop("/systems/thrust/n1/clb-lim");
	n1crz = getprop("/systems/thrust/n1/crz-lim");
	mode = getprop("/it-autoflight/mode/vert");
	flap = getprop("/controls/flight/flap-lever");
	if (mode == "T/O CLB") {
		setprop("/controls/engines/thrust-limit", "T/O");
		setprop("/controls/engines/n1-limit", n1toga);
		setprop("/controls/engines/epr-limit", eprtoga);
	} else if (mode == "G/A CLB") {
		setprop("/controls/engines/thrust-limit", "G/A");
		setprop("/controls/engines/n1-limit", n1toga);
		setprop("/controls/engines/epr-limit", eprtoga);
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
