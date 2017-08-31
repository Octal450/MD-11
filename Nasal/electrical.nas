# MD-11 Electrical System
# Joshua Davidson (it0uchpods) and Jonathan Redpath (legoboyvdlp)

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

#############
# Init Vars #
#############

var ac_volt_std = 115;
var ac_volt_min = 110;
var dc_volt_std = 28;
var dc_volt_min = 25;
var dc_amps_std = 150;
var ac_hz_std = 400;

setlistener("/sim/signals/fdm-initialized", func {
	var batt_sw = getprop("/controls/electrical/switches/battery");
	var emer_pw_sw = getprop("/controls/electrical/switches/emer-pw-sw");
	var dc_tie_1_sw = getprop("/controls/electrical/switches/dc-tie-1");
	var dc_tie_3_sw = getprop("/controls/electrical/switches/dc-tie-3");
	var ac_tie_1_sw = getprop("/controls/electrical/switches/ac-tie-1");
	var ac_tie_2_sw = getprop("/controls/electrical/switches/ac-tie-2");
	var ac_tie_3_sw = getprop("/controls/electrical/switches/ac-tie-3");
	var adg_elec = getprop("/controls/electrical/switches/adg_elec");
	var extg_pwr_sw = getprop("/controls/electrical/switches/extg-pwr");
	var ext_pwr_sw = getprop("/controls/electrical/switches/ext-pwr");
	var apu_pwr_sw = getprop("/controls/electrical/switches/apu-pwr");
	var gen1_sw = getprop("/controls/electrical/switches/gen1");
	var gen_drive_1_sw = getprop("/controls/electrical/switches/gen-drive-1");
	var gen2_sw = getprop("/controls/electrical/switches/gen2");
	var gen_drive_2_sw = getprop("/controls/electrical/switches/gen-drive-2");
	var gen3_sw = getprop("/controls/electrical/switches/gen3");
	var gen_drive_3_sw = getprop("/controls/electrical/switches/gen-drive-3");
	var smoke_elecair_sw = getprop("/controls/electrical/switches/smoke-elecair");
	var cab_bus = getprop("/systems/electrical/switches/cab-bus");
	var system = getprop("/systems/electrical/system");
	var bat1_volts = getprop("/systems/electrical/battery1-volts");
	var bat2_volts = getprop("/systems/electrical/battery2-volts");
	var ac1 = getprop("/systems/electrical/bus/ac1");
	var ac2 = getprop("/systems/electrical/bus/ac2");
	var ac3 = getprop("/systems/electrical/bus/ac3");
	var dc1 = getprop("/systems/electrical/bus/dc1");
	var dc2 = getprop("/systems/electrical/bus/dc2");
	var dc3 = getprop("/systems/electrical/bus/dc3");
	var ac_tie = getprop("/systems/electrical/bus/ac-tie");
	var dc_tie = getprop("/systems/electrical/bus/dc-tie");
	var ac_gndsvc = getprop("/systems/electrical/bus/ac-gndsvc");
	var dc_gndsvc = getprop("/systems/electrical/bus/dc-gndsvc");
	var replay = getprop("/sim/replay/replay-state");
	var state1 = getprop("/engines/engine[0]/state");
	var state2 = getprop("/engines/engine[1]/state");
	var state3 = getprop("/engines/engine[2]/state");
});

var elec_init = func {
	setprop("/controls/switches/annun-test", 0);
	setprop("/controls/electrical/switches/battery", 0);
	setprop("/controls/electrical/switches/emer-pw-sw", 0);
	setprop("/controls/electrical/switches/dc-tie-1", 1);
	setprop("/controls/electrical/switches/dc-tie-3", 1);
	setprop("/controls/electrical/switches/ac-tie-1", 1);
	setprop("/controls/electrical/switches/ac-tie-2", 1);
	setprop("/controls/electrical/switches/ac-tie-3", 1);
	setprop("/controls/electrical/switches/adg_elec", 0);
	setprop("/controls/electrical/switches/extg-pwr", 0);
	setprop("/controls/electrical/switches/ext-pwr", 0);
	setprop("/controls/electrical/switches/apu-pwr", 0);
	setprop("/controls/electrical/switches/gen1", 1);
	setprop("/controls/electrical/switches/gen-drive-1", 1);
	setprop("/controls/electrical/switches/gen2", 1);
	setprop("/controls/electrical/switches/gen-drive-2", 1);
	setprop("/controls/electrical/switches/gen3", 1);
	setprop("/controls/electrical/switches/gen-drive-3", 1);
	setprop("/controls/electrical/switches/smoke-elecair", 0);
	setprop("/systems/electrical/switches/cab-bus", 0);
	setprop("/controls/electrical/switches/manual-lt", 0);
	setprop("/controls/electrical/switches/manual-flash", 0);
	setprop("/systems/electrical/system", 0);
	setprop("/systems/electrical/battery1-volts", 25.9);
	setprop("/systems/electrical/battery2-volts", 25.9);
	setprop("/systems/electrical/battery1-amps", 0);
	setprop("/systems/electrical/battery2-amps", 0);
	setprop("/systems/electrical/bus/ac1", 0);
	setprop("/systems/electrical/bus/ac2", 0);
	setprop("/systems/electrical/bus/ac3", 0);
	setprop("/systems/electrical/bus/dc1", 0);
	setprop("/systems/electrical/bus/dc2", 0);
	setprop("/systems/electrical/bus/dc3", 0);
	setprop("/systems/electrical/bus/ac-tie", 0);
	setprop("/systems/electrical/bus/dc-tie", 0);
	setprop("/systems/electrical/bus/ac-gndsvc", 0);
	setprop("/systems/electrical/bus/dc-gndsvc", 0);
	setprop("/systems/electrical/light/bat-bus", 0);
	setprop("/systems/electrical/light/l-emer-ac", 0);
	setprop("/systems/electrical/light/l-emer-dc", 0);
	setprop("/systems/electrical/light/ac1", 0);
	setprop("/systems/electrical/light/ac2", 0);
	setprop("/systems/electrical/light/ac3", 0);
	setprop("/systems/electrical/light/dc1", 0);
	setprop("/systems/electrical/light/dc2", 0);
	setprop("/systems/electrical/light/dc3", 0);
	setprop("/systems/electrical/light/ac-gnd", 0);
	setprop("/systems/electrical/light/dc-gnd", 0);
	setprop("/systems/electrical/light/r-emer-ac", 0);
	setprop("/systems/electrical/light/r-emer-dc", 0);
	setprop("/systems/electrical/light/select-manual", 0);
	manualElecLightt.stop();
	# Below are standard FG Electrical stuff to keep things working when the plane is powered
    setprop("/systems/electrical/outputs/adf", 0);
    setprop("/systems/electrical/outputs/audio-panel", 0);
    setprop("/systems/electrical/outputs/audio-panel[1]", 0);
    setprop("/systems/electrical/outputs/autopilot", 0);
    setprop("/systems/electrical/outputs/avionics-fan", 0);
    setprop("/systems/electrical/outputs/beacon", 0);
    setprop("/systems/electrical/outputs/bus", 0);
    setprop("/systems/electrical/outputs/cabin-lights", 0);
    setprop("/systems/electrical/outputs/dme", 0);
    setprop("/systems/electrical/outputs/efis", 0);
    setprop("/systems/electrical/outputs/flaps", 0);
    setprop("/systems/electrical/outputs/fuel-pump", 0);
    setprop("/systems/electrical/outputs/fuel-pump[1]", 0);
    setprop("/systems/electrical/outputs/gps", 0);
    setprop("/systems/electrical/outputs/gps-mfd", 0);
    setprop("/systems/electrical/outputs/hsi", 0);
    setprop("/systems/electrical/outputs/instr-ignition-switch", 0);
    setprop("/systems/electrical/outputs/instrument-lights", 0);
    setprop("/systems/electrical/outputs/landing-lights", 0);
    setprop("/systems/electrical/outputs/map-lights", 0);
    setprop("/systems/electrical/outputs/mk-viii", 0);
    setprop("/systems/electrical/outputs/nav", 0);
    setprop("/systems/electrical/outputs/nav[1]", 0);
    setprop("/systems/electrical/outputs/nav[2]", 0);
    setprop("/systems/electrical/outputs/nav[3]", 0);
    setprop("/systems/electrical/outputs/pitot-head", 0);
    setprop("/systems/electrical/outputs/stobe-lights", 0);
    setprop("/systems/electrical/outputs/tacan", 0);
    setprop("/systems/electrical/outputs/taxi-lights", 0);
    setprop("/systems/electrical/outputs/transponder", 0);
    setprop("/systems/electrical/outputs/turn-coordinator", 0);
	elec_timer.start();
}

######################
# Main Electric Loop #
######################

var master_elec = func {
	batt_sw = getprop("/controls/electrical/switches/battery");
	emer_pw_sw = getprop("/controls/electrical/switches/emer-pw-sw");
	dc_tie_1_sw = getprop("/controls/electrical/switches/dc-tie-1");
	dc_tie_3_sw = getprop("/controls/electrical/switches/dc-tie-3");
	ac_tie_1_sw = getprop("/controls/electrical/switches/ac-tie-1");
	ac_tie_2_sw = getprop("/controls/electrical/switches/ac-tie-2");
	ac_tie_3_sw = getprop("/controls/electrical/switches/ac-tie-3");
	adg_elec = getprop("/controls/electrical/switches/adg_elec");
	extg_pwr_sw = getprop("/controls/electrical/switches/extg-pwr");
	ext_pwr_sw = getprop("/controls/electrical/switches/ext-pwr");
	apu_pwr_sw = getprop("/controls/electrical/switches/apu-pwr");
	gen1_sw = getprop("/controls/electrical/switches/gen1");
	gen_drive_1_sw = getprop("/controls/electrical/switches/gen-drive-1");
	gen2_sw = getprop("/controls/electrical/switches/gen2");
	gen_drive_2_sw = getprop("/controls/electrical/switches/gen-drive-2");
	gen3_sw = getprop("/controls/electrical/switches/gen3");
	gen_drive_3_sw = getprop("/controls/electrical/switches/gen-drive-3");
	smoke_elecair_sw = getprop("/controls/electrical/switches/smoke-elecair");
	cab_bus = getprop("/systems/electrical/switches/cab-bus");
	system = getprop("/systems/electrical/system");
	bat1_volts = getprop("/systems/electrical/battery1-volts");
	bat2_volts = getprop("/systems/electrical/battery2-volts");
	ac1 = getprop("/systems/electrical/bus/ac1");
	ac2 = getprop("/systems/electrical/bus/ac2");
	ac3 = getprop("/systems/electrical/bus/ac3");
	dc1 = getprop("/systems/electrical/bus/dc1");
	dc2 = getprop("/systems/electrical/bus/dc2");
	dc3 = getprop("/systems/electrical/bus/dc3");
	ac_tie = getprop("/systems/electrical/bus/ac-tie");
	dc_tie = getprop("/systems/electrical/bus/dc-tie");
	ac_gndsvc = getprop("/systems/electrical/bus/ac-gndsvc");
	dc_gndsvc = getprop("/systems/electrical/bus/dc-gndsvc");
	replay = getprop("/sim/replay/replay-state");
	state1 = getprop("/engines/engine[0]/state");
	state2 = getprop("/engines/engine[1]/state");
	state3 = getprop("/engines/engine[2]/state");
}

var systemElecMode = func {
	system = getprop("/systems/electrical/system");
	if (system) {
		setprop("/systems/electrical/system", 0);
		setprop("/controls/electrical/switches/manual-lt", 1);
	} else {
		setprop("/systems/electrical/system", 1);
		setprop("/controls/electrical/switches/manual-lt", 0);
	}
}

var manualElecLight = func {
	var manl = getprop("/controls/electrical/switches/manual-flash");
	if (manl >= 5) {
		manualHydLightt.stop();
		setprop("/controls/electrical/switches/manual-flash", 0);
	} else {
		setprop("/controls/electrical/switches/manual-flash", manl + 1);
	}
}

###################
# Update Function #
###################

var update_electrical = func {
	master_elec();
}

##########
# Timers #
##########

var elec_timer = maketimer(0.2, update_electrical);
var manualElecLightt = maketimer(0.4, manualElecLight);
