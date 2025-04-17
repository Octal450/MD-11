# 2D Panel Common
# Copyright (c) 2025 Josh Davidson (Octal450)

var font_mapper = func(family, weight) {
	return "LiberationFonts/LiberationSans-Regular.ttf";
};

# This is because 2020.3 cannot use onClose() methods properly, need to find a better solution
var fgfsVersion = split(".", getprop("/sim/version/flightgear"));
