# McDonnell Douglas MD-11 FMS
# Copyright (c) 2025 Josh Davidson (Octal450)
# Where needed + 0 is used to force a string to a number

# Properties and Data
var FlightData = {
	new: func() {
		var m = {parents: [FlightData]};
		
		m.accelAlt = -1000;
		m.accelAltSet = 0;
		m.accelAltEo = -1000;
		m.accelAltEoSet = 0;
		m.airportAltn = "";
		m.airportFrom = "";
		m.airportFromAlt = -1000;
		m.airportTo = "";
		m.airportToAlt = -1000;
		m.blockFuelLbs = 0;
		m.canCalcVspeeds = 0;
		m.climbSpeedEditKts = 0;
		m.climbSpeedEditMach = 0;
		m.climbSpeedMode = 0; # 0 = ECON; 1 = MAX; 2 = EDIT
		m.climbThrustAlt = -1000;
		m.climbThrustAltSet = 0;
		m.climbTransAlt = 18000;
		m.costIndex = -1;
		m.cruiseAlt = 0;
		m.cruiseAltAll = [0, 0, 0, 0, 0, 0];
		m.cruiseFl = 0;
		m.cruiseFlAll = [0, 0, 0, 0, 0, 0];
		m.cruiseSpeedEdit = 0;
		m.cruiseSpeedMode = 0; # 0 = ECON; 1 = MAX; 2 = EDIT
		m.cruiseTemp = nil;
		m.descentSpeedEditKts = 0;
		m.descentSpeedEditMach = 0;
		m.descentSpeedMode = 0; # 0 = ECON; 1 = MAX; 2 = EDIT
		m.descentTransAlt = 18000;
		m.flexActive = 0;
		m.flexTemp = 0;
		m.flightNumber = "";
		m.gwLbs = 0;
		m.landFlaps = 35;
		m.lastGwZfw = 1; # Which was entered last
		m.oatC = -100;
		m.oatUnit = 0;
		m.taxiFuel = 1.5;
		m.taxiFuelSet = 0;
		m.tocg = 0;
		m.toFlaps = 0;
		m.toPacks = 0;
		m.toSlope = -100; 
		m.toWind = -100;
		m.togwLbs = 0;
		m.ufobLbs = 0;
		m.v1 = 0;
		m.v1State = 0;
		m.v2 = 0;
		m.v2State = 0;
		m.vapp = 0;
		m.vappOvrd = 0;
		m.vr = 0;
		m.vrState = 0;
		m.zfwcg = 0;
		m.zfwLbs = 0;
		
		return m; 
	},
	reset: func() {
		var blankData = flightData.new();
		foreach(var key; keys(me)) {
			if (typeof(me[key]) != "func") {
				me[key] = blankData[key];
			}
		}
	},
};

var flightData = FlightData.new();

var FlightDataOut = {
	airportFromAlt: props.globals.getNode("/systems/fms/flight-data/airport-from-alt"),
	airportToAlt: props.globals.getNode("/systems/fms/flight-data/airport-to-alt"),
	canCalcVspeeds: props.globals.getNode("/systems/fms/flight-data/can-calc-vspeeds"),
	costIndex: props.globals.getNode("/systems/fms/flight-data/cost-index"),
	cruiseFl: props.globals.getNode("/systems/fms/flight-data/cruise-fl"),
	flexActive: props.globals.getNode("/systems/fms/flight-data/flex-active"),
	flexTemp: props.globals.getNode("/systems/fms/flight-data/flex-temp"),
	gwLbs: props.globals.getNode("/systems/fms/flight-data/gw-lbs"),
	landFlaps: props.globals.getNode("/systems/fms/flight-data/land-flaps"),
	oatC: props.globals.getNode("/systems/fms/flight-data/oat-c"),
	toFlaps: props.globals.getNode("/systems/fms/flight-data/to-flaps"),
	tocg: props.globals.getNode("/systems/fms/flight-data/tocg"),
	toPacks: props.globals.getNode("/systems/fms/flight-data/to-packs"),
	toSlope: props.globals.getNode("/systems/fms/flight-data/to-slope"),
	toWind: props.globals.getNode("/systems/fms/flight-data/to-wind"),
	togw: props.globals.getNode("/systems/fms/flight-data/togw-lbs"),
	v1: props.globals.getNode("/systems/fms/flight-data/v1"),
	v2: props.globals.getNode("/systems/fms/flight-data/v2"),
	vr: props.globals.getNode("/systems/fms/flight-data/vr"),
	zfwcg: props.globals.getNode("/systems/fms/flight-data/zfwcg"),
	zfwLbs: props.globals.getNode("/systems/fms/flight-data/zfw-lbs"),
};

var RouteManager = {
	active: props.globals.getNode("/autopilot/route-manager/active"),
	alternateAirport: props.globals.getNode("/autopilot/route-manager/alternate/airport"),
	cruiseAlt: props.globals.getNode("/autopilot/route-manager/cruise/altitude-ft"),
	currentWp: props.globals.getNode("/autopilot/route-manager/current-wp"),
	departureAirport: props.globals.getNode("/autopilot/route-manager/departure/airport"),
	destinationAirport: props.globals.getNode("/autopilot/route-manager/destination/airport"),
	distanceRemainingNm: props.globals.getNode("/autopilot/route-manager/distance-remaining-nm"),
	num: props.globals.getNode("/autopilot/route-manager/route/num"),
};

var Value = { # Values used for internal checking, do not access elsewhere
	togw: 0,
	zfw: 0,
};

# Logic
var EditFlightData = {
	loop: func() {
		# Status Sync
		if (flightData.airportTo == "") {
			if (Value.active) {
				flightplan().cleanPlan();
				gui.popupTip("You need to initialize the MCDU before a route can be activated");
			}
		}
		
		# Force 60K for FLEX
		if (flightData.flexActive) {
			if (!systems.FADEC.Limit.pwDerate.getBoolValue()) {
				systems.FADEC.Limit.pwDerate.setBoolValue(1);
			}
		}
		
		# Calculate UFOB
		flightData.ufobLbs = math.round(pts.Consumables.Fuel.totalFuelLbs.getValue(), 100) / 1000;
		
		# Calculate GW
		if (flightData.zfwLbs > 0) {
			flightData.gwLbs = flightData.zfwLbs + flightData.ufobLbs;
		} else {
			flightData.gwLbs = 0;
		}
		
		# Sync block when engines running
		if (Internal.engOn) {
			flightData.blockFuelLbs = flightData.ufobLbs;
		}
		
		# Calculate speeds
		me.calcSpeeds();
		
		# Write out values for JSBSim to use
		me.writeOut();
		
		# After write out
		# Enable/Disable V speeds Calc
		if (flightData.toFlaps > 0 and flightData.airportFromAlt > -1000 and flightData.toSlope > -100 and flightData.toWind > -100 and flightData.oatC > -100 and flightData.gwLbs > 0) {
			flightData.canCalcVspeeds = 1;
		} else {
			flightData.canCalcVspeeds = 0;
			me.resetVspeeds();
		}
		
		# Check if V speeds still valid
		if (Internal.phase == 0) {
			if (flightData.v1State == 1) {
				if (abs(flightData.v1 - math.round(Speeds.v1.getValue())) > 2) {
					me.resetVspeeds(1);
				}
			}
			if (flightData.vrState == 1) {
				if (abs(flightData.vr - math.round(Speeds.vr.getValue())) > 2) {
					me.resetVspeeds(2);
				}
			}
			if (flightData.v2State == 1) {
				if (abs(flightData.v2 - math.round(Speeds.v2.getValue())) > 2) {
					me.resetVspeeds(3);
				}
			}
		}
		
		# V speeds MCDU message
		if ((flightData.v1State == 0 and fms.Speeds.v1.getValue() > 0) or (flightData.vrState == 0 and fms.Speeds.vr.getValue() > 0) or (flightData.v2State == 0 and fms.Speeds.v2.getValue() > 0)) {
			if (!Internal.Messages.vspeeds) {
				Internal.Messages.vspeeds = 1;
				mcdu.BASE.setGlobalMessage("CHECK/CONFIRM VSPDS");
			}
		} else {
			if (Internal.Messages.vspeeds) {
				Internal.Messages.vspeeds = 0;
				mcdu.BASE.removeGlobalMessage("CHECK/CONFIRM VSPDS");
			}
		}
		
		# Cruise above Max Level MCDU message
		if (flightData.cruiseFl > math.round(Internal.maxAlt.getValue())) {
			if (!Internal.Messages.maxAlt) {
				Internal.Messages.maxAlt = 1;
				mcdu.BASE.setGlobalMessage("CRZ FL ABOVE MAX FL");
			}
		} else {
			if (Internal.Messages.maxAlt) {
				Internal.Messages.maxAlt = 0;
				mcdu.BASE.removeGlobalMessage("CRZ FL ABOVE MAX FL");
			}
		}
	},
	reset: func() {
		# Reset Route Manager
		flightplan().cleanPlan(); # Clear List function in Route Manager
		RouteManager.alternateAirport.setValue("");
		RouteManager.cruiseAlt.setValue(0);
		RouteManager.departureAirport.setValue("");
		RouteManager.destinationAirport.setValue("");
		
		# Clear FlightData
		flightData.reset();
		me.writeOut();
	},
	writeOut: func() { # Write out relevant parts of the FlightData object to property tree as required so that JSBSim can access it
		FlightDataOut.airportFromAlt.setValue(flightData.airportFromAlt);
		FlightDataOut.airportToAlt.setValue(flightData.airportToAlt);
		FlightDataOut.canCalcVspeeds.setBoolValue(flightData.canCalcVspeeds);
		FlightDataOut.costIndex.setValue(flightData.costIndex);
		FlightDataOut.cruiseFl.setValue(flightData.cruiseFl);
		FlightDataOut.flexActive.setBoolValue(flightData.flexActive);
		FlightDataOut.flexTemp.setValue(flightData.flexTemp);
		FlightDataOut.gwLbs.setValue(flightData.gwLbs);
		FlightDataOut.landFlaps.setValue(flightData.landFlaps);
		FlightDataOut.oatC.setValue(flightData.oatC);
		FlightDataOut.tocg.setValue(flightData.tocg);
		FlightDataOut.toFlaps.setValue(flightData.toFlaps);
		FlightDataOut.toPacks.setValue(flightData.toPacks);
		FlightDataOut.toSlope.setValue(flightData.toSlope);
		FlightDataOut.toWind.setValue(flightData.toWind);
		FlightDataOut.togw.setValue(flightData.togwLbs);
		FlightDataOut.v1.setValue(flightData.v1);
		FlightDataOut.v2.setValue(flightData.v2);
		FlightDataOut.vr.setValue(flightData.vr);
		FlightDataOut.zfwcg.setValue(flightData.zfwcg);
		FlightDataOut.zfwLbs.setValue(flightData.zfwLbs);
	},
	calcSpeeds: func() {
		if (!flightData.vappOvrd) {
			flightData.vapp = math.round(fms.Speeds.vapp.getValue());
		}
	},
	insertAlternate: func(arpt) { # Assumes validation is already done
		flightData.airportAltn = arpt;
		RouteManager.alternateAirport.setValue(arpt);
		if (RouteManager.currentWp.getValue() == -1) { # This fixes a weird issue where the Route Manager sets it to -1
			RouteManager.currentWp.setValue(0);
		}
	},
	insertBlockFuel: func(block) { # Recalculate TOGW
		if (flightData.zfwLbs > 0) {
			Value.togw = block + flightData.zfwLbs - flightData.taxiFuel;
			if (Value.togw <= fms.Internal.maxTocg) {
				flightData.blockFuelLbs = block + 0;
				flightData.togwLbs = Value.togw;
				flightData.lastGwZfw = 1;
				me.resetVspeeds();
				return 1;
			} else {
				return 0;
			}
		} else {
			flightData.blockFuelLbs = block + 0;
			return 1;
		}
	},
	insertCruiseFl: func(s1, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0) {
		flightData.cruiseAlt = s1 * 100;
		flightData.cruiseAltAll = [s1 * 100, s2 * 100, s3 * 100, s4 * 100, s5 * 100, s6 * 100];
		flightData.cruiseFl = int(s1);
		flightData.cruiseFlAll = [int(s1), int(s2), int(s3), int(s4), int(s5), int(s6)];
		RouteManager.cruiseAlt.setValue(s1 * 100);
		
		if (s1 == 0) {
			flightData.cruiseTemp = nil;
		} else if (s1 * 100 < 36090) {
			flightData.cruiseTemp = math.round(15 - (math.round(s1 / 10) * 1.98));
		} else {
			flightData.cruiseTemp = -56; # Rounded
		}
	},
	insertGw: func(gw) { # Recalculate TOGW and ZFW, let GW calculate on it's own, block synced with ufob
		Value.zfw = gw - flightData.ufobLbs;
		if (Value.zfw <= fms.Internal.maxZfw) {
			flightData.togwLbs = gw - flightData.taxiFuel;
			flightData.zfwLbs = Value.zfw;
			flightData.lastGwZfw = 0;
			me.resetVspeeds();
			return 1;
		} else {
			return 0;
		}
	},
	insertTaxiFuel: func(taxi) { # Recalculate TOGW or ZFW
		if (flightData.togwLbs > 0 and flightData.zfwLbs > 0) {
			if (flightData.lastGwZfw) { # TOGW
				Value.togw = flightData.blockFuelLbs + flightData.zfwLbs - taxi;
				if (Value.togw <= fms.Internal.maxTocg) {
					flightData.taxiFuel = taxi + 0;
					flightData.togwLbs = Value.togw;
					me.resetVspeeds();
					return 0;
				} else {
					return 1;
				}
			} else { # ZFW
				Value.zfw = flightData.togwLbs + taxi - flightData.blockFuelLbs;
				if (Value.zfw <= fms.Internal.maxZfw) {
					flightData.taxiFuel = taxi;
					flightData.zfwLbs = Value.zfw;
					me.resetVspeeds();
					return 0;
				} else {
					return 2;
				}
			}
		} else {
			flightData.taxiFuel = taxi;
			return 0;
		}
	},
	insertToAlts: func(t = 0) {
		if (flightData.airportFromAlt > -1000) {
			if (t == 0 or t == 1) flightData.climbThrustAlt = math.max(flightData.climbThrustAltCalc = flightData.airportFromAlt + 1500, 0);
			if (t == 0 or t == 2) flightData.accelAlt = math.max(flightData.accelAltCalc = flightData.airportFromAlt + 3000, 0);
			if (t == 0 or t == 3) flightData.accelAltEo = math.max(flightData.accelAltEoCalc = flightData.airportFromAlt + 800, 0);
		} else {
			if (t == 0 or t == 1) flightData.climbThrustAlt = -1000;
			if (t == 0 or t == 2) flightData.accelAlt = -1000;
			if (t == 0 or t == 3) flightData.accelAltEo = -1000;
		}
		
		if (t == 0 or t == 1) flightData.climbThrustAltSet = 0;
		if (t == 0 or t == 2) flightData.accelAltSet = 0;
		if (t == 0 or t == 3) flightData.accelAltEoSet = 0;
	},
	insertTogw: func(togw) { # Recalculate ZFW
		if (flightData.blockFuelLbs > 0) {
			Value.zfw = togw + flightData.taxiFuel - flightData.blockFuelLbs;
			if (Value.zfw <= fms.Internal.maxZfw) {
				flightData.togwLbs = togw + 0;
				flightData.zfwLbs = Value.zfw;
				flightData.lastGwZfw = 0;
				me.resetVspeeds();
				return 1;
			} else {
				return 0;
			}
		} else {
			flightData.togwLbs = togw + 0;
			return 1;
		}
	},
	insertZfw: func(zfw) { # Recalculate TOGW
		if (flightData.blockFuelLbs > 0) {
			Value.togw = zfw + flightData.blockFuelLbs - flightData.taxiFuel;
			if (Value.togw <= fms.Internal.maxTocg) {
				flightData.zfwLbs = zfw + 0;
				flightData.togwLbs = Value.togw;
				flightData.lastGwZfw = 1;
				me.resetVspeeds();
				return 1;
			} else {
				return 0;
			}
		} else {
			flightData.zfwLbs = zfw + 0;
			return 1;
		}
	},
	newFlightplan: func(from, to) { # Assumes validation is already done
		if (pts.Position.wow.getBoolValue()) {
			CORE.resetPhase();
		}
		
		flightplan().cleanPlan(); # Clear List function in Route Manager
		flightData.airportFrom = from;
		flightData.airportTo = to;
		
		RouteManager.departureAirport.setValue(from);
		RouteManager.destinationAirport.setValue(to);
		
		if (!RouteManager.active.getBoolValue()) {
			fgcommand("activate-flightplan", props.Node.new({"activate": 1}));
		}
		if (RouteManager.currentWp.getValue() == -1) { # This fixes a weird issue where the Route Manager sets it to -1
			RouteManager.currentWp.setValue(1);
		}
		
		flightData.airportFromAlt = math.round(airportinfo(flightData.airportFrom).elevation * M2FT);
		flightData.airportToAlt = math.round(airportinfo(flightData.airportTo).elevation * M2FT);
		me.insertToAlts();
		
		me.resetVspeeds();
		flightData.toSlope = -100;
		flightData.toWind = -100;
	},
	resetVspeeds: func(t = 0) {
		if (Internal.phase > 0) return;
		
		if (flightData.v1State == 1 and (t == 0 or t == 1)) {
			flightData.v1 = 0;
			flightData.v1State = 0;
		}
		if (flightData.vrState == 1 and (t == 0 or t == 2)) {
			flightData.vr = 0;
			flightData.vrState = 0;
		}
		if (flightData.v2State == 1 and (t == 0 or t == 3)) {
			flightData.v2 = 0;
			flightData.v2State = 0;
		}
	},
	returnToEcon: func() {
		if (Internal.phase <= 2) {
			flightData.climbSpeedMode = 0;
		} else if (Internal.phase == 3) {
			flightData.cruiseSpeedMode = 0;
		} else {
			flightData.descentSpeedMode = 0;
		}
	},
	setAcconfigWeightBalanceData: func() {
		Internal.request[0] = 0;
		Internal.request[1] = 0;
		Internal.request[2] = 0;
		mcdu.unit[0].setPage("acStatus");
		mcdu.unit[1].setPage("acStatus");
		flightData.gwLbs = sprintf("%5.1f", math.round(pts.Fdm.JSBSim.Inertia.weightLbs.getValue() / 1000, 0.1));
		flightData.tocg = sprintf("%4.1f", math.round(pts.Fdm.JSBSim.Inertia.cgPercentMac.getValue(), 0.1));
		flightData.togwLbs = flightData.gwLbs - flightData.taxiFuel;
		flightData.toFlaps = 15;
		flightData.zfwcg = sprintf("%4.1f", math.round(pts.Fdm.JSBSim.Inertia.zfwcgPercentMac.getValue(), 0.1));
		flightData.zfwLbs = sprintf("%5.1f", math.round(pts.Fdm.JSBSim.Inertia.zfwLbs.getValue() / 1000, 0.1));
	},
	setNpsPhnlTest: func() { # For developer use/testing ONLY!
		me.newFlightplan("NPS", "PHNL");
		me.insertCruiseFl(100);
		flightData.costIndex = 30;
		flightData.oatC = 20;
		flightData.toSlope = 0;
		flightData.toWind = 0;
		me.setAcconfigWeightBalanceData();
	},
};
