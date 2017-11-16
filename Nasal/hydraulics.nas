# MD-11 Hydraulic System
# Joshua Davidson (it0uchpods)

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

#############
# Init Vars #
#############

setlistener("/sim/signals/fdm-initialized", func {
	var LPump1_sw = getprop("/controls/hydraulic/switches/LPump1");
	var RPump1_sw = getprop("/controls/hydraulic/switches/RPump1");
	var LPump2_sw = getprop("/controls/hydraulic/switches/LPump2");
	var RPump2_sw = getprop("/controls/hydraulic/switches/RPump2");
	var LPump3_sw = getprop("/controls/hydraulic/switches/LPump3");
	var RPump3_sw = getprop("/controls/hydraulic/switches/RPump3");
	var RMP1_3_sw = getprop("/controls/hydraulic/switches/RMP1-3");
	var RMP2_3_sw = getprop("/controls/hydraulic/switches/RMP2-3");	
	var auxPump1_sw = getprop("/controls/hydraulic/switches/AuxPump1");
	var auxPump2_sw = getprop("/controls/hydraulic/switches/AuxPump2");
	var press_test = getprop("/controls/hydraulic/switches/press-test");
	var system = getprop("/systems/hydraulic/system");
	var sys1_psi = getprop("/systems/hydraulic/sys1-psi");
	var sys2_psi = getprop("/systems/hydraulic/sys2-psi");
	var sys3_psi = getprop("/systems/hydraulic/sys3-psi");
	var state1 = getprop("/engines/engine[0]/state");
	var state2 = getprop("/engines/engine[1]/state");
	var state3 = getprop("/engines/engine[2]/state");
	var N21 = getprop("/engines/engine[0]/n2-actual");
	var N22 = getprop("/engines/engine[1]/n2-actual");
	var N23 = getprop("/engines/engine[2]/n2-actual");
	var src1 = "XX";
	var src2 = "XX";
	var src3 = "XX";
	var wow = getprop("/gear/gear[3]/wow");
});

var hyd_init = func {
	setprop("/controls/hydraulic/switches/LPump1", 1);
	setprop("/controls/hydraulic/switches/RPump1", 1);
	setprop("/controls/hydraulic/switches/LPump2", 1);
	setprop("/controls/hydraulic/switches/RPump2", 1);
	setprop("/controls/hydraulic/switches/LPump3", 1);
	setprop("/controls/hydraulic/switches/RPump3", 1);
	setprop("/controls/hydraulic/switches/RMP1-3", 0);
	setprop("/controls/hydraulic/switches/RMP2-3", 0);
	setprop("/controls/hydraulic/switches/manual-lt", 0);
	setprop("/controls/hydraulic/switches/AuxPump1", 0);
	setprop("/controls/hydraulic/switches/AuxPump2", 0);
	setprop("/controls/hydraulic/switches/press-test", 0);
	setprop("/systems/hydraulic/system", 1); # Automatic
	setprop("/systems/hydraulic/sys1-psi", 0);
	setprop("/systems/hydraulic/sys2-psi", 0);
	setprop("/systems/hydraulic/sys3-psi", 0);
	setprop("/systems/hydraulic/light/LPump1-fault", 1);
	setprop("/systems/hydraulic/light/RPump1-fault", 1);
	setprop("/systems/hydraulic/light/LPump2-fault", 1);
	setprop("/systems/hydraulic/light/RPump2-fault", 1);
	setprop("/systems/hydraulic/light/LPump3-fault", 1);
	setprop("/systems/hydraulic/light/RPump3-fault", 1);
	setprop("/systems/hydraulic/light/RMP1-3-disag", 0);
	setprop("/systems/hydraulic/light/RMP2-3-disag", 0);
	setprop("/systems/hydraulic/light/select-manual", 0);
	setprop("/systems/hydraulic/source/sys1", "XX");
	setprop("/systems/hydraulic/source/sys2", "XX");
	setprop("/systems/hydraulic/source/sys3", "XX");
	setprop("/controls/hydraulic/switches/manual-flash", 0);
	manualHydLightt.stop();
	hyd_timer.start();
}

#######################
# Main Hydraulic Loop #
#######################

var master_hyd = func {
	system = getprop("/systems/hydraulic/system");
	sys1_psi = getprop("/systems/hydraulic/sys1-psi");
	sys2_psi = getprop("/systems/hydraulic/sys2-psi");
	sys3_psi = getprop("/systems/hydraulic/sys3-psi");
	state1 = getprop("/engines/engine[0]/state");
	state2 = getprop("/engines/engine[1]/state");
	state3 = getprop("/engines/engine[2]/state");
	N21 = getprop("/engines/engine[0]/n2-actual");
	N22 = getprop("/engines/engine[1]/n2-actual");
	N23 = getprop("/engines/engine[2]/n2-actual");
	wow = getprop("/gear/gear[3]/wow");
	
	# HSC
	if (system) {
		setprop("/controls/hydraulic/switches/LPump1", 1);
		setprop("/controls/hydraulic/switches/RPump1", 1);
		setprop("/controls/hydraulic/switches/LPump2", 1);
		setprop("/controls/hydraulic/switches/RPump2", 1);
		setprop("/controls/hydraulic/switches/LPump3", 1);
		setprop("/controls/hydraulic/switches/RPump3", 1);
		if ((N21 < 45 or N22 < 45 or N23 < 45) and !wow) {
			if (getprop("/controls/hydraulic/switches/RMP1-3") != 1) {
				setprop("/controls/hydraulic/switches/RMP1-3", 1);
			}
			if (getprop("/controls/hydraulic/switches/RMP2-3") != 1) {
				setprop("/controls/hydraulic/switches/RMP2-3", 1);
			}
		} else if (((N21 < 45 and N22 < 45) or (N21 < 45 and N23 < 45) or (N22 < 45 and N23 < 45)) and !wow) {
			if (getprop("/controls/hydraulic/switches/RMP1-3") != 1) {
				setprop("/controls/hydraulic/switches/RMP1-3", 1);
			}
			if (getprop("/controls/hydraulic/switches/RMP2-3") != 1) {
				setprop("/controls/hydraulic/switches/RMP2-3", 1);
			}
		} else {
			if (getprop("/controls/hydraulic/switches/RMP1-3") != 0) {
				setprop("/controls/hydraulic/switches/RMP1-3", 0);
			}
			if (getprop("/controls/hydraulic/switches/RMP2-3") != 0) {
				setprop("/controls/hydraulic/switches/RMP2-3", 0);
			}
		}
	}
	
	LPump1_sw = getprop("/controls/hydraulic/switches/LPump1");
	RPump1_sw = getprop("/controls/hydraulic/switches/RPump1");
	LPump2_sw = getprop("/controls/hydraulic/switches/LPump2");
	RPump2_sw = getprop("/controls/hydraulic/switches/RPump2");
	LPump3_sw = getprop("/controls/hydraulic/switches/LPump3");
	RPump3_sw = getprop("/controls/hydraulic/switches/RPump3");
	RMP1_3_sw = getprop("/controls/hydraulic/switches/RMP1-3");
	RMP2_3_sw = getprop("/controls/hydraulic/switches/RMP2-3");
	auxPump1_sw = getprop("/controls/hydraulic/switches/AuxPump1");
	auxPump2_sw = getprop("/controls/hydraulic/switches/AuxPump2");
	press_test = getprop("/controls/hydraulic/switches/press-test");
	sys3_psi = getprop("/systems/hydraulic/sys3-psi");
	src3 = getprop("/systems/hydraulic/source/sys3");
	
	if ((LPump1_sw or RPump1_sw) and state1 == 3) {
		setprop("/systems/hydraulic/source/sys1", "ENG");
		if (sys1_psi < 2900) {
			setprop("/systems/hydraulic/sys1-psi", sys1_psi + 100);
		} else {
			setprop("/systems/hydraulic/sys1-psi", 3000);
		}
	} else if (RMP1_3_sw and sys3_psi >= 2400 and src3 != "RMP1" and src3 != "XX") {
		setprop("/systems/hydraulic/source/sys1", "RMP");
		if (sys1_psi < 2900) {
			setprop("/systems/hydraulic/sys1-psi", sys1_psi + 100);
		} else {
			setprop("/systems/hydraulic/sys1-psi", 3000);
		}
	} else {
		setprop("/systems/hydraulic/source/sys1", "XX");
		if (sys1_psi > 1) {
			setprop("/systems/hydraulic/sys1-psi", sys1_psi - 50);
		} else {
			setprop("/systems/hydraulic/sys1-psi", 0);
		}
	}
	
	src1 = getprop("/systems/hydraulic/source/sys1");
	
	if ((LPump2_sw or RPump2_sw) and state2 == 3) {
		setprop("/systems/hydraulic/source/sys2", "ENG");
		if (sys2_psi < 2900) {
			setprop("/systems/hydraulic/sys2-psi", sys2_psi + 100);
		} else {
			setprop("/systems/hydraulic/sys2-psi", 3000);
		}
	} else if (RMP2_3_sw and sys3_psi >= 2400 and src3 != "RMP2" and src3 != "XX") {
		setprop("/systems/hydraulic/source/sys2", "RMP");
		if (sys2_psi < 2900) {
			setprop("/systems/hydraulic/sys2-psi", sys2_psi + 100);
		} else {
			setprop("/systems/hydraulic/sys2-psi", 3000);
		}
	} else {
		setprop("/systems/hydraulic/source/sys2", "XX");
		if (sys2_psi > 1) {
			setprop("/systems/hydraulic/sys2-psi", sys2_psi - 50);
		} else {
			setprop("/systems/hydraulic/sys2-psi", 0);
		}
	}
	
	sys1_psi = getprop("/systems/hydraulic/sys1-psi");
	sys2_psi = getprop("/systems/hydraulic/sys2-psi");
	src2 = getprop("/systems/hydraulic/source/sys2");
	
	if ((LPump3_sw or RPump3_sw) and state3 == 3) {
		setprop("/systems/hydraulic/source/sys3", "ENG");
		if (sys3_psi < 2900) {
			setprop("/systems/hydraulic/sys3-psi", sys3_psi + 100);
		} else {
			setprop("/systems/hydraulic/sys3-psi", 3000);
		}
	} else if (RMP1_3_sw and sys1_psi >= 2400 and src1 != "RMP" and src1 != "XX") {
		setprop("/systems/hydraulic/source/sys3", "RMP1");
		if (sys3_psi < (sys1_psi - 100)) {
			setprop("/systems/hydraulic/sys3-psi", sys3_psi + 100);
		} else {
			setprop("/systems/hydraulic/sys3-psi", sys1_psi);
		}
	} else if (RMP2_3_sw and sys2_psi >= 2400 and src2 != "RMP" and src2 != "XX") {
		setprop("/systems/hydraulic/source/sys3", "RMP2");
		if (sys3_psi < (sys2_psi - 100)) {
			setprop("/systems/hydraulic/sys3-psi", sys3_psi + 100);
		} else {
			setprop("/systems/hydraulic/sys3-psi", sys2_psi);
		}
	} else if (auxPump1_sw or auxPump2_sw) {
		setprop("/systems/hydraulic/source/sys3", "AUX");
		if (sys3_psi < 2900) {
			setprop("/systems/hydraulic/sys3-psi", sys3_psi + 100);
		} else {
			setprop("/systems/hydraulic/sys3-psi", 3000);
		}
	} else {
		setprop("/systems/hydraulic/source/sys3", "XX");
		if (sys3_psi > 1) {
			setprop("/systems/hydraulic/sys3-psi", sys3_psi - 50);
		} else {
			setprop("/systems/hydraulic/sys3-psi", 0);
		}
	}
	
	if (N21 < 45 and LPump1_sw) {
		setprop("/systems/hydraulic/light/LPump1-fault", 1);
	} else {
		setprop("/systems/hydraulic/light/LPump1-fault", 0);
	}
	
	if (N21 < 45 and RPump1_sw) {
		setprop("/systems/hydraulic/light/RPump1-fault", 1);
	} else {
		setprop("/systems/hydraulic/light/RPump1-fault", 0);
	}
	
	if (N22 < 45 and LPump2_sw) {
		setprop("/systems/hydraulic/light/LPump2-fault", 1);
	} else {
		setprop("/systems/hydraulic/light/LPump2-fault", 0);
	}
	
	if (N22 < 45 and RPump2_sw) {
		setprop("/systems/hydraulic/light/RPump2-fault", 1);
	} else {
		setprop("/systems/hydraulic/light/RPump2-fault", 0);
	}
	
	if (N23 < 45 and LPump3_sw) {
		setprop("/systems/hydraulic/light/LPump3-fault", 1);
	} else {
		setprop("/systems/hydraulic/light/LPump3-fault", 0);
	}
	
	if (N23 < 45 and RPump3_sw) {
		setprop("/systems/hydraulic/light/RPump3-fault", 1);
	} else {
		setprop("/systems/hydraulic/light/RPump3-fault", 0);
	}
}

var systemHydMode = func {
	system = getprop("/systems/hydraulic/system");
	sys3_psi = getprop("/systems/hydraulic/sys3-psi");
	src3 = getprop("/systems/hydraulic/source/sys3");
	if (system) {
		setprop("/systems/hydraulic/system", 0);
		setprop("/controls/hydraulic/HSC/RMP1-3", 1);
		setprop("/controls/hydraulic/HSC/RMP2-3", 1);
		setprop("/controls/hydraulic/switches/manual-lt", 1);
	} else {
		setprop("/systems/hydraulic/system", 1);
		if (sys3_psi >= 2400 and src3 != "AUX") {
			setprop("/controls/hydraulic/switches/AuxPump1", 0);
			setprop("/controls/hydraulic/switches/AuxPump2", 0);
		}
		setprop("/controls/hydraulic/switches/manual-lt", 0);
	}
}

var manualHydLight = func {
	var manl = getprop("/controls/hydraulic/switches/manual-flash");
	if (manl >= 5) {
		manualHydLightt.stop();
		setprop("/controls/hydraulic/switches/manual-flash", 0);
	} else {
		setprop("/controls/hydraulic/switches/manual-flash", manl + 1);
	}
}

#######################
# Various Other Stuff #
#######################

setlistener("/controls/gear/gear-down", func {
	down = getprop("/controls/gear/gear-down");
	if (!down and (getprop("/gear/gear[0]/wow") or getprop("/gear/gear[1]/wow") or getprop("/gear/gear[2]/wow"))) {
		setprop("/controls/gear/gear-down", 1);
	}
});

setlistener("/controls/hydraulic/switches/RMP1-3", func {
	setprop("/systems/hydraulic/light/RMP1-3-disag", 1);
	settimer(func {
		setprop("/systems/hydraulic/light/RMP1-3-disag", 0);
	}, 1);
});

setlistener("/controls/hydraulic/switches/RMP2-3", func {
	setprop("/systems/hydraulic/light/RMP2-3-disag", 1);
	settimer(func {
		setprop("/systems/hydraulic/light/RMP2-3-disag", 0);
	}, 1);
});

###################
# Update Function #
###################

var update_hydraulic = func {
	master_hyd();
}

var hyd_timer = maketimer(0.2, update_hydraulic);
var manualHydLightt = maketimer(0.4, manualHydLight);
