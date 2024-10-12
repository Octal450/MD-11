# McDonnell Douglas MD-11 DU Controller
# Copyright (c) 2024 Josh Davidson (Octal450)
# This controls the DU's in an efficient and synchronized way

var DUController = {
	BlinkSd: {
		active: 0,
		time: -10,
	},
	CounterIesi: {
		secs: 180,
		time: 0,
	},
	eadType: "GE-Dials",
	eng: pts.Options.eng.getValue(),
	elapsedSec: 0,
	errorActive: 0,
	iesiLcdOn: props.globals.initNode("/instrumentation/iesi/lcd-on", 0, "BOOL"),
	PwrSource: {
		ac1: 0,
		ac3: 0,
		dcBat: 0,
		lEmerAc: 0,
	},
	sdPage: "ENG",
	sdPageActive: "ENG",
	showNd1: props.globals.initNode("/instrumentation/nd/show-nd1", 0, "BOOL"),
	showNd2: props.globals.initNode("/instrumentation/nd/show-nd2", 0, "BOOL"),
	singleCueFd: 0,
	updateEad: 0,
	updateIesi: 0,
	updateMcdu1: 0,
	updateMcdu2: 0,
	updateMcdu3: 0,
	updateNd1: 0,
	updateNd2: 0,
	updatePfd1: 0,
	updatePfd2: 0,
	updateSd: 0,
	showError: func() {
		me.errorActive = 1;
		
		# Hide the pages
		me.updateMcdu1 = 0;
		me.updateMcdu2 = 0;
		me.updateMcdu3 = 0;
		me.updatePfd1 = 0;
		me.updatePfd2 = 0;
		me.updateNd1 = 0;
		me.updateNd2 = 0;
		me.updateEad = 0;
		me.updateSd = 0;
		me.updateIesi = 0;
		canvas_pfd.pfd1.page.hide();
		canvas_pfd.pfd2.page.hide();
		me.showNd1.setBoolValue(0); # Temporary
		me.showNd2.setBoolValue(0); # Temporary
		canvas_ead.geDials.page.hide();
		canvas_ead.geTapes.page.hide();
		canvas_ead.pwDials.page.hide();
		canvas_ead.pwTapes.page.hide();
		me.showSdPage("NONE");
		canvas_iesi.iesi.page.hide();
		canvas_mcdu.mcdu1.page.hide();
		canvas_mcdu.mcdu2.page.hide();
		canvas_mcdu.mcdu3.page.hide();
		me.iesiLcdOn.setBoolValue(0);
		
		# Now show the error
		canvas_pfd.pfd1Error.page.show();
		canvas_pfd.pfd2Error.page.show();
	},
	loop: func() {
		me.singleCueFd = pts.Systems.Acconfig.Options.singleCueFd.getBoolValue();
		
		if (me.eng == "PW") {
			if (pts.Systems.Acconfig.Options.engTapes.getBoolValue()) {
				me.eadType = "PW-Tapes";
			} else {
				me.eadType = "PW-Dials";
			}
		} else {
			if (pts.Systems.Acconfig.Options.engTapes.getBoolValue()) {
				me.eadType = "GE-Tapes";
			} else {
				me.eadType = "GE-Dials";
			}
		}
		
		if (!me.errorActive) {
			me.PwrSource.ac1 = systems.ELECTRICAL.Bus.ac1.getValue();
			me.PwrSource.ac3 = systems.ELECTRICAL.Bus.ac3.getValue();
			me.PwrSource.dcBat = systems.ELECTRICAL.Bus.dcBat.getValue();
			me.PwrSource.lEmerAc = systems.ELECTRICAL.Bus.lEmerAc.getValue();
			me.PwrSource.rEmerAc = systems.ELECTRICAL.Bus.rEmerAc.getValue();
			
			# L Emer AC
			if (me.PwrSource.lEmerAc >= 112 and pts.Instrumentation.Du.duDimmer[0].getValue() > 0.01) {
				if (!me.updatePfd1) {
					me.updatePfd1 = 1;
					canvas_pfd.pfd1.update();
					canvas_pfd.pfd1.page.show();
				}
			} else {
				if (me.updatePfd1) {
					me.updatePfd1 = 0;
					canvas_pfd.pfd1.page.hide();
				}
			}
				
			if (me.PwrSource.lEmerAc >= 112 and pts.Instrumentation.Du.duDimmer[2].getValue() > 0.01) {
				if (!me.updateEad) {
					me.updateEad = 1;
					if (me.eadType == "PW-Tapes") {
						canvas_ead.geDials.page.hide();
						canvas_ead.geTapes.page.hide();
						canvas_ead.pwDials.page.hide();
						canvas_ead.pwTapes.update();
						canvas_ead.pwTapes.page.show();
					} else if (me.eadType == "GE-Tapes") {
						canvas_ead.geDials.page.hide();
						canvas_ead.pwDials.page.hide();
						canvas_ead.pwTapes.page.hide();
						canvas_ead.geTapes.update();
						canvas_ead.geTapes.page.show();
					} else if (me.eadType == "PW-Dials") {
						canvas_ead.geDials.page.hide();
						canvas_ead.geTapes.page.hide();
						canvas_ead.pwTapes.page.hide();
						canvas_ead.pwDials.setDials();
						canvas_ead.pwDials.update();
						canvas_ead.pwDials.page.show();
					} else {
						canvas_ead.geTapes.page.hide();
						canvas_ead.pwDials.page.hide();
						canvas_ead.pwTapes.page.hide();
						canvas_ead.geDials.update();
						canvas_ead.geDials.page.show();
					}
				}
			} else {
				if (me.updateEad) {
					me.updateEad = 0;
					canvas_ead.geDials.page.hide();
					canvas_ead.geTapes.page.hide();
					canvas_ead.pwDials.page.hide();
					canvas_ead.pwTapes.page.hide();
				}
			}
			
			if (me.PwrSource.lEmerAc >= 112 and pts.Instrumentation.Du.mcduDimmer[0].getValue() > 0.01) {
				if (!mcdu.unit[0].Blink.active) {
					if (!me.updateMcdu1) {
						me.updateMcdu1 = 1;
						canvas_mcdu.mcdu1.update();
						canvas_mcdu.mcdu1.page.show();
					}
				}
			} else {
				if (me.updateMcdu1) {
					me.updateMcdu1 = 0;
					canvas_mcdu.mcdu1.page.hide();
				}
			}
			
			# AC 1
			if (me.PwrSource.ac1 >= 112 and pts.Instrumentation.Du.duDimmer[1].getValue() > 0.01) {
				if (!me.updateNd1) {
					me.updateNd1 = 1;
					me.showNd1.setBoolValue(1); # Temporary
				}
			} else {
				if (me.updateNd1) {
					me.updateNd1 = 0;
					me.showNd1.setBoolValue(0); # Temporary
				}
			}
			
			if (me.PwrSource.ac1 >= 112 and pts.Instrumentation.Du.mcduDimmer[2].getValue() > 0.01) {
				if (!mcdu.unit[2].Blink.active) {
					if (!me.updateMcdu3) {
						me.updateMcdu3 = 1;
						canvas_mcdu.mcdu3.update();
						canvas_mcdu.mcdu3.page.show();
					}
				}
			} else {
				if (me.updateMcdu3) {
					me.updateMcdu3 = 0;
					canvas_mcdu.mcdu3.page.hide();
				}
			}
			
			# AC 3
			if (me.PwrSource.ac3 >= 112 and pts.Instrumentation.Du.duDimmer[5].getValue() > 0.01) {
				if (!me.updatePfd2) {
					me.updatePfd2 = 1;
					canvas_pfd.pfd2.update();
					canvas_pfd.pfd2.page.show();
				}
			} else {
				if (me.updatePfd2) {
					me.updatePfd2 = 0;
					canvas_pfd.pfd2.page.hide();
				}
			}
			
			if (me.PwrSource.ac3 >= 112 and pts.Instrumentation.Du.duDimmer[4].getValue() > 0.01) {
				if (!me.updateNd2) {
					me.updateNd2 = 1;
					me.showNd2.setBoolValue(1); # Temporary
				}
			} else {
				if (me.updateNd2) {
					me.updateNd2 = 0;
					me.showNd2.setBoolValue(0); # Temporary
				}
			}
			
			if (me.BlinkSd.active) {
				if (me.BlinkSd.time < pts.Sim.Time.elapsedSec.getValue()) {
					me.BlinkSd.active = 0;
				}
			}
			if (me.PwrSource.ac3 >= 112 and pts.Instrumentation.Du.duDimmer[3].getValue() > 0.01) {
				if (!me.BlinkSd.active) {
					if (!me.updateSd) {
						me.updateSd = 1;
						me.showSdPage(me.sdPage);
					}
					if (me.sdPage != me.sdPageActive) {
						me.sdPageActive = me.sdPage;
						me.showSdPage(me.sdPage);
					}
				}
			} else {
				if (me.updateSd) {
					me.updateSd = 0;
					canvas_sd.canvasBase.hidePages();
				}
			}
			
			# R Emer AC
			if (me.PwrSource.rEmerAc >= 112 and pts.Instrumentation.Du.mcduDimmer[1].getValue() > 0.01) {
				if (!mcdu.unit[1].Blink.active) {
					if (!me.updateMcdu2) {
						me.updateMcdu2 = 1;
						canvas_mcdu.mcdu2.update();
						canvas_mcdu.mcdu2.page.show();
					}
				}
			} else {
				if (me.updateMcdu2) {
					me.updateMcdu2 = 0;
					canvas_mcdu.mcdu2.page.hide();
				}
			}
			
			if (me.PwrSource.dcBat >= 24) {
				me.elapsedSec = pts.Sim.Time.elapsedSec.getValue();
				if (me.CounterIesi.time == 0) {
					if (acconfig.SYSTEM.autoConfigRunning.getBoolValue()) {
						me.CounterIesi.time = me.elapsedSec - 178;
					} else {
						me.CounterIesi.time = me.elapsedSec;
					}
				}
				if (me.CounterIesi.secs > 0) {
					me.CounterIesi.secs = math.round(me.CounterIesi.time + 180 - me.elapsedSec);
				} else {
					me.CounterIesi.secs = 0;
				}
				
				if (pts.Systems.Acconfig.Options.iesiEquipped.getBoolValue()) { # Equipped
					if (!me.updateIesi) {
						me.updateIesi = 1;
						canvas_iesi.iesi.update();
						me.iesiLcdOn.setBoolValue(1);
						canvas_iesi.iesi.page.show();
					}
				} else { # Not equipped
					if (me.updateIesi) {
						me.updateIesi = 0;
						canvas_iesi.iesi.page.hide();
						me.iesiLcdOn.setBoolValue(0);
					}
				}
			} else {
				me.CounterIesi.secs = 180;
				me.CounterIesi.time = 0;
				
				if (me.updateIesi) {
					me.updateIesi = 0;
					canvas_iesi.iesi.page.hide();
					me.iesiLcdOn.setBoolValue(0);
				}
			}
		}
	},
	blinkSd: func() {
		me.BlinkSd.active = 1;
		me.updateSd = 0;
		canvas_sd.canvasBase.hidePages();
		me.BlinkSd.time = pts.Sim.Time.elapsedSec.getValue() + 0.4;
	},
	hideMcdu: func(n) {
		if (n == 0) {
			me.updateMcdu1 = 0;
			canvas_mcdu.mcdu1.page.hide();
		}
		if (n == 1) {
			me.updateMcdu2 = 0;
			canvas_mcdu.mcdu2.page.hide();
		}
		if (n == 2) {
			me.updateMcdu3 = 0;
			canvas_mcdu.mcdu3.page.hide();
		}
	},
	setSdPage: func(page) {
		me.blinkSd();
		me.sdPage = page;
	},
	showSdPage: func(p) {
		if (p == "CONFIG") {
			canvas_sd.conseq.page.hide();
			canvas_sd.engDials.page.hide();
			canvas_sd.engTapes.page.hide();
			canvas_sd.misc.page.hide();
			canvas_sd.status.page.hide();
			canvas_sd.config.update();
			canvas_sd.config.page.show();
		} else if (p == "CONSEQ") {
			canvas_sd.config.page.hide();
			canvas_sd.engDials.page.hide();
			canvas_sd.engTapes.page.hide();
			canvas_sd.misc.page.hide();
			canvas_sd.status.page.hide();
			canvas_sd.conseq.update();
			canvas_sd.conseq.page.show();
		} else if (p == "ENG") {
			if (me.eadType == "GE-Tapes" or me.eadType == "PW-Tapes") { # Tape style EAD means tape style SD
				canvas_sd.config.page.hide();
				canvas_sd.conseq.page.hide();
				canvas_sd.engDials.page.hide();
				canvas_sd.misc.page.hide();
				canvas_sd.status.page.hide();
				canvas_sd.engTapes.update();
				canvas_sd.engTapes.page.show();
			} else {
				canvas_sd.config.page.hide();
				canvas_sd.conseq.page.hide();
				canvas_sd.engTapes.page.hide();
				canvas_sd.misc.page.hide();
				canvas_sd.status.page.hide();
				canvas_sd.engDials.update();
				canvas_sd.engDials.page.show();
			}
		} else if (p == "MISC") {
			canvas_sd.config.page.hide();
			canvas_sd.conseq.page.hide();
			canvas_sd.engDials.page.hide();
			canvas_sd.engTapes.page.hide();
			canvas_sd.misc.update();
			canvas_sd.misc.page.show();
			canvas_sd.status.page.hide();
		} else if (p == "STATUS") {
			canvas_sd.config.page.hide();
			canvas_sd.conseq.page.hide();
			canvas_sd.engDials.page.hide();
			canvas_sd.engTapes.page.hide();
			canvas_sd.misc.page.hide();
			canvas_sd.status.update();
			canvas_sd.status.page.show();
		} else {
			canvas_sd.config.page.hide();
			canvas_sd.conseq.page.hide();
			canvas_sd.engDials.page.hide();
			canvas_sd.engTapes.page.hide();
			canvas_sd.misc.page.hide();
			canvas_sd.status.page.hide();
		}
	},
};

# Update PW Dial Positions
setlistener("/systems/acconfig/options/n1-below-epr", func() {
	if (DUController.eadType == "PW-Dials") {
		canvas_ead.pwDials.setDials();
	}
}, 0, 0);

# Update Dials vs Tapes
setlistener("/systems/acconfig/options/eng-tapes", func() {
	# This forces them to show the appropriate page
	DUController.updateEad = 0;
	DUController.updateSd = 0;
}, 0, 0);
