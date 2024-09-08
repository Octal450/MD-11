# McDonnell Douglas MD-11 Shaking
# Copyright (c) 2024 Josh Davidson (Octal450)

var SHAKE = {
	force: 0,
	rollspeedMs: [0, 0, 0],
	wow: [0, 0, 0],
	loop: func() {
		me.rollspeedMs[0] = pts.Gear.rollspeedMs[0].getValue();
		me.rollspeedMs[1] = pts.Gear.rollspeedMs[1].getValue();
		me.rollspeedMs[2] = pts.Gear.rollspeedMs[2].getValue();
		me.wow[0] = pts.Gear.wow[0].getBoolValue();
		me.wow[1] = pts.Gear.wow[1].getBoolValue();
		me.wow[2] = pts.Gear.wow[2].getBoolValue();
		
		if (pts.Velocities.groundspeedKt.getValue() >= 1 and (me.wow[0] or me.wow[1] or me.wow[2])) {
			if (me.wow[0]) {
				me.force = me.rollspeedMs[0] / 94000;
			} else {
				me.force = math.max(me.rollspeedMs[1], me.rollspeedMs[2]) / 188000;
			}
			
			interpolate(pts.Systems.Shake.shaking, 0, 0.03);
			settimer(func() {
				interpolate(pts.Systems.Shake.shaking, me.force * 1.5, 0.03); 
			}, 0.5);
		} else {
			pts.Systems.Shake.shaking.setBoolValue(0);
		}	    
	},
};
