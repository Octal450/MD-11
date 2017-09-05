# MD-11 JSB Engine System

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

#####################
# Initializing Vars #
#####################

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
setprop("/controls/APU/on-light", 0);
setprop("/controls/engines/engine[0]/reverser", 0);
setprop("/controls/engines/engine[1]/reverser", 0);
setprop("/controls/engines/engine[2]/reverser", 0);

#############
# Start APU #
#############

setlistener("/controls/APU/start", func {
	if (getprop("/controls/APU/start") == 1) {
	# if (getprop("/controls/APU/start") == 1 and (getprop("/controls/electrical/switches/battery") == 1) or getprop("/systems/electrical/system") {
		if (getprop("/systems/acconfig/autoconfig-running") == 0) {
			interpolate("/systems/apu/n1", apu_max, spinup_time);
			interpolate("/systems/apu/n2", apu_max_n2, spinup_time);
			apu_egt_checkt.start();
			apu_n1_checkt.start();
			apu_oil_drop.start();
			apu_on_ltt.start();
		} else if (getprop("/systems/acconfig/autoconfig-running") == 1) {
			apu_on_ltt.stop();
			setprop("/controls/APU/on-light", 1);
			interpolate("/systems/apu/n1", apu_max, 5);
			interpolate("/systems/apu/n2", apu_max_n2, 5);
			interpolate("/systems/apu/egt", apu_egt_max, 5);
			oilqty = getprop("/systems/apu/oilqty");
			setprop("/systems/apu/oilqty", oilqty - oildrop);
		}
	} else if (getprop("/controls/APU/start") == 0) {
		apu_on_ltt.stop();
		setprop("/controls/APU/on-light", 0);
		apu_egt_checkt.stop();
		apu_egt2_checkt.stop();
		apu_stop();
	}
});

var apu_egt_check = func {
	if (getprop("/systems/apu/n2") >= 28) {
		apu_egt_checkt.stop();
		interpolate("/systems/apu/egt", apu_egt_max, 5);
		apu_egt2_checkt.start();
	}
}

var apu_egt2_check = func {
	if (getprop("/systems/apu/egt") >= 701) {
		apu_egt2_checkt.stop();
		interpolate("/systems/apu/egt", apu_egt_min, 30);
	}
}

var apu_n1_check = func {
	if (getprop("/systems/apu/n2") >= 94.9) {
		apu_oil_drop.stop();
		apu_n1_checkt.stop();
		apu_oil_consumet.start();
	}
}


var apu_oil = func {
	oilqty = getprop("/systems/apu/oilqty");
	setprop("/systems/apu/oilqty", oilqty - 0.1);
}

var apu_oil_consume = func {
	oilqty = getprop("/systems/apu/oilqty");
	setprop("/systems/apu/oilqty", oilqty - 0.1);
}

var apu_on_lt = func {
	if (getprop("/systems/apu/n2") < 94.9) {
		apu_on_lt2 = getprop("/controls/APU/on-light");
		if (apu_on_lt2 == 0) {
			setprop("/controls/APU/on-light", 1);
		} else {
			setprop("/controls/APU/on-light", 0);
		}
	} else {
		apu_on_ltt.stop();
		setprop("/controls/APU/on-light", 1);
	}
}

############
# Stop APU #
############

var apu_stop = func {
	oat = getprop("/environment/temperature-degc");
	apu_oil_consumet.stop();
	interpolate("/systems/apu/n1", 0, 30);
	interpolate("/systems/apu/n2", 0, 30);
	interpolate("/systems/apu/egt", oat, 40);
}

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
		setprop("/controls/engines/engine[0]/throttle-rev", 0.25);
		setprop("/controls/engines/engine[1]/throttle-rev", 0.25);
		setprop("/controls/engines/engine[2]/throttle-rev", 0.25);
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
		if (pos1 < 0.25) {
			setprop("/controls/engines/engine[0]/throttle-rev", pos1 + 0.167);
		}
		if (pos2 < 0.25) {
			setprop("/controls/engines/engine[1]/throttle-rev", pos2 + 0.167);
		}
		if (pos3 < 0.25) {
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

##########
# Timers #
##########

var apu_egt_checkt = maketimer(0.5, apu_egt_check);
var apu_egt2_checkt = maketimer(0.5, apu_egt2_check);
var apu_on_ltt = maketimer(0.5, apu_on_lt);
var apu_n1_checkt = maketimer(0.5, apu_n1_check);
var apu_oil_drop = maketimer(5, apu_oil);
var apu_oil_consumet = maketimer(3600, apu_oil_consume); # 0.1 qt per hour, so around 80 hours till it runs done
