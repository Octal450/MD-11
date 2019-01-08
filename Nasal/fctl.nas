# MD-11 Flight Control System

# Copyright (c) 2019 Joshua Davidson (it0uchpods)

var IAS = 0;
var Mach = 0;
var flap = 0;
var gear = 0;
var mmoIAS = 0;
var slatIAS = 0;
var flapIAS = 0;
var sys1_psi = 0;
var sys2_psi = 0;
var sys3_psi = 0;
var dc1 = 0;
var dc2 = 0;
var dc3 = 0;
var l_emer_dc = 0;
var r_emer_dc = 0;
var lsas_lo_fail = 0;
var lsas_li_fail = 0;
var lsas_ri_fail = 0;
var lsas_ro_fail = 0;
var yd_upra_fail = 0;
var yd_uprb_fail = 0;
var yd_lwra_fail = 0;
var yd_lwrb_fail = 0;
var gearMax = 300;
var slatMax = 280;
var flap0_15Max = 255;
var flap15_20Max = 240;
var flap20_25Max = 220;
var flap28Max = 210;
var flap35Max = 190;
var flap50Max = 175;
var flapLimKnob = 0;
setprop("/controls/fctl/vmo-mmo", 365);
setprop("/controls/fctl/flap-gear-max", 300);

var FCTL = {
	init: func() {
		setprop("/controls/fctl/lsas/left-out", 1);
		setprop("/controls/fctl/lsas/left-in", 1);
		setprop("/controls/fctl/lsas/right-in", 1);
		setprop("/controls/fctl/lsas/right-out", 1);
		setprop("/controls/fctl/lsas/feel-knob", 0);
		setprop("/controls/fctl/lsas/feel-man", 0);
		setprop("/controls/fctl/yd/upper-a", 1);
		setprop("/controls/fctl/yd/upper-b", 1);
		setprop("/controls/fctl/yd/lower-a", 1);
		setprop("/controls/fctl/yd/lower-b", 1);
		setprop("/controls/fctl/flap/limit-knob", 0);
		setprop("/controls/fctl/lsas/light/left-out-fail", 1);
		setprop("/controls/fctl/lsas/light/left-in-fail", 1);
		setprop("/controls/fctl/lsas/light/right-in-fail", 1);
		setprop("/controls/fctl/lsas/light/right-out-fail", 1);
		setprop("/controls/fctl/lsas/light/manual", 0);
		setprop("/controls/fctl/yd/light/upper-a-fail", 1);
		setprop("/controls/fctl/yd/light/upper-b-fail", 1);
		setprop("/controls/fctl/yd/light/lower-a-fail", 1);
		setprop("/controls/fctl/yd/light/lower-b-fail", 1);
		setprop("/controls/fctl/flap/light/manual", 0);
		setprop("/fdm/jsbsim/fcc/lsas/left-out-active", 0);
		setprop("/fdm/jsbsim/fcc/lsas/left-in-active", 0);
		setprop("/fdm/jsbsim/fcc/lsas/right-in-active", 0);
		setprop("/fdm/jsbsim/fcc/lsas/right-out-active", 0);
		setprop("/fdm/jsbsim/fcc/yaw/avail-upr", 0);
		setprop("/fdm/jsbsim/fcc/yaw/avail-lwr", 0);
		setprop("/fdm/jsbsim/fcc/flap/max-deg", 50);
	},
	loop: func() {
		sys1_psi = getprop("/systems/hydraulic/sys1-psi");
		sys2_psi = getprop("/systems/hydraulic/sys2-psi");
		sys3_psi = getprop("/systems/hydraulic/sys3-psi");
		dc1 = getprop("/systems/electrical/bus/dc1");
		dc2 = getprop("/systems/electrical/bus/dc2");
		dc3 = getprop("/systems/electrical/bus/dc3");
		l_emer_dc = getprop("/systems/electrical/bus/l-emer-dc");
		r_emer_dc = getprop("/systems/electrical/bus/r-emer-dc");
		lsas_lo_fail = getprop("/systems/failures/lsas-l-out");
		lsas_li_fail = getprop("/systems/failures/lsas-l-in");
		lsas_ri_fail = getprop("/systems/failures/lsas-r-in");
		lsas_ro_fail = getprop("/systems/failures/lsas-r-out");
		yd_upra_fail = getprop("/systems/failures/yawdamp-upr-a");
		yd_uprb_fail = getprop("/systems/failures/yawdamp-upr-b");
		yd_lwra_fail = getprop("/systems/failures/yawdamp-lwr-a");
		yd_lwrb_fail = getprop("/systems/failures/yawdamp-lwr-b");
		elevFeelFail = getprop("/systems/failures/elev-feel");
		flapLimFail = getprop("/systems/failures/flap-limit");
		
		# ELEV FEEL MAN
		if (l_emer_dc >= 25 or r_emer_dc >= 25 or dc1 >= 25 or dc2 >= 25 or dc3 >= 25) {
			setprop("/fdm/jsbsim/fcc/lsas/elevator-feel-pwr", 1);
		} else {
			setprop("/fdm/jsbsim/fcc/lsas/elevator-feel-pwr", 0);
		}
		
		if (getprop("/controls/fctl/lsas/feel-man") != 1 and (l_emer_dc >= 25 or r_emer_dc >= 25 or dc1 >= 25 or dc2 >= 25 or dc3 >= 25) and !elevFeelFail) {
			setprop("/fdm/jsbsim/fcc/lsas/elevator-feel-auto", 1);
		} else {
			setprop("/fdm/jsbsim/fcc/lsas/elevator-feel-auto", 0);
		}
		
		# L OUTBD LSAS
		if (getprop("/controls/fctl/lsas/left-out") == 1 and (sys1_psi >= 1500 or sys2_psi >= 1500) and dc3 >= 25 and !lsas_lo_fail) {
			setprop("/fdm/jsbsim/fcc/lsas/left-out-active", 1);
		} else {
			setprop("/fdm/jsbsim/fcc/lsas/left-out-active", 0);
		}
		
		# L INBD LSAS
		if (getprop("/controls/fctl/lsas/left-in") == 1 and (sys2_psi >= 1500 or sys3_psi >= 1500) and l_emer_dc >= 25 and !lsas_li_fail) {
			setprop("/fdm/jsbsim/fcc/lsas/left-in-active", 1);
		} else {
			setprop("/fdm/jsbsim/fcc/lsas/left-in-active", 0);
		}
		
		# R INBD LSAS
		if (getprop("/controls/fctl/lsas/right-in") == 1 and (sys1_psi >= 1500 or sys3_psi >= 1500) and r_emer_dc >= 25 and !lsas_ri_fail) {
			setprop("/fdm/jsbsim/fcc/lsas/right-in-active", 1);
		} else {
			setprop("/fdm/jsbsim/fcc/lsas/right-in-active", 0);
		}
		
		# R OUTBD LSAS
		if (getprop("/controls/fctl/lsas/right-out") == 1 and (sys1_psi >= 1500 or sys2_psi >= 1500) and dc1 >= 25 and !lsas_ro_fail) {
			setprop("/fdm/jsbsim/fcc/lsas/right-out-active", 1);
		} else {
			setprop("/fdm/jsbsim/fcc/lsas/right-out-active", 0);
		}
		
		# UPR YD
		if (getprop("/controls/fctl/yd/upper-a") == 1 and sys1_psi >= 1500 and dc3 >= 25 and !yd_upra_fail) {
			setprop("/fdm/jsbsim/fcc/yaw/avail-upr", 1);
		} else if (getprop("/controls/fctl/yd/upper-b") == 1 and sys1_psi >= 1500 and dc3 >= 25 and !yd_uprb_fail) {
			setprop("/fdm/jsbsim/fcc/yaw/avail-upr", 1);
		} else {
			setprop("/fdm/jsbsim/fcc/yaw/avail-upr", 0);
		}
		
		# LWR YD
		if (getprop("/controls/fctl/yd/lower-a") == 1 and sys2_psi >= 1500 and dc1 >= 25 and !yd_lwra_fail) {
			setprop("/fdm/jsbsim/fcc/yaw/avail-lwr", 1);
		} else if (getprop("/controls/fctl/yd/lower-b") == 1 and sys2_psi >= 1500 and dc1 >= 25 and !yd_lwrb_fail) {
			setprop("/fdm/jsbsim/fcc/yaw/avail-lwr", 1);
		} else {
			setprop("/fdm/jsbsim/fcc/yaw/avail-lwr", 0);
		}
		
		# Fault lights
		if (getprop("/controls/fctl/lsas/left-out") == 1 and lsas_lo_fail) {
			setprop("/controls/fctl/lsas/light/left-out-fail", 1);
		} else {
			setprop("/controls/fctl/lsas/light/left-out-fail", 0);
		}
		
		if (getprop("/controls/fctl/lsas/left-in") == 1 and lsas_li_fail) {
			setprop("/controls/fctl/lsas/light/left-in-fail", 1);
		} else {
			setprop("/controls/fctl/lsas/light/left-in-fail", 0);
		}
		
		if (getprop("/controls/fctl/lsas/right-in") == 1 and lsas_ri_fail) {
			setprop("/controls/fctl/lsas/light/right-in-fail", 1);
		} else {
			setprop("/controls/fctl/lsas/light/right-in-fail", 0);
		}
		
		if (getprop("/controls/fctl/lsas/right-out") == 1 and lsas_ro_fail) {
			setprop("/controls/fctl/lsas/light/right-out-fail", 1);
		} else {
			setprop("/controls/fctl/lsas/light/right-out-fail", 0);
		}
		
		if (getprop("/controls/fctl/yd/upper-a") == 1 and yd_upra_fail) {
			setprop("/controls/fctl/yd/light/upper-a-fail", 1);
		} else {
			setprop("/controls/fctl/yd/light/upper-a-fail", 0);
		}
		
		if (getprop("/controls/fctl/yd/upper-b") == 1 and yd_uprb_fail) {
			setprop("/controls/fctl/yd/light/upper-b-fail", 1);
		} else {
			setprop("/controls/fctl/yd/light/upper-b-fail", 0);
		}
		
		if (getprop("/controls/fctl/yd/lower-a") == 1 and yd_lwra_fail) {
			setprop("/controls/fctl/yd/light/lower-a-fail", 1);
		} else {
			setprop("/controls/fctl/yd/light/lower-a-fail", 0);
		}
		
		if (getprop("/controls/fctl/yd/lower-b") == 1 and yd_lwrb_fail) {
			setprop("/controls/fctl/yd/light/lower-b-fail", 1);
		} else {
			setprop("/controls/fctl/yd/light/lower-b-fail", 0);
		}
		
		# Max Speed Calculations
		IAS = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt");
		Mach = getprop("/instrumentation/airspeed-indicator/indicated-mach");
		
		# VMO MMO
		mmoIAS = (IAS / Mach) * 0.85;
		if (mmoIAS < 365) {
			setprop("/controls/fctl/vmo-mmo", mmoIAS);
		} else {
			setprop("/controls/fctl/vmo-mmo", 365);
		}
		
		# Gear Max
		gearIAS = (IAS / Mach) * 0.7;
		if (gearIAS < 300) {
			gearMax = gearIAS;
		} else {
			gearMax = 300;
		}
		
		# Slats Max
		slatIAS = (IAS / Mach) * 0.55;
		if (slatIAS < 280) {
			slatMax = slatIAS;
		} else {
			slatMax = 280;
		}
		
		# Flaps Max
		flapIAS = (IAS / Mach) * 0.51;
		
		# Flaps 0-15
		if (flapIAS < 255) {
			flap0_15Max = flapIAS;
		} else {
			flap0_15Max = 255;
		}
		
		# Flaps 15-20
		if (flapIAS < 240) {
			flap15_20Max = flapIAS;
		} else {
			flap15_20Max = 240;
		}
		
		# Flaps 20-25
		if (flapIAS < 220) {
			flap20_25Max = flapIAS;
		} else {
			flap20_25Max = 220;
		}
		
		# Flaps 28
		if (flapIAS < 210) {
			flap28Max = flapIAS;
		} else {
			flap28Max = 210;
		}
		
		# Flaps 35
		if (flapIAS < 190) {
			flap35Max = flapIAS;
		} else {
			flap35Max = 190;
		}
		
		# Flaps 50
		if (flapIAS < 175) {
			flap50Max = flapIAS;
		} else {
			flap50Max= 175;
		}
		
		flap = getprop("/fdm/jsbsim/fcc/flap/cmd-deg");
		slat = getprop("/fdm/jsbsim/fcc/slat/cmd-deg");
		gear = getprop("/controls/gear/gear-down");
		# These if conditions are up from the previous position by 0.1, just in case.
		if (flap > 35.1) {
			setprop("/controls/fctl/flap-gear-max", flap50Max);
		} else if (flap > 28.1) {
			setprop("/controls/fctl/flap-gear-max", flap35Max);
		} else if (flap > 25.1) {
			setprop("/controls/fctl/flap-gear-max", flap28Max);
		} else if (flap > 20.1) {
			setprop("/controls/fctl/flap-gear-max", flap20_25Max);
		} else if (flap > 15.1) {
			setprop("/controls/fctl/flap-gear-max", flap15_20Max);
		} else if (flap > 0.1) {
			setprop("/controls/fctl/flap-gear-max", flap0_15Max);
		} else if (flap <= 0.1 and slat > 0.1) {
			setprop("/controls/fctl/flap-gear-max", slatMax);
		} else if (gear == 1) {
			setprop("/controls/fctl/flap-gear-max", gearMax);
		} else {
			setprop("/controls/fctl/flap-gear-max", -1); # Hide the tape
		}
		
		# Flap Limiter
		flapLimKnob = getprop("/controls/fctl/flap/limit-knob");
		if (IAS > flap20_25Max and flapLimKnob == 0 and !flapLimFail) {
			setprop("/fdm/jsbsim/fcc/flap/max-deg", 22);
		} else if (IAS > flap28Max and flapLimKnob == 0 and !flapLimFail) {
			setprop("/fdm/jsbsim/fcc/flap/max-deg", 25);
		} else if (IAS > flap35Max and flapLimKnob == 0 and !flapLimFail) {
			setprop("/fdm/jsbsim/fcc/flap/max-deg", 28);
		} else if (IAS > flap50Max and flapLimKnob == 0 and !flapLimFail) {
			setprop("/fdm/jsbsim/fcc/flap/max-deg", 35);
		} else {
			setprop("/fdm/jsbsim/fcc/flap/max-deg", 50);
		}
		
		# Manual Lights
		if (getprop("/fdm/jsbsim/fcc/lsas/elevator-feel-auto") != 1 or elevFeelFail) {
			setprop("/controls/fctl/lsas/light/manual", 1);
		} else {
			setprop("/controls/fctl/lsas/light/manual", 0);
		}
		
		if (flapLimKnob > 0 or flapLimFail) {
			setprop("/controls/fctl/flap/light/manual", 1);
		} else {
			setprop("/controls/fctl/flap/light/manual", 0);
		}
	},
};
