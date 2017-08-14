# Temporary until proper systems are available
# Joshua Davidson (it0uchpods)
# ;)

########################################
# Copyright (c) MD-11 Development Team #
########################################

var doMagicStartup = func {
	setprop("/systems/electrical/outputs/avionics", 25);
	setprop("/systems/electrical/outputs/efis", 25);
	setprop("/controls/engines/engine[0]/starter", "true");
	setprop("/controls/engines/engine[1]/starter", "true");
	setprop("/controls/engines/engine[2]/starter", "true");
	settimer(func {
		setprop("/controls/engines/engine[0]/cutoff", "false");
		setprop("/controls/engines/engine[1]/cutoff", "false");
		setprop("/controls/engines/engine[2]/cutoff", "false");
	}, 10);
}