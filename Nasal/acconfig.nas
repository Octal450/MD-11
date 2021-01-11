# Aircraft Config Center V2.0.0
# Copyright (c) 2020 Josh Davidson (Octal450)

var CONFIG = {
	minFgfsInt: num(string.replace(getprop("/sim/minimum-fg-version"),".","")),
	minFgfsString: getprop("/sim/minimum-fg-version"),
	minOptionsRevision: 980, # Minimum revision of supported options
	noRevisionCheck: 0, # Disable ACCONFIG revision checks
};

var SYSTEM = {
	autoConfigRunning: props.globals.getNode("/systems/acconfig/autoconfig-running"),
	Error: {
		code: props.globals.initNode("/systems/acconfig/error-code", "0x000", "STRING"),
		outOfDate: 0,
		reason: props.globals.initNode("/systems/acconfig/error-reason", "", "STRING"),
	},
	newRevision: props.globals.initNode("/systems/acconfig/new-revision", 0, "INT"),
	revision: props.globals.initNode("/systems/acconfig/revision", 0, "INT"),
	revisionTemp: 0,
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
		
		fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-init"}));
		spinningT.stop();
		
		me.errorCheck();
		OPTIONS.read();
		
		if (!CONFIG.noRevisionCheck) { # Revision Checks Enabled
			if (me.Error.outOfDate) {
				fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-update"}));
			} else if (me.Error.code.getValue() == "0x000") {
				if (OPTIONS.savedRevision.getValue() < me.revisionTemp) {
					fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-updated"}));
				} else if (!OPTIONS.welcomeSkip.getBoolValue()) {
					fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-welcome"}));
				}
				
				# Only do on successful init
				OPTIONS.savedRevision.setValue(me.revisionTemp);
				RENDERING.check();
				OPTIONS.write();
			}
		} else { # No Revision Checks
			if (me.Error.code.getValue() == "0x000") {
				if (!OPTIONS.welcomeSkip.getBoolValue()) {
					fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-welcome"}));
				}
				
				# Only do on successful init
				RENDERING.check();
				OPTIONS.write();
			}
		}
	},
	errorCheck: func() {
		if (num(string.replace(getprop("/sim/version/flightgear"),".","")) < CONFIG.minFgfsInt) {
			me.Error.code.setValue("0x121");
			me.Error.reason.setValue("FGFS version is too old! Please update FlightGear to at least " ~ CONFIG.minFgfsString ~ ".");
			me.showError();
			print("System: Error 0x121");
		} else if (getprop("/gear/gear[0]/wow") == 0 or getprop("/position/altitude-ft") >= 15000) {
			me.Error.code.setValue("0x223");
			me.Error.reason.setValue("Preposterous configuration detected for initialization. Check your position or scenery.");
			me.showError();
			print("System: Error 0x223");
		} else if (getprop("/systems/acconfig/libraries-loaded") != 1 or getprop("/systems/acconfig/property-tree-setup-loaded") != 1) {
			me.Error.code.setValue("0x247");
			me.Error.reason.setValue("System files are missing or damaged. Please download a new copy of the aircraft.");
			me.showError();
			print("System: Error 0x247");
		}
	},
	showError: func() {
		libraries.systemsLoop.stop();
		systems.DUController.showError();
		fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-updated"}));
		fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-welcome"}));
		fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-error"}));
		# Kill menu items
		setprop("/sim/menubar/default/menu[101]/enabled", 0);
		setprop("/sim/menubar/default/menu[102]/enabled", 0);
		setprop("/sim/menubar/default/menu[103]/enabled", 0);
		setprop("/sim/menubar/default/menu[104]/enabled", 0);
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
		# Don't override higher settings
		if (me.landmass.getValue() < 4) {
			me.landmass.setValue(4);
		}
		if (me.model.getValue() < 2) {
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
	noRenderingWarn: props.globals.initNode("/systems/acconfig/options/no-rendering-warn", 0, "BOOL"),
	savedRevision: props.globals.initNode("/systems/acconfig/options/saved-revision", 0, "INT"),
	tempRevision: props.globals.initNode("/systems/acconfig/temp/saved-revision", 0, "INT"),
	welcomeSkip: props.globals.initNode("/systems/acconfig/options/welcome-skip", 0, "BOOL"),
	read: func() {
		io.read_properties(getprop("/sim/fg-home") ~ "/Export/MD-11-options.xml", "/systems/acconfig/temp");
		
		# Only load if options is new enough
		if (me.tempRevision.getValue() < CONFIG.minOptionsRevision) {
			print("System: Options reset!");
			gui.popupTip("System: Aircraft Options have been reset due to aircraft installation/update!", 10);
		} else {
			io.read_properties(getprop("/sim/fg-home") ~ "/Export/MD-11-options.xml", "/systems/acconfig/options");
			
			# These aren't stored in acconfig themselves, so we move them there
			setprop("/sim/model/autopush/route/show", getprop("/systems/acconfig/options/autopush/show-route"));
			setprop("/sim/model/autopush/route/show-wingtip", getprop("/systems/acconfig/options/autopush/show-wingtip"));
			print("System: Options loaded successfully!");
		}
	},
	write: func() {
		# These aren't stored in acconfig themselves, so we move them there
		setprop("/systems/acconfig/options/autopush/show-route", getprop("/sim/model/autopush/route/show"));
		setprop("/systems/acconfig/options/autopush/show-wingtip", getprop("/sim/model/autopush/route/show-wingtip"));
		
		io.write_properties(getprop("/sim/fg-home") ~ "/Export/MD-11-options.xml", "/systems/acconfig/options");
	},
};

var spinningT = maketimer(0.05, SYSTEM, SYSTEM.spinning);
SYSTEM.simInit();

setlistener("/sim/signals/fdm-initialized", func() {
	SYSTEM.fdmInit();
});

# Panel States specifically designed to work with IntegratedSystems design
var PANEL = {
	l1: nil,
	engTimer: 10,
	panelBase: func(t) {
		SYSTEM.autoConfigRunning.setBoolValue(1);
		spinningT.start();
		fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-psloaded"}));
		fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-psload"}));
		systems.doIdleThrust();
		libraries.systemsInit();
		pts.Controls.Flight.speedbrake.setValue(0);
		if (t == 1) {
			pts.Controls.Flight.elevatorTrim.setValue(-0.2967742); # About 4.6ANU -->
			pts.Controls.Flight.flaps.setValue(0.36); # 10-25/EXT
			pts.Controls.Flight.speedbrakeArm.setBoolValue(1);
			systems.BRAKES.Switch.abs.setValue(-1); # T/O
		} else {
			pts.Controls.Flight.elevatorTrim.setValue(-0.1935484); # About 3ANU
			pts.Controls.Flight.flaps.setValue(0);
			pts.Controls.Flight.speedbrakeArm.setBoolValue(0);
		}
		pts.Controls.Gear.leverCockpit.setValue(3);
	},
	coldDark: func() {
		me.panelBase(0);
		
		systems.ENGINE.Switch.cutoffSwitch[0].setBoolValue(1);
		systems.ENGINE.Switch.cutoffSwitch[1].setBoolValue(1);
		systems.ENGINE.Switch.cutoffSwitch[2].setBoolValue(1);
		
		settimer(func() { # Give things a moment to settle
			fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-psload"}));
			spinningT.stop();
			fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-psloaded"}));
			SYSTEM.autoConfigRunning.setBoolValue(0);
		}, 1);
	},
	beforeStart: func() {
		me.panelBase(0);
		
		systems.ELEC.Switch.battery.setBoolValue(1);
		systems.ELEC.Switch.emerPwSw.setValue(1);
		systems.APU.fastStart();
		systems.IRS.Switch.knob[0].setBoolValue(1);
		systems.IRS.Switch.knob[1].setBoolValue(1);
		systems.IRS.Switch.knob[2].setBoolValue(1);
		systems.IRS.Switch.mcduBtn.setBoolValue(1);
		pts.Controls.Lighting.beacon.setBoolValue(1);
		pts.Controls.Lighting.navLights.setBoolValue(1);
		pts.Controls.Switches.seatbeltSign.setBoolValue(1);
		
		systems.ENGINE.Switch.cutoffSwitch[0].setBoolValue(1);
		systems.ENGINE.Switch.cutoffSwitch[1].setBoolValue(1);
		systems.ENGINE.Switch.cutoffSwitch[2].setBoolValue(1);
		
		l1 = setlistener("/engines/engine[3]/state", func() {
			if (systems.APU.state.getValue() == 3) {
				removelistener(l1);
				systems.ELEC.Switch.apuPwr.setBoolValue(1);
				systems.PNEU.Switch.bleedApu.setBoolValue(1);
				fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-psload"}));
				spinningT.stop();
				fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-psloaded"}));
				SYSTEM.autoConfigRunning.setBoolValue(0);
			}
		});
	},
	afterStart: func(t) {
		me.panelBase(t);
		
		systems.ELEC.Switch.battery.setBoolValue(1);
		systems.ELEC.Switch.emerPwSw.setValue(1);
		systems.ELEC.Source.Ext.cart.setBoolValue(1); # autoConfigRunning cancels disable check in libraries.nas
		systems.ELEC.Switch.extPwr.setBoolValue(1);
		systems.ELEC.Switch.extGPwr.setBoolValue(1);
		pts.Controls.Switches.seatbeltSign.setBoolValue(1);
		systems.IRS.Switch.knob[0].setBoolValue(1);
		systems.IRS.Switch.knob[1].setBoolValue(1);
		systems.IRS.Switch.knob[2].setBoolValue(1);
		systems.IRS.Switch.mcduBtn.setBoolValue(1);
		pts.Controls.Lighting.beacon.setBoolValue(1);
		pts.Controls.Lighting.navLights.setBoolValue(1);
		systems.IGNITION.Switch.ignA.setBoolValue(1);
		
		if (pts.Engines.Engine.state[0].getValue() != 3 or pts.Engines.Engine.state[1].getValue() != 3 or pts.Engines.Engine.state[2].getValue() != 3) {
			engTimer = 10;
			settimer(func() {
				systems.IGNITION.fastStart(0);
				systems.IGNITION.fastStart(1);
				systems.IGNITION.fastStart(2);
			}, 0.5);
		} else {
			engTimer = 1;
		}
		
		l1 = setlistener("/engines/engine[1]/state", func() {
			if (pts.Engines.Engine.state[1].getValue() == 3) {
				removelistener(l1);
				systems.ELEC.Source.Ext.cart.setBoolValue(0);
				systems.ELEC.Switch.extPwr.setBoolValue(0);
				systems.ELEC.Switch.extGPwr.setBoolValue(0);
				if (t == 1) {
					pts.Controls.Lighting.strobe.setBoolValue(1);
					pts.Controls.Lighting.landingLightL.setValue(1);
					pts.Controls.Lighting.landingLightN.setValue(1);
					pts.Controls.Lighting.landingLightR.setValue(1);
					
				} else {
					pts.Controls.Lighting.landingLightL.setValue(0.5);
					pts.Controls.Lighting.landingLightN.setValue(0.5);
					pts.Controls.Lighting.landingLightR.setValue(0.5);
				}
				settimer(func() { # Give things a moment to settle
					fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-psload"}));
					spinningT.stop();
					fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-psloaded"}));
					SYSTEM.autoConfigRunning.setBoolValue(0);
				}, engTimer);
			}
		});
	},
};
