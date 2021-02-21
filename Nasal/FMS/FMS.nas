# MD-11 FMS
# Copyright (c) 2021 Josh Davidson (Octal450)

var Internal = {
	bankAngle1: props.globals.initNode("/fms/internal/bank-limit-1", 0, "DOUBLE"),
	bankAngle2: props.globals.initNode("/fms/internal/bank-limit-2", 0, "DOUBLE"),
	v2: props.globals.initNode("/fms/internal/v2", 153, "INT"),
};

var CORE = {
	resetFMS: func() {
		Internal.v2.setValue(153);
		afs.ITAF.init(1);
	},
};
