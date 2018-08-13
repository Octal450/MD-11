# MD-11 Main Libraries
# Joshua Davidson (it0uchpods)

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

print("-----------------------------------------------------------------------------");
print("Copyright (c) 2017-2018 Joshua Davidson (it0uchpods)");
print("-----------------------------------------------------------------------------");

setprop("/sim/replay/was-active", 0);

var nav_lights = props.globals.getNode("/sim/model/lights/nav-lights");
var setting = getprop("/controls/lighting/nav-lights");
var land = getprop("/controls/lighting/landing-light");
var landr = getprop("/controls/lighting/landing-light[1]");

var strobe_switch = props.globals.getNode("/controls/lighting/strobe", 2);
var strobe = aircraft.light.new("/sim/model/lights/strobe", [0.05, 0.05, 0.05, 1.0], "/controls/lighting/strobe");

var beacon_switch = props.globals.getNode("/controls/lighting/beacon", 2);
var beacon = aircraft.light.new("/sim/model/lights/beacon", [0.1, 1], "/controls/lighting/beacon");

##########
# Sounds #
##########

setlistener("/sim/sounde/btn1", func {
	if (!getprop("/sim/sounde/btn1")) {
		return;
	}
	settimer(func {
		props.globals.getNode("/sim/sounde/btn1").setBoolValue(0);
	}, 0.05);
});

setlistener("/sim/sounde/oh-btn", func {
	if (!getprop("/sim/sounde/oh-btn")) {
		return;
	}
	settimer(func {
		props.globals.getNode("/sim/sounde/oh-btn").setBoolValue(0);
	}, 0.05);
});

setlistener("/sim/sounde/btn3", func {
	if (!getprop("/sim/sounde/btn3")) {
		return;
	}
	settimer(func {
		props.globals.getNode("/sim/sounde/btn3").setBoolValue(0);
	}, 0.05);
});

setlistener("/sim/sounde/knb1", func {
	if (!getprop("/sim/sounde/knb1")) {
		return;
	}
	settimer(func {
		props.globals.getNode("/sim/sounde/knb1").setBoolValue(0);
	}, 0.05);
});

setlistener("/sim/sounde/switch1", func {
	if (!getprop("/sim/sounde/switch1")) {
		return;
	}
	settimer(func {
		props.globals.getNode("/sim/sounde/switch1").setBoolValue(0);
	}, 0.05);
});

setlistener("/controls/switches/seatbelt-sign", func {
	props.globals.getNode("/sim/sounde/seatbelt-sign").setBoolValue(1);
	settimer(func {
		props.globals.getNode("/sim/sounde/seatbelt-sign").setBoolValue(0);
	}, 2);
});

setlistener("/controls/switches/no-smoking-sign", func {
	props.globals.getNode("/sim/sounde/no-smoking-sign").setBoolValue(1);
	settimer(func {
		props.globals.getNode("/sim/sounde/no-smoking-sign").setBoolValue(0);
	}, 1);
});

#############
# Gear Tilt #
#############

var update_tilt = maketimer(0.1, func {
	var comp1 = getprop("/gear/gear[1]/compression-norm");
	if (comp1 > 0) {
		var pitchdeg1 = getprop("/orientation/pitch-deg");
		setprop("/gear/gear[1]/angle-deg", pitchdeg1);
	} else {
		setprop("/gear/gear[1]/angle-deg", "0");
	}
	var comp2 = getprop("/gear/gear[2]/compression-norm");
	if (comp2 > 0) {
		var pitchdeg2 = getprop("/orientation/pitch-deg");
		setprop("/gear/gear[2]/angle-deg", pitchdeg2);
	} else {
		setprop("/gear/gear[2]/angle-deg", "0");
	}
});

#######################
# Various Other Stuff #
#######################

var systemsInit = func {
	systems.ELEC.init();
	systems.PNEU.init();
	systems.HYD.init();
	systems.IRS.init();
	systems.eng_init();
	fadec.fadec_reset();
	afs.ap_init();
	update_tilt.start();
	lightsLoop.start();
	systemsLoop.start();
	systems.autobrake_init();
	libraries.variousReset();
	var autopilot = gui.Dialog.new("sim/gui/dialogs/autopilot/dialog", "Aircraft/IDG-MD-11X/Systems/autopilot-dlg.xml");
}

setlistener("sim/signals/fdm-initialized", func {
	systemsInit();
});

var systemsLoop = maketimer(0.1, func {
	systems.ELEC.loop();
	systems.PNEU.loop();
	systems.HYD.loop();
	systems.IRS.loop();
	systems.eng_loop();
	fadec.fadecLoop();
	
	if ((getprop("/controls/pneumatic/switches/groundair") or getprop("/controls/switches/cart")) and ((getprop("/velocities/groundspeed-kt") > 2) or getprop("/controls/gear/brake-parking") == 0)) {
		setprop("/controls/switches/cart", 0);
		setprop("/controls/pneumatic/switches/groundair", 0);
	}
	
	if (getprop("/it-autoflight/custom/show-hdg") == 0 and getprop("/it-autoflight/output/lat") != 4) {
		setprop("/it-autoflight/input/hdg", math.round(getprop("/instrumentation/pfd/heading-scale")));
		setprop("/it-autoflight/custom/hdg-sel", math.round(getprop("/instrumentation/pfd/heading-scale")));
	}

	if (getprop("/velocities/groundspeed-kt") > 15) {
		setprop("/systems/shake/effect", 1);
	} else {
		setprop("/systems/shake/effect", 0);
	}
	
	if ((getprop("/sim/replay/time") == 0) or (getprop("/sim/replay/time") == nil)) {
		setprop("/aircraft/wingflex-enable", 1);
	} else {
		setprop("/aircraft/wingflex-enable", 0);
	}
# FIXME: Needs fuel pipes working
#	if ((getprop("/engines/engine[0]/state") == 2 or getprop("/engines/engine[0]/state") == 3) and getprop("/fdm/jsbsim/propulsion/tank[3]/contents-lbs") < 1) {
#		systems.cutoff_one();
#	}
#	if ((getprop("/engines/engine[1]/state") == 2 or getprop("/engines/engine[1]/state") == 3) and getprop("/fdm/jsbsim/propulsion/tank[4]/contents-lbs") < 1) {
#		systems.cutoff_two();
#	}
#	if ((getprop("/engines/engine[2]/state") == 2 or getprop("/engines/engine[2]/state") == 3) and getprop("/fdm/jsbsim/propulsion/tank[5]/contents-lbs") < 1) {
#		systems.cutoff_two();
#	}
	
	if (getprop("/sim/replay/replay-state") == 1) {
		setprop("/sim/replay/was-active", 1);
	} else if (getprop("/sim/replay/replay-state") == 0 and getprop("/sim/replay/was-active") == 1) {
		setprop("/sim/replay/was-active", 0);
		acconfig.colddark();
		gui.popupTip("Replay Ended: Setting Cold and Dark state...");
	}
});

canvas.Text._lastText = canvas.Text["_lastText"];
canvas.Text.setText = func (text) {
	if (text == me._lastText) {return me;}
	me._lastText = text;
	me.set("text", typeof(text) == 'scalar' ? text : "");
};
canvas.Element._lastVisible = nil;
canvas.Element.show = func () {
	if (1 == me._lastVisible) {return me;}
	me._lastVisible = 1;
	me.setBool("visible", 1);
};
canvas.Element.hide = func () {
	if (0 == me._lastVisible) {return me;}
	me._lastVisible = 0;
	me.setBool("visible", 0);
};
canvas.Element.setVisible = func (vis) {
	if (vis == me._lastVisible) {return me;}
	me._lastVisible = vis;
	me.setBool("visible", vis);
};

setprop("/controls/flight/flap-lever", 0);
setprop("/controls/flight/flap-output", 0);
setprop("/controls/flight/flap-txt", 0);

controls.flapsDown = func(step) {
	if (step == 1) {
		if (getprop("/controls/flight/flap-lever") == 0) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 0.000);
			setprop("/controls/flight/flap-lever", 1);
			setprop("/controls/flight/flaps", 0.0);
			setprop("/controls/flight/flap-txt", 0);
			setprop("/controls/hydraulic/aileron-droop", 0);
			return;
		} else if (getprop("/controls/flight/flap-lever") == 1) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 0.300);
			setprop("/controls/flight/flap-lever", 2);
			setprop("/controls/flight/flaps", 0.4);
			setprop("/controls/flight/flap-txt", 15);
			if (getprop("/controls/hydraulic/aileron-droop-enable") == 1) {
				if (getprop("/gear/gear[0]/wow") == 1) {
					setprop("/controls/hydraulic/aileron-droop", 1);
				}
			} else {
				setprop("/controls/hydraulic/aileron-droop", 0);
			}
			return;
		} else if (getprop("/controls/flight/flap-lever") == 2) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 0.560);
			setprop("/controls/flight/flap-lever", 3);
			setprop("/controls/flight/flaps", 0.7);
			setprop("/controls/flight/flap-txt", 28);
			if (getprop("/controls/hydraulic/aileron-droop-enable") == 1) {
				if (getprop("/gear/gear[0]/wow") == 1) {
					setprop("/controls/hydraulic/aileron-droop", 1);
				}
			} else {
				setprop("/controls/hydraulic/aileron-droop", 0);
			}
			return;
		} else if (getprop("/controls/flight/flap-lever") == 3) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 0.700);
			setprop("/controls/flight/flap-lever", 4);
			setprop("/controls/flight/flaps", 1.0);
			setprop("/controls/flight/flap-txt", 35);
			setprop("/controls/hydraulic/aileron-droop", 0);
			return;
		} else if (getprop("/controls/flight/flap-lever") == 4) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 1.000);
			setprop("/controls/flight/flap-lever", 5);
			setprop("/controls/flight/flaps", 1.0);
			setprop("/controls/flight/flap-txt", 50);
			setprop("/controls/hydraulic/aileron-droop", 0);
			return;
		}
	} else if (step == -1) {
		if (getprop("/controls/flight/flap-lever") == 5) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 0.700);
			setprop("/controls/flight/flap-lever", 4);
			setprop("/controls/flight/flaps", 1.0);
			setprop("/controls/flight/flap-txt", 35);
			setprop("/controls/hydraulic/aileron-droop", 0);
			return;
		} else if (getprop("/controls/flight/flap-lever") == 4) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 0.560);
			setprop("/controls/flight/flap-lever", 3);
			setprop("/controls/flight/flaps", 7.0);
			setprop("/controls/flight/flap-txt", 28);
			if (getprop("/controls/hydraulic/aileron-droop-enable") == 1) {
				if (getprop("/gear/gear[0]/wow") == 1) {
					setprop("/controls/hydraulic/aileron-droop", 1);
				}
			} else {
				setprop("/controls/hydraulic/aileron-droop", 0);
			}
			return;
		} else if (getprop("/controls/flight/flap-lever") == 3) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 0.300);
			setprop("/controls/flight/flap-lever", 2);
			setprop("/controls/flight/flaps", 0.4);
			setprop("/controls/flight/flap-txt", 15);
			if (getprop("/controls/hydraulic/aileron-droop-enable") == 1) {
				if (getprop("/gear/gear[0]/wow") == 1) {
					setprop("/controls/hydraulic/aileron-droop", 1);
				}
			} else {
				setprop("/controls/hydraulic/aileron-droop", 0);
			}
			return;
		} else if (getprop("/controls/flight/flap-lever") == 2) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 0.000);
			setprop("/controls/flight/flap-lever", 1);
			setprop("/controls/flight/flaps", 0.0);
			setprop("/controls/flight/flap-txt", 0);
			setprop("/controls/hydraulic/aileron-droop", 0);
			return;
		} else if (getprop("/controls/flight/flap-lever") == 1) {
			setprop("/controls/flight/slats", 0.000);
			setprop("/controls/flight/flaps-output", 0.000);
			setprop("/controls/flight/flap-lever", 0);
			setprop("/controls/flight/flaps", 0.0);
			setprop("/controls/flight/flap-txt", 0);
			setprop("/controls/hydraulic/aileron-droop", 0);
			return;
		}
	} else {
		return 0;
	}
}

controls.stepSpoilers = func(step) {
	setprop("/controls/flight/speedbrake-arm", 0);
	if (step == 1) {
		deploySpeedbrake();
	} else if (step == -1) {
		retractSpeedbrake();
	}
}

var deploySpeedbrake = func {
	if (getprop("/gear/gear[1]/wow") == 1 or getprop("/gear/gear[2]/wow") == 1) {
		if (getprop("/controls/flight/speedbrake") < 0.2) {
			setprop("/controls/flight/speedbrake", 0.2);
		} else if (getprop("/controls/flight/speedbrake") < 0.4) {
			setprop("/controls/flight/speedbrake", 0.4);
		} else if (getprop("/controls/flight/speedbrake") < 0.6) {
			setprop("/controls/flight/speedbrake", 0.6);
		} else if (getprop("/controls/flight/speedbrake") < 1.0) {
			setprop("/controls/flight/speedbrake", 1.0);
		}
	} else {
		if (getprop("/controls/flight/speedbrake") < 0.2) {
			setprop("/controls/flight/speedbrake", 0.2);
		} else if (getprop("/controls/flight/speedbrake") < 0.4) {
			setprop("/controls/flight/speedbrake", 0.4);
		} else if (getprop("/controls/flight/speedbrake") < 0.6) {
			setprop("/controls/flight/speedbrake", 0.6);
		}
	}
}

var retractSpeedbrake = func {
	if (getprop("/controls/flight/speedbrake") > 0.6) {
		setprop("/controls/flight/speedbrake", 0.6);
	} else if (getprop("/controls/flight/speedbrake") > 0.4) {
		setprop("/controls/flight/speedbrake", 0.4);
	} else if (getprop("/controls/flight/speedbrake") > 0.2) {
		setprop("/controls/flight/speedbrake", 0.2);
	} else if (getprop("/controls/flight/speedbrake") > 0.0) {
		setprop("/controls/flight/speedbrake", 0.0);
	}
}

var lightsLoop = maketimer(0.2, func {
	#gear = getprop("/gear/gear[0]/position-norm");
	#nose_lights = getprop("/sim/model/lights/nose-lights");
	#settingT = getprop("/controls/lighting/taxi-light-switch");
	
	# nose lights
	
	#if (settingT == 0.5 and gear > 0.9 and (getprop("/systems/electrical/bus/ac1") > 0 or getprop("/systems/electrical/bus/ac2") > 0)) {
	#	setprop("/sim/model/lights/nose-lights", 0.85);
	#} else if (settingT == 1 and gear > 0.9 and (getprop("/systems/electrical/bus/ac1") > 0 or getprop("/systems/electrical/bus/ac2") > 0)) {
	#	setprop("/sim/model/lights/nose-lights", 1);
	#} else {
	#	setprop("/sim/model/lights/nose-lights", 0);
	#}
	
	# turnoff lights
	#settingTurnoff = getprop("/controls/lighting/turnoff-light-switch");
	#left_turnoff_light = props.globals.getNode("/controls/lighting/leftturnoff");
	#right_turnoff_light = props.globals.getNode("/controls/lighting/rightturnoff");
	
	#if (settingTurnoff == 1 and gear > 0.9 and getprop("/systems/electrical/bus/ac1") > 0) {
	#	left_turnoff_light.setBoolValue(1);
	#} else {
	#	left_turnoff_light.setBoolValue(0);
	#}
	
	#if (settingTurnoff == 1 and gear > 0.9 and getprop("/systems/electrical/bus/ac2") > 0) {
	#	right_turnoff_light.setBoolValue(1);
	#} else {
	#	right_turnoff_light.setBoolValue(0);
	#}
	
	# logo and navigation lights
	setting = getprop("/controls/lighting/nav-lights");
	nav_lights = props.globals.getNode("/sim/model/lights/nav-lights");
	#logo_lights = props.globals.getNode("/sim/model/lights/logo-lights");
	#wow = getprop("/gear/gear[2]/wow");
	#slats = getprop("/controls/flight/slats");
	
	# if (getprop("/systems/electrical/bus/ac1") > 0 or getprop("/systems/electrical/bus/ac2") > 0) {
	#	setprop("/systems/electrical/nav-lights-power", 1);
	#} else { 
	#	setprop("/systems/electrical/nav-lights-power", 0);
	#}
	
	#if (setting == 0 and logo_lights == 1) {
	#	 logo_lights.setBoolValue(0);
	#} else if (setting == 1 or setting == 2 and (getprop("/systems/electrical/bus/ac1") > 0 or getprop("/systems/electrical/bus/ac2") > 0)) {
	#	if ((wow) or (!wow and slats > 0)) {
	#		logo_lights.setBoolValue(1);
	#	} else {
	#		logo_lights.setBoolValue(0);
	#	}
	#} else {
	#	logo_lights.setBoolValue(0);
	#}

	if (setting == 1) {
		nav_lights.setBoolValue(1);
	} else {
		nav_lights.setBoolValue(0);
	}
	
	# landing lights
	land = getprop("/controls/lighting/landing-light");
	landr = getprop("/controls/lighting/landing-light[1]");
	
	if (land == 1) {
		setprop("/sim/rendering/als-secondary-lights/use-landing-light", 1);
	} else {
		setprop("/sim/rendering/als-secondary-lights/use-landing-light", 0);
	}
	
	if (landr == 1 or landr == 2) {
		setprop("/sim/rendering/als-secondary-lights/use-alt-landing-light", 1);
	} else {
		setprop("/sim/rendering/als-secondary-lights/use-alt-landing-light", 0);
	}
});

var slewProp = func(prop, delta) {
	delta *= getprop("/sim/time/delta-realtime-sec");
	setprop(prop, getprop(prop) + delta);
	return getprop(prop);
}

controls.elevatorTrim = func(speed) {
	if (getprop("/systems/hydraulic/sys1-psi") >= 1500 or getprop("/systems/hydraulic/sys3-psi") >= 1500) {
		slewProp("/controls/flight/elevator-trim", speed * 0.045);
	}
}

setlistener("/controls/flight/elevator-trim", func {
	if (getprop("/controls/flight/elevator-trim") > 0.064516) {
		setprop("/controls/flight/elevator-trim", 0.064516);
	}
});

if (getprop("/controls/flight/auto-coordination") == 1) {
	setprop("/controls/flight/auto-coordination", 0);
	setprop("/controls/flight/aileron-drives-tiller", 1);
} else {
	setprop("/controls/flight/aileron-drives-tiller", 0);
}

setprop("/systems/acconfig/libraries-loaded", 1);
