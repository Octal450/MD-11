# McDonnell Douglas MD-11 Misc Instruments
# Copyright (c) 2024 Josh Davidson (Octal450)

var Baro = {
	calc: 0,
	adjust: func(d) {
		if (!pts.Instrumentation.Altimeter.std.getBoolValue()) {
			if (pts.Instrumentation.Altimeter.inhg.getBoolValue()) {
				me.calc = pts.Instrumentation.Altimeter.settingInhg.getValue() + (0.01 * d);
				
				if (me.calc < 22) {
					pts.Instrumentation.Altimeter.settingInhg.setValue(22);
				} else if (me.calc > 32) {
					pts.Instrumentation.Altimeter.settingInhg.setValue(32);
				} else {
					pts.Instrumentation.Altimeter.settingInhg.setValue(me.calc);
				}
			} else {
				me.calc = pts.Instrumentation.Altimeter.settingHpa.getValue() + d;
				
				if (me.calc < 745) {
					pts.Instrumentation.Altimeter.settingHpa.setValue(745);
				} else if (me.calc > 1100) {
					pts.Instrumentation.Altimeter.settingHpa.setValue(1100);
				} else {
					pts.Instrumentation.Altimeter.settingHpa.setValue(me.calc);
				}
			}
		} else {
			me.unStd();
		}
	},
	std: func() {
		if (!pts.Instrumentation.Altimeter.std.getBoolValue()) {
			pts.Instrumentation.Altimeter.oldQnh.setValue(pts.Instrumentation.Altimeter.settingInhg.getValue());
			pts.Instrumentation.Altimeter.settingInhg.setValue(29.92);
			pts.Instrumentation.Altimeter.std.setBoolValue(1);
		}
	},
	unStd: func() {
		if (pts.Instrumentation.Altimeter.std.getBoolValue()) {
			pts.Instrumentation.Altimeter.settingInhg.setValue(pts.Instrumentation.Altimeter.oldQnh.getValue());
			pts.Instrumentation.Altimeter.std.setBoolValue(0);
		}
	},
};

var Mins = {
	reset: func() {
		if (canvas_pfd.Value.Ra.time != -10) {
			canvas_pfd.Value.Ra.time = -10 # Stop blinking
		} else {
			pts.Controls.Switches.minimums.setValue(200);
		}
	},
};
