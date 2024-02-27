# McDonnell Douglas MD-11 FMS
# Copyright (c) 2024 Josh Davidson (Octal450)
# Where needed + 0 is used to force a string into an int

# Properties and Data
var FlightData = {
	airportAlt: "",
	airportFrom: "",
	airportTo: "",
	blockFuel: 0,
	costIndex: 0,
	cruiseAlt: 0,
	cruiseAltAll: [0, 0, 0, 0, 0, 0],
	cruiseFl: 0,
	cruiseFlAll: [0, 0, 0, 0, 0, 0],
	cruiseTemp: nil,
	flightNumber: "",
	lastTogwZfw: 1, # Which was entered last
	taxiFuel: 0.7,
	tocg: 0,
	togw: 0,
	zfw: 0,
	zfwcg: 0,
	Temp: { # Values used for internal checking, do not use
		togw: 0,
		zfw: 0,
	},
};

# Logic
var FPLN = {
	loop: func() {
		if (pts.Engines.Engine.state[0].getValue() == 3 or pts.Engines.Engine.state[1].getValue() == 3 or pts.Engines.Engine.state[2].getValue() == 3) {
			FlightData.blockFuel = math.round(pts.Consumables.Fuel.totalFuelLbs.getValue(), 100) / 1000;
		}
	},
	resetFlightData: func() {
		flightplan().cleanPlan(); # Clear List function in Route Manager
		RouteManager.alternateAirport.setValue("");
		RouteManager.cruiseAlt.setValue(0);
		RouteManager.departureAirport.setValue("");
		RouteManager.destinationAirport.setValue("");
		FlightData.airportAlt = "";
		FlightData.airportFrom = "";
		FlightData.airportTo = "";
		FlightData.blockFuel = 0;
		FlightData.costIndex = 0;
		FlightData.cruiseAlt = 0;
		FlightData.cruiseAltAll = [0, 0, 0, 0, 0, 0];
		FlightData.cruiseFl = 0;
		FlightData.cruiseFlAll = [0, 0, 0, 0, 0, 0];
		FlightData.cruiseTemp = nil;
		FlightData.flightNumber = "";
		FlightData.lastTogwZfw = 1;
		FlightData.taxiFuel = 0.7;
		FlightData.tocg = 0;
		FlightData.togw = 0;
		FlightData.zfw = 0;
		FlightData.zfwcg = 0;
	},
	newFlightplan: func(from, to) { # Assumes validation is already done
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
	},
	insertAlternate: func(arpt) { # Assumes validation is already done
		FlightData.airportAlt = arpt;
		RouteManager.alternateAirport.setValue(arpt);
		if (RouteManager.currentWp.getValue() == -1) { # This fixes a weird issue where the Route Manager sets it to -1
			RouteManager.currentWp.setValue(0);
		}
	},
	insertBlockFuel: func(block) { # Recalculate TOGW
		if (FlightData.zfw > 0) {
			FlightData.Temp.togw = block + FlightData.zfw - FlightData.taxiFuel;
			if (FlightData.Temp.togw <= mcdu.BASE.initPage2.maxTocg) {
				FlightData.blockFuel = block + 0;
				FlightData.togw = FlightData.Temp.togw;
				FlightData.lastTogwZfw = 1;
				return 1;
			} else {
				return 0;
			}
		} else {
			FlightData.blockFuel = block + 0;
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
	insertTogw: func(togw) { # Recalculate ZFW
		if (FlightData.blockFuel > 0) {
			FlightData.Temp.zfw = togw + FlightData.taxiFuel - FlightData.blockFuel;
			if (FlightData.Temp.zfw <= mcdu.BASE.initPage2.maxZfw) {
				FlightData.togw = togw + 0;
				FlightData.zfw = FlightData.Temp.zfw;
				FlightData.lastTogwZfw = 0;
				return 1;
			} else {
				return 0;
			}
		} else {
			FlightData.togw = togw + 0;
			return 1;
		}
	},
	insertZfw: func(zfw) { # Recalculate TOGW
		if (FlightData.blockFuel > 0) {
			FlightData.Temp.togw = zfw + FlightData.blockFuel - FlightData.taxiFuel;
			if (FlightData.Temp.togw <= mcdu.BASE.initPage2.maxTocg) {
				FlightData.zfw = zfw + 0;
				FlightData.togw = FlightData.Temp.togw;
				FlightData.lastTogwZfw = 1;
				return 1;
			} else {
				return 0;
			}
		} else {
			FlightData.zfw = zfw + 0;
			return 1;
		}
	},
};
