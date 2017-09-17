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

var failReset = func {
}

failReset();
setprop("/systems/acconfig/autoconfig-running", 0);
setprop("/systems/acconfig/spinning", 0);
setprop("/systems/acconfig/spin", "-");
setprop("/systems/acconfig/new-revision", "");
setprop("/systems/acconfig/out-of-date", 0);
var main_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/main/dialog", "Aircraft/IDG-MD-11X/AircraftConfig/main.xml");
var welcome_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/welcome/dialog", "Aircraft/IDG-MD-11X/AircraftConfig/welcome.xml");
var ps_load_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/psload/dialog", "Aircraft/IDG-MD-11X/AircraftConfig/psload.xml");
var ps_loaded_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/psloaded/dialog", "Aircraft/IDG-MD-11X/AircraftConfig/psloaded.xml");
var init_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/init/dialog", "Aircraft/IDG-MD-11X/AircraftConfig/ac_init.xml");
var help_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/help/dialog", "Aircraft/IDG-MD-11X/AircraftConfig/help.xml");
var fctl_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/fctl/dialog", "Aircraft/IDG-MD-11X/AircraftConfig/fctl.xml");
#var fail_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/fail/dialog", "Aircraft/IDG-MD-11X/AircraftConfig/fail.xml");
var about_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/about/dialog", "Aircraft/IDG-MD-11X/AircraftConfig/about.xml");
var update_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/update/dialog", "Aircraft/IDG-MD-11X/AircraftConfig/update.xml");
spinning.start();
init_dlg.open();

#http.load("https://raw.githubusercontent.com/it0uchpods/A320Family/master/revision.txt").done(func(r) setprop("/systems/acconfig/new-revision", r.response));
#var revisionFile = (getprop("/sim/aircraft-dir")~"/revision.txt");
#var current_revision = io.readfile(revisionFile);

#setlistener("/systems/acconfig/new-revision", func {
#	if (getprop("/systems/acconfig/new-revision") > current_revision) {
#		setprop("/systems/acconfig/out-of-date", 1);
#	} else {
#		setprop("/systems/acconfig/out-of-date", 0);
#	}
#});

setlistener("/sim/signals/fdm-initialized", func {
	init_dlg.close();
#	if (getprop("/systems/acconfig/out-of-date") == 1) {
#		update_dlg.open();
#		print("The MD-11Family is out of date!");
#	} else {
		welcome_dlg.open();
#	}
	spinning.stop();
});

var saveSettings = func {
#	aircraft.data.add("/something");
#	aircraft.data.save();
}

saveSettings();

var systemsReset = func {
	systems.hyd_init();
	thrust.fadec_reset();
	afs.ap_init();
	systems.irs_init();
}
