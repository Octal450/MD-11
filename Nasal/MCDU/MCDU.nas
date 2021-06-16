# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2021 Josh Davidson (Octal450)

var unit = [nil, nil, nil];

var MCDU = {
	new: func(n, t) {
		var m = {parents: [MCDU]};
		
		m.blink = {
			active: 0,
			time: -10,
		};
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
		me.blink.active = 0;
		me.blink.time = -10;
		me.lastFmcPage = "acstatus";
		me.message.clear();
		me.page = "menu";
		me.scratchpad = "";
		me.scratchpadOld = "";
		me.request = 1;
	},
	loop: func() {
		if (me.blink.active) {
			if (me.blink.time < pts.Sim.Time.elapsedSec.getValue()) {
				me.blink.active = 0;
			}
		}
	},
	blinkScreen: func() {
		me.blink.active = 1;
		systems.DUController.hideMcdu(me.id);
		me.blink.time = pts.Sim.Time.elapsedSec.getValue() + 0.5;
	},
	isFmcPage: func(p) {
		if (p == "acstatus" or p == "radnav") { # Put all FMC pages here
			return 1;
		} else {
			return 0;
		}
	},
	pageKey: func(p) {
		if (!me.blink.active) {
			if (p == "menu" or !me.request) {
				me.setPage(p);
			}
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
		me.blinkScreen();
		me.page = p;
		canvas_mcdu.updatePage(me.id);
	},
	softKey: func(k) {
		if (!me.blink.active) {
			me.blinkScreen();
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
	loop: func() {
		unit[0].loop();
		unit[1].loop();
		unit[2].loop();
	},
};
