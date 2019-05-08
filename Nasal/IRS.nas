# MD-11 IRS System
# Joshua Davidson (Octal450)

# Copyright (c) 2019 Joshua Davidson (Octal450)

var knob = 0;
var roll = 0;
var pitch = 0;
var gs = 0;
var ac1 = 0;
var ac2 = 0;
var ac3 = 0;
var dcbat = 0;;
var pwr_src = "XX";
var algnd1 = 0;
var algnd2 = 0;
var algnd3 = 0;
var setHDG = 1;
var hdg = 0;
setprop("/controls/irs/align-time", 600);

var IRS = {
	init: func() {
		setprop("/instrumentation/irs/ir[0]/aligned", 0);
		setprop("/instrumentation/irs/ir[1]/aligned", 0);
		setprop("/instrumentation/irs/ir[2]/aligned", 0);
		setprop("/controls/irs/ir[0]/align", 0);
		setprop("/controls/irs/ir[1]/align", 0);
		setprop("/controls/irs/ir[2]/align", 0);
		setprop("/controls/irs/ir[0]/time", 0);
		setprop("/controls/irs/ir[1]/time", 0);
		setprop("/controls/irs/ir[2]/time", 0);
		setprop("/controls/irs/ir[0]/knob", 0);
		setprop("/controls/irs/ir[1]/knob", 0);
		setprop("/controls/irs/ir[2]/knob", 0);
		setprop("/controls/irs/mcducbtn", 1); # MCDU is not here yet, so we can't press the INITIALIZE IRS button
	},
	loop: func() {
		roll = getprop("/orientation/roll-deg");
		pitch = getprop("/orientation/pitch-deg");
		gs = getprop("/velocities/groundspeed-kt");
		ac1 = getprop("/systems/electrical/bus/ac-1");
		ac2 = getprop("/systems/electrical/bus/ac-2");
		ac3 = getprop("/systems/electrical/bus/ac-3");
		dcbat = getprop("/systems/electrical/bus/dc-bat");
		
		if (getprop("/controls/irs/skip") == 1) {
			if (getprop("/controls/irs/align-time") != 5) {
				setprop("/controls/irs/align-time", 5);
			}
		} else {
			if (getprop("/controls/irs/align-time") != 600) {
				setprop("/controls/irs/align-time", 600);
			}
		}
		
		if (gs > 5 or pitch > 5 or pitch < -5 or roll > 10 or roll < -10 or (ac1 < 110 and ac2 < 110 and dcbat < 25)) {
			if (getprop("/controls/irs/ir[0]/align") == 1) {
				me.stopAlign(0, 1);
			}
			if (getprop("/controls/irs/ir[1]/align") == 1) {
				me.stopAlign(1, 1);
			}
			if (getprop("/controls/irs/ir[2]/align") == 1) {
				me.stopAlign(2, 1);
			}
		}
		
		if (ac1 >= 110 or ac2 >= 110 or ac3 >= 110) {
			pwr_src = "AC";
		} else if (dcbat >= 25 and (getprop("/controls/irs/ir[0]/knob") != 0 or getprop("/controls/irs/ir[1]/knob") != 0 or getprop("/controls/irs/ir[2]/knob") != 0)) {
			pwr_src = "BATT";
		} else {
			pwr_src = "XX";
		}
		
		algnd1 = getprop("/instrumentation/irs/ir[0]/aligned");
		algnd2 = getprop("/instrumentation/irs/ir[1]/aligned");
		algnd3 = getprop("/instrumentation/irs/ir[2]/aligned");
		hdg = math.round(getprop("/orientation/heading-magnetic-deg"));
		
		if (!algnd1 and !algnd2 and !algnd3 and setHDG != 1) {
			setHDG = 1;
		}
		if ((algnd1 or algnd2 or algnd3) and setHDG == 1) {
			setHDG = 0;
			setprop("/it-autoflight/custom/hdg-sel", hdg);
			setprop("/it-autoflight/input/hdg", hdg);
		}
		
		if (!algnd1 and !algnd2 and !algnd3 and getprop("/it-autoflight/output/lat") == 1) {
			afs.ITAF.setLatMode(3);
		} else if (!algnd1 and !algnd2 and !algnd3 and getprop("/it-autoflight/output/lnav-armed") == 1) {
			setprop("/it-autoflight/output/lnav-armed", 0);
			afs.ITAF.armTextCheck();
		}
	},
	knob: func(k) {
		knob = getprop("/controls/irs/ir[" ~ k ~ "]/knob");
		if (knob == 0) {
			me.stopAlign(k, 0);
		} else if (knob == 1) {
			me.beginAlign(k);
		}
	},
	beginAlign: func(n) {
		ac1 = getprop("/systems/electrical/bus/ac-1");
		ac2 = getprop("/systems/electrical/bus/ac-2");
		ac3 = getprop("/systems/electrical/bus/ac-3");
		dcbat = getprop("/systems/electrical/bus/dc-bat");
		setprop("/instrumentation/irs/adr[" ~ n ~ "]/active", 1);
		if (getprop("/controls/irs/ir[" ~ n ~ "]/align") != 1 and getprop("/instrumentation/irs/ir[" ~ n ~ "]/aligned") != 1 and (ac1 >= 110 or ac2 >= 110 or ac3 >= 110 or dcbat >= 25)) {
			setprop("/controls/irs/ir[" ~ n ~ "]/time", getprop("/sim/time/elapsed-sec"));
			setprop("/controls/irs/ir[" ~ n ~ "]/align", 1);
			if (n == 0) {
				alignOne.start();
			} else if (n == 1) {
				alignTwo.start();
			} else if (n == 2) {
				alignThree.start();
			}
		}
	},
	stopAlign: func(n,f) {
		setprop("/controls/irs/ir[" ~ n ~ "]/align", 0);
		if (n == 0) {
			alignOne.stop();
		} else if (n == 1) {
			alignTwo.stop();
		} else if (n == 2) {
			alignThree.stop();
		}
		setprop("/instrumentation/irs/adr[" ~ n ~ "]/active", 0);
		setprop("/instrumentation/irs/ir[" ~ n ~ "]/aligned", 0);
#		setprop("/controls/irs/mcducbtn", 0); # MCDU is not here yet, so we can't press the INITIALIZE IRS button
	},
	skip: func(n) {
		if (n == 0) {
			alignOne.stop();
		} else if (n == 1) {
			alignTwo.stop();
		} else if (n == 2) {
			alignThree.stop();
		}
		setprop("/controls/irs/ir[" ~ n ~ "]/align", 0);
		setprop("/instrumentation/irs/ir[" ~ n ~ "]/aligned", 1);
	},
};

var alignOne = maketimer(0.1, func {
	if (getprop("/controls/irs/ir[0]/time") + getprop("/controls/irs/align-time") >= getprop("/sim/time/elapsed-sec")) {
		if (getprop("/instrumentation/irs/ir[0]/aligned") != 0) {
			setprop("/instrumentation/irs/ir[0]/aligned", 0);
		}
		if (getprop("/controls/irs/ir[0]/align") != 1) {
			setprop("/controls/irs/ir[0]/align", 1);
		}
	} else {
		if (getprop("/instrumentation/irs/ir[0]/aligned") != 1 and getprop("/controls/irs/mcducbtn") == 1) {
			alignOne.stop();
			setprop("/instrumentation/irs/ir[0]/aligned", 1);
		}
		if (getprop("/controls/irs/ir[0]/align") != 0) {
			setprop("/controls/irs/ir[0]/align", 0);
		}
	}
});

var alignTwo = maketimer(0.1, func {
	if (getprop("/controls/irs/ir[1]/time") + getprop("/controls/irs/align-time") >= getprop("/sim/time/elapsed-sec")) {
		if (getprop("/instrumentation/irs/ir[1]/aligned") != 0) {
			setprop("/instrumentation/irs/ir[1]/aligned", 0);
		}
		if (getprop("/controls/irs/ir[1]/align") != 1) {
			setprop("/controls/irs/ir[1]/align", 1);
		}
	} else {
		if (getprop("/instrumentation/irs/ir[1]/aligned") != 1 and getprop("/controls/irs/mcducbtn") == 1) {
			alignTwo.stop();
			setprop("/instrumentation/irs/ir[1]/aligned", 1);
		}
		if (getprop("/controls/irs/ir[1]/align") != 0) {
			setprop("/controls/irs/ir[1]/align", 0);
		}
	}
});

var alignThree = maketimer(0.1, func {
	if (getprop("/controls/irs/ir[2]/time") + getprop("/controls/irs/align-time") >= getprop("/sim/time/elapsed-sec")) {
		if (getprop("/instrumentation/irs/ir[2]/aligned") != 0) {
			setprop("/instrumentation/irs/ir[2]/aligned", 0);
		}
		if (getprop("/controls/irs/ir[2]/align") != 1) {
			setprop("/controls/irs/ir[2]/align", 1);
		}
	} else {
		if (getprop("/instrumentation/irs/ir[2]/aligned") != 1 and getprop("/controls/irs/mcducbtn") == 1) {
			alignThree.stop();
			setprop("/instrumentation/irs/ir[2]/aligned", 1);
		}
		if (getprop("/controls/irs/ir[2]/align") != 0) {
			setprop("/controls/irs/ir[2]/align", 0);
		}
	}
});

setlistener("/controls/irs/ir[0]/knob", func {
	IRS.knob(0);
});

setlistener("/controls/irs/ir[1]/knob", func {
	IRS.knob(1);
});

setlistener("/controls/irs/ir[2]/knob", func {
	IRS.knob(2);
});
