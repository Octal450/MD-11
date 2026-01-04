# McDonnell Douglas MD-11 Gear
# Copyright (c) 2026 Josh Davidson (Octal450)

var GEAR = {
	allNorm: props.globals.getNode("/systems/gear/all-norm"),
	cmd: props.globals.getNode("/systems/gear/cmd"),
	status: [props.globals.getNode("/systems/gear/unit[0]/status"), props.globals.getNode("/systems/gear/unit[1]/status"), props.globals.getNode("/systems/gear/unit[2]/status"), props.globals.getNode("/systems/gear/unit[3]/status")],
	TirePressurePsi: {
		centerL: props.globals.getNode("/systems/gear/unit[3]/tire-l-psi"),
		centerLInput: props.globals.getNode("/systems/gear/unit[3]/tire-l-psi-input"),
		centerR: props.globals.getNode("/systems/gear/unit[3]/tire-r-psi"),
		centerRInput: props.globals.getNode("/systems/gear/unit[3]/tire-r-psi-input"),
		leftLAft: props.globals.getNode("/systems/gear/unit[1]/tire-l-aft-psi"),
		leftLAftInput: props.globals.getNode("/systems/gear/unit[1]/tire-l-aft-psi-input"),
		leftRAft: props.globals.getNode("/systems/gear/unit[1]/tire-r-aft-psi"),
		leftRAftInput: props.globals.getNode("/systems/gear/unit[1]/tire-r-aft-psi-input"),
		leftLFwd: props.globals.getNode("/systems/gear/unit[1]/tire-l-fwd-psi"),
		leftLFwdInput: props.globals.getNode("/systems/gear/unit[1]/tire-l-fwd-psi-input"),
		leftRFwd: props.globals.getNode("/systems/gear/unit[1]/tire-r-fwd-psi"),
		leftRFwdInput: props.globals.getNode("/systems/gear/unit[1]/tire-r-fwd-psi-input"),
		noseL: props.globals.getNode("/systems/gear/unit[0]/tire-l-psi"),
		noseLInput: props.globals.getNode("/systems/gear/unit[0]/tire-l-psi-input"),
		noseR: props.globals.getNode("/systems/gear/unit[0]/tire-r-psi"),
		noseRInput: props.globals.getNode("/systems/gear/unit[0]/tire-r-psi-input"),
		rightLAft: props.globals.getNode("/systems/gear/unit[2]/tire-l-aft-psi"),
		rightLAftInput: props.globals.getNode("/systems/gear/unit[2]/tire-l-aft-psi-input"),
		rightRAft: props.globals.getNode("/systems/gear/unit[2]/tire-r-aft-psi"),
		rightRAftInput: props.globals.getNode("/systems/gear/unit[2]/tire-r-aft-psi-input"),
		rightLFwd: props.globals.getNode("/systems/gear/unit[2]/tire-l-fwd-psi"),
		rightLFwdInput: props.globals.getNode("/systems/gear/unit[2]/tire-l-fwd-psi-input"),
		rightRFwd: props.globals.getNode("/systems/gear/unit[2]/tire-r-fwd-psi"),
		rightRFwdInput: props.globals.getNode("/systems/gear/unit[2]/tire-r-fwd-psi-input"),
	},
	Controls: {
		brakeLeft: props.globals.getNode("/controls/gear/brake-left"),
		brakeParking: props.globals.getNode("/controls/gear/brake-parking"),
		brakeRight: props.globals.getNode("/controls/gear/brake-right"),
		centerGearUp: props.globals.getNode("/controls/gear/center-gear-up"),
		lever: props.globals.getNode("/controls/gear/lever"),
	},
	Failures: {
		centerActuator: props.globals.getNode("/systems/failures/gear/center-actuator"),
		leftActuator: props.globals.getNode("/systems/failures/gear/left-actuator"),
		noseActuator: props.globals.getNode("/systems/failures/gear/nose-actuator"),
		rightActuator: props.globals.getNode("/systems/failures/gear/right-actuator"),
	},
	init: func() {
		me.resetFailures();
		me.Controls.brakeParking.setBoolValue(0);
		me.Controls.centerGearUp.setBoolValue(0);
		me.TirePressurePsi.centerLInput.setValue(math.round((rand() * 6) + 167 , 0.1)); # Random between 167 and 163
		me.TirePressurePsi.centerRInput.setValue(math.round((rand() * 6) + 167 , 0.1)); # Random between 167 and 163
		me.TirePressurePsi.leftLAftInput.setValue(math.round((rand() * 6) + 207 , 0.1)); # Random between 207 and 213
		me.TirePressurePsi.leftLFwdInput.setValue(math.round((rand() * 6) + 207 , 0.1)); # Random between 207 and 213
		me.TirePressurePsi.leftRAftInput.setValue(math.round((rand() * 6) + 207 , 0.1)); # Random between 207 and 213
		me.TirePressurePsi.leftRFwdInput.setValue(math.round((rand() * 6) + 207 , 0.1)); # Random between 207 and 213
		me.TirePressurePsi.noseLInput.setValue(math.round((rand() * 6) + 167 , 0.1)); # Random between 167 and 163
		me.TirePressurePsi.noseRInput.setValue(math.round((rand() * 6) + 167 , 0.1)); # Random between 167 and 163
		me.TirePressurePsi.rightLAftInput.setValue(math.round((rand() * 6) + 207 , 0.1)); # Random between 207 and 213
		me.TirePressurePsi.rightLFwdInput.setValue(math.round((rand() * 6) + 207 , 0.1)); # Random between 207 and 213
		me.TirePressurePsi.rightRAftInput.setValue(math.round((rand() * 6) + 207 , 0.1)); # Random between 207 and 213
		me.TirePressurePsi.rightRFwdInput.setValue(math.round((rand() * 6) + 207 , 0.1)); # Random between 207 and 213
	},
	resetFailures: func() {
		me.Failures.centerActuator.setBoolValue(0);
		me.Failures.leftActuator.setBoolValue(0);
		me.Failures.noseActuator.setBoolValue(0);
		me.Failures.rightActuator.setBoolValue(0);
	},
};
