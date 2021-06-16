# McDonnell Douglas MD-11 MCDU
# Copyright (c) 2021 Josh Davidson (Octal450)

var mcdu1 = nil;
var mcdu1Display = nil;
var mcdu2 = nil;
var mcdu2Display = nil;
var mcdu3 = nil;
var mcdu3Display = nil;

var Font = {
	default: "MCDULarge.ttf",
	normal: 65,
	small: 54,
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
		
		if (mcdu.unit[n].page == "menu") {
			if (mcdu.unit[n].type) {
				me["Simple_C1"].setText("");
			} else if (mcdu.unit[n].request) {
				me["Simple_C1"].setText("<REQ>  ");
			} else {
				me["Simple_C1"].setText("<ACT>  ");
			}
		} else if (mcdu.unit[n].page == "acstatus") {
			if (pts.Systems.Acconfig.Options.deflectedAileronEquipped.getBoolValue()) {
				me["Simple_L1"].setText("MD-11 DEF AIL");
			} else {
				me["Simple_L1"].setText("MD-11");
			}
			
			if (mcdu.BASE.acStatus.databaseSelected) {
				me["Simple_L3"].setText(mcdu.BASE.acStatus.database2);
				me["Simple_L4"].setText(mcdu.BASE.acStatus.database);
				me["Simple_R3"].setText(mcdu.BASE.acStatus.databaseCode2);
			} else {
				me["Simple_L3"].setText(mcdu.BASE.acStatus.database);
				me["Simple_L4"].setText(mcdu.BASE.acStatus.database2);
				me["Simple_R3"].setText(mcdu.BASE.acStatus.databaseCode);
			}
			
			if (mcdu.BASE.acStatus.perfFactor >= 0) {
				me["Simple_L6"].setText("+" ~ sprintf("%2.1f", mcdu.BASE.acStatus.perfFactor));
			} else {
				me["Simple_L6"].setText(sprintf("%2.1f", mcdu.BASE.acStatus.perfFactor));
			}
		}
	},
	updateBasePage: func(n) { # Only set static elements, rest will be set by update() call immediately after
		me.resetFontSize();
		if (mcdu.unit[n].page == "menu") {
			me["Arrow"].hide();
			me["Simple"].show();
			
			me["Simple_C1S"].setText("");
			me["Simple_C2"].setText("");
			me["Simple_C2S"].setText("");
			me["Simple_C3"].setText("");
			me["Simple_C3S"].setText("");
			me["Simple_C4"].setText("");
			me["Simple_C4S"].setText("");
			me["Simple_C5"].setText("");
			me["Simple_C5S"].setText("");
			me["Simple_C6"].setText("");
			me["Simple_C6S"].setText("");
			
			if (n == 0 and !mcdu.unit[n].type) {
				me["Simple_L1"].setText("<FMC-1");
			} else if (n == 1 and !mcdu.unit[n].type) {
				me["Simple_L1"].setText("<FMC-2");
			} else {
				me["Simple_L1"].setText("");
			}
			
			me["Simple_L1S"].setText("");
			me["Simple_L2"].setText("");
			me["Simple_L2S"].setText("");
			me["Simple_L3"].setText("");
			me["Simple_L3S"].setText("");
			me["Simple_L4"].setText("<CDFS");
			me["Simple_L4S"].setText("");
			me["Simple_L5"].setText("");
			me["Simple_L5S"].setText("");
			me["Simple_L6"].setText("");
			me["Simple_L6S"].setText("");
			
			me["Simple_PageNum"].setText("");
			
			me["Simple_R1"].setText("NAV/RAD*");
			me["Simple_R1S"].setText("STANDBY");
			me["Simple_R2"].setText("");
			me["Simple_R2S"].setText("");
			me["Simple_R3"].setText("");
			me["Simple_R3S"].setText("");
			me["Simple_R4"].setText("");
			me["Simple_R4S"].setText("");
			me["Simple_R5"].setText("MAINT>");
			me["Simple_R5S"].setText("");
			me["Simple_R6"].setText("");
			me["Simple_R6S"].setText("");
			
			me["Simple_Title"].setText("MENU");
		} else if (mcdu.unit[n].page == "acstatus") {
			me["Arrow"].show();
			me["Simple"].show();
			
			me["Simple_C1"].setText("");
			me["Simple_C1S"].setText("");
			me["Simple_C2"].setText("");
			me["Simple_C2S"].setText("");
			me["Simple_C3"].setText("");
			me["Simple_C3S"].setText("");
			me["Simple_C4"].setText("");
			me["Simple_C4S"].setText("");
			me["Simple_C5"].setText("");
			me["Simple_C5S"].setText("");
			me["Simple_C6"].setText("");
			me["Simple_C6S"].setText("");
			
			me["Simple_L1S"].setText(" MODEL");
			me["Simple_L2"].setText(mcdu.BASE.acStatus.program);
			me["Simple_L2S"].setText(" OP PROGRAM");
			me["Simple_L3S"].setText(" ACTIVE DATA BASE");
			me["Simple_L4"].setFontSize(Font.small);
			me["Simple_L4S"].setText(" SECOND DATA BASE");
			me["Simple_L5"].setText("");
			me["Simple_L5S"].setText("");
			me["Simple_L6S"].setText(" PERF FACTOR");
			
			me["Simple_PageNum"].setText("1/2");
			
			me["Simple_R1"].setText(mcdu.BASE.acStatus.eng);
			me["Simple_R1S"].setText("ENGINE ");
			me["Simple_R2"].setText("");
			me["Simple_R2S"].setText("");
			me["Simple_R3"].setText("N/A");
			me["Simple_R3S"].setText("");
			me["Simple_R4"].setText("");
			me["Simple_R4S"].setText("");
			me["Simple_R5"].setText("");
			me["Simple_R5S"].setText("");
			me["Simple_R6"].setText("F-PLN INIT>");
			me["Simple_R6S"].setText("");
			
			me["Simple_Title"].setText("A/C STATUS");
		} else {
			me["Arrow"].hide();
			me["Simple"].show();
			
			me["Simple_C1"].setText("");
			me["Simple_C1S"].setText("");
			me["Simple_C2"].setText("");
			me["Simple_C2S"].setText("");
			me["Simple_C3"].setText("");
			me["Simple_C3S"].setText("");
			me["Simple_C4"].setText("");
			me["Simple_C4S"].setText("");
			me["Simple_C5"].setText("");
			me["Simple_C5S"].setText("");
			me["Simple_C6"].setText("");
			me["Simple_C6S"].setText("");
			
			me["Simple_L1"].setText("");
			me["Simple_L1S"].setText("");
			me["Simple_L2"].setText("");
			me["Simple_L2S"].setText("");
			me["Simple_L3"].setText("");
			me["Simple_L3S"].setText("");
			me["Simple_L4"].setText("");
			me["Simple_L4S"].setText("");
			me["Simple_L5"].setText("");
			me["Simple_L5S"].setText("");
			me["Simple_L6"].setText("");
			me["Simple_L6S"].setText("");
			
			me["Simple_PageNum"].setText("");
			
			me["Simple_R1"].setText("");
			me["Simple_R1S"].setText("");
			me["Simple_R2"].setText("");
			me["Simple_R2S"].setText("");
			me["Simple_R3"].setText("");
			me["Simple_R3S"].setText("");
			me["Simple_R4"].setText("");
			me["Simple_R4S"].setText("");
			me["Simple_R5"].setText("");
			me["Simple_R5S"].setText("");
			me["Simple_R6"].setText("");
			me["Simple_R6S"].setText("");
			
			me["Simple_Title"].setText("PAGE NOT AVAIL");
		}
	},
	resetFontSize: func() {
		me["Simple_C1"].setFontSize(Font.normal);
		me["Simple_C2"].setFontSize(Font.normal);
		me["Simple_C3"].setFontSize(Font.normal);
		me["Simple_C4"].setFontSize(Font.normal);
		me["Simple_C5"].setFontSize(Font.normal);
		me["Simple_C6"].setFontSize(Font.normal);
		me["Simple_L1"].setFontSize(Font.normal);
		me["Simple_L2"].setFontSize(Font.normal);
		me["Simple_L3"].setFontSize(Font.normal);
		me["Simple_L4"].setFontSize(Font.normal);
		me["Simple_L5"].setFontSize(Font.normal);
		me["Simple_L6"].setFontSize(Font.normal);
		me["Simple_R1"].setFontSize(Font.normal);
		me["Simple_R2"].setFontSize(Font.normal);
		me["Simple_R3"].setFontSize(Font.normal);
		me["Simple_R4"].setFontSize(Font.normal);
		me["Simple_R5"].setFontSize(Font.normal);
		me["Simple_R6"].setFontSize(Font.normal);
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
	updatePage: func() {
		me.updateBasePage(0);
		me.update();
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
	updatePage: func() {
		me.updateBasePage(1);
		me.update();
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
	updatePage: func() {
		me.updateBasePage(2);
		me.update();
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
	
	mcdu1.updatePage();
	mcdu2.updatePage();
	mcdu3.updatePage();
	
	update.start();
	
	if (pts.Systems.Acconfig.Options.Du.mcduFps.getValue() != 10) {
		rateApply();
	}
}

var updatePage = func(n) {
	if (n == 0) {
		mcdu1.updatePage();
	} else if (n == 1) {
		mcdu2.updatePage();
	} else if (n == 2) {
		mcdu3.updatePage();
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
