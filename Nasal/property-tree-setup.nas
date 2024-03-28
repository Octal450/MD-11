# McDonnell Douglas MD-11 Property Tree Setup
# Copyright (c) 2024 Josh Davidson (Octal450)
# Nodes organized like property tree, except when lots of identical (example: Gear wow), where vectors are used to make it easier
# Anything that says Temp is set by another file to avoid multiple getValue calls
# Usage Example: pts.Class.SubClass.node.getValue()

var Consumables = {
	Fuel: {
		totalFuelLbs: props.globals.getNode("/consumables/fuel/total-fuel-lbs"),
	},
};

var Controls = {
	Cockpit: {
		apDisc: [props.globals.getNode("/controls/cockpit/ap-disc-1"), props.globals.getNode("/controls/cockpit/ap-disc-2")],
		shadeLeftCmd: props.globals.getNode("/controls/cockpit/shade-left-cmd"),
		shadeRightCmd: props.globals.getNode("/controls/cockpit/shade-right-cmd"),
	},
	Flight: {
		aileronDrivesTiller: props.globals.getNode("/controls/flight/aileron-drives-tiller"),
		autoCoordination: props.globals.getNode("/controls/flight/auto-coordination", 1),
		autoSlatTimer: props.globals.getNode("/controls/flight/auto-slat-timer"),
		dialAFlap: props.globals.getNode("/controls/flight/dial-a-flap"),
		elevatorTrim: props.globals.getNode("/controls/flight/elevator-trim"),
		flaps: props.globals.getNode("/controls/flight/flaps"),
		flapsCmd: props.globals.getNode("/controls/flight/flaps-cmd"),
		flapsTemp: 0,
		flapsInput: props.globals.getNode("/controls/flight/flaps-input"),
		slatStow: props.globals.getNode("/controls/flight/slat-stow"),
		speedbrake: props.globals.getNode("/controls/flight/speedbrake"),
		speedbrakeArm: props.globals.getNode("/controls/flight/speedbrake-arm"),
		speedbrakeTemp: 0,
		slatsCmd: props.globals.getNode("/controls/flight/slats-cmd"),
		wingflexEnable: props.globals.getNode("/controls/flight/wingflex-enable"),
	},
	Lighting: {
		beacon: props.globals.getNode("/controls/lighting/beacon"),
		emerLt: props.globals.getNode("/controls/lighting/emer-lt"),
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
		gpwsOvrd: props.globals.getNode("/controls/switches/gpws-ovrd"),
		gpwsOvrdCover: props.globals.getNode("/controls/switches/gpws-ovrd-cover"),
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
			Lsas: {
				autotrimInhibit: props.globals.getNode("/fdm/jsbsim/fcc/lsas/autotrim-inhibit"),
			},
			powerAvail: props.globals.getNode("/fdm/jsbsim/fcc/power-avail"),
			powerAvailTemp: 0,
			pitchTrimSpeed: props.globals.getNode("/fdm/jsbsim/fcc/pitch-trim-speed"),
			stallAlphaDeg: props.globals.getNode("/fdm/jsbsim/fcc/stall-alpha-deg"),
			stallWarnAlphaDeg: props.globals.getNode("/fdm/jsbsim/fcc/stall-warn-alpha-deg"),
		},
		Fcs: {
			flapPosDeg: props.globals.getNode("/fdm/jsbsim/fcs/flap-pos-deg"),
			slatPosDeg: props.globals.getNode("/fdm/jsbsim/fcs/slat-pos-deg"),
			spoilerL: props.globals.getNode("/fdm/jsbsim/fcs/spoiler-left-deg"),
			spoilerR: props.globals.getNode("/fdm/jsbsim/fcs/spoiler-right-deg"),
		},
		Gear: {
			gearAllNorm: props.globals.getNode("/fdm/jsbsim/gear/gear-all-norm"),
		},
		Hydraulics: {
			DeflectedAileron: {
				active: props.globals.getNode("/fdm/jsbsim/hydraulics/deflected-aileron/active"),
			},
			RudderLower: {
				finalDeg: props.globals.getNode("/fdm/jsbsim/hydraulics/rudder-lower/final-deg"),
			},
			RudderUpper: {
				finalDeg: props.globals.getNode("/fdm/jsbsim/hydraulics/rudder-upper/final-deg"),
			},
			Stabilizer: {
				finalDeg: props.globals.getNode("/fdm/jsbsim/hydraulics/stabilizer/final-deg"),
			},
		},
		Inertia: {
			cgPercentMac: props.globals.getNode("/fdm/jsbsim/inertia/cg-percent-mac"),
			weightLbs: props.globals.getNode("/fdm/jsbsim/inertia/weight-lbs"),
			zfwLbs: props.globals.getNode("/fdm/jsbsim/inertia/zfw-lbs"),
			zfwcgPercentMac: props.globals.getNode("/fdm/jsbsim/inertia/zfwcg-percent-mac"),
		},
		Libraries: {
			anyEngineOut: props.globals.getNode("/fdm/jsbsim/libraries/any-engine-out"),
			blinkMed: props.globals.getNode("/fdm/jsbsim/libraries/blink-med"),
			blinkMed2: props.globals.getNode("/fdm/jsbsim/libraries/blink-med-2"),
			multiEngineOut: props.globals.getNode("/fdm/jsbsim/libraries/multi-engine-out"),
		},
		Position: {
			wow: props.globals.getNode("/fdm/jsbsim/position/wow"),
			wowTemp: 0,
		},
		Propulsion: {
			Engine: {
				n1: [props.globals.getNode("/fdm/jsbsim/propulsion/engine[0]/n1"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[1]/n1"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[2]/n1"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[3]/n1")],
				n2: [props.globals.getNode("/fdm/jsbsim/propulsion/engine[0]/n2"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[1]/n2"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[2]/n2"), props.globals.getNode("/fdm/jsbsim/propulsion/engine[3]/n2")],
			},
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
	Adf: {
		Frequencies: {
			selectedKhz: [props.globals.getNode("/instrumentation/adf[0]/frequencies/selected-khz"), props.globals.getNode("/instrumentation/adf[1]/frequencies/selected-khz")],
		},
	},
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
	Comm: {
		Frequencies: {
			selectedMhz: [props.globals.getNode("/instrumentation/comm[0]/frequencies/selected-mhz"), props.globals.getNode("/instrumentation/comm[1]/frequencies/selected-mhz"), props.globals.getNode("/instrumentation/comm[2]/frequencies/selected-mhz")],
			selectedMhzFmt: [props.globals.getNode("/instrumentation/comm[0]/frequencies/selected-mhz-fmt"), props.globals.getNode("/instrumentation/comm[1]/frequencies/selected-mhz-fmt"), props.globals.getNode("/instrumentation/comm[2]/frequencies/selected-mhz-fmt")],
			standbyMhz: [props.globals.getNode("/instrumentation/comm[0]/frequencies/standby-mhz"), props.globals.getNode("/instrumentation/comm[1]/frequencies/standby-mhz"), props.globals.getNode("/instrumentation/comm[2]/frequencies/standby-mhz")],
			standbyMhzFmt: [props.globals.getNode("/instrumentation/comm[0]/frequencies/standby-mhz-fmt"), props.globals.getNode("/instrumentation/comm[1]/frequencies/standby-mhz-fmt"), props.globals.getNode("/instrumentation/comm[2]/frequencies/standby-mhz-fmt")],
		},
	},
	Dme: {
		indicatedDistanceNm: [props.globals.getNode("/instrumentation/dme[0]/indicated-distance-nm"), props.globals.getNode("/instrumentation/dme[1]/indicated-distance-nm"), props.globals.getNode("/instrumentation/dme[2]/indicated-distance-nm")],
		inRange: [props.globals.getNode("/instrumentation/dme[0]/in-range"), props.globals.getNode("/instrumentation/dme[1]/in-range"), props.globals.getNode("/instrumentation/dme[2]/in-range")],
	},
	Du: {
		duDimmer: [props.globals.getNode("/instrumentation/du/du1-dimmer"), props.globals.getNode("/instrumentation/du/du2-dimmer"), props.globals.getNode("/instrumentation/du/du3-dimmer"), props.globals.getNode("/instrumentation/du/du4-dimmer"), props.globals.getNode("/instrumentation/du/du5-dimmer"), props.globals.getNode("/instrumentation/du/du6-dimmer")],
		irsCapt: props.globals.getNode("/instrumentation/du/irs-capt"),
		irsFo: props.globals.getNode("/instrumentation/du/irs-fo"),
		mcduDimmer: [props.globals.getNode("/instrumentation/du/mcdu1-dimmer"), props.globals.getNode("/instrumentation/du/mcdu2-dimmer"), props.globals.getNode("/instrumentation/du/mcdu3-dimmer")],
	},
	Ead: {
		configWarn: props.globals.getNode("/instrumentation/ead/config-warn"),
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
			trueNorth: [props.globals.initNode("/instrumentation/efis[0]/mfd/true-north", 0, "BOOL"), props.globals.initNode("/instrumentation/efis[1]/mfd/true-north", 0, "BOOL")],
		},
	},
	MarkerBeacon: {
		inner: props.globals.getNode("/instrumentation/marker-beacon/inner"),
		middle: props.globals.getNode("/instrumentation/marker-beacon/middle"),
		outer: props.globals.getNode("/instrumentation/marker-beacon/outer"),
	},
	MkViii: {
		Inputs: {
			Discretes: {
				momentaryFlapOverride: props.globals.getNode("/instrumentation/mk-viii/inputs/discretes/momentary-flap-override"),
				selfTest: props.globals.getNode("/instrumentation/mk-viii/inputs/discretes/self-test"),
			},
		},
	},
	Nav: {
		Frequencies: {
			selectedMhz: [props.globals.getNode("/instrumentation/nav[0]/frequencies/selected-mhz"), props.globals.getNode("/instrumentation/nav[1]/frequencies/selected-mhz"), props.globals.getNode("/instrumentation/nav[2]/frequencies/selected-mhz")],
		},
		headingNeedleDeflectionNorm: [props.globals.getNode("/instrumentation/nav[0]/heading-needle-deflection-norm"), props.globals.getNode("/instrumentation/nav[1]/heading-needle-deflection-norm"), props.globals.getNode("/instrumentation/nav[2]/heading-needle-deflection-norm")],
		gsInRange: [props.globals.getNode("/instrumentation/nav[0]/gs-in-range"), props.globals.getNode("/instrumentation/nav[1]/gs-in-range"), props.globals.getNode("/instrumentation/nav[2]/gs-in-range")],
		gsNeedleDeflectionNorm: [props.globals.getNode("/instrumentation/nav[0]/gs-needle-deflection-norm"), props.globals.getNode("/instrumentation/nav[1]/gs-needle-deflection-norm"), props.globals.getNode("/instrumentation/nav[2]/gs-needle-deflection-norm")],
		hasGs: [props.globals.getNode("/instrumentation/nav[0]/has-gs"), props.globals.getNode("/instrumentation/nav[1]/has-gs"), props.globals.getNode("/instrumentation/nav[2]/has-gs")],
		inRange: [props.globals.getNode("/instrumentation/nav[0]/in-range"), props.globals.getNode("/instrumentation/nav[1]/in-range"), props.globals.getNode("/instrumentation/nav[2]/in-range")],
		navId: [props.globals.getNode("/instrumentation/nav[0]/nav-id"), props.globals.getNode("/instrumentation/nav[1]/nav-id"), props.globals.getNode("/instrumentation/nav[2]/nav-id")],
		navLoc: [props.globals.getNode("/instrumentation/nav[0]/nav-loc"), props.globals.getNode("/instrumentation/nav[1]/nav-loc"), props.globals.getNode("/instrumentation/nav[2]/nav-loc")],
		Radials: {
			selectedDeg: [props.globals.getNode("/instrumentation/nav[0]/radials/selected-deg"), props.globals.getNode("/instrumentation/nav[1]/radials/selected-deg"), props.globals.getNode("/instrumentation/nav[2]/radials/selected-deg")],
		},
		signalQualityNorm: [props.globals.getNode("/instrumentation/nav[0]/signal-quality-norm"), props.globals.getNode("/instrumentation/nav[1]/signal-quality-norm"), props.globals.getNode("/instrumentation/nav[2]/signal-quality-norm")],
	},
	Pfd: {
		altPreSel: props.globals.initNode("/instrumentation/pfd/alt-pre-sel", 0, "DOUBLE"),
		altSel: props.globals.initNode("/instrumentation/pfd/alt-sel", 0, "DOUBLE"),
		bankLimit: props.globals.initNode("/instrumentation/pfd/bank-limit", 0, "DOUBLE"),
		hdgPreSel: props.globals.initNode("/instrumentation/pfd/heading-pre-sel", 0, "DOUBLE"),
		hdgSel: props.globals.initNode("/instrumentation/pfd/heading-sel", 0, "DOUBLE"),
		hdgDeg: [props.globals.initNode("/instrumentation/pfd/heading-deg[0]", 0, "DOUBLE"), props.globals.initNode("/instrumentation/pfd/heading-deg[1]", 0, "DOUBLE")],
		slipSkid: props.globals.initNode("/instrumentation/pfd/slip-skid", 0, "DOUBLE"),
		spdPreSel: props.globals.initNode("/instrumentation/pfd/spd-pre-sel", 0, "DOUBLE"),
		spdSel: props.globals.initNode("/instrumentation/pfd/spd-sel", 0, "DOUBLE"),
		speedTrend: props.globals.initNode("/instrumentation/pfd/speed-trend", 0, "DOUBLE"),
		trackBug: [props.globals.initNode("/instrumentation/pfd/track-bug[0]", 0, "DOUBLE"), props.globals.initNode("/instrumentation/pfd/track-bug[1]", 0, "DOUBLE")],
		vsBugDn: props.globals.initNode("/instrumentation/pfd/vs-bug-dn", 0, "DOUBLE"),
		vsBugUp: props.globals.initNode("/instrumentation/pfd/vs-bug-up", 0, "DOUBLE"),
		vsNeedleDn: props.globals.initNode("/instrumentation/pfd/vs-needle-dn", 0, "DOUBLE"),
		vsNeedleUp: props.globals.initNode("/instrumentation/pfd/vs-needle-up", 0, "DOUBLE"),
		vsDigit: props.globals.initNode("/instrumentation/pfd/vs-digit", 0, "DOUBLE"),
	},
	Sd: {
		Config: {
			aileronL: props.globals.getNode("/instrumentation/sd/config/aileron-l"),
			aileronR: props.globals.getNode("/instrumentation/sd/config/aileron-r"),
			elevatorL: props.globals.getNode("/instrumentation/sd/config/elevator-l"),
			elevatorR: props.globals.getNode("/instrumentation/sd/config/elevator-r"),
		},
		Eng: {
			oilPsi: [props.globals.getNode("/instrumentation/sd/eng/oil-psi[0]"), props.globals.getNode("/instrumentation/sd/eng/oil-psi[1]"), props.globals.getNode("/instrumentation/sd/eng/oil-psi[2]")],
			oilQty: [props.globals.getNode("/instrumentation/sd/eng/oil-qty[0]"), props.globals.getNode("/instrumentation/sd/eng/oil-qty[1]"), props.globals.getNode("/instrumentation/sd/eng/oil-qty[2]")],
			oilQtyCline: [props.globals.getNode("/instrumentation/sd/eng/oil-qty-cline[0]"), props.globals.getNode("/instrumentation/sd/eng/oil-qty-cline[1]"), props.globals.getNode("/instrumentation/sd/eng/oil-qty-cline[2]")],
			oilTemp: [props.globals.getNode("/instrumentation/sd/eng/oil-temp[0]"), props.globals.getNode("/instrumentation/sd/eng/oil-temp[1]"), props.globals.getNode("/instrumentation/sd/eng/oil-temp[2]")],
		},
	},
};

var Options = {
	eng: props.globals.getNode("/options/eng"),
	pw62k: props.globals.getNode("/options/pw-62k"),
};

var Orientation = {
	headingDeg: props.globals.getNode("/orientation/heading-deg"),
	headingMagneticDeg: props.globals.getNode("/orientation/heading-magnetic-deg"),
	pitchDeg: props.globals.getNode("/orientation/pitch-deg"),
	rollDeg: props.globals.getNode("/orientation/roll-deg"),
};

var Position = {
	gearAglFt: props.globals.getNode("/position/gear-agl-ft"),
	node: props.globals.getNode("/position"),
};

var Services = {
	Chocks: {
		enable: props.globals.getNode("/services/chocks/enable"),
		enableTemp: 1,
	},
};

var Sim = {
	CurrentView: {
		fieldOfView: props.globals.getNode("/sim/current-view/field-of-view", 1),
		headingOffsetDeg: props.globals.getNode("/sim/current-view/heading-offset-deg", 1),
		name: props.globals.getNode("/sim/current-view/name", 1),
		pitchOffsetDeg: props.globals.getNode("/sim/current-view/pitch-offset-deg", 1),
		rollOffsetDeg: props.globals.getNode("/sim/current-view/roll-offset-deg", 1),
		viewNumber: props.globals.getNode("/sim/current-view/view-number", 1),
		viewNumberRaw: props.globals.getNode("/sim/current-view/view-number-raw", 1),
		xOffsetM: props.globals.getNode("/sim/current-view/x-offset-m", 1),
		yOffsetM: props.globals.getNode("/sim/current-view/y-offset-m", 1),
		zOffsetDefault: props.globals.getNode("/sim/current-view/z-offset-default", 1),
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
	},
	Sound: {
		btn1: props.globals.initNode("/sim/sound/btn1", 0, "BOOL"),
		btn2: props.globals.initNode("/sim/sound/btn2", 0, "BOOL"),
		btn3: props.globals.initNode("/sim/sound/btn3", 0, "BOOL"),
		flapsClick: props.globals.initNode("/sim/sound/flaps-click", 0, "BOOL"),
		knb1: props.globals.initNode("/sim/sound/knb1", 0, "BOOL"),
		noSmokingSign: props.globals.initNode("/sim/sound/no-smoking-sign", 0, "BOOL"),
		noSmokingSignInhibit: props.globals.initNode("/sim/sound/no-smoking-sign-inhibit", 0, "BOOL"),
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
			deflectedAileronEquipped: props.globals.getNode("/systems/acconfig/options/deflected-aileron-equipped"),
			Du: {
				eadFps: props.globals.getNode("/systems/acconfig/options/du/ead-fps"),
				iesiFps: props.globals.getNode("/systems/acconfig/options/du/iesi-fps"),
				mcduFps: props.globals.getNode("/systems/acconfig/options/du/mcdu-fps"),
				ndFps: props.globals.getNode("/systems/acconfig/options/du/nd-fps"),
				pfdFps: props.globals.getNode("/systems/acconfig/options/du/pfd-fps"),
				sdFps: props.globals.getNode("/systems/acconfig/options/du/sd-fps"),
			},
			iesiEquipped: props.globals.getNode("/systems/acconfig/options/iesi-equipped"),
			throttleOverride: props.globals.getNode("/systems/acconfig/options/throttle-override"),
		}
	},
	Shake: {
		effect: props.globals.getNode("/systems/shake/effect"),
		shaking: props.globals.getNode("/systems/shake/shaking"),
	},
};

var Velocities = {
	groundspeedKt: props.globals.getNode("/velocities/groundspeed-kt"),
	groundspeedKtTemp: 0,
};

setprop("/systems/acconfig/property-tree-setup-loaded", 1);
