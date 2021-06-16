# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2021 Josh Davidson (Octal450)

var unit = [nil, nil, nil];

var MCDU = {
	new: func(n, t) {
		var m = {parents: [MCDU]};
		
		m.id = n;
		m.lastFmcPage = "acstatus";
		m.message = std.Vector.new();
		m.page = "menu";
		m.request = 1;
		m.scratchpad = "";
		m.scratchpadOld = "";
		m.type = t;
		
		return m;
	},
	setup: func() {
		me.lastFmcPage = "acstatus";
		me.message.clear();
		me.page = "menu";
		me.scratchpad = "";
		me.scratchpadOld = "";
		me.request = 1;
	},
	isFmcPage: func(p) {
		if (p == "acstatus" or p == "radnav") { # Put all FMC pages here
			return 1;
		} else {
			return 0;
		}
	},
	pageKey: func(p) {
		if (p == "menu" or !me.request) {
			me.setPage(p);
		}
	},
	setMessage: func(m) {
		if (me.message.size() > 0) {
			if (me.message.vector[0] != m) {
				me.message.insert(0, m);
				me.scratchpad = m;
			}
		} else {
			me.message.insert(0, m);
			me.scratchpadOld = me.scratchpad;
			me.scratchpad = m;
		}
	},
	setPage: func(p) {
		if (p == "menu" and me.isFmcPage(me.page)) {
			me.lastFmcPage = me.page;
		}
		# Flash screen
		me.page = p;
		canvas_mcdu.updatePage(me.id);
	},
	softKey: func(k) {
		# Flash screen
		if (me.page == "menu") {
			if (k == "l1") {
				if (me.request) {
					me.request = 0;
				} else {
					me.setPage(me.lastFmcPage);
				}
			} else {
				me.setMessage("NOT ALLOWED");
			}
		} else {
			me.setMessage("NOT ALLOWED");
		}
	},
};

var BASE = {
	init: func() {
		unit[0] = MCDU.new(0, 0);
		unit[1] = MCDU.new(1, 0);
		unit[2] = MCDU.new(2, 1);
	},
	setup: func() {
		for (var i = 0; i < 3; i = i + 1) {
			unit[i].setup();
		}
	},
};
