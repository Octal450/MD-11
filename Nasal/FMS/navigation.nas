# McDonnell Douglas MD-11 FMS
# Copyright (c) 2026 Josh Davidson (Octal450)

var Gps = {
	bearingTrueDeg: props.globals.getNode("/instrumentation/gps/wp/wp[1]/bearing-true-deg"),
	courseErrorNm: props.globals.getNode("/instrumentation/gps/wp/wp[1]/course-error-nm"),
	legTrueCourseDeg: props.globals.getNode("/instrumentation/gps/wp/leg-true-course-deg"),
};

var NavController = {
	Advance: {
		courseNext: 0,
		courseTo: 0,
		distTo: 0,
		deltaAngle: 0,
		deltaAngleRad: 0,
		distCoeff: 0,
		maxBank: 0,
		maxBankLimit: 0,
		R: 0,
		radius: 0,
		turnDist: 0,
	},
	captureTimer: {
		active: 0,
		time: -5,
	},
	canArm: 0,
	canCapture: 0,
	elapsedSec: 0,
	Gps: {
		bearingTrueDeg: 0,
		courseErrorDeg: 0,
		courseErrorGain: 0,
		courseErrorNm: 0,
		deltaLegAngle: 0,
		deltaWpAngle: 0,
		gainAirspeed: 0,
		legTrueCourseDeg: 0,
	},
	latMode: 0,
	lnavArm: 0,
	onInterceptHdg: 0,
	init: func() {
		me.canArm = 0;
		me.canCapture = 0;
		me.onInterceptHdg = 0;
	},
	loop: func() {
		# Waypoint advance/sequencing
		if (FPController.ready and !Value.wow0) {
			if (FPController.size[0] > 2) {
				if (FPController.wpTo.ghost.fly_type != "flyBy") { # Don't other to calculate it
					me.Advance.turnDist = 0.2; # Under 0.2nm guidance becomes unreliable
				} else {
					Value.groundspeedMps = pts.Velocities.groundspeedKt.getValue() * 0.5144444444444;
					me.Advance.maxBankLimit = afs.Internal.bankLimit.getValue();
					
					me.Advance.courseTo = FPController.wpTo.ghost.leg_bearing;
					me.Advance.courseNext = FPController.wpNext.ghost.leg_bearing;
					me.Advance.deltaAngle = math.abs(geo.normdeg180(me.Advance.courseTo - me.Advance.courseNext));
					me.Advance.distTo = courseAndDistance(FPController.wpTo.geoCoord)[1];
					
					me.Advance.maxBank = me.Advance.deltaAngle * 1.5;
					if (me.Advance.maxBank > me.Advance.maxBankLimit) {
						me.Advance.maxBank = me.Advance.maxBankLimit;
					}
					
					me.Advance.radius = (Value.groundspeedMps * Value.groundspeedMps) / (9.81 * math.tan(me.Advance.maxBank / 57.2957795131));
					me.Advance.deltaAngleRad = (180 - me.Advance.deltaAngle) / 114.5915590262;
					me.Advance.R = me.Advance.radius / math.sin(me.Advance.deltaAngleRad);
					
					me.Advance.distCoeff = me.Advance.deltaAngle * -0.011111 + 2;
					if (me.Advance.distCoeff < 1) {
						me.Advance.distCoeff = 1;
					}
					
					me.Advance.turnDist = math.cos(me.Advance.deltaAngleRad) * me.Advance.R * me.Advance.distCoeff / 1852;
					
					if (me.Advance.turnDist < 0.1) { # Under 0.1nm guidance becomes unreliable
						me.Advance.turnDist = 0.1;
					}
				}
				
				afs.Internal.lnavAdvanceNm.setValue(me.Advance.turnDist); # Just keeping it synced
				
				if (me.Advance.distTo <= me.Advance.turnDist) {
					if (FPController.wpNext.ghost.id == "DISCONTINUITY") { # Add vectors/manual???
						if (afs.Output.lat.getValue() == 1) {
							afs.Input.lat.setValue(3); # Exit to heading hold
							Fma.startBlink(1);
						}
					} else {
						FPController.advanceWp(0);
					}
				}
			} else if (FPController.size[0] == 2) { # End of route handling
				me.Advance.distTo = courseAndDistance(FPController.wpTo.geoCoord)[1];
				if (me.Advance.distTo < 0.1) {
					if (afs.Output.lat.getValue() == 1) {
						afs.Input.lat.setValue(3); # Exit to heading hold
						Fma.startBlink(1);
					}
				}
			}
		}
		
		me.elapsedSec = pts.Sim.Time.elapsedSec.getValue();
		me.latMode = afs.Output.lat.getValue();
		me.lnavArm = afs.Output.lnavArm.getBoolValue();
		
		# Get info from GPS
		me.Gps.bearingTrueDeg = Gps.bearingTrueDeg.getValue();
		me.Gps.courseErrorNm = Gps.courseErrorNm.getValue();
		me.Gps.legTrueCourseDeg = Gps.legTrueCourseDeg.getValue();
		
		# Calculate delta angles
		me.Gps.deltaLegAngle = geo.normdeg180(me.Gps.legTrueCourseDeg - pts.Orientation.trackDeg.getValue());
		me.Gps.deltaWpAngle = geo.normdeg180(me.Gps.bearingTrueDeg - pts.Orientation.trackDeg.getValue());
		
		# Calculate error angle command here so we don't have to wait for control loop to update
		me.Gps.gainAirspeed = math.max(140, math.min(360, pts.Velocities.airspeedKt.getValue()));
		me.Gps.courseErrorGain = 40 - (((me.Gps.gainAirspeed - 140) * 20) / 220); # From afs-drivers.xml
		me.Gps.courseErrorDeg = math.clamp(me.Gps.courseErrorNm * me.Gps.courseErrorGain, -45, 45);
		
		# If NAV can be armed
		me.canArm = FPController.ready and FPController.wpTo.exists and FPController.wpTo.ghost.id != "DISCONTINUITY";
		
		# Check if on intercept heading with course
		me.checkOnInterceptHdg();
		
		# If NAV can engage
		me.checkCapture();
	},
	checkCapture: func() {
		if (!me.canArm) {
			me.canCapture = 0;
			me.captureTimer.active = 0;
			me.captureTimer.time = -5;
			return;
		}
		
		if (me.latMode == 1) { # If we get here and we're already in NAV, always return true
			me.canCapture = 1;
			me.captureTimer.active = 0;
			me.captureTimer.time = -5;
			return;
		} else if (!me.lnavArm) {
			me.canCapture = 0;
			me.captureTimer.active = 0;
			me.captureTimer.time = -5;
			return;
		} else {
			if (!me.captureTimer.active) {
				me.captureTimer.active = 1;
				me.captureTimer.time = me.elapsedSec;
			}
			
			# Within 0.2 seconds of arming, inhibit capture to simulate "checking conditions"
			if (me.captureTimer.time + 0.2 >= me.elapsedSec) {
				me.canCapture = 0;
				return;
			}
		}
		
		if (abs(me.Gps.courseErrorNm) > 10) { # To capture we must be within 10nm of course
			me.canCapture = 0;
			return;
		}
		
		me.canCapture = 1; # If we fall through all cases, then capture
	},
	checkOnInterceptHdg: func() { # Not used by capture logic, but may be useful
		if (me.latMode == 1) { # If we're already in NAV, always return true
			me.onInterceptHdg = 1;
			return;
		}
		
		if (me.Gps.courseErrorNm > 0) { # Left of line
			if (me.Gps.deltaWpAngle <= 0) {
				me.onInterceptHdg = 1;
			} else {
				me.onInterceptHdg = 0;
			}
		} else if (me.Gps.courseErrorNm < 0) { # Right of line
			if (me.Gps.deltaWpAngle >= 0) {
				me.onInterceptHdg = 1;
			} else {
				me.onInterceptHdg = 0;
			}
		} else { # Rare case where error is exactly 0, fall through
			me.onInterceptHdg = 1;
		}
	},
};
