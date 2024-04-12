# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450) and Jonathan Redpath (legoboyvdlp)

var ClosestAirports = {
	new: func(n) {
		var m = {parents: [ClosestAirports]};
		
		m.id = n;
		
		m.Display = {
			arrow: 0,
			
			CFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			CSTranslate: [0, 0, 0, 0, 0, 0],
			CTranslate: [0, 0, 0, 0, 0, 0],
			C1S: "BRG /DIST",
			C1: "",
			C2S: "",
			C2: "",
			C3S: "",
			C3: "",
			C4S: "",
			C4: "",
			C5S: "",
			C5: "",
			C6S: "",
			C6: "",
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1S: "",
			L1: "",
			L2S: "",
			L2: "",
			L3S: "",
			L3: "",
			L4S: "",
			L4: "",
			L5S: "",
			L5: "",
			L6S: "",
			L6: "",
			
			pageNum: "",
			
			RFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1S: "",
			R1: "",
			R2S: "",
			R2: "",
			R3S: "",
			R3: "",
			R4S: "",
			R4: "",
			R5S: "",
			R5: "",
			R6S: "",
			R6: "",
			
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
			me.Display.L1 = "";
			me.Display.L2 = "";
			me.Display.L3 = "";
			me.Display.L4 = "";
			me.Display.C1 = "NONE WITHIN 4000NM";
			me.Display.C2 = "";
			me.Display.C3 = "";
			me.Display.C4 = "";
		} else {
			me.Value.magVar = magvar();
			
			if (size(me.Value.airports) >= 1) {
				me.Display.L1 = me.Value.airports[0].id;
				me.Value.cdVector[0] = courseAndDistance(me.Value.airports[0]);
				me.Display.C1 = sprintf("%03.0fg/%-4d", math.round(me.Value.cdVector[0][0] - me.Value.magVar), math.round(me.Value.cdVector[0][1]));
			}
			
			if (size(me.Value.airports) >= 2) {
				me.Display.L2 = me.Value.airports[1].id;
				me.Value.cdVector[1] = courseAndDistance(me.Value.airports[1]);
				me.Display.C2 = sprintf("%03.0fg/%-4d", math.round(me.Value.cdVector[1][0] - me.Value.magVar), math.round(me.Value.cdVector[1][1]));
			}
			
			if (size(me.Value.airports) >= 3) {
				me.Display.L3 = me.Value.airports[2].id;
				me.Value.cdVector[2] = courseAndDistance(me.Value.airports[2]);
				me.Display.C3 = sprintf("%03.0fg/%-4d", math.round(me.Value.cdVector[2][0] - me.Value.magVar), math.round(me.Value.cdVector[2][1]));
			}
			
			if (size(me.Value.airports) >= 4) {
				me.Display.L4 = me.Value.airports[3].id;
				me.Value.cdVector[3] = courseAndDistance(me.Value.airports[3]);
				me.Display.C4 = sprintf("%-03.0fg/%-4d", math.round(me.Value.cdVector[3][0] - me.Value.magVar), math.round(me.Value.cdVector[3][1]));
			}
		
		}
		
		if (me.Value.customAirport == nil) {
			me.Display.L5 = "[    ]";
			me.Display.C5 = sprintf("---g/----");
		} else {
			me.Value.cdVector[4] = courseAndDistance(me.Value.customAirport);
			me.Display.L5 = me.Value.customAirport.id;
			me.Display.C5 = sprintf("%03.0fg/%-4d", math.round(me.Value.cdVector[4][0] - me.Value.magVar), math.round(me.Value.cdVector[4][1]));
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
