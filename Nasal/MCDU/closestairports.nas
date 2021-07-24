# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2021 Josh Davidson (Octal450) and Jonathan Redpath (legoboyvdlp)

var ClosestAirports = {
	new: func(n) {
		var m = {parents: [ClosestAirports]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			C1: "",
			C1S: "",
			C2: "",
			C2S: "",
			C3: "",
			C3S: "",
			C4: "",
			C4S: "",
			C5: "",
			C5S: "",
			C6: "",
			C6S: "",
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1: "",
			L1S: "",
			L2: "",
			L2S: "",
			L3: "",
			L3S: "",
			L4: "",
			L4S: "",
			L5: "",
			L5S: "",
			L6: "",
			L6S: "",
			
			pageNum: "",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1: "",
			R1S: "BRG /DIST      ",
			R2: "",
			R2S: "",
			R3: "",
			R3S: "",
			R4: "",
			R4S: "",
			R5: "",
			R5S: "",
			R6: "",
			R6S: "",
			
			simple: 1,
			title: "CLOSEST AIRPORTS",
		};
		
		m.group = "fmc";
		m.name = "closestAirport";
		m.scratchpad = "";
		m.scratchpadState = 0;
		
		m.Value = {
			airports: nil,
			cdVector: [nil, nil, nil, nil, nil],
			customAirport: nil,
			magVar: nil,
			range: 10,
		};
		
		return m;
	},
	reset: func() {
		me.setup();
	},
	setup: func() {
		me.Value.cdVector = [nil, nil, nil, nil, nil];
		me.customAirport = nil;
		me.Value.range = 10;
		
		# Loop and search for airports in range
		me.Value.airports = findAirportsWithinRange(me.Value.range);
		while (size(me.Value.airports) < 4 and me.Value.range < 4000) {
			me.Value.airports = findAirportsWithinRange(me.Value.range);
			if (me.Value.range < 100) {
				me.Value.range += 10;
			} elsif (me.Value.range < 500) {
				me.Value.range += 50;
			} elsif (me.Value.range < 1000) {
				me.Value.range += 100;
			} elsif (me.Value.range < 2000) {
				me.Value.range += 250;
			}  else {
				me.Value.range += 500;
			}
		}
	},
	loop: func() {
		if (size(me.Value.airports) == 0) {
			me.Display.C3 = "NONE WITHIN 4000NM";
		} else {
			me.Display.C3 = "";
			me.Value.magVar = magvar();
			
			if (size(me.Value.airports) >= 1) {
				me.Display.L1 = me.Value.airports[0].id;
				me.Value.cdVector[0] = courseAndDistance(me.Value.airports[0]);
				me.Display.R1 = sprintf("%03.0fg/%-4d    ", math.round(me.Value.cdVector[0][0] - me.Value.magVar), math.round(me.Value.cdVector[0][1]));
			}
			
			if (size(me.Value.airports) >= 2) {
				me.Display.L2 = me.Value.airports[1].id;
				me.Value.cdVector[1] = courseAndDistance(me.Value.airports[1]);
				me.Display.R2 = sprintf("%03.0fg/%-4d    ", math.round(me.Value.cdVector[1][0] - me.Value.magVar), math.round(me.Value.cdVector[1][1]));
			}
			
			if (size(me.Value.airports) >= 3) {
				me.Display.L3 = me.Value.airports[2].id;
				me.Value.cdVector[2] = courseAndDistance(me.Value.airports[2]);
				me.Display.R3 = sprintf("%03.0fg/%-4d    ", math.round(me.Value.cdVector[2][0] - me.Value.magVar), math.round(me.Value.cdVector[2][1]));
			}
			
			if (size(me.Value.airports) >= 4) {
				me.Display.L4 = me.Value.airports[3].id;
				me.Value.cdVector[3] = courseAndDistance(me.Value.airports[3]);
				me.Display.R4 = sprintf("%-03.0fg/%-4d    ", math.round(me.Value.cdVector[3][0] - me.Value.magVar), math.round(me.Value.cdVector[3][1]));
			}
		
		}
		
		if (me.Value.customAirport == nil) {
			me.Display.L5 = "[    ]";
			me.Display.R5 = sprintf("---g/----    ");
		} else {
			me.Value.cdVector[4] = courseAndDistance(me.Value.customAirport);
			me.Display.L5 = me.Value.customAirport.id;
			me.Display.R5 = sprintf("%03.0fg/%-4d    ", math.round(me.Value.cdVector[4][0] - me.Value.magVar), math.round(me.Value.cdVector[4][1]));
		}
	},
	softKey: func(k) {
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		if (k == "l5") {
			if (me.scratchpadState == 2) {
				if (mcdu.unit[me.id].stringLengthInRange(3, 4)) {
					if (size(findAirportsByICAO(me.scratchpad)) > 0) {
						me.Value.customAirport = findAirportsByICAO(me.scratchpad)[0];
						mcdu.unit[me.id].scratchpadClear();
					} else {
						mcdu.unit[me.id].setMessage("NOT IN DATA BASE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else if (me.scratchpadState == 0) {
				if (me.Value.customAirport != nil) {
					me.Value.customAirport = nil;
					mcdu.unit[me.id].scratchpadClear();
				} else {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};
