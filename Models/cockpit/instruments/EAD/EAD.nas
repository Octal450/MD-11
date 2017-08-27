# MD-11 EAD Canvas
# Joshua Davidson (it0uchpods)

setprop("/fuck/fuck", 0);

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

var EAD_GE = nil;
var EAD_display = nil;

var canvas_EAD_base = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {'font-mapper': font_mapper});

		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}

		me.page = canvas_group;

		return me;
	},
	getKeys: func() {
		return [];
	},
	update: func() {
#		if (power to displays) {
			if (getprop("/options/eng") == "GE") {
				EAD_GE.page.show();
#				EAD_PW.page.hide();
			} else if (getprop("/options/eng") == "PW") {
				EAD_GE.page.hide();
#				EAD_PW.page.show();
			}
#		} else {
#			EAD_GE.page.hide();
#			EAD_PW.page.hide();
#		}
		
		settimer(func me.update(), 0.02);
	},
	updateBase: func() {
		# Reversers
		if (getprop("/engines/engine[0]/reverser-pos-norm") and getprop("/options/eng") == "GE") {
			me["REV1"].show();
			me["N11-thr"].hide();
		} else {
			me["REV1"].hide();
			me["N11-thr"].show();
		}
		
		if (getprop("/engines/engine[0]/reverser-pos-norm") >= 0.95) {
			me["REV1"].setColor(0,1,0);
		} else {
			me["REV1"].setColor(1,1,0);
		}
	},
};

var canvas_EAD_GE = {
	new: func(canvas_group, file) {
		var m = { parents: [canvas_EAD_GE , canvas_EAD_base] };
		m.init(canvas_group, file);
		
		me.getKeys();
		
		m["N11-decimal"].set("clip", "rect(441.72, 100, 14.75, 100)");

		return m;
	},
	getKeys: func() {
		return ["N11","N11-decpnt","N11-decimal","N11-needle","N11-lim","N11-thr","N11-redline","REV1"];
	},
	update: func() {
		# N1
		me["N11-decimal"].setTranslation(0,int(10*math.mod(getprop("/engines/engine[0]/n1") + 0.05,1))*33.65);
		
		me.updateBase();
		
		settimer(func me.update(), 0.02);
	},
};

setlistener("sim/signals/fdm-initialized", func {
	EAD_display = canvas.new({
		"name": "EAD",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	EAD_display.addPlacement({"node": "ead.screen"});
	var group_EAD_GE = EAD_display.createGroup();

	EAD_GE = canvas_EAD_GE.new(group_EAD_GE, "Aircraft/MD-11Family/Models/cockpit/instruments/EAD/res/ge.svg");

	EAD_GE.update();
	canvas_EAD_base.update();
});

var showEAD = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(EAD_display);
}
