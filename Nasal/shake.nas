# McDonnell Douglas MD-11 Shaking
# Copyright (c) 2019 Joshua Davidson (Octal450)

var sf = 0;

var theShakeEffect = func{
	sf = pts.Gear.rollspeedMs[0].getValue() / 94000;
	
	if (pts.Systems.Shake.effect.getBoolValue() and (pts.Gear.wow[0].getBoolValue() or pts.Gear.wow[1].getBoolValue() or pts.Gear.wow[2].getBoolValue())) {
		interpolate("/systems/shake/shaking", sf, 0.03);
		settimer(func {
			interpolate("/systems/shake/shaking", -sf * 2, 0.03); 
		}, 0.06);
		settimer(func {
			interpolate("/systems/shake/shaking", sf, 0.03);
		}, 0.12);
		settimer(theShakeEffect, 0.09);	
	} else {
		pts.Systems.Shake.effect.setBoolValue(0);
		setprop("/systems/shake/shaking", 0); # Why do props.nas when I need interpolate above anyways...
	}	    
}

setlistener("/systems/shake/effect", func {
	if (pts.Systems.Shake.effect.getBoolValue()) {
		theShakeEffect();
	}
}, 0, 0);
