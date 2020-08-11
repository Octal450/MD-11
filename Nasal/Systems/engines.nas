# Reference will be deleted
var apu_start_loop = maketimer(0.5, func {
	if (getprop("/engines/engine[3]/n2-actual") < 94.9) {
	# Remember that this STOPS when APU N2 is greater than 94.9%
		apu_on_lt2 = getprop("/controls/apu/on-light");
		if (apu_on_lt2 == 0) {
			setprop("/controls/apu/on-light", 1);
		} else {
			setprop("/controls/apu/on-light", 0);
		}
	} else {
		apu_start_loop.stop();
		setprop("/controls/apu/on-light", 1);
	}
	
	oilqty = getprop("/systems/apu/oilqty");
	setprop("/systems/apu/oilqty", oilqty - 0.001);
});
