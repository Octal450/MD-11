# Aircraft Configuration Center V2
# Copyright (c) 2025 Josh Davidson (Octal450)

var CONFIG = {
	minFgfs: split(".", getprop("/sim/minimum-fg-version")),
	minFgfsString: getprop("/sim/minimum-fg-version"),
	minOptionsRevision: 1710, # Minimum revision of supported options
	noUpdateCheck: 0, # Disable ACCONFIG update checks
};

var SYSTEM = {
	autoConfigRunning: props.globals.getNode("/systems/acconfig/autoconfig-running"),
	Error: {
		active: props.globals.initNode("/systems/acconfig/error-active", 0, "BOOL"),
		outOfDate: 0,
		reason: props.globals.initNode("/systems/acconfig/error-reason", "", "STRING"),
	},
	fgfs: split(".", getprop("/sim/version/flightgear")),
	newRevision: props.globals.initNode("/systems/acconfig/new-revision", 0, "INT"),
	revision: props.globals.initNode("/systems/acconfig/revision", 0, "INT"),
	revisionTemp: 0,
	spinner: "\\",
	spinnerProp: props.globals.initNode("/systems/acconfig/spinner-prop", "\\", "STRING"),
	simInit: func() {
		print("System: Initializing " ~ getprop("/sim/aircraft"));
		PANEL.stop = 1;
		me.autoConfigRunning.setBoolValue(0);
		spinningT.start();
		fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-init"}));
		if (!CONFIG.noUpdateCheck) {
			http.load("https://raw.githubusercontent.com/Octal450/MD-11/master/revision.txt").done(func(r) me.newRevision.setValue(r.response));
		}
		me.revision.setValue(io.readfile(getprop("/sim/aircraft-dir") ~ "/revision.txt"));
		print("System: Version " ~ me.revision.getValue());
	},
	fdmInit: func() {
		me.revisionTemp = me.revision.getValue();
		
		if (!CONFIG.noUpdateCheck) {
			if (me.newRevision.getValue() > me.revisionTemp) {
				me.Error.outOfDate = 1;
				print("System: Aircraft update available!");
			} else {
				me.Error.outOfDate = 0;
				print("System: No aircraft update available!");
			}
		} else {
			print("System: Update checks have been turned off!");
		}
		
		fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-init"}));
		spinningT.stop();
		OPTIONS.read();
	},
	finalInit: func() {
		me.errorCheck();
		
		if (!CONFIG.noUpdateCheck) { # Update Checks Enabled
			if (me.Error.outOfDate) {
				fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-update"}));
			} else if (!me.Error.active.getBoolValue()) {
				if (OPTIONS.savedRevision.getValue() < me.revisionTemp) {
					fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-updated"}));
				} else if (OPTIONS.openOnLaunch.getBoolValue()) {
					fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-main"}));
				}
				
				# Only do on successful init
				RENDERING.check();
				OPTIONS.savedRevision.setValue(me.revisionTemp);
				OPTIONS.write();
			}
		} else { # No Update Checks
			if (!me.Error.active.getBoolValue()) {
				if (OPTIONS.openOnLaunch.getBoolValue()) {
					fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-main"}));
				}
				
				# Only do on successful init
				RENDERING.check();
				OPTIONS.savedRevision.setValue(me.revisionTemp);
				OPTIONS.write();
			}
		}
	},
	errorCheck: func() {
		if (!me.versionCheck()) {
			me.Error.active.setBoolValue(1);
			me.Error.reason.setValue("FGFS version is too old. Please update FlightGear to at least " ~ CONFIG.minFgfsString ~ ".");
			me.showError();
			print("System: FGFS version error");
		}
	},
	resetFailures: func() {
		systems.ELECTRICAL.resetFailures();
		systems.FCC.resetFailures();
		systems.FUEL.resetFailures();
		systems.GEAR.resetFailures();
		systems.HYDRAULICS.resetFailures();
		systems.PNEUMATICS.resetFailures();
	},
	showError: func() {
		libraries.systemsLoop.stop();
		fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-main"}));
		fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-updated"}));
		fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-error"}));
		# Kill menu items
		setprop("/sim/menubar/default/menu[101]/enabled", 0);
		setprop("/sim/menubar/default/menu[102]/enabled", 0);
		setprop("/sim/menubar/default/menu[103]/enabled", 0);
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
		me.spinnerProp.setValue(me.spinner);
	},
	versionCheck: func() {
		if (SYSTEM.fgfs[0] > CONFIG.minFgfs[0]) {
			return 1;
		} else if (SYSTEM.fgfs[0] == CONFIG.minFgfs[0]) {
			if (SYSTEM.fgfs[1] > CONFIG.minFgfs[1]) {
				return 1;
			} else if (SYSTEM.fgfs[1] == CONFIG.minFgfs[1]) {
				if (SYSTEM.fgfs[2] >= CONFIG.minFgfs[2]) {
					return 1;
				} else {
					return 0;
				}
			} else {
				return 0;
			}
		} else {
			return 0;
		}
	},
};

var RENDERING = {
	als: props.globals.getNode("/sim/rendering/shaders/skydome"),
	alsMode: props.globals.getNode("/sim/gui/dialogs/advanced/mode/als-mode", 1),
	landmass: props.globals.getNode("/sim/rendering/shaders/landmass"),
	landmassSet: 0,
	lowSpecMode: props.globals.getNode("/sim/gui/dialogs/advanced/mode/low-spec-mode", 1),
	model: props.globals.getNode("/sim/rendering/shaders/model"),
	modelEffects: props.globals.getNode("/sim/gui/dialogs/advanced/model-effects", 1),
	modelSet: 0,
	check: func() {
		if (OPTIONS.noRenderingWarn.getBoolValue()) {
			return;
		}
		
		me.landmassSet = me.landmass.getValue() >= 4;
		me.modelSet = me.model.getValue() >= 3;
		
		if (!me.als.getBoolValue() or !me.landmassSet or !me.modelSet) {
			fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-rendering"}));
		}
	},
	fixAll: func() {
		# Don't override higher settings
		if (me.landmass.getValue() < 4) {
			me.landmass.setValue(4);
			me.modelEffects.setValue("Medium");
		}
		if (me.model.getValue() < 3) {
			me.model.setValue(3);
			me.modelEffects.setValue("Enabled");
		}
		
		me.fixCore();
	},
	fixCore: func() {
		me.als.setBoolValue(1); # ALS on
		me.alsMode.setBoolValue(1);
		me.lowSpecMode.setBoolValue(0);
		
		print("System: Rendering Settings updated!");
		gui.popupTip("System: Rendering settings updated!");
	},
};

var OPTIONS = {
	openOnLaunch: props.globals.initNode("/systems/acconfig/options/open-on-launch", 1, "BOOL"),
	noRenderingWarn: props.globals.initNode("/systems/acconfig/options/no-rendering-warn", 0, "BOOL"),
	savedRevision: props.globals.initNode("/systems/acconfig/options/saved-revision", 0, "INT"),
	tempRevision: props.globals.initNode("/systems/acconfig/temp/saved-revision", 0, "INT"),
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

# Panel States specifically designed to work with IntegratedSystems design
var PANEL = {
	engTimer: 10,
	l1: nil,
	stop: 1,
	cancel: func() {
		me.stop = 1; # Kill timers
		
		# Kill listeners
		if (me.l1 != nil) {
			removelistener(me.l1);
			me.l1 = nil; # Important
		}
		
		me.panelBase(0, 1); # Don't disable stop
		
		pts.Services.Chocks.enable.setBoolValue(1);
		systems.IGNITION.fastStop(0);
		systems.IGNITION.fastStop(1);
		systems.IGNITION.fastStop(2);
		
		fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-psload"}));
		fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-init"}));
		
		settimer(func() { # Give things a moment to settle
			fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-init"}));
			spinningT.stop();
			SYSTEM.autoConfigRunning.setBoolValue(0);
		}, 2);
	},
	panelBase: func(t, s = 0) {
		if (s != 1) {
			me.stop = 0;
		}
		
		SYSTEM.autoConfigRunning.setBoolValue(1);
		spinningT.start();
		fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-psloaded"}));
		fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-psload"}));
		systems.doIdleThrust();
		libraries.systemsInit();
		afs.ITAF.syncHdg();
		pts.Controls.Flight.speedbrake.setValue(0);
		if (t == 1) {
			pts.Controls.Flight.flaps.setValue(0.36); # 10-25/EXT
			pts.Controls.Flight.speedbrakeArm.setBoolValue(1);
			systems.BRAKES.Controls.abs.setValue(-1); # T/O
		} else {
			pts.Controls.Flight.elevatorTrim.setValue(-0.193548); # About 3ANU
			pts.Controls.Flight.flaps.setValue(0);
			pts.Controls.Flight.speedbrakeArm.setBoolValue(0);
		}
		systems.GEAR.Controls.lever.setValue(3);
	},
	coldDark: func(reinit = 0) {
		me.panelBase(0);
		
		pts.Services.Chocks.enable.setBoolValue(1);
		systems.IGNITION.fastStop(0);
		systems.IGNITION.fastStop(1);
		systems.IGNITION.fastStop(2);
		systems.APU.stopRpm();
		
		settimer(func() { # Give things a moment to settle
			fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-psload"}));
			spinningT.stop();
			if (!reinit) {
				fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-psloaded"}));
			} else if (OPTIONS.openOnLaunch.getBoolValue()) {
				fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-main"}));
			}
			SYSTEM.autoConfigRunning.setBoolValue(0);
			me.stop = 1;
		}, 1);
	},
	beforeStart: func() {
		me.panelBase(0);
		
		pts.Services.Chocks.enable.setBoolValue(1);
		systems.ELECTRICAL.Controls.battery.setBoolValue(1);
		systems.ELECTRICAL.Controls.emerPwr.setValue(1);
		pts.Controls.Lighting.emerLt.setValue(0.5);
		systems.APU.fastStart();
		systems.IRS.Controls.knob[0].setBoolValue(1);
		systems.IRS.Controls.knob[1].setBoolValue(1);
		systems.IRS.Controls.knob[2].setBoolValue(1);
		systems.IRS.Controls.mcduBtn.setBoolValue(1);
		pts.Controls.Lighting.beacon.setBoolValue(1);
		pts.Controls.Lighting.navLights.setBoolValue(1);
		pts.Controls.Switches.seatbeltSign.setValue(1);
		
		systems.IGNITION.fastStop(0);
		systems.IGNITION.fastStop(1);
		systems.IGNITION.fastStop(2);
		
		me.l1 = setlistener("/engines/engine[3]/state", func() {
			if (systems.APU.state.getValue() == 3) {
				removelistener(me.l1);
				me.l1 = nil; # Important
				systems.ELECTRICAL.Controls.apuPwr.setBoolValue(1);
				systems.PNEUMATICS.Controls.bleedApu.setBoolValue(1);
				fms.EditFlightData.setAcconfigData();
				
				fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-psload"}));
				spinningT.stop();
				fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-psloaded"}));
				SYSTEM.autoConfigRunning.setBoolValue(0);
				me.stop = 1;
			}
		});
	},
	afterStart: func(t) {
		me.panelBase(t);
		
		pts.Services.Chocks.enable.setBoolValue(0);
		systems.ELECTRICAL.Controls.battery.setBoolValue(1);
		systems.ELECTRICAL.Controls.emerPwr.setValue(1);
		pts.Controls.Lighting.emerLt.setValue(0.5);
		systems.ELECTRICAL.Controls.groundCart.setBoolValue(1); # autoConfigRunning cancels disable check in libraries.nas
		systems.ELECTRICAL.Controls.extPwr.setBoolValue(1);
		systems.ELECTRICAL.Controls.extGPwr.setBoolValue(1);
		systems.IRS.Controls.knob[0].setBoolValue(1);
		systems.IRS.Controls.knob[1].setBoolValue(1);
		systems.IRS.Controls.knob[2].setBoolValue(1);
		systems.IRS.Controls.mcduBtn.setBoolValue(1);
		pts.Controls.Lighting.beacon.setBoolValue(1);
		pts.Controls.Lighting.navLights.setBoolValue(1);
		pts.Controls.Switches.seatbeltSign.setValue(1);
		systems.IGNITION.Controls.ignA.setBoolValue(1);
		systems.APU.stopRpm();
		
		if (systems.ENGINES.state[0].getValue() != 3 or systems.ENGINES.state[1].getValue() != 3 or systems.ENGINES.state[2].getValue() != 3) {
			engTimer = 3;
			settimer(func() {
				if (!me.stop) {
					systems.IGNITION.fastStart(0);
					systems.IGNITION.fastStart(1);
					systems.IGNITION.fastStart(2);
				}
			}, 0.5);
		} else {
			engTimer = 1;
		}
		
		me.l1 = setlistener("/engines/engine[1]/state", func() {
			if (systems.ENGINES.state[1].getValue() == 3) {
				removelistener(me.l1);
				me.l1 = nil; # Important
				systems.ELECTRICAL.Controls.groundCart.setBoolValue(0);
				systems.ELECTRICAL.Controls.extPwr.setBoolValue(0);
				systems.ELECTRICAL.Controls.extGPwr.setBoolValue(0);
				instruments.XPDR.setMode(3); # TA/RA
				fms.EditFlightData.setAcconfigData();
				
				if (t == 1) {
					settimer(func() {
						pts.Controls.Flight.elevatorTrim.setValue(fms.Internal.takeoffStabDeg.getValue() / -15.5);
					}, 0.5);
					pts.Controls.Lighting.strobeLights.setBoolValue(1);
					pts.Controls.Lighting.landingLightL.setValue(1);
					pts.Controls.Lighting.landingLightN.setValue(1);
					pts.Controls.Lighting.landingLightR.setValue(1);
				} else {
					pts.Controls.Lighting.landingLightL.setValue(0.5);
					pts.Controls.Lighting.landingLightN.setValue(0.5);
					pts.Controls.Lighting.landingLightR.setValue(0.5);
				}
				
				settimer(func() { # Give things a moment to settle
					if (!me.stop) {
						fgcommand("dialog-close", props.Node.new({"dialog-name": "acconfig-psload"}));
						spinningT.stop();
						fgcommand("dialog-show", props.Node.new({"dialog-name": "acconfig-psloaded"}));
						SYSTEM.autoConfigRunning.setBoolValue(0);
						me.stop = 1;
					}
				}, engTimer);
			}
		});
	},
};

var spinningT = maketimer(0.05, SYSTEM, SYSTEM.spinning);
SYSTEM.simInit();

setlistener("/sim/signals/reinit", func(s) {
	if (!s.getBoolValue() and libraries.initDone) {
		PANEL.coldDark(1);
	}
});
