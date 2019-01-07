# MD-11 Flight Control System

# Copyright (c) 2019 Joshua Davidson (it0uchpods)

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
	},
};
