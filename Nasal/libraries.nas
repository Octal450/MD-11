# McDonnell Douglas MD-11 Main Libraries
# Copyright (c) 2019 Joshua Davidson (Octal450)

print("-----------------------------------------------------------------------------");
print("Copyright (c) 2017-2019 Joshua Davidson (Octal450)");
print("-----------------------------------------------------------------------------");

setprop("/sim/menubar/default/menu[0]/item[0]/enabled", 0);
setprop("/sim/menubar/default/menu[2]/item[0]/enabled", 0);
setprop("/sim/menubar/default/menu[2]/item[2]/enabled", 0);
setprop("/sim/menubar/default/menu[3]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[9]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[10]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[11]/enabled", 0);

var systemsInit = func {
	systems.ELEC.init();
	systems.FCTL.init();
	systems.FUEL.init();
	systems.HYD.init();
	systems.IRS.init();
	systems.PNEU.init();
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
	systems.IRS.loop();
	systems.eng_loop();
	fadec.fadecLoop();
	
	if ((pts.Velocities.groundspeedKt.getValue() >= 2) or !pts.Controls.Gear.brakeParking.getBoolValue()) {
		if (systems.ELEC.Source.Ext.cart.getBoolValue() or systems.ELEC.Switch.extPwr.getBoolValue() or systems.ELEC.Switch.extGPwr.getBoolValue()) {
			systems.ELEC.Source.Ext.cart.setBoolValue(0);
			systems.ELEC.Switch.extPwr.setBoolValue(0);
			systems.ELEC.Switch.extGPwr.setBoolValue(0);
		}
		if (systems.PNEU.Switch.groundAir.getBoolValue()) {
			systems.PNEU.Switch.groundAir.setBoolValue(0);
		}
	}

	if (pts.Velocities.groundspeedKt.getValue() >= 15) {
		pts.Systems.Shake.effect.setBoolValue(1);
	} else {
		pts.Systems.Shake.effect.setBoolValue(0);
	}
	
	if (pts.Sim.Replay.replayState.getBoolValue()) {
		pts.Controls.Flight.wingflexEnable.setBoolValue(0);
	} else {
		pts.Controls.Flight.wingflexEnable.setBoolValue(1);
	}
	
	if ((getprop("/engines/engine[0]/state") == 2 or getprop("/engines/engine[0]/state") == 3) and getprop("/fdm/jsbsim/propulsion/tank[8]/contents-lbs") < 1) {
		systems.cutoff_one();
	}
	if ((getprop("/engines/engine[1]/state") == 2 or getprop("/engines/engine[1]/state") == 3) and (getprop("/fdm/jsbsim/propulsion/tank[9]/contents-lbs") < 1 or systems.HYD.Fail.catastrophicAft.getBoolValue())) {
		systems.cutoff_two();
	}
	if ((getprop("/engines/engine[2]/state") == 2 or getprop("/engines/engine[2]/state") == 3) and getprop("/fdm/jsbsim/propulsion/tank[10]/contents-lbs") < 1) {
		systems.cutoff_three();
	}
	
	if (pts.Sim.Replay.replayState.getBoolValue()) {
		pts.Sim.Replay.wasActive.setBoolValue(1);
	} else if (!pts.Sim.Replay.replayState.getBoolValue() and pts.Sim.Replay.wasActive.getBoolValue()) {
		pts.Sim.Replay.wasActive.setBoolValue(0);
		acconfig.colddark();
		gui.popupTip("Replay Ended: Setting Cold and Dark state...");
	}
});

# Prevent gear up accidently while WoW
setlistener("/controls/gear/gear-down", func {
	if (!pts.Controls.Gear.gearDown.getBoolValue()) {
		if (pts.Gear.wow[0].getBoolValue() or pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) {
			pts.Controls.Gear.gearDown.setBoolValue(1);
		}
	}
});

# Enable/Disable the drooped aileron when flap lever moved
setlistener("/controls/flight/flaps-input-out", func {
	if (pts.Controls.Flight.flapsInputOut.getValue() == 2 or pts.Controls.Flight.flapsInputOut.getValue() == 3) {
		if (pts.Gear.wow[0].getBoolValue()) {
			pts.Controls.Hydraulics.deflectedAileron.setBoolValue(1);
		}
	} else {
		pts.Controls.Hydraulics.deflectedAileron.setBoolValue(0);
	}
}, 0, 0);

canvas.Text._lastText = canvas.Text["_lastText"];
canvas.Text.setText = func(text) {
	if (text == me._lastText and text != nil and size(text) == size(me._lastText)) {
		return me;
	}
	me._lastText = text;
	me.set("text", typeof(text) == "scalar" ? text : "");
};
canvas.Element._lastVisible = nil;
canvas.Element.show = func {
	if (1 == me._lastVisible) {
		return me;
	}
	me._lastVisible = 1;
	me.setBool("visible", 1);
};
canvas.Element.hide = func {
	if (0 == me._lastVisible) {
		return me;
	}
	me._lastVisible = 0;
	me.setBool("visible", 0);
};
canvas.Element.setVisible = func(vis) {
	if (vis == me._lastVisible) {
		return me;
	}
	me._lastVisible = vis;
	me.setBool("visible", vis);
};

var nav_lights = props.globals.getNode("/sim/model/lights/nav-lights");
var setting = getprop("/controls/lighting/nav-lights");

var strobe_switch = props.globals.getNode("/controls/lighting/strobe", 2);
var strobe = aircraft.light.new("/sim/model/lights/strobe", [0.05, 0.05, 0.05, 1.0], "/controls/lighting/strobe");

var beacon_switch = props.globals.getNode("/controls/lighting/beacon", 2);
var beacon = aircraft.light.new("/sim/model/lights/beacon", [0.1, 1], "/controls/lighting/beacon");

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
	delta *= pts.Sim.Time.deltaRealtimeSec.getValue();
	setprop(prop, getprop(prop) + delta);
	return getprop(prop);
}

controls.flapsDown = func(step) {
	pts.Controls.Flight.flapsTemp = pts.Controls.Flight.flaps.getValue();
	if (step == 1) {
		if (pts.Controls.Flight.flapsTemp < 0.2) {
			pts.Controls.Flight.flaps.setValue(0.2);
		} else if (pts.Controls.Flight.flapsTemp < 0.36) {
			pts.Controls.Flight.flaps.setValue(0.36);
		} else if (pts.Controls.Flight.flapsTemp < 0.52) {
			pts.Controls.Flight.flaps.setValue(0.52);
		} else if (pts.Controls.Flight.flapsTemp < 0.68) {
			pts.Controls.Flight.flaps.setValue(0.68);
		} else if (pts.Controls.Flight.flapsTemp < 0.84) {
			pts.Controls.Flight.flaps.setValue(0.84);
		}
	} else if (step == -1) {
		if (pts.Controls.Flight.flapsTemp > 0.68) {
			pts.Controls.Flight.flaps.setValue(0.68);
		} else if (pts.Controls.Flight.flapsTemp > 0.52) {
			pts.Controls.Flight.flaps.setValue(0.52);
		} else if (pts.Controls.Flight.flapsTemp > 0.36) {
			pts.Controls.Flight.flaps.setValue(0.36);
		} else if (pts.Controls.Flight.flapsTemp > 0.2) {
			pts.Controls.Flight.flaps.setValue(0.2);
		} else if (pts.Controls.Flight.flapsTemp > 0) {
			pts.Controls.Flight.flaps.setValue(0);
		}
	}
}

controls.stepSpoilers = func(step) {
	pts.Controls.Flight.speedbrakeArm.setBoolValue(0);
	if (step == 1) {
		deploySpeedbrake();
	} else if (step == -1) {
		retractSpeedbrake();
	}
}

var deploySpeedbrake = func {
	pts.Controls.Flight.speedbrakeTemp = pts.Controls.Flight.speedbrake.getValue();
	if (pts.Gear.wow[0].getBoolValue()) {
		if (pts.Controls.Flight.speedbrakeTemp < 0.2) {
			pts.Controls.Flight.speedbrake.setValue(0.2);
		} else if (pts.Controls.Flight.speedbrakeTemp < 0.4) {
			pts.Controls.Flight.speedbrake.setValue(0.4);
		} else if (pts.Controls.Flight.speedbrakeTemp < 0.6) {
			pts.Controls.Flight.speedbrake.setValue(0.6);
		} else if (pts.Controls.Flight.speedbrakeTemp < 0.8) {
			pts.Controls.Flight.speedbrake.setValue(0.8);
		}
	} else {
		if (pts.Controls.Flight.speedbrakeTemp < 0.2) {
			pts.Controls.Flight.speedbrake.setValue(0.2);
		} else if (pts.Controls.Flight.speedbrakeTemp < 0.4) {
			pts.Controls.Flight.speedbrake.setValue(0.4);
		} else if (pts.Controls.Flight.speedbrakeTemp < 0.8) { # Not 0.6!
			pts.Controls.Flight.speedbrake.setValue(0.8); # Not 0.6!
		}
	}
}

var retractSpeedbrake = func {
	pts.Controls.Flight.speedbrakeTemp = pts.Controls.Flight.speedbrake.getValue();
	if (pts.Gear.wow[0].getBoolValue()) {
		if (pts.Controls.Flight.speedbrakeTemp > 0.6) {
			pts.Controls.Flight.speedbrake.setValue(0.6);
		} else if (pts.Controls.Flight.speedbrakeTemp > 0.4) {
			pts.Controls.Flight.speedbrake.setValue(0.4);
		} else if (pts.Controls.Flight.speedbrakeTemp > 0.2) {
			pts.Controls.Flight.speedbrake.setValue(0.2);
		} else if (pts.Controls.Flight.speedbrakeTemp > 0) {
			pts.Controls.Flight.speedbrake.setValue(0);
		}
	} else {
		if (pts.Controls.Flight.speedbrakeTemp > 0.4) {
			pts.Controls.Flight.speedbrake.setValue(0.4);
		} else if (pts.Controls.Flight.speedbrakeTemp > 0.2) {
			pts.Controls.Flight.speedbrake.setValue(0.2);
		} else if (pts.Controls.Flight.speedbrakeTemp > 0) {
			pts.Controls.Flight.speedbrake.setValue(0);
		}
	}
}

controls.elevatorTrim = func(d) {
	if (getprop("/systems/hydraulics/sys-1-psi") >= 1500 or getprop("/systems/hydraulics/sys-3-psi") >= 1500) {
		slewProp("/controls/flight/elevator-trim", d * 0.0162); # 0.0162 is the rate in JSB normalized (0.25 / 15.5)
	}
}

setlistener("/controls/flight/elevator-trim", func {
	if (pts.Controls.Flight.elevatorTrim.getValue() > 0.064516) {
		pts.Controls.Flight.elevatorTrim.setValue(0.064516);
	}
}, 0, 0);

setlistener("/controls/flight/auto-coordination", func {
	setprop("/controls/flight/auto-coordination", 0);
});

if (getprop("/controls/flight/auto-coordination") == 1) {
	setprop("/controls/flight/auto-coordination", 0);
	setprop("/controls/flight/aileron-drives-tiller", 1);
} else {
	setprop("/controls/flight/aileron-drives-tiller", 0);
}

# Custom Sounds
# TODO: Refactor this rubbish
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

setprop("/systems/acconfig/libraries-loaded", 1);
