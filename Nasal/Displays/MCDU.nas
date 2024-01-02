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
		return ["Arrow", "Clr", "Scratchpad", "Simple", "Simple_C1", "Simple_C1S", "Simple_C2", "Simple_C2S", "Simple_C3", "Simple_C3S", "Simple_C4", "Simple_C4S", "Simple_C5", "Simple_C5S", "Simple_C6", "Simple_C6S", "Simple_L1", "Simple_L1A", "Simple_L1S",
		"Simple_L2", "Simple_L2A", "Simple_L2S", "Simple_L3", "Simple_L3A", "Simple_L3S", "Simple_L4", "Simple_L4A", "Simple_L4S", "Simple_L5", "Simple_L5A", "Simple_L5S", "Simple_L6", "Simple_L6A", "Simple_L6S", "Simple_PageNum", "Simple_R1", "Simple_R1A",
		"Simple_R1S", "Simple_R2", "Simple_R2A", "Simple_R2S", "Simple_R3", "Simple_R3A", "Simple_R3S", "Simple_R4", "Simple_R4A", "Simple_R4S", "Simple_R5", "Simple_R5A", "Simple_R5S", "Simple_R6", "Simple_R6A", "Simple_R6S", "Simple_Title"];
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
		
		if (mcdu.unit[n].page.Display.simple) {
			if (mcdu.unit[n].page.Display.arrow) {
				me["Arrow"].show();
			} else {
				me["Arrow"].hide();
			}
			
			me["Simple"].show();
			
			me["Simple_C1"].setText(mcdu.unit[n].page.Display.C1);
			me["Simple_C1S"].setText(mcdu.unit[n].page.Display.C1S);
			me["Simple_C2"].setText(mcdu.unit[n].page.Display.C2);
			me["Simple_C2S"].setText(mcdu.unit[n].page.Display.C2S);
			me["Simple_C3"].setText(mcdu.unit[n].page.Display.C3);
			me["Simple_C3S"].setText(mcdu.unit[n].page.Display.C3S);
			me["Simple_C4"].setText(mcdu.unit[n].page.Display.C4);
			me["Simple_C4S"].setText(mcdu.unit[n].page.Display.C4S);
			me["Simple_C5"].setText(mcdu.unit[n].page.Display.C5);
			me["Simple_C5S"].setText(mcdu.unit[n].page.Display.C5S);
			me["Simple_C6"].setText(mcdu.unit[n].page.Display.C6);
			me["Simple_C6S"].setText(mcdu.unit[n].page.Display.C6S);
			
			me["Simple_L1"].setText(mcdu.unit[n].page.Display.L1);
			me["Simple_L1S"].setText(mcdu.unit[n].page.Display.L1S);
			me["Simple_L2"].setText(mcdu.unit[n].page.Display.L2);
			me["Simple_L2S"].setText(mcdu.unit[n].page.Display.L2S);
			me["Simple_L3"].setText(mcdu.unit[n].page.Display.L3);
			me["Simple_L3S"].setText(mcdu.unit[n].page.Display.L3S);
			me["Simple_L4"].setText(mcdu.unit[n].page.Display.L4);
			me["Simple_L4S"].setText(mcdu.unit[n].page.Display.L4S);
			me["Simple_L5"].setText(mcdu.unit[n].page.Display.L5);
			me["Simple_L5S"].setText(mcdu.unit[n].page.Display.L5S);
			me["Simple_L6"].setText(mcdu.unit[n].page.Display.L6);
			me["Simple_L6S"].setText(mcdu.unit[n].page.Display.L6S);
			
			me["Simple_PageNum"].setText(mcdu.unit[n].page.Display.pageNum);
			
			me["Simple_R1"].setText(mcdu.unit[n].page.Display.R1);
			me["Simple_R1S"].setText(mcdu.unit[n].page.Display.R1S);
			me["Simple_R2"].setText(mcdu.unit[n].page.Display.R2);
			me["Simple_R2S"].setText(mcdu.unit[n].page.Display.R2S);
			me["Simple_R3"].setText(mcdu.unit[n].page.Display.R3);
			me["Simple_R3S"].setText(mcdu.unit[n].page.Display.R3S);
			me["Simple_R4"].setText(mcdu.unit[n].page.Display.R4);
			me["Simple_R4S"].setText(mcdu.unit[n].page.Display.R4S);
			me["Simple_R5"].setText(mcdu.unit[n].page.Display.R5);
			me["Simple_R5S"].setText(mcdu.unit[n].page.Display.R5S);
			me["Simple_R6"].setText(mcdu.unit[n].page.Display.R6);
			me["Simple_R6S"].setText(mcdu.unit[n].page.Display.R6S);
			
			me["Simple_Title"].setText(mcdu.unit[n].page.Display.title);
			
			me.updateFontSize(n);
		} else {
			me["Simple"].hide();
		}
	},
	updateFontSize: func(n) {
		if (me["Simple_C1"].get("character-size") != mcdu.unit[n].page.Display.CFont[0]) me["Simple_C1"].setFontSize(mcdu.unit[n].page.Display.CFont[0]);
		if (me["Simple_C2"].get("character-size") != mcdu.unit[n].page.Display.CFont[1]) me["Simple_C2"].setFontSize(mcdu.unit[n].page.Display.CFont[1]);
		if (me["Simple_C3"].get("character-size") != mcdu.unit[n].page.Display.CFont[2]) me["Simple_C3"].setFontSize(mcdu.unit[n].page.Display.CFont[2]);
		if (me["Simple_C4"].get("character-size") != mcdu.unit[n].page.Display.CFont[3]) me["Simple_C4"].setFontSize(mcdu.unit[n].page.Display.CFont[3]);
		if (me["Simple_C5"].get("character-size") != mcdu.unit[n].page.Display.CFont[4]) me["Simple_C5"].setFontSize(mcdu.unit[n].page.Display.CFont[4]);
		if (me["Simple_C6"].get("character-size") != mcdu.unit[n].page.Display.CFont[5]) me["Simple_C6"].setFontSize(mcdu.unit[n].page.Display.CFont[5]);
		
		if (me["Simple_L1"].get("character-size") != mcdu.unit[n].page.Display.LFont[0]) me["Simple_L1"].setFontSize(mcdu.unit[n].page.Display.LFont[0]);
		if (me["Simple_L2"].get("character-size") != mcdu.unit[n].page.Display.LFont[1]) me["Simple_L2"].setFontSize(mcdu.unit[n].page.Display.LFont[1]);
		if (me["Simple_L3"].get("character-size") != mcdu.unit[n].page.Display.LFont[2]) me["Simple_L3"].setFontSize(mcdu.unit[n].page.Display.LFont[2]);
		if (me["Simple_L4"].get("character-size") != mcdu.unit[n].page.Display.LFont[3]) me["Simple_L4"].setFontSize(mcdu.unit[n].page.Display.LFont[3]);
		if (me["Simple_L5"].get("character-size") != mcdu.unit[n].page.Display.LFont[4]) me["Simple_L5"].setFontSize(mcdu.unit[n].page.Display.LFont[4]);
		if (me["Simple_L6"].get("character-size") != mcdu.unit[n].page.Display.LFont[5]) me["Simple_L6"].setFontSize(mcdu.unit[n].page.Display.LFont[5]);
		
		if (me["Simple_R1"].get("character-size") != mcdu.unit[n].page.Display.RFont[0]) me["Simple_R1"].setFontSize(mcdu.unit[n].page.Display.RFont[0]);
		if (me["Simple_R2"].get("character-size") != mcdu.unit[n].page.Display.RFont[1]) me["Simple_R2"].setFontSize(mcdu.unit[n].page.Display.RFont[1]);
		if (me["Simple_R3"].get("character-size") != mcdu.unit[n].page.Display.RFont[2]) me["Simple_R3"].setFontSize(mcdu.unit[n].page.Display.RFont[2]);
		if (me["Simple_R4"].get("character-size") != mcdu.unit[n].page.Display.RFont[3]) me["Simple_R4"].setFontSize(mcdu.unit[n].page.Display.RFont[3]);
		if (me["Simple_R5"].get("character-size") != mcdu.unit[n].page.Display.RFont[4]) me["Simple_R5"].setFontSize(mcdu.unit[n].page.Display.RFont[4]);
		if (me["Simple_R6"].get("character-size") != mcdu.unit[n].page.Display.RFont[5]) me["Simple_R6"].setFontSize(mcdu.unit[n].page.Display.RFont[5]);
	},
	resetFontSize: func() {
		#me["Simple_C1"].setFontSize(Font.normal);
		#me["Simple_C2"].setFontSize(Font.normal);
		#me["Simple_C3"].setFontSize(Font.normal);
		#me["Simple_C4"].setFontSize(Font.normal);
		#me["Simple_C5"].setFontSize(Font.normal);
		#me["Simple_C6"].setFontSize(Font.normal);
		#me["Simple_L1"].setFontSize(Font.normal);
		#me["Simple_L2"].setFontSize(Font.normal);
		#me["Simple_L3"].setFontSize(Font.normal);
		#me["Simple_L4"].setFontSize(Font.normal);
		#me["Simple_L5"].setFontSize(Font.normal);
		#me["Simple_L6"].setFontSize(Font.normal);
		#me["Simple_R1"].setFontSize(Font.normal);
		#me["Simple_R2"].setFontSize(Font.normal);
		#me["Simple_R3"].setFontSize(Font.normal);
		#me["Simple_R4"].setFontSize(Font.normal);
		#me["Simple_R5"].setFontSize(Font.normal);
		#me["Simple_R6"].setFontSize(Font.normal);
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
