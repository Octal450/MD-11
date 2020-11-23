# McDonnell Douglas MD-11 SD
# Copyright (c) 2020 Josh Davidson (Octal450)

var display = nil;
var eng = nil;

var Value = {
	
};

var canvasBase = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};
		
		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
			
			var clip_el = canvas_group.getElementById(key ~ "_clip");
			if (clip_el != nil) {
				clip_el.setVisible(0);
				var tran_rect = clip_el.getTransformedBounds();
				
				var clip_rect = sprintf("rect(%d, %d, %d, %d)", 
					tran_rect[1], # 0 ys
					tran_rect[2], # 1 xe
					tran_rect[3], # 2 ye
					tran_rect[0] # 3 xs
				);
				
				# Coordinates are top, right, bottom, left (ys, xe, ye, xs) ref: l621 of simgear/canvas/CanvasElement.cxx
				me[key].set("clip", clip_rect);
				me[key].set("clip-frame", canvas.Element.PARENT);
			}
		}
		
		me.page = canvas_group;
		
		return me;
	},
	getKeys: func() {
		return [];
	},
	setup: func() {
		eng.setup();
	},
	update: func() {
		if (systems.ELEC.Bus.ac3.getValue() >= 110) {
			if (pts.Instrumentation.Sd.selectedSynoptic.getValue() == "ENG") {
				eng.page.show();
				eng.update();
			} else {
				eng.page.hide();
			}
		} else {
			eng.page.hide();
		}
	},
	updateBase: func() {
		
	},
};

var canvasEng = {
	new: func(canvas_group, file) {
		var m = {parents: [canvasEng, canvasBase]};
		m.init(canvas_group, file);
		
		return m;
	},
	getKeys: func() {
		return ["GEGroup", "PWGroup", "APU"];
	},
	setup: func() {
		if (pts.Options.eng.getValue() == "GE") {
			me["GEGroup"].show();
			me["PWGroup"].hide();
		} else {
			me["GEGroup"].hide();
			me["PWGroup"].show();
		}
	},
	update: func() {
		
		
		me.updateBase();
	},
};

var init = func() {
	display = canvas.new({
		"name": "SD",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	
	display.addPlacement({"node": "sd.screen"});
	
	var engGroup = display.createGroup();
	
	eng = canvasEng.new(engGroup, "Aircraft/MD-11/Models/Cockpit/Instruments/SD/res/ENG.svg");
	
	canvasBase.setup();
	sdUpdate.start();
	if (pts.Systems.Acconfig.Options.sdFps.getValue() != 20) {
		rateApply();
	}
}

var rateApply = func() {
	#sdUpdate.restart(1 / pts.Systems.Acconfig.Options.sdFps.getValue()); # 20FPS
}

var sdUpdate = maketimer(0.05, func() {
	canvasBase.update();
});

var showSd = func() {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(display);
	dlg.set("title", "SD");
}
