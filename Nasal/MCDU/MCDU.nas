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
		m.clear = 0;
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
	pageList: {
		acstatus: {
			nextPage: "acstatus2",
			type: "fms",
		},
		acstatus2: {
			nextPage: "acstatus",
			type: "fms",
		},
		menu: {
			nextPage: "none",
			type: "base",
		},
		radnav: {
			nextPage: "none",
			type: "fms",
		},
	},
	setup: func() {
		me.blink.active = 0;
		me.blink.time = -10;
		me.clear = 0;
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
	arrowKey: func(d) {
		if (!me.blink.active) {
			# Do cool up/down stuff here
		}
	},
	blinkScreen: func() {
		me.blink.active = 1;
		systems.DUController.hideMcdu(me.id);
		me.blink.time = pts.Sim.Time.elapsedSec.getValue() + 0.5;
	},
	clearMessage: func() {
		me.clear = 0;
		if (me.message.size() > 1) {
			me.message.pop(0);
			me.scratchpad = me.message.vector[0];
		} else if (me.message.size() > 0) {
			me.message.pop(0);
			me.scratchpad = "";
		}
	},
	nextPage: func() {
		if (!me.blink.active) {
			me.blinkScreen();
			
			if (me.pageList[me.page].nextPage != "none") {
				me.setPage(me.pageList[me.page].nextPage);
			} else {
				me.setMessage("NOT ALLOWED");
			}
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
		me.clear = 0;
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
		if (p == "menu" and me.pageList[me.page].type == "fms") {
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
					if (!me.clear and size(me.scratchpad) == 0) {
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
			} else {
				me.setMessage("NOT ALLOWED");
			}
		}
	},
	alphaNumKey: func(k) {
		if (k == "CLR") {
			if (me.message.size() > 0) {
				me.clear = 0;
				me.clearMessage();
			} else if (size(me.scratchpad) > 0) {
				me.clear = 0;
				me.scratchpad = left(me.scratchpad, size(me.scratchpad) - 1);
			} else if (me.clear) {
				me.clear = 0;
			} else {
				me.clear = 1;
			}
		} else if (me.message.size() == 0) {
			me.clear = 0;
			if (size(me.scratchpad) < 22) {
				me.scratchpad = me.scratchpad ~ k;
			}
		} else {
			me.clear = 0;
		}
	},
};

var BASE = {
	acStatus: {
		database: "01JAN-28JAN",
		database2: "29JAN-26FEB",
		databaseCode: "MD20170101",
		databaseCode2: "MD20170102",
		databaseSelected: 1,
		eng: props.globals.getNode("/MCDUC/eng").getValue(),
		perfFactor: 0,
		program: "PS4070541-921", # -921 software load
	},
	init: func() {
		unit[0] = MCDU.new(0, 0);
		unit[1] = MCDU.new(1, 0);
		unit[2] = MCDU.new(2, 1);
	},
	setup: func() {
		me.acStatus.databaseSelected = 1;
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
