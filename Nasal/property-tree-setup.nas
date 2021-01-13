# McDonnell Douglas MD-11 Property Tree Setup
# Copyright (c) 2021 Josh Davidson (Octal450)
# Nodes organized like property tree, except when lots of identical (example: Gear wow), where vectors are used to make it easier
# Anything that says Temp is set by another file to avoid multiple getValue calls
# Usage Example: pts.Class.SubClass.node.getValue()

var Consumables = {
	Fuel: {
		totalFuelLbs: props.globals.getNode("/consumables/fuel/total-fuel-lbs"),
	},
};

var Controls = {
	Flight: {
		aileronDrivesTiller: props.globals.getNode("/controls/flight/aileron-drives-tiller"),
		autoCoordination: props.globals.getNode("/controls/flight/auto-coordination", 1),
		dialAFlap: props.globals.getNode("/controls/flight/dial-a-flap"),
		elevatorTrim: props.globals.getNode("/controls/flight/elevator-trim"),
		flaps: props.globals.getNode("/controls/flight/flaps"),
		flapsCmd: props.globals.getNode("/controls/flight/flaps-cmd"),
		flapsTemp: 0,
		flapsInput: props.globals.getNode("/controls/flight/flaps-input"),
		speedbrake: props.globals.getNode("/controls/flight/speedbrake"),
		speedbrakeArm: props.globals.getNode("/controls/flight/speedbrake-arm"),
		speedbrakeTemp: 0,
		slatsCmd: props.globals.getNode("/controls/flight/slats-cmd"),
		wingflexEnable: props.globals.getNode("/controls/flight/wingflex-enable"),
	},
	Gear: {
		brakeParking: props.globals.getNode("/controls/gear/brake-parking"),
		brakeLeft: props.globals.getNode("/controls/gear/brake-left"),
		brakeRight: props.globals.getNode("/controls/gear/brake-right"),
		lever: props.globals.getNode("/controls/gear/lever"),
		leverCockpit: props.globals.getNode("/controls/gear/lever-cockpit"),
	},
	Lighting: {
		beacon: props.globals.getNode("/controls/lighting/beacon"),
		landingLightL: props.globals.getNode("/controls/lighting/landing-light-l"),
		landingLightN: props.globals.getNode("/controls/lighting/landing-light-n"),
		landingLightR: props.globals.getNode("/controls/lighting/landing-light-r"),
		logoLights: props.globals.getNode("/controls/lighting/logo-lights"),
		navLights: props.globals.getNode("/controls/lighting/nav-lights"),
		strobe: props.globals.getNode("/controls/lighting/strobe"),
	},
	Switches: {
		adgHandle: props.globals.getNode("/controls/switches/adg-handle"),
		annunTest: props.globals.getNode("/controls/switches/annun-test"),
		apYokeButton1: props.globals.getNode("/controls/switches/ap-yoke-button1"),
		apYokeButton2: props.globals.getNode("/controls/switches/ap-yoke-button2"),
		minimums: props.globals.getNode("/controls/switches/minimums"),
		noSmokingSign: props.globals.getNode("/controls/switches/no-smoking-sign"),
		seatbeltSign: props.globals.getNode("/controls/switches/seatbelt-sign"),
	},
};

var Engines = {
	Engine: {
		egtActual: [props.globals.getNode("/engines/engine[0]/egt-actual"), props.globals.getNode("/engines/engine[1]/egt-actual"), props.globals.getNode("/engines/engine[2]/egt-actual")],
		eprActual: [props.globals.getNode("/engines/engine[0]/epr-actual"), props.globals.getNode("/engines/engine[1]/epr-actual"), props.globals.getNode("/engines/engine[2]/epr-actual")],
		ffActual: [props.globals.getNode("/engines/engine[0]/ff-actual"), props.globals.getNode("/engines/engine[1]/ff-actual"), props.globals.getNode("/engines/engine[2]/ff-actual")],
		n1Actual: [props.globals.getNode("/engines/engine[0]/n1-actual"), props.globals.getNode("/engines/engine[1]/n1-actual"), props.globals.getNode("/engines/engine[2]/n1-actual")],
		n2Actual: [props.globals.getNode("/engines/engine[0]/n2-actual"), props.globals.getNode("/engines/engine[1]/n2-actual"), props.globals.getNode("/engines/engine[2]/n2-actual")],
		nacelleTemp: [props.globals.getNode("/engines/engine[0]/nacelle-temp"), props.globals.getNode("/engines/engine[1]/nacelle-temp"), props.globals.getNode("/engines/engine[2]/nacelle-temp")],
		oilPsi: [props.globals.getNode("/engines/engine[0]/oil-psi"), props.globals.getNode("/engines/engine[1]/oil-psi"), props.globals.getNode("/engines/engine[2]/oil-psi")],
		oilQty: [props.globals.getNode("/engines/engine[0]/oil-qty"), props.globals.getNode("/engines/engine[1]/oil-qty"), props.globals.getNode("/engines/engine[2]/oil-qty")],
		oilQtyInput: [props.globals.getNode("/engines/engine[0]/oil-qty-input"), props.globals.getNode("/engines/engine[1]/oil-qty-input"), props.globals.getNode("/engines/engine[2]/oil-qty-input")],
		oilTemp: [props.globals.getNode("/engines/engine[0]/oil-temp"), props.globals.getNode("/engines/engine[1]/oil-temp"), props.globals.getNode("/engines/engine[2]/oil-temp")],
		state: [props.globals.getNode("/engines/engine[0]/state"), props.globals.getNode("/engines/engine[1]/state"), props.globals.getNode("/engines/engine[2]/state")],
	},
};

var Fdm = {
	JSBsim: {
		Aero: {
			alphaDegDamped: props.globals.getNode("/fdm/jsbsim/aero/alpha-deg-damped"),
		},
		Fadec: {
			throttleLever: [props.globals.getNode("/fdm/jsbsim/fadec/throttle-lever[0]"), props.globals.getNode("/fdm/jsbsim/fadec/throttle-lever[1]"), props.globals.getNode("/fdm/jsbsim/fadec/throttle-lever[2]")],
		},
		Fcc: {
			Flap: {
				maxDeg: props.globals.getNode("/fdm/jsbsim/fcc/flap/max-deg"),
			},
			Speeds: {
				flapGearMax: props.globals.getNode("/fdm/jsbsim/fcc/speeds/flap-gear-max"),
				vmin: props.globals.getNode("/fdm/jsbsim/fcc/speeds/vmin"),
				vmoMmo: props.globals.getNode("/fdm/jsbsim/fcc/speeds/vmo-mmo"),
				vss: props.globals.getNode("/fdm/jsbsim/fcc/speeds/vss"),
			},
		},
		Fcs: {
			flapPosDeg: props.globals.getNode("/fdm/jsbsim/fcs/flap-pos-deg"),
			slatPosDeg: props.globals.getNode("/fdm/jsbsim/fcs/slat-pos-deg"),
		},
		Hydraulics: {
			Stabilizer: {
				finalDeg: props.globals.getNode("/fdm/jsbsim/hydraulics/stabilizer/final-deg"),
			},
		},
		Inertia: {
			weightLbs: props.globals.getNode("/fdm/jsbsim/inertia/weight-lbs"),
		},
		Position: {
			wow: props.globals.getNode("/fdm/jsbsim/position/wow"),
			wowTemp: 0,
		},
		Propulsion: {
			setRunning: props.globals.getNode("/fdm/jsbsim/propulsion/set-running"),
			tatC: props.globals.getNode("/fdm/jsbsim/propulsion/tat-c"),
		},
	},
};

var Gear = {
	rollspeedMs: [props.globals.getNode("/gear/gear[0]/rollspeed-ms"), props.globals.getNode("/gear/gear[1]/rollspeed-ms"), props.globals.getNode("/gear/gear[2]/rollspeed-ms"), props.globals.getNode("/gear/gear[3]/rollspeed-ms")],
	wow: [props.globals.getNode("/gear/gear[0]/wow"), props.globals.getNode("/gear/gear[1]/wow"), props.globals.getNode("/gear/gear[2]/wow"), props.globals.getNode("/gear/gear[3]/wow")],
};

var Instrumentation = {
	AirspeedIndicator: {
		indicatedMach: props.globals.getNode("/instrumentation/airspeed-indicator/indicated-mach"),
		indicatedSpeedKt: props.globals.getNode("/instrumentation/airspeed-indicator/indicated-speed-kt"),
	},
	Altimeter: {
		indicatedAltitudeFt: props.globals.getNode("/instrumentation/altimeter/indicated-altitude-ft"),
		inhg: props.globals.getNode("/instrumentation/altimeter/inhg"),
		oldQnh: props.globals.getNode("/instrumentation/altimeter/oldqnh"),
		settingHpa: props.globals.getNode("/instrumentation/altimeter/setting-hpa"),
		settingInhg: props.globals.getNode("/instrumentation/altimeter/setting-inhg"),
		std: props.globals.getNode("/instrumentation/altimeter/std"),
	},
	Ead: {
		egt: [props.globals.getNode("/instrumentation/ead/egt[0]"), props.globals.getNode("/instrumentation/ead/egt[1]"), props.globals.getNode("/instrumentation/ead/egt[2]")],
		epr: [props.globals.getNode("/instrumentation/ead/epr[0]"), props.globals.getNode("/instrumentation/ead/epr[1]"), props.globals.getNode("/instrumentation/ead/epr[2]")],
		eprLimit: props.globals.getNode("/instrumentation/ead/epr-limit"),
		eprThr: [props.globals.getNode("/instrumentation/ead/epr-thr[0]"), props.globals.getNode("/instrumentation/ead/epr-thr[1]"), props.globals.getNode("/instrumentation/ead/epr-thr[2]")],
		n1: [props.globals.getNode("/instrumentation/ead/n1[0]"), props.globals.getNode("/instrumentation/ead/n1[1]"), props.globals.getNode("/instrumentation/ead/n1[2]")],
		n1Limit: props.globals.getNode("/instrumentation/ead/n1-limit"),
		n1Thr: [props.globals.getNode("/instrumentation/ead/n1-thr[0]"), props.globals.getNode("/instrumentation/ead/n1-thr[1]"), props.globals.getNode("/instrumentation/ead/n1-thr[2]")],
		n2: [props.globals.getNode("/instrumentation/ead/n2[0]"), props.globals.getNode("/instrumentation/ead/n2[1]"), props.globals.getNode("/instrumentation/ead/n2[2]")],
	},
	Efis: {
		hdgTrkSelected: [props.globals.initNode("/instrumentation/efis[0]/hdg-trk-selected", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/hdg-trk-selected", 0, "BOOL")],
		Inputs: {
			arpt: [props.globals.initNode("/instrumentation/efis[0]/inputs/arpt", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/arpt", 0, "BOOL")],
			data: [props.globals.initNode("/instrumentation/efis[0]/inputs/data", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/data", 0, "BOOL")],
			lhVorAdf: [props.globals.initNode("/instrumentation/efis[0]/inputs/lh-vor-adf", 0, "INT"), props.globals.initNode("/instrumentation/efis[1]/inputs/lh-vor-adf", 0, "INT")],
			ndCentered: [props.globals.initNode("/instrumentation/efis[0]/inputs/nd-centered", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/nd-centered", 0, "BOOL")],
			rangeNm: [props.globals.initNode("/instrumentation/efis[0]/inputs/range-nm", 10, "INT"), props.globals.initNode("/instrumentation/efis[1]/inputs/range-nm", 10, "INT")],
			rhVorAdf: [props.globals.initNode("/instrumentation/efis[0]/inputs/rh-vor-adf", 0, "INT"), props.globals.initNode("/instrumentation/efis[1]/inputs/rh-vor-adf", 0, "INT")],
			sta: [props.globals.initNode("/instrumentation/efis[0]/inputs/sta", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/sta", 0, "BOOL")],
			tfc: [props.globals.initNode("/instrumentation/efis[0]/inputs/tfc", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/tfc", 0, "BOOL")],
			wpt: [props.globals.initNode("/instrumentation/efis[0]/inputs/wpt", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/inputs/wpt", 0, "BOOL")],
		},
		Mfd: {
			displayMode: [props.globals.initNode("/instrumentation/efis[0]/mfd/display-mode", "MAP", "STRING"), props.globals.initNode("/instrumentation/efis[1]/mfd/display-mode", "MAP", "STRING")],
		},
	},
	Nav: {
		headingNeedleDeflectionNorm: [props.globals.getNode("/instrumentation/nav[0]/heading-needle-deflection-norm"), props.globals.getNode("/instrumentation/nav[1]/heading-needle-deflection-norm"), props.globals.getNode("/instrumentation/nav[2]/heading-needle-deflection-norm")],
		gsInRange: [props.globals.getNode("/instrumentation/nav[0]/gs-in-range"), props.globals.getNode("/instrumentation/nav[1]/gs-in-range"), props.globals.getNode("/instrumentation/nav[2]/gs-in-range")],
		gsNeedleDeflectionNorm: [props.globals.getNode("/instrumentation/nav[0]/gs-needle-deflection-norm"), props.globals.getNode("/instrumentation/nav[1]/gs-needle-deflection-norm"), props.globals.getNode("/instrumentation/nav[2]/gs-needle-deflection-norm")],
		hasGs: [props.globals.getNode("/instrumentation/nav[0]/has-gs"), props.globals.getNode("/instrumentation/nav[1]/has-gs"), props.globals.getNode("/instrumentation/nav[2]/has-gs")],
		inRange: [props.globals.getNode("/instrumentation/nav[0]/in-range"), props.globals.getNode("/instrumentation/nav[1]/in-range"), props.globals.getNode("/instrumentation/nav[2]/in-range")],
		navLoc: [props.globals.getNode("/instrumentation/nav[0]/nav-loc"), props.globals.getNode("/instrumentation/nav[1]/nav-loc"), props.globals.getNode("/instrumentation/nav[2]/nav-loc")],
		signalQualityNorm: [props.globals.getNode("/instrumentation/nav[0]/signal-quality-norm"), props.globals.getNode("/instrumentation/nav[1]/signal-quality-norm"), props.globals.getNode("/instrumentation/nav[2]/signal-quality-norm")],
	},
	Pfd: {
		altPreSel: props.globals.initNode("/instrumentation/pfd/alt-pre-sel", 0, "DOUBLE"),
		altSel: props.globals.initNode("/instrumentation/pfd/alt-sel", 0, "DOUBLE"),
		bankLimit: props.globals.initNode("/instrumentation/pfd/bank-limit", 0, "DOUBLE"),
		hdgPreSel: props.globals.initNode("/instrumentation/pfd/heading-pre-sel", 0, "DOUBLE"),
		hdgSel: props.globals.initNode("/instrumentation/pfd/heading-sel", 0, "DOUBLE"),
		hdgScale: props.globals.initNode("/instrumentation/pfd/heading-scale", 0, "DOUBLE"),
		iasPreSel: props.globals.initNode("/instrumentation/pfd/ias-pre-sel", 0, "DOUBLE"),
		iasSel: props.globals.initNode("/instrumentation/pfd/ias-sel", 0, "DOUBLE"),
		slipSkid: props.globals.initNode("/instrumentation/pfd/slip-skid", 0, "DOUBLE"),
		speedTrend: props.globals.initNode("/instrumentation/pfd/speed-trend", 0, "DOUBLE"),
		trackBug: props.globals.initNode("/instrumentation/pfd/track-bug", 0, "DOUBLE"),
		vsNeedleDn: props.globals.initNode("/instrumentation/pfd/vs-needle-dn", 0, "DOUBLE"),
		vsNeedleUp: props.globals.initNode("/instrumentation/pfd/vs-needle-up", 0, "DOUBLE"),
		vsDigit: props.globals.initNode("/instrumentation/pfd/vs-digit", 0, "DOUBLE"),
	},
	Sd: {
		Eng: {
			oilPsi: [props.globals.getNode("/instrumentation/sd/eng/oil-psi[0]"), props.globals.getNode("/instrumentation/sd/eng/oil-psi[1]"), props.globals.getNode("/instrumentation/sd/eng/oil-psi[2]")],
			oilQty: [props.globals.getNode("/instrumentation/sd/eng/oil-qty[0]"), props.globals.getNode("/instrumentation/sd/eng/oil-qty[1]"), props.globals.getNode("/instrumentation/sd/eng/oil-qty[2]")],
			oilQtyCline: [props.globals.getNode("/instrumentation/sd/eng/oil-qty-cline[0]"), props.globals.getNode("/instrumentation/sd/eng/oil-qty-cline[1]"), props.globals.getNode("/instrumentation/sd/eng/oil-qty-cline[2]")],
		},
		selectedSynoptic: props.globals.getNode("/instrumentation/sd/selected-synoptic"),
	},
};

var Options = {
	eng: props.globals.getNode("/options/eng"),
};

var Orientation = {
	headingDeg: props.globals.getNode("/orientation/heading-deg"),
	headingMagneticDeg: props.globals.getNode("/orientation/heading-magnetic-deg"),
	pitchDeg: props.globals.getNode("/orientation/pitch-deg"),
	rollDeg: props.globals.getNode("/orientation/roll-deg"),
};

var Position = {
	gearAglFt: props.globals.getNode("/position/gear-agl-ft"),
};

var Sim = {
	CurrentView: {
		fieldOfView: props.globals.getNode("/sim/current-view/field-of-view", 1),
		headingOffsetDeg: props.globals.getNode("/sim/current-view/heading-offset-deg", 1),
		name: props.globals.getNode("/sim/current-view/name", 1),
		pitchOffsetDeg: props.globals.getNode("/sim/current-view/pitch-offset-deg", 1),
		rollOffsetDeg: props.globals.getNode("/sim/current-view/roll-offset-deg", 1),
		type: props.globals.getNode("/sim/current-view/type", 1),
		viewNumberRaw: props.globals.getNode("/sim/current-view/view-number-raw", 1),
		zOffsetDefault: props.globals.getNode("/sim/current-view/z-offset-default", 1),
		xOffsetM: props.globals.getNode("/sim/current-view/x-offset-m", 1),
		yOffsetM: props.globals.getNode("/sim/current-view/y-offset-m", 1),
		zOffsetM: props.globals.getNode("/sim/current-view/z-offset-m", 1),
		zOffsetMaxM: props.globals.getNode("/sim/current-view/z-offset-max-m", 1),
		zOffsetMinM: props.globals.getNode("/sim/current-view/z-offset-min-m", 1),
	},
	Rendering: {
		Headshake: {
			enabled: props.globals.getNode("/sim/rendering/headshake/enabled"),
		},
	},
	Replay: {
		replayState: props.globals.getNode("/sim/replay/replay-state"),
		wasActive: props.globals.initNode("/sim/replay/was-active", 0, "BOOL"),
	},
	Sound: {
		btn1: props.globals.initNode("/sim/sound/btn1", 0, "BOOL"),
		btn3: props.globals.initNode("/sim/sound/btn3", 0, "BOOL"),
		flapsClick: props.globals.initNode("/sim/sound/flaps-click", 0, "BOOL"),
		knb1: props.globals.initNode("/sim/sound/knb1", 0, "BOOL"),
		noSmokingSign: props.globals.initNode("/sim/sound/no-smoking-sign", 0, "BOOL"),
		noSmokingSignInhibit: props.globals.initNode("/sim/sound/no-smoking-sign-inhibit", 0, "BOOL"),
		ohBtn: props.globals.initNode("/sim/sound/oh-btn", 0, "BOOL"),
		seatbeltSign: props.globals.initNode("/sim/sound/seatbelt-sign", 0, "BOOL"),
		switch1: props.globals.initNode("/sim/sound/switch1", 0, "BOOL"),
	},
	Time: {
		deltaRealtimeSec: props.globals.getNode("/sim/time/delta-realtime-sec"),
		elapsedSec: props.globals.getNode("/sim/time/elapsed-sec"),
	},
	View: {
		Config: {
			defaultFieldOfViewDeg: props.globals.getNode("/sim/view/config/default-field-of-view-deg", 1),
		},
	},
};

var Systems = {
	Acconfig: {
		Options: {
			Du: {
				eadFps: props.globals.getNode("/systems/acconfig/options/du/ead-fps"),
				ndFps: props.globals.getNode("/systems/acconfig/options/du/nd-fps"),
				pfdFps: props.globals.getNode("/systems/acconfig/options/du/pfd-fps"),
				sdFps: props.globals.getNode("/systems/acconfig/options/du/sd-fps"),
			},
			throttleOverride: props.globals.getNode("/systems/acconfig/options/throttle-override"),
		}
	},
	Shake: {
		effect: props.globals.getNode("/systems/shake/effect"),
		shaking: props.globals.initNode("/systems/shake/shaking", 0, "DOUBLE"),
	},
};

var Velocities = {
	groundspeedKt: props.globals.getNode("/velocities/groundspeed-kt"),
};

setprop("/systems/acconfig/property-tree-setup-loaded", 1);
