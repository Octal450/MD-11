# McDonnell Douglas MD-11 Buttons and Switches
# Copyright (c) 2023 Josh Davidson (Octal450)

var gpwsOvrd = 0;

# Resets buttons to the default values
var variousReset = func() {
	pts.Controls.Flight.dialAFlap.setValue(15); 
	pts.Controls.Flight.slatStow.setBoolValue(0); 
	pts.Controls.Lighting.beacon.setBoolValue(0);
	pts.Controls.Lighting.emerLt.setValue(0);
	pts.Controls.Lighting.landingLightL.setValue(0);
	pts.Controls.Lighting.landingLightN.setValue(0);
	pts.Controls.Lighting.landingLightR.setValue(0);
	pts.Controls.Lighting.logoLights.setBoolValue(0);
	pts.Controls.Lighting.navLights.setBoolValue(0);
	pts.Controls.Lighting.strobe.setBoolValue(0);
	pts.Controls.Switches.adgHandle.setValue(0);
	pts.Controls.Switches.gpwsOvrd.setValue(0);
	pts.Controls.Switches.gpwsOvrdCover.setBoolValue(0);
	pts.Controls.Switches.minimums.setValue(250);
	pts.Controls.Switches.noSmokingSign.setValue(1); # Smoking is bad!
	pts.Controls.Switches.seatbeltSign.setValue(0);
	pts.Instrumentation.Du.duDimmer[0].setValue(1);
	pts.Instrumentation.Du.duDimmer[1].setValue(1);
	pts.Instrumentation.Du.duDimmer[2].setValue(1);
	pts.Instrumentation.Du.duDimmer[3].setValue(1);
	pts.Instrumentation.Du.duDimmer[4].setValue(1);
	pts.Instrumentation.Du.duDimmer[5].setValue(1);
	pts.Instrumentation.Du.mcduDimmer[0].setValue(1);
	pts.Instrumentation.Du.mcduDimmer[1].setValue(1);
	pts.Instrumentation.Du.mcduDimmer[2].setValue(1);
	pts.Instrumentation.Du.irsCapt.setBoolValue(0);
	pts.Instrumentation.Du.irsFo.setBoolValue(0);
	pts.Instrumentation.Efis.Mfd.trueNorth[0].setBoolValue(0);
	pts.Instrumentation.Efis.Mfd.trueNorth[1].setBoolValue(0);
	pts.Instrumentation.Sd.selectedSynoptic.setValue("ENG");
}

var apPanel = {
	altTemp: 0,
	fpaTemp: 0,
	hdgTemp: 0,
	ktsTemp: 0,
	machTemp: 0,
	vertTemp: 0,
	vsTemp: 0,
	autoflight: func() {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			afs.ITAF.autoflight();
		}
	},
	fd1: func() {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			afs.ITAF.fd1Master(!afs.Output.fd1.getBoolValue());
		}
	},
	fd2: func() {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			afs.ITAF.fd2Master(!afs.Output.fd2.getBoolValue());
		}
	},
	apDisc: func() {
		afs.killApWarn();
		if (afs.Output.ap1.getBoolValue()) {
			afs.ITAF.ap1Master(0);
		}
		if (afs.Output.ap2.getBoolValue()) {
			afs.ITAF.ap2Master(0);
		}
	},
	atDisc: func() {
		afs.killAtsWarn();
		if (afs.Output.athr.getBoolValue()) {
			afs.ITAF.athrMaster(0);
		}
	},
	ktsMach: func() {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			afs.Input.ktsMach.setBoolValue(!afs.Input.ktsMach.getBoolValue());
		}
	},
	spdPush: func() {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			afs.ITAF.spdPush();
		}
	},
	spdPull: func() {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			afs.ITAF.spdPull();
		}
	},
	spdAdjust: func(d) {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			if (afs.Input.ktsMach.getBoolValue()) {
				me.machTemp = math.round(afs.Input.mach.getValue() + (d * 0.001), (abs(d * 0.001))); # Kill floating point error
				if (me.machTemp < 0.50) {
					afs.Input.mach.setValue(0.50);
				} else if (me.machTemp > 0.87) {
					afs.Input.mach.setValue(0.87);
				} else {
					afs.Input.mach.setValue(me.machTemp);
				}
			} else {
				me.ktsTemp = afs.Input.kts.getValue() + d;
				if (me.ktsTemp < 100) {
					afs.Input.kts.setValue(100);
				} else if (me.ktsTemp > 365) {
					afs.Input.kts.setValue(365);
				} else {
					afs.Input.kts.setValue(me.ktsTemp);
				}
			}
		}
	},
	hdgPush: func() {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			afs.Input.lat.setValue(3);
		}
	},
	hdgPull: func() {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			afs.Internal.hdg.setValue(afs.Input.hdg.getValue());
			afs.Input.lat.setValue(0);
		}
	},
	hdgAdjust: func(d) {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			afs.Output.showHdg.setBoolValue(1);
			me.hdgTemp = afs.Input.hdg.getValue() + d;
			if (me.hdgTemp < -0.5) {
				afs.Input.hdg.setValue(me.hdgTemp + 360);
			} else if (me.hdgTemp >= 359.5) {
				afs.Input.hdg.setValue(me.hdgTemp - 360);
			} else {
				afs.Input.hdg.setValue(me.hdgTemp);
			}
		}
	},
	hdgTrk: func() {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			afs.Input.trk.setValue(!afs.Input.trk.getBoolValue());
		}
	},
	nav: func() {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			afs.Input.lat.setValue(1);
		}
	},
	altPush: func() {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			afs.Input.vert.setValue(0);
		}
	},
	altPull: func() {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			afs.Input.vert.setValue(4);
		}
	},
	altAdjust: func(d) {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
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
				if (me.altTemp >= 10000) {
					me.altTemp = math.round(me.altTemp, 1000);
				}
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
	vsAdjust: func(d) {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
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
			} else {
				afs.Input.vert.setValue(1);
			}
		}
	},
	vsFpa: func() {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			afs.Input.vsFpa.setBoolValue(!afs.Input.vsFpa.getBoolValue());
		}
	},
	appr: func() {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			afs.Input.radioSel.setValue(2);
			afs.Input.vert.setValue(2);
		}
	},
	prof: func() {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			# Nothing yet
		}
	},
	toga: func() {
		if (systems.ELEC.Generic.fcp.getValue() >= 24) {
			systems.FADEC.Limit.flexActive.setBoolValue(0); # Cancels FLEX if active
			afs.Input.toga.setValue(1);
		}
	},
};

var STD = func() {
	if (!pts.Instrumentation.Altimeter.std.getBoolValue()) {
		pts.Instrumentation.Altimeter.oldQnh.setValue(pts.Instrumentation.Altimeter.settingInhg.getValue());
		pts.Instrumentation.Altimeter.settingInhg.setValue(29.92);
		pts.Instrumentation.Altimeter.std.setBoolValue(1);
	}
}

var unSTD = func() {
	if (pts.Instrumentation.Altimeter.std.getBoolValue()) {
		pts.Instrumentation.Altimeter.settingInhg.setValue(pts.Instrumentation.Altimeter.oldQnh.getValue());
		pts.Instrumentation.Altimeter.std.setBoolValue(0);
	}
}

setlistener("/controls/switches/gpws-ovrd", func() {
	gpwsOvrd = pts.Controls.Switches.gpwsOvrd.getValue();
	
	if (gpwsOvrd == 1) pts.Instrumentation.MkViii.Inputs.Discretes.selfTest.setBoolValue(1);
	else pts.Instrumentation.MkViii.Inputs.Discretes.selfTest.setBoolValue(0);
	
	if (gpwsOvrd == -1) pts.Instrumentation.MkViii.Inputs.Discretes.momentaryFlapOverride.setBoolValue(1);
	else pts.Instrumentation.MkViii.Inputs.Discretes.momentaryFlapOverride.setBoolValue(0);
}, 0, 0);
