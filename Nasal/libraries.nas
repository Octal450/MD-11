# McDonnell Douglas MD-11 Main Libraries
# Copyright (c) 2024 Josh Davidson (Octal450)

print("------------------------------------------------");
print("Copyright (c) 2017-2024 Josh Davidson (Octal450)");
print("------------------------------------------------");

setprop("/sim/menubar/default/menu[2]/item[0]/enabled", 0);
setprop("/sim/menubar/default/menu[2]/item[2]/enabled", 0);
setprop("/sim/menubar/default/menu[3]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[8]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[9]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[10]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[11]/enabled", 0);
setprop("/sim/menubar/default/menu[5]/item[12]/enabled", 0);
setprop("/sim/multiplay/visibility-range-nm", 130);

var initDone = 0;
var systemsInit = func() {
	# Standard modules
	systems.APU.init();
	systems.BRAKES.init();
	systems.ELECTRICAL.init();
	systems.ENGINES.init();
	systems.FADEC.init();
	systems.FCC.init();
	systems.FUEL.init();
	systems.GEAR.init();
	systems.HYDRAULICS.init();
	systems.IGNITION.init();
	systems.IRS.init();
	systems.PNEUMATICS.init();
	afs.ITAF.init();
	fms.CORE.init();
	instruments.EFIS.init();
	instruments.XPDR.init();
	
	# Object orientated modules
	if (initDone) { # Anytime after sim init
		instruments.RADIOS.reset();
		mcdu.BASE.reset();
	} else { # Sim init
		instruments.RADIOS.setup();
		mcdu.BASE.setup();
	}
	
	# Other switches
	cockpit.variousReset();
}

var fdmInit = setlistener("/sim/signals/fdm-initialized", func() {
	acconfig.SYSTEM.fdmInit();
	systemsInit();
	systemsLoop.start();
	slowLoop.start();
	lightsLoop.start();
	canvas_pfd.setup();
	canvas_ead.setup();
	canvas_sd.setup();
	canvas_iesi.setup();
	canvas_mcdu.setup();
	removelistener(fdmInit);
	initDone = 1;
	acconfig.SYSTEM.finalInit();
});

var systemsLoop = maketimer(0.1, func() {
	fms.CORE.loop();
	mcdu.BASE.loop();
	systems.FADEC.loop();
	systems.DUController.loop();
	SHAKE.loop();
	
	if (pts.Sim.Replay.replayState.getBoolValue()) {
		pts.Sim.Model.wingflexEnable.setBoolValue(0);
	} else {
		pts.Sim.Model.wingflexEnable.setBoolValue(1);
	}
	
	pts.Services.Chocks.enableTemp = pts.Services.Chocks.enable.getBoolValue();
	pts.Velocities.groundspeedKtTemp = pts.Velocities.groundspeedKt.getValue();
	if ((pts.Velocities.groundspeedKtTemp >= 2 or !pts.Position.wow.getBoolValue()) and pts.Services.Chocks.enableTemp) {
		pts.Services.Chocks.enable.setBoolValue(0);
	}
	
	if ((pts.Velocities.groundspeedKtTemp >= 2 or (!systems.GEAR.Controls.brakeParking.getBoolValue() and !pts.Services.Chocks.enableTemp)) and !acconfig.SYSTEM.autoConfigRunning.getBoolValue()) {
		if (systems.ELECTRICAL.Controls.groundCart.getBoolValue() or systems.ELECTRICAL.Controls.extPwr.getBoolValue() or systems.ELECTRICAL.Controls.extGPwr.getBoolValue()) {
			systems.ELECTRICAL.Controls.groundCart.setBoolValue(0);
			systems.ELECTRICAL.Controls.extPwr.setBoolValue(0);
			systems.ELECTRICAL.Controls.extGPwr.setBoolValue(0);
		}
		if (systems.PNEUMATICS.Controls.groundAir.getBoolValue()) {
			systems.PNEUMATICS.Controls.groundAir.setBoolValue(0);
		}
	}
});

var slowLoop = maketimer(1, func() {
	if (acconfig.SYSTEM.Error.active.getBoolValue()) {
		systemsInit();
	}
});

setlistener("/position/wow", func() {
	if (initDone) {
		instruments.XPDR.airGround();
	}
}, 0, 0);

var nav_lights = props.globals.getNode("/sim/model/lights/nav-lights");
var setting = getprop("/controls/lighting/nav-lights");

var strobe_switch = props.globals.getNode("/controls/lighting/strobe", 2);
var strobe = aircraft.light.new("/sim/model/lights/strobe", [0.05, 0.05, 0.05, 1.0], "/controls/lighting/strobe");

var beacon_switch = props.globals.getNode("/controls/lighting/beacon", 2);
var beacon = aircraft.light.new("/sim/model/lights/beacon", [0.1, 1], "/controls/lighting/beacon");

var lightsLoop = maketimer(0.2, func() {
	# Logo and navigation lights
	setting = getprop("/controls/lighting/nav-lights");
	
	if (setting == 1) {
		nav_lights.setBoolValue(1);
	} else {
		nav_lights.setBoolValue(0);
	}
});

# Backwards compatibility, removed soon
var ApPanel = {
	apDisc: func() {
		cockpit.ApPanel.apDisc();
		gui.popupTip("libraries.ApPanel is deprecated. Please switch to cockpit.ApPanel.");
	},
	atDisc: func() {
		cockpit.ApPanel.atDisc();
		gui.popupTip("libraries.ApPanel is deprecated. Please switch to cockpit.ApPanel.");
	},
	toga: func() {
		cockpit.ApPanel.toga();
		gui.popupTip("libraries.ApPanel is deprecated. Please switch to cockpit.ApPanel.");
	},
};

# Custom controls.nas overrides
controls.autopilotDisconnect = func() {
	cockpit.ApPanel.apDisc();
}

controls.reverserTogglePosition = func() {
	systems.toggleRevThrust();
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

var leverCockpit = 3;
controls.gearDown = func(d) { # Requires a mod-up
	pts.Position.wowTemp = pts.Position.wow.getBoolValue();
	leverCockpit = systems.GEAR.Controls.lever.getValue();
	if (d < 0) {
		if (pts.Position.wowTemp) {
			if (leverCockpit == 3) {
				systems.GEAR.Controls.lever.setValue(2);
			} else if (leverCockpit == 0) {
				systems.GEAR.Controls.lever.setValue(1);
			}
		} else {
			systems.GEAR.Controls.lever.setValue(0);
		}
	} else if (d > 0) {
		if (pts.Position.wowTemp) {
			if (leverCockpit == 3) {
				systems.GEAR.Controls.lever.setValue(2);
			} else if (leverCockpit == 0) {
				systems.GEAR.Controls.lever.setValue(1);
			}
		} else {
			systems.GEAR.Controls.lever.setValue(3);
		}
	} else {
		if (leverCockpit == 2) {
			systems.GEAR.Controls.lever.setValue(3);
		} else if (leverCockpit == 1) {
			systems.GEAR.Controls.lever.setValue(0);
		}
	}
}

controls.gearDownSmart = func(d) { # Used by cockpit, requires a mod-up
	if (d) {
		if (systems.GEAR.Controls.lever.getValue() >= 2) {
			controls.gearDown(-1);
		} else {
			controls.gearDown(1);
		}
	} else {
		controls.gearDown(0);
	}
}

controls.gearToggle = func() {
	if (!pts.Position.wow.getBoolValue()) {
		if (systems.GEAR.Controls.lever.getValue() >= 2) {
			systems.GEAR.Controls.lever.setValue(0);
		} else {
			systems.GEAR.Controls.lever.setValue(3);
		}
	} else {
		systems.GEAR.Controls.lever.setValue(3);
	}
}

controls.gearTogglePosition = func(d) {
	if (d) {
		controls.gearToggle();
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

var speedbrakeKey = func() {
	if (pts.Controls.Flight.speedbrakeArm.getBoolValue()) {
		pts.Controls.Flight.speedbrakeArm.setBoolValue(0);
	} else {
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
			} else {
				pts.Controls.Flight.speedbrake.setValue(0);
			}
		} else {
			if (pts.Controls.Flight.speedbrakeTemp < 0.2) {
				pts.Controls.Flight.speedbrake.setValue(0.2);
			} else if (pts.Controls.Flight.speedbrakeTemp < 0.4) {
				pts.Controls.Flight.speedbrake.setValue(0.4);
			} else if (pts.Controls.Flight.speedbrakeTemp < 0.8) { # Not 0.6!
				pts.Controls.Flight.speedbrake.setValue(0.8); # Not 0.6!
			} else {
				pts.Controls.Flight.speedbrake.setValue(0);
			}
		}
	}
}

var deploySpeedbrake = func() {
	pts.Controls.Flight.speedbrakeArm.setBoolValue(0);
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

var retractSpeedbrake = func() {
	pts.Controls.Flight.speedbrakeArm.setBoolValue(0);
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

var delta = 0;
var output = 0;
var slewProp = func(prop, delta) {
	delta *= pts.Sim.Time.deltaRealtimeSec.getValue();
	output = props.globals.getNode(prop).getValue() + delta;
	props.globals.getNode(prop).setValue(output);
	return output;
}

controls.elevatorTrim = func(d) {
	if (afs.Output.ap1.getBoolValue()) {
		afs.ITAF.ap1Master(0);
	}
	if (afs.Output.ap2.getBoolValue()) {
		afs.ITAF.ap2Master(0);
	}
	if (systems.HYDRAULICS.Psi.sys1.getValue() >= 2200 or systems.HYDRAULICS.Psi.sys3.getValue() >= 2200) {
		slewProp("/controls/flight/elevator-trim", d * (systems.FCC.pitchTrimSpeed.getValue() / 15.5)); # Rate normalized by max degrees (rate / 15.5)
		systems.FCC.Lsas.autotrimInhibit.setValue(1); # Inhibit autotrim for a few seconds
	}
}

setlistener("/controls/flight/elevator-trim", func() {
	if (pts.Controls.Flight.elevatorTrim.getValue() > 0.064516) {
		pts.Controls.Flight.elevatorTrim.setValue(0.064516);
	}
}, 0, 0);

# Override FG's generic brake
controls.applyBrakes = func(v, which = 0) { # No interpolate, that's bad, we will apply rate-limit in JSBSim
	if (which <= 0) {
		systems.GEAR.Controls.brakeLeft.setValue(v);
	}
	if (which >= 0) {
		systems.GEAR.Controls.brakeRight.setValue(v);
	}
}

if (pts.Controls.Flight.autoCoordination.getBoolValue()) {
	pts.Controls.Flight.autoCoordination.setBoolValue(0);
	pts.Controls.Flight.aileronDrivesTiller.setBoolValue(1);
} else {
	pts.Controls.Flight.aileronDrivesTiller.setBoolValue(0);
}

setlistener("/controls/flight/auto-coordination", func() {
	pts.Controls.Flight.autoCoordination.setBoolValue(0);
	print("System: Auto Coordination has been turned off as it is not compatible with the flight control system of this aircraft.");
	screen.log.write("Auto Coordination has been disabled as it is not compatible with the flight control system of this aircraft", 1, 0, 0);
});

# Doors
var Doors = {
	cargoUpper: aircraft.door.new("/sim/model/door-positions/cargo-upper", 8),
	toggle: func(door, doorName, doorDesc) {
		if (props.globals.getNode("/sim/model/door-positions/" ~ doorName ~ "/position-norm").getValue() > 0) {
			gui.popupTip("Closing: " ~ doorDesc ~ " Door");
			door.toggle();
		} else {
			if (!pts.Position.wow.getBoolValue()) {
				gui.popupTip("Doors can not open while the aircraft is airborne");
			} else if (pts.Velocities.groundspeedKt.getValue() >= 2) {
				gui.popupTip("Doors can not open while the aircraft is moving");
			} else {
				gui.popupTip("Opening: " ~ doorDesc ~ " Door");
				door.toggle();
			}
		}
	},
};

# Shaking Logic
var SHAKE = {
	force: 0,
	rollspeedMs: [0, 0, 0],
	wow: [0, 0, 0],
	loop: func() {
		me.rollspeedMs[0] = pts.Gear.rollspeedMs[0].getValue();
		me.rollspeedMs[1] = pts.Gear.rollspeedMs[1].getValue();
		me.rollspeedMs[2] = pts.Gear.rollspeedMs[2].getValue();
		me.wow[0] = pts.Gear.wow[0].getBoolValue();
		me.wow[1] = pts.Gear.wow[1].getBoolValue();
		me.wow[2] = pts.Gear.wow[2].getBoolValue();
		
		if (pts.Velocities.groundspeedKt.getValue() >= 1 and (me.wow[0] or me.wow[1] or me.wow[2])) {
			if (me.wow[0]) {
				me.force = me.rollspeedMs[0] / 94000;
			} else {
				me.force = math.max(me.rollspeedMs[1], me.rollspeedMs[2]) / 188000;
			}
			
			interpolate(pts.Systems.Shake.shaking, 0, 0.03);
			settimer(func() {
				interpolate(pts.Systems.Shake.shaking, me.force * 1.5, 0.03); 
			}, 0.5);
		} else {
			pts.Systems.Shake.shaking.setBoolValue(0);
		}	    
	},
};

# Custom Sounds
var Sound = {
	btn1: func() {
		if (pts.Sim.Sound.btn1.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.btn1.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.btn1.setBoolValue(0);
		}, 0.2);
	},
	btn2: func() {
		if (pts.Sim.Sound.btn2.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.btn2.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.btn2.setBoolValue(0);
		}, 0.2);
	},
	btn3: func() {
		if (pts.Sim.Sound.btn3.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.btn3.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.btn3.setBoolValue(0);
		}, 0.2);
	},
	knb1: func() {
		if (pts.Sim.Sound.knb1.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.knb1.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.knb1.setBoolValue(0);
		}, 0.2);
	},
	switch1: func() {
		if (pts.Sim.Sound.switch1.getBoolValue()) {
			return;
		}
		pts.Sim.Sound.switch1.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.switch1.setBoolValue(0);
		}, 0.2);
	},
};

setlistener("/systems/fcs/flaps/input", func() {
	if (pts.Sim.Sound.flapsClick.getBoolValue()) {
		return;
	}
	pts.Sim.Sound.flapsClick.setBoolValue(1);
	settimer(func() {
		pts.Sim.Sound.flapsClick.setBoolValue(0);
	}, 0.4);
}, 0, 0);

setlistener("/controls/switches/seatbelt-sign-status", func() {
	if (pts.Sim.Sound.seatbeltSign.getBoolValue()) {
		return;
	}
	if (systems.ELECTRICAL.Outputs.efis.getValue() >= 24) {
		pts.Sim.Sound.noSmokingSignInhibit.setBoolValue(1); # Prevent no smoking sound from playing at same time
		pts.Sim.Sound.seatbeltSign.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.seatbeltSign.setBoolValue(0);
			pts.Sim.Sound.noSmokingSignInhibit.setBoolValue(0);
		}, 2);
	}
}, 0, 0);

setlistener("/controls/switches/no-smoking-sign-status", func() {
	if (pts.Sim.Sound.noSmokingSign.getBoolValue()) {
		return;
	}
	if (systems.ELECTRICAL.Outputs.efis.getValue() >= 24 and !pts.Sim.Sound.noSmokingSignInhibit.getBoolValue()) {
		pts.Sim.Sound.noSmokingSign.setBoolValue(1);
		settimer(func() {
			pts.Sim.Sound.noSmokingSign.setBoolValue(0);
		}, 1);
	}
}, 0, 0);

setlistener("/engines/engine[0]/state", func() {
	setprop("/sim/sound/shutdown[0]", systems.ENGINES.state[0].getValue());
}, 0, 0);

setlistener("/engines/engine[1]/state", func() {
	setprop("/sim/sound/shutdown[1]", systems.ENGINES.state[1].getValue());
}, 0, 0);

setlistener("/engines/engine[2]/state", func() {
	setprop("/sim/sound/shutdown[2]", systems.ENGINES.state[2].getValue());
}, 0, 0);
