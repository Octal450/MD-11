# McDonnell Douglas MD-11 Electrical System
# Copyright (c) 2024 Josh Davidson (Octal450)

var ELEC = {
	Bus: {
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
	Epcu: {
		allowApu: props.globals.getNode("/systems/electrical/epcu/allow-apu-out"),
	},
	Fail: {
		acTie1: props.globals.getNode("/systems/failures/electrical/ac-tie-1"),
		acTie2: props.globals.getNode("/systems/failures/electrical/ac-tie-2"),
		acTie3: props.globals.getNode("/systems/failures/electrical/ac-tie-3"),
		apu: props.globals.getNode("/systems/failures/electrical/apu"),
		battery: props.globals.getNode("/systems/failures/electrical/battery"),
		dcTie1: props.globals.getNode("/systems/failures/electrical/dc-tie-1"),
		dcTie3: props.globals.getNode("/systems/failures/electrical/dc-tie-3"),
		gen1: props.globals.getNode("/systems/failures/electrical/gen-1"),
		gen2: props.globals.getNode("/systems/failures/electrical/gen-2"),
		gen3: props.globals.getNode("/systems/failures/electrical/gen-3"),
		system: props.globals.getNode("/systems/failures/electrical/system"),
	},
	Generic: {
		efis: props.globals.initNode("/systems/electrical/outputs/efis", 0, "DOUBLE"),
		fcp: props.globals.initNode("/systems/electrical/outputs/fcp", 0, "DOUBLE"),
	},
	Light: {
		manualFlash: props.globals.initNode("/controls/electrical/lights/manual-flash", 0, "INT"),
		manualFlashTemp: 0,
	},
	Source: {
		Adg: {
			hertz: props.globals.getNode("/systems/electrical/sources/adg/output-hertz"),
			volt: props.globals.getNode("/systems/electrical/sources/adg/output-volt"),
		},
		Apu: {
			hertz: props.globals.getNode("/systems/electrical/sources/apu/output-hertz"),
			pmgHertz: props.globals.getNode("/systems/electrical/sources/apu/pmg-hertz"),
			pmgVolt: props.globals.getNode("/systems/electrical/sources/apu/pmg-volt"),
			volt: props.globals.getNode("/systems/electrical/sources/apu/output-volt"),
		},
		Bat1: {
			amp: props.globals.getNode("/systems/electrical/sources/bat-1/amp"),
			percent: props.globals.getNode("/systems/electrical/sources/bat-1/percent"),
			volt: props.globals.getNode("/systems/electrical/sources/bat-1/volt"),
		},
		Bat2: {
			amp: props.globals.getNode("/systems/electrical/sources/bat-2/amp"),
			percent: props.globals.getNode("/systems/electrical/sources/bat-2/percent"),
			volt: props.globals.getNode("/systems/electrical/sources/bat-2/volt"),
		},
		batChargerPowered: props.globals.getNode("/systems/electrical/sources/bat-charger-powered"),
		Ext: {
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
		cabBus: props.globals.getNode("/controls/electrical/switches/cab-bus"),
		dcTie1: props.globals.getNode("/controls/electrical/switches/dc-tie-1"),
		dcTie3: props.globals.getNode("/controls/electrical/switches/dc-tie-3"),
		emerPwr: props.globals.getNode("/controls/electrical/switches/emer-pwr"),
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
		groundCart: props.globals.getNode("/controls/electrical/switches/ground-cart"),
		smokeElecAir: props.globals.getNode("/controls/electrical/switches/smoke-elec-air"),
		system: props.globals.getNode("/controls/electrical/switches/system"),
	},
	system: props.globals.getNode("/systems/electrical/system"),
	init: func() {
		me.resetFailures();
		me.Switch.acTie1.setBoolValue(1);
		me.Switch.acTie2.setBoolValue(1);
		me.Switch.acTie3.setBoolValue(1);
		me.Switch.adgElec.setBoolValue(0);
		me.Switch.apuPwr.setBoolValue(0);
		me.Switch.battery.setBoolValue(0);
		me.Switch.cabBus.setBoolValue(1);
		me.Switch.dcTie1.setBoolValue(1);
		me.Switch.dcTie3.setBoolValue(1);
		me.Switch.emerPwr.setValue(0);
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
		me.Switch.groundCart.setBoolValue(0);
		me.Switch.smokeElecAir.setValue(0);
		me.Switch.system.setBoolValue(1);
		me.Source.Bat1.percent.setValue(99.9);
		me.Source.Bat2.percent.setValue(99.9);
		manualElecLightt.stop();
		me.Light.manualFlash.setValue(0);
	},
	resetFailures: func() {
		me.Switch.genDrive1.setBoolValue(1);
		me.Switch.genDrive2.setBoolValue(1);
		me.Switch.genDrive3.setBoolValue(1);
		me.Fail.acTie1.setBoolValue(0);
		me.Fail.acTie2.setBoolValue(0);
		me.Fail.acTie3.setBoolValue(0);
		me.Fail.apu.setBoolValue(0);
		me.Fail.battery.setBoolValue(0);
		me.Fail.dcTie1.setBoolValue(0);
		me.Fail.dcTie3.setBoolValue(0);
		me.Fail.gen1.setBoolValue(0);
		me.Fail.gen2.setBoolValue(0);
		me.Fail.gen3.setBoolValue(0);
		me.Fail.system.setBoolValue(0);
	},
	systemMode: func() {
		if (me.Switch.system.getBoolValue()) {
			me.Switch.system.setBoolValue(0);
			manualElecLightt.stop();
			me.Light.manualFlash.setValue(0);
		} else {
			me.Switch.system.setBoolValue(1);
			manualElecLightt.stop();
			me.Light.manualFlash.setValue(0);
		}
	},
	manualLight: func() {
		me.Light.manualFlashTemp = me.Light.manualFlash.getValue();
		if (me.Light.manualFlashTemp >= 5 or !me.Switch.system.getBoolValue()) {
			manualElecLightt.stop();
			me.Light.manualFlash.setValue(0);
		} else {
			me.Light.manualFlash.setValue(me.Light.manualFlashTemp + 1);
		}
	},
};

var manualElecLightt = maketimer(0.4, ELEC, ELEC.manualLight);
