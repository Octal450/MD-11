# McDonnell Douglas MD-11 Brakes
# Copyright (c) 2025 Josh Davidson (Octal450)

var BRAKES = {
	Abs: {
		armed: props.globals.getNode("/systems/abs/armed"),
		disarm: props.globals.getNode("/systems/abs/disarm"),
		mode: props.globals.getNode("/systems/abs/mode"), # -2: RTO MAX, -1: RTO MIN, 0: OFF, 1: MIN, 2: MED, 3: MAX
	},
	Controls: {
		abs: props.globals.getNode("/controls/abs/knob"), # -1: RTO, 0: OFF, 1: MIN, 2: MED, 3: MAX
	},
	Failures: {
		abs: props.globals.getNode("/systems/failures/brakes/abs"),
	},
	Lights: {
		absDisarm: props.globals.initNode("/systems/abs/lights/disarm", 0, "BOOL"),
	},
	init: func() {
		me.Controls.abs.setValue(0);
		me.absSetUpdate(0);
	},
	absSetOff: func(t) {
		me.Abs.armed.setBoolValue(0);
		if (t == 1) {
			me.Lights.absDisarm.setBoolValue(1);
		} else {
			me.Lights.absDisarm.setBoolValue(0);
		}
		me.Abs.mode.setValue(0);
	},
	absSetUpdate: func(n) {
		pts.Position.wowTemp = pts.Position.wow.getBoolValue();
		if (n == -1) {
			if (pts.Position.wowTemp and !me.Abs.disarm.getBoolValue()) { # Disarm is cleared at OFF position
				me.Abs.mode.setValue(-1);
				me.Abs.armed.setBoolValue(1);
			} else {
				me.absSetOff(1);
			}
		} else if (n == 0) {
			me.absSetOff(0);
		} else if (n == 1) {
			if (!pts.Position.wowTemp and !me.Abs.disarm.getBoolValue()) { # Disarm is cleared at OFF position
				me.Abs.mode.setValue(1);
				me.Abs.armed.setBoolValue(1);
			} else {
				me.absSetOff(1);
			}
		} else if (n == 2) {
			if (!pts.Position.wowTemp and !me.Abs.disarm.getBoolValue()) { # Disarm is cleared at OFF position
				me.Abs.mode.setValue(2);
				me.Abs.armed.setBoolValue(1);
			} else {
				me.absSetOff(1);
			}
		} else if (n == 3) {
			if (!pts.Position.wowTemp and !me.Abs.disarm.getBoolValue()) { # Disarm is cleared at OFF position
				me.Abs.mode.setValue(3);
				me.Abs.armed.setBoolValue(1);
			} else {
				me.absSetOff(1);
			}
		}
	},
};

setlistener("/systems/abs/knob-input", func() {
	BRAKES.absSetUpdate(BRAKES.Controls.abs.getValue());
}, 0, 0);

setlistener("/systems/abs/disarm", func() {
	BRAKES.absSetOff(1);
}, 0, 0);
