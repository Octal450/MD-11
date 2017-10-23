# MD-11 Pneumatic System
# Joshua Davidson (it0uchpods)

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

#############
# Init Vars #
#############

setlistener("/sim/signals/fdm-initialized", func {

});

var pneu_init = func {
	setprop("/controls/pneumatic/switches/bleed1", 1);
	setprop("/controls/pneumatic/switches/bleed2", 1);
	setprop("/controls/pneumatic/switches/bleed3", 1);
	setprop("/controls/pneumatic/switches/bleedapu", 1);
	setprop("/controls/pneumatic/switches/groundair", 0);
	setprop("/controls/pneumatic/switches/isol1-2", 0);
	setprop("/controls/pneumatic/switches/isol1-3", 0);
	setprop("/controls/pneumatic/switches/pack1", 1);
	setprop("/controls/pneumatic/switches/pack2", 1);
	setprop("/controls/pneumatic/switches/pack3", 1);
	setprop("/systems/pneumatic/system", 1); # Automatic
	setprop("/systems/pneumatic/bleed1", 0);
	setprop("/systems/pneumatic/bleed2", 0);
	setprop("/systems/pneumatic/bleed3", 0);
	setprop("/systems/pneumatic/bleedapu", 0);
	setprop("/systems/pneumatic/groundair", 0);
	setprop("/systems/pneumatic/total-psi", 0);
	setprop("/systems/pneumatic/start-psi", 0);
	setprop("/systems/pneumatic/pack-psi", 0);
	setprop("/systems/pneumatic/pack1", 0);
	setprop("/systems/pneumatic/pack2", 0);
	setprop("/systems/pneumatic/pack3", 0);
	setprop("/systems/pneumatic/start-psi", 0);
	setprop("/systems/pneumatic/eng1-starter", 0);
	setprop("/controls/pneumatic/switches/manual-flash", 0);
	manualPneuLightt.stop();
	pneu_timer.start();
}

#######################
# Main Pneumatic Loop #
#######################

var master_pneu = func {

}

var systemPneuMode = func {
	system = getprop("/systems/pneumatic/system");
	if (system) {
		setprop("/systems/pneumatic/system", 0);
		setprop("/controls/pneumatic/switches/manual-lt", 1);
	} else {
		setprop("/systems/pneumatic/system", 1);
		setprop("/controls/pneumatic/switches/manual-lt", 0);
	}
}

var manualPneuLight = func {
	var manl = getprop("/controls/pneumatic/switches/manual-flash");
	if (manl >= 5) {
		manualPneuLightt.stop();
		setprop("/controls/pneumatic/switches/manual-flash", 0);
	} else {
		setprop("/controls/pneumatic/switches/manual-flash", manl + 1);
	}
}

###################
# Update Function #
###################

var update_pneumatic = func {
	master_pneu();
}

##########
# Timers #
##########

var pneu_timer = maketimer(0.2, update_pneumatic);
var manualPneuLightt = maketimer(0.4, manualPneuLight);
