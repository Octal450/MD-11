# McDonnell Douglas MD-11 FMS
# Copyright (c) 2024 Josh Davidson (Octal450)
# Where needed + 0 is used to force a string into an int

# Properties and Data
var FlightData = {
	accelAlt: -10000,
	accelAltSet: 0,
	accelAltEo: -10000,
	accelAltEoSet: 0,
	airportAlt: "",
	airportFrom: "",
	airportFromElev: -10000,
	airportTo: "",
	blockFuelLbs: 0,
	canCalcVspeeds: 0,
	climbThrustAlt: -10000,
	climbThrustAltSet: 0,
	costIndex: 0,
	cruiseAlt: 0,
	cruiseAltAll: [0, 0, 0, 0, 0, 0],
	cruiseFl: 0,
	cruiseFlAll: [0, 0, 0, 0, 0, 0],
	cruiseTemp: nil,
	flexActive: 0,
	flexTemp: 0,
	flightNumber: "",
	gwLbs: 0,
	lastGwZfw: 1, # Which was entered last
	oatC: -100,
	oatUnit: 0,
	taxiFuel: 0.7,
	taxiFuelSet: 0,
	tocg: 0,
	toFlaps: 0,
	togwLbs: 0,
	toPacks: 0,
	toSlope: -100, 
	toWind: -100,
	ufobLbs: 0,
	zfwcg: 0,
	zfwLbs: 0,
	Temp: { # Values used for internal checking, do not use
		togw: 0,
		zfw: 0,
	},
};

var FlightDataOut = {
	flexActive: props.globals.getNode("/fms/flight-data/flex-active"),
	flexTemp: props.globals.getNode("/fms/flight-data/flex-temp"),
	gwLbs: props.globals.getNode("/fms/flight-data/gw-lbs"),
	oatC: props.globals.getNode("/fms/flight-data/oat-c"),
	toFlaps: props.globals.getNode("/fms/flight-data/to-flaps"),
	togw: props.globals.getNode("/fms/flight-data/togw-lbs"),
	toPacks: props.globals.getNode("/fms/flight-data/to-packs"),
	zfwcg: props.globals.getNode("/fms/flight-data/zfwcg"),
	zfwLbs: props.globals.getNode("/fms/flight-data/zfw-lbs"),
};

# Logic
var EditFlightData = {
	loop: func() {
		FlightData.ufobLbs = math.round(pts.Consumables.Fuel.totalFuelLbs.getValue(), 100) / 1000;
		
		if (Internal.engOn) {
			FlightData.blockFuelLbs = FlightData.ufobLbs;
		}
		
		if (FlightData.zfwLbs > 0) {
			FlightData.gwLbs = FlightData.zfwLbs + FlightData.ufobLbs;
		} else {
			FlightData.gwLbs = 0;
		}
		
		me.writeOut();
		
		# After write out
		if (FlightData.airportFrom != "" and FlightData.toSlope > -100 and FlightData.toWind > -100 and FlightData.gwLbs > 0) {
			FlightData.canCalcVspeeds = 1;
		} else {
			FlightData.canCalcVspeeds = 0;
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
		FlightData.accelAlt = -10000;
		FlightData.accelAltSet = 0;
		FlightData.accelAltEo = -10000;
		FlightData.accelAltEoSet = 0;
		FlightData.airportAlt = "";
		FlightData.airportFrom = "";
		FlightData.airportFromElev = -10000;
		FlightData.airportTo = "";
		FlightData.blockFuelLbs = 0;
		FlightData.climbThrustAlt = -10000;
		FlightData.climbThrustAltSet = 0;
		FlightData.costIndex = 0;
		FlightData.cruiseAlt = 0;
		FlightData.cruiseAltAll = [0, 0, 0, 0, 0, 0];
		FlightData.cruiseFl = 0;
		FlightData.cruiseFlAll = [0, 0, 0, 0, 0, 0];
		FlightData.cruiseTemp = nil;
		FlightData.flexActive = 0;
		FlightData.flexTemp = 0;
		FlightData.flightNumber = "";
		FlightData.lastGwZfw = 1;
		FlightData.oatC = -100;
		FlightData.oatUnit = 0;
		FlightData.taxiFuel = 0.7;
		FlightData.taxiFuelSet = 0;
		FlightData.tocg = 0;
		FlightData.toFlaps = 0;
		FlightData.togwLbs = 0;
		FlightData.toPacks = 0;
		FlightData.toSlope = -100;
		FlightData.toWind = -100;
		FlightData.zfwcg = 0;
		FlightData.zfwLbs = 0;
		me.writeOut();
	},
	writeOut: func() { # Write out FlightData to property tree as required so that JSBsim can access it
		FlightDataOut.flexActive.setBoolValue(FlightData.flexActive);
		FlightDataOut.flexTemp.setValue(FlightData.flexTemp);
		FlightDataOut.gwLbs.setValue(FlightData.gwLbs);
		FlightDataOut.oatC.setValue(FlightData.oatC);
		FlightDataOut.toFlaps.setValue(FlightData.toFlaps);
		FlightDataOut.togw.setValue(FlightData.togwLbs);
		FlightDataOut.toPacks.setValue(FlightData.toPacks);
		FlightDataOut.zfwcg.setValue(FlightData.zfwcg);
		FlightDataOut.zfwLbs.setValue(FlightData.zfwLbs);
	},
	newFlightplan: func(from, to) { # Assumes validation is already done
		flightplan().cleanPlan(); # Clear List function in Route Manager
		FlightData.airportFrom = from;
		FlightData.airportTo = to;
		
		RouteManager.departureAirport.setValue(from);
		RouteManager.destinationAirport.setValue(to);
		
		if (!RouteManager.active.getBoolValue()) {
			fgcommand("activate-flightplan", props.Node.new({"activate": 1}));
		}
		if (RouteManager.currentWp.getValue() == -1) { # This fixes a weird issue where the Route Manager sets it to -1
			RouteManager.currentWp.setValue(0);
		}
		
		FlightData.airportFromElev = math.round(airportinfo(FlightData.airportFrom).elevation * M2FT);
		FlightData.toSlope = -100;
		FlightData.toWind = -100;
	},
	insertAlternate: func(arpt) { # Assumes validation is already done
		FlightData.airportAlt = arpt;
		RouteManager.alternateAirport.setValue(arpt);
		if (RouteManager.currentWp.getValue() == -1) { # This fixes a weird issue where the Route Manager sets it to -1
			RouteManager.currentWp.setValue(0);
		}
	},
	insertBlockFuel: func(block) { # Recalculate TOGW
		if (FlightData.zfwLbs > 0) {
			FlightData.Temp.togw = block + FlightData.zfwLbs - FlightData.taxiFuel;
			if (FlightData.Temp.togw <= mcdu.BASE.initPage2.maxTocg) {
				FlightData.blockFuelLbs = block + 0;
				FlightData.togwLbs = FlightData.Temp.togw;
				FlightData.lastGwZfw = 1;
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
		FlightData.cruiseFl = s1 + 0;
		FlightData.cruiseFlAll = [s1 + 0, s2 + 0, s3 + 0, s4 + 0, s5 + 0, s6 + 0];
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
		if (FlightData.Temp.zfw <= mcdu.BASE.initPage2.maxZfw) {
			FlightData.togwLbs = gw - FlightData.taxiFuel;
			FlightData.zfwLbs = FlightData.Temp.zfw;
			FlightData.lastGwZfw = 0;
			return 1;
		} else {
			return 0;
		}
	},
	insertTaxiFuel: func(taxi) { # Recalculate TOGW or ZFW
		if (FlightData.togwLbs > 0 and FlightData.zfwLbs > 0) {
			if (FlightData.lastGwZfw) { # TOGW
				FlightData.Temp.togw = FlightData.blockFuelLbs + FlightData.zfwLbs - taxi;
				if (FlightData.Temp.togw <= mcdu.BASE.initPage2.maxTocg) {
					FlightData.taxiFuel = taxi + 0;
					FlightData.togwLbs = FlightData.Temp.togw;
					return 0;
				} else {
					return 1;
				}
			} else { # ZFW
				FlightData.Temp.zfw = FlightData.togwLbs + taxi - FlightData.blockFuelLbs;
				if (FlightData.Temp.zfw <= mcdu.BASE.initPage2.maxZfw) {
					FlightData.taxiFuel = taxi + 0;
					FlightData.zfwLbs = FlightData.Temp.zfw;
					return 0;
				} else {
					return 2;
				}
			}
		} else {
			FlightData.taxiFuel = taxi + 0;
			return 0;
		}
	},
	insertTogw: func(togw) { # Recalculate ZFW
		if (FlightData.blockFuelLbs > 0) {
			FlightData.Temp.zfw = togw + FlightData.taxiFuel - FlightData.blockFuelLbs;
			if (FlightData.Temp.zfw <= mcdu.BASE.initPage2.maxZfw) {
				FlightData.togwLbs = togw + 0;
				FlightData.zfwLbs = FlightData.Temp.zfw;
				FlightData.lastGwZfw = 0;
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
			if (FlightData.Temp.togw <= mcdu.BASE.initPage2.maxTocg) {
				FlightData.zfwLbs = zfw + 0;
				FlightData.togwLbs = FlightData.Temp.togw;
				FlightData.lastGwZfw = 1;
				return 1;
			} else {
				return 0;
			}
		} else {
			FlightData.zfwLbs = zfw + 0;
			return 1;
		}
	},
};
