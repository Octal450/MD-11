# McDonnell Douglas MD-11 FMS
# Copyright (c) 2026 Josh Davidson (Octal450)

var RouteManager = {
	active: props.globals.getNode("/autopilot/route-manager/active"),
	activeTemp: 0,
	currentWp: props.globals.getNode("/autopilot/route-manager/current-wp"),
	distanceRemainingNm: props.globals.getNode("/autopilot/route-manager/distance-remaining-nm"),
};

# Flight plan controller
var FPController = {
	currentWp: 0,
	gotWp: [nil, nil, nil],
	plan: [createFlightplan(), createFlightplan(), createFlightplan(), createFlightplan(), nil], # 0 = Active, 1 = Alternate, 2 = Temporary 1, 3 = Temporary 2, 4 = Company Route
	ready: 0,
	routeReady: 0,
	size: [0, 0, 0, 0, 0],
	temporaryActive: [0, 0],
	init: func() {
		FPList.init();
		me.temporaryActive[0] = 0;
		me.temporaryActive[1] = 0;
		me.clearPlan(0);
		me.clearPlan(1);
		me.clearPlan(2);
		me.clearPlan(3);
		me.plan[0].activate();
		me.insertDiscontinuity(0, 0, 1, 1);
		me.insertPpos(0); # Calls planChanged
		me.activatePlan();
		me.ready = 1;
	},
	reset: func() {
		me.init();
	},
	loop: func() {
		RouteManager.activeTemp = RouteManager.active.getBoolValue();
		me.currentWp = RouteManager.currentWp.getValue();
		me.size[0] = me.plan[0].getPlanSize();
		
		if (me.ready and flightData.airportFrom != "" and flightData.airportTo != "") me.routeReady = 1;
		else me.routeReady = 0;
		
		if (me.size[0] > 0) {
			me.setActiveWp(); # Keep active waypoint set properly
			
			if (!RouteManager.activeTemp) {
				me.activatePlan(1);
			}
		}
	},
	activatePlan: func(noWpChange = 0) {
		if (!noWpChange) {
			me.setActiveWp();
		}
		RouteManager.active.setBoolValue(1);
	},
	clearPlan: func(n, noPlanChanged = 0) {
		me.plan[n].clearAll();
		if (!noPlanChanged) me.planChanged(n);
	},
	clearTemporary: func(mcduId, noPlanChanged = 0) {
		me.temporaryActive[mcduId] = 0;
		
		if (mcduId == 0) {
			me.clearPlan(2, noPlanChanged);
		} else if (mcduId == 1) {
			me.clearPlan(3, noPlanChanged);
		}
	},
	copyPlan: func(n, s, noPlanChanged = 0, noPosUpdate = 0) {
		me.clearPlan(n, 1);
		me.plan[n] = me.plan[s].clone();
		
		# PPOS and T-P need to be updated any time we move a flightplan unless we say not to
		if (!noPosUpdate) {
			var wpTemp = me.plan[n].getWP(0); # Only if they are in FROM
			if (wpTemp.id == "PPOS") {
				me.removeWp(n, 0, 1, 1);
				me.insertPpos(n, 0, 1);
			} else if (wpTemp.id == "T-P") {
				me.removeWp(n, 0, 1, 1);
				me.insertTp(n, 0, 1);
			}
		}
		
		if (n == 0) me.plan[0].activate(); # Has to be re-set as active because it's a "new" plan
		if (!noPlanChanged) me.planChanged(n);
	},
	createTemporary: func(mcduId, n, noPlanChanged = 0) { # No temporary alternate
		var planIdTemp = -1;
		
		if (mcduId == 0) {
			planIdTemp = 2;
		} else if (mcduId == 1) {
			planIdTemp = 3;
		} else { # Just in case
			return;
		}
		
		me.clearPlan(planIdTemp, 1);
		me.copyPlan(planIdTemp, n, noPlanChanged);
		me.temporaryActive[mcduId] = 1;
	},
	dirIntcArbitraryGhost: func(n, ghost) {
		me.removeWp(n, 0, 1, 1); # Remove FROM
		me.insertTp(n, 0, 1);
		me.insertGhost(n, 1, ghost); # Calls planChanged
	},
	dirIntcFPWP: func(n, s, i) {
		var legTemp = me.plan[s].getWP(i);
		me.removeWp(n, 0, 1, 1); # Remove FROM
		me.insertTp(n, 0, 1);
		me.insertLeg(n, 1, legTemp); # Calls planChanged
	},
	dirIntcInSequenceWP: func(n, i) {
		me.removeWp(n, 0, 1, 1); # Remove FROM
		me.insertTp(n, 0, 1);
		me.removeMultipleWp(n, 1, i - 1); # Calls planChanged
	},
	executeTemporary: func(n, mcduId, noPlanChanged = 0) {
		if (me.temporaryActive[mcduId]) {
			var planIdTemp = -1;
			
			if (mcduId == 0) {
				planIdTemp = 2;
			} else if (mcduId == 1) {
				planIdTemp = 3;
			} else { # Just in case
				return;
			}
			
			# Both plan's planChanged must be called/not called
			me.copyPlan(n, planIdTemp, noPlanChanged);
			me.clearTemporary(mcduId, noPlanChanged);
		}
	},
	getPrevWpGeo: func(n, i) {
		var prevGeo = geo.aircraft_position();
		
		if (i > 0) {
			var prev = me.plan[n].getWP(i - 1);
			
			if (prev.wp_name != "DISCONTINUITY") {
				prevGeo = geo.Coord.new();
				prevGeo.set_latlon(prev.lat, prev.lon);
			} else if (i > 1) {
				prev = me.plan[n].getWP(i - 2);
				
				if (prev.wp_name != "DISCONTINUITY") { # Should never be false, but just in case, fall through
					prevGeo = geo.Coord.new();
					prevGeo.set_latlon(prev.lat, prev.lon);
				}
			}
		}
		
		return prevGeo;
	},
	getWpGhostByID: func(n, type, id, mcduId = -1) { # Similar to insertWp
		var wpTemp = nil;
		
		if (type == "fix") {
			wpTemp = findFixesByID(id);
		} else if (type == "navaid") {
			wpTemp = findNavaidsByID(id);
		} else if (type == "airport") {
			wpTemp = findAirportsByICAO(id);
		} else {
			return 1; # Not in database
		}
		
		var wpTempVector = std.Vector.new();
		
		if (type == "navaid") {
			foreach (wp; wpTemp) {
				if (wp.type == "VOR" or wp.type == "NDB") { # No DME/TACAN/ILS
					wpTempVector.append(wp);
				}
			}
		} else {
			foreach (wp; wpTemp) {
				wpTempVector.append(wp);
			}
		}
		
		var wpTempVectorSize = wpTempVector.size();
		
		if (wpTempVectorSize == 1 or mcduId == -1) {
			return wpTempVector.vector[0];
		} else if (wpTempVectorSize > 1) { # Duplicate names
			mcdu.unit[mcduId].Data.duplicateWpInfo = DuplicateWpList.new(n, 1, type, wpTempVector); # Prep Duplicate Names page, use current pos since no T-P exists yet
			return 2;
		} else {
			return 1; # Not in database
		}
	},
	insertDiscontinuity: func(n, i, force = 0, noPlanChanged = 0) {
		if (force) {
			me.plan[n].insertWP(createDiscontinuity(), i);
			return;
		}
		
		# Make sure that we do not insert one if one already exists
		if (me.plan[n].getWP(i) != nil) { # WP i is not nil
			if (me.plan[n].getWP(i - 1) != nil) { # WP i - 1 is also not nil
				if (me.plan[n].getWP(i).wp_name != "DISCONTINUITY" and me.plan[n].getWP(i - 1).wp_name != "DISCONTINUITY") {
					me.plan[n].insertWP(createDiscontinuity(), i);
				}
			} else { # WP i - 1 is nil
				if (me.plan[n].getWP(i).wp_name != "DISCONTINUITY") {
					me.plan[n].insertWP(createDiscontinuity(), i);
				}
			}
		} else if (me.plan[n].getWP(i - 1) != nil) { # WP i is nil, WP i - 1 is not nil
			if (me.plan[n].getWP(i - 1).wp_name != "DISCONTINUITY") {
				me.plan[n].insertWP(createDiscontinuity(), i);
			}
		} else { # Both are nil - should never happen
			print("FPController Error: Both WP i and WP i - 1 are nil, skipping discontinuity add");
		}
		
		if (!noPlanChanged) me.planChanged(n); # If this is just part of another function, don't update now
	},
	insertGhost: func(n, i, ghost, noDiscontinuity = 0, noPlanChanged = 0) {
		me.plan[n].insertWP(createWPFrom(ghost), i);
		if (!noDiscontinuity) me.insertDiscontinuity(n, i + 1, 0, 1);
		if (!noPlanChanged) me.planChanged(n);
	},
	insertLeg: func(n, i, leg, noDiscontinuity = 0, noPlanChanged = 0) {
		me.plan[n].insertWP(leg, i);
		if (!noDiscontinuity) me.insertDiscontinuity(n, i + 1, 0, 1);
		if (!noPlanChanged) me.planChanged(n);
	},
	insertPpos: func(n, i = 0, noPlanChanged = 0) {
		me.plan[n].insertWP(createWP(geo.aircraft_position(), "PPOS"), i);
		if (!noPlanChanged) me.planChanged(n);
	},
	insertTp: func(n, i = 0, noPlanChanged = 0) {
		me.plan[n].insertWP(createWP(geo.aircraft_position(), "T-P"), i);
		if (!noPlanChanged) me.planChanged(n);
	},
	insertWp: func(n, i, type, id, mcduId = -1, noDiscontinuity = 0, noPlanChanged = 0) { # Similar to getWpGhostByID
		var wpTemp = nil;
		
		if (type == "fix") {
			wpTemp = findFixesByID(id);
		} else if (type == "navaid") {
			wpTemp = findNavaidsByID(id);
		} else if (type == "airport") {
			wpTemp = findAirportsByICAO(id);
		} else {
			return 1; # Not in database
		}
		
		var wpTempVector = std.Vector.new();
		
		if (type == "navaid") {
			foreach (wp; wpTemp) {
				if (wp.type == "VOR" or wp.type == "NDB") { # No DME/TACAN/ILS
					wpTempVector.append(wp);
				}
			}
		} else {
			foreach (wp; wpTemp) {
				wpTempVector.append(wp);
			}
		}
		
		var wpTempVectorSize = wpTempVector.size();
		
		if (wpTempVectorSize == 1 or mcduId == -1) {
			me.plan[n].insertWP(createWPFrom(wpTempVector.vector[0]), i);
			if (!noDiscontinuity) me.insertDiscontinuity(n, i + 1, 0, 1);
			if (!noPlanChanged) me.planChanged(n);
		} else if (wpTempVectorSize > 1) { # Duplicate names
			mcdu.unit[mcduId].Data.duplicateWpInfo = DuplicateWpList.new(n, i, type, wpTempVector, me.getPrevWpGeo(n, i)); # Prep Duplicate Names page, previous waypoint pos
			return 2;
		} else {
			return 1; # Not in database
		}
	},
	newPlan: func(n, depInfo, destInfo) { # Takes airportinfo objects
		me.clearPlan(n, 1);
		me.plan[n].departure = depInfo;
		me.plan[n].destination = destInfo;
		me.insertDiscontinuity(n, 1); # Calls planChanged
	},
	planChanged: func(n) {
		FPList.rebuildList(n);
	},
	removeDuplicateDiscontinuities: func(n, i, noPlanChanged = 0) {
		if (i > 0) { # i = 0 case should never have one anyway
			if (me.plan[n].getWP(i - 1).wp_name == "DISCONTINUITY" and me.plan[n].getWP(i).wp_name == "DISCONTINUITY") {
				me.plan[n].deleteWP(i);
				if (!noPlanChanged) me.planChanged(n);
			}
		}
	},
	removeWp: func(n, i, noDiscontinuity = 0, noPlanChanged = 0) {
		var wpName = me.plan[n].getWP(i).wp_name;
		me.plan[n].deleteWP(i);
		if (!noDiscontinuity and wpName != "DISCONTINUITY") me.insertDiscontinuity(n, i, 0, 1);
		me.removeDuplicateDiscontinuities(n, i, 1); # If we delete a WP between two discontinuities, then two would be next to each other
		if (!noPlanChanged) me.planChanged(n);
	},
	removeMultipleWp: func(n, first, last, noPlanChanged = 0) { # Does not insert discontinuities
		for (var i = first; i <= last; i += 1) {
			me.removeWp(n, first, 1, 1); # Just keep removing the WP at first index
		}
		
		me.removeDuplicateDiscontinuities(n, first, 1); # Need to check for duplicates here, since the waypoint after "last" became the waypoint at "first"
		if (!noPlanChanged) me.planChanged(n);
	},
	setActiveWp: func() {
		if (me.ready) {
			if (me.size[0] >= 3) { # Case where there are at least 3 WPs
				me.gotWp[0] = me.plan[0].getWP(0);
				me.gotWp[1] = me.plan[0].getWP(1);
				me.gotWp[2] = me.plan[0].getWP(2);
				
				if (me.gotWp[0] != nil and me.gotWp[1] != nil and me.gotWp[2] != nil) { # Wait for all to become populated
					if (me.gotWp[1].id != "DISCONTINUITY") {
						RouteManager.currentWp.setValue(1);
					} else if (me.gotWp[2].id != "DISCONTINUITY") { # Shouldn't be but just in case
						RouteManager.currentWp.setValue(2);
					} else if (me.gotWp[0].id != "DISCONTINUITY") { # Shouldn't be but just in case
						RouteManager.currentWp.setValue(0);
					}
				}
			} else if (me.size[0] == 2) { # Case where there are only 2 WPs
				me.gotWp[0] = me.plan[0].getWP(0);
				me.gotWp[1] = me.plan[0].getWP(1);
				
				if (me.gotWp[0] != nil and me.gotWp[1] != nil) { # Wait for all to become populated
					if (me.gotWp[1].id != "DISCONTINUITY") {
						RouteManager.currentWp.setValue(1);
					} else if (me.gotWp[0].id != "DISCONTINUITY") { # Shouldn't be but just in case
						RouteManager.currentWp.setValue(0);
					}
				}
			}
		}
	},
};

# Flight plan list management
# This generates the plan lists used by the MCDU
var StaticItem = {
	new: func(n, text) {
		var m = {parents: [StaticItem]};
		
		m.plan = n;
		
		if (text == "fplnEnd") {
			m.text = "------END OF F-PLN------";
		} else if (text == "altnFplnEnd") {
			m.text = "----END OF ALTN F-PLN---";
		} else if (text == "noAltnFpln") {
			m.text = "------NO ALTN F-PLN-----";
		} else {
			me.text = text;
		}
		
		m.type = "static";
		
		return m;
	},
};

var WpItem = {
	new: func(n, wp) {
		var m = {parents: [WpItem]};
		
		m.plan = n;
		m.type = "wp";
		m.wp = wp;
		
		return m;
	},
};

var FPList = {
	combinedList: [std.Vector.new(), nil, std.Vector.new(), std.Vector.new()], # Sorted to match main FP list
	list: [std.Vector.new(), std.Vector.new(), std.Vector.new(), std.Vector.new(), std.Vector.new()],
	size: 0,
	init: func() {
		me.clearCombinedList(0);
		me.clearList(0);
		me.clearList(1);
		me.clearList(2);
		me.clearList(3);
		me.clearList(4);
	},
	clearCombinedList: func(n) {
		me.combinedList[n].clear();
	},
	clearList: func(n) {
		me.list[n].clear();
	},
	rebuildList: func(n) {
		me.clearList(n);
		me.size = FPController.plan[n].getPlanSize();
		
		for (var i = 0; i < me.size; i += 1) {
			me.list[n].append(WpItem.new(n, FPController.plan[n].getWP(i)));
		}
		
		if (n == 1) {
			if (me.size > 0) {
				me.list[n].append(StaticItem.new(n, "altnFplnEnd"));
			} else {
				me.list[n].append(StaticItem.new(n, "noAltnFpln"));
			}
		} else {
			me.list[n].append(StaticItem.new(n, "fplnEnd"));
		}
		
		# Compute combined lists
		if (n == 0) {
			me.rebuildCombinedList(0, 0, 1);
		} else if (n == 1) { # No temporary alternate, so we might have to update all 3
			me.rebuildCombinedList(0, 0, 1); # Always update active
			
			# Update temporary if they are active
			if (FPController.temporaryActive[0]) me.rebuildCombinedList(2, 2, 1);
			if (FPController.temporaryActive[1]) me.rebuildCombinedList(3, 3, 1);
		} else if (n == 2) {
			me.rebuildCombinedList(2, 2, 1);
		} else if (n == 3) {
			me.rebuildCombinedList(3, 3, 1);
		}
	},
	rebuildCombinedList: func(n, n1, n2) {
		me.clearCombinedList(n);
		me.combinedList[n].extend(me.list[n1].vector);
		me.combinedList[n].extend(me.list[n2].vector);
	},
};

# Info page constructors
# Allows us to tell the F-PLN sub-pages information they need
var DuplicateWpList = {
	new: func(n, i, t, wpV, prevGeo = nil) {
		var m = {parents: [DuplicateWpList]};
		
		if (prevGeo == nil) {
			prevGeo = geo.aircraft_position();
		}
		
		m.cDVector = std.Vector.new();
		m.index = i;
		m.plan = n;
		m.type = t;
		m.wpVector = wpV; # std.Vector
		
		var wpGeo = geo.Coord.new();
		for (var i = 0; i < m.wpVector.size(); i += 1) {
			wpGeo.set_latlon(m.wpVector.vector[i].lat, m.wpVector.vector[i].lon);
			m.cDVector.append(courseAndDistance(prevGeo, wpGeo));
		};
		
		return m;
	},
};

var WpInfo = {
	new: func(n, i, wp) {
		var m = {parents: [WpInfo]};
		
		m.index = i;
		m.plan = n;
		m.wp = wp;
		
		return m;
	},
};
