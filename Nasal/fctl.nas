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
		setprop("/controls/fctl/lsas/light/left-out-fail", 1);
		setprop("/controls/fctl/lsas/light/left-in-fail", 1);
		setprop("/controls/fctl/lsas/light/right-in-fail", 1);
		setprop("/controls/fctl/lsas/light/right-out-fail", 1);
		setprop("/controls/fctl/yd/light/upper-a-fail", 1);
		setprop("/controls/fctl/yd/light/upper-b-fail", 1);
		setprop("/controls/fctl/yd/light/lower-a-fail", 1);
		setprop("/controls/fctl/yd/light/lower-b-fail", 1);
		setprop("/fdm/jsbsim/fcc/lsas/left-out-active", 0);
		setprop("/fdm/jsbsim/fcc/lsas/left-in-active", 0);
		setprop("/fdm/jsbsim/fcc/lsas/right-in-active", 0);
		setprop("/fdm/jsbsim/fcc/lsas/right-out-active", 0);
		setprop("/fdm/jsbsim/fcc/yaw/avail-upr", 0);
		setprop("/fdm/jsbsim/fcc/yaw/avail-lwr", 0);
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
		
		# ELEV FEEL MAN
		if (l_emer_dc >= 25 or r_emer_dc >= 25 or dc1 >= 25 or dc2 >= 25 or dc3 >= 25) {
			setprop("/fdm/jsbsim/fcc/lsas/elevator-feel-pwr", 1);
		} else {
			setprop("/fdm/jsbsim/fcc/lsas/elevator-feel-pwr", 0);
		}
		
		if (getprop("/controls/fctl/lsas/feel-man") != 1 and (l_emer_dc >= 25 or r_emer_dc >= 25 or dc1 >= 25 or dc2 >= 25 or dc3 >= 25)) {
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
		
		flap = getprop("/controls/flight/flap-lever");
		gear = getprop("/controls/gear/gear-down");
		if (flap == 5) {
			setprop("/controls/fctl/flap-gear-max", flap50Max);
		} else if (flap == 4) {
			setprop("/controls/fctl/flap-gear-max", flap35Max);
		} else if (flap == 3) {
			setprop("/controls/fctl/flap-gear-max", flap28Max);
		} else if (flap == 2) { # Dial a flap not implemented yet, so for now we only use 15
			setprop("/controls/fctl/flap-gear-max", flap0_15Max);
		} else if (flap == 1) {
			setprop("/controls/fctl/flap-gear-max", slatMax);
		} else if (gear == 1) {
			setprop("/controls/fctl/flap-gear-max", gearMax);
		} else {
			setprop("/controls/fctl/flap-gear-max", -1); # Hide the tape
		}
	},
};
