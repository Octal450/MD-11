# MD-11 FMS
# Copyright (c) 2021 Josh Davidson (Octal450)

var Internal = {
	v2: props.globals.initNode("/FMS/internal/v2", 153, "INT"),
};

var CORE = {
	resetFMS: func() {
		Internal.v2.setValue(153);
		afs.ITAF.init(1);
	},
};
