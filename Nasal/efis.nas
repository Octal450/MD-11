# MD-11 EFIS Controller
# Copyright (c) 2020 Josh Davidson (Octal450)

var rng = 0;
var lh = 0;
var rh = 0;

setlistener("/sim/signals/fdm-initialized", func {
	setprop("/instrumentation/efis[0]/mfd/display-mode", "MAP");
	setprop("/instrumentation/efis[0]/inputs/nd-centered", 0);
	setprop("/instrumentation/efis[0]/inputs/range-nm", 10);
	setprop("/instrumentation/efis[0]/inputs/tfc", 0);
	setprop("/instrumentation/efis[0]/inputs/data", 0);
	setprop("/instrumentation/efis[0]/inputs/wpt", 0);
	setprop("/instrumentation/efis[0]/inputs/sta", 0);
	setprop("/instrumentation/efis[0]/inputs/arpt", 0);
	setprop("/instrumentation/efis[0]/inputs/lh-vor-adf", 0);
	setprop("/instrumentation/efis[0]/inputs/rh-vor-adf", 0);
	setprop("/instrumentation/efis[1]/mfd/display-mode", "MAP");
	setprop("/instrumentation/efis[1]/inputs/nd-centered", 0);
	setprop("/instrumentation/efis[1]/inputs/range-nm", 10);
	setprop("/instrumentation/efis[1]/inputs/tfc", 0);
	setprop("/instrumentation/efis[1]/inputs/data", 0);
	setprop("/instrumentation/efis[1]/inputs/wpt", 0);
	setprop("/instrumentation/efis[1]/inputs/sta", 0);
	setprop("/instrumentation/efis[1]/inputs/arpt", 0);
	setprop("/instrumentation/efis[1]/inputs/lh-vor-adf", 0);
	setprop("/instrumentation/efis[1]/inputs/rh-vor-adf", 0);
});

var setCptND = func(m) {
	pts.Instrumentation.Efis.Mfd.displayMode[0].setValue(m);
	if (m == "MAP") {
		pts.Instrumentation.Efis.Inputs.ndCentered[0].setBoolValue(0);
	} else {
		pts.Instrumentation.Efis.Inputs.ndCentered[0].setBoolValue(1);
	}
}

var setFoND = func(m) {
	pts.Instrumentation.Efis.Mfd.displayMode[1].setValue(m);
	if (m == "MAP") {
		pts.Instrumentation.Efis.Inputs.ndCentered[1].setBoolValue(0);
	} else {
		pts.Instrumentation.Efis.Inputs.ndCentered[1].setBoolValue(1);
	}
}

var setNDRange = func(n, d) {
	rng = pts.Instrumentation.Efis.Inputs.rangeNm[n].getValue();
	if (d == 1) {
		rng = rng * 2;
		if (rng > 640) {
			rng = 640;
		}
	} else if (d == -1){
		rng = rng / 2;
		if (rng < 5) {
			rng = 5;
		}
	}
	pts.Instrumentation.Efis.Inputs.rangeNm[n].setValue(rng);
}

var setCptNDRadio = func(b) {
	lh = pts.Instrumentation.Efis.Inputs.lhVorAdf[0].getValue();
	rh = pts.Instrumentation.Efis.Inputs.rhVorAdf[0].getValue();
	
	if (b == "VOR1") {
		if (lh == 1) {
			pts.Instrumentation.Efis.Inputs.lhVorAdf[0].setValue(0);
		} else {
			pts.Instrumentation.Efis.Inputs.lhVorAdf[0].setValue(1);
		}
	} else if (b == "ADF1") {
		if (lh == -1) {
			pts.Instrumentation.Efis.Inputs.lhVorAdf[0].setValue(0);
		} else {
			pts.Instrumentation.Efis.Inputs.lhVorAdf[0].setValue(-1);
		}
	} else if (b == "VOR2") {
		if (rh == 1) {
			pts.Instrumentation.Efis.Inputs.rhVorAdf[0].setValue(0);
		} else {
			pts.Instrumentation.Efis.Inputs.rhVorAdf[0].setValue(1);
		}
	} else if (b == "ADF2") {
		if (rh == -1) {
			pts.Instrumentation.Efis.Inputs.rhVorAdf[0].setValue(0);
		} else {
			pts.Instrumentation.Efis.Inputs.rhVorAdf[0].setValue(-1);
		}
	}
}

var setFoNDRadio = func(b) {
	lh = pts.Instrumentation.Efis.Inputs.lhVorAdf[1].getValue();
	rh = pts.Instrumentation.Efis.Inputs.rhVorAdf[1].getValue();
	
	if (b == "VOR1") {
		if (lh == 1) {
			pts.Instrumentation.Efis.Inputs.lhVorAdf[1].setValue(0);
		} else {
			pts.Instrumentation.Efis.Inputs.lhVorAdf[1].setValue(1);
		}
	} else if (b == "ADF1") {
		if (lh == -1) {
			pts.Instrumentation.Efis.Inputs.lhVorAdf[1].setValue(0);
		} else {
			pts.Instrumentation.Efis.Inputs.lhVorAdf[1].setValue(-1);
		}
	} else if (b == "VOR2") {
		if (rh == 1) {
			pts.Instrumentation.Efis.Inputs.rhVorAdf[1].setValue(0);
		} else {
			pts.Instrumentation.Efis.Inputs.rhVorAdf[1].setValue(1);
		}
	} else if (b == "ADF2") {
		if (rh == -1) {
			pts.Instrumentation.Efis.Inputs.rhVorAdf[1].setValue(0);
		} else {
			pts.Instrumentation.Efis.Inputs.rhVorAdf[1].setValue(-1);
		}
	}
}
