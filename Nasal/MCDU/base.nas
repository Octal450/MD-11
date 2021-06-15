# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2021 Josh Davidson (Octal450)

var mcdu1 = nil;
var mcdu2 = nil;
var mcdu3 = nil;

var MCDU = {
	new: func() {
		var m = {parents: [MCDU]};
		
		m.page = nil;
		m.req = nil;
		
		return m;
	},
	setup: func() {
		me.page = "MENU";
		me.req = 1;
	},
};

var BASE = {
	init: func() {
		mcdu1 = MCDU.new();
		mcdu2 = MCDU.new();
		mcdu3 = MCDU.new();
	},
	setup: func() {
		mcdu1.setup();
		mcdu2.setup();
		mcdu3.setup();
	},
};
