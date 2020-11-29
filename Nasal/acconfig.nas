# Aircraft Config Center V2.0.0
# Copyright (c) 2020 Josh Davidson (Octal450)

var CONFIG = {
	minFgfsInt: "202011", # Minimum FlightGear version without the decimal points, 2020.1.1
	minOptionsRevision: 1, # Minimum revision of saved options file
	noRevisionCheck: 0, # Disable ACCONFIG revision checks
};

var SYSTEM = {
	autoConfigRunning: props.globals.getNode("/systems/acconfig/autoconfig-running"),
	Error: {
		code: props.globals.initNode("/systems/acconfig/error-code", "0x000", "STRING"),
		critical: 0,
		incompatibleConfig: props.globals.initNode("/systems/acconfig/incompatible-config"),
		outOfDate: 0,
		reason: props.globals.initNode("/systems/acconfig/error-reason", "", "STRING"),
	},
	newRevision: props.globals.initNode("/systems/acconfig/new-revision", 0, "INT"),
	revision: props.globals.initNode("/systems/acconfig/revision", 0, "INT"),
	revisionTemp: 0,
	savedRevision: props.globals.getNode("/systems/acconfig/options/saved-revision"),
	spinner: "\\",
	simInit: func() {
		me.autoConfigRunning.setBoolValue(0);
		spinningT.start();
		fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-init"}));
		if (!CONFIG.noRevisionCheck) {
			http.load("https://raw.githubusercontent.com/Octal450/MD-11/master/revision.txt").done(func(r) me.newRevision.setValue(r.response));
			me.revision.setValue(io.readfile(getprop("/sim/aircraft-dir") ~ "/revision.txt"));
			print("System: MD-11 Revision " ~ me.revision.getValue());
		}
	},
	fdmInit: func() {
		if (!CONFIG.noRevisionCheck) {
			me.revisionTemp = me.revision.getValue();
			if (me.newRevision.getValue() > me.revisionTemp) {
				me.Error.outOfDate = 1;
				print("System: Aircraft update available!");
			} else {
				me.Error.outOfDate = 0;
				print("System: No aircraft update available!");
			}
		} else {
			print("System: Revision checks have been turned off!");
		}
		
		spinningT.stop();
		fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-init"}));
		
		#me.errorCheck();
		OPTIONS.readSettings();
		
		if (!CONFIG.noRevisionCheck) { # Revision Checks Enabled
			if (me.Error.outOfDate) {
				fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-update"}));
			} else if (me.Error.code.getValue() == "0x000") {
				if (me.savedRevision.getValue() < me.revisionTemp or me.Error.incompatibleConfig.getBoolValue()) {
					fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-updated"}));
				} else if (!OPTIONS.welcomeSkip.getBoolValue()) {
					fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-welcome"}));
				}
				
				# Only do on successful init
				me.savedRevision.setValue(me.revisionTemp);
				RENDERING.check();
			}
		} else { # No Revision Checks
			if (me.Error.code.getValue() == "0x000") {
				if (!OPTIONS.welcomeSkip.getBoolValue()) {
					fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-welcome"}));
				}
				
				# Only do on successful init
				RENDERING.check();
			}
		}
	},
	resetFailures: func() {
		systems.ELEC.resetFailures();
		systems.FCTL.resetFailures();
		systems.FUEL.resetFailures();
		systems.HYD.resetFailures();
		systems.PNEU.resetFailures();
	},
	spinning: func() {
		if (me.spinner == "\\") {
			me.spinner = "|";
		} else if (me.spinner == "|") {
			me.spinner = "/";
		} else if (me.spinner == "/") {
			me.spinner = "-";
		} else if (me.spinner == "-") {
			me.spinner = "\\";
		}
		props.globals.getNode("/systems/acconfig/spinner-prop").setValue(me.spinner);
	},
};

var RENDERING = {
	als: props.globals.getNode("/sim/rendering/shaders/skydome"),
	customSettings: props.globals.getNode("/sim/rendering/shaders/custom-settings"),
	landmass: props.globals.getNode("/sim/rendering/shaders/landmass"),
	landmassSet: 0,
	model: props.globals.getNode("/sim/rendering/shaders/model"),
	modelSet: 0,
	rembrandt: props.globals.getNode("/sim/rendering/rembrandt/enabled"),
	check: func() {
		if (OPTIONS.noRenderingWarn.getBoolValue()) {
			return;
		}
		
		me.landmassSet = me.landmass.getValue() >= 4;
		me.modelSet = me.model.getValue() >= 2;
		
		if (!me.rembrandt.getBoolValue() and (!me.als.getBoolValue() or !me.customSettings.getBoolValue() or !me.landmassSet or !me.modelSet)) {
			fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-rendering"}));
		}
	},
	fixAll: func() {
		me.landmassSet = me.landmass.getValue() >= 4;
		me.modelSet = me.model.getValue() >= 2;
		
		# Don't override higher settings
		if (!me.landmassSet) {
			me.landmass.setValue(4);
		}
		if (!me.modelSet) {
			me.model.setValue(2);
		}
		
		me.fixCore();
	},
	fixCore: func() {
		me.als.setBoolValue(1); # ALS on
		me.customSettings.setBoolValue(1);
		
		print("System: Rendering Settings updated!");
		gui.popupTip("System: Rendering settings updated!");
	},
};

var OPTIONS = {
	noRenderingWarn: props.globals.getNode("/systems/acconfig/options/no-rendering-warn"),
	welcomeSkip: props.globals.getNode("/systems/acconfig/options/welcome-skip"),
	readSettings: func() {
		
	},
	writeSettings: func() {
		
	},
};

var spinningT = maketimer(0.05, SYSTEM, SYSTEM.spinning);
SYSTEM.simInit();

setlistener("/sim/signals/fdm-initialized", func() {
	SYSTEM.fdmInit();
});
