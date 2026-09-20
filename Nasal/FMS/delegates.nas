# Custom Delegates
# Disables unwanted Route Manager/GPS behavior
# Copyright (c) 2026 Josh Davidson (Octal450)

setprop("/autopilot/route-manager/disable-fms", 1);

var CustomRouteManagerDelegate = {
	new: func(fp) {
		var m = { parents: [CustomRouteManagerDelegate] };
		
		#logprint(LOG_INFO, 'CustomRouteManagerDelegate loaded');
		
		m.flightplan = fp;
		return m;
	},
	departureChanged: func
	{
		# Disabled, do nothing
	},
	arrivalChanged: func
	{
		# Disabled, do nothing
	},
	cleared: func
	{
		# Disabled, do nothing
	},
	endOfFlightPlan: func
	{
		# Disabled, do nothing
	}
};

var GPSPath = "/instrumentation/gps";
var CustomGPSDelegate = {
	new: func(fp) {
		var m = { parents: [CustomGPSDelegate], flightplan:fp, landingCheck:nil };
		
		#logprint(LOG_INFO, 'CustomGPSDelegate loaded');
		
		# tell the GPS C++ code we will do sequencing ourselves, so it can disable
		# its legacy logic for this
		
		setprop(GPSPath ~ '/config/delegate-sequencing', 1);
		
		# disable turn anticipation
		setprop(GPSPath ~ '/config/enable-fly-by', 1);
		
		# flyOver maximum distance
		setprop(GPSPath ~ '/config/over-flight-arm-distance', 5);
		
		fp.followLegTrackToFix = 1;
		fp.aircraftCategory = 'C';
		
		m._modeProp = props.globals.getNode(GPSPath ~ '/mode');
		return m;
	},
	_landingCheckTimeout: func
	{ # Disabled
	},
	_captureCurrentCourse: func
	{
		setprop(GPSPath ~ "/selected-course-deg", getprop(GPSPath ~ "/desired-course-deg"));
	},
	_selectOBSMode: func
	{
		setprop(GPSPath ~ "/command", "obs");
	},	waypointsChanged: func
	{
	},
	activated: func
	{
		if (!me.flightplan.active)
			return;

		#logprint(LOG_INFO,'flightplan activated, default GPS to LEG mode');
		setprop(GPSPath ~ "/command", "leg");
	},
	deactivated: func
	{
		if (me._modeProp.getValue() == 'leg') {
			#logprint(LOG_INFO, 'flightplan deactivated, default GPS to OBS mode');
			me._captureCurrentCourse();
			me._selectOBSMode();
		}
	},
	endOfFlightPlan: func
	{
		if (me._modeProp.getValue() == 'leg') {
			#logprint(LOG_INFO, 'end of flight-plan, switching GPS to OBS mode');
			me._captureCurrentCourse();
			me._selectOBSMode();
		}
	},
	cleared: func
	{
		if (!me.flightplan.active)
			return;

		if (me._modeProp.getValue() == 'leg') {
			#logprint(LOG_INFO, 'flight-plan cleared, switching GPS to OBS mode');
			me._captureCurrentCourse();
			me._selectOBSMode();
		}
	},
	sequence: func
	{
		# Disabled, do nothing
	},
	currentWaypointChanged: func
	{
		if (!me.flightplan.active)
			return;
		
		var active = me.flightplan.currentWP();
		if (active == nil) return;
	}
};

registerFlightPlanDelegate(CustomGPSDelegate.new);
registerFlightPlanDelegate(CustomRouteManagerDelegate.new);
