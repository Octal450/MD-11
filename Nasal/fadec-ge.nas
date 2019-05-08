# MD-11 GE FADEC by Joshua Davidson (Octal450)

# Copyright (c) 2019 Joshua Davidson (Octal450)

setprop("/systems/fadec/eng1/egt", 0);
setprop("/systems/fadec/eng1/n1", 0);
setprop("/systems/fadec/eng1/n2", 0);
setprop("/systems/fadec/eng1/ff", 0);
setprop("/systems/fadec/eng2/egt", 0);
setprop("/systems/fadec/eng2/n1", 0);
setprop("/systems/fadec/eng2/n2", 0);
setprop("/systems/fadec/eng2/ff", 0);
setprop("/systems/fadec/eng3/egt", 0);
setprop("/systems/fadec/eng3/n1", 0);
setprop("/systems/fadec/eng3/n2", 0);
setprop("/systems/fadec/eng3/ff", 0);
setprop("/systems/fadec/power-avail", 0);
setprop("/systems/fadec/powered1", 0);
setprop("/systems/fadec/powered2", 0);
setprop("/systems/fadec/powered3", 0);

setlistener("/sim/signals/fdm-initialized", func {
	fadecLoop2.start();
});

var fadecLoop2 = maketimer(0.7, func {
	var state1 = getprop("/engines/engine[0]/state");
	var state2 = getprop("/engines/engine[1]/state");
	var state3 = getprop("/engines/engine[2]/state");
	var master1 = getprop("/controls/engines/engine[0]/cutoff-switch");
	var master2 = getprop("/controls/engines/engine[1]/cutoff-switch");
	var master3 = getprop("/controls/engines/engine[1]/cutoff-switch");
	var modeSel = getprop("/controls/engines/ignition-mode");
	var N21 = getprop("/engines/engine[0]/n2-actual");
	var N22 = getprop("/engines/engine[1]/n2-actual");
	var N23 = getprop("/engines/engine[2]/n2-actual");
	
	if (getprop("/systems/electrical/outputs/efis") >= 15) {
		setprop("/systems/fadec/power-avail", 1);
	} else {
		setprop("/systems/fadec/power-avail", 0);
	}
	
	var powerAvail = getprop("/systems/fadec/power-avail");
	
	if (state1 == 3) {
		setprop("/systems/fadec/powered1", 1);
	} else if (powerAvail and N21 >= 1) {
		setprop("/systems/fadec/powered1", 1);
	} else {
		setprop("/systems/fadec/powered1", 0);
	}
	
	if (state2 == 3) {
		setprop("/systems/fadec/powered2", 1);
	} else if (powerAvail and N22 >= 1) {
		setprop("/systems/fadec/powered2", 1);
	} else {
		setprop("/systems/fadec/powered2", 0);
	}
	
	if (state3 == 3) {
		setprop("/systems/fadec/powered3", 1);
	} else if (powerAvail and N23 >= 1) {
		setprop("/systems/fadec/powered3", 1);
	} else {
		setprop("/systems/fadec/powered3", 0);
	}
	
	var powered1 = getprop("/systems/fadec/powered1");
	var powered2 = getprop("/systems/fadec/powered2");
	var powered3 = getprop("/systems/fadec/powered3");
	
	if (powered1) {
		setprop("/systems/fadec/eng1/n1", 1);
		setprop("/systems/fadec/eng1/egt", 1);
		setprop("/systems/fadec/eng1/n2", 1);
		setprop("/systems/fadec/eng1/ff", 1);
	} else {
		setprop("/systems/fadec/eng1/n1", 0);
		setprop("/systems/fadec/eng1/egt", 0);
		setprop("/systems/fadec/eng1/n2", 0);
		setprop("/systems/fadec/eng1/ff", 0);
	}
	
	if (powered2) {
		setprop("/systems/fadec/eng2/n1", 1);
		setprop("/systems/fadec/eng2/egt", 1);
		setprop("/systems/fadec/eng2/n2", 1);
		setprop("/systems/fadec/eng2/ff", 1);
	} else {
		setprop("/systems/fadec/eng2/n1", 0);
		setprop("/systems/fadec/eng2/egt", 0);
		setprop("/systems/fadec/eng2/n2", 0);
		setprop("/systems/fadec/eng2/ff", 0);
	}
	
	if (powered3) {
		setprop("/systems/fadec/eng3/n1", 1);
		setprop("/systems/fadec/eng3/egt", 1);
		setprop("/systems/fadec/eng3/n2", 1);
		setprop("/systems/fadec/eng3/ff", 1);
	} else {
		setprop("/systems/fadec/eng3/n1", 0);
		setprop("/systems/fadec/eng3/egt", 0);
		setprop("/systems/fadec/eng3/n2", 0);
		setprop("/systems/fadec/eng3/ff", 0);
	}
});
