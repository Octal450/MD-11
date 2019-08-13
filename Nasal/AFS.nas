# MD-11 AFS
# Based off IT-AUTOFLIGHT System Controller V4.0.X
# Copyright (c) 2019 Joshua Davidson (Octal450)
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
	currentWP: props.globals.getNode("/autopilot/route-manager/current-wp", 1),
	currentWPTemp: 0,
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
	indicatedAirspeedKt5Sec: props.globals.getNode("/it-autoflight/internal/lookahead-5-sec-airspeed-kt", 1),
	indicatedMach: props.globals.getNode("/instrumentation/airspeed-indicator/indicated-mach", 1),
	indicatedMach5Sec: props.globals.getNode("/it-autoflight/internal/lookahead-5-sec-mach", 1),
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
	hdg: props.globals.initNode("/it-autoflight/input/hdg", 0, "INT"),
	hdgSet: 0,
	ias: props.globals.initNode("/it-autoflight/input/spd-kts", 250, "INT"),
	ktsMach: props.globals.initNode("/it-autoflight/input/kts-mach", 0, "BOOL"),
	lat: props.globals.initNode("/it-autoflight/input/lat", 5, "INT"),
	latTemp: 5,
	mach: props.globals.initNode("/it-autoflight/input/spd-mach", 0.5, "DOUBLE"),
	toga: props.globals.initNode("/it-autoflight/input/toga", 0, "BOOL"),
	trk: props.globals.initNode("/it-autoflight/input/trk", 0, "BOOL"),
	trueCourse: props.globals.initNode("/it-autoflight/input/true-course", 0, "BOOL"),
	vs: props.globals.initNode("/it-autoflight/input/vs", 0, "INT"),
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
	captVS: 0,
	flchActive: 0,
	fpa: props.globals.initNode("/it-autoflight/internal/fpa", 0, "DOUBLE"),
	hdg: props.globals.initNode("/it-autoflight/internal/heading-deg", 0, "DOUBLE"),
	hdgPredicted: props.globals.initNode("/it-autoflight/internal/heading-predicted", 0, "DOUBLE"),
	lnavAdvanceNm: props.globals.initNode("/it-autoflight/internal/lnav-advance-nm", 0, "DOUBLE"),
	minVS: props.globals.initNode("/it-autoflight/internal/min-vs", -500, "INT"),
	maxVS: props.globals.initNode("/it-autoflight/internal/max-vs", 500, "INT"),
	trk: props.globals.initNode("/it-autoflight/internal/track-deg", 0, "DOUBLE"),
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
	reducAglFt: props.globals.initNode("/it-autoflight/settings/reduc-agl-ft", 1500, "INT"), # Will be changable from FMS
	useNAV2Radio: props.globals.initNode("/it-autoflight/settings/use-nav2-radio", 0, "BOOL"),
};

var Sound = {
	apOff: props.globals.initNode("/it-autoflight/sound/apoffsound", 0, "BOOL"),
	enableApOff: 0,
};

var Text = {
	arm: props.globals.initNode("/it-autoflight/mode/arm", " ", "STRING"),
	lat: props.globals.initNode("/it-autoflight/mode/lat", "T/O", "STRING"),
	thr: props.globals.initNode("/it-autoflight/mode/thr", "PITCH", "STRING"),
	vert: props.globals.initNode("/it-autoflight/mode/vert", "T/O CLB", "STRING"),
	vertTemp: 0,
};

# MD-11 Custom
var Custom = {
	apWarn: props.globals.initNode("/it-autoflight/custom/apwarn", 0, "BOOL"),
	atsFlash: props.globals.initNode("/it-autoflight/custom/atsflash", 0, "BOOL"),
	atsWarn: props.globals.initNode("/it-autoflight/custom/atswarn", 0, "BOOL"),
	canAutoland: 0,
	enableAtsOff: 0,
	fpaAbs: props.globals.initNode("/it-autoflight/input/fpa-abs", 0, "DOUBLE"),
	hdgSel: props.globals.initNode("/it-autoflight/custom/hdg-sel", 0, "INT"),
	ktsMach: props.globals.initNode("/it-autoflight/custom/kts-mach", 0, "BOOL"),
	ktsMachTemp: 0,
	landCondition: 0,
	landModeActive: 0,
	iasSel: props.globals.initNode("/it-autoflight/custom/kts-sel", 0, "INT"),
	machSel: props.globals.initNode("/it-autoflight/custom/mach-sel", 0, "DOUBLE"),
	retardLock: 0,
	selfCheckStatus: 0,
	selfCheckTime: 0,
	showHdg: props.globals.initNode("/it-autoflight/custom/show-hdg", 1, "BOOL"),
	targetHDGError: 0,
	targetIAS: 0,
	targetIASError: 0,
	vsAbs: props.globals.initNode("/it-autoflight/input/vs-abs", 0, "INT"),
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
			Custom.ktsMach.setBoolValue(0);
			Custom.iasSel.setValue(250);
			Custom.machSel.setValue(0.5);
			Custom.hdgSel.setValue(0);
			Custom.vsFpa.setBoolValue(0);
		}
		Input.ktsMach.setBoolValue(0);
		Input.ap1.setBoolValue(0);
		Input.ap2.setBoolValue(0);
		Input.athr.setBoolValue(0);
		Input.fd1.setBoolValue(1);
		Input.fd2.setBoolValue(1);
		if (t != 1) {
			Input.hdg.setValue(0);
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
		Setting.useNAV2Radio.setBoolValue(0);
		Internal.minVS.setValue(-500);
		Internal.maxVS.setValue(500);
		Internal.bankLimit.setValue(25);
		Internal.bankLimitAuto = 25;
		if (t != 1) {
			Internal.alt.setValue(10000);
		}
		Internal.altCaptureActive = 0;
		Input.ias.setValue(Custom.FMS.v2Speed.getValue());
		Input.mach.setValue(0.5);
		Text.thr.setValue("PITCH");
		Text.arm.setValue(" ");
		Text.lat.setValue("T/O");
		Text.vert.setValue("T/O CLB");
		Custom.retardLock = 0;
		Custom.Text.land.setValue("OFF");
		Custom.Output.spdCaptured = 1;
		Custom.Output.hdgCaptured = 1;
		Custom.Internal.activeFMS.setValue(1);
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
		loopTimer.start();
		slowLoopTimer.start();
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
					Text.vert.setValue("FLARE");
				}
				if (Gear.wow1Temp and Gear.wow2Temp) {
					Text.lat.setValue("RLOU");
					Text.vert.setValue("ROLLOUT");
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
		
		if (Output.vertTemp != 0 and Output.vertTemp != 2 and Output.vertTemp != 6 and Text.vertTemp != "G/A CLB") {
			Internal.captVS = math.clamp(math.round(abs(Internal.vs.getValue()) / 5, 100), 50, 2500); # Capture limits
			if (abs(Internal.altDiff) <= Internal.captVS and !Gear.wow1Temp and !Gear.wow2Temp) {
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
				Text.vert.setValue("ALT HLD");
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
			if (Engines.reverserNorm[0].getValue() >= 0.01 or Engines.reverserNorm[1].getValue() >= 0.01 or Engines.reverserNorm[2].getValue() >= 0.01) { # Disconnect A/THR on any reverser deployed
				me.killATSSilent();
			}
		} else if (Custom.retardLock != 1) { # Stays in RETARD unless we tell it to go to THRUST or PITCH
			if (Output.vertTemp == 4) {
				if (Internal.altTemp >= Position.indicatedAltitudeFtTemp) {
					Output.thrMode.setValue(2);
					Text.thr.setValue("PITCH");
					if (Internal.flchActive) { # Set before mode change to prevent it from overwriting by mistake
						Text.vert.setValue("SPD CLB");
					}
				} else {
					Output.thrMode.setValue(1);
					Text.thr.setValue("PITCH");
					if (Internal.flchActive) { # Set before mode change to prevent it from overwriting by mistake
						Text.vert.setValue("SPD DES");
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
				Custom.ktsMachTemp = Custom.ktsMach.getBoolValue();
				if (Input.ktsMach.getBoolValue() != Custom.ktsMachTemp) {
					Input.ktsMach.setBoolValue(Custom.ktsMachTemp);
				}
				if (Custom.ktsMachTemp) {
					Input.mach.setValue(Custom.machSel.getValue());
					Custom.targetIAS = Input.mach.getValue() * (Velocities.indicatedAirspeedKt.getValue() / Velocities.indicatedMach.getValue()); # Convert to IAS
				} else {
					Input.ias.setValue(Custom.iasSel.getValue());
					Custom.targetIAS = Input.ias.getValue();
				}
				Custom.targetIASError = Custom.targetIAS - Velocities.indicatedAirspeedKt5Sec.getValue();
				if (abs(Custom.targetIASError) <= 2.5) {
					Custom.Output.spdCaptured = 1;
				}
			}
		} else if (!Custom.Output.spdCaptured) {
			Custom.Output.spdCaptured = 1;
		}
		
		# Heading Sync
		if (!Custom.showHdg.getBoolValue()) {
			Misc.pfdHeadingScaleTemp = Misc.pfdHeadingScale.getValue();
			Input.hdg.setValue(Misc.pfdHeadingScaleTemp);
			Custom.hdgSel.setValue(Misc.pfdHeadingScaleTemp);
		}
		
		# Heading Capture
		if (Output.latTemp == 0) {
			if (!Custom.Output.hdgCaptured) {
				Input.hdg.setValue(Custom.hdgSel.getValue());
				Custom.targetHDGError = Input.hdg.getValue() - Internal.hdgPredicted.getValue();
				if (abs(Custom.targetHDGError) <= 2.5) {
					Custom.Output.hdgCaptured = 1;
				}
			}
		} else if (!Custom.Output.hdgCaptured) {
			Custom.Output.hdgCaptured = 1;
		}
		
		# Misc
		if (Output.ap1Temp == 1 or Output.ap2Temp == 1) { # Trip AP off
			if (abs(Controls.aileron.getValue()) >= 0.2 or abs(Controls.elevator.getValue()) >= 0.2) {
				me.ap1Master(0);
				me.ap2Master(0);
			}
			if (!Misc.ir0Align.getBoolValue() or !Misc.ir1Align.getBoolValue() or !Misc.ir2Align.getBoolValue()) {
				me.ap1Master(0);
				me.ap2Master(0);
			}
		}
		if (Output.athrTemp and Misc.state1.getValue() != 3 and Misc.state2.getValue() != 3 and Misc.state3.getValue() != 3) { # Trip A/THR off
			me.athrMaster(0);
		}
		
		# Dual Land Logic
		if (Output.vertTemp == 2 or Output.vertTemp == 6) {
			Radio.radioSel = Setting.useNAV2Radio.getBoolValue();
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
			if ((Output.ap1Temp or Output.ap2Temp) and !Custom.Input.ovrd1.getBoolValue() and !Custom.Input.ovrd2.getBoolValue()) {
				Custom.landCondition = "DUAL";
			} else if (Output.ap1Temp or Output.ap2Temp) {
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
	},
	slowLoop: func() {
		Input.bankLimitSWTemp = Input.bankLimitSW.getValue();
		Velocities.trueAirspeedKtTemp = Velocities.trueAirspeedKt.getValue();
		FPLN.activeTemp = FPLN.active.getValue();
		FPLN.currentWPTemp = FPLN.currentWP.getValue();
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
			if ((FPLN.currentWPTemp + 1) < FPLN.numTemp) {
				Velocities.groundspeedMps = Velocities.groundspeedKt.getValue() * 0.5144444444444;
				FPLN.wpFlyFrom = FPLN.currentWPTemp;
				if (FPLN.wpFlyFrom < 0) {
					FPLN.wpFlyFrom = 0;
				}
				FPLN.currentCourse = getprop("/autopilot/route-manager/route/wp[" ~ FPLN.wpFlyFrom ~ "]/leg-bearing-true-deg"); # Best left at getprop
				FPLN.wpFlyTo = FPLN.currentWPTemp + 1;
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
					FPLN.currentWP.setValue(FPLN.currentWPTemp + 1);
				}
			}
		}
	},
	ap1Master: func(s) {
		if (s == 1) {
			if (Output.vert.getValue() != 6 and !Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue() and !Custom.Input.ovrd1.getBoolValue() and (Misc.ir0Align.getBoolValue() or Misc.ir1Align.getBoolValue() or Misc.ir2Align.getBoolValue())) {
				Controls.rudder.setValue(0);
				Output.ap1.setBoolValue(1);
				Custom.Internal.activeFMS.setValue(1);
				apKill.stop();
				Custom.apWarn.setBoolValue(0);
				Sound.apOff.setBoolValue(0);
				Sound.enableApOff = 1;
			}
		} else {
			Output.ap1.setBoolValue(0);
			if (!Custom.Input.ovrd2.getBoolValue() and !Output.ap2.getBoolValue()) {
				Custom.Internal.activeFMS.setValue(2);
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
			if (Output.vert.getValue() != 6 and !Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue() and !Custom.Input.ovrd2.getBoolValue() and (Misc.ir0Align.getBoolValue() or Misc.ir1Align.getBoolValue() or Misc.ir2Align.getBoolValue())) {
				Controls.rudder.setValue(0);
				Output.ap2.setBoolValue(1);
				Custom.Internal.activeFMS.setValue(2);
				apKill.stop();
				Custom.apWarn.setBoolValue(0);
				Sound.apOff.setBoolValue(0);
				Sound.enableApOff = 1;
			}
		} else {
			Output.ap2.setBoolValue(0);
			if (!Custom.Input.ovrd1.getBoolValue() and !Output.ap1.getBoolValue()) {
				Custom.Internal.activeFMS.setValue(1);
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
			if (Misc.state1.getValue() == 3 or Misc.state2.getValue() == 3 or Misc.state3.getValue() == 3 and Engines.reverserNorm[0].getValue() < 0.01 and Engines.reverserNorm[1].getValue() < 0.01 and Engines.reverserNorm[2].getValue() < 0.01) {
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
			Output.lnavArm.setBoolValue(0);
			Output.locArm.setBoolValue(0);
			Output.apprArm.setBoolValue(0);
			Output.lat.setValue(0);
			Custom.showHdg.setBoolValue(1);
			Text.lat.setValue("HDG");
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
			Output.lnavArm.setBoolValue(0);
			me.armTextCheck();
			me.checkLOC(0, 0);
		} else if (n == 3) { # HDG HLD
			Output.lnavArm.setBoolValue(0);
			Output.locArm.setBoolValue(0);
			Output.apprArm.setBoolValue(0);
			me.syncHDG();
			Output.lat.setValue(0);
			Custom.showHdg.setBoolValue(1);
			Text.lat.setValue("HDG");
			if (Output.vertTemp == 2 or Output.vertTemp == 6) { # Also cancel G/S or FLARE if active
				me.setVertMode(1);
			} else {
				me.armTextCheck();
			}
		} else if (n == 4) { # ALIGN
			Output.lnavArm.setBoolValue(0);
			Output.locArm.setBoolValue(0);
			Output.apprArm.setBoolValue(0);
			Output.lat.setValue(4);
			Custom.showHdg.setBoolValue(0);
			Text.lat.setValue("ALGN");
			me.armTextCheck();
		} else if (n == 5) { # T/O
			Output.lnavArm.setBoolValue(0);
			Output.locArm.setBoolValue(0);
			Output.apprArm.setBoolValue(0);
			Output.lat.setValue(5);
			Custom.showHdg.setBoolValue(1);
			Text.lat.setValue("T/O");
			me.armTextCheck();
		}
	},
	setLatArm: func(n) {
		if (n == 1) {
			if (FPLN.num.getValue() > 0 and FPLN.active.getBoolValue()) {
				Output.lnavArm.setBoolValue(1);
				me.armTextCheck();
			}
		} else if (n == 3) {
			me.syncHDG();
			Output.lnavArm.setBoolValue(0);
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
				Output.apprArm.setBoolValue(0);
			}
			Output.vert.setValue(0);
			me.resetClimbRateLim();
			Text.vert.setValue("ALT HLD");
			me.syncALT();
			me.armTextCheck();
		} else if (n == 1) { # V/S
			if (abs(Input.altDiff) >= 25) {
				Internal.flchActive = 0;
				Internal.altCaptureActive = 0;
				Custom.vsFpa.setBoolValue(0);
				if (Output.latTemp == 2) {
					Output.apprArm.setBoolValue(0);
				}
				Output.vert.setValue(1);
				Text.vert.setValue("V/S");
				me.syncVS();
				me.armTextCheck();
			} else {
				Output.apprArm.setBoolValue(0);
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
			Text.vert.setValue("ALT CAP");
		} else if (n == 4) { # FLCH
			if (Output.latTemp == 2) {
				Output.apprArm.setBoolValue(0);
			}
			if (abs(Input.altDiff) >= 125) { # SPD CLB or SPD DES
				if (Input.alt.getValue() >= Position.indicatedAltitudeFt.getValue()) { # Usually set Thrust Mode Selector, but we do it now due to timer lag
					Text.vert.setValue("SPD CLB");
				} else {
					Text.vert.setValue("SPD DES");
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
				Text.vert.setValue("ALT CAP");
			}
			me.armTextCheck();
		} else if (n == 5) { # FPA
			if (abs(Input.altDiff) >= 25) {
				Internal.flchActive = 0;
				Internal.altCaptureActive = 0;
				Custom.vsFpa.setBoolValue(1);
				if (Output.latTemp == 2) {
					Output.apprArm.setBoolValue(0);
				}
				Output.vert.setValue(5);
				Text.vert.setValue("FPA");
				me.syncFPA();
				me.armTextCheck();
			} else {
				Output.apprArm.setBoolValue(0);
				me.armTextCheck();
			}
		} else if (n == 6) { # FLARE/ROLLOUT
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			Output.vert.setValue(6);
			Text.vert.setValue("G/S");
		} else if (n == 7) { # T/O CLB or G/A CLB, text is set by TOGA selector
			Custom.retardLock = 0;
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			if (Output.latTemp == 2) {
				Output.apprArm.setBoolValue(0);
			}
			Output.vert.setValue(7);
			me.armTextCheck();
		}
	},
	activateLNAV: func() {
		if (Output.lat.getValue() != 1) {
			Output.lnavArm.setBoolValue(0);
			Output.locArm.setBoolValue(0);
			Output.apprArm.setBoolValue(0);
			Output.lat.setValue(1);
			Text.lat.setValue("LNAV");
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
			Output.lnavArm.setBoolValue(0);
			Output.locArm.setBoolValue(0);
			Output.lat.setValue(2);
			Text.lat.setValue("LOC");
			me.armTextCheck();
		}
		Custom.showHdg.setBoolValue(0);
	},
	activateGS: func() {
		if (Output.vert.getValue() != 2) {
			Internal.flchActive = 0;
			Internal.altCaptureActive = 0;
			Output.apprArm.setBoolValue(0);
			Output.vert.setValue(2);
			Text.vert.setValue("G/S");
			me.armTextCheck();
		}
	},
	checkLNAV: func(t) {
		if (FPLN.num.getValue() > 0 and FPLN.active.getBoolValue() and Position.gearAglFt.getValue() >= 150) {
			me.activateLNAV();
		} else if (Output.lat.getValue() != 1 and t != 1) {
			Output.lnavArm.setBoolValue(1);
			me.armTextCheck();
		}
	},
	checkFLCH: func(a) {
		if (Position.gearAglFt.getValue() >= a and a != 0) {
			me.setVertMode(4);
		}
	},
	checkLOC: func(t, a) {
		Radio.radioSel = Setting.useNAV2Radio.getBoolValue();
		if (Radio.inRange[Radio.radioSel].getBoolValue()) { #  # Only evaulate the rest of the condition unless we are in range
			Radio.locDeflTemp = Radio.locDefl[Radio.radioSel].getValue();
			Radio.signalQualityTemp = Radio.signalQuality[Radio.radioSel].getValue();
			if (abs(Radio.locDeflTemp) <= 0.95 and Radio.locDeflTemp != 0 and Radio.signalQualityTemp >= 0.99) {
				me.activateLOC();
			} else if (t != 1) { # Do not do this if loop calls it
				if (Output.lat.getValue() != 2) {
					Output.lnavArm.setBoolValue(0);
					Output.locArm.setBoolValue(1);
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
		Radio.radioSel = Setting.useNAV2Radio.getBoolValue();
		if (Radio.inRange[Radio.radioSel].getBoolValue()) { #  # Only evaulate the rest of the condition unless we are in range
			Radio.gsDeflTemp = Radio.gsDefl[Radio.radioSel].getValue();
			if (abs(Radio.gsDeflTemp) <= 0.2 and Radio.gsDeflTemp != 0 and Output.lat.getValue()  == 2) { # Only capture if LOC is active
				me.activateGS();
			} else if (t != 1) { # Do not do this if loop calls it
				if (Output.vert.getValue() != 2) {
					Output.apprArm.setBoolValue(1);
				}
				me.armTextCheck();
			}
		} else { # Prevent bad behavior due to FG not updating it when not in range
			Radio.signalQuality[Radio.radioSel].setValue(0);
		}
	},
	checkRadioRevision: func(l, v) { # Revert mode if signal lost
		Radio.radioSel = Setting.useNAV2Radio.getBoolValue();
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
			Internal.maxVS.setValue(math.round(Internal.vsTemp));
			Internal.minVS.setValue(-500);
		} else {
			Internal.maxVS.setValue(500);
			Internal.minVS.setValue(math.round(Internal.vsTemp));
		}
	},
	resetClimbRateLim: func() {
		Internal.minVS.setValue(-500);
		Internal.maxVS.setValue(500);
	},
	takeoffGoAround: func() {
		Output.vertTemp = Output.vert.getValue();
		if (Output.vertTemp == 2 or Output.vertTemp == 6 and Velocities.indicatedAirspeedKt.getValue() >= 80) {
			if (Gear.wow1.getBoolValue() or Gear.wow2.getBoolValue()) {
				me.ap1Master(0);
				me.ap2Master(0);
			}
			me.setLatMode(3);
			me.setVertMode(7);
			Text.vert.setValue("G/A CLB");
			Input.ktsMach.setBoolValue(0);
			me.syncIASGA();
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
	syncIAS: func() {
		Input.ias.setValue(math.clamp(math.round(Velocities.indicatedAirspeedKt.getValue()), 100, 365));
	},
	syncIASGA: func() { # Same as syncIAS, except doesn't go below V2
		Input.ias.setValue(math.clamp(math.round(Velocities.indicatedAirspeedKt.getValue()), Custom.FMS.v2Speed.getValue(), 365));
	},
	syncCIAS: func() {
		Custom.iasSel.setValue(math.clamp(math.round(Velocities.indicatedAirspeedKt.getValue()), 100, 365));
	},
	syncMach: func() {
		Input.mach.setValue(math.clamp(math.round(Velocities.indicatedMach.getValue(), 0.001), 0.5, 0.87));
	},
	syncCMach: func() {
		Custom.machSel.setValue(math.clamp(math.round(Velocities.indicatedMach.getValue(), 0.001), 0.5, 0.87));
	},
	syncHDG: func() {
		Input.hdgSet = math.round(Internal.hdgPredicted.getValue()); # Switches to track automatically
		if (Input.hdgSet == 360) {
			Input.hdgSet = 0;
		}
		Input.hdg.setValue(Input.hdgSet);
		Custom.hdgSel.setValue(Input.hdgSet);
	},
	syncALT: func() {
		Input.alt.setValue(math.clamp(math.round(Internal.altPredicted.getValue(), 100), 0, 50000));
		Internal.alt.setValue(math.clamp(math.round(Internal.altPredicted.getValue(), 100), 0, 50000));
	},
	syncVS: func() {
		Input.vs.setValue(math.clamp(math.round(Internal.vs.getValue(), 100), -6000, 6000));
	},
	syncFPA: func() {
		Input.fpa.setValue(math.clamp(math.round(Internal.fpa.getValue(), 0.1), -9.9, 9.9));
	},
	# Custom Stuff Below
	spdPush: func() {
		Custom.retardLock = 0;
		if (!Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue() and Text.vert.getValue() != "T/O CLB") {
			Custom.Output.spdCaptured = 1;
			if (Custom.ktsMach.getBoolValue()) {
				Input.ktsMach.setBoolValue(1);
				Custom.machSel.setValue(math.clamp(math.round(Velocities.indicatedMach5Sec.getValue(), 0.001), 0.5, 0.87));
				Input.mach.setValue(math.clamp(math.round(Velocities.indicatedMach5Sec.getValue(), 0.001), 0.5, 0.87));
			} else {
				Input.ktsMach.setBoolValue(0);
				Custom.iasSel.setValue(math.clamp(math.round(Velocities.indicatedAirspeedKt5Sec.getValue()), 100, 365));
				Input.ias.setValue(math.clamp(math.round(Velocities.indicatedAirspeedKt5Sec.getValue()), 100, 365));
			}
		} else {
			if (Custom.ktsMach.getBoolValue()) {
				me.syncCMach();
			} else {
				me.syncCIAS();
			}
		}
	},
	spdPull: func() {
		Custom.retardLock = 0;
		if (!Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue() and Text.vert.getValue() != "T/O CLB") {
			Custom.ktsMachTemp = Custom.ktsMach.getBoolValue();
			if (Input.ktsMach.getBoolValue() != Custom.ktsMachTemp) {
				Input.ktsMach.setBoolValue(Custom.ktsMachTemp);
			}
			if (Custom.ktsMachTemp) {
				Input.mach.setValue(Custom.machSel.getValue());
			} else {
				Input.ias.setValue(Custom.iasSel.getValue());
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
				if (Custom.Internal.activeFMSTemp == 1 and !Custom.Input.ovrd2Temp) {
					Custom.Internal.activeFMS.setValue(2);
				} else if (Custom.Internal.activeFMSTemp == 2 and !Custom.Input.ovrd1Temp) {
					Custom.Internal.activeFMS.setValue(1);
				}
			}
			Custom.Internal.activeFMSTemp = Custom.Internal.activeFMS.getValue(); # Update it after we just set it
			# Note: AP will not engage in vert mode 6
			if (Custom.Internal.activeFMSTemp == 1 and !Custom.Input.ovrd1Temp) { # AP1 on
				me.ap1Master(1);
				me.ap2Master(0);
			} else if (Custom.Internal.activeFMSTemp == 2 and !Custom.Input.ovrd2Temp) { # AP2 on
				me.ap2Master(1);
				me.ap1Master(0);
			}
		}
		if (!Output.athr.getBoolValue() and (!Custom.Input.ovrd1Temp or !Custom.Input.ovrd2Temp)) {
			me.athrMaster(1);
		}
	},
	updateOVRD: func() {
		Output.ap1Temp = Output.ap1.getBoolValue();
		Output.ap2Temp = Output.ap2.getBoolValue();
		Custom.Input.ovrd1Temp = Custom.Input.ovrd1.getBoolValue();
		Custom.Input.ovrd2Temp = Custom.Input.ovrd2.getBoolValue();
		
		if (Custom.Input.ovrd1Temp and Custom.Input.ovrd2Temp) {
			if (Output.ap1Temp) {
				me.ap1Master(0);
			}
			if (Output.ap2Temp) {
				me.ap2Master(0);
			}
			if (Output.athr.getBoolValue()) {
				me.athrMaster(0);
			}
		} else if (Custom.Input.ovrd1Temp and !Custom.Input.ovrd2Temp) {
			if (Output.ap1Temp) {
				me.ap1Master(0);
			}
			Custom.Internal.activeFMS.setValue(2);
		} else if (Custom.Input.ovrd2Temp and !Custom.Input.ovrd1Temp) {
			if (Output.ap2Temp) {
				me.ap2Master(0);
			}
			Custom.Internal.activeFMS.setValue(1);
		}
	},
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

setlistener("/it-autoflight/custom/kts-mach", func {
	if (Custom.ktsMach.getBoolValue()) {
		ITAF.syncCMach();
	} else {
		ITAF.syncCIAS();
	}
}, 0, 0);

setlistener("/it-autoflight/input/kts-mach", func {
	if (Input.ktsMach.getBoolValue()) {
		ITAF.syncMach();
	} else {
		ITAF.syncIAS();
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
	if (!Gear.wow1.getBoolValue() and !Gear.wow2.getBoolValue()) {
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

setlistener("/it-autoflight/input/ovrd1", func {
	ITAF.updateOVRD();
});

setlistener("/it-autoflight/input/ovrd2", func {
	ITAF.updateOVRD();
});

setlistener("/it-autoflight/input/vs", func {
	Custom.vsAbs.setValue(abs(Input.vs.getValue()));
});

setlistener("/it-autoflight/input/fpa", func {
	Custom.fpaAbs.setValue(abs(Input.fpa.getValue()));
});

# For Canvas Nav Display.
setlistener("/it-autoflight/custom/hdg-sel", func {
	setprop("/autopilot/settings/heading-bug-deg", getprop("/it-autoflight/custom/hdg-sel"));
});

setlistener("/it-autoflight/internal/alt", func {
	setprop("/autopilot/settings/target-altitude-ft", getprop("/it-autoflight/input/alt"));
});

var loopTimer = maketimer(0.1, ITAF, ITAF.loop);
var slowLoopTimer = maketimer(1, ITAF, ITAF.slowLoop);
