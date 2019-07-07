# MD-11 JSB Engine System

# Copyright (c) 2019 Joshua Davidson (Octal450)

io.include("engines-b.nas");

var spinup_time = math.round((rand() * 10 ) + 49, 0.1);
var apu_max = 60;
var apu_max_n2 = 100;
var apu_egt_min = math.round((rand() * 10 ) + 352, 0.1);;
var apu_egt_max = math.round((rand() * 10 ) + 704, 0.1);;
var apu_on_lt2 = 0;
var oilqty = math.round((rand() * 5 ) + 7, 0.1);
var oildrop = math.round((rand() * 5 ) + 0.8, 0.1);
var oat = getprop("/environment/temperature-degc");
setprop("/systems/apu/oilqty", oilqty);
setprop("/systems/apu/n1", 0);
setprop("/systems/apu/n2", 0);
setprop("/systems/apu/egt", oat);
setprop("/controls/apu/on-light", 0);
setprop("/controls/engines/engine[0]/reverser", 0);
setprop("/controls/engines/engine[1]/reverser", 0);
setprop("/controls/engines/engine[2]/reverser", 0);

# Start APU
setlistener("/controls/apu/start", func {
	if (getprop("/controls/apu/start") == 1 and (getprop("/systems/electrical/bus/dc-bat") >= 25 or getprop("/systems/electrical/bus/dc-1") >= 25 or getprop("/systems/electrical/bus/dc-2") >= 25 or getprop("/systems/electrical/bus/dc-3") >= 25)) {
		if (getprop("/systems/acconfig/autoconfig-running") == 0) {
			interpolate("/systems/apu/n1", apu_max, spinup_time);
			interpolate("/systems/apu/n2", apu_max_n2, spinup_time);
			oilqty = getprop("/systems/apu/oilqty");
			setprop("/systems/apu/oilqty", oilqty - oildrop);
			apu_egt_check.start();
			apu_start_loop.start();
		} else if (getprop("/systems/acconfig/autoconfig-running") == 1) {
			apu_start_loop.stop();
			setprop("/controls/apu/on-light", 1);
			interpolate("/systems/apu/n1", apu_max, 5);
			interpolate("/systems/apu/n2", apu_max_n2, 5);
			interpolate("/systems/apu/egt", apu_egt_max, 5);
			oilqty = getprop("/systems/apu/oilqty");
			setprop("/systems/apu/oilqty", oilqty - oildrop);
		}
	} else if (getprop("/controls/apu/start") == 0) {
		apu_start_loop.stop();
		setprop("/controls/apu/on-light", 0);
		apu_egt_check.stop();
		apu_egt2_check.stop();
		apu_stop();
	}
});

var apu_egt_check = maketimer(0.5, func {
	if (getprop("/systems/apu/n2") >= 28) {
		apu_egt_check.stop();
		interpolate("/systems/apu/egt", apu_egt_max, 5);
		apu_egt2_check.start();
	}
});

var apu_egt2_check = maketimer(0.5, func {
	if (getprop("/systems/apu/egt") >= 701) {
		apu_egt2_check.stop();
		interpolate("/systems/apu/egt", apu_egt_min, 30);
	}
});

var apu_start_loop = maketimer(0.5, func {
	if (getprop("/systems/apu/n2") < 94.9) {
	# Remember that this STOPS when APU N2 is greater than 94.9%
		apu_on_lt2 = getprop("/controls/apu/on-light");
		if (apu_on_lt2 == 0) {
			setprop("/controls/apu/on-light", 1);
		} else {
			setprop("/controls/apu/on-light", 0);
		}
	} else {
		apu_start_loop.stop();
		setprop("/controls/apu/on-light", 1);
	}
	
	oilqty = getprop("/systems/apu/oilqty");
	setprop("/systems/apu/oilqty", oilqty - 0.001);
});

# Stop APU
var apu_stop = func {
	setprop("/controls/electrical/switches/apu-pwr", 0);
	setprop("/controls/pneumatics/switches/bleed-apu", 0);
	oat = getprop("/environment/temperature-degc");
	interpolate("/systems/apu/n1", 0, 30);
	interpolate("/systems/apu/n2", 0, 30);
	interpolate("/systems/apu/egt", oat, 40);
}

# Various Other Stuff
var doIdleThrust = func {
	setprop("/controls/engines/engine[0]/throttle", 0.0);
	setprop("/controls/engines/engine[1]/throttle", 0.0);
	setprop("/controls/engines/engine[2]/throttle", 0.0);
}

var doFullThrust = func {
	setprop("/controls/engines/engine[0]/throttle", 1.0);
	setprop("/controls/engines/engine[1]/throttle", 1.0);
	setprop("/controls/engines/engine[2]/throttle", 1.0);
}

# Reverse Thrust System
var toggleFastRevThrust = func {
	var eng1thr = getprop("/controls/engines/engine[0]/throttle-pos");
	var eng2thr = getprop("/controls/engines/engine[1]/throttle-pos");
	var eng3thr = getprop("/controls/engines/engine[2]/throttle-pos");
	if (eng1thr <= 0.05 and eng2thr <= 0.05 and eng3thr <= 0.05 and getprop("/controls/engines/engine[0]/reverser") == "0" and getprop("/controls/engines/engine[1]/reverser") == "0" and getprop("/controls/engines/engine[2]/reverser") == "0" 
	and getprop("/gear/gear[1]/wow") == 1 and getprop("/gear/gear[2]/wow") == 1) {
		interpolate("/engines/engine[0]/reverser-pos-norm", 1, 1.4);
		interpolate("/engines/engine[2]/reverser-pos-norm", 1, 1.4);
		interpolate("/engines/engine[1]/reverser-pos-norm", 1, 1.4);
		setprop("/controls/engines/engine[0]/reverser", 1);
		setprop("/controls/engines/engine[1]/reverser", 1);
		setprop("/controls/engines/engine[2]/reverser", 1);
		setprop("/controls/engines/engine[0]/throttle-rev", 0.3);
		setprop("/controls/engines/engine[1]/throttle-rev", 0.3);
		setprop("/controls/engines/engine[2]/throttle-rev", 0.3);
		setprop("/fdm/jsbsim/propulsion/engine[0]/reverser-angle-rad", 3.14);
		setprop("/fdm/jsbsim/propulsion/engine[1]/reverser-angle-rad", 3.14);
		setprop("/fdm/jsbsim/propulsion/engine[2]/reverser-angle-rad", 3.14);
	} else if ((getprop("/controls/engines/engine[0]/reverser") == "1" or getprop("/controls/engines/engine[1]/reverser") == "1" or getprop("/controls/engines/engine[2]/reverser") == "0") and getprop("/gear/gear[1]/wow") == 1 
	and getprop("/gear/gear[2]/wow") == 1) {
		setprop("/controls/engines/engine[0]/throttle-rev", 0);
		setprop("/controls/engines/engine[1]/throttle-rev", 0);
		setprop("/controls/engines/engine[2]/throttle-rev", 0);
		interpolate("/engines/engine[0]/reverser-pos-norm", 0, 1.0);
		interpolate("/engines/engine[2]/reverser-pos-norm", 0, 1.0);
		interpolate("/engines/engine[1]/reverser-pos-norm", 0, 1.0);
		setprop("/fdm/jsbsim/propulsion/engine[0]/reverser-angle-rad", 0);
		setprop("/fdm/jsbsim/propulsion/engine[1]/reverser-angle-rad", 0);
		setprop("/fdm/jsbsim/propulsion/engine[2]/reverser-angle-rad", 0);
		setprop("/controls/engines/engine[0]/reverser", 0);
		setprop("/controls/engines/engine[1]/reverser", 0);
		setprop("/controls/engines/engine[2]/reverser", 0);
	}
}

var doRevThrust = func {
	if (getprop("/controls/engines/engine[0]/reverser") == "1" and getprop("/controls/engines/engine[1]/reverser") == "1" and getprop("/controls/engines/engine[2]/reverser") == "1" and getprop("/gear/gear[1]/wow") == 1 and getprop("/gear/gear[2]/wow") == 1) {
		var pos1 = getprop("/controls/engines/engine[0]/throttle-rev");
		var pos2 = getprop("/controls/engines/engine[1]/throttle-rev");
		var pos3 = getprop("/controls/engines/engine[2]/throttle-rev");
		if (pos1 < 0.299) {
			setprop("/controls/engines/engine[0]/throttle-rev", pos1 + 0.1);
		}
		if (pos2 < 0.299) {
			setprop("/controls/engines/engine[1]/throttle-rev", pos2 + 0.1);
		}
		if (pos3 < 0.299) {
			setprop("/controls/engines/engine[2]/throttle-rev", pos3 + 0.1);
		}
	}
	var eng1thr = getprop("/controls/engines/engine[0]/throttle-pos");
	var eng2thr = getprop("/controls/engines/engine[1]/throttle-pos");
	var eng3thr = getprop("/controls/engines/engine[2]/throttle-pos");
	if (eng1thr <= 0.05 and eng2thr <= 0.05 and eng3thr <= 0.05 and getprop("/controls/engines/engine[0]/reverser") == "0" and getprop("/controls/engines/engine[1]/reverser") == "0" and getprop("/controls/engines/engine[2]/reverser") == "0" 
	and getprop("/gear/gear[1]/wow") == 1 and getprop("/gear/gear[2]/wow") == 1) {
		setprop("/controls/engines/engine[0]/throttle-rev", 0);
		setprop("/controls/engines/engine[1]/throttle-rev", 0);
		setprop("/controls/engines/engine[2]/throttle-rev", 0);
		interpolate("/engines/engine[0]/reverser-pos-norm", 1, 1.4);
		interpolate("/engines/engine[2]/reverser-pos-norm", 1, 1.4);
		interpolate("/engines/engine[1]/reverser-pos-norm", 1, 1.4);
		setprop("/controls/engines/engine[0]/reverser", 1);
		setprop("/controls/engines/engine[1]/reverser", 1);
		setprop("/controls/engines/engine[2]/reverser", 1);
		setprop("/fdm/jsbsim/propulsion/engine[0]/reverser-angle-rad", 3.14);
		setprop("/fdm/jsbsim/propulsion/engine[1]/reverser-angle-rad", 3.14);
		setprop("/fdm/jsbsim/propulsion/engine[2]/reverser-angle-rad", 3.14);
	}
}

var unRevThrust = func {
	var eng1thr = getprop("/controls/engines/engine[0]/throttle-pos");
	var eng2thr = getprop("/controls/engines/engine[1]/throttle-pos");
	var eng3thr = getprop("/controls/engines/engine[2]/throttle-pos");
	if (eng1thr <= 0.05 and eng2thr <= 0.05 and eng3thr <= 0.05 and (getprop("/controls/engines/engine[0]/reverser") == "1" or getprop("/controls/engines/engine[1]/reverser") == "1" or getprop("/controls/engines/engine[2]/reverser") == "1")) {
		var pos1 = getprop("/controls/engines/engine[0]/throttle-rev");
		var pos2 = getprop("/controls/engines/engine[1]/throttle-rev");
		var pos3 = getprop("/controls/engines/engine[2]/throttle-rev");
		if (pos1 > 0.001) {
			setprop("/controls/engines/engine[0]/throttle-rev", pos1 - 0.1);
		} else {
			unRevThrust_b();
		}
		if (pos2 > 0.001) {
			setprop("/controls/engines/engine[1]/throttle-rev", pos2 - 0.1);
		} else {
			unRevThrust_b();
		}
		if (pos3 > 0.001) {
			setprop("/controls/engines/engine[2]/throttle-rev", pos3 - 0.1);
		} else {
			unRevThrust_b();
		}
	}
}

var unRevThrust_b = func {
	setprop("/controls/engines/engine[0]/throttle-rev", 0);
	setprop("/controls/engines/engine[1]/throttle-rev", 0);
	setprop("/controls/engines/engine[2]/throttle-rev", 0);
	interpolate("/engines/engine[0]/reverser-pos-norm", 0, 1.0);
	interpolate("/engines/engine[2]/reverser-pos-norm", 0, 1.0);
	interpolate("/engines/engine[1]/reverser-pos-norm", 0, 1.0);
	setprop("/fdm/jsbsim/propulsion/engine[0]/reverser-angle-rad", 0);
	setprop("/fdm/jsbsim/propulsion/engine[1]/reverser-angle-rad", 0);
	setprop("/fdm/jsbsim/propulsion/engine[2]/reverser-angle-rad", 0);
	setprop("/controls/engines/engine[0]/reverser", 0);
	setprop("/controls/engines/engine[1]/reverser", 0);
	setprop("/controls/engines/engine[2]/reverser", 0);
}
