# McDonnell Douglas MD-11 Buttons and Switches
# Copyright (c) 2020 Josh Davidson (Octal450)

# Resets buttons to the default values
var variousReset = func {
	pts.Controls.Flight.dialAFlap.setValue(15); 
	pts.Controls.Lighting.beacon.setBoolValue(0);
	pts.Controls.Lighting.landingLightL.setValue(0);
	pts.Controls.Lighting.landingLightN.setValue(0);
	pts.Controls.Lighting.landingLightR.setValue(0);
	pts.Controls.Lighting.logoLights.setBoolValue(0);
	pts.Controls.Lighting.navLights.setBoolValue(0);
	pts.Controls.Lighting.strobe.setBoolValue(0);
	pts.Controls.Switches.adgHandle.setValue(0);
	pts.Controls.Switches.minimums.setValue(250);
	pts.Controls.Switches.noSmokingSign.setValue(1); # Smoking is bad!
	pts.Controls.Switches.seatbeltSign.setValue(0);
}

var APPanel = {
	altTemp: 0,
	fpaTemp: 0,
	hdgTemp: 0,
	iasTemp: 0,
	machTemp: 0,
	vertTemp: 0,
	vsTemp: 0,
	AUTOFLIGHT: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.ITAF.AUTOFLIGHT();
		}
	},
	FD1: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.ITAF.fd1Master(!afs.Output.fd1.getBoolValue());
		}
	},
	FD2: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.ITAF.fd2Master(!afs.Output.fd2.getBoolValue());
		}
	},
	APDisc: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.killAPWarn();
			if (afs.Output.ap1.getBoolValue()) {
				afs.ITAF.ap1Master(0);
			}
			if (afs.Output.ap2.getBoolValue()) {
				afs.ITAF.ap2Master(0);
			}
		}
	},
	ATDisc: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.killATSWarn();
			if (afs.Output.athr.getBoolValue()) {
				afs.ITAF.athrMaster(0);
			}
		}
	},
	IASMach: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.Custom.ktsMach.setBoolValue(!afs.Custom.ktsMach.getBoolValue());
		}
	},
	SPDPush: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.ITAF.spdPush();
		}
	},
	SPDPull: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.ITAF.spdPull();
		}
	},
	SPDAdjust: func(d) {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			if (afs.Custom.ktsMach.getBoolValue()) {
				me.machTemp = math.round(afs.Custom.machSel.getValue() + (d * 0.001), (abs(d * 0.001))); # Kill floating point error
				if (me.machTemp < 0.50) {
					afs.Custom.machSel.setValue(0.50);
				} else if (me.machTemp > 0.87) {
					afs.Custom.machSel.setValue(0.87);
				} else {
					afs.Custom.machSel.setValue(me.machTemp);
				}
			} else {
				me.iasTemp = afs.Custom.iasSel.getValue() + d;
				if (me.iasTemp < 100) {
					afs.Custom.iasSel.setValue(100);
				} else if (me.iasTemp > 365) {
					afs.Custom.iasSel.setValue(365);
				} else {
					afs.Custom.iasSel.setValue(me.iasTemp);
				}
			}
		}
	},
	HDGPush: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.Input.lat.setValue(3);
		}
	},
	HDGPull: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.Input.hdg.setValue(afs.Custom.hdgSel.getValue());
			afs.Input.lat.setValue(0);
		}
	},
	HDGAdjust: func(d) {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.Custom.showHdg.setBoolValue(1);
			me.hdgTemp = afs.Custom.hdgSel.getValue() + d;
			if (me.hdgTemp < -0.5) {
				afs.Custom.hdgSel.setValue(me.hdgTemp + 360);
			} else if (me.hdgTemp >= 359.5) {
				afs.Custom.hdgSel.setValue(me.hdgTemp - 360);
			} else {
				afs.Custom.hdgSel.setValue(me.hdgTemp);
			}
		}
	},
	HDGTRK: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.Input.trk.setValue(!afs.Input.trk.getBoolValue());
		}
	},
	NAVButton: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.Input.lat.setValue(1);
		}
	},
	ALTPush: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.Input.vert.setValue(0);
		}
	},
	ALTPull: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.Input.vert.setValue(4);
		}
	},
	ALTAdjust: func(d) {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			me.altTemp = afs.Input.alt.getValue();
			if (d == 1) {
				if (me.altTemp >= 10000) {
					me.altTemp = math.round(me.altTemp, 500) + 500; # Make sure it rounds to the nearest 500 from previous before changing
				} else {
					me.altTemp = math.round(me.altTemp, 100) + 100; # Make sure it rounds to the nearest 100 from previous before changing
				}
			} else if (d == -1) {
				if (me.altTemp > 10000) { # Intentionally not >=
					me.altTemp = math.round(me.altTemp, 500) - 500; # Make sure it rounds to the nearest 500 from previous before changing
				} else {
					me.altTemp = math.round(me.altTemp, 100) - 100; # Make sure it rounds to the nearest 100 from previous before changing
				}
			} else {
				me.altTemp = me.altTemp + (d * 100);
			}
			if (me.altTemp < 0) {
				afs.Input.alt.setValue(0);
			} else if (me.altTemp > 50000) {
				afs.Input.alt.setValue(50000);
			} else {
				afs.Input.alt.setValue(me.altTemp);
			}
		}
	},
	VSAdjust: func(d) {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			me.vertTemp = afs.Output.vert.getValue();
			if (me.vertTemp == 1) {
				me.vsTemp = afs.Input.vs.getValue() + (d * 100);
				if (me.vsTemp < -6000) {
					afs.Input.vs.setValue(-6000);
				} else if (me.vsTemp > 6000) {
					afs.Input.vs.setValue(6000);
				} else {
					afs.Input.vs.setValue(me.vsTemp);
				}
			} else if (me.vertTemp == 5) {
				me.fpaTemp = afs.Input.fpa.getValue();
				if (d == 1 or d == -1) {
					me.fpaTemp = math.round(me.fpaTemp + (d * 0.1), 0.1);
				} else {
					me.fpaTemp = me.fpaTemp + (d * 0.1);
				}
				if (me.fpaTemp < -9.9) {
					afs.Input.fpa.setValue(-9.9);
				} else if (me.fpaTemp > 9.9) {
					afs.Input.fpa.setValue(9.9);
				} else {
					afs.Input.fpa.setValue(me.fpaTemp);
				}
			}
			if (afs.Custom.vsFpa.getBoolValue()) {
				if (me.vertTemp != 5) {
					afs.Input.vert.setValue(5);
				}
			} else {
				if (me.vertTemp != 1) {
					afs.Input.vert.setValue(1);
				}
			}
		}
	},
	VSFPA: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			me.vertTemp = afs.Output.vert.getValue();
			if (me.vertTemp == 1) {
				afs.Custom.vsFpa.setBoolValue(1);
				afs.Input.vert.setValue(5);
			} else if (me.vertTemp == 5) {
				afs.Custom.vsFpa.setBoolValue(0);
				afs.Input.vert.setValue(1);
			} else {
				afs.Custom.vsFpa.setBoolValue(afs.Custom.vsFpa.getBoolValue());
			}
		}
	},
	APPRButton: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.Input.vert.setValue(2);
		}
	},
	PROFButton: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			# Nothing yet
		}
	},
	GAButton: func() {
		if (systems.ELEC.Generic.fcpPower.getBoolValue()) {
			afs.Input.toga.setValue(1);
		}
	},
};

var STD = func {
	if (!pts.Instrumentation.Altimeter.std.getBoolValue()) {
		pts.Instrumentation.Altimeter.oldQnh.setValue(pts.Instrumentation.Altimeter.settingInhg.getValue());
		pts.Instrumentation.Altimeter.settingInhg.setValue(29.92);
		pts.Instrumentation.Altimeter.std.setBoolValue(1);
	}
}

var unSTD = func {
	if (pts.Instrumentation.Altimeter.std.getBoolValue()) {
		pts.Instrumentation.Altimeter.settingInhg.setValue(pts.Instrumentation.Altimeter.oldQnh.getValue());
		pts.Instrumentation.Altimeter.std.setBoolValue(0);
	}
}
