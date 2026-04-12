# McDonnell Douglas MD-11 SD
# Copyright (c) 2026 Josh Davidson (Octal450)

var CanvasAir = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasAir, CanvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Alert_error"];
	},
	setup: func() {
		# Hide unimplemented objects
	},
	update: func() {
		Value.Misc.wow = pts.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Alert_error"].show();
		} else {
			me["Alert_error"].hide();
		}
	},
};
