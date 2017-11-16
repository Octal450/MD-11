# Temporary until proper systems are available
# Joshua Davidson (it0uchpods)
# ;)

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

var doMagicStartup = func {
	setprop("/controls/engines/engine[0]/cutoff", 0);
	setprop("/controls/engines/engine[1]/cutoff", 0);
	setprop("/controls/engines/engine[2]/cutoff", 0);
	setprop("/engines/engine[0]/out-of-fuel", 0);
	setprop("/engines/engine[1]/out-of-fuel", 0);
	setprop("/engines/engine[2]/out-of-fuel", 0);
	setprop("/engines/engine[0]/run", 1);
	setprop("/engines/engine[1]/run", 1);
	setprop("/engines/engine[2]/run", 1);
	setprop("/engines/engine[0]/cutoff", 0);
	setprop("/engines/engine[1]/cutoff", 0);
	setprop("/engines/engine[2]/cutoff", 0);
	setprop("/engines/engine[0]/starter", 0);
	setprop("/engines/engine[1]/starter", 0);
	setprop("/engines/engine[2]/starter", 0);
	setprop("/fdm/jsbsim/propulsion/set-running", 0);
	setprop("/fdm/jsbsim/propulsion/set-running", 1);
	setprop("/fdm/jsbsim/propulsion/set-running", 2);
	setprop("/engines/engine[0]/state", 3);
	setprop("/engines/engine[1]/state", 3);
	setprop("/engines/engine[2]/state", 3);
	setprop("/controls/electrical/switches/battery", 1);
	setprop("/controls/electrical/switches/emer-pw-sw", 1);
}