# Temporary until proper systems are available
# Joshua Davidson (it0uchpods)
# ;)

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

setprop("/systems/electrical/outputs/efis", 0);

var doMagicStartup = func {
	setprop("/systems/electrical/outputs/avionics", 25);
	setprop("/systems/electrical/outputs/efis", 25);
	setprop("/controls/engines/ignition-mode", "A");
	setprop("/controls/engines/engine[0]/starter", "true");
	setprop("/controls/engines/engine[1]/starter", "true");
	setprop("/controls/engines/engine[2]/starter", "true");
	settimer(func {
		setprop("/controls/engines/engine[0]/cutoff", "false");
		setprop("/controls/engines/engine[1]/cutoff", "false");
		setprop("/controls/engines/engine[2]/cutoff", "false");
		setprop("/engines/engine[0]/state", 3);
		setprop("/engines/engine[1]/state", 3);
		setprop("/engines/engine[2]/state", 3);
	}, 7.5);
}