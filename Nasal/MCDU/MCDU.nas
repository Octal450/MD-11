# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2025 Josh Davidson (Octal450)

var unit = [nil, nil, nil];

var MCDU = {
	new: func(n, t, ps) {
		var m = {parents: [MCDU]};
		
		m.Blink = {
			active: 0,
			time: -10,
		};
		
		m.clear = 0;
		
		m.clearTimer = {
			active: 0,
			time: -5,
		};
		
		m.elapsedSec = 0;
		m.id = n;
		m.lastFmcPage = "none";
		m.message = std.Vector.new();
		
		m.PageList = {
			acStatus: AcStatus.new(n),
			acStatus2: AcStatus2.new(n),
			approach: Approach.new(n),
			closestAirports: ClosestAirports.new(n),
			compRte: CompRte.new(n),
			fallback: Fallback.new(n),
			init: Init.new(n),
			init2: Init2.new(n),
			init3: Init3.new(n),
			irsGnsPos: IrsGnsPos.new(n),
			irsStatus: IrsStatus.new(n),
			menu: Menu.new(n, t),
			navRadio: NavRadio.new(n),
			perfClb: Perf.new(n, 0),
			perfCrz: Perf.new(n, 1),
			perfDes: Perf.new(n, 2),
			preSelCrz: PreSel.new(n, 1),
			preSelDes: PreSel.new(n, 2),
			posRef: PosRef.new(n),
			ref: Ref.new(n),
			sensorStatus: SensorStatus.new(n),
			thrLim: ThrLim.new(n),
			takeoff: Takeoff.new(n),
		};
		
		m.page = m.PageList.menu;
		m.powerSource = ps;
		m.scratchpad = "";
		m.scratchpadDecimal = nil;
		m.scratchpadOld = "";
		m.scratchpadSize = 0;
		m.type = t; # 0 = Standard, 1 = Standby
		
		return m;
	},
	reset: func() {
		me.blinkScreen();
		me.clear = 0;
		me.lastFmcPage = "none";
		me.message.clear();
		me.page = me.PageList.menu;
		
		me.PageList.acStatus.reset();
		me.PageList.closestAirports.reset();
		me.PageList.init.reset();
		me.PageList.irsGnsPos.reset();
		me.PageList.irsStatus.reset();
		me.PageList.posRef.reset();
		me.PageList.takeoff.reset();
		
		me.scratchpad = "";
		me.scratchpadDecimal = nil;
		me.scratchpadOld = "";
		me.scratchpadSize = 0;
	},
	loop: func() {
		me.elapsedSec = pts.Sim.Time.elapsedSec.getValue();
		
		if (me.powerSource.getValue() < 112) {
			if (me.page != me.PageList.menu) {
				me.page = me.PageList.menu;
			}
			fms.Internal.request[me.id] = 1;
		}
		
		if (!me.type) {
			if (!fms.Internal.avail[me.id].getBoolValue()) {
				if (me.page != me.PageList.menu and me.page.group == "fmc") {
					me.page = me.PageList.menu;
				}
				fms.Internal.request[me.id] = 1;
			}
		}
		
		if (me.clearTimer.active) {
			if (me.clearTimer.time < me.elapsedSec) {
				me.clearTimer.active = 0;
				me.clearTimer.time = -5;
				me.alphaNumKey("LONGCLR");
			}
		}
		
		if (me.Blink.active) {
			if (me.Blink.time < me.elapsedSec) {
				me.Blink.active = 0;
			}
		}
		me.page.loop();
	},
	alphaNumKey: func(k) {
		if (me.powerSource.getValue() < 112) {
			return;
		}
		
		if (k == "LONGCLR") { # Clear everything
			me.clear = 0;
			me.clearMessage(0);
			me.scratchpad = "";
		} else if (k == "CLR") {
			if (me.message.size() > 0) { # Clear message
				me.clear = 0;
				me.clearMessage(0);
			} else if (size(me.scratchpad) > 0) { # Clear letter
				me.clear = 0;
				me.scratchpad = left(me.scratchpad, size(me.scratchpad) - 1);
			} else if (me.clear) { # Clear CLR character
				me.clear = 0;
			} else { # Set CLR character
				me.clear = 1;
			}
		} else {
			me.clear = 0;
			if (me.message.size() > 0) {
				me.clearMessage(1);
			}
			if (size(me.scratchpad) < 23) {
				me.scratchpad = me.scratchpad ~ k;
			}
		}
	},
	arrowKey: func(d) {
		if (me.powerSource.getValue() < 112) {
			return;
		}
		
		if (!me.Blink.active) {
			# Do cool up/down stuff here
		} else {
			me.setMessage("BUTTON PUSH IGNORED");
		}
	},
	blinkScreen: func() {
		me.Blink.active = 1;
		systems.DUController.hideMcdu(me.id);
		me.Blink.time = pts.Sim.Time.elapsedSec.getValue() + 0.4;
	},
	clearKey: func(dir) {
		if (dir == "up") {
			me.clearTimer.active = 0;
			me.clearTimer.time = -5;
		} else if (dir == "down") {
			me.clearTimer.active = 1;
			me.clearTimer.time = pts.Sim.Time.elapsedSec.getValue() + 1.9;
			me.alphaNumKey("CLR");
		}
	},
	clearMessage: func(a) {
		me.clear = 0;
		
		if (a == 2) { # Clear all and set scratchpad to stored value
			me.message.clear();
			if (size(me.scratchpadOld) > 0) {
				me.scratchpad = me.scratchpadOld;
			} else {
				me.scratchpad = "";
			}
		} else if (a == 1) { # Clear all and blank scratchpad
			me.message.clear();
			me.scratchpad = "";
			me.scratchpadOld = "";
		} else { # Clear single message
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
	nextPageKey: func() {
		if (me.powerSource.getValue() < 112) {
			return;
		}
		
		if (!me.Blink.active) {
			me.blinkScreen();
			
			if (me.page.nextPage == "handled") { # Page handles it itself
				me.page.nextPage(); 
			} else if (me.page.nextPage != "none") { # Has next page
				me.setPage(me.page.nextPage);
			} else { # No next page
				me.setMessage("NOT ALLOWED");
			}
		} else {
			me.setMessage("BUTTON PUSH IGNORED");
		}
	},
	pageKey: func(p) {
		if (me.powerSource.getValue() < 112) {
			return;
		}
		
		if (!me.Blink.active) {
			if (p == "menu" or !fms.Internal.request[me.id]) {
				me.setPage(p);
			} else {
				me.blinkScreen();
				me.setMessage("NOT ALLOWED");
			}
		} else {
			me.setMessage("BUTTON PUSH IGNORED");
		}
	},
	removeMessage: func(m) {
		me.clear = 0;
		
		if (me.message.contains(m)) {
			if (me.message.size() > 1) {
				me.message.pop(me.message.index(m));
				me.scratchpad = me.message.vector[0];
			} else if (me.message.size() > 0) {
				me.message.pop(me.message.index(m));
				if (size(me.scratchpadOld) > 0) {
					me.scratchpad = me.scratchpadOld;
				} else {
					me.scratchpad = "";
				}
			}
		}
	},
	scratchpadClear: func() {
		me.clearMessage(1); # Also clears scratchpad and clear
	},
	scratchpadSet: func(t) {
		me.clearMessage(1);
		me.scratchpad = t;
	},
	scratchpadState: func() {
		if (me.clear) { # CLR character
			return 0;
		} else if (size(me.scratchpad) > 0 and me.message.size() == 0) { # Entry
			return 2;
		} else { # Empty or Message
			return 1;
		}
	},
	setMessage: func(m) {
		me.clear = 0;
		
		if (me.message.size() > 0) {
			if (me.message.vector[0] != m) { # Don't duplicate top message
				me.removeMessage(m); # Remove duplicate if it exists
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
		if (p == "perf") { # PERF page logic
			if (fms.Internal.phase <= 2) {
				p = "perfClb";
			} else if (fms.Internal.phase == 3) {
				p = "perfCrz";
			} else {
				p = "perfDes";
			}
		}
		
		if (p == "toAppr") { # TO/APPR page logic
			if (fms.Internal.phase <= 1) {
				p = "takeoff";
			} else {
				p = "approach";
			}
		}
		
		if (!contains(me.PageList, p)) { # Fallback logic
			p = "fallback";
		}
		
		if (me.PageList[p].group == "fmc") { # Standby MCDU special logic
			if (me.type) {
				me.blinkScreen();
				me.setMessage("NOT ALLOWED");
				return;
			}
		}
		
		if (me.page.group == "fmc") { # Store last FMC group page
			me.lastFmcPage = me.page.name;
		}
		
		me.blinkScreen();
		me.page = me.PageList[p]; # Set page
		me.page.setup();
		
		# Update everything now to make sure it all transitions at once
		me.page.loop(); 
		canvas_mcdu.updateMcdu(me.id);
	},
	softKey: func(k) {
		if (me.powerSource.getValue() < 112) {
			return;
		}
		
		if (!me.Blink.active) {
			me.blinkScreen();
			me.page.softKey(k);
		} else {
			me.setMessage("BUTTON PUSH IGNORED");
		}
	},
	# String checking functions - if no test string is provided, they will check the scratchpad
	stringContains: func(c, test = nil) { # Checks if the test contains the string provided
		if (test == nil) {
			test = me.scratchpad;
		}
		
		if (find(c, test) != -1) {
			return 1;
		} else {
			return 0;
		}
	},
	stringDecimalLengthInRange: func(min, max, test = nil) { # Checks if the test is a decimal number with place length in the range provided
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
	stringIsInt: func(test = nil) { # Checks if the test is an integer number
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
	stringIsNumber: func(test = nil) { # Checks if the test is a number, integer or decimal
		if (test == nil) {
			test = me.scratchpad;
		}
		
		if (int(test) != nil) {
			return 1;
		} else {
			return 0;
		}
	},
	stringLengthInRange: func(min, max, test = nil) { # Checks if the test string length is in the range provided
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
	setup: func() {
		unit[0] = MCDU.new(0, 0, systems.ELECTRICAL.Bus.lEmerAc);
		unit[1] = MCDU.new(1, 0, systems.ELECTRICAL.Bus.rEmerAc);
		unit[2] = MCDU.new(2, 1, systems.ELECTRICAL.Bus.ac1);
	},
	loop: func() {
		unit[0].loop();
		unit[1].loop();
		unit[2].loop();
	},
	reset: func() {
		fms.CORE.resetRadio();
		for (var i = 0; i < 3; i = i + 1) {
			unit[i].reset();
		}
	},
	removeGlobalMessage: func(m) {
		for (var i = 0; i < 3; i = i + 1) {
			unit[i].removeMessage(m);
		}
	},
	setGlobalMessage: func(m, t = 0) {
		for (var i = 0; i < 3; i = i + 1) {
			if (t or !unit[i].type) unit[i].setMessage(m);
		}
	},
};

var FONT = { # Letter separation in Canvas: 38.77
	large: "MD11MCDULarge.ttf",
	small: "MD11MCDUSmall.ttf",
};

var FORMAT = {
	Position: {
		degrees: [nil, nil],
		dms: nil,
		minutes: [nil, nil],
		sign: [nil, nil],
		formatNode: func(node) {
			me.dms = node.getChild("latitude-deg").getValue();
			me.degrees[0] = int(me.dms);
			me.minutes[0] = sprintf("%.1f",abs((me.dms - me.degrees[0]) * 60));
			me.sign[0] = me.degrees[0] >= 0 ? "N" : "S";
			me.dms = node.getChild("longitude-deg").getValue();
			me.degrees[1] = int(me.dms);
			me.minutes[1] = sprintf("%.1f",abs((me.dms - me.degrees[1]) * 60));
			me.sign[1] = me.degrees[1] >= 0 ? "E" : "W";
			return sprintf("%s%02s%04.1f/%s%03s%04.1f", me.sign[0], abs(me.degrees[0]), me.minutes[0], me.sign[1], abs(me.degrees[1]), me.minutes[1]);
		},
	},
};
