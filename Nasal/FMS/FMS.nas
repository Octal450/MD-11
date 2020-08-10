# MD-11 FMS
# Copyright (c) 2020 Josh Davidson (Octal450)

var Internal = {
	v2: props.globals.initNode("/FMS/internal/v2", 163, "INT"),
};

var CORE = {
	resetFMS: func() {
		Internal.v2.setValue(163);
		afs.ITAF.init(1);
	},
};
