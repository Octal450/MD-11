# McDonnell Douglas MD-11 FMS
# Copyright (c) 2026 Josh Davidson (Octal450)

var LnavController = {
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
	canArm: 0,
	canCapture: 0,
	init: func() {
		me.canArm = 0;
		me.canCapture = 0;
	},
	loop: func() {
		if (FPController.ready) {
			if (FPController.size[0] > 2 and !Value.wow0) {
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
					
					if (me.Advance.turnDist < 0.2) { # Under 0.2nm guidance becomes unreliable
						me.Advance.turnDist = 0.2;
					}
				}
				
				afs.Internal.lnavAdvanceNm.setValue(me.Advance.turnDist); # Just keeping it synced
				
				if (me.Advance.distTo <= me.Advance.turnDist) {
					if (FPController.wpNext.ghost.id == "DISCONTINUITY") { # Add vectors/manual???
						if (afs.Output.lat.getValue() == 1) {
							afs.Input.lat.setValue(3); # Exit to heading hold
						}
					} else {
						FPController.advanceWp(0);
					}
				}
			}
		}
		
		me.canArm = FPController.ready and FPController.wpTo.exists and FPController.wpTo.ghost.id != "DISCONTINUITY";
		me.canCapture = me.canArm; # To be done
	},
};
