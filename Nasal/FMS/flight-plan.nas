# McDonnell Douglas MD-11 FMS
# Copyright (c) 2026 Josh Davidson (Octal450)

var RouteManager = {
	active: props.globals.getNode("/autopilot/route-manager/active"),
	currentWp: props.globals.getNode("/autopilot/route-manager/current-wp"),
	distanceRemainingNm: props.globals.getNode("/autopilot/route-manager/distance-remaining-nm"),
};

# Flight plan controller
var FPController = {
	active: 0,
	currentWp: 0,
	gotWp: [nil, nil, nil],
	plan: [createFlightplan(), createFlightplan(), createFlightplan(), createFlightplan(), nil], # 0 = Active, 1 = Alternate, 2 = Temporary 1, 3 = Temporary 2, 4 = Company Route
	size: [0, 0, 0, 0, 0],
	temporaryActive: [0, 0],
	wpTemp: nil,
	wpTempVector: std.Vector.new(),
	wpTempVectorSize: 0,
	init: func(noSetup = 0) {
		FPList.init();
		me.temporaryActive[0] = 0;
		me.temporaryActive[1] = 0;
		me.clearPlan(0);
		me.clearPlan(1);
		me.clearPlan(2);
		me.clearPlan(3);
		me.plan[0].activate();
		if (!noSetup) me.insertDiscontinuity(0, 0, 1, 1);
		if (!noSetup) me.insertPpos(0); # Calls planChanged
		me.activatePlan();
	},
	reset: func(noSetup = 0) {
		me.init(noSetup);
	},
	loop: func() {
		me.active = RouteManager.active.getBoolValue();
		me.currentWp = RouteManager.currentWp.getValue();
		me.size[0] = me.plan[0].getPlanSize();
		
		if (me.size[0] > 0) {
			me.setActiveWp(); # Keep active waypoint set properly
			
			if (!me.active) {
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
	clearPlan: func(n) {
		me.plan[n].cleanPlan();
		me.planChanged(n);
	},
	insertDiscontinuity: func(n, i, force = 0, noPlanChanged = 0) {
		if (force) {
			me.plan[n].insertWP(createDiscontinuity(), i);
			return;
		}
		
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
	insertPpos: func(n, i = 0, noPlanChanged = 0) {
		me.plan[n].insertWP(createWP(geo.aircraft_position(), "PPOS"), i);
		if (!noPlanChanged) me.planChanged(n);
	},
	insertTp: func(n, i = 0, noPlanChanged = 0) {
		me.plan[n].insertWP(createWP(geo.aircraft_position(), "T-P"), i);
		if (!noPlanChanged) me.planChanged(n);
	},
	insertWp: func(n, i, type, id, mcduId = -1, noDiscontinuity = 0, noPlanChanged = 0) {
		if (type == "fix") {
			me.wpTemp = findFixesByID(id);
		} else if (type == "navaid") {
			me.wpTemp = findNavaidsByID(id);
		} else if (type == "airport") {
			me.wpTemp = findAirportsByICAO(id);
		} else {
			return 1;
		}
		
		me.wpTempVector.clear();
		if (type == "navaid") {
			foreach (wp; me.wpTemp) {
				if (wp.type == "VOR" or wp.type == "NDB") { # No DME/TACAN/ILS
					me.wpTempVector.append(wp);
				}
			}
		} else {
			foreach (wp; me.wpTemp) {
				me.wpTempVector.append(wp);
			}
		}
		me.wpTempVectorSize = me.wpTempVector.size();
		
		if (me.wpTempVectorSize == 1 or mcduId == -1) {
			me.plan[n].insertWP(createWPFrom(me.wpTempVector.vector[0]), i);
			if (!noDiscontinuity) me.insertDiscontinuity(n, i + 1, 0, 1);
			if (!noPlanChanged) me.planChanged(n);
		} else if (me.wpTempVectorSize > 1) { # Duplicate names
			mcdu.unit[mcduId].Data.duplicateWpInfo = DuplicateWpList.new(n, i, type, me.wpTempVector); # Prep Duplicate Names page
			return 2;
		} else {
			return 1; # Not in database
		}
	},
	newPlan: func(depInfo, destInfo) { # Takes airportinfo objects
		me.reset(1);
		me.plan[0].departure = depInfo;
		me.plan[0].destination = destInfo;
		me.insertDiscontinuity(0, 1);
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
		if (!noDiscontinuity and me.plan[n].getWP(i).wp_name != "DISCONTINUITY") me.insertDiscontinuity(n, i + 1, 0, 1);
		me.plan[n].deleteWP(i);
		me.removeDuplicateDiscontinuities(n, i, 1); # If we delete a WP between two discontinuities, then two would be next to each other
		if (!noPlanChanged) me.planChanged(n);
	},
	setActiveWp: func() {
		if (me.active) {
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

# Flight plan data management
var StaticItem = {
	new: func(text) {
		var m = {parents: [StaticItem]};
		
		if (text == "fplnEnd") {
			m.text = "------END OF F-PLN------";
		} else if (text == "altnFplnEnd") {
			m.text = "---END OF ALTN F-PLN----";
		} else if (text == "noAltnFpln") {
			m.text = "-----NO ALTN F-PLN------";
		} else {
			me.text = text;
		}
		m.type = "static";
		
		return m;
	},
};

var WpItem = {
	new: func(wp) {
		var m = {parents: [WpItem]};
		
		m.type = "wp";
		m.wp = wp;
		
		return m;
	},
};

var FPList = {
	list: [std.Vector.new(), std.Vector.new(), std.Vector.new(), std.Vector.new(), std.Vector.new()],
	size: 0,
	init: func() {
		me.clearList(0);
		me.clearList(1);
		me.clearList(2);
		me.clearList(3);
		me.clearList(4);
	},
	clearList: func(n) {
		me.list[n].clear();
	},
	rebuildList: func(n) {
		me.clearList(n);
		me.size = FPController.plan[n].getPlanSize();
		
		for (var i = 0; i < me.size; i += 1) {
			me.list[n].append(WpItem.new(FPController.plan[n].getWP(i)));
		}
		
		me.list[n].append(StaticItem.new("fplnEnd"));
		me.list[n].append(StaticItem.new("noAltnFpln"));
	},
};

# Info page constructors
# Allows us to tell the F-PLN sub-pages information they need
var DuplicateWpList = {
	new: func(n, i, t, wpV) {
		var m = {parents: [DuplicateWpList]};
		
		m.index = i;
		m.plan = n;
		m.type = t;
		m.wpVector = wpV; # std.Vector
		
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
