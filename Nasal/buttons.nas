# McDonnell Douglas MD-11 Buttons and Switches
# Copyright (c) 2019 Joshua Davidson (Octal450)

# Resets buttons to the default values
var variousReset = func {
	setprop("/controls/flight/dial-a-flap", 15);
	setprop("/controls/lighting/beacon", 0);
	setprop("/controls/lighting/landing-light-l", 0.0);
	setprop("/controls/lighting/landing-light-n", 0.0);
	setprop("/controls/lighting/landing-light-r", 0.0);
	setprop("/controls/lighting/logo-lights", 0);
	setprop("/controls/lighting/nav-lights", 0);
	setprop("/controls/lighting/strobe", 0);
	setprop("/controls/switches/adg-handle", 0);
	setprop("/controls/switches/minimums", 200);
}

var ktsMachC = props.globals.getNode("/it-autoflight/custom/kts-mach", 1);
var iasSet = props.globals.getNode("/it-autoflight/input/spd-kts", 1);
var iasSetC = props.globals.getNode("/it-autoflight/custom/kts-sel", 1);
var machSet = props.globals.getNode("/it-autoflight/input/spd-mach", 1);
var machSetC = props.globals.getNode("/it-autoflight/custom/mach-sel", 1);
var hdgSet = props.globals.getNode("/it-autoflight/input/hdg", 1);
var hdgSetC = props.globals.getNode("/it-autoflight/custom/hdg-sel", 1);
var showHDG = props.globals.getNode("/it-autoflight/custom/show-hdg", 1);
var altSet = props.globals.getNode("/it-autoflight/input/alt", 1);
var vsSet = props.globals.getNode("/it-autoflight/input/vs", 1);
var fpaSet = props.globals.getNode("/it-autoflight/input/fpa", 1);
var iasNow = props.globals.getNode("/instrumentation/airspeed-indicator/indicated-speed-kt", 1);
var machNow = props.globals.getNode("/instrumentation/airspeed-indicator/indicated-mach", 1);
var hdgTrkSW = props.globals.getNode("/it-autoflight/input/trk", 1);
var vsFpaSW = props.globals.getNode("/it-autoflight/custom/vs-fpa", 1);
var latMode = props.globals.getNode("/it-autoflight/output/lat", 1);
var vertMode = props.globals.getNode("/it-autoflight/output/vert", 1);
var locArm = props.globals.getNode("/it-autoflight/output/loc-armed", 1);
var apprArm = props.globals.getNode("/it-autoflight/output/appr-armed", 1);
var fcpPower = props.globals.getNode("/systems/electrical/outputs/fcp-power", 1);
var fd1 = props.globals.getNode("/it-autoflight/output/fd1", 1);
var fd2 = props.globals.getNode("/it-autoflight/output/fd2", 1);
var ap1 = props.globals.getNode("/it-autoflight/output/ap1", 1);
var ap2 = props.globals.getNode("/it-autoflight/output/ap2", 1);
var athr = props.globals.getNode("/it-autoflight/output/athr", 1);

var APPanel = {
	AUTOFLIGHT: func() {
		if (fcpPower.getBoolValue()) {
			afs.ITAF.AUTOFLIGHT();
		}
	},
	FD1: func() {
		if (fcpPower.getBoolValue()) {
			afs.ITAF.fd1Master(!fd1.getBoolValue());
		}
	},
	FD2: func() {
		if (fcpPower.getBoolValue()) {
			afs.ITAF.fd2Master(!fd2.getBoolValue());
		}
	},
	APDisc: func() {
		if (fcpPower.getBoolValue()) {
			afs.killAPWarn();
			if (ap1.getBoolValue()) {
				afs.ITAF.ap1Master(0);
			}
			if (ap2.getBoolValue()) {
				afs.ITAF.ap2Master(0);
			}
		}
	},
	ATDisc: func() {
		if (fcpPower.getBoolValue()) {
			afs.killATSWarn();
			if (athr.getBoolValue()) {
				afs.ITAF.athrMaster(0);
			}
		}
	},
	IASMach: func() {
		if (fcpPower.getBoolValue()) {
			if (ktsMachC.getBoolValue()) {
				ktsMachC.setBoolValue(0);
			} else {
				ktsMachC.setBoolValue(1);
			}
		}
	},
	SPDPush: func() {
		if (fcpPower.getBoolValue()) {
			afs.ITAF.spdPush();
		}
	},
	SPDPull: func() {
		if (fcpPower.getBoolValue()) {
			afs.ITAF.spdPull();
		}
	},
	SPDAdjust: func(d) {
		if (fcpPower.getBoolValue()) {
			if (ktsMachC.getBoolValue()) {
				var machTemp = machSetC.getValue();
				if (d == 1) {
					machTemp = math.round(machTemp + 0.001, 0.001); # Kill floating point error
				} else if (d == -1) {
					machTemp = math.round(machTemp - 0.001, 0.001); # Kill floating point error
				} else if (d == 10) {
					machTemp = math.round(machTemp + 0.01, 0.01); # Kill floating point error
				} else if (d == -10) {
					machTemp = math.round(machTemp - 0.01, 0.01); # Kill floating point error
				}
				if (machTemp < 0.50) {
					machSetC.setValue(0.50);
				} else if (machTemp > 0.87) {
					machSetC.setValue(0.87);
				} else {
					machSetC.setValue(machTemp);
				}
			} else {
				var iasTemp = iasSetC.getValue();
				if (d == 1) {
					iasTemp = iasTemp + 1;
				} else if (d == -1) {
					iasTemp = iasTemp - 1;
				} else if (d == 10) {
					iasTemp = iasTemp + 10;
				} else if (d == -10) {
					iasTemp = iasTemp - 10;
				}
				if (iasTemp < 100) {
					iasSetC.setValue(100);
				} else if (iasTemp > 365) {
					iasSetC.setValue(365);
				} else {
					iasSetC.setValue(iasTemp);
				}
			}
		}
	},
	HDGPush: func() {
		if (fcpPower.getBoolValue()) {
			setprop("/it-autoflight/input/lat", 3);
		}
	},
	HDGPull: func() {
		if (fcpPower.getBoolValue()) {
			hdgSet.setValue(hdgSetC.getValue());
			setprop("/it-autoflight/input/lat", 0);
		}
	},
	HDGAdjust: func(d) {
		if (fcpPower.getBoolValue()) {
			showHDG.setBoolValue(1);
			var hdgTemp = hdgSetC.getValue();
			if (d == 1) {
				hdgTemp = hdgTemp + 1;
			} else if (d == -1) {
				hdgTemp = hdgTemp - 1;
			} else if (d == 10) {
				hdgTemp = hdgTemp + 10;
			} else if (d == -10) {
				hdgTemp = hdgTemp - 10;
			}
			if (hdgTemp < -0.5) {
				hdgSetC.setValue(hdgTemp + 360);
			} else if (hdgTemp >= 359.5) {
				hdgSetC.setValue(hdgTemp - 360);
			} else {
				hdgSetC.setValue(hdgTemp);
			}
		}
	},
	HDGTRK: func() {
		if (fcpPower.getBoolValue()) {
			if (hdgTrkSW.getBoolValue()) {
				hdgTrkSW.setBoolValue(0);
			} else {
				hdgTrkSW.setBoolValue(1);
			}
		}
	},
	NAVButton: func() {
		if (fcpPower.getBoolValue()) {
			setprop("/it-autoflight/input/lat", 1);
		}
	},
	ALTPush: func() {
		if (fcpPower.getBoolValue()) {
			setprop("/it-autoflight/input/vert", 0);
		}
	},
	ALTPull: func() {
		if (fcpPower.getBoolValue()) {
			setprop("/it-autoflight/input/vert", 4);
		}
	},
	ALTAdjust: func(d) {
		if (fcpPower.getBoolValue()) {
			var altTemp = altSet.getValue();
			if (d == 1) {
				if (altTemp >= 10000) {
					altTemp = math.round(altTemp, 500) + 500; # Make sure it rounds to the nearest 500 from previous before changing
				} else {
					altTemp = math.round(altTemp, 100) + 100; # Make sure it rounds to the nearest 100 from previous before changing
				}
			} else if (d == -1) {
				if (altTemp > 10000) {
					altTemp = math.round(altTemp, 500) - 500; # Make sure it rounds to the nearest 500 from previous before changing
				} else {
					altTemp = math.round(altTemp, 100) - 100; # Make sure it rounds to the nearest 100 from previous before changing
				}
			} else if (d == 10) {
				altTemp = altTemp + 1000;
			} else if (d == -10) {
				altTemp = altTemp - 1000;
			}
			if (altTemp < 0) {
				altSet.setValue(0);
			} else if (altTemp > 50000) {
				altSet.setValue(50000);
			} else {
				altSet.setValue(altTemp);
			}
		}
	},
	VSAdjust: func(d) {
		if (fcpPower.getBoolValue()) {
			if (vertMode.getValue() == 1) {
				var vsTemp = vsSet.getValue();
				if (d == 1) {
					vsTemp = vsTemp + 100;
				} else if (d == -1) {
					vsTemp = vsTemp - 100;
				} else if (d == 10) {
					vsTemp = vsTemp + 1000;
				} else if (d == -10) {
					vsTemp = vsTemp - 1000;
				}
				if (vsTemp < -6000) {
					vsSet.setValue(-6000);
				} else if (vsTemp > 6000) {
					vsSet.setValue(6000);
				} else {
					vsSet.setValue(vsTemp);
				}
			} else if (vertMode.getValue() == 5) {
				var fpaTemp = fpaSet.getValue();
				if (d == 1) {
					fpaTemp = math.round(fpaTemp + 0.1, 0.1);
				} else if (d == -1) {
					fpaTemp = math.round(fpaTemp - 0.1, 0.1);
				} else if (d == 10) {
					fpaTemp = fpaTemp + 1;
				} else if (d == -10) {
					fpaTemp = fpaTemp - 1;
				}
				if (fpaTemp < -9.9) {
					fpaSet.setValue(-9.9);
				} else if (fpaTemp > 9.9) {
					fpaSet.setValue(9.9);
				} else {
					fpaSet.setValue(fpaTemp);
				}
			}
			if (vsFpaSW.getBoolValue()) {
				if (vertMode.getValue() != 5) {
					setprop("/it-autoflight/input/vert", 5);
				}
			} else {
				if (vertMode.getValue() != 1) {
					setprop("/it-autoflight/input/vert", 1);
				}
			}
		}
	},
	VSFPA: func() {
		if (fcpPower.getBoolValue()) {
			if (vertMode.getValue() == 1) {
				vsFpaSW.setBoolValue(1);
				setprop("/it-autoflight/input/vert", 5);
			} else if (vertMode.getValue() == 5) {
				vsFpaSW.setBoolValue(0);
				setprop("/it-autoflight/input/vert", 1);
			} else {
				if (!vsFpaSW.getBoolValue()) {
					vsFpaSW.setBoolValue(1);
				} else if (vsFpaSW.getBoolValue()) {
					vsFpaSW.setBoolValue(0);
				}
			}
		}
	},
	APPRButton: func() {
		if (fcpPower.getBoolValue()) {
			setprop("/it-autoflight/input/vert", 2);
		}
	},
	PROFButton: func() {
		if (fcpPower.getBoolValue()) {
			# Nothing yet
		}
	},
	GAButton: func() {
		if (fcpPower.getBoolValue()) {
			setprop("/it-autoflight/input/toga", 1);
		}
	},
};

setlistener("/it-autoflight/input/trk", func {
	setprop("/instrumentation/efis[0]/hdg-trk-selected", hdgTrkSW.getBoolValue());
	setprop("/instrumentation/efis[1]/hdg-trk-selected", hdgTrkSW.getBoolValue());
}, 0, 0);

var toggleSTD = func {
	var Std = getprop("/modes/altimeter/std");
	if (Std == 1) {
		var oldqnh = getprop("/modes/altimeter/oldqnh");
		setprop("/instrumentation/altimeter/setting-inhg", oldqnh);
		setprop("/modes/altimeter/std", 0);
	} else if (Std == 0) {
		var qnh = getprop("/instrumentation/altimeter/setting-inhg");
		setprop("/modes/altimeter/oldqnh", qnh);
		setprop("/instrumentation/altimeter/setting-inhg", 29.92);
		setprop("/modes/altimeter/std", 1);
	}
}

var unSTD = func {
	var Std = getprop("/modes/altimeter/std");
	if (Std == 1) {
		var oldqnh = getprop("/modes/altimeter/oldqnh");
		setprop("/instrumentation/altimeter/setting-inhg", oldqnh);
		setprop("/modes/altimeter/std", 0);
	}
}
