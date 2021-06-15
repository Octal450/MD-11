# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2021 Josh Davidson (Octal450)

var unit = [nil, nil, nil];

var MCDU = {
	new: func(n) {
		var m = {parents: [MCDU]};
		
		m.id = n;
		m.page = "Menu";
		m.request = 1;
		m.scratchpad = "";
		m.type = 0;
		
		return m;
	},
	setup: func() {
		me.page = "Menu";
		me.scratchpad = "";
		me.request = 1;
	},
	pageKey: func(p) {
		me.page = p;
		canvas_mcdu.updatePage(me.id);
	},
};

var BASE = {
	init: func() {
		for (var i = 0; i < 3; i = i + 1) {
			unit[i] = MCDU.new(i);
		}
	},
	setup: func() {
		for (var i = 0; i < 3; i = i + 1) {
			unit[i].setup();
		}
	},
};
