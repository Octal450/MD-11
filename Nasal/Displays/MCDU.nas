# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2021 Josh Davidson (Octal450)

var mcdu1 = nil;
var mcdu1Display = nil;
var mcdu2 = nil;
var mcdu2Display = nil;
var mcdu3 = nil;
var mcdu3Display = nil;

var Font = {
	default: "BoeingCDU-Large.ttf",
	symbol: "LiberationMonoCustom.ttf",
};

var Value = {
	
};

var canvasBase = {
	init: func(canvasGroup, file) {
		var font_mapper = func(family, weight) {
			return Font.default;
		};
		
		canvas.parsesvg(canvasGroup, file, {"font-mapper": font_mapper});
		
		var svgKeys = me.getKeys();
		foreach(var key; svgKeys) {
			me[key] = canvasGroup.getElementById(key);
			
			var clip_el = canvasGroup.getElementById(key ~ "_clip");
			if (clip_el != nil) {
				clip_el.setVisible(0);
				var tranRect = clip_el.getTransformedBounds();
				
				var clip_rect = sprintf("rect(%d, %d, %d, %d)", 
					tranRect[1], # 0 ys
					tranRect[2], # 1 xe
					tranRect[3], # 2 ye
					tranRect[0] # 3 xs
				);
				
				# Coordinates are top, right, bottom, left (ys, xe, ye, xs) ref: l621 of simgear/canvas/CanvasElement.cxx
				me[key].set("clip", clip_rect);
				me[key].set("clip-frame", canvas.Element.PARENT);
			}
		}
		
		me.page = canvasGroup;
		
		return me;
	},
	getKeys: func() {
		return [];
	},
	setup: func() {
		# Hide the pages by default
		mcdu1.page.hide();
		mcdu2.page.hide();
		mcdu3.page.hide();
	},
	update: func() {
		if (systems.DUController.updateMcdu1) {
			mcdu1.update();
		}
		if (systems.DUController.updateMcdu2) {
			mcdu2.update();
		}
		if (systems.DUController.updateMcdu3) {
			mcdu3.update();
		}
	},
	updateBase: func(n) {
		
	},
};

var canvasMcdu1 = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasMcdu1, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	update: func() {
		me.updateBase(0);
	},
};

var canvasMcdu2 = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasMcdu2, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	update: func() {
		me.updateBase(1);
	},
};

var canvasMcdu3 = {
	new: func(canvasGroup, file) {
		var m = {parents: [canvasMcdu3, canvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	update: func() {
		me.updateBase(2);
	},
};

var init = func() {
	mcdu1Display = canvas.new({
		"name": "MCDU1",
		"size": [512, 432],
		"view": [1024, 864],
		"mipmapping": 1
	});
	mcdu2Display = canvas.new({
		"name": "MCDU2",
		"size": [512, 432],
		"view": [1024, 864],
		"mipmapping": 1
	});
	mcdu3Display = canvas.new({
		"name": "MCDU3",
		"size": [512, 432],
		"view": [1024, 864],
		"mipmapping": 1
	});
	
	mcdu1Display.addPlacement({"node": "mcdu1.screen"});
	mcdu2Display.addPlacement({"node": "mcdu2.screen"});
	mcdu3Display.addPlacement({"node": "mcdu3.screen"});
	
	var mcdu1Group = mcdu1Display.createGroup();
	var mcdu2Group = mcdu2Display.createGroup();
	var mcdu3Group = mcdu3Display.createGroup();
	
	mcdu1 = canvasMcdu1.new(mcdu1Group, "Aircraft/MD-11/Nasal/Displays/res/MCDU.svg");
	mcdu2 = canvasMcdu2.new(mcdu2Group, "Aircraft/MD-11/Nasal/Displays/res/MCDU.svg");
	mcdu3 = canvasMcdu3.new(mcdu3Group, "Aircraft/MD-11/Nasal/Displays/res/MCDU.svg");
	
	canvasBase.setup();
	update.start();
	
	if (pts.Systems.Acconfig.Options.Du.mcduFps.getValue() != 10) {
		rateApply();
	}
}

var rateApply = func() {
	update.restart(1 / pts.Systems.Acconfig.Options.Du.mcduFps.getValue());
}

var update = maketimer(0.1, func() { # 10FPS
	canvasBase.update();
});
