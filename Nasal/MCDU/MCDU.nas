# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)
# Thanks to legoboyvdlp!

var unit = [nil, nil, nil];

var MCDU = {
	new: func(n, t) {
		var m = {parents: [MCDU]};
		
		m.Blink = {
			active: 0,
			time: -10,
		};
		
		m.clear = 0;
		m.id = n;
		m.lastFmcPage = "acStatus";
		m.message = std.Vector.new();
		
		m.PageList = {
			acStatus: AcStatus.new(n),
			acStatus2: AcStatus2.new(n),
			closestAirports: ClosestAirports.new(n),
			fallback: Fallback.new(n),
			init: Init.new(n),
			menu: Menu.new(n, t),
			irsGnsPos: IrsGnsPos.new(n),
			irsStatus: IrsStatus.new(n),
			navRadio: NavRadio.new(n),
			posRef: PosRef.new(n),
			ref: Ref.new(n),
			sensorStatus: SensorStatus.new(n),
		};
		
		m.page = m.PageList.menu;
		
		m.scratchpad = "";
		m.scratchpadDecimal = nil;
		m.scratchpadOld = "";
		m.scratchpadSize = 0;
		m.type = t;
		
		return m;
	},
	reset: func() {
		me.Blink.active = 0;
		me.Blink.time = -10;
		me.clear = 0;
		me.lastFmcPage = "acStatus";
		me.message.clear();
		me.page = me.PageList.menu;
		
		me.PageList.acStatus.reset();
		me.PageList.closestAirports.reset();
		me.PageList.init.reset();
		me.PageList.menu.reset();
		me.PageList.irsGnsPos.reset();
		me.PageList.irsStatus.reset();
		me.PageList.navRadio.reset();
		me.PageList.posRef.reset();
		
		me.scratchpad = "";
		me.scratchpadDecimal = nil;
		me.scratchpadOld = "";
		me.scratchpadSize = 0;
	},
	loop: func() {
		if (me.Blink.active) {
			if (me.Blink.time < pts.Sim.Time.elapsedSec.getValue()) {
				me.Blink.active = 0;
			}
		}
		me.page.loop();
	},
	alphaNumKey: func(k) {
		if (k == "CLR") {
			if (me.message.size() > 0) {
				me.clear = 0;
				me.clearMessage(0);
			} else if (size(me.scratchpad) > 0) {
				me.clear = 0;
				me.scratchpad = left(me.scratchpad, size(me.scratchpad) - 1);
			} else if (me.clear) {
				me.clear = 0;
			} else {
				me.clear = 1;
			}
		} else {
			me.clear = 0;
			if (me.message.size() > 0) {
				me.clearMessage(1);
			}
			if (size(me.scratchpad) < 22) {
				me.scratchpad = me.scratchpad ~ k;
			}
		}
	},
	arrowKey: func(d) {
		if (!me.Blink.active) {
			# Do cool up/down stuff here
		}
	},
	blinkScreen: func() {
		me.Blink.active = 1;
		systems.DUController.hideMcdu(me.id);
		me.Blink.time = pts.Sim.Time.elapsedSec.getValue() + 0.4;
	},
	clearMessage: func(a) {
		me.clear = 0;
		
		if (a == 2) {
			me.message.clear();
			if (size(me.scratchpadOld) > 0) {
				me.scratchpad = me.scratchpadOld;
			} else {
				me.scratchpad = "";
			}
		} else if (a == 1) {
			me.message.clear();
			me.scratchpad = "";
		} else {
			if (me.message.size() > 1) {
				me.message.pop(0);
				me.scratchpad = me.message.vector[0];
			} else if (me.message.size() > 0) {
				me.message.pop(0);
				if (size(me.scratchpadOld) > 0) {
					me.scratchpad = me.scratchpadOld;
				} else {
					me.scratchpad = "";
				}
			}
		}
	},
	nextPage: func() {
		if (!me.Blink.active) {
			me.blinkScreen();
			
			if (me.page.nextPage != "none") {
				me.setPage(me.page.nextPage);
			} else {
				me.setMessage("NOT ALLOWED");
			}
		}
	},
	pageKey: func(p) {
		if (!me.Blink.active) {
			if (p == "menu" or !me.PageList.menu.Value.request) {
				me.setPage(p);
			} else {
				me.blinkScreen();
				me.setMessage("NOT ALLOWED");
			}
		}
	},
	scratchpadClear: func() {
		me.clear = 0;
		me.scratchpad = "";
		me.scratchpadOld = "";
	},
	scratchpadState: func() {
		if (me.clear) { # CLR
			return 0;
		} else if (size(me.scratchpad) > 0 and me.message.size() == 0) { # Scratchpad Entry
			return 2;
		} else { # Empty or Message
			return 1;
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
		if (p == "menu" and me.page.group == "fmc") {
			me.lastFmcPage = me.page.name;
		}
		
		me.blinkScreen();
		
		if (me.message.size() > 0) {
			me.clearMessage(2);
		}
		
		if (contains(me.PageList, p)) {
			me.page = me.PageList[p];
		} else {
			me.page = me.PageList.fallback;
		}
		
		# Setup page
		me.page.setup(); 
		
		# Update everything now to make sure it all transitions at once
		me.page.loop(); 
		canvas_mcdu.updateMcdu(me.id);
	},
	setScratchpad: func(s) {
		if (me.scratchpadState() == 1) {
			me.scratchpad = s;
		}
	},
	softKey: func(k) {
		if (!me.Blink.active) {
			me.blinkScreen();
			me.page.softKey(k);
		}
	},
	# String checking functions - if no test string is provided, they will check the scratchpad
	stringContains: func(c, test = nil) {
		if (test == nil) {
			test = me.scratchpad;
		}
		
		if (find(c, test) != -1) {
			return 1;
		} else {
			return 0;
		}
	},
	stringDecimalLengthInRange: func(min, max, test = nil) {
		if (test == nil) {
			test = me.scratchpad;
		}
		
		if (int(test) != nil) {
			if (find(".", test) != -1) {
				if (max == 0) {
					return 0;
				} else {
					me.scratchpadDecimal = split(".", test);
					if (size(me.scratchpadDecimal[1]) >= min and size(me.scratchpadDecimal[1]) <= max) {
						return 1;
					} else {
						return 0;
					}
				}
			} else {
				if (min == 0) {
					return 1;
				} else {
					return 0;
				}
			}
		} else {
			return 0;
		}
	},
	stringIsInt: func(test = nil) {
		if (test == nil) {
			test = me.scratchpad;
		}
		
		if (int(test) != nil) {
			if (test - int(test) != 0) {
				return 0;
			} else {
				return 1;
			}
		} else {
			return 0;
		}
	},
	stringIsNumber: func(test = nil) {
		if (test == nil) {
			test = me.scratchpad;
		}
		
		if (int(test) != nil) {
			return 1;
		} else {
			return 0;
		}
	},
	stringLengthInRange: func(min, max, test = nil) {
		if (test == nil) {
			test = me.scratchpad;
		}
		
		me.scratchpadSize = size(sprintf("%s", string.replace(test, "-", ""))); # Always string, and negatives don't affect
		
		if (me.scratchpadSize >= min and me.scratchpadSize <= max) {
			return 1;
		} else {
			return 0;
		}
	},
};

var BASE = {
	acStatus: {
		database: "01JAN-28JAN",
		database2: "29JAN-26FEB",
		databaseCode: "MD11605001",
		databaseCode2: "MD11605002",
		databaseSelected: 1,
		eng: props.globals.getNode("/MCDUC/eng").getValue(),
		perfFactor: 0,
		program: "PS4070541-921", # -921 software load
	},
	acStatus2: {
		amiPn: "1234DAC123456789",
		dataLink: "003FFC00",
		fidoPn: "ABC1234DAC456789",
		opcPn: "1234DAC567891234",
		perfDbPn: "ABC1234567867789",
	},
	init: func() {
		unit[0] = MCDU.new(0, 0);
		unit[1] = MCDU.new(1, 0);
		unit[2] = MCDU.new(2, 1);
	},
	reset: func() {
		me.acStatus.databaseSelected = 1;
		fms.CORE.resetRadio();
		for (var i = 0; i < 3; i = i + 1) {
			unit[i].reset();
		}
	},
	loop: func() {
		unit[0].loop();
		unit[1].loop();
		unit[2].loop();
	},
};

var FONT = {
	default: "MCDULarge.ttf",
	normal: 65,
	small: 54,
};

var dms = nil;
var degrees = [nil, nil];
var minutes = [nil, nil];
var sign = [nil, nil];

var positionFormat = func(node) {
	dms = node.getChild("latitude-deg").getValue();
	degrees[0] = int(dms);
	minutes[0] = sprintf("%.1f",abs((dms - degrees[0]) * 60));
	sign[0] = degrees[0] >= 0 ? "N" : "S";
	dms = node.getChild("longitude-deg").getValue();
	degrees[1] = int(dms);
	minutes[1] = sprintf("%.1f",abs((dms - degrees[1]) * 60));
	sign[1] = degrees[1] >= 0 ? "E" : "W";
	return sprintf("%s%02s%.1f/%s%03s%.1f", sign[0], abs(degrees[0]), minutes[0], sign[1], abs(degrees[1]), minutes[1]);
};
