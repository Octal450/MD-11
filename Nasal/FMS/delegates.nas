# Custom Delegates
# Disables unwanted Route Manager/GPS behavior
# Copyright (c) 2026 Josh Davidson (Octal450)

var CustomRouteManagerDelegate = {
	new: func(fp) {
		var m = { parents: [CustomRouteManagerDelegate] };
		
		#logprint(LOG_INFO, 'CustomRouteManagerDelegate loaded');
		
		m.flightplan = fp;
		return m;
	},
	
	departureChanged: func
	{
		#logprint(LOG_INFO, 'saw departure changed');
		me.flightplan.clearWPType('sid');
		if (me.flightplan.departure == nil)
			return;
		
		if (me.flightplan.departure_runway == nil) {
			# no runway, only an airport, use that
			var wp = createWPFrom(me.flightplan.departure);
			wp.wp_role = 'sid';
			me.flightplan.insertWP(wp, 0);
			return;
		}
		# first, insert the runway itself
		var wp = createWPFrom(me.flightplan.departure_runway);
		wp.wp_role = 'sid';
		me.flightplan.insertWP(wp, 0);
		if (me.flightplan.sid == nil)
			return;

		# and we have a SID
		var sid = me.flightplan.sid;
		#logprint(LOG_INFO, 'routing via SID ' ~ sid.id);
		
		var wps = sid.route(me.flightplan.departure_runway, me.flightplan.sid_trans);
		var lastWP = wps[-1];
		var foundIdx = -999;
		
		for (var wptIdx = 0; wptIdx < me.flightplan.getPlanSize(); wptIdx = wptIdx + 1) {
			if (me.flightplan.getWP(wptIdx).id == lastWP.id) {
				foundIdx = wptIdx;
				break;
			}
		}
		
		if (foundIdx != -999) {
			while (foundIdx > 0) {
				me.flightplan.deleteWP(1);
				foundIdx -= 1;
			}
		}
		
		me.flightplan.insertWaypoints(wps, 1);
	},
	arrivalChanged: func
	{
		me.flightplan.clearWPType('star');
		me.flightplan.clearWPType('approach');
		if (me.flightplan.destination == nil)
			return;
		
		if (me.flightplan.destination_runway == nil) {
		# no runway, only an airport, use that
			var wp = createWPFrom(me.flightplan.destination);
			wp.wp_role = 'approach';
			me.flightplan.appendWP(wp);
			return;
		}
		
		var initialApproachFix = nil;
		if (me.flightplan.star != nil) {
			#logprint(LOG_INFO, 'routing via STAR ' ~ me.flightplan.star.id);
			var wps = me.flightplan.star.route(me.flightplan.destination_runway, me.flightplan.star_trans);
			if (wps != nil) {
				me.flightplan.insertWaypoints(wps, -1);
				initialApproachFix = wps[-1]; # final waypoint of STAR
			}
		}
		
		if (me.flightplan.approach != nil) {
			var wps = nil;
			var approachIdent = me.flightplan.approach.id;
			
			if (me.flightplan.approach_trans != nil) {
				# if an approach transition was specified, let's use it explicitly
				wps = me.flightplan.approach.route(me.flightplan.destination_runway, me.flightplan.approach_trans);
				if (wps == nil) {
					#logprint(LOG_WARN, "couldn't route approach " ~ approachIdent ~ " based on specified transition:" ~ me.flightplan.approach_trans);
				}
			} else if (initialApproachFix != nil) {
				# no explicit approach transition, let's use the IAF to guess one
				wps = me.flightplan.approach.route(me.flightplan.destination_runway, initialApproachFix);
				if (wps == nil) {
					#logprint(LOG_INFO, "couldn't route approach " ~ approachIdent ~ " based on IAF:" ~ initialApproachFix.wp_name);
				}
			}
			
			# depending on the order the user selects the approach or STAR, we might get into
			# a mess here. If we failed to route so far, just try a direct to the approach
			if (wps == nil) {
				# route direct
				 wps = me.flightplan.approach.route(me.flightplan.destination_runway);
			}
			
			if (wps == nil) {
				#logprint(LOG_WARN, 'routing via approach ' ~ approachIdent ~ ' failed entirely.');
			} else {
				me.flightplan.insertWaypoints(wps, -1);
			}
		} else {
			# no approach, just use the runway waypoint
			var wp = createWPFrom(me.flightplan.destination_runway);
			wp.wp_role = 'approach';
			me.flightplan.appendWP(wp);
		}
	},
	cleared: func
	{
		#logprint(LOG_INFO, "saw active flightplan cleared, deactivating");
		# see http://https://code.google.com/p/flightgear-bugs/issues/detail?id=885
		fgcommand("activate-flightplan", props.Node.new({"activate": 0}));
	},
	endOfFlightPlan: func
	{ # Disabled, we do not want to deactivate when reaching the "end"
		#logprint(LOG_INFO, "end of flight-plan, deactivating");
		#fgcommand("activate-flightplan", props.Node.new({"activate": 0}));
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
		setprop(GPSPath ~ '/config/enable-fly-by', 0);
		
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
	{ # We sequence ourselves
		return;
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
