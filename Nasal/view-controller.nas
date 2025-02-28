# Octal's View Controller
# Copyright (c) 2024 Josh Davidson (Octal450)
# FovZoom based on work by onox

var distance = 0;
var min_dist = 0;
var max_dist = 0;
var canChangeZOffset = 0;
var decStep = -5;
var incStep = 5;
var shakeFlag = 0;
var viewNumberRaw = 0;
var views = [0, 9, 10, 11, 12, 13, 14];

var resetView = func() {
	viewNumberRaw = pts.Sim.CurrentView.viewNumberRaw.getValue();
	if (viewNumberRaw == 0 or (viewNumberRaw >= 100 and viewNumberRaw <= 111)) {
		if (pts.Sim.Rendering.Headshake.enabled.getBoolValue()) {
			shakeFlag = 1;
			pts.Sim.Rendering.Headshake.enabled.setBoolValue(0);
		} else {
			shakeFlag = 0;
		}
		
		pts.Sim.CurrentView.fieldOfView.setValue(props.globals.getNode("/sim/view[" ~ viewNumberRaw ~ "]/config/default-field-of-view-deg").getValue());
		pts.Sim.CurrentView.headingOffsetDeg.setValue(props.globals.getNode("/sim/view[" ~ viewNumberRaw ~ "]/config/heading-offset-deg").getValue());
		pts.Sim.CurrentView.pitchOffsetDeg.setValue(props.globals.getNode("/sim/view[" ~ viewNumberRaw ~ "]/config/pitch-offset-deg").getValue());
		pts.Sim.CurrentView.rollOffsetDeg.setValue(props.globals.getNode("/sim/view[" ~ viewNumberRaw ~ "]/config/roll-offset-deg").getValue());
		pts.Sim.CurrentView.xOffsetM.setValue(props.globals.getNode("/sim/view[" ~ viewNumberRaw ~ "]/config/x-offset-m").getValue());
		pts.Sim.CurrentView.yOffsetM.setValue(props.globals.getNode("/sim/view[" ~ viewNumberRaw ~ "]/config/y-offset-m").getValue());
		pts.Sim.CurrentView.zOffsetM.setValue(props.globals.getNode("/sim/view[" ~ viewNumberRaw ~ "]/config/z-offset-m").getValue());
		
		if (shakeFlag) {
			pts.Sim.Rendering.Headshake.enabled.setBoolValue(1);
		}
	} 
}

var setView = func(n) {
	pts.Sim.CurrentView.viewNumber.setValue(views[n - 1]);
}

var fovZoom = func(d) {
	canChangeZOffset = pts.Sim.CurrentView.name.getValue() == "Helicopter View";
	
	if (pts.Sim.CurrentView.zOffsetM.getValue() <= -50) {
		decStep = -10;
	} else {
		decStep = -5;
	}
	
	if (pts.Sim.CurrentView.zOffsetM.getValue() < -50) { # Not a typo, the conditions are different
		incStep = 10;
	} else {
		incStep = 5;
	}
	
	if (d == -1) {
		if (canChangeZOffset) {
			distance = pts.Sim.CurrentView.zOffsetM.getValue();
			min_dist = pts.Sim.CurrentView.zOffsetMinM.getValue();
			
			distance = math.round(std.min(-min_dist, distance + incStep) / incStep, 0.1) * incStep;
			pts.Sim.CurrentView.zOffsetM.setValue(distance);
			
			gui.popupTip(sprintf("%d meters", abs(distance)));
		} else {
			view.decrease();
		}
	} else if (d == 1) {
		if (canChangeZOffset) {
			distance = pts.Sim.CurrentView.zOffsetM.getValue();
			max_dist = pts.Sim.CurrentView.zOffsetMaxM.getValue();
			
			distance = math.round(std.max(-max_dist, distance + decStep) / decStep, 0.1) * decStep;
			pts.Sim.CurrentView.zOffsetM.setValue(distance);
			
			gui.popupTip(sprintf("%d meters", abs(distance)));
		} else {
			view.increase();
		}
	} else if (d == 0) {
		if (canChangeZOffset) {
			pts.Sim.CurrentView.zOffsetM.setValue(pts.Sim.CurrentView.zOffsetDefault.getValue() * -1);
			gui.popupTip(sprintf("%d meters", pts.Sim.CurrentView.zOffsetDefault.getValue()));
		} else {
			pts.Sim.CurrentView.fieldOfView.setValue(pts.Sim.View.Config.defaultFieldOfViewDeg.getValue());
			gui.popupTip(sprintf("FOV: %.1f", pts.Sim.CurrentView.fieldOfView.getValue()));
		}
	}
}
