# FailureMgr to IntegratedSystems Failure Bridge
# OPRF uses FailureMgr to control failures with its damage code, but I use IntegratedSystems to manage failures. This thing allows FailureMgr to control IntegratedSystems failures.
# Copyright (c) 2026 Josh Davidson (Octal450)

var numEng = 4; # Number of engines + APU, counting from 1
var ready = 0;
setprop("/systems/acconfig/damage-installed", 1);

# Main function
var setupFailures = func() {
	FailureMgr.remove_all(); # Remove all the default failures, they mess with the simulation
	
	# Add back the default engines, as this will work for engines & APU
	# This code is adapted from compat_failure_modes.nas
	var failId = nil;
	var node = nil;
	var prop = nil;
	for (var i = 0; i < numEng; i = i + 1) {
		failId = "/engines/engine[" ~ i ~ "]";
		FailureMgr.add_failure_mode(
			id: failId,
			description: "Engine " ~ (i + 1),
			actuator: failEngineIs("engine[" ~ i ~ "]")
		);
		
		prop = FailureMgr.proproot ~ failId;
		node = props.globals.initNode(prop ~ "/serviceable", 1, "BOOL");
		
		setlistener(node, compat_failure_modes.compat_listener, 0, 0);
		setlistener(prop ~ "/failure-level", compat_failure_modes.compat_listener, 0, 0);
		
		FailureMgr.set_trigger(failId, compat_failure_modes.MtbfTrigger.new(0));
	}
	
	
	# Now add the IS failure nodes to FailureMgr
	var actuator = nil;
	foreach(var system; props.globals.getNode("/systems/failures").getChildren()) {
		foreach(var component; system.getChildren()) {
			path = component.getPath();
			actuator = failActuator(path);
			FailureMgr.add_failure_mode(path, "System " ~ system.getName() ~ " component " ~ component.getName(), actuator);
		}
	}
	
	ready = 1;
}

# Break on contact
# Adapted from Slavutinsky Victor and Nikolai V. Chr. (crash-and-stress.nas)
var downSpeed = 0;
var eastSpeed = 0;
var horzSpeed = 0;
var northSpeed = 0;
var realSpeed = 0;
var vertSpeed = 0;
setlistener("/fdm/jsbsim/contact/any-wow-out", func {
	if (ready) {
		if (pts.Fdm.JSBSim.Contact.anyWowOut.getBoolValue()) {
			if (pts.Payload.Armament.msg.getBoolValue()) { # Only if damage enabled
				northSpeed = pts.Velocities.speedNorthFps.getValue();
				eastSpeed = pts.Velocities.speedEastFps.getValue();
				horzSpeed = math.sqrt((eastSpeed * eastSpeed) + (northSpeed * northSpeed));
				vertSpeed = pts.Velocities.speedDownFps.getValue();
				realSpeed = FPS2KT * (math.sqrt((horzSpeed * horzSpeed) + (vertSpeed * vertSpeed)));
				
				damage.fail_systems((realSpeed * realSpeed) / 40000); # 200 knots will fail everything, 0 knots will fail nothing
			}
		}
	}
}, 0, 0);

# Set up just after init
var failureInit = setlistener("/sim/signals/fdm-initialized", func {
	settimer(setupFailures, 0.1); # Ensure that the default failures are done
	removelistener(failureInit); # Only do this once
});

# IS Actuator
var failActuator = func(path) {
	if (props.globals.getNode(path) == nil) {
		props.globals.initNode(path, 0, "BOOL");
	}
	
	return {
		parents: [FailureMgr.FailureActuator],
			set_failure_level: func(level) setprop(path, level > 0 ? 1 : 0),
			get_failure_level: func { getprop(path) ? 1 : 0 }
	}
}

# Adapted from failures.nas
var failEngineIs = func(engine) {
	return {
		parents: [FailureMgr.FailureActuator],
		level: 0,
		cutoff: props.globals.getNode("/controls/engines/" ~ engine ~ "/cutoff", 1),
		starter: props.globals.getNode("/controls/engines/" ~ engine ~ "/starter", 1),
		
		get_failure_level: func me.level,
		
		set_failure_level: func(level) {
			if (level) {
				# Switch off the engine and disable writing to it.
				me.cutoff.setValue(1);
				me.cutoff.setAttribute("writable", 0);
				me.starter.setValue(0);
				me.starter.setAttribute("writable", 0);
			}
			else {
				# Enable the properties but don't set them
				me.cutoff.setAttribute("writable", 1);
				me.starter.setAttribute("writable", 1);
			}
			me.level = level;
		}
	}
}
