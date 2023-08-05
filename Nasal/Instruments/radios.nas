# McDonnell Douglas MD-11 Radios
# Copyright (c) 2023 Josh Davidson (Octal450)

var crp = [nil, nil, nil];
var ettr = props.globals.getNode("/systems/acconfig/options/eight-three-three-radios");

var CRP = { # HF is not simulated in FGFS, so we will not use it
	new: func(n, t) {
		var m = {parents: [CRP]};
		m.root = "/instrumentation/crp[" ~ n ~ "]/";
		
		m.defMode = 0;
		if (t) m.defMode = 2;
		
		m.activeSel = 0;
		m.mode = props.globals.getNode(m.root ~ "mode"); # 0: VHF1, 1: VHF2, 2: VHF3, 3: HF1, 4: HF2
		m.power = props.globals.getNode("/systems/electrical/outputs/crp[" ~ n ~ "]", 1);
		m.selTemp = 0;
		m.stby = props.globals.getNode(m.root ~ "stby", 1);
		m.stbyRight = 0;
		m.stbySel = 0;
		m.stbySplit = [0, 0];
		m.stbyVal = 0;
		m.stbyValRight = 0;
		
		return m;
	},
	reset: func() {
		me.mode.setValue(me.defMode);
	},
	adjustDec: func(d, s = 0, o = -1) {
		if (me.power.getValue() >= 24) {
			if (o > -1) {
				me.selTemp = o;
			} else {
				me.selTemp = me.mode.getValue();
			}
			
			me.stbySplit = split(".", sprintf("%3.3f", pts.Instrumentation.Comm.Frequencies.standbyMhzFmt[me.selTemp].getValue()));
			me.stbyRight = right(me.stbySplit[1], 2);
			
			if (ettr.getBoolValue()) { # 8.33KHz/25KHz mixed
				# FG enforces 8.33KHz channel rounding
				if (s) me.stbyVal = sprintf("%03d", me.stbySplit[1] + (100 * d));
				else me.stbyVal = sprintf("%03d", me.stbySplit[1] + (5 * d));
				
				me.stbyValRight = right(me.stbyVal, 2);
				
				if (d > 0) {
					if (me.stbyVal > 990) { # 995 is skipped
						if (s) me.stbyVal = me.stbyRight; # Initial value
						else me.stbyVal = 0;
					} else if (me.stbyValRight == 20 or me.stbyValRight == 45 or me.stbyValRight == 70 or me.stbyValRight == 95) {
						me.stbyVal = me.stbyVal + 5;
					}
				} else if (d < 0) {
					if (me.stbyVal < 0) {
						if (s) me.stbyVal = "9" ~ me.stbyRight; # Initial value
						else me.stbyVal = 990; # 995 is skipped
					} else if (me.stbyValRight == 20 or me.stbyValRight == 45 or me.stbyValRight == 70 or me.stbyValRight == 95) {
						me.stbyVal = me.stbyVal - 5;
					}
				}
			} else { # 25KHz
				# Enforce 25KHz channel rounding because FG doesn't
				if (s) me.stbyVal = sprintf("%03d", math.round(me.stbySplit[1] + (100 * d), 25));
				else me.stbyVal = sprintf("%03d", math.round(me.stbySplit[1] + (25 * d), 25));
				
				if (d > 0) {
					if (me.stbyVal > 975) {
						if (s) me.stbyVal = me.stbyRight; # Initial value
						else me.stbyVal = 0;
					}
				} else if (d < 0) {
					if (me.stbyVal < 0) {
						if (s) me.stbyVal = "9" ~ me.stbyRight; # Initial value
						else me.stbyVal = 975;
					}
				}
			}
			
			me.stbyVal = sprintf("%03d", me.stbyVal);
			pts.Instrumentation.Comm.Frequencies.standbyMhz[me.selTemp].setValue(me.stbySplit[0] ~ "." ~ me.stbyVal);
		}
	},
	adjustInt: func(d, o = -1) {
		if (me.power.getValue() >= 24) {
			if (o > -1) {
				me.selTemp = o;
			} else {
				me.selTemp = me.mode.getValue();
			}
			
			me.stbySplit = split(".", sprintf("%3.3f", pts.Instrumentation.Comm.Frequencies.standbyMhzFmt[me.selTemp].getValue()));
			me.stbyVal = me.stbySplit[0] + d;
			
			if (d > 0) {
				if (me.stbyVal > 136) me.stbyVal = 118;
			} else if (d < 0) {
				if (me.stbyVal < 118) me.stbyVal = 136;
			}
			
			pts.Instrumentation.Comm.Frequencies.standbyMhz[me.selTemp].setValue(me.stbyVal ~ "." ~ me.stbySplit[1]);
		}
	},
	swap: func(o = -1) {
		if (me.power.getValue() >= 24) {
			if (o > -1) {
				me.selTemp = o;
			} else {
				me.selTemp = me.mode.getValue();
			}
			
			me.activeSel = pts.Instrumentation.Comm.Frequencies.selectedMhzFmt[me.selTemp].getValue();
			me.stbySel = pts.Instrumentation.Comm.Frequencies.standbyMhzFmt[me.selTemp].getValue();
			
			pts.Instrumentation.Comm.Frequencies.selectedMhz[me.selTemp].setValue(me.stbySel);
			pts.Instrumentation.Comm.Frequencies.standbyMhz[me.selTemp].setValue(me.activeSel);
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
	toggle833: func() {
		if (!ettr.getBoolValue()) { # If 8.33KHz is off, make sure all frequencies are 25KHz
			for (var i = 0; i < 3; i = i + 1) {
				pts.Instrumentation.Comm.Frequencies.selectedMhz[i].setValue(math.round(pts.Instrumentation.Comm.Frequencies.selectedMhzFmt[i].getValue() * 1000, 25) / 1000);
				pts.Instrumentation.Comm.Frequencies.standbyMhz[i].setValue(math.round(pts.Instrumentation.Comm.Frequencies.standbyMhzFmt[i].getValue() * 1000, 25) / 1000);
			}
		}
	},
};
