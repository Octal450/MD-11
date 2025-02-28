# McDonnell Douglas MD-11 Engines
# Copyright (c) 2025 Josh Davidson (Octal450)

var ENGINES = {
	anyEngineOn: props.globals.getNode("/systems/engines/any-engine-on"),
	anyEngineOut: props.globals.getNode("/systems/engines/any-engine-out"),
	egt: [props.globals.getNode("/engines/engine[0]/egt-actual"), props.globals.getNode("/engines/engine[1]/egt-actual"), props.globals.getNode("/engines/engine[2]/egt-actual")],
	epr: [props.globals.getNode("/engines/engine[0]/epr-actual"), props.globals.getNode("/engines/engine[1]/epr-actual"), props.globals.getNode("/engines/engine[2]/epr-actual")],
	ff: [props.globals.getNode("/engines/engine[0]/ff-actual"), props.globals.getNode("/engines/engine[1]/ff-actual"), props.globals.getNode("/engines/engine[2]/ff-actual")],
	multiEngineOut: props.globals.getNode("/systems/engines/multi-engine-out"),
	n1: [props.globals.getNode("/engines/engine[0]/n1-actual"), props.globals.getNode("/engines/engine[1]/n1-actual"), props.globals.getNode("/engines/engine[2]/n1-actual")],
	n2: [props.globals.getNode("/engines/engine[0]/n2-actual"), props.globals.getNode("/engines/engine[1]/n2-actual"), props.globals.getNode("/engines/engine[2]/n2-actual")],
	nacelleTemp: [props.globals.getNode("/engines/engine[0]/nacelle-temp"), props.globals.getNode("/engines/engine[1]/nacelle-temp"), props.globals.getNode("/engines/engine[2]/nacelle-temp")],
	oilPsi: [props.globals.getNode("/engines/engine[0]/oil-psi"), props.globals.getNode("/engines/engine[1]/oil-psi"), props.globals.getNode("/engines/engine[2]/oil-psi")],
	oilQty: [props.globals.getNode("/engines/engine[0]/oil-qty"), props.globals.getNode("/engines/engine[1]/oil-qty"), props.globals.getNode("/engines/engine[2]/oil-qty")],
	oilQtyInput: [props.globals.getNode("/engines/engine[0]/oil-qty-input"), props.globals.getNode("/engines/engine[1]/oil-qty-input"), props.globals.getNode("/engines/engine[2]/oil-qty-input")],
	oilTemp: [props.globals.getNode("/engines/engine[0]/oil-temp"), props.globals.getNode("/engines/engine[1]/oil-temp"), props.globals.getNode("/engines/engine[2]/oil-temp")],
	state: [props.globals.getNode("/engines/engine[0]/state"), props.globals.getNode("/engines/engine[1]/state"), props.globals.getNode("/engines/engine[2]/state")],
	twoEngineOn: props.globals.getNode("/systems/engines/two-engine-on"),
	Controls: {
		cutoff: [props.globals.getNode("/controls/engines/engine[0]/cutoff-switch"), props.globals.getNode("/controls/engines/engine[1]/cutoff-switch"), props.globals.getNode("/controls/engines/engine[2]/cutoff-switch")],
		start: [props.globals.getNode("/controls/engines/engine[0]/start-switch"), props.globals.getNode("/controls/engines/engine[1]/start-switch"), props.globals.getNode("/controls/engines/engine[2]/start-switch")],
		startCmd: [props.globals.getNode("/controls/engines/engine[0]/start-cmd"), props.globals.getNode("/controls/engines/engine[1]/start-cmd"), props.globals.getNode("/controls/engines/engine[2]/start-cmd")],
		throttle: [props.globals.getNode("/controls/engines/engine[0]/throttle"), props.globals.getNode("/controls/engines/engine[1]/throttle"), props.globals.getNode("/controls/engines/engine[2]/throttle")],
		throttleTemp: [0, 0, 0],
	},
	init: func() {
		me.Controls.start[0].setBoolValue(0);
		me.Controls.start[1].setBoolValue(0);
		me.Controls.start[2].setBoolValue(0);
		me.Controls.startCmd[0].setBoolValue(0);
		me.Controls.startCmd[1].setBoolValue(0);
		me.Controls.startCmd[2].setBoolValue(0);
		me.oilQtyInput[0].setValue(math.round((rand() * 8) + 20 , 0.1)); # Random between 20 and 28
		me.oilQtyInput[1].setValue(math.round((rand() * 8) + 20 , 0.1)); # Random between 20 and 28
		me.oilQtyInput[2].setValue(math.round((rand() * 8) + 20 , 0.1)); # Random between 20 and 28
	},
};

# Base off Engine 2
var doRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and FADEC.throttleCompareMax.getValue() <= 0.05) {
		ENGINES.Controls.throttleTemp[1] = ENGINES.Controls.throttle[1].getValue();
		if (!FADEC.reverseEngage[0].getBoolValue() or !FADEC.reverseEngage[1].getBoolValue() or !FADEC.reverseEngage[2].getBoolValue()) {
			FADEC.reverseEngage[0].setBoolValue(1);
			FADEC.reverseEngage[1].setBoolValue(1);
			FADEC.reverseEngage[2].setBoolValue(1);
			ENGINES.Controls.throttle[0].setValue(0);
			ENGINES.Controls.throttle[1].setValue(0);
			ENGINES.Controls.throttle[2].setValue(0);
		} else if (ENGINES.Controls.throttleTemp[1] < 0.4) {
			ENGINES.Controls.throttle[0].setValue(0.4);
			ENGINES.Controls.throttle[1].setValue(0.4);
			ENGINES.Controls.throttle[2].setValue(0.4);
		} else if (ENGINES.Controls.throttleTemp[1] < 0.7) {
			ENGINES.Controls.throttle[0].setValue(0.7);
			ENGINES.Controls.throttle[1].setValue(0.7);
			ENGINES.Controls.throttle[2].setValue(0.7);
		} else if (ENGINES.Controls.throttleTemp[1] < 1) {
			ENGINES.Controls.throttle[0].setValue(1);
			ENGINES.Controls.throttle[1].setValue(1);
			ENGINES.Controls.throttle[2].setValue(1);
		}
	} else {
		ENGINES.Controls.throttle[0].setValue(0);
		ENGINES.Controls.throttle[1].setValue(0);
		ENGINES.Controls.throttle[2].setValue(0);
		FADEC.reverseEngage[0].setBoolValue(0);
		FADEC.reverseEngage[1].setBoolValue(0);
		FADEC.reverseEngage[2].setBoolValue(0);
	}
}

var unRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and FADEC.throttleCompareMax.getValue() <= 0.05) {
		if (FADEC.reverseEngage[0].getBoolValue() or FADEC.reverseEngage[1].getBoolValue() or FADEC.reverseEngage[2].getBoolValue()) {
			ENGINES.Controls.throttleTemp[1] = ENGINES.Controls.throttle[1].getValue();
			if (ENGINES.Controls.throttleTemp[1] > 0.7) {
				ENGINES.Controls.throttle[0].setValue(0.7);
				ENGINES.Controls.throttle[1].setValue(0.7);
				ENGINES.Controls.throttle[2].setValue(0.7);
			} else if (ENGINES.Controls.throttleTemp[1] > 0.4) {
				ENGINES.Controls.throttle[0].setValue(0.4);
				ENGINES.Controls.throttle[1].setValue(0.4);
				ENGINES.Controls.throttle[2].setValue(0.4);
			} else if (ENGINES.Controls.throttleTemp[1] > 0.05) {
				ENGINES.Controls.throttle[0].setValue(0);
				ENGINES.Controls.throttle[1].setValue(0);
				ENGINES.Controls.throttle[2].setValue(0);
			} else {
				ENGINES.Controls.throttle[0].setValue(0);
				ENGINES.Controls.throttle[1].setValue(0);
				ENGINES.Controls.throttle[2].setValue(0);
				FADEC.reverseEngage[0].setBoolValue(0);
				FADEC.reverseEngage[1].setBoolValue(0);
				FADEC.reverseEngage[2].setBoolValue(0);
			}
		}
	} else {
		ENGINES.Controls.throttle[0].setValue(0);
		ENGINES.Controls.throttle[1].setValue(0);
		ENGINES.Controls.throttle[2].setValue(0);
		FADEC.reverseEngage[0].setBoolValue(0);
		FADEC.reverseEngage[1].setBoolValue(0);
		FADEC.reverseEngage[2].setBoolValue(0);
	}
}

var toggleRevThrust = func() {
	if ((pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue()) and FADEC.throttleCompareMax.getValue() <= 0.05) {
		if (FADEC.reverseEngage[0].getBoolValue() or FADEC.reverseEngage[1].getBoolValue() or FADEC.reverseEngage[2].getBoolValue()) {
			ENGINES.Controls.throttle[0].setValue(0);
			ENGINES.Controls.throttle[1].setValue(0);
			ENGINES.Controls.throttle[2].setValue(0);
			FADEC.reverseEngage[0].setBoolValue(0);
			FADEC.reverseEngage[1].setBoolValue(0);
			FADEC.reverseEngage[2].setBoolValue(0);
		} else {
			FADEC.reverseEngage[0].setBoolValue(1);
			FADEC.reverseEngage[1].setBoolValue(1);
			FADEC.reverseEngage[2].setBoolValue(1);
		}
	} else {
		ENGINES.Controls.throttle[0].setValue(0);
		ENGINES.Controls.throttle[1].setValue(0);
		ENGINES.Controls.throttle[2].setValue(0);
		FADEC.reverseEngage[0].setBoolValue(0);
		FADEC.reverseEngage[1].setBoolValue(0);
		FADEC.reverseEngage[2].setBoolValue(0);
	}
}

var doIdleThrust = func() {
	ENGINES.Controls.throttle[0].setValue(0);
	ENGINES.Controls.throttle[1].setValue(0);
	ENGINES.Controls.throttle[2].setValue(0);
}

var doLimitThrust = func() {
	var active = FADEC.Limit.activeNorm.getValue();
	ENGINES.Controls.throttle[0].setValue(active);
	ENGINES.Controls.throttle[1].setValue(active);
	ENGINES.Controls.throttle[2].setValue(active);
}

var doFullThrust = func() {
	ENGINES.Controls.throttle[0].setValue(1);
	ENGINES.Controls.throttle[1].setValue(1);
	ENGINES.Controls.throttle[2].setValue(1);
}
