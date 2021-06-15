# McDonnell Douglas MD-11 DU Controller
# Copyright (c) 2021 Josh Davidson (Octal450)
# This file manages the DU Canvas hide/showing in an efficient and synchronized way

var DUController = {
	counterIesi: {
		secs: 180,
		time: 0,
	},
	eadType: pts.Options.eng.getValue(),
	elapsedSec: 0,
	errorActive: 0,
	iesiLcdOn: props.globals.initNode("/instrumentation/iesi/lcd-on", 0, "BOOL"),
	sdPage: "ENG",
	sdPageActive: "ENG",
	showNd1: props.globals.initNode("/instrumentation/nd/show-nd1", 0, "BOOL"),
	showNd2: props.globals.initNode("/instrumentation/nd/show-nd2", 0, "BOOL"),
	updateMcdu1: 0,
	updateMcdu2: 0,
	updateMcdu3: 0,
	updatePfd1: 0,
	updatePfd2: 0,
	updateNd1: 0,
	updateNd2: 0,
	updateEad: 0,
	updateSd: 0,
	updateIesi: 0,
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
		canvas_ead.ge.page.hide();
		canvas_ead.pw.page.hide();
		canvas_sd.eng.page.hide();
		canvas_iesi.iesi.page.hide();
		canvas_mcdu.mcdu1.page.hide();
		canvas_mcdu.mcdu2.page.hide();
		canvas_mcdu.mcdu3.page.hide();
		me.iesiLcdOn.setBoolValue(0);
		
		# Now show the error
		canvas_pfd.pfd1Error.page.show();
		canvas_pfd.pfd2Error.page.show();
		canvas_pfd.pfd1Error.update();
		canvas_pfd.pfd2Error.update();
	},
	loop: func() {
		if (!me.errorActive) {
			if (systems.ELEC.Bus.lEmerAc.getValue() >= 112) {
				if (!me.updatePfd1) {
					me.updatePfd1 = 1;
					canvas_pfd.pfd1.update();
					canvas_pfd.pfd1.page.show();
				}
				
				if (!me.updateEad) {
					me.updateEad = 1;
					if (me.eadType == "GE") {
						canvas_ead.ge.update();
						canvas_ead.ge.page.show();
					} else {
						canvas_ead.pw.update();
						canvas_ead.pw.page.show();
					}
				}
				
				if (!me.updateMcdu1) {
					me.updateMcdu1 = 1;
					canvas_mcdu.mcdu1.update();
					canvas_mcdu.mcdu1.page.show();
				}
			} else {
				if (me.updatePfd1) {
					me.updatePfd1 = 0;
					canvas_pfd.pfd1.page.hide();
				}
				
				if (me.updateEad) {
					me.updateEad = 0;
					canvas_ead.ge.page.hide();
					canvas_ead.pw.page.hide();
				}
				
				if (me.updateMcdu1) {
					me.updateMcdu1 = 0;
					canvas_mcdu.mcdu1.page.hide();
				}
			}
			
			if (systems.ELEC.Bus.ac1.getValue() >= 112) {
				if (!me.updateNd1) {
					me.updateNd1 = 1;
					me.showNd1.setBoolValue(1); # Temporary
				}
				
				if (!me.updateMcdu3) {
					me.updateMcdu3 = 1;
					canvas_mcdu.mcdu3.update();
					canvas_mcdu.mcdu3.page.show();
				}
			} else {
				if (me.updateNd1) {
					me.updateNd1 = 0;
					me.showNd1.setBoolValue(0); # Temporary
				}
				
				if (me.updateMcdu3) {
					me.updateMcdu3 = 0;
					canvas_mcdu.mcdu3.page.hide();
				}
			}
			
			if (systems.ELEC.Bus.ac3.getValue() >= 112) {
				if (!me.updatePfd2) {
					me.updatePfd2 = 1;
					canvas_pfd.pfd2.update();
					canvas_pfd.pfd2.page.show();
				}
				
				if (!me.updateNd2) {
					me.updateNd2 = 1;
					me.showNd2.setBoolValue(1); # Temporary
				}
				
				me.sdPage = pts.Instrumentation.Sd.selectedSynoptic.getValue();
				if (!me.updateSd) {
					me.updateSd = 1;
					me.updateSdPage(me.sdPage);
				}
				if (me.sdPage != me.sdPageActive) {
					me.sdPageActive = me.sdPage;
					me.updateSdPage(me.sdPage);
				}
				
				if (!me.updateMcdu2) {
					me.updateMcdu2 = 1;
					canvas_mcdu.mcdu2.update();
					canvas_mcdu.mcdu2.page.show();
				}
			} else {
				if (me.updatePfd2) {
					me.updatePfd2 = 0;
					canvas_pfd.pfd2.page.hide();
				}
				
				if (me.updateNd2) {
					me.updateNd2 = 0;
					me.showNd2.setBoolValue(0); # Temporary
				}
				
				if (me.updateSd) {
					me.updateSd = 0;
					canvas_sd.eng.page.hide();
				}
				
				if (me.updateMcdu2) {
					me.updateMcdu2 = 0;
					canvas_mcdu.mcdu2.page.hide();
				}
			}
			
			if (systems.ELEC.Bus.dcBat.getValue() >= 24) {
				me.elapsedSec = pts.Sim.Time.elapsedSec.getValue();
				if (me.counterIesi.time == 0) {
					if (acconfig.SYSTEM.autoConfigRunning.getBoolValue()) {
						me.counterIesi.time = me.elapsedSec - 178;
					} else {
						me.counterIesi.time = me.elapsedSec;
					}
				}
				if (me.counterIesi.secs > 0) {
					me.counterIesi.secs = math.round(me.counterIesi.time + 180 - me.elapsedSec);
				} else {
					me.counterIesi.secs = 0;
				}
				
				if (!me.updateIesi) {
					me.updateIesi = 1;
					canvas_iesi.iesi.update();
					me.iesiLcdOn.setBoolValue(1);
					canvas_iesi.iesi.page.show();
				}
			} else {
				me.counterIesi.secs = 180;
				me.counterIesi.time = 0;
				
				if (me.updateIesi) {
					me.updateIesi = 0;
					canvas_iesi.iesi.page.hide();
					me.iesiLcdOn.setBoolValue(0);
				}
			}
		}
	},
	updateSdPage: func(p) {
		if (p == "ENG") {
			canvas_sd.eng.update();
			canvas_sd.eng.page.show();
		} else {
			canvas_sd.eng.page.hide();
		}
	},
};
