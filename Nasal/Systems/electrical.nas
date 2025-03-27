# McDonnell Douglas MD-11 Electrical
# Copyright (c) 2025 Josh Davidson (Octal450)

var ELECTRICAL = {
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
		dcBatPre: props.globals.getNode("/systems/electrical/bus/dc-bat-pre"),
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
		splitBuses: props.globals.getNode("/systems/electrical/epcu/split-buses"),
	},
	Outputs: {
		efis: props.globals.initNode("/systems/electrical/outputs/efis", 0, "DOUBLE"),
		fcp: props.globals.initNode("/systems/electrical/outputs/fcp", 0, "DOUBLE"),
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
	system: props.globals.getNode("/systems/electrical/system"),
	Controls: {
		acTie1: props.globals.getNode("/controls/electrical/ac-tie-1"),
		acTie2: props.globals.getNode("/controls/electrical/ac-tie-2"),
		acTie3: props.globals.getNode("/controls/electrical/ac-tie-3"),
		adgElec: props.globals.getNode("/controls/electrical/adg-elec"),
		apuPwr: props.globals.getNode("/controls/electrical/apu-pwr"),
		battery: props.globals.getNode("/controls/electrical/battery"),
		cabBus: props.globals.getNode("/controls/electrical/cab-bus"),
		dcTie1: props.globals.getNode("/controls/electrical/dc-tie-1"),
		dcTie3: props.globals.getNode("/controls/electrical/dc-tie-3"),
		emerPwr: props.globals.getNode("/controls/electrical/emer-pwr"),
		extPwr: props.globals.getNode("/controls/electrical/ext-pwr"),
		extGPwr: props.globals.getNode("/controls/electrical/extg-pwr"),
		galley1: props.globals.getNode("/controls/electrical/galley-1"),
		galley2: props.globals.getNode("/controls/electrical/galley-2"),
		galley3: props.globals.getNode("/controls/electrical/galley-3"),
		gen1: props.globals.getNode("/controls/electrical/gen-1"),
		gen2: props.globals.getNode("/controls/electrical/gen-2"),
		gen3: props.globals.getNode("/controls/electrical/gen-3"),
		genDrive1: props.globals.getNode("/controls/electrical/gen-drive-1"),
		genDrive2: props.globals.getNode("/controls/electrical/gen-drive-2"),
		genDrive3: props.globals.getNode("/controls/electrical/gen-drive-3"),
		groundCart: props.globals.getNode("/controls/electrical/ground-cart"),
		smokeElecAir: props.globals.getNode("/controls/electrical/smoke-elec-air"),
		system: props.globals.getNode("/controls/electrical/system"),
	},
	Failures: {
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
	Lights: {
		manualFlash: props.globals.initNode("/systems/electrical/lights/manual-flash", 0, "INT"),
		manualFlashTemp: 0,
	},
	init: func() {
		me.resetFailures();
		me.Controls.acTie1.setBoolValue(1);
		me.Controls.acTie2.setBoolValue(1);
		me.Controls.acTie3.setBoolValue(1);
		me.Controls.adgElec.setBoolValue(0);
		me.Controls.apuPwr.setBoolValue(0);
		me.Controls.battery.setBoolValue(0);
		me.Controls.cabBus.setBoolValue(1);
		me.Controls.dcTie1.setBoolValue(1);
		me.Controls.dcTie3.setBoolValue(1);
		me.Controls.emerPwr.setValue(0);
		me.Controls.extPwr.setBoolValue(0);
		me.Controls.extGPwr.setBoolValue(0);
		me.Controls.galley1.setBoolValue(1);
		me.Controls.galley2.setBoolValue(1);
		me.Controls.galley3.setBoolValue(1);
		me.Controls.gen1.setBoolValue(1);
		me.Controls.gen2.setBoolValue(1);
		me.Controls.gen3.setBoolValue(1);
		me.Controls.genDrive1.setBoolValue(1);
		me.Controls.genDrive2.setBoolValue(1);
		me.Controls.genDrive3.setBoolValue(1);
		me.Controls.groundCart.setBoolValue(0);
		me.Controls.smokeElecAir.setValue(0);
		me.Controls.system.setBoolValue(1);
		me.Epcu.splitBuses.setBoolValue(0);
		me.Source.Bat1.percent.setValue(99.9);
		me.Source.Bat2.percent.setValue(99.9);
		manualElecLightt.stop();
		me.Lights.manualFlash.setValue(0);
	},
	resetFailures: func() {
		me.Controls.genDrive1.setBoolValue(1);
		me.Controls.genDrive2.setBoolValue(1);
		me.Controls.genDrive3.setBoolValue(1);
		me.Failures.acTie1.setBoolValue(0);
		me.Failures.acTie2.setBoolValue(0);
		me.Failures.acTie3.setBoolValue(0);
		me.Failures.apu.setBoolValue(0);
		me.Failures.battery.setBoolValue(0);
		me.Failures.dcTie1.setBoolValue(0);
		me.Failures.dcTie3.setBoolValue(0);
		me.Failures.gen1.setBoolValue(0);
		me.Failures.gen2.setBoolValue(0);
		me.Failures.gen3.setBoolValue(0);
		me.Failures.system.setBoolValue(0);
	},
	systemMode: func() {
		if (me.Controls.system.getBoolValue()) {
			me.Controls.system.setBoolValue(0);
			manualElecLightt.stop();
			me.Lights.manualFlash.setValue(0);
		} else {
			me.Controls.system.setBoolValue(1);
			manualElecLightt.stop();
			me.Lights.manualFlash.setValue(0);
		}
	},
	manualLight: func() {
		me.Lights.manualFlashTemp = me.Lights.manualFlash.getValue();
		if (me.Lights.manualFlashTemp >= 5 or !me.Controls.system.getBoolValue()) {
			manualElecLightt.stop();
			me.Lights.manualFlash.setValue(0);
		} else {
			me.Lights.manualFlash.setValue(me.Lights.manualFlashTemp + 1);
		}
	},
};

var manualElecLightt = maketimer(0.4, ELECTRICAL, ELECTRICAL.manualLight);
