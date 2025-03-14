# McDonnell Douglas MD-11 FMS
# Copyright (c) 2025 Josh Davidson (Octal450)
# Where needed + 0 is used to force a string to a number

# Properties and Data
var FlightData = {
	accelAlt: -1000,
	accelAltSet: 0,
	accelAltEo: -1000,
	accelAltEoSet: 0,
	airportAltn: "",
	airportFrom: "",
	airportFromAlt: -1000,
	airportTo: "",
	airportToAlt: -1000,
	blockFuelLbs: 0,
	canCalcVspeeds: 0,
	climbSpeedEditKts: 0,
	climbSpeedEditMach: 0,
	climbSpeedMode: 0, # 0 = ECON, 1 = MAX, 2 = EDIT
	climbThrustAlt: -1000,
	climbThrustAltSet: 0,
	climbTransAlt: 18000,
	costIndex: -1,
	cruiseAlt: 0,
	cruiseAltAll: [0, 0, 0, 0, 0, 0],
	cruiseFl: 0,
	cruiseFlAll: [0, 0, 0, 0, 0, 0],
	cruiseSpeedEdit: 0,
	cruiseSpeedMode: 0, # 0 = ECON, 1 = MAX, 2 = EDIT
	cruiseTemp: nil,
	descentSpeedEditKts: 0,
	descentSpeedEditMach: 0,
	descentSpeedMode: 0, # 0 = ECON, 1 = MAX, 2 = EDIT
	descentTransAlt: 18000,
	flexActive: 0,
	flexTemp: 0,
	flightNumber: "",
	gwLbs: 0,
	landFlaps: 35,
	lastGwZfw: 1, # Which was entered last
	oatC: -100,
	oatUnit: 0,
	taxiFuel: 1.5,
	taxiFuelSet: 0,
	tocg: 0,
	toFlaps: 0,
	toPacks: 0,
	toSlope: -100, 
	toWind: -100,
	togwLbs: 0,
	ufobLbs: 0,
	v1: 0,
	v1State: 0,
	v2: 0,
	v2State: 0,
	vapp: 0,
	vappOvrd: 0,
	vr: 0,
	vrState: 0,
	zfwcg: 0,
	zfwLbs: 0,
	Temp: { # Values used for internal checking, do not use
		togw: 0,
		zfw: 0,
	},
};

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

# Logic
var EditFlightData = {
	loop: func() {
		# Status Sync
		if (FlightData.airportTo == "") {
			if (Value.active) {
				flightplan().cleanPlan();
				gui.popupTip("You need to initialize the MCDU before a route can be activated");
			}
		}
		
		# Force 60K for FLEX
		if (FlightData.flexActive) {
			if (!systems.FADEC.Limit.pwDerate.getBoolValue()) {
				systems.FADEC.Limit.pwDerate.setBoolValue(1);
			}
		}
		
		# Calculate UFOB
		FlightData.ufobLbs = math.round(pts.Consumables.Fuel.totalFuelLbs.getValue(), 100) / 1000;
		
		# Calculate GW
		if (FlightData.zfwLbs > 0) {
			FlightData.gwLbs = FlightData.zfwLbs + FlightData.ufobLbs;
		} else {
			FlightData.gwLbs = 0;
		}
		
		# Sync block when engines running
		if (Internal.engOn) {
			FlightData.blockFuelLbs = FlightData.ufobLbs;
		}
		
		# Calculate speeds
		me.calcSpeeds();
		
		# Write out values for JSBSim to use
		me.writeOut();
		
		# After write out
		# Enable/Disable V speeds Calc
		if (FlightData.airportFromAlt > -1000 and FlightData.toSlope > -100 and FlightData.toWind > -100 and FlightData.oatC > -100 and FlightData.gwLbs > 0) {
			FlightData.canCalcVspeeds = 1;
		} else {
			FlightData.canCalcVspeeds = 0;
			me.resetVspeeds();
		}
		
		# Check if V speeds still valid
		if (Internal.phase == 0) {
			if (FlightData.v1State == 1) {
				if (abs(FlightData.v1 - math.round(Speeds.v1.getValue())) > 2) {
					me.resetVspeeds(1);
				}
			}
			if (FlightData.vrState == 1) {
				if (abs(FlightData.vr - math.round(Speeds.vr.getValue())) > 2) {
					me.resetVspeeds(2);
				}
			}
			if (FlightData.v2State == 1) {
				if (abs(FlightData.v2 - math.round(Speeds.v2.getValue())) > 2) {
					me.resetVspeeds(3);
				}
			}
		}
		
		# V speeds MCDU message
		if ((FlightData.v1State == 0 and fms.Speeds.v1.getValue() > 0) or (FlightData.vrState == 0 and fms.Speeds.vr.getValue() > 0) or (FlightData.v2State == 0 and fms.Speeds.v2.getValue() > 0)) {
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
	},
	reset: func() {
		# Reset Route Manager
		flightplan().cleanPlan(); # Clear List function in Route Manager
		RouteManager.alternateAirport.setValue("");
		RouteManager.cruiseAlt.setValue(0);
		RouteManager.departureAirport.setValue("");
		RouteManager.destinationAirport.setValue("");
		
		# Clear FlightData
		FlightData.accelAlt = -1000;
		FlightData.accelAltSet = 0;
		FlightData.accelAltEo = -1000;
		FlightData.accelAltEoSet = 0;
		FlightData.airportAltn = "";
		FlightData.airportFrom = "";
		FlightData.airportFromAlt = -1000;
		FlightData.airportTo = "";
		FlightData.airportToAlt = -1000;
		FlightData.blockFuelLbs = 0;
		FlightData.canCalcVspeeds = 0;
		FlightData.climbSpeedEditKts = 0;
		FlightData.climbSpeedEditMach = 0;
		FlightData.climbSpeedMode = 0;
		FlightData.climbThrustAlt = -1000;
		FlightData.climbThrustAltSet = 0;
		FlightData.climbTransAlt = 18000;
		FlightData.costIndex = -1;
		FlightData.cruiseAlt = 0;
		FlightData.cruiseAltAll = [0, 0, 0, 0, 0, 0];
		FlightData.cruiseFl = 0;
		FlightData.cruiseFlAll = [0, 0, 0, 0, 0, 0];
		FlightData.cruiseSpeedEditKts = 0;
		FlightData.cruiseSpeedEditMach = 0;
		FlightData.cruiseSpeedMode = 0;
		FlightData.cruiseTemp = nil;
		FlightData.descentSpeedEditKts = 0;
		FlightData.descentSpeedEditMach = 0;
		FlightData.descentSpeedMode = 0;
		FlightData.descentTransAlt = 18000;
		FlightData.flexActive = 0;
		FlightData.flexTemp = 0;
		FlightData.flightNumber = "";
		FlightData.landFlaps = 35;
		FlightData.lastGwZfw = 1;
		FlightData.oatC = -100;
		FlightData.oatUnit = 0;
		FlightData.taxiFuel = 1.5;
		FlightData.taxiFuelSet = 0;
		FlightData.tocg = 0;
		FlightData.toFlaps = 0;
		FlightData.toPacks = 0;
		FlightData.toSlope = -100;
		FlightData.toWind = -100;
		FlightData.togwLbs = 0;
		FlightData.v1 = 0;
		FlightData.v1State = 0;
		FlightData.v2 = 0;
		FlightData.v2State = 0;
		FlightData.vapp = 0;
		FlightData.vappOvrd = 0;
		FlightData.vr = 0;
		FlightData.vrState = 0;
		FlightData.zfwcg = 0;
		FlightData.zfwLbs = 0;
		me.writeOut();
	},
	writeOut: func() { # Write out FlightData to property tree as required so that JSBSim can access it
		FlightDataOut.airportFromAlt.setValue(FlightData.airportFromAlt);
		FlightDataOut.airportToAlt.setValue(FlightData.airportToAlt);
		FlightDataOut.canCalcVspeeds.setBoolValue(FlightData.canCalcVspeeds);
		FlightDataOut.costIndex.setValue(FlightData.costIndex);
		FlightDataOut.cruiseFl.setValue(FlightData.cruiseFl);
		FlightDataOut.flexActive.setBoolValue(FlightData.flexActive);
		FlightDataOut.flexTemp.setValue(FlightData.flexTemp);
		FlightDataOut.gwLbs.setValue(FlightData.gwLbs);
		FlightDataOut.landFlaps.setValue(FlightData.landFlaps);
		FlightDataOut.oatC.setValue(FlightData.oatC);
		FlightDataOut.tocg.setValue(FlightData.tocg);
		FlightDataOut.toFlaps.setValue(FlightData.toFlaps);
		FlightDataOut.toPacks.setValue(FlightData.toPacks);
		FlightDataOut.toSlope.setValue(FlightData.toSlope);
		FlightDataOut.toWind.setValue(FlightData.toWind);
		FlightDataOut.togw.setValue(FlightData.togwLbs);
		FlightDataOut.v1.setValue(FlightData.v1);
		FlightDataOut.v2.setValue(FlightData.v2);
		FlightDataOut.vr.setValue(FlightData.vr);
		FlightDataOut.zfwcg.setValue(FlightData.zfwcg);
		FlightDataOut.zfwLbs.setValue(FlightData.zfwLbs);
	},
	calcSpeeds: func() {
		if (!FlightData.vappOvrd) {
			FlightData.vapp = math.round(fms.Speeds.vapp.getValue());
		}
	},
	insertAlternate: func(arpt) { # Assumes validation is already done
		FlightData.airportAltn = arpt;
		RouteManager.alternateAirport.setValue(arpt);
		if (RouteManager.currentWp.getValue() == -1) { # This fixes a weird issue where the Route Manager sets it to -1
			RouteManager.currentWp.setValue(0);
		}
	},
	insertBlockFuel: func(block) { # Recalculate TOGW
		if (FlightData.zfwLbs > 0) {
			FlightData.Temp.togw = block + FlightData.zfwLbs - FlightData.taxiFuel;
			if (FlightData.Temp.togw <= fms.Internal.maxTocg) {
				FlightData.blockFuelLbs = block + 0;
				FlightData.togwLbs = FlightData.Temp.togw;
				FlightData.lastGwZfw = 1;
				me.resetVspeeds();
				return 1;
			} else {
				return 0;
			}
		} else {
			FlightData.blockFuelLbs = block + 0;
			return 1;
		}
	},
	insertCruiseFl: func(s1, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0) {
		FlightData.cruiseAlt = s1 * 100;
		FlightData.cruiseAltAll = [s1 * 100, s2 * 100, s3 * 100, s4 * 100, s5 * 100, s6 * 100];
		FlightData.cruiseFl = int(s1);
		FlightData.cruiseFlAll = [int(s1), int(s2), int(s3), int(s4), int(s5), int(s6)];
		RouteManager.cruiseAlt.setValue(s1 * 100);
		
		if (s1 == 0) {
			FlightData.cruiseTemp = nil;
		} else if (s1 * 100 < 36090) {
			FlightData.cruiseTemp = math.round(15 - (math.round(s1 / 10) * 1.98));
		} else {
			FlightData.cruiseTemp = -56; # Rounded
		}
	},
	insertGw: func(gw) { # Recalculate TOGW and ZFW, let GW calculate on it's own, block synced with ufob
		FlightData.Temp.zfw = gw - FlightData.ufobLbs;
		if (FlightData.Temp.zfw <= fms.Internal.maxZfw) {
			FlightData.togwLbs = gw - FlightData.taxiFuel;
			FlightData.zfwLbs = FlightData.Temp.zfw;
			FlightData.lastGwZfw = 0;
			me.resetVspeeds();
			return 1;
		} else {
			return 0;
		}
	},
	insertTaxiFuel: func(taxi) { # Recalculate TOGW or ZFW
		if (FlightData.togwLbs > 0 and FlightData.zfwLbs > 0) {
			if (FlightData.lastGwZfw) { # TOGW
				FlightData.Temp.togw = FlightData.blockFuelLbs + FlightData.zfwLbs - taxi;
				if (FlightData.Temp.togw <= fms.Internal.maxTocg) {
					FlightData.taxiFuel = taxi + 0;
					FlightData.togwLbs = FlightData.Temp.togw;
					me.resetVspeeds();
					return 0;
				} else {
					return 1;
				}
			} else { # ZFW
				FlightData.Temp.zfw = FlightData.togwLbs + taxi - FlightData.blockFuelLbs;
				if (FlightData.Temp.zfw <= fms.Internal.maxZfw) {
					FlightData.taxiFuel = taxi;
					FlightData.zfwLbs = FlightData.Temp.zfw;
					me.resetVspeeds();
					return 0;
				} else {
					return 2;
				}
			}
		} else {
			FlightData.taxiFuel = taxi;
			return 0;
		}
	},
	insertToAlts: func(t = 0) {
		if (FlightData.airportFromAlt > -1000) {
			if (t == 0 or t == 1) FlightData.climbThrustAlt = math.max(FlightData.climbThrustAltCalc = FlightData.airportFromAlt + 1500, 0);
			if (t == 0 or t == 2) FlightData.accelAlt = math.max(FlightData.accelAltCalc = FlightData.airportFromAlt + 3000, 0);
			if (t == 0 or t == 3) FlightData.accelAltEo = math.max(FlightData.accelAltEoCalc = FlightData.airportFromAlt + 800, 0);
		} else {
			if (t == 0 or t == 1) FlightData.climbThrustAlt = -1000;
			if (t == 0 or t == 2) FlightData.accelAlt = -1000;
			if (t == 0 or t == 3) FlightData.accelAltEo = -1000;
		}
		
		if (t == 0 or t == 1) FlightData.climbThrustAltSet = 0;
		if (t == 0 or t == 2) FlightData.accelAltSet = 0;
		if (t == 0 or t == 3) FlightData.accelAltEoSet = 0;
	},
	insertTogw: func(togw) { # Recalculate ZFW
		if (FlightData.blockFuelLbs > 0) {
			FlightData.Temp.zfw = togw + FlightData.taxiFuel - FlightData.blockFuelLbs;
			if (FlightData.Temp.zfw <= fms.Internal.maxZfw) {
				FlightData.togwLbs = togw + 0;
				FlightData.zfwLbs = FlightData.Temp.zfw;
				FlightData.lastGwZfw = 0;
				me.resetVspeeds();
				return 1;
			} else {
				return 0;
			}
		} else {
			FlightData.togwLbs = togw + 0;
			return 1;
		}
	},
	insertZfw: func(zfw) { # Recalculate TOGW
		if (FlightData.blockFuelLbs > 0) {
			FlightData.Temp.togw = zfw + FlightData.blockFuelLbs - FlightData.taxiFuel;
			if (FlightData.Temp.togw <= fms.Internal.maxTocg) {
				FlightData.zfwLbs = zfw + 0;
				FlightData.togwLbs = FlightData.Temp.togw;
				FlightData.lastGwZfw = 1;
				me.resetVspeeds();
				return 1;
			} else {
				return 0;
			}
		} else {
			FlightData.zfwLbs = zfw + 0;
			return 1;
		}
	},
	newFlightplan: func(from, to) { # Assumes validation is already done
		if (pts.Position.wow.getBoolValue()) {
			CORE.resetPhase();
		}
		
		flightplan().cleanPlan(); # Clear List function in Route Manager
		FlightData.airportFrom = from;
		FlightData.airportTo = to;
		
		RouteManager.departureAirport.setValue(from);
		RouteManager.destinationAirport.setValue(to);
		
		if (!RouteManager.active.getBoolValue()) {
			fgcommand("activate-flightplan", props.Node.new({"activate": 1}));
		}
		if (RouteManager.currentWp.getValue() == -1) { # This fixes a weird issue where the Route Manager sets it to -1
			RouteManager.currentWp.setValue(1);
		}
		
		FlightData.airportFromAlt = math.round(airportinfo(FlightData.airportFrom).elevation * M2FT);
		FlightData.airportToAlt = math.round(airportinfo(FlightData.airportTo).elevation * M2FT);
		me.insertToAlts();
		
		me.resetVspeeds();
		FlightData.toSlope = -100;
		FlightData.toWind = -100;
	},
	resetVspeeds: func(t = 0) {
		if (Internal.phase > 0) return;
		
		if (FlightData.v1State == 1 and (t == 0 or t == 1)) {
			FlightData.v1 = 0;
			FlightData.v1State = 0;
		}
		if (FlightData.vrState == 1 and (t == 0 or t == 2)) {
			FlightData.vr = 0;
			FlightData.vrState = 0;
		}
		if (FlightData.v2State == 1 and (t == 0 or t == 3)) {
			FlightData.v2 = 0;
			FlightData.v2State = 0;
		}
	},
	returnToEcon: func() {
		if (Internal.phase <= 2) {
			FlightData.climbSpeedMode = 0;
		} else if (Internal.phase == 3) {
			FlightData.cruiseSpeedMode = 0;
		} else {
			FlightData.descentSpeedMode = 0;
		}
	},
	setAcconfigWeightBalanceData: func() {
		Internal.request[0] = 0;
		Internal.request[1] = 0;
		Internal.request[2] = 0;
		mcdu.unit[0].setPage("acStatus");
		mcdu.unit[1].setPage("acStatus");
		FlightData.gwLbs = sprintf("%5.1f", math.round(pts.Fdm.JSBSim.Inertia.weightLbs.getValue() / 1000, 0.1));
		FlightData.tocg = sprintf("%4.1f", math.round(pts.Fdm.JSBSim.Inertia.cgPercentMac.getValue(), 0.1));
		FlightData.togwLbs = FlightData.gwLbs - FlightData.taxiFuel;
		FlightData.toFlaps = 15;
		FlightData.zfwcg = sprintf("%4.1f", math.round(pts.Fdm.JSBSim.Inertia.zfwcgPercentMac.getValue(), 0.1));
		FlightData.zfwLbs = sprintf("%5.1f", math.round(pts.Fdm.JSBSim.Inertia.zfwLbs.getValue() / 1000, 0.1));
	},
	setNpsPhnlTest: func() { # For developer use/testing ONLY!
		me.newFlightplan("NPS", "PHNL");
		me.insertCruiseFl(100);
		FlightData.costIndex = 30;
		FlightData.oatC = 20;
		FlightData.toSlope = 0;
		FlightData.toWind = 0;
		me.setAcconfigWeightBalanceData();
	},
};
