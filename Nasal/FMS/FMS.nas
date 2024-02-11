# McDonnell Douglas MD-11 FMS
# Copyright (c) 2024 Josh Davidson (Octal450)

# Properties and Data
var FlightData = {
	airportAlt: "",
	airportFrom: "",
	airportTo: "",
	costIndex: 0,
	cruiseAlt: 0,
	cruiseAltAll: [0, 0, 0, 0, 0, 0],
	cruiseFl: 0,
	cruiseFlAll: [0, 0, 0, 0, 0, 0],
	cruiseTemp: nil,
	flightNumber: "",
};

var Internal = {
	bankAngle1: props.globals.initNode("/fms/internal/bank-limit-1", 0, "DOUBLE"),
	bankAngle2: props.globals.initNode("/fms/internal/bank-limit-2", 0, "DOUBLE"),
	bankAngleVss: props.globals.initNode("/fms/internal/bank-limit-vss", 0, "DOUBLE"),
};

var RouteManager = {
	active: props.globals.getNode("/autopilot/route-manager/active"),
	alternateAirport: props.globals.getNode("/autopilot/route-manager/alternate/airport"),
	cruiseAlt: props.globals.getNode("/autopilot/route-manager/cruise/altitude-ft"),
	currentWp: props.globals.getNode("/autopilot/route-manager/current-wp"),
	departureAirport: props.globals.getNode("/autopilot/route-manager/departure/airport"),
	destinationAirport: props.globals.getNode("/autopilot/route-manager/destination/airport"),
};

var Speeds = {
	athrMax: props.globals.getNode("/fms/speeds/athr-max"),
	athrMaxMach: props.globals.getNode("/fms/speeds/athr-max-mach"),
	athrMin: props.globals.getNode("/fms/speeds/athr-min"),
	athrMinMach: props.globals.getNode("/fms/speeds/athr-min-mach"),
	flap15Max: props.globals.getNode("/fms/speeds/flap-0-15-max-kts"),
	flap28Max: props.globals.getNode("/fms/speeds/flap-28-max-kts"),
	flap35Max: props.globals.getNode("/fms/speeds/flap-35-max-kts"),
	flap50Max: props.globals.getNode("/fms/speeds/flap-50-max-kts"),
	flapGearMax: props.globals.getNode("/fms/speeds/flap-gear-max"),
	gearExtMax: props.globals.getNode("/fms/speeds/gear-ext-max-kts"),
	gearRetMax: props.globals.getNode("/fms/speeds/gear-ret-max-kts"),
	slatMax: props.globals.getNode("/fms/speeds/slat-max-kts"),
	v1: props.globals.getNode("/fms/speeds/v1"),
	v2: props.globals.getNode("/fms/speeds/v2"),
	v2Plus10: props.globals.getNode("/fms/speeds/v2-plus-10"),
	vcl: props.globals.getNode("/fms/speeds/vcl"),
	vfr: props.globals.getNode("/fms/speeds/vfr"),
	vmax: props.globals.getNode("/fms/speeds/vmax"),
	vmin: props.globals.getNode("/fms/speeds/vmin"),
	vminTape: props.globals.getNode("/fms/speeds/vmin-tape"),
	vmoMmo: props.globals.getNode("/fms/speeds/vmo-mmo"),
	vr: props.globals.getNode("/fms/speeds/vr"),
	vsr: props.globals.getNode("/fms/speeds/vsr"),
	vss: props.globals.getNode("/fms/speeds/vss"),
	vssTape: props.globals.getNode("/fms/speeds/vss-tape"),
};

# Logic
var CORE = {
	resetFms: func() {
		afs.ITAF.init(1); # First
		FPLN.resetFlightData();
		mcdu.BASE.reset(); # Last
	},
	resetRadio: func() {
		pts.Instrumentation.Adf.Frequencies.selectedKhz[0].setValue(0);
		pts.Instrumentation.Adf.Frequencies.selectedKhz[1].setValue(0);
		pts.Instrumentation.Nav.Frequencies.selectedMhz[0].setValue(0);
		pts.Instrumentation.Nav.Frequencies.selectedMhz[1].setValue(0);
		pts.Instrumentation.Nav.Frequencies.selectedMhz[2].setValue(0);
		pts.Instrumentation.Nav.Radials.selectedDeg[0].setValue(0);
		pts.Instrumentation.Nav.Radials.selectedDeg[1].setValue(0);
		pts.Instrumentation.Nav.Radials.selectedDeg[2].setValue(0);
	},
};

var FPLN = {
	resetFlightData: func() {
		flightplan().cleanPlan(); # Clear List function in Route Manager
		RouteManager.alternateAirport.setValue("");
		RouteManager.cruiseAlt.setValue(0);
		RouteManager.departureAirport.setValue("");
		RouteManager.destinationAirport.setValue("");
		FlightData.airportAlt = "";
		FlightData.airportFrom = "";
		FlightData.airportTo = "";
		FlightData.costIndex = 0;
		FlightData.cruiseAlt = 0;
		FlightData.cruiseAltAll = [0, 0, 0, 0, 0, 0];
		FlightData.cruiseFl = 0;
		FlightData.cruiseFlAll = [0, 0, 0, 0, 0, 0];
		FlightData.cruiseTemp = nil;
		FlightData.flightNumber = "";
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
	insertCruiseFl: func(s1, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0) {
		FlightData.cruiseAlt = s1 * 100;
		FlightData.cruiseAltAll = [s1 * 100, s2 * 100, s3 * 100, s4 * 100, s5 * 100, s6 * 100];
		FlightData.cruiseFl = s1;
		FlightData.cruiseFlAll = [s1, s2, s3, s4, s5, s6];
		if (s1 == 0) {
			FlightData.cruiseTemp = nil;
		} else if (s1 * 100 < 36090) {
			FlightData.cruiseTemp = math.round(15 - (math.round(s1 / 10) * 1.98));
		} else {
			FlightData.cruiseTemp = -56; # Rounded
		}
		RouteManager.cruiseAlt.setValue(s1 * 100);
	},
};
