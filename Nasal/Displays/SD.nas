# McDonnell Douglas MD-11 SD
# Copyright (c) 2020 Josh Davidson (Octal450)

var display = nil;
var eng = nil;

# Slow update enable
var updateSd = 0;

var Value = {
	Apu: {
		n2: 0,
	},
	Eng: {
		oilQty: [0, 0, 0],
		oilQtyCline: [0, 0, 0],
	},
	Fctl: {
		stab: 0,
		stabText: 0,
	},
	Misc: {
		fuel: 0,
		gw: 0,
	},
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
		# Hide the pages by default
		eng.page.hide();
		
		eng.setup();
	},
	update: func() {
		if (systems.DUController.updateSd) {
			if (systems.DUController.sdPage == "ENG") {
				eng.update();
			}
		}
	},
};

var canvasEng = {
	new: func(canvas_group, file) {
		var m = {parents: [canvasEng, canvasBase]};
		m.init(canvas_group, file);
		
		return m;
	},
	getKeys: func() {
		return ["GEGroup", "PWGroup", "OilPsi1", "OilPsi1-needle", "OilPsi2", "OilPsi2-needle", "OilPsi3", "OilPsi3-needle", "OilTemp1", "OilTemp1-needle", "OilTemp2", "OilTemp2-needle", "OilTemp3", "OilTemp3-needle", "OilQty1", "OilQty1-needle", "OilQty1-cline",
		"OilQty1-box", "OilQty2", "OilQty2-needle", "OilQty2-cline", "OilQty2-box", "OilQty3", "OilQty3-needle", "OilQty3-cline", "OilQty3-box", "NacelleTemp1", "NacelleTemp2", "NacelleTemp3", "APU", "APU-N1", "APU-EGT", "APU-N2", "APU-QTY", "GW-thousands",
		"GW", "Fuel-thousands", "Fuel", "Stab", "StabBox", "Stab-needle", "StabUnit"];
	},
	setup: func() {
		if (pts.Options.eng.getValue() == "GE") {
			me["GEGroup"].show();
			me["PWGroup"].hide();
		} else {
			me["GEGroup"].hide();
			me["PWGroup"].show();
		}
		
		# Unsimulated stuff, fix later
		me["StabBox"].hide();
	},
	update: func() {
		# GW and Fuel
		Value.Misc.gw = math.round(pts.Fdm.JSBsim.Inertia.weightLbs.getValue(), 100);
		me["GW-thousands"].setText(sprintf("%d", math.floor(Value.Misc.gw / 1000)));
		me["GW"].setText(right(sprintf("%d", Value.Misc.gw), 3));
		
		Value.Misc.fuel = math.round(pts.Consumables.Fuel.totalFuelLbs.getValue(), 100);
		me["Fuel-thousands"].setText(sprintf("%d", math.floor(Value.Misc.fuel / 1000)));
		me["Fuel"].setText(right(sprintf("%d", Value.Misc.fuel), 3));
		
		# Oil Psi
		me["OilPsi1"].setText(sprintf("%d", pts.Engines.Engine.oilPsi[0].getValue()));
		me["OilPsi1-needle"].setRotation(pts.Instrumentation.Sd.Eng.oilPsi[0].getValue() * D2R);
		
		me["OilPsi2"].setText(sprintf("%d", pts.Engines.Engine.oilPsi[1].getValue()));
		me["OilPsi2-needle"].setRotation(pts.Instrumentation.Sd.Eng.oilPsi[1].getValue() * D2R);
		
		me["OilPsi3"].setText(sprintf("%d", pts.Engines.Engine.oilPsi[2].getValue()));
		me["OilPsi3-needle"].setRotation(pts.Instrumentation.Sd.Eng.oilPsi[2].getValue() * D2R);
		
		# Oil Qty
		Value.Eng.oilQty[0] = pts.Engines.Engine.oilQty[0].getValue();
		Value.Eng.oilQty[1] = pts.Engines.Engine.oilQty[1].getValue();
		Value.Eng.oilQty[2] = pts.Engines.Engine.oilQty[2].getValue();
		
		me["OilQty1"].setText(sprintf("%d", math.round(Value.Eng.oilQty[0])));
		me["OilQty1-needle"].setRotation(pts.Instrumentation.Sd.Eng.oilQty[0].getValue() * D2R);
		
		me["OilQty2"].setText(sprintf("%d", math.round(Value.Eng.oilQty[1])));
		me["OilQty2-needle"].setRotation(pts.Instrumentation.Sd.Eng.oilQty[1].getValue() * D2R);
		
		me["OilQty3"].setText(sprintf("%d", math.round(Value.Eng.oilQty[2])));
		me["OilQty3-needle"].setRotation(pts.Instrumentation.Sd.Eng.oilQty[2].getValue() * D2R);
		
		if (Value.Eng.oilQty[0] <= 4) {
			me["OilQty1"].setColor(0.9647,0.8196,0.07843);
			me["OilQty1-box"].show();
			me["OilQty1-needle"].setColor(0.9647,0.8196,0.07843);
		} else {
			me["OilQty1"].setColor(1,1,1);
			me["OilQty1-box"].hide();
			me["OilQty1-needle"].setColor(1,1,1);
		}
		
		if (Value.Eng.oilQty[1] <= 4) {
			me["OilQty2"].setColor(0.9647,0.8196,0.07843);
			me["OilQty2-box"].show();
			me["OilQty2-needle"].setColor(0.9647,0.8196,0.07843);
		} else {
			me["OilQty2"].setColor(1,1,1);
			me["OilQty2-box"].hide();
			me["OilQty2-needle"].setColor(1,1,1);
		}
		
		if (Value.Eng.oilQty[2] <= 4) {
			me["OilQty3"].setColor(0.9647,0.8196,0.07843);
			me["OilQty3-box"].show();
			me["OilQty3-needle"].setColor(0.9647,0.8196,0.07843);
		} else {
			me["OilQty3"].setColor(1,1,1);
			me["OilQty3-box"].hide();
			me["OilQty3-needle"].setColor(1,1,1);
		}
		
		Value.Eng.oilQtyCline[0] = pts.Instrumentation.Sd.Eng.oilQtyCline[0].getValue();
		Value.Eng.oilQtyCline[1] = pts.Instrumentation.Sd.Eng.oilQtyCline[1].getValue();
		Value.Eng.oilQtyCline[2] = pts.Instrumentation.Sd.Eng.oilQtyCline[2].getValue();
		
		if (Value.Eng.oilQtyCline[0] != -1) {
			me["OilQty1-cline"].setRotation(Value.Eng.oilQtyCline[0] * D2R);
			me["OilQty1-cline"].show();
		} else {
			me["OilQty1-cline"].hide();
		}
		if (Value.Eng.oilQtyCline[1] != -1) {
			me["OilQty2-cline"].setRotation(Value.Eng.oilQtyCline[1] * D2R);
			me["OilQty2-cline"].show();
		} else {
			me["OilQty2-cline"].hide();
		}
		if (Value.Eng.oilQtyCline[2] != -1) {
			me["OilQty3-cline"].setRotation(Value.Eng.oilQtyCline[2] * D2R);
			me["OilQty3-cline"].show();
		} else {
			me["OilQty3-cline"].hide();
		}
		
		# Nacelle Temp
		me["NacelleTemp1"].setText(sprintf("%d", math.round(pts.Engines.Engine.nacelleTemp[0].getValue())));
		me["NacelleTemp2"].setText(sprintf("%d", math.round(pts.Engines.Engine.nacelleTemp[1].getValue())));
		me["NacelleTemp3"].setText(sprintf("%d", math.round(pts.Engines.Engine.nacelleTemp[2].getValue())));
		
		# Stab
		Value.Fctl.stab = pts.Fdm.JSBsim.Hydraulics.Stabilizer.finalDeg.getValue();
		Value.Fctl.stabText = math.round(abs(Value.Fctl.stab), 0.1);
		
		me["Stab"].setText(sprintf("%2.1f", Value.Fctl.stabText));
		me["Stab-needle"].setTranslation(Value.Fctl.stab * -12.6451613, 0);
		
		if (Value.Fctl.stab > 0 and Value.Fctl.stabText > 0) {
			me["StabUnit"].setText("AND");
		} else {
			me["StabUnit"].setText("ANU");
		}
		
		# APU
		Value.Apu.n2 = systems.APU.n2.getValue();
		if (Value.Apu.n2 >= 1) {
			me["APU-EGT"].setText(sprintf("%d", math.round(systems.APU.egt.getValue())));
			me["APU-N1"].setText(sprintf("%d", math.round(systems.APU.n1.getValue())));
			me["APU-N2"].setText(sprintf("%d", math.round(Value.Apu.n2)));
			me["APU-QTY"].setText(sprintf("%2.1f", math.round(systems.APU.oilQty.getValue(), 0.5)));
			me["APU"].show();
		} else {
			me["APU"].hide();
		}
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
	
	if (pts.Systems.Acconfig.Options.Du.sdFps.getValue() != 10) {
		rateApply();
	}
}

var rateApply = func() {
	sdUpdate.restart(1 / pts.Systems.Acconfig.Options.Du.sdFps.getValue()); # 10FPS
}

var sdUpdate = maketimer(0.1, func() { # 10FPS
	canvasBase.update();
});

var showSd = func() {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(display);
	dlg.set("title", "System Display");
}
