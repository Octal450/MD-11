# McDonnell Douglas MD-11 Electrical System
# Copyright (c) 2019 Joshua Davidson (it0uchpods)

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
		dc1: props.globals.getNode("/systems/electrical/bus/dc-1"),
		dc2: props.globals.getNode("/systems/electrical/bus/dc-2"),
		dc3: props.globals.getNode("/systems/electrical/bus/dc-3"),
		dcBat: props.globals.getNode("/systems/electrical/bus/dc-bat"),
		dcBatDirect: props.globals.getNode("/systems/electrical/bus/dc-bat-direct"),
		dcGndSvc: props.globals.getNode("/systems/electrical/bus/dc-gndsvc"),
		dcTie: props.globals.getNode("/systems/electrical/bus/dc-tie"),
		galley1: props.globals.getNode("/systems/electrical/bus/galley-1"),
		galley2: props.globals.getNode("/systems/electrical/bus/galley-2"),
		galley3: props.globals.getNode("/systems/electrical/bus/galley-3"),
		lEmerAc: props.globals.getNode("/systems/electrical/bus/l-emer-ac"),
		lEmerDc: props.globals.getNode("/systems/electrical/bus/l-emer-dc"),
		lEmerSi: props.globals.getNode("/systems/electrical/bus/l-emer-si"),
		rEmerAc: props.globals.getNode("/systems/electrical/bus/r-emer-ac"),
		rEmerDc: props.globals.getNode("/systems/electrical/bus/r-emer-dc"),
	},
	Fail: {
		gen1: props.globals.getNode("/systems/failures/elec-gen1", 1),
		gen2: props.globals.getNode("/systems/failures/elec-gen2", 1),
		gen3: props.globals.getNode("/systems/failures/elec-gen3", 1),
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
	Source: {
		Apu: {
			hertz: props.globals.getNode("/systems/electrical/sources/apu/output-hertz"),
			volt: props.globals.getNode("/systems/electrical/sources/apu/output-volt"),
		},
		Bat1: {
			percent: props.globals.getNode("/systems/electrical/sources/bat1/percent", 1),
			volt: props.globals.getNode("/systems/electrical/sources/bat1/volts", 1),
		},
		Bat2: {
			percent: props.globals.getNode("/systems/electrical/sources/bat2/percent", 1),
			volt: props.globals.getNode("/systems/electrical/sources/bat2/volts", 1),
		},
		Ext: {
			hertz: props.globals.getNode("/systems/electrical/sources/ext/output-hertz"),
			hertzGalley: props.globals.getNode("/systems/electrical/sources/ext/output-galley-hertz"),
			volt: props.globals.getNode("/systems/electrical/sources/ext/output-volt"),
			voltGalley: props.globals.getNode("/systems/electrical/sources/ext/output-galley-volt"),
		},
		Idg1: {
			hertz: props.globals.getNode("/systems/electrical/sources/idg1/output-hertz"),
			volt: props.globals.getNode("/systems/electrical/sources/idg1/output-volt"),
		},
		Idg2: {
			hertz: props.globals.getNode("/systems/electrical/sources/idg2/output-hertz"),
			volt: props.globals.getNode("/systems/electrical/sources/idg2/output-volt"),
		},
		Idg3: {
			hertz: props.globals.getNode("/systems/electrical/sources/idg3/output-hertz"),
			volt: props.globals.getNode("/systems/electrical/sources/idg3/output-volt"),
		},
		Si1: {
			volt: props.globals.getNode("/systems/electrical/sources/si1/output-volt"),
		},
		Tr1: {
			volt: props.globals.getNode("/systems/electrical/sources/tr1/output-volt"),
		},
		Tr2A: {
			volt: props.globals.getNode("/systems/electrical/sources/tr2a/output-volt"),
		},
		Tr2B: {
			volt: props.globals.getNode("/systems/electrical/sources/tr2b/output-volt"),
		},
		Tr3: {
			volt: props.globals.getNode("/systems/electrical/sources/tr3/output-volt"),
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
		manualFlash: props.globals.initNode("/controls/electrical/switches/manual-flash", 0, "INT"),
		manualFlashTemp: 0,
		smokeElecAir: props.globals.getNode("/controls/electrical/switches/smoke-elec-air"),
	},
	system: props.globals.getNode("/systems/electrical/system"),
	init: func() {
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
		me.Source.Bat1.percent.setValue(55);
		me.Source.Bat2.percent.setValue(55);
		me.system.setBoolValue(1);
		manualElecLightt.stop();
		me.Switch.manualFlash.setValue(0);
	},
	loop: func() {
		
	},
	systemMode: func() {
		if (me.system.getBoolValue()) {
			me.system.setBoolValue(0);
			manualElecLightt.stop();
			me.Switch.manualFlash.setValue(0);
		} else {
			me.system.setBoolValue(1);
			manualElecLightt.stop();
			me.Switch.manualFlash.setValue(0);
		}
	},
	manualLight: func() {
		me.Switch.manualFlashTemp = me.Switch.manualFlash.getValue();
		if (me.Switch.manualFlashTemp >= 5 or !me.system.getBoolValue()) {
			manualElecLightt.stop();
			me.Switch.manualFlash.setValue(0);
		} else {
			me.Switch.manualFlash.setValue(me.Switch.manualFlashTemp + 1);
		}
	},
};

var manualElecLightt = maketimer(0.4, ELEC, ELEC.manualLight);
