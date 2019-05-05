# MD-11 Main Libraries
# Copyright (c) 2019 Joshua Davidson (it0uchpods)

print("-----------------------------------------------------------------------------");
print("Copyright (c) 2017-2019 Joshua Davidson (it0uchpods)");
print("-----------------------------------------------------------------------------");

setprop("/sim/replay/was-active", 0);

setprop("/sim/menubar/default/menu[0]/item[0]/enabled", 0);
setprop("/sim/menubar/default/menu[2]/item[0]/enabled", 0);
setprop("/sim/menubar/default/menu[2]/item[2]/enabled", 0);
setprop("/sim/menubar/default/menu[3]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[9]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[10]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[11]/enabled", 0);

var nav_lights = props.globals.getNode("/sim/model/lights/nav-lights");
var setting = getprop("/controls/lighting/nav-lights");

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

#######################
# Various Other Stuff #
#######################

var Master = { # Setup like property tree
	Controls: {
		Gear: {
			brakeParking: props.globals.getNode("/controls/gear/brake-parking"),
		},
	},
	Sim: {
		Time: {
			elapsedSec: props.globals.getNode("/sim/time/elapsed-sec", 1),
		},
	},
	Velocities: {
		groundspeedKt: props.globals.getNode("/velocities/groundspeed-kt", 1),
	},
};

var systemsInit = func {
	systems.ELEC.init();
	systems.PNEU.init();
	systems.HYD.init();
	systems.FUEL.init();
	systems.FCTL.init();
	systems.IRS.init();
	systems.eng_init();
	fadec.fadec_reset();
	afs.ITAF.init(0);
	lightsLoop.start();
	systemsLoop.start();
	systems.autobrake_init();
	libraries.variousReset();
}

setlistener("sim/signals/fdm-initialized", func {
	systemsInit();
});

var systemsLoop = maketimer(0.1, func {
	systems.ELEC.loop();
	systems.PNEU.loop();
	systems.FUEL.loop();
	systems.IRS.loop();
	systems.eng_loop();
	fadec.fadecLoop();
	
	if ((Master.Velocities.groundspeedKt.getValue() >= 2) or !Master.Controls.Gear.brakeParking.getBoolValue()) {
		if (systems.ELEC.Source.Ext.cart.getBoolValue() or systems.ELEC.Switch.extPwr.getBoolValue() or systems.ELEC.Switch.extGPwr.getBoolValue()) {
			systems.ELEC.Source.Ext.cart.setBoolValue(0);
			systems.ELEC.Switch.extPwr.setBoolValue(0);
			systems.ELEC.Switch.extGPwr.setBoolValue(0);
		}
		if (getprop("/controls/pneumatic/switches/groundair")) { # To be deprecated
			setprop("/controls/pneumatic/switches/groundair", 0);
		}
	}

	if (Master.Velocities.groundspeedKt.getValue() >= 15) {
		setprop("/systems/shake/effect", 1);
	} else {
		setprop("/systems/shake/effect", 0);
	}
	
	if ((getprop("/sim/replay/time") == 0) or (getprop("/sim/replay/time") == nil)) {
		setprop("/aircraft/wingflex-enable", 1);
	} else {
		setprop("/aircraft/wingflex-enable", 0);
	}
	
	if ((getprop("/engines/engine[0]/state") == 2 or getprop("/engines/engine[0]/state") == 3) and getprop("/fdm/jsbsim/propulsion/tank[5]/contents-lbs") < 1) {
		systems.cutoff_one();
	}
	if ((getprop("/engines/engine[1]/state") == 2 or getprop("/engines/engine[1]/state") == 3) and getprop("/fdm/jsbsim/propulsion/tank[6]/contents-lbs") < 1) {
		systems.cutoff_two();
	}
	if ((getprop("/engines/engine[2]/state") == 2 or getprop("/engines/engine[2]/state") == 3) and getprop("/fdm/jsbsim/propulsion/tank[7]/contents-lbs") < 1) {
		systems.cutoff_three();
	}
	
	if (getprop("/sim/replay/replay-state") == 1) {
		setprop("/sim/replay/was-active", 1);
	} else if (getprop("/sim/replay/replay-state") == 0 and getprop("/sim/replay/was-active") == 1) {
		setprop("/sim/replay/was-active", 0);
		acconfig.colddark();
		gui.popupTip("Replay Ended: Setting Cold and Dark state...");
	}
});

setlistener("/controls/flight/flaps-input-out", func { # TODO: props.nas
	if (getprop("/controls/flight/flaps-input-out") == 2 or getprop("/controls/flight/flaps-input-out") == 3) {
		if (getprop("/gear/gear[0]/wow") == 1) {
			setprop("/controls/hydraulics/deflected-aileron", 1);
		}
	} else {
		setprop("/controls/hydraulics/deflected-aileron", 0);
	}
}, 0, 0);

canvas.Text._lastText = canvas.Text["_lastText"];
canvas.Text.setText = func(text) {
	if (text == me._lastText and text != nil and size(text) == size(me._lastText)) {return me;}
	me._lastText = text;
	me.set("text", typeof(text) == "scalar" ? text : "");
};
canvas.Element._lastVisible = nil;
canvas.Element.show = func {
	if (1 == me._lastVisible) {return me;}
	me._lastVisible = 1;
	me.setBool("visible", 1);
};
canvas.Element.hide = func {
	if (0 == me._lastVisible) {return me;}
	me._lastVisible = 0;
	me.setBool("visible", 0);
};
canvas.Element.setVisible = func(vis) {
	if (vis == me._lastVisible) {return me;}
	me._lastVisible = vis;
	me.setBool("visible", vis);
};

var lightsLoop = maketimer(0.2, func {
	# Logo and navigation lights
	setting = getprop("/controls/lighting/nav-lights");
	
	if (setting == 1) {
		nav_lights.setBoolValue(1);
	} else {
		nav_lights.setBoolValue(0);
	}
});

# Custom controls.nas overwrites
var slewProp = func(prop, delta) {
	delta *= getprop("/sim/time/delta-realtime-sec");
	setprop(prop, getprop(prop) + delta);
	return getprop(prop);
}

controls.flapsDown = func(step) {
	if (step == 1) {
		if (getprop("/controls/flight/flaps") < 0.2) {
			setprop("/controls/flight/flaps", 0.2);
		} else if (getprop("/controls/flight/flaps") < 0.36) {
			setprop("/controls/flight/flaps", 0.36);
		} else if (getprop("/controls/flight/flaps") < 0.52) {
			setprop("/controls/flight/flaps", 0.52);
		} else if (getprop("/controls/flight/flaps") < 0.68) {
			setprop("/controls/flight/flaps", 0.68);
		} else if (getprop("/controls/flight/flaps") < 0.84) {
			setprop("/controls/flight/flaps", 0.84);
		}
	} else if (step == -1) {
		if (getprop("/controls/flight/flaps") > 0.68) {
			setprop("/controls/flight/flaps", 0.68);
		} else if (getprop("/controls/flight/flaps") > 0.52) {
			setprop("/controls/flight/flaps", 0.52);
		} else if (getprop("/controls/flight/flaps") > 0.36) {
			setprop("/controls/flight/flaps", 0.36);
		} else if (getprop("/controls/flight/flaps") > 0.2) {
			setprop("/controls/flight/flaps", 0.2);
		} else if (getprop("/controls/flight/flaps") > 0) {
			setprop("/controls/flight/flaps", 0);
		}
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
	if (getprop("/gear/gear[0]/wow") == 1) {
		if (getprop("/controls/flight/speedbrake") < 0.2) {
			setprop("/controls/flight/speedbrake", 0.2);
		} else if (getprop("/controls/flight/speedbrake") < 0.4) {
			setprop("/controls/flight/speedbrake", 0.4);
		} else if (getprop("/controls/flight/speedbrake") < 0.6) {
			setprop("/controls/flight/speedbrake", 0.6);
		} else if (getprop("/controls/flight/speedbrake") < 0.8) {
			setprop("/controls/flight/speedbrake", 0.8);
		}
	} else {
		if (getprop("/controls/flight/speedbrake") < 0.2) {
			setprop("/controls/flight/speedbrake", 0.2);
		} else if (getprop("/controls/flight/speedbrake") < 0.4) {
			setprop("/controls/flight/speedbrake", 0.4);
		} else if (getprop("/controls/flight/speedbrake") < 0.8) { # Not 0.6!
			setprop("/controls/flight/speedbrake", 0.8); # Not 0.6!
		}
	}
}

var retractSpeedbrake = func {
	if (getprop("/gear/gear[0]/wow") == 1) {
		if (getprop("/controls/flight/speedbrake") > 0.6) {
			setprop("/controls/flight/speedbrake", 0.6);
		} else if (getprop("/controls/flight/speedbrake") > 0.4) {
			setprop("/controls/flight/speedbrake", 0.4);
		} else if (getprop("/controls/flight/speedbrake") > 0.2) {
			setprop("/controls/flight/speedbrake", 0.2);
		} else if (getprop("/controls/flight/speedbrake") > 0) {
			setprop("/controls/flight/speedbrake", 0);
		}
	} else {
		if (getprop("/controls/flight/speedbrake") > 0.4) {
			setprop("/controls/flight/speedbrake", 0.4);
		} else if (getprop("/controls/flight/speedbrake") > 0.2) {
			setprop("/controls/flight/speedbrake", 0.2);
		} else if (getprop("/controls/flight/speedbrake") > 0) {
			setprop("/controls/flight/speedbrake", 0);
		}
	}
}

controls.elevatorTrim = func(d) {
	if (getprop("/systems/hydraulics/sys-1-psi") >= 1500 or getprop("/systems/hydraulics/sys-3-psi") >= 1500) {
		slewProp("/controls/flight/elevator-trim", d * 0.0162); # 0.0162 is the rate in JSB normalized (0.25 / 15.5)
	}
}

setlistener("/controls/flight/elevator-trim", func {
	if (getprop("/controls/flight/elevator-trim") > 0.064516) {
		setprop("/controls/flight/elevator-trim", 0.064516);
	}
});

setlistener("/controls/flight/auto-coordination", func {
	setprop("/controls/flight/auto-coordination", 0);
});

if (getprop("/controls/flight/auto-coordination") == 1) {
	setprop("/controls/flight/auto-coordination", 0);
	setprop("/controls/flight/aileron-drives-tiller", 1);
} else {
	setprop("/controls/flight/aileron-drives-tiller", 0);
}

setprop("/systems/acconfig/libraries-loaded", 1);
