# Aircraft Config Center
# Copyright (c) 2019 Joshua Davidson (Octal450)

var spinning = maketimer(0.05, func {
	var spinning = getprop("/systems/acconfig/spinning");
	if (spinning == 0) {
		setprop("/systems/acconfig/spin", "\\");
		setprop("/systems/acconfig/spinning", 1);
	} else if (spinning == 1) {
		setprop("/systems/acconfig/spin", "|");
		setprop("/systems/acconfig/spinning", 2);
	} else if (spinning == 2) {
		setprop("/systems/acconfig/spin", "/");
		setprop("/systems/acconfig/spinning", 3);
	} else if (spinning == 3) {
		setprop("/systems/acconfig/spin", "-");
		setprop("/systems/acconfig/spinning", 0);
	}
});

var failReset = func {
	systems.ELEC.resetFail();
	systems.FCTL.resetFail();
	systems.FUEL.resetFail();
	systems.HYD.resetFail();
	systems.PNEU.resetFail();
}

setprop("/systems/acconfig/autoconfig-running", 0);
setprop("/systems/acconfig/spinning", 0);
setprop("/systems/acconfig/spin", "-");
setprop("/systems/acconfig/new-revision", 0);
setprop("/systems/acconfig/out-of-date", 0);
setprop("/systems/acconfig/mismatch-code", "0x000");
setprop("/systems/acconfig/mismatch-reason", "XX");
setprop("/systems/acconfig/options/autopush/show-route", 1);
setprop("/systems/acconfig/options/autopush/show-wingtip", 1);
setprop("/systems/acconfig/options/deflected-aileron-equipped", 1);
setprop("/systems/acconfig/options/ead-rate", 1);
setprop("/systems/acconfig/options/irs-skip", 0);
setprop("/systems/acconfig/options/keyboard-mode", 0);
setprop("/systems/acconfig/options/nd-rate", 1);
setprop("/systems/acconfig/options/no-rendering-warn", 0);
setprop("/systems/acconfig/options/pfd-rate", 1);
setprop("/systems/acconfig/options/revision", 0);
setprop("/systems/acconfig/options/sd-rate", 1);
setprop("/systems/acconfig/options/welcome-skip", 0);
var main_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/main/dialog", "Aircraft/IDG-MD-11/AircraftConfig/main.xml");
var welcome_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/welcome/dialog", "Aircraft/IDG-MD-11/AircraftConfig/welcome.xml");
var ps_load_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/psload/dialog", "Aircraft/IDG-MD-11/AircraftConfig/psload.xml");
var ps_loaded_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/psloaded/dialog", "Aircraft/IDG-MD-11/AircraftConfig/psloaded.xml");
var init_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/init/dialog", "Aircraft/IDG-MD-11/AircraftConfig/ac_init.xml");
var help_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/help/dialog", "Aircraft/IDG-MD-11/AircraftConfig/help.xml");
var fctl_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/fctl/dialog", "Aircraft/IDG-MD-11/AircraftConfig/fctl.xml");
var fail_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/fail/dialog", "Aircraft/IDG-MD-11/AircraftConfig/fail.xml");
var about_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/about/dialog", "Aircraft/IDG-MD-11/AircraftConfig/about.xml");
var update_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/update/dialog", "Aircraft/IDG-MD-11/AircraftConfig/update.xml");
var updated_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/updated/dialog", "Aircraft/IDG-MD-11/AircraftConfig/updated.xml");
var error_mismatch = gui.Dialog.new("sim/gui/dialogs/acconfig/error/mismatch/dialog", "Aircraft/IDG-MD-11/AircraftConfig/error-mismatch.xml");
var du_quality = gui.Dialog.new("sim/gui/dialogs/acconfig/du-quality/dialog", "Aircraft/IDG-MD-11/AircraftConfig/du-quality.xml");
var rendering_dlg = gui.Dialog.new("sim/gui/dialogs/rendering/dialog", "Aircraft/IDG-MD-11/AircraftConfig/rendering.xml");
spinning.start();
init_dlg.open();

http.load("https://raw.githubusercontent.com/Octal450/IDG-MD-11/master/revision.txt").done(func(r) setprop("/systems/acconfig/new-revision", r.response));
var revisionFile = (getprop("/sim/aircraft-dir") ~ "/revision.txt");
var current_revision = io.readfile(revisionFile);
print("IDG MD-11 Revision: " ~ current_revision);
setprop("/systems/acconfig/revision", current_revision);

setlistener("/systems/acconfig/new-revision", func {
	if (getprop("/systems/acconfig/new-revision") > current_revision) {
		setprop("/systems/acconfig/out-of-date", 1);
	} else {
		setprop("/systems/acconfig/out-of-date", 0);
	}
});

var mismatch_chk = func {
	if (num(string.replace(getprop("/sim/version/flightgear"),".","")) < 201830) {
		setprop("/systems/acconfig/mismatch-code", "0x121");
		setprop("/systems/acconfig/mismatch-reason", "FGFS version is too old! Please update FlightGear to at least 2018.3.0.");
		if (getprop("/systems/acconfig/out-of-date") != 1) {
			error_mismatch.open();
		}
		libraries.systemsLoop.stop();
		print("Mismatch: 0x121");
		welcome_dlg.close();
	} else if (getprop("/gear/gear[0]/wow") == 0 or getprop("/position/altitude-ft") >= 15000) {
		setprop("/systems/acconfig/mismatch-code", "0x223");
		setprop("/systems/acconfig/mismatch-reason", "Preposterous configuration detected for initialization. Check your position or scenery.");
		if (getprop("/systems/acconfig/out-of-date") != 1) {
			error_mismatch.open();
		}
		libraries.systemsLoop.stop();
		print("Mismatch: 0x223");
		welcome_dlg.close();
	} else if (getprop("/systems/acconfig/libraries-loaded") != 1 or getprop("/systems/acconfig/property-tree-setup-loaded") != 1) {
		setprop("/systems/acconfig/mismatch-code", "0x247");
		setprop("/systems/acconfig/mismatch-reason", "System files are missing or damaged. Please download a new copy of the aircraft.");
		if (getprop("/systems/acconfig/out-of-date") != 1) {
			error_mismatch.open();
		}
		libraries.systemsLoop.stop();
		print("Mismatch: 0x247");
		welcome_dlg.close();
	}
}

setlistener("/sim/signals/fdm-initialized", func {
	init_dlg.close();
	if (getprop("/systems/acconfig/out-of-date") == 1) {
		update_dlg.open();
		print("System: The IDG-MD-11 is out of date!");
	} 
	mismatch_chk();
	readSettings();
	if (getprop("/systems/acconfig/out-of-date") != 1 and getprop("/systems/acconfig/options/revision") < current_revision and getprop("/systems/acconfig/mismatch-code") == "0x000") {
		updated_dlg.open();
		if (getprop("/systems/acconfig/options/no-rendering-warn") != 1) {
			renderingSettings.check();
		}
	} else if (getprop("/systems/acconfig/out-of-date") != 1 and getprop("/systems/acconfig/mismatch-code") == "0x000" and getprop("/systems/acconfig/options/welcome-skip") != 1) {
		welcome_dlg.open();
		if (getprop("/systems/acconfig/options/no-rendering-warn") != 1) {
			renderingSettings.check();
		}
	}
	setprop("/systems/acconfig/options/revision", current_revision);
	writeSettings();
	spinning.stop();
});

var renderingSettings = {
	check: func() {
		var rembrandt = getprop("/sim/rendering/rembrandt/enabled");
		var ALS = getprop("/sim/rendering/shaders/skydome");
		var customSettings = getprop("/sim/rendering/shaders/custom-settings") == 1;
		var landmass = getprop("/sim/rendering/shaders/landmass") >= 4;
		var model = getprop("/sim/rendering/shaders/model") >= 2;
		if (!rembrandt and (!ALS or !customSettings or !landmass or !model)) {
			rendering_dlg.open();
		}
	},
	fixAll: func() {
		me.fixCore();
		var landmass = getprop("/sim/rendering/shaders/landmass") >= 4;
		var model = getprop("/sim/rendering/shaders/model") >= 2;
		if (!landmass) {
			setprop("/sim/rendering/shaders/landmass", 4);
		}
		if (!model) {
			setprop("/sim/rendering/shaders/model", 2);
		}
	},
	fixCore: func() {
		setprop("/sim/rendering/shaders/skydome", 1); # ALS on
		setprop("/sim/rendering/shaders/custom-settings", 1);
		gui.popupTip("Rendering Settings updated!");
	},
};

var readSettings = func {
	io.read_properties(getprop("/sim/fg-home") ~ "/Export/IDG-MD-11-config.xml", "/systems/acconfig/options");
	setprop("/sim/model/autopush/route/show", getprop("/systems/acconfig/options/autopush/show-route"));
	setprop("/sim/model/autopush/route/show-wingtip", getprop("/systems/acconfig/options/autopush/show-wingtip"));
	setprop("/controls/hydraulics/deflected-aileron-equipped", getprop("/systems/acconfig/options/deflected-aileron-equipped"));
	setprop("/controls/irs/skip", getprop("/systems/acconfig/options/irs-skip"));
	setprop("/options/system/keyboard-mode", getprop("/systems/acconfig/options/keyboard-mode"));
}

var writeSettings = func {
	setprop("/systems/acconfig/options/autopush/show-route", getprop("/sim/model/autopush/route/show"));
	setprop("/systems/acconfig/options/autopush/show-wingtip", getprop("/sim/model/autopush/route/show-wingtip"));
	setprop("/systems/acconfig/options/deflected-aileron-equipped", getprop("/controls/hydraulics/deflected-aileron-equipped"));
	setprop("/systems/acconfig/options/irs-skip", getprop("/controls/irs/skip"));
	setprop("/systems/acconfig/options/keyboard-mode", getprop("/options/system/keyboard-mode"));
	io.write_properties(getprop("/sim/fg-home") ~ "/Export/IDG-MD-11-config.xml", "/systems/acconfig/options");
}

################
# Panel States #
################

# Cold and Dark
var colddark = func {
	if (getprop("/systems/acconfig/mismatch-code") == "0x000") {
		spinning.start();
		ps_loaded_dlg.close();
		ps_load_dlg.open();
		setprop("/systems/acconfig/autoconfig-running", 1);
		setprop("/controls/gear/brake-left", 1);
		setprop("/controls/gear/brake-right", 1);
		# Initial shutdown, and reinitialization.
		setprop("/controls/engines/engine[0]/start-switch", 0);
		setprop("/controls/engines/engine[1]/start-switch", 0);
		setprop("/controls/engines/engine[2]/start-switch", 0);
		setprop("/controls/engines/engine[0]/cutoff-switch", 1);
		setprop("/controls/engines/engine[1]/cutoff-switch", 1);
		setprop("/controls/engines/engine[2]/cutoff-switch", 1);
		setprop("/controls/flight/flaps", 0);
		setprop("/controls/hydraulics/deflected-aileron", 0);
		setprop("/controls/flight/speedbrake-arm", 0);
		setprop("/controls/flight/speedbrake", 0);
		setprop("/controls/gear/gear-down", 1);
		setprop("/controls/flight/elevator-trim", -0.25);
		libraries.systemsInit();
		if (getprop("/engines/engine[1]/n2-actual") < 2) {
			colddark_b();
		} else {
			var colddark_eng_off = setlistener("/engines/engine[1]/n2-actual", func {
				if (getprop("/engines/engine[1]/n2-actual") < 2) {
					removelistener(colddark_eng_off);
					colddark_b();
				}
			});
		}
	}
}
var colddark_b = func {
	# Continues the Cold and Dark script, after engines fully shutdown.
	setprop("/controls/apu/start", 0);
	settimer(func {
		setprop("/controls/gear/brake-left", 0);
		setprop("/controls/gear/brake-right", 0);
		setprop("/systems/acconfig/autoconfig-running", 0);
		ps_load_dlg.close();
		ps_loaded_dlg.open();
		spinning.stop();
	}, 2);
}

# Ready to Start Eng
var beforestart = func {
	if (getprop("/systems/acconfig/mismatch-code") == "0x000") {
		spinning.start();
		ps_loaded_dlg.close();
		ps_load_dlg.open();
		setprop("/systems/acconfig/autoconfig-running", 1);
		setprop("/controls/gear/brake-left", 1);
		setprop("/controls/gear/brake-right", 1);
		# First, we set everything to cold and dark.
		setprop("/controls/engines/engine[0]/start-switch", 0);
		setprop("/controls/engines/engine[1]/start-switch", 0);
		setprop("/controls/engines/engine[2]/start-switch", 0);
		setprop("/controls/engines/engine[0]/cutoff-switch", 1);
		setprop("/controls/engines/engine[1]/cutoff-switch", 1);
		setprop("/controls/engines/engine[2]/cutoff-switch", 1);
		setprop("/controls/flight/flaps", 0);
		setprop("/controls/hydraulics/deflected-aileron", 0);
		setprop("/controls/flight/speedbrake-arm", 0);
		setprop("/controls/flight/speedbrake", 0);
		setprop("/controls/gear/gear-down", 1);
		setprop("/controls/flight/elevator-trim", -0.25);
		libraries.systemsInit();
		setprop("/controls/apu/start", 0);
		
		# Now the Startup!
		setprop("/controls/electrical/switches/battery", 1);
		setprop("/controls/electrical/switches/emer-pw-sw", 1);
		settimer(func {
			setprop("/controls/apu/start", 1);
			var apu_rpm_chk = setlistener("/systems/apu/n2", func {
				if (getprop("/systems/apu/n2") >= 98) {
					removelistener(apu_rpm_chk);
					beforestart_b();
				}
			});
		}, 0.5);
	}
}
var beforestart_b = func {
	# Continue with engine start prep.
	setprop("/controls/electrical/switches/apu-pwr", 1);
	setprop("/controls/pneumatics/switches/bleed-apu", 1);
	setprop("/controls/irs/ir[0]/knob","1");
	setprop("/controls/irs/ir[1]/knob","1");
	setprop("/controls/irs/ir[2]/knob","1");
	systems.IRS.skip(0);
	systems.IRS.skip(1);
	systems.IRS.skip(2);
	setprop("/controls/irs/mcducbtn", 1);
	setprop("/controls/lighting/beacon", 1);
	setprop("/controls/lighting/nav-lights", 1);
	settimer(func {
		setprop("/controls/gear/brake-left", 0);
		setprop("/controls/gear/brake-right", 0);
		setprop("/systems/acconfig/autoconfig-running", 0);
		ps_load_dlg.close();
		ps_loaded_dlg.open();
		spinning.stop();
	}, 2);
}

# Ready to Taxi
var taxi = func {
	if (getprop("/systems/acconfig/mismatch-code") == "0x000") {
		spinning.start();
		ps_loaded_dlg.close();
		ps_load_dlg.open();
		setprop("/systems/acconfig/autoconfig-running", 1);
		setprop("/controls/gear/brake-left", 1);
		setprop("/controls/gear/brake-right", 1);
		# First, we set everything to cold and dark.
		setprop("/controls/engines/engine[0]/start-switch", 0);
		setprop("/controls/engines/engine[1]/start-switch", 0);
		setprop("/controls/engines/engine[2]/start-switch", 0);
		setprop("/controls/engines/engine[0]/cutoff-switch", 1);
		setprop("/controls/engines/engine[1]/cutoff-switch", 1);
		setprop("/controls/engines/engine[2]/cutoff-switch", 1);
		setprop("/controls/flight/flaps", 0);
		setprop("/controls/hydraulics/deflected-aileron", 0);
		setprop("/controls/flight/speedbrake-arm", 0);
		setprop("/controls/flight/speedbrake", 0);
		setprop("/controls/gear/gear-down", 1);
		setprop("/controls/flight/elevator-trim", -0.25);
		libraries.systemsInit();
		setprop("/controls/apu/start", 0);
		
		# Now the Startup!
		setprop("/controls/electrical/switches/battery", 1);
		setprop("/controls/electrical/switches/emer-pw-sw", 1);
		settimer(func {
			setprop("/controls/apu/start", 1);
			var apu_rpm_chk = setlistener("/systems/apu/n2", func {
				if (getprop("/systems/apu/n2") >= 98) {
					removelistener(apu_rpm_chk);
					taxi_b();
				}
			});
		}, 0.5);
	}
}
var taxi_b = func {
	# Continue with engine start prep
	setprop("/controls/electrical/switches/apu-pwr", 1);
	setprop("/controls/pneumatics/switches/bleed-apu", 1);
	setprop("/controls/irs/ir[0]/knob","1");
	setprop("/controls/irs/ir[1]/knob","1");
	setprop("/controls/irs/ir[2]/knob","1");
	systems.IRS.skip(0);
	systems.IRS.skip(1);
	systems.IRS.skip(2);
	setprop("/controls/irs/mcducbtn", 1);
	setprop("/controls/engines/ign-a", 1);
	setprop("/controls/lighting/beacon", 1);
	setprop("/controls/lighting/nav-lights", 1);
	setprop("/controls/lighting/landing-light-l", 0.5);
	setprop("/controls/lighting/landing-light-n", 0.5);
	setprop("/controls/lighting/landing-light-r", 0.5);
	settimer(taxi_c, 2);
}
var taxi_c = func {
	# Start engines
	systems.fast_start_one();
	systems.fast_start_two();
	systems.fast_start_three();
	settimer(func {
		taxi_d();
	}, 10);
}
var taxi_d = func {
	# After Start items.
	setprop("/controls/apu/start", 0);
	setprop("/controls/gear/brake-left", 0);
	setprop("/controls/gear/brake-right", 0);
	setprop("/systems/acconfig/autoconfig-running", 0);
	ps_load_dlg.close();
	ps_loaded_dlg.open();
	spinning.stop();
}

# Ready to Takeoff
var takeoff = func {
	if (getprop("/systems/acconfig/mismatch-code") == "0x000") {
		# The same as taxi, except we set some things afterwards.
		taxi();
		var eng_one_chk_c = setlistener("/engines/engine[0]/state", func {
			if (getprop("/engines/engine[0]/state") == 3) {
				removelistener(eng_one_chk_c);
				setprop("/controls/lighting/strobe", 1);
				setprop("/controls/lighting/landing-light-l", 1);
				setprop("/controls/lighting/landing-light-n", 1);
				setprop("/controls/lighting/landing-light-r", 1);
				setprop("/controls/flight/speedbrake-arm", 1);
				setprop("/controls/flight/flaps", 0.36); # 10-25/EXT
				if (getprop("/controls/hydraulics/deflected-aileron-equipped") == 1) {
					if (getprop("/gear/gear[0]/wow") == 1) {
						setprop("/controls/hydraulics/deflected-aileron", 1);
					}
				} else {
					setprop("/controls/hydraulics/deflected-aileron", 0);
				}
				setprop("/controls/flight/elevator-trim", -0.29);
				setprop("/controls/autobrake/switch", -1);
			}
		});
	}
}
