# McDonnell Douglas MD-11 APU
# Copyright (c) 2024 Josh Davidson (Octal450)

var APU = {
	autoConnect: 0,
	egt: props.globals.getNode("/engines/engine[3]/egt-actual"),
	ff: props.globals.getNode("/engines/engine[3]/ff-actual"),
	n1: props.globals.getNode("/engines/engine[3]/n1-actual"),
	n2: props.globals.getNode("/engines/engine[3]/n2-actual"),
	oilQty: props.globals.getNode("/engines/engine[3]/oil-qty"),
	oilQtyInput: props.globals.getNode("/engines/engine[3]/oil-qty-input"),
	state: props.globals.getNode("/engines/engine[3]/state"),
	Controls: {
		start: props.globals.getNode("/controls/apu/start"),
	},
	Lights: {
		avail: props.globals.getNode("/systems/apu/lights/avail-flash"), # Flashes Elec Panel AVAIL light
		on: props.globals.initNode("/systems/apu/lights/on", 0, "BOOL"),
		onTemp: 0,
	},
	init: func() {
		me.oilQtyInput.setValue(math.round((rand() * 2) + 5.5 , 0.1)); # Random between 5.5 and 7.5
		me.Controls.start.setBoolValue(0);
		me.Lights.avail.setBoolValue(0);
		me.Lights.on.setBoolValue(0);
		me.autoConnect = 0;
	},
	fastStart: func() {
		me.Controls.start.setBoolValue(1);
		me.Lights.avail.setValue(1);
		me.Lights.on.setValue(1);
		me.autoConnect = 0;
		settimer(func() { # Give the fuel system a moment to provide fuel in the pipe
			pts.Fdm.JSBSim.Propulsion.setRunning.setValue(3);
		}, 1);
	},
	stopRpm: func() {
		settimer(func() { # Required delay
			if (me.n2.getValue() >= 1) {
				pts.Fdm.JSBSim.Propulsion.Engine.n1[3].setValue(0.1);
				pts.Fdm.JSBSim.Propulsion.Engine.n2[3].setValue(0.1);
			}
		}, 0.1);
	},
	onLight: func() {
		me.Lights.onTemp = me.Lights.on.getValue();
		if (!me.Controls.start.getBoolValue()) {
			onLightt.stop();
			me.Lights.avail.setValue(0);
			me.Lights.on.setValue(0);
		} else if (me.Controls.start.getBoolValue() and me.n2.getValue() >= 95) {
			onLightt.stop();
			me.Lights.avail.setValue(1);
			me.Lights.on.setValue(1);
			if (me.autoConnect) {
				if (ELECTRICAL.Epcu.allowApu.getBoolValue()) {
					ELECTRICAL.Controls.apuPwr.setBoolValue(1);
				}
			}
		} else {
			if (me.autoConnect) {
				me.Lights.avail.setValue(!me.Lights.onTemp); 
			} else {
				me.Lights.avail.setValue(0);
			}
			me.Lights.on.setValue(!me.Lights.onTemp);
		}
	},
	startStop: func(t) {
		if (ELECTRICAL.Bus.dcBat.getValue() >= 24) {
			if (!me.Controls.start.getBoolValue() and me.n2.getValue() < 1.8) {
				me.autoConnect = t;
				me.Controls.start.setBoolValue(1);
				onLightt.start();
			} else if (!acconfig.SYSTEM.autoConfigRunning.getBoolValue() and t != 1) { # Do nothing if autoconfig is running, cause it'll break it, or if ELEC panel switch was used
				onLightt.stop();
				me.Controls.start.setBoolValue(0);
				me.Lights.avail.setValue(0);
				me.Lights.on.setValue(0);
				PNEUMATICS.Controls.bleedApu.setBoolValue(0);
				me.autoConnect = 0;
			}
		}
	},
	stop: func() {
		onLightt.stop();
		me.Controls.start.setBoolValue(0);
		me.Lights.avail.setValue(0);
		me.Lights.on.setValue(0);
		PNEUMATICS.Controls.bleedApu.setBoolValue(0);
		me.autoConnect = 0;
	},
};

setlistener("/systems/electrical/epcu/allow-apu-out", func() {
	if (APU.autoConnect) {
		if (ELECTRICAL.Epcu.allowApu.getBoolValue() and APU.state.getValue() == 3) {
			ELECTRICAL.Controls.apuPwr.setBoolValue(1);
		}
	}
}, 0, 0);

var onLightt = maketimer(0.4, APU, APU.onLight);
