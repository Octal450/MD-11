# MD-11 Pneumatic System
# Joshua Davidson (it0uchpods)

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

#############
# Init Vars #
#############

setprop("/controls/pneumatic/switches/cockpit-temp", 0.5);
setprop("/controls/pneumatic/switches/fwd-temp", 0.5);
setprop("/controls/pneumatic/switches/mid-temp", 0.5);
setprop("/controls/pneumatic/switches/aft-temp", 0.5);

setlistener("/sim/signals/fdm-initialized", func {
	var system = getprop("/systems/pneumatic/system");
	var bleed1_sw = getprop("/controls/pneumatic/switches/bleed1");
	var bleed2_sw = getprop("/controls/pneumatic/switches/bleed2");
	var bleed3_sw = getprop("/controls/pneumatic/switches/bleed3");
	var bleedapu_sw = getprop("/controls/pneumatic/switches/bleedapu");
	var groundair_sw = getprop("/controls/pneumatic/switches/groundair");
	var isol1_2_sw = getprop("/controls/pneumatic/switches/isol1-2");
	var isol1_3_sw = getprop("/controls/pneumatic/switches/isol1-3");
	var pack1_sw = getprop("/controls/pneumatic/switches/pack1");
	var pack2_sw = getprop("/controls/pneumatic/switches/pack2");
	var pack3_sw = getprop("/controls/pneumatic/switches/pack3");
	var bleed1 = getprop("/systems/pneumatic/bleed1");
	var bleed2 = getprop("/systems/pneumatic/bleed2");
	var bleed3 = getprop("/systems/pneumatic/bleed3");
	var bleedapu = getprop("/systems/pneumatic/bleedapu");
	var groundair = getprop("/systems/pneumatic/groundair");
	var total_psi = getprop("/systems/pneumatic/total-psi");
	var start_psi = getprop("/systems/pneumatic/start-psi");
	var pack_psi = getprop("/systems/pneumatic/pack-psi");
	var pack1 = getprop("/systems/pneumatic/pack1");
	var pack2 = getprop("/systems/pneumatic/pack2");
	var pack3 = getprop("/systems/pneumatic/pack3");
	var eng_starter = getprop("/systems/pneumatic/eng-starter");
	var state1 = getprop("/engines/engine[0]/state");
	var state2 = getprop("/engines/engine[1]/state");
	var state3 = getprop("/engines/engine[2]/state");
	var rpmapu = getprop("/systems/apu/n2");
	var total_psi_calc = 0;
});

var PNEU = {
	init: func() {
		setprop("/controls/pneumatic/switches/bleed1", 1);
		setprop("/controls/pneumatic/switches/bleed2", 1);
		setprop("/controls/pneumatic/switches/bleed3", 1);
		setprop("/controls/pneumatic/switches/bleedapu", 0);
		setprop("/controls/pneumatic/switches/groundair", 0);
		setprop("/controls/pneumatic/switches/isol1-2", 0);
		setprop("/controls/pneumatic/switches/isol1-3", 0);
		setprop("/controls/pneumatic/switches/pack1", 1);
		setprop("/controls/pneumatic/switches/pack2", 1);
		setprop("/controls/pneumatic/switches/pack3", 1);
		setprop("/controls/pneumatic/switches/avionics-fan", 1);
		setprop("/controls/pneumatic/switches/econ", 1);
		setprop("/controls/pneumatic/switches/trim-air", 1);
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
		setprop("/systems/pneumatic/eng-starter", 0);
		setprop("/systems/pneumatic/light/pack1-flow", 0);
		setprop("/systems/pneumatic/light/pack2-flow", 0);
		setprop("/systems/pneumatic/light/pack3-flow", 0);
		setprop("/systems/pneumatic/light/select-manual", 0);
		setprop("/controls/pneumatic/switches/manual-flash", 0);
		manualPneuLightt.stop();
	},
	loop: func() {
		system = getprop("/systems/pneumatic/system");
		bleed1_sw = getprop("/controls/pneumatic/switches/bleed1");
		bleed2_sw = getprop("/controls/pneumatic/switches/bleed2");
		bleed3_sw = getprop("/controls/pneumatic/switches/bleed3");
		bleedapu_sw = getprop("/controls/pneumatic/switches/bleedapu");
		groundair_sw = getprop("/controls/pneumatic/switches/groundair");
		isol1_2_sw = getprop("/controls/pneumatic/switches/isol1-2");
		isol1_3_sw = getprop("/controls/pneumatic/switches/isol1-3");
		pack1_sw = getprop("/controls/pneumatic/switches/pack1");
		pack2_sw = getprop("/controls/pneumatic/switches/pack2");
		pack3_sw = getprop("/controls/pneumatic/switches/pack3");
		eng_starter = getprop("/systems/pneumatic/eng-starter");
		state1 = getprop("/engines/engine[0]/state");
		state2 = getprop("/engines/engine[1]/state");
		state3 = getprop("/engines/engine[2]/state");
		rpmapu = getprop("/systems/apu/n2");
		
		# PSC FIXME: (Temporary, until I find more info on how the automatic functions work) -JD
		if (system) {
			setprop("/controls/pneumatic/switches/bleed1", 1);
			setprop("/controls/pneumatic/switches/bleed2", 1);
			setprop("/controls/pneumatic/switches/bleed3", 1);
			setprop("/controls/pneumatic/switches/isol1-2", 0);
			setprop("/controls/pneumatic/switches/isol1-3", 0);
			if (getprop("/controls/pneumatic/switches/pack1") != 1) {
				setprop("/controls/pneumatic/switches/pack1", 1);
			}
			if (getprop("/controls/pneumatic/switches/pack2") != 1) {
				setprop("/controls/pneumatic/switches/pack2", 1);
			}
			if (getprop("/controls/pneumatic/switches/pack3") != 1) {
				setprop("/controls/pneumatic/switches/pack3", 1);
			}
		}
		
		# Air Sources/PSI
		if (rpmapu >= 94.9 and bleedapu_sw) {
			setprop("/systems/pneumatic/bleedapu", 34);
		} else {
			setprop("/systems/pneumatic/bleedapu", 0);
		}
		
		if (groundair_sw) {
			setprop("/systems/pneumatic/groundair", 39);
		} else {
			setprop("/systems/pneumatic/groundair", 0);
		}
		
		bleedapu = getprop("/systems/pneumatic/bleedapu");
		groundair = getprop("/systems/pneumatic/groundair");
		
		if (state1 == 3 and bleed1_sw) {
			setprop("/systems/pneumatic/bleed1", 31);
		} else {
			setprop("/systems/pneumatic/bleed1", 0);
		}
		
		if (state2 == 3 and bleed2_sw) {
			setprop("/systems/pneumatic/bleed2", 32);
		} else {
			setprop("/systems/pneumatic/bleed2", 0);
		}
		
		if (state3 == 3 and bleed3_sw) {
			setprop("/systems/pneumatic/bleed3", 31);
		} else {
			setprop("/systems/pneumatic/bleed3", 0);
		}
		
		bleed1 = getprop("/systems/pneumatic/bleed1");
		bleed2 = getprop("/systems/pneumatic/bleed2");
		bleed3 = getprop("/systems/pneumatic/bleed3");
		
		if (state1 == 1 or state2 == 1 or state3 == 1) {
			setprop("/systems/pneumatic/start-psi", 18);
		} else {
			setprop("/systems/pneumatic/start-psi", 0);
		}
		
		if (pack1_sw == 1 and (bleed1 >= 11 or bleedapu >= 11 or groundair >= 11) and eng_starter == 0) {
			setprop("/systems/pneumatic/pack1", 9);
		} else {
			setprop("/systems/pneumatic/pack1", 0);
		}
		
		if (pack2_sw == 1 and (bleed2 >= 11 or bleedapu >= 11 or groundair >= 11) and eng_starter == 0) {
			setprop("/systems/pneumatic/pack2", 9);
		} else {
			setprop("/systems/pneumatic/pack2", 0);
		}
		
		if (pack3_sw == 1 and (bleed3 >= 11 or bleedapu >= 11 or groundair >= 11) and eng_starter == 0) {
			setprop("/systems/pneumatic/pack3", 9);
		} else {
			setprop("/systems/pneumatic/pack3", 0);
		}
		
		pack1 = getprop("/systems/pneumatic/pack1");
		pack2 = getprop("/systems/pneumatic/pack2");
		pack3 = getprop("/systems/pneumatic/pack3");
		
		if (pack1_sw == 1 and pack2_sw == 1 and pack3_sw == 1) {
			setprop("/systems/pneumatic/pack-psi", pack1 + pack2 + pack3);
		} else if (pack1_sw == 0 and pack2_sw == 0 and pack3_sw == 0) {
			setprop("/systems/pneumatic/pack-psi", 0);
		} else {
			setprop("/systems/pneumatic/pack-psi", pack1 + pack2 + pack3 + 5);
		}
		
		start_psi = getprop("/systems/pneumatic/start-psi");
		pack_psi = getprop("/systems/pneumatic/pack-psi");
		
		if ((bleed1 + bleed2 + bleed3 + bleedapu) > 42) {
			setprop("/systems/pneumatic/total-psi", 42);
		} else {
			total_psi_calc = ((bleed1 + bleed2 + bleed3 + bleedapu + groundair) - start_psi - pack_psi);
			setprop("/systems/pneumatic/total-psi", total_psi_calc);
		}
		
		total_psi = getprop("/systems/pneumatic/total-psi");
	},
	systemMode: func() {
		system = getprop("/systems/pneumatic/system");
		if (system) {
			setprop("/systems/pneumatic/system", 0);
			setprop("/controls/pneumatic/switches/manual-lt", 1);
		} else {
			setprop("/systems/pneumatic/system", 1);
			setprop("/controls/pneumatic/switches/manual-lt", 0);
		}
	},
	manualLight: func() {
		var manl = getprop("/controls/pneumatic/switches/manual-flash");
		if (manl >= 5) {
			manualPneuLightt.stop();
			setprop("/controls/pneumatic/switches/manual-flash", 0);
		} else {
			setprop("/controls/pneumatic/switches/manual-flash", manl + 1);
		}
	},
};

#######################
# Various Other Stuff #
#######################

setlistener("/controls/pneumatic/switches/pack1", func {
	if (getprop("/controls/pneumatic/switches/pack1") == 1) {
		setprop("/systems/pneumatic/light/pack1-flow", 1);
		settimer(func {
			setprop("/systems/pneumatic/light/pack1-flow", 0);
		}, 1);
	}
});

setlistener("/controls/pneumatic/switches/pack2", func {
	if (getprop("/controls/pneumatic/switches/pack2") == 1) {
		setprop("/systems/pneumatic/light/pack2-flow", 1);
		settimer(func {
			setprop("/systems/pneumatic/light/pack2-flow", 0);
		}, 1);
	}
});

setlistener("/controls/pneumatic/switches/pack3", func {
	if (getprop("/controls/pneumatic/switches/pack3") == 1) {
		setprop("/systems/pneumatic/light/pack3-flow", 1);
		settimer(func {
			setprop("/systems/pneumatic/light/pack3-flow", 0);
		}, 1);
	}
});

var manualPneuLightt = maketimer(0.4, PNEU.manualLight);
