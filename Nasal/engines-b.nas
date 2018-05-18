# MD-11 JSB Engine System

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

var IGN1 = 0;
var IGN2 = 0;
var IGN3 = 0;
var IGNTOGA = 0;
setprop("/controls/engines/packs-off", 0);
setprop("/controls/engines/ign-packs", 0);
setprop("/controls/engines/ign-packs-time", -1000);

setlistener("/sim/signals/fdm-initialized", func {
	var thr1 = 0;
	var thr2 = 0;
	var state1 = getprop("/engines/engine[0]/state");
	var state2 = getprop("/engines/engine[1]/state");
	var state3 = getprop("/engines/engine[2]/state");
	var wow0 = getprop("/gear/gear[0]/wow");
});

var eng_init = func {
	setprop("/controls/engines/ign-a", 0);
	setprop("/controls/engines/ign-b", 0);
	setprop("/controls/engines/ign-ovrd", 0);
	setprop("/controls/engines/ignition-1", 0);
	setprop("/controls/engines/ignition-2", 0);
	setprop("/controls/engines/ignition-3", 0);
}

var eng_loop = func {
	thr1 = getprop("/controls/engines/engine[0]/throttle");
	thr2 = getprop("/controls/engines/engine[1]/throttle");
	state1 = getprop("/engines/engine[0]/state");
	state2 = getprop("/engines/engine[1]/state");
	state3 = getprop("/engines/engine[2]/state");
	wow0 = getprop("/gear/gear[0]/wow");
	
	if (getprop("/systems/electrical/bus/l-emer-ac") >= 110 and getprop("/controls/engines/ign-a") == 1) {
		IGN1 = 1;
		IGN2 = 1;
		IGN3 = 1;
	} else if (getprop("/systems/electrical/bus/r-emer-ac") >= 110 and getprop("/controls/engines/ign-b") == 1) {
		IGN1 = 1;
		IGN2 = 1;
		IGN3 = 1;
	} else {
		IGN1 = 0;
		IGN2 = 0;
		IGN3 = 0;
	}
	
	if ((getprop("/controls/engines/thrust-limit") == "T/O" or getprop("/controls/engines/thrust-limit") == "G/A") and (thr1 >= 0.7 or thr2 >= 0.7)) {
		IGNTOGA = 1;
	} else {
		IGNTOGA = 0;
	}
	
	if (getprop("/controls/engines/ign-packs") != 1 and (getprop("/controls/engines/ign-a") == 1 or getprop("/controls/engines/ign-b") == 1) and (state1 != 3 or state2 != 3 or state3 != 3) and wow0 == 1) {
		setprop("/controls/engines/ign-packs", 1);
		setprop("/controls/engines/ign-packs-time", getprop("/sim/time/elapsed-sec"));
	} else if (getprop("/controls/engines/ign-packs") != 0 and getprop("/controls/engines/ign-a") == 0 and getprop("/controls/engines/ign-b") == 0) {
		setprop("/controls/engines/ign-packs", 0);
		setprop("/controls/engines/ign-packs-time", -1000)
	}
	
	if (getprop("/controls/engines/ign-packs-time") + 120 >= getprop("/sim/time/elapsed-sec") and (state1 != 3 or state2 != 3 or state3 != 3) and wow0 == 1) {
		setprop("/controls/engines/packs-off", 1);
	} else if (IGNTOGA == 1) {
		setprop("/controls/engines/packs-off", 1);
	} else {
		setprop("/controls/engines/packs-off", 0);
	}
	
	if ((getprop("/controls/engines/ign-ovrd") == 1 or state1 == 1 or state1 == 2 or IGNTOGA == 1) and IGN1 == 1) {
		setprop("/controls/engines/ignition-1", 1);
	} else {
		setprop("/controls/engines/ignition-1", 0);
	}
	
	if ((getprop("/controls/engines/ign-ovrd") == 1 or state2 == 1 or state2 == 2 or IGNTOGA == 1) and IGN2 == 1) {
		setprop("/controls/engines/ignition-2", 1);
	} else {
		setprop("/controls/engines/ignition-2", 0);
	}
	
	if ((getprop("/controls/engines/ign-ovrd") == 1 or state3 == 1 or state3 == 2 or IGNTOGA == 1) and IGN3 == 1) {
		setprop("/controls/engines/ignition-3", 1);
	} else {
		setprop("/controls/engines/ignition-3", 0);
	}
}
