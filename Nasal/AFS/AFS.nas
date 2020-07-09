# McDonnell Douglas MD-11 AFS
# Based off IT-AUTOFLIGHT System Controller V4.0.X
# Copyright (c) 2020 Josh Davidson (Octal450)
# This file DOES NOT integrate with Property Tree Setup
# That way, we can update it from generic IT-AUTOFLIGHT easily

# Initialize all used variables and property nodes
# Sim
var Controls = {
	aileron: props.globals.getNode("/controls/flight/aileron", 1), # Not written to, so lets use actual yoke value
	elevator: props.globals.getNode("/controls/flight/elevator", 1), # Not written to, so lets use actual yoke value
	rudder: props.globals.getNode("/controls/flight/rudder", 1),
};

var Engines = {
	reverserNorm: [props.globals.getNode("/engines/engine[0]/reverser-pos-norm", 1), props.globals.getNode("/engines/engine[1]/reverser-pos-norm", 1), props.globals.getNode("/engines/engine[2]/reverser-pos-norm", 1)],
};

var FPLN = {
	active: props.globals.getNode("/autopilot/route-manager/active", 1),
	activeTemp: 0,
	currentCourse: 0,
	currentWp: props.globals.getNode("/autopilot/route-manager/current-wp", 1),
	currentWpTemp: 0,
	deltaAngle: 0,
	deltaAngleRad: 0,
	distCoeff: 0,
	maxBank: 0,
	maxBankLimit: 0,
	nextCourse: 0,
	num: props.globals.getNode("/autopilot/route-manager/route/num", 1),
	numTemp: 0,
	R: 0,
	radius: 0,
	turnDist: 0,
	wp0Dist: props.globals.getNode("/autopilot/route-manager/wp/dist", 1),
	wpFlyFrom: 0,
	wpFlyTo: 0,
};

var Gear = {
	wow0: props.globals.getNode("/gear/gear[0]/wow", 1),
	wow1: props.globals.getNode("/gear/gear[1]/wow", 1),
	wow1Temp: 1,
	wow2: props.globals.getNode("/gear/gear[2]/wow", 1),
	wow2Temp: 1,
};

var Misc = {
	elapsedSec: props.globals.getNode("/sim/time/elapsed-sec", 1),
	flapDeg: props.globals.getNode("/fdm/jsbsim/fcs/flap-pos-deg", 1),
	ir0Align: props.globals.getNode("/instrumentation/irs/ir[0]/aligned", 1),
	ir1Align: props.globals.getNode("/instrumentation/irs/ir[1]/aligned", 1),
	ir2Align: props.globals.getNode("/instrumentation/irs/ir[2]/aligned", 1),
	irAnyAlign: 0,
	pfdHeadingScale: props.globals.getNode("/instrumentation/pfd/heading-scale", 1),
	pfdHeadingScaleTemp: 0,
	state1: props.globals.getNode("/engines/engine[0]/state", 1),
	state2: props.globals.getNode("/engines/engine[1]/state", 1),
	state3: props.globals.getNode("/engines/engine[2]/state", 1),
};

var Position = {
	gearAglFtTemp: 0,
	gearAglFt: props.globals.getNode("/position/gear-agl-ft", 1),
	indicatedAltitudeFt: props.globals.getNode("/instrumentation/altimeter/indicated-altitude-ft", 1),
	indicatedAltitudeFtTemp: 0,
};

var Radio = {
	gsDefl: [props.globals.getNode("/instrumentation/nav[0]/gs-needle-deflection-norm", 1), props.globals.getNode("/instrumentation/nav[1]/gs-needle-deflection-norm", 1)],
	gsDeflTemp: 0,
	inRange: [props.globals.getNode("/instrumentation/nav[0]/in-range", 1), props.globals.getNode("/instrumentation/nav[1]/in-range", 1)],
	inRangeTemp: 0,
	locDefl: [props.globals.getNode("/instrumentation/nav[0]/heading-needle-deflection-norm", 1), props.globals.getNode("/instrumentation/nav[1]/heading-needle-deflection-norm", 1)],
	locDeflTemp: 0,
	radioSel: 0,
	signalQuality: [props.globals.getNode("/instrumentation/nav[0]/signal-quality-norm", 1), props.globals.getNode("/instrumentation/nav[1]/signal-quality-norm", 1)],
	signalQualityTemp: 0,
};

var Velocities = {
	groundspeedKt: props.globals.getNode("/velocities/groundspeed-kt", 1),
	groundspeedMps: 0,
	indicatedAirspeedKt: props.globals.getNode("/instrumentation/airspeed-indicator/indicated-speed-kt", 1),
	indicatedAirspeedKt5Sec: props.globals.getNode("/it-autoflight/internal/kts-predicted-5", 1),
	indicatedMach: props.globals.getNode("/instrumentation/airspeed-indicator/indicated-mach", 1),
	indicatedMach5Sec: props.globals.getNode("/it-autoflight/internal/mach-predicted-5", 1),
	trueAirspeedKt: props.globals.getNode("/instrumentation/airspeed-indicator/true-speed-kt", 1),
	trueAirspeedKtTemp: 0,
};

# IT-AUTOFLIGHT
var Input = {
	alt: props.globals.initNode("/it-autoflight/input/alt", 10000, "INT"),
	ap1: props.globals.initNode("/it-autoflight/input/ap1", 0, "BOOL"),
	ap2: props.globals.initNode("/it-autoflight/input/ap2", 0, "BOOL"),
	athr: props.globals.initNode("/it-autoflight/input/athr", 0, "BOOL"),
	altDiff: 0,
	bankLimitSW: props.globals.initNode("/it-autoflight/input/bank-limit-sw", 0, "INT"),
	bankLimitSWTemp: 0,
	fd1: props.globals.initNode("/it-autoflight/input/fd1", 1, "BOOL"),
	fd2: props.globals.initNode("/it-autoflight/input/fd2", 1, "BOOL"),
	fpa: props.globals.initNode("/it-autoflight/input/fpa", 0, "DOUBLE"),
	fpaAbs: props.globals.initNode("/it-autoflight/input/fpa-abs", 0, "DOUBLE"), # Set by property rule
	hdg: props.globals.initNode("/it-autoflight/input/hdg", 0, "INT"),
	kts: props.globals.initNode("/it-autoflight/input/kts", 0, "INT"),
	ktsMach: props.globals.initNode("/it-autoflight/input/kts-mach", 0, "BOOL"),
	ktsMachTemp: 0,
	lat: props.globals.initNode("/it-autoflight/input/lat", 5, "INT"),
	latTemp: 5,
	mach: props.globals.initNode("/it-autoflight/input/mach", 0.5, "DOUBLE"),
	toga: props.globals.initNode("/it-autoflight/input/toga", 0, "BOOL"),
	trk: props.globals.initNode("/it-autoflight/input/trk", 0, "BOOL"),
	trkTemp: 0,
	trueCourse: props.globals.initNode("/it-autoflight/input/true-course", 0, "BOOL"),
	useNav2Radio: props.globals.initNode("/it-autoflight/input/use-nav2-radio", 0, "BOOL"),
	vs: props.globals.initNode("/it-autoflight/input/vs", 0, "INT"),
	vsAbs: props.globals.initNode("/it-autoflight/input/vs-abs", 0, "INT"), # Set by property rule
	vert: props.globals.initNode("/it-autoflight/input/vert", 7, "INT"),
	vertTemp: 7,
};

var Internal = {
	alt: props.globals.initNode("/it-autoflight/internal/alt", 10000, "INT"),
	altAlert: props.globals.initNode("/it-autoflight/internal/alt-alert", 0, "BOOL"),
	altAlertAural: props.globals.initNode("/it-autoflight/internal/alt-alert-aural", 0, "BOOL"),
	altCaptureActive: 0,
	altDiff: 0,
	altTemp: 0,
	altPredicted: props.globals.initNode("/it-autoflight/internal/altitude-predicted", 0, "DOUBLE"),
	bankLimit: props.globals.initNode("/it-autoflight/internal/bank-limit", 25, "INT"),
	bankLimitAuto: 25,
	captVs: 0,
	driftAngle: props.globals.initNode("/it-autoflight/internal/drift-angle-deg", 0, "DOUBLE"),
	flchActive: 0,
	fpa: props.globals.initNode("/it-autoflight/internal/fpa", 0, "DOUBLE"),
	hdg: props.globals.initNode("/it-autoflight/internal/hdg", 0, "INT"),
	hdgCalc: 0,
	hdgSet: 0,
	kts: props.globals.initNode("/it-autoflight/internal/kts", 250, "INT"),
	ktsMach: props.globals.initNode("/it-autoflight/internal/kts-mach", 0, "BOOL"),
	hdgPredicted: props.globals.initNode("/it-autoflight/internal/heading-predicted", 0, "DOUBLE"),
	lnavAdvanceNm: props.globals.initNode("/it-autoflight/internal/lnav-advance-nm", 0, "DOUBLE"),
	lnavEngageFt: 100,
	mach: props.globals.initNode("/it-autoflight/internal/mach", 0.5, "DOUBLE"),
	minVs: props.globals.initNode("/it-autoflight/internal/min-vs", -500, "INT"),
	maxVs: props.globals.initNode("/it-autoflight/internal/max-vs", 500, "INT"),
	vs: props.globals.initNode("/it-autoflight/internal/vert-speed-fpm", 0, "DOUBLE"),
	vsTemp: 0,
};

var Output = {
	ap1: props.globals.initNode("/it-autoflight/output/ap1", 0, "BOOL"),
	ap1Temp: 0,
	ap2: props.globals.initNode("/it-autoflight/output/ap2", 0, "BOOL"),
	ap2Temp: 0,
	apprArm: props.globals.initNode("/it-autoflight/output/appr-armed", 0, "BOOL"),
	athr: props.globals.initNode("/it-autoflight/output/athr", 0, "BOOL"),
	athrTemp: 0,
	fd1: props.globals.initNode("/it-autoflight/output/fd1", 1, "BOOL"),
	fd1Temp: 0,
	fd2: props.globals.initNode("/it-autoflight/output/fd2", 1, "BOOL"),
	fd2Temp: 0,
	lat: props.globals.initNode("/it-autoflight/output/lat", 5, "INT"),
	latTemp: 5,
	lnavArm: props.globals.initNode("/it-autoflight/output/lnav-armed", 0, "BOOL"),
	locArm: props.globals.initNode("/it-autoflight/output/loc-armed", 0, "BOOL"),
	thrMode: props.globals.initNode("/it-autoflight/output/thr-mode", 2, "INT"),
	vert: props.globals.initNode("/it-autoflight/output/vert", 7, "INT"),
	vertTemp: 7,
};

var Setting = {
	reducAglFt: props.globals.initNode("/it-autoflight/settings/reduc-agl-ft", 1000, "INT"), # Will be changable from FMS
};

var Sound = {
	apOff: props.globals.initNode("/it-autoflight/sound/apoffsound", 0, "BOOL"),
	enableApOff: 0,
};

var Text = {
	arm: props.globals.initNode("/it-autoflight/mode/arm", " ", "STRING"),
	lat: props.globals.initNode("/it-autoflight/mode/lat", "T/O", "STRING"),
	latTemp: "T/O",
	thr: props.globals.initNode("/it-autoflight/mode/thr", "PITCH", "STRING"),
	vert: props.globals.initNode("/it-autoflight/mode/vert", "T/O CLB", "STRING"),
	vertTemp: "T/O CLB",
};

# MD-11 Custom
var Custom = {
	apWarn: props.globals.initNode("/it-autoflight/custom/apwarn", 0, "BOOL"),
	atsFlash: props.globals.initNode("/it-autoflight/custom/atsflash", 0, "BOOL"),
	atsWarn: props.globals.initNode("/it-autoflight/custom/atswarn", 0, "BOOL"),
	canAutoland: 0,
	enableAtsOff: 0,
	landCondition: 0,
	landModeActive: 0,
	retardLock: 0,
	selfCheckStatus: 0,
	selfCheckTime: 0,
	showHdg: props.globals.initNode("/it-autoflight/custom/show-hdg", 1, "BOOL"),
	targetHDGError: 0,
	targetKts: 0,
	targetKtsError: 0,
	vsFpa: props.globals.initNode("/it-autoflight/custom/vs-fpa", 0, "BOOL"),
	FMS: {
		v2Speed: props.globals.getNode("/FMS/internal/v2", 1),
	},
	Input: {
		ovrd1: props.globals.initNode("/it-autoflight/input/ovrd1", 0, "BOOL"),
		ovrd1Temp: 0,
		ovrd2: props.globals.initNode("/it-autoflight/input/ovrd2", 0, "BOOL"),
		ovrd2Temp: 0,
	},
	Internal: {
		activeFMS: props.globals.initNode("/it-autoflight/internal/active-fms", 1, "INT"),
		activeFMSTemp: 1,
	},
	Output: {
		ap1Avail: props.globals.initNode("/it-autoflight/output/ap1-available", 0, "BOOL"),
		ap2Avail: props.globals.initNode("/it-autoflight/output/ap2-available", 0, "BOOL"),
		atsAvail: props.globals.initNode("/it-autoflight/output/ats-available", 0, "BOOL"),
		clamp: props.globals.initNode("/it-autoflight/output/clamp", 0, "BOOL"),
		hdgCaptured: 1,
		spdCaptured: 1,
	},
	Text: {
		land: props.globals.initNode("/it-autoflight/mode/land", "OFF", "STRING"),
	},
};

var ITAF = {
	init: func(t) { # Not everything should be reset if the reset is type 1
		if (t != 1) {
			Input.ktsMach.setBoolValue(0);
			Input.kts.setValue(250);
			Input.mach.setValue(0.5);
			Input.hdg.setValue(0);
			Custom.vsFpa.setBoolValue(0);
		}
		Internal.ktsMach.setBoolValue(0);
		Input.ap1.setBoolValue(0);
		Input.ap2.setBoolValue(0);
		Input.athr.setBoolValue(0);
		Input.fd1.setBoolValue(1);
		Input.fd2.setBoolValue(1);
		if (t != 1) {
			Internal.hdg.setValue(0);
			Input.alt.setValue(10000);
		}
		Input.vs.setValue(0);
		Input.fpa.setValue(0);
		Input.lat.setValue(5);
		Input.vert.setValue(7);
		if (t != 1) {
			Input.trk.setBoolValue(0);
			Input.trueCourse.setBoolValue(0);
		}
		Input.toga.setBoolValue(0);
		if (t != 1) {
			Input.bankLimitSW.setValue(0);
			Custom.Input.ovrd1.setBoolValue(0);
			Custom.Input.ovrd2.setBoolValue(0);
		}
		Input.useNav2Radio.setBoolValue(0);
		Output.ap1.setBoolValue(0);
		Output.ap2.setBoolValue(0);
		Output.athr.setBoolValue(0);
		Output.fd1.setBoolValue(1);
		Output.fd2.setBoolValue(1);
		Output.lnavArm.setBoolValue(0);
		Output.locArm.setBoolValue(0);
		Output.apprArm.setBoolValue(0);
		Output.thrMode.setValue(0);
		Output.lat.setValue(5);
		Output.vert.setValue(7);
		Internal.minVs.setValue(-500);
		Internal.maxVs.setValue(500);
		Internal.bankLimit.setValue(25);
		Internal.bankLimitAuto = 25;
		if (t != 1) {
			Internal.alt.setValue(10000);
		}
		Internal.altCaptureActive = 0;
		Internal.kts.setValue(Custom.FMS.v2Speed.getValue());
		Internal.mach.setValue(0.5);
		Text.thr.setValue("PITCH");
		Text.arm.setValue(" ");
		Text.lat.setValue("T/O");
		Text.vert.setValue("T/O CLB");
		Custom.retardLock = 0;
		Custom.Text.land.setValue("OFF");
		Custom.Output.spdCaptured = 1;
		Custom.Output.hdgCaptured = 1;
		me.updateActiveFMS(1);
		Custom.showHdg.setBoolValue(1);
		if (t != 1) {
			Sound.apOff.setBoolValue(0);
			Custom.apWarn.setBoolValue(0);
			Custom.atsFlash.setBoolValue(0);
			Custom.atsWarn.setBoolValue(0);
			Sound.enableApOff = 0;
			Custom.enableAtsOff = 0;
			apKill.stop();
			atsKill.stop();
		}
		updateFMA.roll();
		updateFMA.pitch();
		updateFMA.arm();
		loopTimer.start();
		slowLoopTimer.start();
		clampLoop.start();
	},
	loop: func() {
		Output.latTemp = Output.lat.getValue();
		Output.vertTemp = Output.vert.getValue();
		
		# VOR/ILS Revision
		if (Output.latTemp == 2 or Output.vertTemp == 2 or Output.vertTemp == 6) {
			me.checkRadioRevision(Output.latTemp, Output.vertTemp);
		}
		
		Gear.wow1Temp = Gear.wow1.getBoolValue();
		Gear.wow2Temp = Gear.wow2.getBoolValue();
		Output.ap1Temp = Output.ap1.getBoolValue();
		Output.ap2Temp = Output.ap2.getBoolValue();
		Output.athrTemp = Output.athr.getBoolValue();
		Output.latTemp = Output.lat.getValue();
		Output.vertTemp = Output.vert.getValue();
		Text.vertTemp = Text.vert.getValue();
		Position.gearAglFtTemp = Position.gearAglFt.getValue();
		Internal.vsTemp = Internal.vs.getValue();
		Position.indicatedAltitudeFtTemp = Position.indicatedAltitudeFt.getValue();
		
		# Kill when power lost
		if (systems.ELEC.Bus.dc1.getValue() < 25 or systems.ELEC.Bus.dc2.getValue() < 25 or systems.ELEC.Bus.dc3.getValue() < 25) {
			if (Output.ap1Temp or Output.ap2Temp) {
				me.killAFSSilent();
			}
			if (Output.athrTemp) {
				me.killATSSilent();
			}
		}
		
		# Kill Autoland if AP is turned off
		if (!Output.ap1Temp and !Output.ap2Temp) {
			if (Output.latTemp == 4) {
				me.activateLOC();
			}
			if (Output.vertTemp == 6) {
				me.activateGS();
			}
		}
		
		# Update LNAV engage altitude
		if (Output.ap1Temp or Output.ap2Temp) {
			Internal.lnavEngageFt = 400;
		} else {
			Internal.lnavEngageFt = 100;
		}
		
		# LNAV Engagement
		if (Output.lnavArm.getBoolValue()) {
			me.checkLNAV(1);
		}
		
		# VOR/LOC or ILS/LOC Capture
		if (Output.locArm.getBoolValue()) {
			me.checkLOC(1, 0);
		}
		
		# G/S Capture
		if (Output.apprArm.getBoolValue()) {
			me.checkAPPR(1);
		}
		
		# Autoland Logic
		if (Output.latTemp == 2) {
			if (Position.gearAglFtTemp <= 150) {
				if (Output.ap1Temp or Output.ap2Temp) {
					me.setLatMode(4);
				}
			}
		}
		if (Output.vertTemp == 2) {
			if (Position.gearAglFtTemp <= 100 and Position.gearAglFtTemp >= 5) {
				if (Output.ap1Temp or Output.ap2Temp) {
					me.setVertMode(6);
				}
			}
		} else if (Output.vertTemp == 6) {
			if (!Output.ap1Temp and !Output.ap2Temp) {
				me.activateLOC();
				me.activateGS();
			} else {
				if (Position.gearAglFtTemp <= 50 and Position.gearAglFtTemp >= 5) {
					me.updateVertText("FLARE");
				}
				if (Gear.wow1Temp and Gear.wow2Temp) {
					me.updateLatText("RLOU");
					me.updateVertText("ROLLOUT");
				}
			}
		}
		
		# FLCH Engagement
		if (Text.vertTemp == "T/O CLB") {
			me.checkFLCH(Setting.reducAglFt.getValue());
		}
		
		# Altitude Capture/Sync Logic
		if (Output.vertTemp != 0) {
			Internal.alt.setValue(Input.alt.getValue());
		}
		Internal.altTemp = Internal.alt.getValue();
		Internal.altDiff = Internal.altTemp - Position.indicatedAltitudeFtTemp;
		
		if (Output.vertTemp != 0 and Output.vertTemp != 2 and Output.vertTemp != 6) {
			Internal.captVs = math.clamp(math.round(abs(Internal.vs.getValue()) / 5, 100), 50, 2500); # Capture limits
			if (abs(Internal.altDiff) <= Internal.captVs and !Gear.wow1Temp and !Gear.wow2Temp) {
				if (Internal.altTemp >= Position.indicatedAltitudeFtTemp and Internal.vsTemp >= -25) { # Don't capture if we are going the wrong way
					me.setVertMode(3);
				} else if (Internal.altTemp < Position.indicatedAltitudeFtTemp and Internal.vsTemp <= 25) { # Don't capture if we are going the wrong way
					me.setVertMode(3);
				}
			}
		}
		
		# Altitude Hold Min/Max Reset
		if (Internal.altCaptureActive) {
			if (abs(Internal.altDiff) <= 25) {
				me.resetClimbRateLim();
				me.updateVertText("ALT HLD");
			}
		}
		
		# Altitude Alert
		Text.vertTemp = Text.vert.getValue(); # We want it updated so that the sound doesn't play as wrong time
		if (Output.vertTemp != 2 and Output.vertTemp != 6 and Misc.flapDeg.getValue() < 31.5) {
			if (abs(Internal.altDiff) >= 150 and Text.vertTemp == "ALT HLD") {
				Internal.altAlert.setBoolValue(1);
			} else if (abs(Internal.altDiff) >= 150 and abs(Internal.altDiff) <= 1000 and Text.vertTemp != "ALT HLD") {
				Internal.altAlert.setBoolValue(1);
			} else {
				Internal.altAlert.setBoolValue(0);
			}
		} else {
			Internal.altAlert.setBoolValue(0);
		}
		
		if (abs(Internal.altDiff) > 1050) {
			Internal.altAlertAural.setBoolValue(1);
		} else if (abs(Internal.altDiff) < 950 and !Internal.altAlert.getBoolValue()) {
			Internal.altAlertAural.setBoolValue(0);
		}
		
		# Thrust Mode Selector
		if (Output.athrTemp and Output.vertTemp != 7 and Position.gearAglFt.getValue() <= 50 and Misc.flapDeg.getValue() >= 31.5) {
			Output.thrMode.setValue(1);
			Text.thr.setValue("RETARD");
			Custom.retardLock = 1;
		} else if (Custom.retardLock != 1) { # Stays in RETARD unless we tell it to go to THRUST or PITCH
			if (Output.vertTemp == 4) {
				if (Internal.altTemp >= Position.indicatedAltitudeFtTemp) {
					Output.thrMode.setValue(2);
					Text.thr.setValue("PITCH");
					if (Internal.flchActive) { # Set before mode change to prevent it from overwriting by mistake
						me.updateVertText("SPD CLB");
					}
				} else {
					Output.thrMode.setValue(1);
					Text.thr.setValue("PITCH");
					if (Internal.flchActive) { # Set before mode change to prevent it from overwriting by mistake
						me.updateVertText("SPD DES");
					}
				}
			} else if (Output.vertTemp == 7) {
				Output.thrMode.setValue(2);
				Text.thr.setValue("PITCH");
			} else {
				Output.thrMode.setValue(0);
				Text.thr.setValue("THRUST");
			}
		}
		
		# Custom Stuff Below
		# Speed Capture
		if (Text.vertTemp != "T/O CLB") {
			if (!Custom.Output.spdCaptured) {
				Input.ktsMachTemp = Input.ktsMach.getBoolValue();
				if (Input.ktsMachTemp) {
					Internal.mach.setValue(Input.mach.getValue());
					Custom.targetKts = Internal.mach.getValue() * (Velocities.indicatedAirspeedKt.getValue() / Velocities.indicatedMach.getValue()); # Convert to Knots
				} else {
					Internal.kts.setValue(Input.kts.getValue());
					Custom.targetKts = Internal.kts.getValue();
				}
				Custom.targetKtsError = Custom.targetKts - Velocities.indicatedAirspeedKt5Sec.getValue();
				if (abs(Custom.targetKtsError) <= 2.5) {
					Custom.Output.spdCaptured = 1;
				}
			}
		} else if (!Custom.Output.spdCaptured) {
			Custom.Output.spdCaptured = 1;
		}
		
		# Heading Sync
		if (!Custom.showHdg.getBoolValue()) {
			Misc.pfdHeadingScaleTemp = Misc.pfdHeadingScale.getValue();
			Internal.hdg.setValue(Misc.pfdHeadingScaleTemp);
			Input.hdg.setValue(Misc.pfdHeadingScaleTemp);
		}
		
		# Heading Capture
		if (Output.latTemp == 0) {
			if (!Custom.Output.hdgCaptured) {
				Internal.hdg.setValue(Input.hdg.getValue());
				Custom.targetHDGError = Internal.hdg.getValue() - Internal.hdgPredicted.getValue();
				if (abs(Custom.targetHDGError) <= 2.5) {
					Custom.Output.hdgCaptured = 1;
				}
			}
		} else if (!Custom.Output.hdgCaptured) {
			Custom.Output.hdgCaptured = 1;
		}
		
		# Autoland Logic
		if (Output.vertTemp == 2 or Output.vertTemp == 6) {
			Radio.radioSel = Input.useNav2Radio.getBoolValue();
			Radio.locDeflTemp = Radio.locDefl[Radio.radioSel].getValue();
			Radio.signalQualityTemp = Radio.signalQuality[Radio.radioSel].getValue();
			Custom.canAutoland = (abs(Radio.locDeflTemp) <= 0.1 and Radio.locDeflTemp != 0 and Radio.signalQualityTemp >= 0.99) or Gear.wow0.getBoolValue();
		} else {
			Custom.canAutoland = 0;
		}
		Custom.landModeActive = (Output.latTemp == 2 or Output.latTemp == 4) and (Output.vertTemp == 2 or Output.vertTemp == 6);
		
		if (Position.gearAglFtTemp <= 1500 and Custom.landModeActive) {
			Custom.selfCheckStatus = 1;
		} else if (!Custom.landModeActive) {
			Custom.selfCheckStatus = 0;
		}
		
		if (Custom.selfCheckStatus == 1) {
			if (Custom.selfCheckStatus != 2 and Custom.selfCheckTime + 10 < Misc.elapsedSec.getValue()) {
				Custom.selfCheckStatus = 2;
			}
		} else {
			Custom.selfCheckTime = Misc.elapsedSec.getValue();
		}
		
		if (Custom.canAutoland and Custom.landModeActive and Custom.selfCheckStatus == 2) {
			if ((Output.ap1Temp or Output.ap2Temp) and Custom.Output.ap1Avail.getBoolValue() and Custom.Output.ap2Avail.getBoolValue() and Output.athr.getBoolValue() and Position.gearAglFtTemp <= 1500) { # Don't engage DUAL LAND below 100ft
				Custom.landCondition = "DUAL";
			} else if (Output.ap1Temp or Output.ap2Temp and Position.gearAglFtTemp <= 1500) { # Don't engage SINGLE LAND below 100ft
				Custom.landCondition = "SINGLE";
			} else {
				Custom.landCondition = "APPR";
			}
		} else {
			Custom.landCondition = "OFF";
		}
		
		if (Custom.landCondition != Custom.Text.land.getValue()) {
			Custom.Text.land.setValue(Custom.landCondition);
		}
		
		# Trip system off
		if (Output.ap1Temp == 1 or Output.ap2Temp == 1) { 
			if (abs(Controls.aileron.getValue()) >= 0.2 or abs(Controls.elevator.getValue()) >= 0.2) {
				me.ap1Master(0);
				me.ap2Master(0);
			}
		}
		if (!Custom.Output.ap1Avail.getBoolValue() and Output.ap1Temp) {
			me.ap1Master(0);
		}
		if (!Custom.Output.ap2Avail.getBoolValue() and Output.ap2Temp) {
			me.ap2Master(0);
		}
		if (!Custom.Output.atsAvail.getBoolValue() and Output.athrTemp) {
			if (Engines.reverserNorm[0].getValue() >= 0.01 or Engines.reverserNorm[1].getValue() >= 0.01 or Engines.reverserNorm[2].getValue() >= 0.01) { # Silently kill ATS only if a reverser is deployed
				me.killATSSilent();
			} else {
				me.athrMaster(0);
			}
		}
		
		if (Custom.landCondition != "DUAL" and Custom.landCondition != "SINGLE" and Text.vert.getValue() != "G/A CLB") {
			if (Position.gearAglFtTemp < 400 and Output.latTemp == 1) { # NAV trips at 400ft
				if (Output.ap1Temp) {
					me.ap1Master(0);
				}
				if (Output.ap2Temp) {
					me.ap2Master(0);
				}
			} else if (Position.gearAglFtTemp < 100 and Output.latTemp != 1) {
				if (Output.ap1Temp) {
					me.ap1Master(0);
				}
				if (Output.ap2Temp) {
					me.ap2Master(0);
				}
			}
		}
	},
	slowLoop: func() {
		Input.bankLimitSWTemp = Input.bankLimitSW.getValue();
		Velocities.trueAirspeedKtTemp = Velocities.trueAirspeedKt.getValue();
		FPLN.activeTemp = FPLN.active.getValue();
		FPLN.currentWpTemp = FPLN.currentWp.getValue();
		FPLN.numTemp = FPLN.num.getValue();
		
		# Bank Limit
		if (Velocities.trueAirspeedKtTemp >= 420) {
			Internal.bankLimitAuto = 15;
		} else if (Velocities.trueAirspeedKtTemp >= 340) {
			Internal.bankLimitAuto = 20;
		} else {
			Internal.bankLimitAuto = 25;
		}
		
		if (Input.bankLimitSWTemp == 0) {
			Internal.bankLimit.setValue(Internal.bankLimitAuto);
		} else if (Input.bankLimitSWTemp == 1) {
			Internal.bankLimit.setValue(5);
		} else if (Input.bankLimitSWTemp == 2) {
			Internal.bankLimit.setValue(10);
		} else if (Input.bankLimitSWTemp == 3) {
			Internal.bankLimit.setValue(15);
		} else if (Input.bankLimitSWTemp == 4) {
			Internal.bankLimit.setValue(20);
		} else if (Input.bankLimitSWTemp == 5) {
			Internal.bankLimit.setValue(25);
		}
		
		# If in LNAV mode and route is not longer active, switch to HDG HLD
		if (Output.lat.getValue() == 1) { # Only evaulate the rest of the condition if we are in LNAV mode
			if (FPLN.num.getValue() == 0 or !FPLN.active.getBoolValue()) {
				me.setLatMode(3);
			}
		}
		
		# Waypoint Advance Logic
		if (FPLN.numTemp > 0 and FPLN.activeTemp == 1) {
			if ((FPLN.currentWpTemp + 1) < FPLN.numTemp) {
				Velocities.groundspeedMps = Velocities.groundspeedKt.getValue() * 0.5144444444444;
				FPLN.wpFlyFrom = FPLN.currentWpTemp;
				if (FPLN.wpFlyFrom < 0) {
					FPLN.wpFlyFrom = 0;
				}
				FPLN.currentCourse = getprop("/autopilot/route-manager/route/wp[" ~ FPLN.wpFlyFrom ~ "]/leg-bearing-true-deg"); # Best left at getprop
				FPLN.wpFlyTo = FPLN.currentWpTemp + 1;
				if (FPLN.wpFlyTo < 0) {
					FPLN.wpFlyTo = 0;
				}
				FPLN.nextCourse = getprop("/autopilot/route-manager/route/wp[" ~ FPLN.wpFlyTo ~ "]/leg-bearing-true-deg"); # Best left at getprop
				FPLN.maxBankLimit = Internal.bankLimit.getValue();

				FPLN.deltaAngle = math.abs(geo.normdeg180(FPLN.currentCourse - FPLN.nextCourse));
				FPLN.maxBank = FPLN.deltaAngle * 1.5;
				if (FPLN.maxBank > FPLN.maxBankLimit) {
					FPLN.maxBank = FPLN.maxBankLimit;
				}
				FPLN.radius = (Velocities.groundspeedMps * Velocities.groundspeedMps) / (9.81 * math.tan(FPLN.maxBank / 57.2957795131));
				FPLN.deltaAngleRad = (180 - FPLN.deltaAngle) / 114.5915590262;
				FPLN.R = FPLN.radius / math.sin(FPLN.deltaAngleRad);
				FPLN.distCoeff = FPLN.deltaAngle * -0.011111 + 2;
				if (FPLN.distCoeff < 1) {
					FPLN.distCoeff = 1;
				}
				FPLN.turnDist = math.cos(FPLN.deltaAngleRad) * FPLN.R * FPLN.distCoeff / 1852;
				if (Gear.wow0.getBoolValue() and FPLN.turnDist < 1) {
					FPLN.turnDist = 1;
				}
				Internal.lnavAdvanceNm.setValue(FPLN.turnDist);
				
				if (FPLN.wp0Dist.getValue() <= FPLN.turnDist) {
					FPLN.currentWp.setValue(FPLN.currentWpTemp + 1);
				}
			}
		}
		
		# Reset system once flight complete
		if (!Output.ap1.getBoolValue() and !Output.ap2.getBoolValue() and Gear.wow0.getBoolValue() and Velocities.groundspeedKt.getValue() < 60 and Output.vert.getValue() != 7) { # Not in T/O or G/A
			fms.CORE.resetFMS();
		}
	},
	ap1Master: func(s) {
		if (s == 1) {
			if (me.apEngageAllowed() == 1 and Custom.Output.ap1Avail.getBoolValue()) {
				if (!Output.fd1.getBoolValue() and !Output.fd2.getBoolValue() and !Output.ap2.getBoolValue()) {
					me.setLatMode(3); # HDG HOLD
					if (abs(Internal.vs.getValue()) > 300) {
						me.setVertMode(1); # V/S
					} else {
						me.setVertMode(0); # HOLD
					}
				}
				Controls.rudder.setValue(0);
				Output.ap1.setBoolValue(1);
				me.updateActiveFMS(1);
				apKill.stop();
				Custom.apWarn.setBoolValue(0);
				Sound.apOff.setBoolValue(0);
				Sound.enableApOff = 1;
			} else if (me.apEngageAllowed() == 2) {
				Sound.apOff.setBoolValue(1);
				Sound.enableApOff = 0;
				apKill.start();	
			}
		} else {
			Output.ap1.setBoolValue(0);
			if (Custom.Output.ap2Avail.getBoolValue()) {
				me.updateActiveFMS(2);
			}
			me.apOffFunction();
		}
		Output.ap1Temp = Output.ap1.getBoolValue();
		if (Input.ap1.getBoolValue() != Output.ap1Temp) {
			Input.ap1.setBoolValue(Output.ap1Temp);
		}
	},
	ap2Master: func(s) {
		if (s == 1) {
			if (me.apEngageAllowed() == 1 and Custom.Output.ap2Avail.getBoolValue()) {
				if (!Output.fd1.getBoolValue() and !Output.fd2.getBoolValue() and !Output.ap1.getBoolValue()) {
					me.setLatMode(3); # HDG HOLD
					if (abs(Internal.vs.getValue()) > 300) {
						me.setVertMode(1); # V/S
					} else {
						me.setVertMode(0); # HOLD
					}
				}
				Controls.rudder.setValue(0);
				Output.ap2.setBoolValue(1);
				me.updateActiveFMS(2);
				apKill.stop();
				Custom.apWarn.setBoolValue(0);
				Sound.apOff.setBoolValue(0);
				Sound.enableApOff = 1;
			} else if (me.apEngageAllowed() == 2) {
				Sound.apOff.setBoolValue(1);
				Sound.enableApOff = 0;
				apKill.start();	
			}
		} else {
			Output.ap2.setBoolValue(0);
			if (Custom.Output.ap1Avail.getBoolValue()) {
				me.updateActiveFMS(1);
			}
			me.apOffFunction();
		}
		Output.ap2Temp = Output.ap2.getBoolValue();
		if (Input.ap2.getBoolValue() != Output.ap2Temp) {
			Input.ap2.setBoolValue(Output.ap2Temp);
		}
	},
	apOffFunction: func() {
		if (!Output.ap1.getBoolValue() and !Output.ap2.getBoolValue()) { # Only do if both APs are off
			if (Sound.enableApOff) {
				Sound.apOff.setBoolValue(1);
				Sound.enableApOff = 0;
				apKill.start();	
			}
			if (Text.vert.getValue() == "ROLLOUT") {
				fms.CORE.resetFMS();
			}
		}
	},
	athrMaster: func(s) {
		if (s == 1) {
			if (Custom.Output.atsAvail.getBoolValue()) {
				Output.athr.setBoolValue(1);
				atsKill.stop();
				Custom.atsWarn.setBoolValue(0);
				Custom.atsFlash.setBoolValue(0);
				Custom.enableAtsOff = 1;
			}
		} else {
			Output.athr.setBoolValue(0);
			if (Custom.enableAtsOff) {
				Custom.atsFlash.setBoolValue(1);
				Custom.enableAtsOff = 0;
				atsKill.start();
			}
		}
		Output.athrTemp = Output.athr.getBoolValue();
		if (Input.athr.getBoolValue() != Output.athrTemp) {
			Input.athr.setBoolValue(Output.athrTemp);
		}
	},
	fd1Master: func(s) {
		if (s == 1) {
			if (!Output.fd2.getBoolValue() and !Output.ap1.getBoolValue() and !Output.ap2.getBoolValue()) {
				me.setLatMode(3); # HDG HOLD
					if (abs(Internal.vs.getValue()) > 300) {
					me.setVertMode(1); # V/S
				} else {
					me.setVertMode(0); # HOLD
				}
			}
			Output.fd1.setBoolValue(1);
		} else {
			Output.fd1.setBoolValue(0);
		}
		Output.fd1Temp = Output.fd1.getBoolValue();
		if (Input.fd1.getBoolValue() != Output.fd1Temp) {
			Input.fd1.setBoolValue(Output.fd1Temp);
		}
	},
	fd2Master: func(s) {
		if (s == 1) {
			if (!Output.fd1.getBoolValue() and !Output.ap1.getBoolValue() and !Output.ap2.getBoolValue()) {
				me.setLatMode(3); # HDG HOLD
					if (abs(Internal.vs.getValue()) > 300) {
					me.setVertMode(1); # V/S
				} else {
					me.setVertMode(0); # HOLD
				}
			}
			Output.fd2.setBoolValue(1);
		} else {
			Output.fd2.setBoolValue(0);
		}
		Output.fd2Temp = Output.fd2.getBoolValue();
		if (Input.fd2.getBoolValue() != Output.fd2Temp) {
			Input.fd2.setBoolValue(Output.fd2Temp);
		}
	},
	setLatMode: func(n) {
		Output.vertTemp = Output.vert.getValue();
		if (n == 0) { # HDG SEL
			Custom.Output.hdgCaptured = 0;
			me.updateLnavArm(0);
			me.updateLocArm(0);
			me.updateApprArm(0);
			Output.lat.setValue(0);
			Custom.showHdg.setBoolValue(1);
			me.updateLatText("HDG");
			if (Output.vertTemp == 2 or Output.vertTemp == 6) { # Also cancel G/S or FLARE if active
				me.setVertMode(1);
			} else {
				me.armTextCheck();
			}
		} else if (n == 1) { # LNAV
			if (Misc.ir0Align.getBoolValue() or Misc.ir1Align.getBoolValue() or Misc.ir2Align.getBoolValue()) { # Remember that IRS.nas kills NAV if the IR's fail
				me.checkLNAV(0);
			}
		} else if (n == 2) { # VOR/LOC
			me.updateLnavArm(0);
			me.armTextCheck();
			me.checkLOC(0, 0);
		} else if (n == 3) { # HDG HLD
			me.updateLnavArm(0);
			me.updateLocArm(0);
			me.updateApprArm(0);
			me.syncHdg();
			Output.lat.setValue(0);
			Custom.showHdg.setBoolValue(1);
			me.updateLatText("HDG");
			if (Output.vertTemp == 2 or Output.vertTemp == 6) { # Also cancel G/S or FLARE if active
				me.setVertMode(1);
			} else {
				me.armTextCheck();
			}
		} else if (n == 4) { # ALIGN
			me.updateLnavArm(0);
			me.updateLocArm(0);
			me.updateApprArm(0);
			Output.lat.setValue(4);
			Custom.showHdg.setBoolValue(0);
			me.updateLatText("ALGN");
			me.armTextCheck();
		} else if (n == 5) { # T/O
			me.updateLnavArm(0);
			me.updateLocArm(0);
			me.updateApprArm(0);
			Output.lat.setValue(5);
			Custom.showHdg.setBoolValue(1);
			me.updateLatText("T/O");
			me.armTextCheck();
		}
	},
	setLatArm: func(n) {
		if (n == 1) {
			if (FPLN.num.getValue() > 0 and FPLN.active.getBoolValue()) {
				me.updateLnavArm(1);
				me.armTextCheck();
			}
		} else if (n == 3) {
			me.syncHdg();
			me.updateLnavArm(0);
			me.armTextCheck();
		} 
	},
	setVertMode: func(n) {
		Input.altDiff = Input.alt.getValue() - Position.indicatedAltitudeFt.getValue();
		Output.latTemp = Output.lat.getValue();
		if (n == 0) { # ALT HLD
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			if (Output.latTemp == 2) {
				me.updateApprArm(0);
			}
			Output.vert.setValue(0);
			me.resetClimbRateLim();
			me.updateVertText("ALT HLD");
			me.syncAlt();
			me.armTextCheck();
		} else if (n == 1) { # V/S
			if (abs(Input.altDiff) >= 25) {
				Internal.flchActive = 0;
				Internal.altCaptureActive = 0;
				Custom.vsFpa.setBoolValue(0);
				if (Output.latTemp == 2) {
					me.updateApprArm(0);
				}
				Output.vert.setValue(1);
				me.updateVertText("V/S");
				me.syncVs();
				me.armTextCheck();
			} else {
				me.updateApprArm(0);
				me.armTextCheck();
			}
		} else if (n == 2) { # G/S
			me.checkLOC(0, 1);
			me.checkAPPR(0);
		} else if (n == 3) { # ALT CAP
			Internal.flchActive = 0;
			Output.vert.setValue(0);
			me.setClimbRateLim();
			Internal.altCaptureActive = 1;
			me.updateVertText("ALT CAP");
		} else if (n == 4) { # FLCH
			if (Output.latTemp == 2) {
				me.updateApprArm(0);
			}
			if (abs(Input.altDiff) >= 125) { # SPD CLB or SPD DES
				if (Input.alt.getValue() >= Position.indicatedAltitudeFt.getValue()) { # Usually set Thrust Mode Selector, but we do it now due to timer lag
					me.updateVertText("SPD CLB");
				} else {
					me.updateVertText("SPD DES");
				}
				Custom.retardLock = 0;
				Internal.altCaptureActive = 0;
				Output.vert.setValue(4);
				Internal.flchActive = 1;
			} else { # ALT CAP
				Internal.flchActive = 0;
				Internal.alt.setValue(Input.alt.getValue());
				Internal.altCaptureActive = 1;
				Output.vert.setValue(0);
				me.updateVertText("ALT CAP");
			}
			me.armTextCheck();
		} else if (n == 5) { # FPA
			if (abs(Input.altDiff) >= 25) {
				Internal.flchActive = 0;
				Internal.altCaptureActive = 0;
				Custom.vsFpa.setBoolValue(1);
				if (Output.latTemp == 2) {
					me.updateApprArm(0);
				}
				Output.vert.setValue(5);
				me.updateVertText("FPA");
				me.syncFpa();
				me.armTextCheck();
			} else {
				me.updateApprArm(0);
				me.armTextCheck();
			}
		} else if (n == 6) { # FLARE/ROLLOUT
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			Output.vert.setValue(6);
			me.updateVertText("G/S");
		} else if (n == 7) { # T/O CLB or G/A CLB, text is set by TOGA selector
			Custom.retardLock = 0;
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			if (Output.latTemp == 2) {
				me.updateApprArm(0);
			}
			Output.vert.setValue(7);
			me.armTextCheck();
		}
	},
	activateLNAV: func() {
		if (Output.lat.getValue() != 1) {
			me.updateLnavArm(0);
			me.updateLocArm(0);
			me.updateApprArm(0);
			Output.lat.setValue(1);
			me.updateLatText("LNAV");
			if (Output.vertTemp == 2 or Output.vertTemp == 6) { # Also cancel G/S or FLARE if active
				me.setVertMode(1);
			} else {
				me.armTextCheck();
			}
		}
		Custom.showHdg.setBoolValue(0);
	},
	activateLOC: func() {
		if (Output.lat.getValue() != 2) {
			me.updateLnavArm(0);
			me.updateLocArm(0);
			Output.lat.setValue(2);
			me.updateLatText("LOC");
			me.armTextCheck();
		}
		Custom.showHdg.setBoolValue(0);
	},
	activateGS: func() {
		if (Output.vert.getValue() != 2) {
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			me.updateApprArm(0);
			Output.vert.setValue(2);
			me.updateVertText("G/S");
			me.armTextCheck();
		}
	},
	checkLNAV: func(t) {
		if (FPLN.num.getValue() > 0 and FPLN.active.getBoolValue() and Position.gearAglFt.getValue() >= Internal.lnavEngageFt) {
			me.activateLNAV();
		} else if (FPLN.active.getBoolValue() and Output.lat.getValue() != 1 and t != 1) {
			me.updateLnavArm(1);
			me.armTextCheck();
		}
	},
	checkFLCH: func(a) {
		if (Position.gearAglFt.getValue() >= a and a != 0) {
			me.setVertMode(4);
		}
	},
	checkLOC: func(t, a) {
		Radio.radioSel = Input.useNav2Radio.getBoolValue();
		if (Radio.inRange[Radio.radioSel].getBoolValue()) { #  # Only evaulate the rest of the condition unless we are in range
			Radio.locDeflTemp = Radio.locDefl[Radio.radioSel].getValue();
			Radio.signalQualityTemp = Radio.signalQuality[Radio.radioSel].getValue();
			if (abs(Radio.locDeflTemp) <= 0.95 and Radio.locDeflTemp != 0 and Radio.signalQualityTemp >= 0.99) {
				me.activateLOC();
			} else if (t != 1) { # Do not do this if loop calls it
				if (Output.lat.getValue() != 2) {
					me.updateLnavArm(0);
					me.updateLocArm(1);
					if (a != 1) { # Don't call this if arming with G/S
						me.armTextCheck();
					}
				}
			}
		} else { # Prevent bad behavior due to FG not updating it when not in range
			Radio.signalQuality[Radio.radioSel].setValue(0);
		}
	},
	checkAPPR: func(t) {
		Radio.radioSel = Input.useNav2Radio.getBoolValue();
		if (Radio.inRange[Radio.radioSel].getBoolValue()) { #  # Only evaulate the rest of the condition unless we are in range
			Radio.gsDeflTemp = Radio.gsDefl[Radio.radioSel].getValue();
			if (abs(Radio.gsDeflTemp) <= 0.2 and Radio.gsDeflTemp != 0 and Output.lat.getValue()  == 2) { # Only capture if LOC is active
				me.activateGS();
			} else if (t != 1) { # Do not do this if loop calls it
				if (Output.vert.getValue() != 2) {
					me.updateApprArm(1);
				}
				me.armTextCheck();
			}
		} else { # Prevent bad behavior due to FG not updating it when not in range
			Radio.signalQuality[Radio.radioSel].setValue(0);
		}
	},
	checkRadioRevision: func(l, v) { # Revert mode if signal lost
		Radio.radioSel = Input.useNav2Radio.getBoolValue();
		Radio.inRangeTemp = Radio.inRange[Radio.radioSel].getBoolValue();
		if (!Radio.inRangeTemp) {
			if (l == 4 or v == 6) {
				me.ap1Master(0);
				me.ap2Master(0);
				me.setLatMode(3);
				me.setVertMode(1);
			} else {
				me.setLatMode(3); # Also cancels G/S if active
			}
		}
	},
	setClimbRateLim: func() {
		Internal.vsTemp = Internal.vs.getValue();
		if (Internal.alt.getValue() >= Position.indicatedAltitudeFt.getValue()) {
			Internal.maxVs.setValue(math.round(Internal.vsTemp));
			Internal.minVs.setValue(-500);
		} else {
			Internal.maxVs.setValue(500);
			Internal.minVs.setValue(math.round(Internal.vsTemp));
		}
	},
	resetClimbRateLim: func() {
		Internal.minVs.setValue(-500);
		Internal.maxVs.setValue(500);
	},
	takeoffGoAround: func() {
		Output.vertTemp = Output.vert.getValue();
		if (Output.vertTemp == 2 or Output.vertTemp == 6 and Velocities.indicatedAirspeedKt.getValue() >= 80) {
			me.setLatMode(3);
			me.setVertMode(7);
			me.updateVertText("G/A CLB");
			Internal.ktsMach.setBoolValue(0);
			me.syncKtsGa();
			if (Gear.wow1.getBoolValue() or Gear.wow2.getBoolValue()) {
				if (systems.BRAKES.Abs.armed.getBoolValue()) {
					systems.BRAKES.absSetOff(1); # Disarm autobrake
				}
				me.ap1Master(0);
				me.ap2Master(0);
			}
		}
	},
	armTextCheck: func() {
		if (Output.apprArm.getBoolValue()) {
			Text.arm.setValue("ILS");
		} else if (Output.locArm.getBoolValue()) {
			Text.arm.setValue("LOC");
		} else if (Output.lnavArm.getBoolValue()) {
			Text.arm.setValue("LNV");
		} else {
			Text.arm.setValue(" ");
		}
	},
	syncKts: func() {
		Internal.kts.setValue(math.clamp(math.round(Velocities.indicatedAirspeedKt.getValue()), 100, 365));
	},
	syncKtsGa: func() { # Same as syncKts, except doesn't go below V2
		Internal.kts.setValue(math.clamp(math.round(Velocities.indicatedAirspeedKt.getValue()), Custom.FMS.v2Speed.getValue(), 365));
	},
	syncKtsSel: func() {
		Input.kts.setValue(math.clamp(math.round(Velocities.indicatedAirspeedKt.getValue()), 100, 365));
	},
	syncMach: func() {
		Internal.mach.setValue(math.clamp(math.round(Velocities.indicatedMach.getValue(), 0.001), 0.5, 0.87));
	},
	syncMachSel: func() {
		Input.mach.setValue(math.clamp(math.round(Velocities.indicatedMach.getValue(), 0.001), 0.5, 0.87));
	},
	syncHdg: func() {
		Internal.hdgSet = math.round(Internal.hdgPredicted.getValue()); # Switches to track automatically
		Internal.hdg.setValue(Internal.hdgSet);
		Input.hdg.setValue(Internal.hdgSet);
	},
	syncAlt: func() {
		Input.alt.setValue(math.clamp(math.round(Internal.altPredicted.getValue(), 100), 0, 50000));
		Internal.alt.setValue(math.clamp(math.round(Internal.altPredicted.getValue(), 100), 0, 50000));
	},
	syncVs: func() {
		Input.vs.setValue(math.clamp(math.round(Internal.vs.getValue(), 100), -6000, 6000));
	},
	syncFpa: func() {
		Input.fpa.setValue(math.clamp(math.round(Internal.fpa.getValue(), 0.1), -9.9, 9.9));
	},
	# Custom Stuff Below
	spdPush: func() {
		Custom.retardLock = 0;
		if (!Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue() and (Text.vert.getValue() != "T/O CLB" or Position.gearAglFt.getValue() >= 400)) {
			Custom.Output.spdCaptured = 1;
			if (Input.ktsMach.getBoolValue()) {
				Internal.ktsMach.setBoolValue(1);
				Input.mach.setValue(math.clamp(math.round(Velocities.indicatedMach5Sec.getValue(), 0.001), 0.5, 0.87));
				Internal.mach.setValue(math.clamp(math.round(Velocities.indicatedMach5Sec.getValue(), 0.001), 0.5, 0.87));
			} else {
				Internal.ktsMach.setBoolValue(0);
				Input.kts.setValue(math.clamp(math.round(Velocities.indicatedAirspeedKt5Sec.getValue()), 100, 365));
				Internal.kts.setValue(math.clamp(math.round(Velocities.indicatedAirspeedKt5Sec.getValue()), 100, 365));
			}
		} else {
			if (Input.ktsMach.getBoolValue()) {
				me.syncMachSel();
			} else {
				me.syncKtsSel();
			}
		}
	},
	spdPull: func() {
		Custom.retardLock = 0;
		if (!Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue() and (Text.vert.getValue() != "T/O CLB" or Position.gearAglFt.getValue() >= 400)) {
			Input.ktsMachTemp = Input.ktsMach.getBoolValue();
			if (Internal.ktsMach.getBoolValue() != Input.ktsMachTemp) {
				Internal.ktsMach.setBoolValue(Input.ktsMachTemp);
			}
			if (Input.ktsMachTemp) {
				Internal.mach.setValue(Input.mach.getValue());
			} else {
				Internal.kts.setValue(Input.kts.getValue());
			}
			Custom.Output.spdCaptured = 0;
		}
	},
	AUTOFLIGHT: func() {
		Custom.Input.ovrd1Temp = Custom.Input.ovrd1.getBoolValue();
		Custom.Input.ovrd2Temp = Custom.Input.ovrd2.getBoolValue();
		Custom.Internal.activeFMSTemp = Custom.Internal.activeFMS.getValue();
		
		if (!Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue()) {
			if ((Output.ap1.getBoolValue() or Output.ap2.getBoolValue()) and Output.athr.getBoolValue()) { # Switch active FMS if there is nothing to engage
				if (Custom.Internal.activeFMSTemp == 1 and Custom.Output.ap2Avail.getBoolValue()) {
					me.updateActiveFMS(2);
				} else if (Custom.Internal.activeFMSTemp == 2 and Custom.Output.ap1Avail.getBoolValue()) {
					me.updateActiveFMS(1);
				}
			}
			Custom.Internal.activeFMSTemp = Custom.Internal.activeFMS.getValue(); # Update it after we just set it
			if (Custom.Internal.activeFMSTemp == 1) {
				if (Custom.Output.ap1Avail.getBoolValue()) { # AP1 on
					me.ap1Master(1);
					me.ap2Master(0);
				} else if (Custom.Output.ap2Avail.getBoolValue()) { # AP2 on because AP1 is not available
					me.ap2Master(1); # Will set activeFMS to 2
					me.ap1Master(0);
				}
			} else if (Custom.Internal.activeFMSTemp == 2) {
				if (Custom.Output.ap2Avail.getBoolValue()) { # AP2 on
					me.ap2Master(1);
					me.ap1Master(0);
				} else if (Custom.Output.ap1Avail.getBoolValue()) { # AP1 on because AP2 is not available
					me.ap1Master(1); # Will set activeFMS to 1
					me.ap2Master(0);
				}
			}
		}
		if (!Output.athr.getBoolValue() and Custom.Output.atsAvail.getBoolValue()) {
			me.athrMaster(1);
		}
	},
	# To avoid messy code in the ap1Master() and ap2Master()
	apEngageAllowed: func() {
		if (!Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue()) {
			if (Output.vert.getValue() == 6 or Text.vert.getValue() == "G/A CLB") {
				return 1;
			} else if (Position.gearAglFt.getValue() >= 400 and Output.lat.getValue() == 1) {
				return 1;
			} else if (Position.gearAglFt.getValue() >= 100 and Output.lat.getValue() != 1) {
				return 1;
			} else {
				return 2;
			}
		} else {
			return 0;
		}
	},
	# Silently kill AFS and ATS
	killAFSSilent: func() {
		Output.ap1.setBoolValue(0);
		Output.ap2.setBoolValue(0);
		Sound.apOff.setBoolValue(0);
		Sound.enableApOff = 0;
		# Now that AFS is off, we can safely update the input to 0 without the AP Master running
		Input.ap1.setBoolValue(0);
		Input.ap2.setBoolValue(0);
	},
	killATSSilent: func() {
		Output.athr.setBoolValue(0);
		Custom.atsFlash.setBoolValue(0);
		Custom.enableAtsOff = 0;
		# Now that ATS is off, we can safely update the input to 0 without the ATHR Master running
		Input.athr.setBoolValue(0);
	},
	# Custom functions that will also update the custom FMA
	updateActiveFMS: func(n) {
		Custom.Internal.activeFMS.setValue(n);
		updateFMA.roll();
	},
	updateLatText: func(t) {
		Text.lat.setValue(t);
		updateFMA.roll();
	},
	updateVertText: func(t) {
		Text.vert.setValue(t);
		updateFMA.pitch();
	},
	updateLnavArm: func(n) {
		Output.lnavArm.setBoolValue(n);
		updateFMA.arm();
	},
	updateLocArm: func(n) {
		Output.locArm.setBoolValue(n);
		updateFMA.arm();
	},
	updateApprArm: func(n) {
		Output.apprArm.setBoolValue(n);
		updateFMA.arm();
	},
};

setlistener("/it-autoflight/input/ap1", func {
	Input.ap1Temp = Input.ap1.getBoolValue();
	if (Input.ap1Temp != Output.ap1.getBoolValue()) {
		ITAF.ap1Master(Input.ap1Temp);
	}
});

setlistener("/it-autoflight/input/ap2", func {
	Input.ap2Temp = Input.ap2.getBoolValue();
	if (Input.ap2Temp != Output.ap2.getBoolValue()) {
		ITAF.ap2Master(Input.ap2Temp);
	}
});

setlistener("/it-autoflight/input/athr", func {
	Input.athrTemp = Input.athr.getBoolValue();
	if (Input.athrTemp != Output.athr.getBoolValue()) {
		ITAF.athrMaster(Input.athrTemp);
	}
});

setlistener("/it-autoflight/input/fd1", func {
	Input.fd1Temp = Input.fd1.getBoolValue();
	if (Input.fd1Temp != Output.fd1.getBoolValue()) {
		ITAF.fd1Master(Input.fd1Temp);
	}
});

setlistener("/it-autoflight/input/fd2", func {
	Input.fd2Temp = Input.fd2.getBoolValue();
	if (Input.fd2Temp != Output.fd2.getBoolValue()) {
		ITAF.fd2Master(Input.fd2Temp);
	}
});

setlistener("/it-autoflight/input/kts-mach", func {
	if (Input.ktsMach.getBoolValue()) {
		ITAF.syncMachSel();
	} else {
		ITAF.syncKtsSel();
	}
}, 0, 0);

setlistener("/it-autoflight/internal/kts-mach", func {
	if (Internal.ktsMach.getBoolValue()) {
		ITAF.syncMach();
	} else {
		ITAF.syncKts();
	}
}, 0, 0);

setlistener("/it-autoflight/input/toga", func {
	if (Input.toga.getBoolValue()) {
		ITAF.takeoffGoAround();
		Input.toga.setBoolValue(0);
	}
});

setlistener("/it-autoflight/input/lat", func {
	Input.latTemp = Input.lat.getValue();
	if (!Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue()) {
		ITAF.setLatMode(Input.latTemp);
	} else {
		ITAF.setLatArm(Input.latTemp);
	}
});

setlistener("/it-autoflight/input/vert", func {
	if (!Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue() and (Text.vert.getValue() != "T/O CLB" or Position.gearAglFt.getValue() >= 400)) {
		ITAF.setVertMode(Input.vert.getValue());
	}
});

# Flashing Logic
var killAPWarn = func {
	if (Sound.apOff.getBoolValue()) { # Second press only
		apKill.stop();
		Custom.apWarn.setBoolValue(0);
		Sound.apOff.setBoolValue(0);
	}
}

var killATSWarn = func {
	if (Custom.atsFlash.getBoolValue()) { # Second press only
		atsKill.stop();
		Custom.atsWarn.setBoolValue(0);
		Custom.atsFlash.setBoolValue(0);
	}
};

var apKill = maketimer(0.3, func {
	if (!Sound.apOff.getBoolValue()) {
		apKill.stop();
		Custom.apWarn.setBoolValue(0);
	} else if (!Custom.apWarn.getBoolValue()) {
		Custom.apWarn.setBoolValue(1);
	} else {
		Custom.apWarn.setBoolValue(0);
	}
});

var atsKill = maketimer(0.3, func {
	if (!Custom.atsFlash.getBoolValue()) {
		atsKill.stop();
		Custom.atsWarn.setBoolValue(0);
	} else if (!Custom.atsWarn.getBoolValue()) {
		Custom.atsWarn.setBoolValue(1);
	} else {
		Custom.atsWarn.setBoolValue(0);
	}
});

setlistener("/it-autoflight/input/trk", func {
	Input.trkTemp = Input.trk.getBoolValue();
	if (Input.trkTemp) {
		Internal.hdgCalc = Internal.hdg.getValue() + math.round(Internal.driftAngle.getValue());
		if (Internal.hdgCalc > 359) { # It's rounded, so this is ok. Otherwise do >= 359.5
			Internal.hdgCalc = Internal.hdgCalc - 360;
		} else if (Internal.hdgCalc < 0) { # It's rounded, so this is ok. Otherwise do < -0.5
			Internal.hdgCalc = Internal.hdgCalc + 360;
		}
		Internal.hdg.setValue(Internal.hdgCalc);
		Input.hdg.setValue(Internal.hdgCalc);
	} else {
		Internal.hdgCalc = Internal.hdg.getValue() - math.round(Internal.driftAngle.getValue());
		if (Internal.hdgCalc > 359) { # It's rounded, so this is ok. Otherwise do >= 359.5
			Internal.hdgCalc = Internal.hdgCalc - 360;
		} else if (Internal.hdgCalc < 0) { # It's rounded, so this is ok. Otherwise do < -0.5
			Internal.hdgCalc = Internal.hdgCalc + 360;
		}
		Internal.hdg.setValue(Internal.hdgCalc);
		Input.hdg.setValue(Internal.hdgCalc);
	}
	updateFMA.roll();
	pts.Instrumentation.Efis.hdgTrkSelected[0].setBoolValue(Input.trkTemp); # For Canvas Nav Display.
	pts.Instrumentation.Efis.hdgTrkSelected[1].setBoolValue(Input.trkTemp); # For Canvas Nav Display.
}, 0, 0);

# For Canvas Nav Display.
setlistener("/it-autoflight/input/hdg", func {
	setprop("/autopilot/settings/heading-bug-deg", getprop("/it-autoflight/input/hdg"));
});

setlistener("/it-autoflight/internal/alt", func {
	setprop("/autopilot/settings/target-altitude-ft", getprop("/it-autoflight/input/alt"));
});

var loopTimer = maketimer(0.1, ITAF, ITAF.loop);
var slowLoopTimer = maketimer(1, ITAF, ITAF.slowLoop);
