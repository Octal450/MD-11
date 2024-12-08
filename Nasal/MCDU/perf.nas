# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)
# Note: Some softkey functions are shared between Perf and PreSel

var Perf = {
	new: func(n, t) {
		var m = {parents: [Perf]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.normal, FONT.small, FONT.small, FONT.normal, FONT.normal, FONT.normal],
			CLTranslate: [0, 1, 1, 0, 0, -3],
			CTranslate: [0, 1, 1, 0, 0, -3],
			C1L: "",
			C1: "",
			C2L: "",
			C2: "",
			C3L: "",
			C3: "",
			C4L: "",
			C4: "",
			C5L: "",
			C5: "",
			C6L: "OPT/MAXFL",
			C6: "---/---",
			
			LFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1L: "",
			L1: "",
			L2L: " ECON",
			L2: "",
			L3L: "",
			L3: "",
			L4L: " EDIT",
			L4: "[ ]",
			L5L: "",
			L5: "",
			L6L: "",
			L6: "",
			
			LBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RFont: [FONT.small, FONT.small, FONT.small, FONT.normal, FONT.normal, FONT.normal],
			R1L: "",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "THRUST ",
			R6: "LIMITS>",
			
			RBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "",
			titleTranslate: 0,
		};
		
		if (t == 0) {
			m.Display.C2L = "TIME";
			m.Display.C2 = "----";
			m.Display.C3 = "----";
			
			m.Display.L3L = " MAX CLB";
			m.Display.L6L = "TRANS";
			
			m.Display.pageNum = "1/3";
			
			m.Display.R1L = "PRED TO";
			m.Display.R1 = "10000";
			m.Display.R2L = "DIST";
			m.Display.R2 = "----";
			m.Display.R3 = "----";
			m.Display.R5L = "CLIMB ";
			m.Display.R5 = "FORECAST>";
			
			m.nextPage = "preSelCrz";
		} else if (t == 1) {
			m.Display.pageNum = "1/2";
			
			m.Display.R1L = "TO T/D";
			m.Display.R1 = "----/---";
			
			m.nextPage = "preSelDes";
		} else if (t == 2) {
			m.Display.arrow = 0;
			
			m.Display.C1 = "0LONG";
			m.Display.C2L = "UTC";
			m.Display.C2 = "----";
			m.Display.C3 = "----";
			
			m.Display.L1L = "PATH ERROR";
			m.Display.L1 = " 0HI";
			m.Display.L3L = " MAX DES";
			m.Display.L6L = "TRANS";
			
			m.Display.pageNum = "";
			
			m.Display.R1L = "PRED TO";
			m.Display.R1 = "10000";
			m.Display.R2L = "DIST";
			m.Display.R2 = "----";
			m.Display.R3 = "----";
			m.Display.R5L = "DESCENT ";
			m.Display.R5 = "FORECAST>";
			
			m.nextPage = "none";
		}
		
		m.fromPage = "";
		m.group = "fmc";
		m.name = "perf";
		m.scratchpad = "";
		m.scratchpadSplit = nil;
		m.scratchpadSplitSize = 0;
		m.scratchpadState = 0;
		m.type = t; # 0 = CLB, 1 = CRZ, 2 = DES
		
		m.Value = {
			speedEdit: 0,
			speedEditFmt: 0,
			speedEditMach: 0,
			speedEditMachFmt: 0,
			speedMode: 0,
		};
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		# Page advance logic
		if (me.type == 2) {
			if (fms.Internal.phase == 3) {
				mcdu.unit[me.id].setPage("perfCrz");
			} else if (fms.Internal.phase <= 2) {
				mcdu.unit[me.id].setPage("perfClb");
			}
		} else if (me.type == 1) {
			if (fms.Internal.phase >= 4) {
				mcdu.unit[me.id].setPage("perfDes");
			} else if (fms.Internal.phase <= 2) {
				mcdu.unit[me.id].setPage("perfClb");
			}
		} else {
			if (fms.Internal.phase >= 4) {
				mcdu.unit[me.id].setPage("perfDes");
			} else if (fms.Internal.phase == 3) {
				mcdu.unit[me.id].setPage("perfCrz");
			}
		}
		
		if (me.type == 2) {
			me.Value.speedEdit = fms.FlightData.descentSpeedEditKts;
			me.Value.speedEditMach = fms.FlightData.descentSpeedEditMach;
			me.Value.speedMode = fms.FlightData.descentSpeedMode;
			
			if (me.Value.speedMode == 2) {
				me.Display.title = "EDIT DES";
			} else if (me.Value.speedMode == 1) {
				me.Display.title = "MAX DES";
			} else {
				me.Display.title = "ECON DES";
			}
		} else if (me.type == 1) {
			me.Value.speedEdit = fms.FlightData.cruiseSpeedEdit;
			me.Value.speedMode = fms.FlightData.cruiseSpeedMode;
			
			if (me.Value.speedMode == 2) {
				me.Display.title = "EDIT CRZ";
			} else if (me.Value.speedMode == 1) {
				me.Display.title = "MAX CRZ";
			} else {
				me.Display.title = "ECON CRZ";
			}
		} else {
			me.Value.speedEdit = fms.FlightData.climbSpeedEditKts;
			me.Value.speedEditMach = fms.FlightData.climbSpeedEditMach;
			me.Value.speedMode = fms.FlightData.climbSpeedMode;
			
			if (me.Value.speedMode == 2) {
				me.Display.title = "EDIT CLB";
			} else if (me.Value.speedMode == 1) {
				me.Display.title = "MAX CLB";
			} else {
				me.Display.title = "ECON CLB";
			}
		}
		
		if (fms.FmsSpd.econKts > 0 and fms.FmsSpd.econMach > 0) {
			if (me.type == 2) {
				if (me.Value.speedMode != 0) {
					me.Display.L2 = "*." ~ sprintf("%d", fms.FmsSpd.econMach * 1000) ~ "/" ~ sprintf("%d", fms.FmsSpd.econKts);
					me.Display.LFont[1] = FONT.small;
				} else {
					me.Display.L2 = "." ~ sprintf("%d", fms.FmsSpd.econMach * 1000) ~ "/" ~ sprintf("%d", fms.FmsSpd.econKts);
					me.Display.LFont[1] = FONT.normal;
				}
			} else if (me.type == 1) {
				if (me.Value.speedMode != 0) {
					me.Display.L2 = "*." ~ sprintf("%d", fms.FmsSpd.econMach * 1000);
					me.Display.LFont[1] = FONT.small;
				} else {
					me.Display.L2 = "." ~ sprintf("%d", fms.FmsSpd.econMach * 1000);
					me.Display.LFont[1] = FONT.normal;
				}
			} else {
				if (me.Value.speedMode != 0) {
					me.Display.L2 = "*" ~ sprintf("%d", fms.FmsSpd.econKts) ~ "/." ~ sprintf("%d", fms.FmsSpd.econMach * 1000);
					me.Display.LFont[1] = FONT.small;
				} else {
					me.Display.L2 = sprintf("%d", fms.FmsSpd.econKts) ~ "/." ~ sprintf("%d", fms.FmsSpd.econMach * 1000);
					me.Display.LFont[1] = FONT.normal;
				}
			}
		} else {
			me.Display.L2 = "---";
			me.Display.LFont[1] = FONT.small;
		}
		
		if (me.type != 1) {
			if (fms.FmsSpd.maxClimb > 0) {
				if (me.type == 2) {
					if (me.Value.speedMode != 1) {
						me.Display.L3 = "*" ~ sprintf("%d", fms.FmsSpd.maxDescent);
						me.Display.LFont[2] = FONT.small;
					} else {
						me.Display.L3 = sprintf("%d", fms.FmsSpd.maxDescent);
						me.Display.LFont[2] = FONT.normal;
					}
				} else {
					if (me.Value.speedMode != 1) {
						me.Display.L3 = "*" ~ sprintf("%d", fms.FmsSpd.maxClimb);
						me.Display.LFont[2] = FONT.small;
					} else {
						me.Display.L3 = sprintf("%d", fms.FmsSpd.maxClimb);
						me.Display.LFont[2] = FONT.normal;
					}
				}
			} else {
				me.Display.L3 = "---";
				me.Display.LFont[2] = FONT.small;
			}
		}
		
		if (me.Value.speedEdit > 0) {
			if (me.type == 2) {
				if (me.Value.speedEdit == 1) {
					me.Value.speedEditFmt = "VMO";
				} else {
					me.Value.speedEditFmt = sprintf("%d", me.Value.speedEdit);
				}
				
				if (me.Value.speedEditMach == 1) {
					me.Value.speedEditMachFmt = "MMO";
				} else {
					me.Value.speedEditMachFmt = "." ~ sprintf("%d", me.Value.speedEditMach * 1000);
				}
				
				if (me.Value.speedMode != 2) {
					me.Display.L4 = "*" ~ me.Value.speedEditMachFmt ~ "/" ~ me.Value.speedEditFmt;
					me.Display.LFont[3] = FONT.small;
				} else {
					me.Display.L4 = me.Value.speedEditMachFmt ~ "/" ~ me.Value.speedEditFmt;
					me.Display.LFont[3] = FONT.normal;
				}
			} else if (me.type == 1) {
				if (me.Value.speedEdit < 1) {
					me.Value.speedEditFmt = "." ~ sprintf("%d", me.Value.speedEdit * 1000);
				} else {
					me.Value.speedEditFmt = sprintf("%d", me.Value.speedEdit);
				}
				
				if (me.Value.speedMode != 2) {
					me.Display.L4 = "*" ~ me.Value.speedEditFmt;
					me.Display.LFont[3] = FONT.small;
				} else {
					me.Display.L4 = me.Value.speedEditFmt;
					me.Display.LFont[3] = FONT.normal;
				}
			} else {
				if (me.Value.speedEdit == 1) {
					me.Value.speedEditFmt = "VMO";
				} else {
					me.Value.speedEditFmt = sprintf("%d", me.Value.speedEdit);
				}
				
				if (me.Value.speedEditMach == 1) {
					me.Value.speedEditMachFmt = "MMO";
				} else {
					me.Value.speedEditMachFmt = "." ~ sprintf("%d", me.Value.speedEditMach * 1000);
				}
				
				if (me.Value.speedMode != 2) {
					me.Display.L4 = "*" ~ me.Value.speedEditFmt ~ "/" ~ me.Value.speedEditMachFmt;
					me.Display.LFont[3] = FONT.small;
				} else {
					me.Display.L4 = me.Value.speedEditFmt ~ "/" ~ me.Value.speedEditMachFmt;
					me.Display.LFont[3] = FONT.normal;
				}
			}
		} else {
			me.Display.L4 = "[ ]";
			me.Display.LFont[3] = FONT.normal;
		}
		
		if (me.type == 0) {
			me.Display.L6 = sprintf("%d", fms.FlightData.climbTransAlt);
		} else if (me.type == 2) {
			me.Display.L6 = sprintf("%d", fms.FlightData.descentTransAlt);
		} else {
			me.Display.L6 = "";
		}
	},
	insertEditSpeed: func() {
		if (me.scratchpadState == 2) {
			if (me.type == 1) { # CRZ: Only one entry
				if (mcdu.unit[me.id].stringIsNumber()) {
					if (me.scratchpad >= 100 and me.scratchpad <= 375 and mcdu.unit[me.id].stringIsInt()) {
						fms.FlightData.cruiseSpeedEdit = int(me.scratchpad);
						mcdu.unit[me.id].scratchpadClear();
					} else if (me.scratchpad >= 0.5 and me.scratchpad <= 0.9) {
						if (mcdu.unit[me.id].stringDecimalLengthInRange(1, 3)) {
							fms.FlightData.cruiseSpeedEdit = math.round(me.scratchpad, 0.001);
							mcdu.unit[me.id].scratchpadClear();
						} else {
							mcdu.unit[me.id].setMessage("FORMAT ERROR");
						}
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else { # CLB/DES: One or two entries
				me.scratchpadSplit = split("/", me.scratchpad);
				me.scratchpadSplitSize = size(me.scratchpadSplit);
				
				if (me.scratchpadSplitSize == 2) {
					me.scratchpadSplitSize0 = size(me.scratchpadSplit[0]);
					me.scratchpadSplitSize1 = size(me.scratchpadSplit[1]);
					
					if (me.type == 2) {
						if (me.scratchpadSplitSize0 == 0 or me.scratchpadSplitSize1 == 0) {
							mcdu.unit[me.id].setMessage("FORMAT ERROR");
							return;
						}
						
						# Check Mach
						if (me.scratchpadSplitSize0 > 0) {
							if (!mcdu.unit[me.id].stringIsNumber(me.scratchpadSplit[0])) {
								mcdu.unit[me.id].setMessage("FORMAT ERROR");
								return;
							}
							
							if (me.scratchpadSplit[0] < 0.5 or me.scratchpadSplit[0] > 0.9) {
								mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
								return;
							}
							
							if (!mcdu.unit[me.id].stringDecimalLengthInRange(1, 3, me.scratchpadSplit[0])) {
								mcdu.unit[me.id].setMessage("FORMAT ERROR");
								return;
							}
						}
						
						# Check Kts
						if (me.scratchpadSplitSize1 > 0) {
							if (!mcdu.unit[me.id].stringIsNumber(me.scratchpadSplit[1])) {
								mcdu.unit[me.id].setMessage("FORMAT ERROR");
								return;
							}
							
							if (me.scratchpadSplit[1] < 100 or me.scratchpadSplit[1] > 375 or !mcdu.unit[me.id].stringIsInt(me.scratchpadSplit[1])) {
								mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
								return;
							}
						}
						
						fms.FlightData.descentSpeedEditMach = math.round(me.scratchpadSplit[0], 0.001);
						fms.FlightData.descentSpeedEditKts = int(me.scratchpadSplit[1]);
						fms.FmsSpd.updateEditSpeeds(2);
						mcdu.unit[me.id].scratchpadClear();
					} else {
						if (me.scratchpadSplitSize0 == 0 or me.scratchpadSplitSize1 == 0) {
							mcdu.unit[me.id].setMessage("FORMAT ERROR");
							return;
						}
						
						# Check Kts
						if (me.scratchpadSplitSize0 > 0) {
							if (!mcdu.unit[me.id].stringIsNumber(me.scratchpadSplit[0])) {
								mcdu.unit[me.id].setMessage("FORMAT ERROR");
								return;
							}
							
							if (me.scratchpadSplit[0] < 100 or me.scratchpadSplit[0] > 375 or !mcdu.unit[me.id].stringIsInt(me.scratchpadSplit[0])) {
								mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
								return;
							}
						}
						
						# Check Mach
						if (me.scratchpadSplitSize1 > 0) {
							if (!mcdu.unit[me.id].stringIsNumber(me.scratchpadSplit[1])) {
								mcdu.unit[me.id].setMessage("FORMAT ERROR");
								return;
							}
							
							if (me.scratchpadSplit[1] < 0.5 or me.scratchpadSplit[1] > 0.9) {
								mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
								return;
							}
							
							if (!mcdu.unit[me.id].stringDecimalLengthInRange(1, 3, me.scratchpadSplit[1])) {
								mcdu.unit[me.id].setMessage("FORMAT ERROR");
								return;
							}
						}
						
						fms.FlightData.climbSpeedEditKts = int(me.scratchpadSplit[0]);
						fms.FlightData.climbSpeedEditMach = math.round(me.scratchpadSplit[1], 0.001);
						fms.FmsSpd.updateEditSpeeds(0);
						mcdu.unit[me.id].scratchpadClear();
					}
				} else if (me.scratchpadSplitSize == 1) {
					if (mcdu.unit[me.id].stringIsNumber()) {
						if (me.scratchpad >= 100 and me.scratchpad <= 375 and mcdu.unit[me.id].stringIsInt()) {
							if (me.type == 2) {
								fms.FlightData.descentSpeedEditKts = int(me.scratchpad);
								fms.FlightData.descentSpeedEditMach = 1;
								fms.FmsSpd.updateEditSpeeds(2);
							} else {
								fms.FlightData.climbSpeedEditKts = int(me.scratchpad);
								fms.FlightData.climbSpeedEditMach = 1;
								fms.FmsSpd.updateEditSpeeds(0);
							}
							mcdu.unit[me.id].scratchpadClear();
						} else if (me.scratchpad >= 0.5 and me.scratchpad <= 0.9) {
							if (mcdu.unit[me.id].stringDecimalLengthInRange(1, 3)) {
								if (me.type == 2) {
									fms.FlightData.descentSpeedEditKts = 1;
									fms.FlightData.descentSpeedEditMach = math.round(me.scratchpad, 0.001);
									fms.FmsSpd.updateEditSpeeds(2);
								} else {
									fms.FlightData.climbSpeedEditKts = 1;
									fms.FlightData.climbSpeedEditMach = math.round(me.scratchpad, 0.001);
									fms.FmsSpd.updateEditSpeeds(0);
								}
								mcdu.unit[me.id].scratchpadClear();
							} else {
								mcdu.unit[me.id].setMessage("FORMAT ERROR");
							}
						} else {
							mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
						}
					} else {
						mcdu.unit[me.id].setMessage("FORMAT ERROR");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			}
		} else if (me.scratchpadState == 1) {
			if (me.type == 2) {
				fms.FlightData.descentSpeedMode = 2;
			} else if (me.type == 1) {
				fms.FlightData.cruiseSpeedMode = 2;
			} else {
				fms.FlightData.climbSpeedMode = 2;
			}
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
	softKey: func(k) {
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		if (k == "l2") {
			if (me.scratchpadState == 1) {
				if (me.type == 2) {
					fms.FlightData.descentSpeedMode = 0;
				} else if (me.type == 1) {
					fms.FlightData.cruiseSpeedMode = 0;
				} else {
					fms.FlightData.climbSpeedMode = 0;
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l3") {
			if (me.scratchpadState == 1) {
				if (me.type == 2) {
					fms.FlightData.descentSpeedMode = 1;
				} else if (me.type == 1) {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				} else {
					fms.FlightData.climbSpeedMode = 1;
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l4") {
			me.insertEditSpeed();
		} else if (k == "l6") {
			if (me.scratchpadState == 2 and me.type != 1) {
				if (mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad >= 1000 and me.scratchpad <= 18000) {
						if (me.type == 2) {
							fms.FlightData.descentTransAlt = math.round(me.scratchpad, 1000);
						} else {
							fms.FlightData.climbTransAlt = math.round(me.scratchpad, 1000);
						}
						mcdu.unit[me.id].scratchpadClear();
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "r6") {
			mcdu.unit[me.id].setPage("thrLim");
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};

var PreSel = {
	new: func(n, t) {
		var m = {parents: [PreSel]};
		
		m.id = n;
		
		m.Display = {
			arrow: 1,
			
			CFont: [FONT.normal, FONT.small, FONT.small, FONT.normal, FONT.normal, FONT.normal],
			CLTranslate: [0, 1, 1, 0, 0, -3],
			CTranslate: [0, 1, 1, 0, 0, -3],
			C1L: "",
			C1: "",
			C2L: "",
			C2: "",
			C3L: "",
			C3: "",
			C4L: "",
			C4: "",
			C5L: "",
			C5: "",
			C6L: "OPT/MAXFL",
			C6: "---/---",
			
			LFont: [FONT.normal, FONT.small, FONT.small, FONT.normal, FONT.normal, FONT.normal],
			L1L: "",
			L1: "",
			L2L: " ECON",
			L2: "",
			L3L: "",
			L3: "",
			L4L: " EDIT",
			L4: "[ ]",
			L5L: "",
			L5: "",
			L6L: "",
			L6: "",
			
			LBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			L1B: "",
			L2B: "",
			L3B: "",
			L4B: "",
			L5B: "",
			L6B: "",
			
			pageNum: "",
			
			RFont: [FONT.small, FONT.small, FONT.small, FONT.normal, FONT.normal, FONT.normal],
			R1L: "",
			R1: "",
			R2L: "",
			R2: "",
			R3L: "",
			R3: "",
			R4L: "",
			R4: "",
			R5L: "",
			R5: "",
			R6L: "",
			R6: "",
			
			RBFont: [FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal, FONT.normal],
			R1B: "",
			R2B: "",
			R3B: "",
			R4B: "",
			R5B: "",
			R6B: "",
			
			title: "",
			titleTranslate: 0,
		};
		
		if (t == 1) {
			m.Display.pageNum = "2/3";
			m.Display.title = "PRESELECT CRZ";
			
			m.nextPage = "preSelDes";
		} else if (t == 2) {
			m.Display.L3L = " MAX DES";
			m.Display.L6L = "TRANS";
			
			m.Display.title = "PRESELECT DES";
			
			m.Display.R5L = "DESCENT ";
			m.Display.R5 = "FORECAST>";
		}
		
		m.fromPage = "";
		m.group = "fmc";
		m.name = "perf";
		m.scratchpad = "";
		m.scratchpadState = 0;
		m.type = t; # 0 = Unused so numbers match Perf class, 1 = CRZ, 2 = DES
		
		m.Value = {
			speedEdit: 0,
			speedEditFmt: 0,
			speedEditMach: 0,
			speedEditMachFmt: 0,
			speedMode: 0,
		};
		
		return m;
	},
	setup: func() {
	},
	loop: func() {
		# Page advance logic
		if (me.type == 2) {
			me.Value.speedEdit = fms.FlightData.descentSpeedEditKts;
			me.Value.speedEditMach = fms.FlightData.descentSpeedEditMach;
			me.Value.speedMode = fms.FlightData.descentSpeedMode;
			
			if (fms.Internal.phase >= 4) {
				mcdu.unit[me.id].setPage("perfDes");
			} else if (fms.Internal.phase == 3) {
				me.Display.pageNum = "2/2";
				me.nextPage = "perfCrz";
			} else {
				me.Display.pageNum = "3/3";
				me.nextPage = "perfClb";
			}
		} else if (me.type == 1) {
			me.Value.speedEdit = fms.FlightData.cruiseSpeedEdit;
			me.Value.speedMode = fms.FlightData.cruiseSpeedMode;
			
			if (fms.Internal.phase >= 4) {
				mcdu.unit[me.id].setPage("perfDes");
			} else if (fms.Internal.phase == 3) {
				mcdu.unit[me.id].setPage("perfCrz");
			}
		}
		
		if (fms.FmsSpd.econKts > 0 and fms.FmsSpd.econMach > 0) {
			if (me.type == 2) {
				if (me.Value.speedMode != 0) {
					me.Display.L2 = "*." ~ sprintf("%d", fms.FmsSpd.econMach * 1000) ~ "/" ~ sprintf("%d", fms.FmsSpd.econKts);
					me.Display.LFont[1] = FONT.small;
				} else {
					me.Display.L2 = "." ~ sprintf("%d", fms.FmsSpd.econMach * 1000) ~ "/" ~ sprintf("%d", fms.FmsSpd.econKts);
					me.Display.LFont[1] = FONT.normal;
				}
			} else if (me.type == 1) {
				if (me.Value.speedMode != 0) {
					me.Display.L2 = "*." ~ sprintf("%d", fms.FmsSpd.econMach * 1000);
					me.Display.LFont[1] = FONT.small;
				} else {
					me.Display.L2 = "." ~ sprintf("%d", fms.FmsSpd.econMach * 1000);
					me.Display.LFont[1] = FONT.normal;
				}
			}
		} else {
			me.Display.L2 = "---";
			me.Display.LFont[1] = FONT.small;
		}
		
		if (me.type != 1) {
			if (fms.FmsSpd.maxClimb > 0) {
				if (me.type == 2) {
					if (me.Value.speedMode != 1) {
						me.Display.L3 = "*" ~ sprintf("%d", fms.FmsSpd.maxDescent);
						me.Display.LFont[2] = FONT.small;
					} else {
						me.Display.L3 = sprintf("%d", fms.FmsSpd.maxDescent);
						me.Display.LFont[2] = FONT.normal;
					}
				}
			} else {
				me.Display.L3 = "---";
				me.Display.LFont[2] = FONT.small;
			}
		}
		
		if (me.Value.speedEdit > 0) {
			if (me.type == 2) {
				if (me.Value.speedEdit == 1) {
					me.Value.speedEditFmt = "VMO";
				} else {
					me.Value.speedEditFmt = sprintf("%d", me.Value.speedEdit);
				}
				
				if (me.Value.speedEditMach == 1) {
					me.Value.speedEditMachFmt = "MMO";
				} else {
					me.Value.speedEditMachFmt = "." ~ sprintf("%d", me.Value.speedEditMach * 1000);
				}
				
				if (me.Value.speedMode != 2) {
					me.Display.L4 = "*" ~ me.Value.speedEditMachFmt ~ "/" ~ me.Value.speedEditFmt;
					me.Display.LFont[3] = FONT.small;
				} else {
					me.Display.L4 = me.Value.speedEditMachFmt ~ "/" ~ me.Value.speedEditFmt;
					me.Display.LFont[3] = FONT.normal;
				}
			} else if (me.type == 1) {
				if (me.Value.speedEdit < 1) {
					me.Value.speedEditFmt = "." ~ sprintf("%d", me.Value.speedEdit * 1000);
				} else {
					me.Value.speedEditFmt = sprintf("%d", me.Value.speedEdit);
				}
				
				if (me.Value.speedMode != 2) {
					me.Display.L4 = "*" ~ me.Value.speedEditFmt;
					me.Display.LFont[3] = FONT.small;
				} else {
					me.Display.L4 = me.Value.speedEditFmt;
					me.Display.LFont[3] = FONT.normal;
				}
			}
		} else {
			me.Display.L4 = "[ ]";
			me.Display.LFont[3] = FONT.normal;
		}
		
		if (me.type == 0) {
			me.Display.L6 = sprintf("%d", fms.FlightData.climbTransAlt);
		} else if (me.type == 2) {
			me.Display.L6 = sprintf("%d", fms.FlightData.descentTransAlt);
		} else {
			me.Display.L6 = "";
		}
	},
	insertEditSpeed: func() {
		if (me.scratchpadState == 2) {
			if (me.type == 1) { # CRZ: Only one entry
				if (mcdu.unit[me.id].stringIsNumber()) {
					if (me.scratchpad >= 100 and me.scratchpad <= 375 and mcdu.unit[me.id].stringIsInt()) {
						fms.FlightData.cruiseSpeedEdit = int(me.scratchpad);
						mcdu.unit[me.id].scratchpadClear();
					} else if (me.scratchpad >= 0.5 and me.scratchpad <= 0.9) {
						if (mcdu.unit[me.id].stringDecimalLengthInRange(1, 3)) {
							fms.FlightData.cruiseSpeedEdit = math.round(me.scratchpad, 0.001);
							mcdu.unit[me.id].scratchpadClear();
						} else {
							mcdu.unit[me.id].setMessage("FORMAT ERROR");
						}
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else { # DES: One or two entries
				me.scratchpadSplit = split("/", me.scratchpad);
				me.scratchpadSplitSize = size(me.scratchpadSplit);
				
				if (me.scratchpadSplitSize == 2) {
					me.scratchpadSplitSize0 = size(me.scratchpadSplit[0]);
					me.scratchpadSplitSize1 = size(me.scratchpadSplit[1]);
					
					if (me.scratchpadSplitSize0 == 0 or me.scratchpadSplitSize1 == 0) {
						mcdu.unit[me.id].setMessage("FORMAT ERROR");
						return;
					}
					
					# Check Mach
					if (me.scratchpadSplitSize0 > 0) {
						if (!mcdu.unit[me.id].stringIsNumber(me.scratchpadSplit[0])) {
							mcdu.unit[me.id].setMessage("FORMAT ERROR");
							return;
						}
						
						if (me.scratchpadSplit[0] < 0.5 or me.scratchpadSplit[0] > 0.9) {
							mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
							return;
						}
						
						if (!mcdu.unit[me.id].stringDecimalLengthInRange(1, 3, me.scratchpadSplit[0])) {
							mcdu.unit[me.id].setMessage("FORMAT ERROR");
							return;
						}
					}
					
					# Check Kts
					if (me.scratchpadSplitSize1 > 0) {
						if (!mcdu.unit[me.id].stringIsNumber(me.scratchpadSplit[1])) {
							mcdu.unit[me.id].setMessage("FORMAT ERROR");
							return;
						}
						
						if (me.scratchpadSplit[1] < 100 or me.scratchpadSplit[1] > 375 or !mcdu.unit[me.id].stringIsInt(me.scratchpadSplit[1])) {
							mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
							return;
						}
					}
					
					fms.FlightData.descentSpeedEditMach = math.round(me.scratchpadSplit[0], 0.001);
					fms.FlightData.descentSpeedEditKts = int(me.scratchpadSplit[1]);
					mcdu.unit[me.id].scratchpadClear();
				} else if (me.scratchpadSplitSize == 1) {
					if (mcdu.unit[me.id].stringIsNumber()) {
						if (me.scratchpad >= 100 and me.scratchpad <= 375 and mcdu.unit[me.id].stringIsInt()) {
							fms.FlightData.descentSpeedEditKts = int(me.scratchpad);
							fms.FlightData.descentSpeedEditMach = 1;
							mcdu.unit[me.id].scratchpadClear();
						} else if (me.scratchpad >= 0.5 and me.scratchpad <= 0.9) {
							if (mcdu.unit[me.id].stringDecimalLengthInRange(1, 3)) {
								fms.FlightData.descentSpeedEditKts = 1;
								fms.FlightData.descentSpeedEditMach = math.round(me.scratchpad, 0.001);
								mcdu.unit[me.id].scratchpadClear();
							} else {
								mcdu.unit[me.id].setMessage("FORMAT ERROR");
							}
						} else {
							mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
						}
					} else {
						mcdu.unit[me.id].setMessage("FORMAT ERROR");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			}
		} else if (me.scratchpadState == 1) {
			if (me.type == 2) {
				fms.FlightData.descentSpeedMode = 2;
			} else if (me.type == 1) {
				fms.FlightData.cruiseSpeedMode = 2;
			}
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
	softKey: func(k) {
		me.scratchpad = mcdu.unit[me.id].scratchpad;
		me.scratchpadState = mcdu.unit[me.id].scratchpadState();
		
		if (k == "l2") {
			if (me.scratchpadState == 1) {
				if (me.type == 2) {
					fms.FlightData.descentSpeedMode = 0;
				} else if (me.type == 1) {
					fms.FlightData.cruiseSpeedMode = 0;
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l3") {
			if (me.scratchpadState == 1) {
				if (me.type == 2) {
					fms.FlightData.descentSpeedMode = 1;
				} else if (me.type == 1) {
					mcdu.unit[me.id].setMessage("NOT ALLOWED");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else if (k == "l4") {
			me.insertEditSpeed();
		} else if (k == "l6") {
			if (me.scratchpadState == 2 and me.type == 2) {
				if (mcdu.unit[me.id].stringIsInt()) {
					if (me.scratchpad >= 1000 and me.scratchpad <= 18000) {
						fms.FlightData.descentTransAlt = math.round(me.scratchpad, 1000);
						mcdu.unit[me.id].scratchpadClear();
					} else {
						mcdu.unit[me.id].setMessage("ENTRY OUT OF RANGE");
					}
				} else {
					mcdu.unit[me.id].setMessage("FORMAT ERROR");
				}
			} else {
				mcdu.unit[me.id].setMessage("NOT ALLOWED");
			}
		} else {
			mcdu.unit[me.id].setMessage("NOT ALLOWED");
		}
	},
};
