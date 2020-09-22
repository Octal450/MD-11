# McDonnell Douglas MD-11 IRS System
# Copyright (c) 2020 Josh Davidson (Octal450)

var IRS = {
	Switch: {
		knob: [props.globals.getNode("/controls/iru[0]/switches/knob"), props.globals.getNode("/controls/iru[1]/switches/knob"), props.globals.getNode("/controls/iru[2]/switches/knob")],
	},
	init: func() {
		
	},
};
