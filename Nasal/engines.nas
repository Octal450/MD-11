# MD-11 JSB Engine System

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

#####################
# Initializing Vars #
#####################

setprop("/controls/engines/engine[0]/reverser", 0);
setprop("/controls/engines/engine[1]/reverser", 0);
setprop("/controls/engines/engine[2]/reverser", 0);

#######################
# Various other stuff #
#######################

var doIdleThrust = func {
	setprop("/controls/engines/engine[0]/throttle", 0.0);
	setprop("/controls/engines/engine[1]/throttle", 0.0);
	setprop("/controls/engines/engine[2]/throttle", 0.0);
}

#########################
# Reverse Thrust System #
#########################

var toggleFastRevThrust = func {
	var eng1thr = getprop("/controls/engines/engine[0]/throttle-pos");
	var eng2thr = getprop("/controls/engines/engine[1]/throttle-pos");
	var eng3thr = getprop("/controls/engines/engine[2]/throttle-pos");
	if (eng1thr <= 0.05 and eng2thr <= 0.05 and eng3thr <= 0.05 and getprop("/controls/engines/engine[0]/reverser") == "0" and getprop("/controls/engines/engine[1]/reverser") == "0" and getprop("/controls/engines/engine[2]/reverser") == "0" 
	and getprop("/gear/gear[1]/wow") == 1 and getprop("/gear/gear[2]/wow") == 1) {
		interpolate("/engines/engine[0]/reverser-pos-norm", 1, 1.4);
		interpolate("/engines/engine[1]/reverser-pos-norm", 1, 1.4);
		interpolate("/engines/engine[2]/reverser-pos-norm", 1, 1.4);
		setprop("/controls/engines/engine[0]/reverser", 1);
		setprop("/controls/engines/engine[1]/reverser", 1);
		setprop("/controls/engines/engine[2]/reverser", 1);
		setprop("/controls/engines/engine[0]/throttle-rev", 0.5);
		setprop("/controls/engines/engine[1]/throttle-rev", 0.5);
		setprop("/controls/engines/engine[2]/throttle-rev", 0.5);
		setprop("/fdm/jsbsim/propulsion/engine[0]/reverser-angle-rad", 3.14);
		setprop("/fdm/jsbsim/propulsion/engine[1]/reverser-angle-rad", 3.14);
		setprop("/fdm/jsbsim/propulsion/engine[2]/reverser-angle-rad", 3.14);
	} else if ((getprop("/controls/engines/engine[0]/reverser") == "1" or getprop("/controls/engines/engine[1]/reverser") == "1" or getprop("/controls/engines/engine[2]/reverser") == "0") and getprop("/gear/gear[1]/wow") == 1 
	and getprop("/gear/gear[2]/wow") == 1) {
		setprop("/controls/engines/engine[0]/throttle-rev", 0);
		setprop("/controls/engines/engine[1]/throttle-rev", 0);
		setprop("/controls/engines/engine[2]/throttle-rev", 0);
		interpolate("/engines/engine[0]/reverser-pos-norm", 0, 1.0);
		interpolate("/engines/engine[1]/reverser-pos-norm", 0, 1.0);
		interpolate("/engines/engine[2]/reverser-pos-norm", 0, 1.0);
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
		if (pos1 < 0.5) {
			setprop("/controls/engines/engine[0]/throttle-rev", pos1 + 0.167);
		}
		if (pos2 < 0.5) {
			setprop("/controls/engines/engine[1]/throttle-rev", pos2 + 0.167);
		}
		if (pos3 < 0.5) {
			setprop("/controls/engines/engine[2]/throttle-rev", pos3 + 0.167);
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
		interpolate("/engines/engine[1]/reverser-pos-norm", 1, 1.4);
		interpolate("/engines/engine[2]/reverser-pos-norm", 1, 1.4);
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
		if (pos1 > 0.0) {
			setprop("/controls/engines/engine[0]/throttle-rev", pos1 - 0.167);
		} else {
			unRevThrust_b();
		}
		if (pos2 > 0.0) {
			setprop("/controls/engines/engine[1]/throttle-rev", pos2 - 0.167);
		} else {
			unRevThrust_b();
		}
		if (pos3 > 0.0) {
			setprop("/controls/engines/engine[2]/throttle-rev", pos3 - 0.167);
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
	interpolate("/engines/engine[1]/reverser-pos-norm", 0, 1.0);
	interpolate("/engines/engine[2]/reverser-pos-norm", 0, 1.0);
	setprop("/fdm/jsbsim/propulsion/engine[0]/reverser-angle-rad", 0);
	setprop("/fdm/jsbsim/propulsion/engine[1]/reverser-angle-rad", 0);
	setprop("/fdm/jsbsim/propulsion/engine[2]/reverser-angle-rad", 0);
	setprop("/controls/engines/engine[0]/reverser", 0);
	setprop("/controls/engines/engine[1]/reverser", 0);
	setprop("/controls/engines/engine[2]/reverser", 0);
}
