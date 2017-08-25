# MD-11 Main Libraries
# Joshua Davidson (it0uchpods)

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

var update_tilt = maketimer(0.1, func {
	var comp1 = getprop("/gear/gear[1]/compression-norm");
	if (comp1 > 0) {
		var pitchdeg1 = getprop("/orientation/pitch-deg");
		setprop("/gear/gear[1]/angle-deg", pitchdeg1);
	} else {
		setprop("/gear/gear[1]/angle-deg", "0");
	}
	var comp2 = getprop("/gear/gear[2]/compression-norm");
	if (comp2 > 0) {
		var pitchdeg2 = getprop("/orientation/pitch-deg");
		setprop("/gear/gear[2]/angle-deg", pitchdeg2);
	} else {
		setprop("/gear/gear[2]/angle-deg", "0");
	}
});

setlistener("/controls/gear/gear-down", func {
	down = getprop("/controls/gear/gear-down");
	if (!down and (getprop("/gear/gear[0]/wow") or getprop("/gear/gear[1]/wow") or getprop("/gear/gear[2]/wow"))) {
		setprop("/controls/gear/gear-down", 1);
	}
});

setlistener("sim/signals/fdm-initialized", func {
	update_tilt.start();
	librariesLoop.start();
	afs.ap_init();
	var autopilot = gui.Dialog.new("sim/gui/dialogs/autopilot/dialog", "Aircraft/MD-11Family/Systems/autopilot-dlg.xml");
});

var librariesLoop = maketimer(0.05, func {
	if (getprop("/velocities/groundspeed-kt") > 15) {
		setprop("/systems/shake/effect", 1);
	} else {
		setprop("/systems/shake/effect", 0);
	}
	
	if ((getprop("/sim/replay/time") == 0) or (getprop("/sim/replay/time") == nil)) {
		setprop("/aircraft/wingflex-enable", 1);
	} else {
		setprop("/aircraft/wingflex-enable", 0);
	}
});

var aglgears = func {
    var agl = getprop("/position/altitude-agl-ft") or 0;
    var aglft = agl - 15.34;  # is the position from the MD-11 above ground
    var aglm = aglft * 0.3048;
    setprop("/position/gear-agl-ft", aglft);
    setprop("/position/gear-agl-m", aglm);

    settimer(aglgears, 0.01);
}

aglgears();

setprop("/controls/flight/flap-lever", 0);

controls.flapsDown = func(step) {
	if (step == 1) {
		if (getprop("/controls/flight/flap-lever") == 0) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 0.000);
			setprop("/controls/flight/flap-lever", 1);
			setprop("/controls/flight/flaps", 0.0);
			return;
		} else if (getprop("/controls/flight/flap-lever") == 1) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 0.310);
			setprop("/controls/flight/flap-lever", 2);
			setprop("/controls/flight/flaps", 0.4);
			return;
		} else if (getprop("/controls/flight/flap-lever") == 2) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 0.580);
			setprop("/controls/flight/flap-lever", 3);
			setprop("/controls/flight/flaps", 0.7);
			return;
		} else if (getprop("/controls/flight/flap-lever") == 3) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 0.700);
			setprop("/controls/flight/flap-lever", 4);
			setprop("/controls/flight/flaps", 1.0);
			return;
		} else if (getprop("/controls/flight/flap-lever") == 4) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 1.000);
			setprop("/controls/flight/flap-lever", 5);
			setprop("/controls/flight/flaps", 1.0);
			return;
		}
	} else if (step == -1) {
		if (getprop("/controls/flight/flap-lever") == 5) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 0.700);
			setprop("/controls/flight/flap-lever", 4);
			setprop("/controls/flight/flaps", 1.0);
			return;
		} else if (getprop("/controls/flight/flap-lever") == 4) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 0.580);
			setprop("/controls/flight/flap-lever", 3);
			setprop("/controls/flight/flaps", 7.0);
			return;
		} else if (getprop("/controls/flight/flap-lever") == 3) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 0.310);
			setprop("/controls/flight/flap-lever", 2);
			setprop("/controls/flight/flaps", 0.4);
			return;
		} else if (getprop("/controls/flight/flap-lever") == 2) {
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flaps-output", 0.000);
			setprop("/controls/flight/flap-lever", 1);
			setprop("/controls/flight/flaps", 0.0);
			return;
		} else if (getprop("/controls/flight/flap-lever") == 1) {
			setprop("/controls/flight/slats", 0.000);
			setprop("/controls/flight/flaps-output", 0.000);
			setprop("/controls/flight/flap-lever", 0);
			setprop("/controls/flight/flaps", 0.0);
			return;
		}
	} else {
		return 0;
	}
}
