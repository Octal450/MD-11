# Aircraft Config Center
# Joshua Davidson (it0uchpods)

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

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

#var failReset = func {
#}

#failReset();
setprop("/systems/acconfig/autoconfig-running", 0);
setprop("/systems/acconfig/spinning", 0);
setprop("/systems/acconfig/spin", "-");
var main_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/main/dialog", "Aircraft/MD-11Family/AircraftConfig/main.xml");
var welcome_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/welcome/dialog", "Aircraft/MD-11Family/AircraftConfig/welcome.xml");
var ps_load_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/psload/dialog", "Aircraft/MD-11Family/AircraftConfig/psload.xml");
var ps_loaded_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/psloaded/dialog", "Aircraft/MD-11Family/AircraftConfig/psloaded.xml");
var init_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/init/dialog", "Aircraft/MD-11Family/AircraftConfig/ac_init.xml");
var help_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/help/dialog", "Aircraft/MD-11Family/AircraftConfig/help.xml");
#var fctl_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/fctl/dialog", "Aircraft/MD-11Family/AircraftConfig/fctl.xml");
#var fail_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/fail/dialog", "Aircraft/MD-11Family/AircraftConfig/fail.xml");
var about_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/about/dialog", "Aircraft/MD-11Family/AircraftConfig/about.xml");
spinning.start();
init_dlg.open();

setlistener("/sim/signals/fdm-initialized", func {
	init_dlg.close();
	welcome_dlg.open();
	spinning.stop();
});

#var saveSettings = func {
#	aircraft.data.add("/something", "/something");
#	aircraft.data.save();
#}

#saveSettings();

var systemsReset = func {
	librariesLoop.start();
	afs.ap_init();
	setprop("/it-autoflight/input/fd1", 1);
	setprop("/it-autoflight/input/fd2", 1);
}
