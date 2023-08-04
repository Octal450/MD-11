# McDonnell Douglas MD-11 Radios
# Copyright (c) 2023 Josh Davidson (Octal450)

var crp = [nil, nil, nil];

var CRP = { # HF is not simulated in FGFS, so we will not use it
	new: func(n, t) {
		var m = {parents: [CRP]};
		m.root = "/instrumentation/crp[" ~ n ~ "]/";
		
		m.active = props.globals.getNode(m.root ~ "active", 1);
		m.activeSel = 0;
		
		m.defMode = 0;
		if (t) {
			m.defMode = 2;
		}
		
		m.mode = props.globals.getNode(m.root ~ "mode"); # 0: VHF1, 1: VHF2, 2: VHF3, 3: HF1, 4: HF2
		m.modeTemp = 0;
		m.power = props.globals.getNode("/systems/electrical/outputs/crp[" ~ n ~ "]", 1);
		m.stby = props.globals.getNode(m.root ~ "stby", 1);
		m.stbyRight = 0;
		m.stbySel = 0;
		m.stbySplit = [0, 0];
		m.stbyVal = 0;
		
		return m;
	},
	reset: func() {
		me.mode.setValue(me.defMode);
	},
	adjustDec: func(d) {
		if (me.power.getValue() >= 24) {
			me.modeTemp = me.mode.getValue();
			
			me.stbySplit = split(".", sprintf("%3.2f", pts.Instrumentation.Comm.Frequencies.standbyMhzFmt[me.modeTemp].getValue()));
			me.stbyRight = right(me.stbySplit[1], 1);
			
			# This thing adds .X25 and .X75 support so that the knob works properly
			if (me.stbyRight == 2 or me.stbyRight == 7) {
				if (d > 0) me.stbyVal = me.stbySplit[1] + (3 * d);
				else if (d < 0) me.stbyVal = me.stbySplit[1] + (2 * d);
			} else {
				if (d > 0) me.stbyVal = me.stbySplit[1] + (2 * d);
				else if (d < 0) me.stbyVal = me.stbySplit[1] + (3 * d);
			}
			
			if (d > 0) {
				if (me.stbyVal > 97) me.stbyVal = 0;
			} else if (d < 0) {
				if (me.stbyVal < 0) me.stbyVal = 97;
			}
			
			me.stbyVal = sprintf("%02d", me.stbyVal);
			pts.Instrumentation.Comm.Frequencies.standbyMhz[me.modeTemp].setValue(me.stbySplit[0] ~ "." ~ me.stbyVal);
		}
	},
	adjustInt: func(d) {
		if (me.power.getValue() >= 24) {
			me.modeTemp = me.mode.getValue();
			
			me.stbySplit = split(".", sprintf("%3.2f", pts.Instrumentation.Comm.Frequencies.standbyMhzFmt[me.modeTemp].getValue()));
			me.stbyVal = me.stbySplit[0] + d;
			
			if (d > 0) {
				if (me.stbyVal > 135) me.stbyVal = 118;
			} else if (d < 0) {
				if (me.stbyVal < 118) me.stbyVal = 135;
			}
			
			pts.Instrumentation.Comm.Frequencies.standbyMhz[me.modeTemp].setValue(me.stbyVal ~ "." ~ me.stbySplit[1]);
		}
	},
	swap: func() { # We always want to insert FG's value
		if (me.power.getValue() >= 24) {
			me.modeTemp = me.mode.getValue();
			me.activeSel = pts.Instrumentation.Comm.Frequencies.selectedMhzFmt[me.modeTemp].getValue();
			me.stbySel = pts.Instrumentation.Comm.Frequencies.standbyMhzFmt[me.modeTemp].getValue();
			
			pts.Instrumentation.Comm.Frequencies.selectedMhz[me.modeTemp].setValue(me.stbySel);
			pts.Instrumentation.Comm.Frequencies.standbyMhz[me.modeTemp].setValue(me.activeSel);
		}
	},
};

var RADIOS = {
	init: func() {
		crp[0] = CRP.new(0, 0);
		crp[1] = CRP.new(1, 0);
		crp[2] = CRP.new(2, 1);
	},
	reset: func() {
		for (var i = 0; i < 3; i = i + 1) {
			crp[i].reset();
		}
	},
	loop: func() { # Do we need this? If yes, add to systemsLoop
		
	},
};
