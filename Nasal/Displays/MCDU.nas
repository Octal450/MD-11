# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2024 Josh Davidson (Octal450)

var mcdu1 = nil;
var mcdu1Display = nil;
var mcdu2 = nil;
var mcdu2Display = nil;
var mcdu3 = nil;
var mcdu3Display = nil;

var Value = {
};

var canvasBase = {
	init: func(canvasGroup, file) {
		var font_mapper = func(family, weight) {
			return mcdu.FONT.default;
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
		return ["Arrow", "Clr", "C1", "C1S", "C2", "C2S", "C3", "C3S", "C4", "C4S", "C5", "C5S", "C6", "C6S", "L1", "L1A", "L1S", "L2", "L2A", "L2S", "L3", "L3A", "L3S", "L4", "L4A", "L4S", "L5", "L5A", "L5S", "L6", "L6A", "L6S",
		"PageNum", "R1", "R1A", "R1S", "R2", "R2A", "R2S", "R3", "R3A", "R3S", "R4", "R4A", "R4S", "R5", "R5A", "R5S", "R6", "R6A", "R6S", "Scratchpad", "Title"];
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
		if (mcdu.unit[n].clear) {
			me["Clr"].show();
		} else {
			me["Clr"].hide();
		}
		me["Scratchpad"].setText(mcdu.unit[n].scratchpad);
		
		if (mcdu.unit[n].page.Display.arrow) {
			me["Arrow"].show();
		} else {
			me["Arrow"].hide();
		}
		
		me["C1"].setText(mcdu.unit[n].page.Display.C1);
		me["C1S"].setText(mcdu.unit[n].page.Display.C1S);
		me["C2"].setText(mcdu.unit[n].page.Display.C2);
		me["C2S"].setText(mcdu.unit[n].page.Display.C2S);
		me["C3"].setText(mcdu.unit[n].page.Display.C3);
		me["C3S"].setText(mcdu.unit[n].page.Display.C3S);
		me["C4"].setText(mcdu.unit[n].page.Display.C4);
		me["C4S"].setText(mcdu.unit[n].page.Display.C4S);
		me["C5"].setText(mcdu.unit[n].page.Display.C5);
		me["C5S"].setText(mcdu.unit[n].page.Display.C5S);
		me["C6"].setText(mcdu.unit[n].page.Display.C6);
		me["C6S"].setText(mcdu.unit[n].page.Display.C6S);
		
		me["L1"].setText(mcdu.unit[n].page.Display.L1);
		me["L1S"].setText(mcdu.unit[n].page.Display.L1S);
		me["L2"].setText(mcdu.unit[n].page.Display.L2);
		me["L2S"].setText(mcdu.unit[n].page.Display.L2S);
		me["L3"].setText(mcdu.unit[n].page.Display.L3);
		me["L3S"].setText(mcdu.unit[n].page.Display.L3S);
		me["L4"].setText(mcdu.unit[n].page.Display.L4);
		me["L4S"].setText(mcdu.unit[n].page.Display.L4S);
		me["L5"].setText(mcdu.unit[n].page.Display.L5);
		me["L5S"].setText(mcdu.unit[n].page.Display.L5S);
		me["L6"].setText(mcdu.unit[n].page.Display.L6);
		me["L6S"].setText(mcdu.unit[n].page.Display.L6S);
		
		me["PageNum"].setText(mcdu.unit[n].page.Display.pageNum);
		
		me["R1"].setText(mcdu.unit[n].page.Display.R1);
		me["R1S"].setText(mcdu.unit[n].page.Display.R1S);
		me["R2"].setText(mcdu.unit[n].page.Display.R2);
		me["R2S"].setText(mcdu.unit[n].page.Display.R2S);
		me["R3"].setText(mcdu.unit[n].page.Display.R3);
		me["R3S"].setText(mcdu.unit[n].page.Display.R3S);
		me["R4"].setText(mcdu.unit[n].page.Display.R4);
		me["R4S"].setText(mcdu.unit[n].page.Display.R4S);
		me["R5"].setText(mcdu.unit[n].page.Display.R5);
		me["R5S"].setText(mcdu.unit[n].page.Display.R5S);
		me["R6"].setText(mcdu.unit[n].page.Display.R6);
		me["R6S"].setText(mcdu.unit[n].page.Display.R6S);
		
		me["Title"].setText(mcdu.unit[n].page.Display.title);
		
		me.updateFontSize(n);
		
		me["C1"].setTranslation(mcdu.unit[n].page.Display.CTranslate[0], 0);
		me["C1S"].setTranslation(mcdu.unit[n].page.Display.CSTranslate[0], 0);
		me["C2"].setTranslation(mcdu.unit[n].page.Display.CTranslate[1], 0);
		me["C2S"].setTranslation(mcdu.unit[n].page.Display.CSTranslate[1], 0);
		me["C3"].setTranslation(mcdu.unit[n].page.Display.CTranslate[2], 0);
		me["C3S"].setTranslation(mcdu.unit[n].page.Display.CSTranslate[2], 0);
		me["C4"].setTranslation(mcdu.unit[n].page.Display.CTranslate[3], 0);
		me["C4S"].setTranslation(mcdu.unit[n].page.Display.CSTranslate[3], 0);
		me["C5"].setTranslation(mcdu.unit[n].page.Display.CTranslate[4], 0);
		me["C5S"].setTranslation(mcdu.unit[n].page.Display.CSTranslate[4], 0);
		me["C6"].setTranslation(mcdu.unit[n].page.Display.CTranslate[5], 0);
		me["C6S"].setTranslation(mcdu.unit[n].page.Display.CSTranslate[5], 0);
	},
	updateFontSize: func(n) {
		if (me["C1"].get("character-size") != mcdu.unit[n].page.Display.CFont[0]) me["C1"].setFontSize(mcdu.unit[n].page.Display.CFont[0]);
		if (me["C2"].get("character-size") != mcdu.unit[n].page.Display.CFont[1]) me["C2"].setFontSize(mcdu.unit[n].page.Display.CFont[1]);
		if (me["C3"].get("character-size") != mcdu.unit[n].page.Display.CFont[2]) me["C3"].setFontSize(mcdu.unit[n].page.Display.CFont[2]);
		if (me["C4"].get("character-size") != mcdu.unit[n].page.Display.CFont[3]) me["C4"].setFontSize(mcdu.unit[n].page.Display.CFont[3]);
		if (me["C5"].get("character-size") != mcdu.unit[n].page.Display.CFont[4]) me["C5"].setFontSize(mcdu.unit[n].page.Display.CFont[4]);
		if (me["C6"].get("character-size") != mcdu.unit[n].page.Display.CFont[5]) me["C6"].setFontSize(mcdu.unit[n].page.Display.CFont[5]);
		
		if (me["L1"].get("character-size") != mcdu.unit[n].page.Display.LFont[0]) me["L1"].setFontSize(mcdu.unit[n].page.Display.LFont[0]);
		if (me["L2"].get("character-size") != mcdu.unit[n].page.Display.LFont[1]) me["L2"].setFontSize(mcdu.unit[n].page.Display.LFont[1]);
		if (me["L3"].get("character-size") != mcdu.unit[n].page.Display.LFont[2]) me["L3"].setFontSize(mcdu.unit[n].page.Display.LFont[2]);
		if (me["L4"].get("character-size") != mcdu.unit[n].page.Display.LFont[3]) me["L4"].setFontSize(mcdu.unit[n].page.Display.LFont[3]);
		if (me["L5"].get("character-size") != mcdu.unit[n].page.Display.LFont[4]) me["L5"].setFontSize(mcdu.unit[n].page.Display.LFont[4]);
		if (me["L6"].get("character-size") != mcdu.unit[n].page.Display.LFont[5]) me["L6"].setFontSize(mcdu.unit[n].page.Display.LFont[5]);
		
		if (me["R1"].get("character-size") != mcdu.unit[n].page.Display.RFont[0]) me["R1"].setFontSize(mcdu.unit[n].page.Display.RFont[0]);
		if (me["R2"].get("character-size") != mcdu.unit[n].page.Display.RFont[1]) me["R2"].setFontSize(mcdu.unit[n].page.Display.RFont[1]);
		if (me["R3"].get("character-size") != mcdu.unit[n].page.Display.RFont[2]) me["R3"].setFontSize(mcdu.unit[n].page.Display.RFont[2]);
		if (me["R4"].get("character-size") != mcdu.unit[n].page.Display.RFont[3]) me["R4"].setFontSize(mcdu.unit[n].page.Display.RFont[3]);
		if (me["R5"].get("character-size") != mcdu.unit[n].page.Display.RFont[4]) me["R5"].setFontSize(mcdu.unit[n].page.Display.RFont[4]);
		if (me["R6"].get("character-size") != mcdu.unit[n].page.Display.RFont[5]) me["R6"].setFontSize(mcdu.unit[n].page.Display.RFont[5]);
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
	
	mcdu1.update();
	mcdu2.update();
	mcdu3.update();
	
	update.start();
	
	if (pts.Systems.Acconfig.Options.Du.mcduFps.getValue() != 10) {
		rateApply();
	}
}

var updateMcdu = func(n) {
	if (n == 0) {
		mcdu1.update();
	} else if (n == 1) {
		mcdu2.update();
	} else if (n == 2) {
		mcdu3.update();
	}
}

var rateApply = func() {
	update.restart(1 / pts.Systems.Acconfig.Options.Du.mcduFps.getValue());
}

var update = maketimer(0.1, func() { # 10FPS
	canvasBase.update();
});

var showMcdu1 = func {
	gui.showDialog("mcdu1");
}

var showMcdu2 = func {
	gui.showDialog("mcdu2");
}

var showMcdu3 = func {
	gui.showDialog("mcdu3");
}
