# McDonnell Douglas MD-11 Electrical System
# Copyright (c) 2019 Joshua Davidson (Octal450)

var ELEC = {
	Bus: { # Volts
		ac1: props.globals.getNode("/systems/electrical/bus/ac-1"),
		ac2: props.globals.getNode("/systems/electrical/bus/ac-2"),
		ac3: props.globals.getNode("/systems/electrical/bus/ac-3"),
		acGen1: props.globals.getNode("/systems/electrical/bus/ac-gen-1"),
		acGen2: props.globals.getNode("/systems/electrical/bus/ac-gen-2"),
		acGen3: props.globals.getNode("/systems/electrical/bus/ac-gen-3"),
		acGndSvc: props.globals.getNode("/systems/electrical/bus/ac-gndsvc"),
		acTie: props.globals.getNode("/systems/electrical/bus/ac-tie"),
		cabinAc1: props.globals.getNode("/systems/electrical/bus/cabin-ac-1"),
		cabinAc3: props.globals.getNode("/systems/electrical/bus/cabin-ac-3"),
		cabinAcF: props.globals.getNode("/systems/electrical/bus/cabin-ac-f"),
		cabinDc: props.globals.getNode("/systems/electrical/bus/cabin-dc"),
		cargoLoading: props.globals.getNode("/systems/electrical/bus/cargo-loading"),
		dc1: props.globals.getNode("/systems/electrical/bus/dc-1"),
		dc2: props.globals.getNode("/systems/electrical/bus/dc-2"),
		dc3: props.globals.getNode("/systems/electrical/bus/dc-3"),
		dcBat: props.globals.getNode("/systems/electrical/bus/dc-bat"),
		dcBatDirect: props.globals.getNode("/systems/electrical/bus/dc-bat-direct"),
		dcGndSvc: props.globals.getNode("/systems/electrical/bus/dc-gndsvc"),
		dcTie: props.globals.getNode("/systems/electrical/bus/dc-tie"),
		fltCompAcGndSvc: props.globals.getNode("/systems/electrical/bus/flt-comp-ac-gndsvc"),
		fwdMidCabin: props.globals.getNode("/systems/electrical/bus/fwd-mid-cabin"),
		galley1: props.globals.getNode("/systems/electrical/bus/galley-1"),
		galley2: props.globals.getNode("/systems/electrical/bus/galley-2"),
		galley3: props.globals.getNode("/systems/electrical/bus/galley-3"),
		galley4: props.globals.getNode("/systems/electrical/bus/galley-4"),
		lEmerAc: props.globals.getNode("/systems/electrical/bus/l-emer-ac"),
		lEmerDc: props.globals.getNode("/systems/electrical/bus/l-emer-dc"),
		lEmerSi: props.globals.getNode("/systems/electrical/bus/l-emer-si"),
		overwingAftCabin: props.globals.getNode("/systems/electrical/bus/overwing-aft-cabin"),
		rEmerAc: props.globals.getNode("/systems/electrical/bus/r-emer-ac"),
		rEmerDc: props.globals.getNode("/systems/electrical/bus/r-emer-dc"),
	},
	Fail: {
		apu: props.globals.getNode("/systems/failures/electrical/apu"),
		bat1: props.globals.getNode("/systems/failures/electrical/bat-1"),
		bat1Temp: 0,
		bat2: props.globals.getNode("/systems/failures/electrical/bat-2"),
		bat2Temp: 0,
		gen1: props.globals.getNode("/systems/failures/electrical/gen-1"),
		gen2: props.globals.getNode("/systems/failures/electrical/gen-2"),
		gen3: props.globals.getNode("/systems/failures/electrical/gen-3"),
	},
	Generic: {
		adf: props.globals.initNode("/systems/electrical/outputs/adf", 0, "DOUBLE"),
		dme: props.globals.initNode("/systems/electrical/outputs/dme", 0, "DOUBLE"),
		efis: props.globals.initNode("/systems/electrical/outputs/efis", 0, "DOUBLE"),
		fcpPower: props.globals.initNode("/systems/electrical/outputs/fcp-power", 0, "DOUBLE"),
		fuelPump0: props.globals.initNode("/systems/electrical/outputs/fuel-pump[0]", 0, "DOUBLE"),
		fuelPump1: props.globals.initNode("/systems/electrical/outputs/fuel-pump[1]", 0, "DOUBLE"),
		fuelPump2: props.globals.initNode("/systems/electrical/outputs/fuel-pump[2]", 0, "DOUBLE"),
		gps: props.globals.initNode("/systems/electrical/outputs/gps", 0, "DOUBLE"),
		mkViii: props.globals.initNode("/systems/electrical/outputs/mk-viii", 0, "DOUBLE"),
		nav0: props.globals.initNode("/systems/electrical/outputs/nav[0]", 0, "DOUBLE"),
		nav1: props.globals.initNode("/systems/electrical/outputs/nav[1]", 0, "DOUBLE"),
		nav2: props.globals.initNode("/systems/electrical/outputs/nav[2]", 0, "DOUBLE"),
		nav3: props.globals.initNode("/systems/electrical/outputs/nav[3]", 0, "DOUBLE"),
		tacan: props.globals.initNode("/systems/electrical/outputs/tacan", 0, "DOUBLE"),
		transponder: props.globals.initNode("/systems/electrical/outputs/transponder", 0, "DOUBLE"),
		turnCoordinator: props.globals.initNode("/systems/electrical/outputs/turn-coordinator", 0, "DOUBLE"),
	},
	Light: {
		manualFlash: props.globals.initNode("/systems/electrical/light/manual-flash", 0, "INT"),
		manualFlashTemp: 0,
	},
	Misc: {
		elapsedSecTemp: 0,
	},
	RCB: { # 0 is Open, 1 is Closed
		dcBat_LEmerDc: props.globals.getNode("/systems/electrical/rcb/dc-bat-l-emer-dc/contact-pos"),
		dcTie_Dc1: props.globals.getNode("/systems/electrical/rcb/dc-tie-dc-1/contact-pos"),
		dcTie_Dc2: props.globals.getNode("/systems/electrical/rcb/dc-tie-dc-2/contact-pos"),
		dcTie_Dc3: props.globals.getNode("/systems/electrical/rcb/dc-tie-dc-3/contact-pos"),
		dcTie_DcGndSvc: props.globals.getNode("/systems/electrical/rcb/dc-tie-dc-gndsvc/contact-pos"),
		tr3_Dc3: props.globals.getNode("/systems/electrical/rcb/tr-3-dc-3/contact-pos"),
	},
	Relay: { # 0 is Open, 1 is Closed
		acGen1_LEmerAc: props.globals.getNode("/systems/electrical/relay/ac-gen-1-l-emer-ac/contact-pos"),
		acGen1_Tr1: props.globals.getNode("/systems/electrical/relay/ac-gen-1-tr-1/contact-pos"),
		acGen2_AcGndSvc: props.globals.getNode("/systems/electrical/relay/ac-gen-2-ac-gndsvc/contact-pos"),
		acGen2_Tr2a: props.globals.getNode("/systems/electrical/relay/ac-gen-2-tr-2a/contact-pos"),
		acGen3_REmerAc: props.globals.getNode("/systems/electrical/relay/ac-gen-3-r-emer-ac/contact-pos"),
		acGen_Ext_Galley1_S1: props.globals.getNode("/systems/electrical/relay/ac-gen-ext-galley-1/contact-pos-ac-gen"),
		acGen_Ext_Galley1_S2: props.globals.getNode("/systems/electrical/relay/ac-gen-ext-galley-1/contact-pos-extg"),
		acGen_Ext_Galley2_S1: props.globals.getNode("/systems/electrical/relay/ac-gen-ext-galley-2/contact-pos-ac-gen"),
		acGen_Ext_Galley2_S2: props.globals.getNode("/systems/electrical/relay/ac-gen-ext-galley-2/contact-pos-extg"),
		acGen_Ext_Galley3_S1: props.globals.getNode("/systems/electrical/relay/ac-gen-ext-galley-3/contact-pos-ac-gen"),
		acGen_Ext_Galley3_S2: props.globals.getNode("/systems/electrical/relay/ac-gen-ext-galley-3/contact-pos-extg"),
		acGndSvc_Tr2b: props.globals.getNode("/systems/electrical/relay/ac-gndsvc-tr-2b/contact-pos"),
		acTie_AcGen1: props.globals.getNode("/systems/electrical/relay/ac-tie-ac-gen-1/contact-pos"),
		acTie_AcGen2: props.globals.getNode("/systems/electrical/relay/ac-tie-ac-gen-2/contact-pos"),
		acTie_AcGen3: props.globals.getNode("/systems/electrical/relay/ac-tie-ac-gen-3/contact-pos"),
		adg_REmerAc: props.globals.getNode("/systems/electrical/relay/adg-r-emer-ac/contact-pos"),
		apu_AcGen1: props.globals.getNode("/systems/electrical/relay/apu-ac-gen-1/contact-pos"),
		apu_AcGen2: props.globals.getNode("/systems/electrical/relay/apu-ac-gen-2/contact-pos"),
		apu_AcGen3: props.globals.getNode("/systems/electrical/relay/apu-ac-gen-3/contact-pos"),
		apu_Ext_AcGndSvc_S1: props.globals.getNode("/systems/electrical/relay/apu-ext-ac-gndsvc/contact-pos-apu"),
		apu_Ext_AcGndSvc_S2: props.globals.getNode("/systems/electrical/relay/apu-ext-ac-gndsvc/contact-pos-ext"),
		ext_AcTie: props.globals.getNode("/systems/electrical/relay/ext-ac-tie/contact-pos"),
		extPwr: props.globals.getNode("/systems/electrical/relay/ext-pwr/contact-pos"),
		extGPwr: props.globals.getNode("/systems/electrical/relay/extg-pwr/contact-pos"),
		galley1: props.globals.getNode("/systems/electrical/relay/galley-1/contact-pos"),
		galley2: props.globals.getNode("/systems/electrical/relay/galley-2/contact-pos"),
		galley3: props.globals.getNode("/systems/electrical/relay/galley-3/contact-pos"),
		idg_AcGen1: props.globals.getNode("/systems/electrical/relay/idg-ac-gen-1/contact-pos"),
		idg_AcGen2: props.globals.getNode("/systems/electrical/relay/idg-ac-gen-2/contact-pos"),
		idg_AcGen3: props.globals.getNode("/systems/electrical/relay/idg-ac-gen-3/contact-pos"),
		rEmerAc_Tr3: props.globals.getNode("/systems/electrical/relay/r-emer-ac-tr-3/contact-pos"),
		si1_LEmerAc: props.globals.getNode("/systems/electrical/relay/si-1-l-emer-ac/contact-pos"),
	},
	Source: {
		batChargerPowered: props.globals.getNode("/systems/electrical/sources/bat-charger-powered"),
		batChargerPoweredTemp: 0,
		Adg: {
			hertz: props.globals.getNode("/systems/electrical/sources/adg/output-hertz"),
			volt: props.globals.getNode("/systems/electrical/sources/adg/output-volt"),
		},
		Apu: {
			hertz: props.globals.getNode("/systems/electrical/sources/apu/output-hertz"),
			volt: props.globals.getNode("/systems/electrical/sources/apu/output-volt"),
		},
		Bat1: {
			amp: props.globals.getNode("/systems/electrical/sources/bat-1/amp"),
			percent: props.globals.getNode("/systems/electrical/sources/bat-1/percent"),
			percentCalc: 100,
			percentTemp: 100,
			time: 0,
			volt: props.globals.getNode("/systems/electrical/sources/bat-1/volt"),
		},
		Bat2: {
			amp: props.globals.getNode("/systems/electrical/sources/bat-2/amp"),
			percent: props.globals.getNode("/systems/electrical/sources/bat-2/percent"),
			percentCalc: 100,
			percentTemp: 100,
			time: 0,
			volt: props.globals.getNode("/systems/electrical/sources/bat-2/volt"),
		},
		Ext: {
			cart: props.globals.getNode("/controls/switches/cart"),
			hertz: props.globals.getNode("/systems/electrical/sources/ext/output-hertz"),
			hertzGalley: props.globals.getNode("/systems/electrical/sources/ext/output-galley-hertz"),
			volt: props.globals.getNode("/systems/electrical/sources/ext/output-volt"),
			voltGalley: props.globals.getNode("/systems/electrical/sources/ext/output-galley-volt"),
		},
		Idg1: {
			outputHertz: props.globals.getNode("/systems/electrical/sources/idg-1/output-hertz"),
			outputVolt: props.globals.getNode("/systems/electrical/sources/idg-1/output-volt"),
			pmgHertz: props.globals.getNode("/systems/electrical/sources/idg-1/pmg-hertz"),
			pmgVolt: props.globals.getNode("/systems/electrical/sources/idg-1/pmg-volt"),
		},
		Idg2: {
			outputHertz: props.globals.getNode("/systems/electrical/sources/idg-2/output-hertz"),
			outputVolt: props.globals.getNode("/systems/electrical/sources/idg-2/output-volt"),
			pmgHertz: props.globals.getNode("/systems/electrical/sources/idg-2/pmg-hertz"),
			pmgVolt: props.globals.getNode("/systems/electrical/sources/idg-2/pmg-volt"),
		},
		Idg3: {
			outputHertz: props.globals.getNode("/systems/electrical/sources/idg-3/output-hertz"),
			outputVolt: props.globals.getNode("/systems/electrical/sources/idg-3/output-volt"),
			pmgHertz: props.globals.getNode("/systems/electrical/sources/idg-3/pmg-hertz"),
			pmgVolt: props.globals.getNode("/systems/electrical/sources/idg-3/pmg-volt"),
		},
		Si1: {
			volt: props.globals.getNode("/systems/electrical/sources/si-1/output-volt"),
		},
		Tr1: {
			amp: props.globals.getNode("/systems/electrical/sources/tr-1/output-amp"),
			volt: props.globals.getNode("/systems/electrical/sources/tr-1/output-volt"),
		},
		Tr2a: {
			amp: props.globals.getNode("/systems/electrical/sources/tr-2a/output-amp"),
			volt: props.globals.getNode("/systems/electrical/sources/tr-2a/output-volt"),
		},
		Tr2b: {
			amp: props.globals.getNode("/systems/electrical/sources/tr-2b/output-amp"),
			volt: props.globals.getNode("/systems/electrical/sources/tr-2b/output-volt"),
		},
		Tr3: {
			amp: props.globals.getNode("/systems/electrical/sources/tr-3/output-amp"),
			volt: props.globals.getNode("/systems/electrical/sources/tr-3/output-volt"),
		},
	},
	Switch: {
		acTie1: props.globals.getNode("/controls/electrical/switches/ac-tie-1"),
		acTie2: props.globals.getNode("/controls/electrical/switches/ac-tie-2"),
		acTie3: props.globals.getNode("/controls/electrical/switches/ac-tie-3"),
		adgElec: props.globals.getNode("/controls/electrical/switches/adg-elec"),
		apuPwr: props.globals.getNode("/controls/electrical/switches/apu-pwr"),
		battery: props.globals.getNode("/controls/electrical/switches/battery"),
		batteryTemp: 0,
		cabBus: props.globals.getNode("/controls/electrical/switches/cab-bus"),
		dcTie1: props.globals.getNode("/controls/electrical/switches/dc-tie-1"),
		dcTie3: props.globals.getNode("/controls/electrical/switches/dc-tie-3"),
		emerPwSw: props.globals.getNode("/controls/electrical/switches/emer-pw-sw"),
		extPwr: props.globals.getNode("/controls/electrical/switches/ext-pwr"),
		extGPwr: props.globals.getNode("/controls/electrical/switches/extg-pwr"),
		galley1: props.globals.getNode("/controls/electrical/switches/galley-1"),
		galley2: props.globals.getNode("/controls/electrical/switches/galley-2"),
		galley3: props.globals.getNode("/controls/electrical/switches/galley-3"),
		gen1: props.globals.getNode("/controls/electrical/switches/gen-1"),
		gen2: props.globals.getNode("/controls/electrical/switches/gen-2"),
		gen3: props.globals.getNode("/controls/electrical/switches/gen-3"),
		genDrive1: props.globals.getNode("/controls/electrical/switches/gen-drive-1"),
		genDrive2: props.globals.getNode("/controls/electrical/switches/gen-drive-2"),
		genDrive3: props.globals.getNode("/controls/electrical/switches/gen-drive-3"),
		smokeElecAir: props.globals.getNode("/controls/electrical/switches/smoke-elec-air"),
	},
	system: props.globals.getNode("/systems/electrical/system"),
	init: func() {
		me.resetFail();
		me.Switch.acTie1.setBoolValue(1);
		me.Switch.acTie2.setBoolValue(1);
		me.Switch.acTie3.setBoolValue(1);
		me.Switch.adgElec.setBoolValue(0);
		me.Switch.apuPwr.setBoolValue(0);
		me.Switch.battery.setBoolValue(0);
		me.Switch.cabBus.setBoolValue(1);
		me.Switch.dcTie1.setBoolValue(1);
		me.Switch.dcTie3.setBoolValue(1);
		me.Switch.emerPwSw.setValue(0);
		me.Switch.extPwr.setBoolValue(0);
		me.Switch.extGPwr.setBoolValue(0);
		me.Switch.galley1.setBoolValue(1);
		me.Switch.galley2.setBoolValue(1);
		me.Switch.galley3.setBoolValue(1);
		me.Switch.gen1.setBoolValue(1);
		me.Switch.gen2.setBoolValue(1);
		me.Switch.gen3.setBoolValue(1);
		me.Switch.genDrive1.setBoolValue(1);
		me.Switch.genDrive2.setBoolValue(1);
		me.Switch.genDrive3.setBoolValue(1);
		me.Switch.smokeElecAir.setValue(0);
		me.Source.Bat1.percent.setValue(100);
		me.Source.Bat2.percent.setValue(100);
		me.system.setBoolValue(1);
		manualElecLightt.stop();
		me.Light.manualFlash.setValue(0);
		me.Source.Ext.cart.setBoolValue(0);
	},
	resetFail: func() {
		me.Switch.genDrive1.setBoolValue(1);
		me.Switch.genDrive2.setBoolValue(1);
		me.Switch.genDrive3.setBoolValue(1);
		me.Fail.apu.setBoolValue(0);
		me.Fail.bat1.setBoolValue(0);
		me.Fail.bat2.setBoolValue(0);
		me.Fail.gen1.setBoolValue(0);
		me.Fail.gen2.setBoolValue(0);
		me.Fail.gen3.setBoolValue(0);
	},
	loop: func() {
		me.Fail.bat1Temp = me.Fail.bat1.getBoolValue();
		me.Fail.bat2Temp = me.Fail.bat2.getBoolValue();
		me.Misc.elapsedSecTemp = pts.Sim.Time.elapsedSec.getValue();
		me.Source.batChargerPoweredTemp = me.Source.batChargerPowered.getBoolValue();
		me.Source.Bat1.percentTemp = me.Source.Bat1.percent.getValue();
		me.Source.Bat2.percentTemp = me.Source.Bat2.percent.getValue();
		me.Switch.batteryTemp = me.Switch.battery.getBoolValue();
		
		# Battery 1 Charging/Decharging
		if (me.Source.Bat1.percentTemp < 100 and me.Source.batChargerPoweredTemp and me.Switch.batteryTemp and !me.Fail.bat1Temp) {
			if (me.Source.Bat1.time + 5 < me.Misc.elapsedSecTemp) {
				me.Source.Bat1.percentCalc = me.Source.Bat1.percentTemp + 0.75; # Roughly 90 percent every 10 mins
				if (me.Source.Bat1.percentCalc > 100) {
					me.Source.Bat1.percentCalc = 100;
				}
				me.Source.Bat1.percent.setValue(me.Source.Bat1.percentCalc);
				me.Source.Bat1.time = me.Misc.elapsedSecTemp;
			}
		} else if (me.Source.Bat1.percentTemp == 100 and me.Source.batChargerPoweredTemp and me.Switch.batteryTemp and !me.Fail.bat1Temp) {
			me.Source.Bat1.time = me.Misc.elapsedSecTemp;
		} else if (me.Source.Bat1.amp.getValue() > 0 and me.Switch.batteryTemp and !me.Fail.bat1Temp) {
			if (me.Source.Bat1.time + 5 < me.Misc.elapsedSecTemp) {
				me.Source.Bat1.percentCalc = me.Source.Bat1.percentTemp - 0.25; # Roughly 90 percent every 30 mins
				if (me.Source.Bat1.percentCalc < 5) {
					me.Source.Bat1.percentCalc = 5;
				}
				me.Source.Bat1.percent.setValue(me.Source.Bat1.percentCalc);
				me.Source.Bat1.time = me.Misc.elapsedSecTemp;
			}
		} else {
			me.Source.Bat1.time = me.Misc.elapsedSecTemp;
		}
		
		# Battery 2 Charging/Decharging
		if (me.Source.Bat2.percentTemp < 100 and me.Source.batChargerPoweredTemp and me.Switch.batteryTemp and !me.Fail.bat2Temp) {
			if (me.Source.Bat2.time + 5 < me.Misc.elapsedSecTemp) {
				me.Source.Bat2.percentCalc = me.Source.Bat2.percentTemp + 0.75; # Roughly 90 percent every 10 mins
				if (me.Source.Bat2.percentCalc > 100) {
					me.Source.Bat2.percentCalc = 100;
				}
				me.Source.Bat2.percent.setValue(me.Source.Bat2.percentCalc);
				me.Source.Bat2.time = me.Misc.elapsedSecTemp;
			}
		} else if (me.Source.Bat2.percentTemp == 100 and me.Source.batChargerPoweredTemp and me.Switch.batteryTemp and !me.Fail.bat2Temp) {
			me.Source.Bat2.time = me.Misc.elapsedSecTemp;
		} else if (me.Source.Bat2.amp.getValue() > 0 and me.Switch.batteryTemp and !me.Fail.bat2Temp) {
			if (me.Source.Bat2.time + 5 < me.Misc.elapsedSecTemp) {
				me.Source.Bat2.percentCalc = me.Source.Bat2.percentTemp - 0.25; # Roughly 90 percent every 30 mins
				if (me.Source.Bat2.percentCalc < 5) {
					me.Source.Bat2.percentCalc = 5;
				}
				me.Source.Bat2.percent.setValue(me.Source.Bat2.percentCalc);
				me.Source.Bat2.time = me.Misc.elapsedSecTemp;
			}
		} else {
			me.Source.Bat2.time = me.Misc.elapsedSecTemp;
		}
	},
	systemMode: func() {
		if (me.system.getBoolValue()) {
			me.system.setBoolValue(0);
			manualElecLightt.stop();
			me.Light.manualFlash.setValue(0);
		} else {
			me.system.setBoolValue(1);
			manualElecLightt.stop();
			me.Light.manualFlash.setValue(0);
		}
	},
	manualLight: func() {
		me.Light.manualFlashTemp = me.Light.manualFlash.getValue();
		if (me.Light.manualFlashTemp >= 5 or !me.system.getBoolValue()) {
			manualElecLightt.stop();
			me.Light.manualFlash.setValue(0);
		} else {
			me.Light.manualFlash.setValue(me.Light.manualFlashTemp + 1);
		}
	},
};

var manualElecLightt = maketimer(0.4, ELEC, ELEC.manualLight);
