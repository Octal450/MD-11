# McDonnell Douglas MD-11 FMS
# Copyright (c) 2025 Josh Davidson (Octal450)

# Properties and Data
var Speeds = {
	athrMax: props.globals.getNode("/systems/fms/speeds/athr-max"),
	athrMaxMach: props.globals.getNode("/systems/fms/speeds/athr-max-mach"),
	athrMin: props.globals.getNode("/systems/fms/speeds/athr-min"),
	athrMinMach: props.globals.getNode("/systems/fms/speeds/athr-min-mach"),
	cleanMin: props.globals.getNode("/systems/fms/speeds/clean-min"),
	econKts: props.globals.getNode("/systems/fms/speeds/econ-kts"),
	econMach: props.globals.getNode("/systems/fms/speeds/econ-mach"),
	flap15Max: props.globals.getNode("/systems/fms/speeds/flap-0-15-max-kts"),
	flap28Max: props.globals.getNode("/systems/fms/speeds/flap-28-max-kts"),
	flap28Min: props.globals.getNode("/systems/fms/speeds/flap-28-min"),
	flap35Max: props.globals.getNode("/systems/fms/speeds/flap-35-max-kts"),
	flap50Max: props.globals.getNode("/systems/fms/speeds/flap-50-max-kts"),
	flapGearMax: props.globals.getNode("/systems/fms/speeds/flap-gear-max"),
	gearExtMax: props.globals.getNode("/systems/fms/speeds/gear-ext-max-kts"),
	gearRetMax: props.globals.getNode("/systems/fms/speeds/gear-ret-max-kts"),
	maxClimb: props.globals.getNode("/systems/fms/speeds/max-climb"),
	maxDescent: props.globals.getNode("/systems/fms/speeds/max-descent"),
	slatMin: props.globals.getNode("/systems/fms/speeds/slat-min"),
	slatMax: props.globals.getNode("/systems/fms/speeds/slat-max-kts"),
	v1: props.globals.getNode("/systems/fms/speeds/v1"),
	v2: props.globals.getNode("/systems/fms/speeds/v2"),
	vapp: props.globals.getNode("/systems/fms/speeds/vapp"),
	vcl: props.globals.getNode("/systems/fms/speeds/vcl"),
	vclTo: props.globals.getNode("/systems/fms/speeds/vcl-to"),
	vfr: props.globals.getNode("/systems/fms/speeds/vfr"),
	vmax: props.globals.getNode("/systems/fms/speeds/vmax"),
	vmin: props.globals.getNode("/systems/fms/speeds/vmin"),
	vminTape: props.globals.getNode("/systems/fms/speeds/vmin-tape"),
	vmoMmo: props.globals.getNode("/systems/fms/speeds/vmo-mmo"),
	vr: props.globals.getNode("/systems/fms/speeds/vr"),
	vref: props.globals.getNode("/systems/fms/speeds/vref"),
	vsr: props.globals.getNode("/systems/fms/speeds/vsr"),
	vsrTo: props.globals.getNode("/systems/fms/speeds/vsr-to"),
	vss: props.globals.getNode("/systems/fms/speeds/vss"),
	vssTape: props.globals.getNode("/systems/fms/speeds/vss-tape"),
};

var FmsSpd = {
	active: 0,
	activeOut: props.globals.getNode("/systems/fms/fms-spd/active"),
	activeOrFmsVspeed: 0,
	alt10kToggle: 0,
	alt11kToggle: 0,
	apprKts: 0,
	decel: 0,
	econKts: 0,
	econKtsCalc: 0,
	econKtsCmd: 0,
	econKtsOut: props.globals.getNode("/systems/fms/fms-spd/econ-kts"),
	econKtsMach: 0,
	econKtsMachOut: props.globals.getNode("/systems/fms/fms-spd/econ-kts-mach"),
	econMach: 0,
	econMachCalc: 0,
	econMachCmd: 0,
	econMachOut: props.globals.getNode("/systems/fms/fms-spd/econ-mach"),
	editClimbKts: 0,
	editClimbMach: 0,
	editDescentKts: 0,
	editDescentMach: 0,
	kts: 0,
	ktsCmd: 0,
	ktsOut: props.globals.getNode("/systems/fms/fms-spd/kts"),
	ktsMach: 0,
	ktsMachOut: props.globals.getNode("/systems/fms/fms-spd/kts-mach"),
	mach: 0,
	machCmd: 0,
	machOut: props.globals.getNode("/systems/fms/fms-spd/mach"),
	machToggleEcon: 0,
	machToggleEditClimb: 0,
	machToggleEditDescent: 0,
	maxClimb: 0,
	maxDescent: 0,
	maxKts: 365,
	maxMach: 0.87,
	minKts: 0,
	minMach: 0,
	pfdDriving: 0,
	pfdShowEconPreSel: 0,
	toDriving: 0,
	toKts: 0,
	toKtsCmd: 0,
	v2Toggle: 0,
	vcl: 0,
	init: func() {
		me.active = 0;
		me.activeOrFmsVspeed = 0;
		me.alt10kToggle = 0;
		me.alt11kToggle = 0;
		me.apprKts = 0;
		me.decel = 0;
		me.econKtsCalc = 0;
		me.econKtsCmd = 0;
		me.econKtsMach = 0;
		me.econMachCalc = 0;
		me.econMachCmd = 0;
		me.kts = 0;
		me.ktsCmd = 0;
		me.ktsMach = 0;
		me.mach = 0;
		me.machCmd = 0;
		me.machToggleEcon = 0;
		me.machToggleEditClimb = 0;
		me.machToggleEditDescent = 0;
		me.pfdDriving = 0;
		me.pfdShowEconPreSel = 0;
		me.toKts = 0;
		me.toKtsCmd = 0;
		me.v2Toggle = 0;
	},
	cancel: func(b = 0) {
		me.active = 0;
		me.toDriving = 0; # Cancels FMS SPD and Takeoff Guidance
		me.loop(); # Update immediately
		afs.Output.showSpd.setBoolValue(1);
		if (b) afs.Fma.startBlink(0);
	},
	cancelAndZero: func(e = 0) {
		if (me.active) {
			me.cancel(1);
		}
		
		if (e) me.zeroEcon();
		
		me.ktsMach = 0;
		me.ktsCmd = 0;
	},
	engage: func() {
		if (me.active) {
			afs.Fma.stopBlink(0);
			afs.Output.showSpd.setBoolValue(0);
			fms.EditFlightData.returnToEcon();
		} else if (me.engageAllowed()) {
			me.active = 1;
			afs.Fma.stopBlink(0);
			afs.Output.showSpd.setBoolValue(0);
			me.loop(); # Update immediately
		}
	},
	engageAllowed: func() {
		# In order to engage correctly during takeoff with manually set Vspeeds, toKts must be checked as the other variables are 0, this is required to prevent incorrect display of the hollow magenta bug on the PFD
		# Sequencing when leaving phase 1 is not a concern as the bug is displayed when FMS SPD is active, meaning that the kts and mach variables will be populated, thus this will not return 0
		if ((pts.Position.gearAglFt.getValue() >= 400 or Internal.phase > 1) and !pts.Gear.wow[0].getBoolValue() and ((Internal.phase <= 1 and me.toKts > 0) or (me.kts > 0 and me.mach > 0))) {
			return 1;
		} else {
			return 0;
		}
	},
	writeOut: func() {
		me.activeOut.setBoolValue(me.active);
		me.econKtsOut.setValue(me.econKtsCalc);
		me.econKtsMachOut.setBoolValue(me.econKtsMach);
		me.econMachOut.setValue(me.econMachCalc);
		me.ktsOut.setValue(me.kts);
		me.ktsMachOut.setBoolValue(me.ktsMach);
		me.machOut.setValue(me.mach);
	},
	zeroEcon: func() {
		me.econKtsMach = 0;
		me.econKtsCmd = 0;
	},
	loop: func() {
		# Disengage if unavailable
		if (me.active) {
			if (!me.engageAllowed()) {
				me.cancel(1);
			}
		}
		
		# Pull Speeds
		me.getSpeeds();
		
		# Takeoff Guidance Logic
		me.takeoffLogic();
		
		# Special Takeoff Guidance Logic
		# Only when FMS SPD is active, or takeoff speed is available and non-overridden V2 is set
		if (me.active or (Internal.phase <= 1 and me.toKts > 0 and flightData.v2State == 1)) {
			me.activeOrFmsVspeed = 1;
		} else {
			me.activeOrFmsVspeed = 0;
		}
		
		# 10K Altitude Latch (Climb/Cruise)
		if (Value.altitude >= 9995) {
			me.alt10kToggle = 1;
		} else if (Value.altitude < 9945) {
			me.alt10kToggle = 0;
		}
		
		# 11K Altitude Latch (Descent)
		if (Value.altitude >= 11045) {
			me.alt11kToggle = 1;
		} else if (Value.altitude < 10995) {
			me.alt11kToggle = 0;
		}
		
		# Main FMS SPD Logic
		# ktsMach determines which is active, the other is handled in Inactive Value Sync
		
		if (Internal.phase >= 4) {
			if (Value.active and Value.wpNum > 0) {
				if (Value.distanceRemainingNm < 15) {
					me.decel = 1;
				}
			} else {
				me.decel = 0;
			}
		} else {
			me.decel = 0;
		}
		
		if (Internal.phase <= 1) { # Preflight/Takeoff
			if (me.active) { # Re-enable driving if overriden
				me.toDriving = 1;
			}
			
			if (me.activeOrFmsVspeed) {
				me.ktsMach = 0;
				me.ktsCmd = me.toKts;
				me.econKtsMach = me.ktsMach;
				me.econKtsCmd = me.ktsCmd;
			} else {
				me.cancelAndZero(1);
			}
		} else if (Value.wow0) { # After takeoff, cancel on NLG WoW
			me.cancelAndZero(1);
		} else if (Internal.phase == 2) { # Climb
			# Compute ECON
			if (me.econKts > 0 and me.econMach > 0 and me.vcl > 0) {
				if (me.alt10kToggle) {
					if (me.convertMach(me.econKts) + 0.0005 >= me.econMach) {
						me.machToggleEcon = 1;
					}
					
					if (me.machToggleEcon) {
						me.econKtsMach = 1;
						me.econMachCmd = me.econMach;
					} else {
						me.econKtsMach = 0;
						me.econKtsCmd = math.max(me.econKts, me.vcl);
					}
				} else {
					me.machToggleEcon = 0;
					me.econKtsMach = 0;
					me.econKtsCmd = math.max(250, me.vcl);
				}
			} else {
				me.zeroEcon();
			}
			
			# Compute FMS SPD
			if (flightData.climbSpeedMode == 2) { # EDIT
				if (me.editClimbKts > 0 and me.editClimbMach > 0) {
					me.checkMachToggleEdit(0, 0);
					
					if (me.machToggleEditClimb) {
						me.ktsMach = 1;
						me.machCmd = me.editClimbMach;
					} else {
						me.ktsMach = 0;
						me.ktsCmd = me.editClimbKts;
					}
				} else {
					me.cancelAndZero();
				}
			} else if (flightData.climbSpeedMode == 1) { # MAX
				if (me.maxClimb > 0 and me.vcl > 0) {
					me.ktsMach = 0;
					me.ktsCmd = math.max(me.maxClimb, me.vcl);
				} else {
					me.cancelAndZero();
				}
			} else { # ECON
				if (me.econKtsCalc > 0) {
					if (me.econKtsMach) {
						me.ktsMach = 1;
						me.machCmd = me.econMachCmd;
					} else {
						me.ktsMach = 0;
						me.ktsCmd = me.econKtsCmd;
					}
				} else {
					me.cancelAndZero();
				}
			}
		} else if (Internal.phase == 3) { # Cruise
			# Compute ECON
			if (me.econMach > 0 and me.vcl > 0) {
				if (me.alt10kToggle) {
					me.econKtsMach = 1;
					me.econMachCmd = me.econMach;
				} else {
					me.econKtsMach = 0;
					me.econKtsCmd = math.max(250, me.vcl);
				}
			} else {
				me.zeroEcon();
			}
			
			# Compute FMS SPD
			if (flightData.cruiseSpeedMode == 2) { # EDIT
				if (fms.flightData.cruiseSpeedEdit > 0 and fms.flightData.cruiseSpeedEdit < 1) {
					me.ktsMach = 1;
					me.machCmd = fms.flightData.cruiseSpeedEdit;
				} else if (fms.flightData.cruiseSpeedEdit > 1) {
					me.ktsMach = 0;
					me.ktsCmd = fms.flightData.cruiseSpeedEdit;
				} else {
					me.cancelAndZero();
				}
			} else { # ECON
				if (me.econKtsCmd > 0) {
					if (me.econKtsMach) {
						me.ktsMach = 1;
						me.machCmd = me.econMachCmd;
					} else {
						me.ktsMach = 0;
						me.ktsCmd = me.econKtsCmd;
					}
				} else {
					me.cancelAndZero();
				}
			}
		} else if (Internal.phase >= 4) { # Descent/Approach/Rollout
			# Compute Approach Decel
			if (me.decel and flightData.vapp > 0) {
				if (Value.flapsPos >= 34) {
					me.apprKts = flightData.vapp;
				} else if (Value.flapsPos >= 27) {
					me.apprKts = math.max(me.minKts, flightData.vapp); # minKts = Vmin + 5
				} else if (Value.slatsPos >= 30) {
					me.apprKts = math.max(me.minKts + 15, flightData.vapp); # Vmin + 20
				} else {
					me.apprKts = math.max(me.minKts + 15, flightData.vapp); # Vmin + 20
				}
			} else {
				me.apprKts = 0;
			}
			
			# Compute ECON
			if (me.apprKts > 0) {
				me.econKtsMach = 0;
				me.econKtsCmd = me.apprKts;
			} else if (me.econKts > 0 and me.econMach > 0 and me.vcl > 0) {
				if (me.alt11kToggle) {
					if (me.convertKts(me.econMach) + 0.5 >= me.econKts) {
						me.machToggleEcon = 0;
					}
					
					if (me.machToggleEcon) {
						me.econKtsMach = 1;
						me.econMachCmd = me.econMach;
					} else {
						me.econKtsMach = 0;
						me.econKtsCmd = me.econKts;
					}
				} else {
					me.machToggleEcon = 0;
					me.econKtsMach = 0;
					me.econKtsCmd = math.max(245, me.vcl);
				}
			} else {
				me.zeroEcon();
			}
			
			# Compute FMS SPD
			if (flightData.descentSpeedMode == 2) { # EDIT
				if (me.editDescentKts > 0 and me.editDescentMach > 0) {
					me.checkMachToggleEdit(2, 0);
					
					if (me.machToggleEditDescent) {
						me.ktsMach = 1;
						me.machCmd = me.editDescentMach;
					} else {
						me.ktsMach = 0;
						me.ktsCmd = me.editDescentKts;
					}
				} else {
					me.cancelAndZero();
				}
			} else if (flightData.descentSpeedMode == 1 and me.apprKts == 0) { # MAX
				if (me.maxDescent > 0) {
					me.ktsMach = 0;
					me.ktsCmd = me.maxDescent;
				} else {
					me.cancelAndZero();
				}
			} else { # ECON
				if (me.econKtsCmd > 0) {
					if (me.econKtsMach) {
						me.ktsMach = 1;
						me.machCmd = me.econMachCmd;
					} else {
						me.ktsMach = 0;
						me.ktsCmd = me.econKtsCmd;
					}
				} else {
					me.cancelAndZero();
				}
			}
		} else { # We should never get here
			me.cancelAndZero(1);
		}
		
		# Inactive Value Sync
		if (me.econKtsMach) {
			if (me.econMachCmd > 0) {
				me.econKtsCmd = me.convertKts(me.econMachCmd);
			} else {
				me.econKtsCmd = 0;
			}
		} else {
			if (me.econKtsCmd > 0) {
				me.econMachCmd = me.convertMach(me.econKtsCmd);
			} else {
				me.econMachCmd = 0;
			}
		}
		
		if (me.ktsMach) {
			if (me.machCmd > 0) {
				me.ktsCmd = me.convertKts(me.machCmd);
			} else {
				me.ktsCmd = 0;
			}
		} else {
			if (me.ktsCmd > 0) {
				me.machCmd = me.convertMach(me.ktsCmd);
			} else {
				me.machCmd = 0;
			}
		}
		
		# ECON Speed Limiting Logic
		if (me.econKtsCmd > 0) {
			if (me.minKts > me.maxKts) { # Max takes priority
				me.econKtsCalc = me.maxKts;
			} else if (me.econKtsCmd > me.maxKts) {
				me.econKtsCalc = me.maxKts;
			} else if (me.econKtsCmd < me.minKts) {
				me.econKtsCalc = me.minKts;
			} else {
				me.econKtsCalc = me.econKtsCmd;
			}
		} else {
			me.econKtsCalc = 0;
		}
		
		if (me.econMachCmd > 0) {
			if (me.minMach > me.maxMach) { # Max takes priority
				me.econMachCalc = me.maxMach;
			} else if (me.econMachCmd > me.maxMach) {
				me.econMachCalc = me.maxMach;
			} else if (me.econMachCmd < me.minMach) {
				me.econMachCalc = me.minMach;
			} else {
				me.econMachCalc = me.econMachCmd;
			}
		} else {
			me.econMachCalc = 0;
		}
		
		# Final Speed Limiting Logic
		if (me.ktsCmd > 0) {
			if (me.minKts > me.maxKts) { # Max takes priority
				me.kts = me.maxKts;
			} else if (me.ktsCmd > me.maxKts) {
				me.kts = me.maxKts;
			} else if (me.ktsCmd < me.minKts) {
				me.kts = me.minKts;
			} else {
				me.kts = me.ktsCmd;
			}
		} else {
			me.kts = 0;
		}
		
		if (me.machCmd > 0) {
			if (me.minMach > me.maxMach) { # Max takes priority
				me.mach = me.maxMach;
			} else if (me.machCmd > me.maxMach) {
				me.mach = me.maxMach;
			} else if (me.machCmd < me.minMach) {
				me.mach = me.minMach;
			} else {
				me.mach = me.machCmd;
			}
		} else {
			me.mach = 0;
		}
		
		# PFD Magenta Bug: Filled shown only when FMS SPD is active, or non-overridden V2 is set and driven, hollow ECON speed when when in EDIT mode
		if (me.active or (me.toDriving and me.toKts > 0 and flightData.v2State == 1)) {
			me.pfdDriving = 1;
			
			if (Internal.phase <= 1) {
				me.pfdShowEconPreSel = 0;
			} else if (Internal.phase == 2 and flightData.climbSpeedMode != 2) {
				me.pfdShowEconPreSel = 0;
			} else if (Internal.phase == 3 and flightData.cruiseSpeedMode != 2) {
				me.pfdShowEconPreSel = 0;
			} else if (Internal.phase == 4 and flightData.descentSpeedMode != 2) {
				me.pfdShowEconPreSel = 0;
			} else {
				if (!me.econKtsMach and me.econKtsCalc != me.kts) {
					me.pfdShowEconPreSel = 1;
				} else if (me.econKtsMach and me.econMachCalc != me.mach) {
					me.pfdShowEconPreSel = 1;
				} else {
					me.pfdShowEconPreSel = 0;
				}
			}
		} else {
			me.pfdDriving = 0;
			me.pfdShowEconPreSel = 0;
		}
		
		# Write to Property Tree
		me.writeOut();
	},
	checkMachToggleEdit: func(type, rst) { # Reset is not allowed when calling from the loop
		if (type == 2) { # Descent
			if (Internal.phase >= 4) {
				if (me.convertKts(me.editDescentMach) + 0.5 >= me.editDescentKts) {
					me.machToggleEditDescent = 0;
				} else if (rst) {
					me.machToggleEditDescent = 1;
				}
			} else { # This is required to ensure it does not flip to 0 early
				me.machToggleEditDescent = 1;
			}
		} else { # Climb
			if (me.convertMach(me.editClimbKts) + 0.0005 >= me.editClimbMach) {
				me.machToggleEditClimb = 1;
			} else if (rst) {
				me.machToggleEditClimb = 0;
			}
		}
	},
	convertKts: func(input) {
		return math.max(math.round(input * (Value.asiKts / Value.asiMach)), 1); # 0 is disallowed
	},
	convertMach: func(input) {
		return math.max(math.round(input * (Value.asiMach / Value.asiKts), 0.001), 0.001); # 0 is disallowed
	},
	getSpeeds: func() {
		me.econKts = math.round(Speeds.econKts.getValue());
		me.econMach = math.round(Speeds.econMach.getValue(), 0.001);
		me.maxClimb = math.round(Speeds.maxClimb.getValue());
		me.maxDescent = math.round(Speeds.maxDescent.getValue());
		me.maxKts = math.max(math.round(Speeds.athrMax.getValue()), 1);
		me.maxMach = math.max(math.round(Speeds.athrMaxMach.getValue(), 0.001), 0.001);
		me.minKts = math.max(math.round(Speeds.athrMin.getValue()), 1);
		me.minMach = math.max(math.round(Speeds.athrMinMach.getValue(), 0.001), 0.001);
		me.vcl = math.round(Speeds.vcl.getValue());
		
		if (fms.flightData.climbSpeedEditKts == 1) me.editClimbKts = me.maxKts;
		else me.editClimbKts = fms.flightData.climbSpeedEditKts;
		
		if (fms.flightData.climbSpeedEditMach == 1) me.editClimbMach = me.maxMach;
		else me.editClimbMach = fms.flightData.climbSpeedEditMach;
		
		if (fms.flightData.descentSpeedEditKts == 1) me.editDescentKts = me.maxKts;
		else me.editDescentKts = fms.flightData.descentSpeedEditKts;
		
		if (fms.flightData.descentSpeedEditMach == 1) me.editDescentMach = me.maxMach;
		else me.editDescentMach = fms.flightData.descentSpeedEditMach;
	},
	takeoffLogic: func() {
		if (Internal.phase >= 2) {
			me.toDriving = 0;
			me.toKtsCmd = 0;
			me.v2Toggle = 0;
			return;
		}
		
		if (fms.flightData.v2 > 0) {
			if (!Value.wow) {
				if (systems.ENGINES.anyEngineOut.getBoolValue()) {
					if (!me.v2Toggle) { # Only set the speed once
						me.v2Toggle = 1;
						me.toKtsCmd = math.clamp(math.round(Value.asiKts), flightData.v2, flightData.v2 + 10);
					}
				} else if (Value.gearAglFt < 400) { # Once hitting 400 feet, this is overridable
					me.toDriving = 1;
					me.toKtsCmd = fms.flightData.v2 + 10;
				}
			} else {
				me.toDriving = 1;
				me.toKtsCmd = math.clamp(math.max(flightData.v2, math.round(Value.asiKts)), flightData.v2, flightData.v2 + 10);
				me.v2Toggle = 0;
			}
		} else {
			me.toDriving = 0;
			me.toKtsCmd = 0;
			me.v2Toggle = 0;
		}
		
		# Limiting logic
		if (me.toKtsCmd > 0) {
			if (me.minKts > me.maxKts) { # Max takes priority
				me.toKts = me.maxKts;
			} else if (me.toKtsCmd > me.maxKts) {
				me.toKts = me.maxKts;
			} else if (me.toKtsCmd < me.minKts) {
				me.toKts = me.minKts;
			} else {
				me.toKts = me.toKtsCmd;
			}
		} else {
			me.toKts = 0;
		}
	},
	updateEditSpeeds: func(type) {
		me.getSpeeds();
		me.checkMachToggleEdit(type, 1); # Allow reset to 0
	},
};

setlistener("/systems/fms/internal/ias-v2-clamp-out", func() { # This is used only to make the loop update when the speed changes between V2 and V2 + 10
	if (FmsSpd.toDriving) {
		FmsSpd.takeoffLogic();
		afs.ITAF.takeoffSpdLogic();
	}
}, 0, 0);
