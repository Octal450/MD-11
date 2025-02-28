# McDonnell Douglas MD-11 FCS
# Copyright (c) 2025 Josh Davidson (Octal450)

var FCS = {
	deflectedAileronActive: props.globals.getNode("/systems/fcs/deflected-aileron/active"),
	flapsCmd: props.globals.getNode("/systems/fcs/flaps/cmd"),
	flapsInput: props.globals.getNode("/systems/fcs/flaps/input"),
	flapsMaxDeg: props.globals.getNode("/systems/fcs/flaps/max-deg"),
	flapsDeg: props.globals.getNode("/fdm/jsbsim/fcs/flap-pos-deg"), # Must use this prop
	rudderLowerDeg: props.globals.getNode("/systems/fcs/rudder-lower/final-deg"),
	rudderUpperDeg: props.globals.getNode("/systems/fcs/rudder-upper/final-deg"),
	slatsCmd: props.globals.getNode("/systems/fcs/slats/cmd"),
	slatsDeg: props.globals.getNode("/fdm/jsbsim/fcs/slat-pos-deg"), # Must use this prop
	spoilerL: props.globals.getNode("/systems/fcs/spoiler-left-deg"),
	spoilerR: props.globals.getNode("/systems/fcs/spoiler-right-deg"),
	stabilizerDeg: props.globals.getNode("/systems/fcs/stabilizer/final-deg"),
};
