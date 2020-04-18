# MD-11 FMS
# Copyright (c) 2020 Josh Davidson (Octal450)

setprop("/FMS/internal/v2", 163);

var CORE = {
	resetFMS: func() {
		setprop("/FMS/internal/v2", 163);
		afs.ITAF.init(1);
	},
};
