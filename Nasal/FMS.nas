# MD-11 FMS
# Copyright (c) 2019 Joshua Davidson (Octal450)

setprop("/FMS/internal/v2", 163);

var CORE = {
	resetFMS: func() {
		setprop("/FMS/internal/v2", 163);
		afs.ITAF.init(1);
	},
	stateCheck: func() {
		if (getprop("/engines/engine[0]/state") == 0 and getprop("/engines/engine[1]/state") == 0 and getprop("/engines/engine[2]/state") == 0) {
			me.resetFMS();
		}
	},
};

setlistener("/engines/engine[0]/state", func {
	CORE.stateCheck();
}, 0, 0);

setlistener("/engines/engine[1]/state", func {
	CORE.stateCheck();
}, 0, 0);

setlistener("/engines/engine[2]/state", func {
	CORE.stateCheck();
}, 0, 0);
