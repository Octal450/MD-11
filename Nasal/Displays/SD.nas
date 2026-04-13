# McDonnell Douglas MD-11 SD
# McDonnell Douglas MD-11 SD
# Copyright (c) 2026 Josh Davidson (Octal450)

var display = nil;
var air = nil;
var config = nil;
var conseq = nil;
var elec = nil;
var engDials = nil;
var engTapes = nil;
var fuel = nil;
var hyd = nil;
var misc = nil;
var noNd = nil;
var status = nil;
var xx = nil;

var Value = {
	Air: {
		apuPsi: 0,
		bleed1: 0,
		bleed1Psi: 0,
		bleed2: 0,
		bleed2Psi: 0,
		bleed3: 0,
		bleed3Psi: 0,
		bleedApu: 0,
		cabinTempF: 0,
		eng1Psi: 0,
		eng2Psi: 0,
		eng3Psi: 0,
		freighter: 0,
	},
	Apu: {
		n2: 0,
	},
	Config: {
		gearStatus: [0, 0, 0, 0],
	},
	Elec: {
		Bus: {
			dcBatDirect: 0,
		},
		Relay: {
			idgAcGen1: 0,
			idgAcGen2: 0,
			idgAcGen3: 0,
		},
		Source: {
			adgHertz: 0,
			adgVolt: 0,
		},
	},
	Eng: {
		fadecPowered: [0, 0, 0],
		oilPsi: [0, 0, 0],
		oilPsiScale: 160,
		oilQty: [0, 0, 0],
		oilQtyCline: [0, 0, 0],
		oilQtyClineQt: [0, 0, 0],
		oilTemp: [0, 0, 0],
		state: [0, 0, 0],
		type: "GE",
	},
	Fctl: {
		aileronDeflGreen: 0,
		aileronL: 0,
		aileronR: 0,
		elevatorL: 0,
		elevatorR: 0,
		flapDeg: 0,
		rudderLower: 0,
		rudderUpper: 0,
		spoilerL: 0,
		spoilerR: 0,
		stab: 0,
		stabComp: 0,
		stabRound: 0,
	},
	Fuel: {
		afiValve: 0,
		cutoff: [0, 0, 0, 0, 0],
		fill1: 0,
		fill2: 0,
		fill3: 0,
		fillAuxUpper: 0,
		fillTail: 0,
		qty: [0, 0, 0, 0, 0, 0],
		Schematic: {
			afiValveLine: 0,
			afiValveMainLine: 0,
			afiValveTailLine: 0,
			apuLine: 0,
			eng1Line: 0,
			eng1Line2: 0,
			eng2Conn: 0,
			eng2Line: 0,
			eng2Line2: 0,
			eng2Line3: 0,
			eng3Line: 0,
			eng3Line2: 0,
			manifoldAuxConn: 0,
			manifoldAuxConn2: 0,
			manifoldAuxConn3: 0,
			manifoldAuxConn4: 0,
			manifoldAuxLine: 0,
			manifoldAuxLine2: 0,
			manifoldAuxLine3: 0,
			manifoldAuxLine4: 0,
			manifoldAuxLine5: 0,
			manifoldAuxLine6: 0,
			manifoldAuxLine7: 0,
			manifoldAuxLine8: 0,
			manifoldAuxLine9: 0,
			manifoldAuxLine10: 0,
			manifoldAuxLine11: 0,
			tank1AftLine: 0,
			tank1AftLine2: 0,
			tank1FwdLine: 0,
			tank1TransConn: 0,
			tank1TransLine: 0,
			tank1TransFillLine: 0,
			tank2AftLine: 0,
			tank2AftApuConn: 0,
			tank2AftApuLine: 0,
			tank2AftApuLine2: 0,
			tank2AftFwdConn: 0,
			tank2AftLLine: 0,
			tank2AftRLine: 0,
			tank2AftRLine2: 0,
			tank2APULine: 0,
			tank2FwdLine: 0,
			tank2TransConn: 0,
			tank2TransLine: 0,
			tank2TransFillLine: 0,
			tank3AftLine: 0,
			tank3AftLine2: 0,
			tank3FwdLine: 0,
			tank3TransConn: 0,
			tank3TransLine: 0,
			tank3TransFillLine: 0,
			tankAuxLowerLLine: 0,
			tankAuxLowerRLine: 0,
			tankAuxUpperLLine: 0,
			tankAuxUpperRLine: 0,
			tankTailEng2Line: 0,
			tankTailLLine: 0,
			tankTailRLine: 0,
			xFeed1Line: 0,
			xFeed2Line: 0,
			xFeed3Line: 0,
		},
		tank3Temp: 0,
		tankTailTemp: 0,
		xFeed1: 0,
		xFeed2: 0,
		xFeed3: 0,
	},
	Hyd: {
		psi: [0, 0, 0],
		qty: [0, 0, 0],
		qtyLow: [0, 0, 0],
		rmp13Valve: 0,
		rmp23Valve: 0,
		rPumpCmd: [0, 0, 0],
		Schematic: {
			auxLine: 0,
			aux1Line: 0,
			aux2Line: 0,
			rmp13Line: 0,
			rmp13Line2: 0,
			rmp13Line2Thru: 0,
			rmp23Line: 0,
			rmp23Line2: 0,
			sys1Line: 0,
			sys1Line2: 0,
			sys1PumpLLine: 0,
			sys1PumpRLine: 0,
			sys2Line: 0,
			sys2Line2: 0,
			sys2PumpLLine: 0,
			sys2PumpRLine: 0,
			sys3Line: 0,
			sys3Line2: 0,
			sys3Line3: 0,
			sys3Line4: 0,
			sys3PumpLLine: 0,
			sys3PumpRLine: 0,
		},
	},
	Misc: {
		annunTestWow: 0,
		cg: 0,
		fuel: 0,
		gw: 0,
		oat: 0,
		tat: 0,
		wow: 0,
	},
};

var CanvasBase = {
	init: func(canvasGroup, file) {
		var font_mapper = func(family, weight) {
			return "MD11DU.ttf";
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
		me.hidePages();
		
		air.setup();
		elec.setup();
		engDials.setup();
		engTapes.setup();
		fuel.setup();
	},
	hidePages: func() {
		air.page.hide();
		config.page.hide();
		conseq.page.hide();
		elec.page.hide();
		engDials.page.hide();
		engTapes.page.hide();
		fuel.page.hide();
		hyd.page.hide();
		misc.page.hide();
		noNd.page.hide();
		status.page.hide();
		xx.page.hide();
	},
	update: func() {
		if (systems.DUController.updateSd) {
			if (systems.DUController.sdPage == "AIR") {
				air.update();
			} else if (systems.DUController.sdPage == "CONFIG") {
				config.update();
			} else if (systems.DUController.sdPage == "CONSEQ") {
				conseq.update();
			} else if (systems.DUController.sdPage == "ELEC") {
				elec.update();
			} else if (systems.DUController.sdPage == "ENG") {
				if (systems.DUController.eadType == "PW-Tapes") { # Tape style EAD means tape style SD
					engTapes.update();
				} else if (systems.DUController.eadType == "GE-Tapes") { # Tape style EAD means tape style SD
					engTapes.update();
				} else {
					engDials.update();
				}
			} else if (systems.DUController.sdPage == "FUEL") {
				fuel.update();
			} else if (systems.DUController.sdPage == "HYD") {
				hyd.update();
			} else if (systems.DUController.sdPage == "MISC") {
				misc.update();
			} else if (systems.DUController.sdPage == "STATUS") {
				status.update();
			}
		}
	},
};

var CanvasConseq = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasConseq, CanvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Error"];
	},
	update: func() {
		Value.Misc.wow = pts.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Error"].show();
		} else {
			me["Error"].hide();
		}
	},
};

var CanvasMisc = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasMisc, CanvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Error"];
	},
	update: func() {
		Value.Misc.wow = pts.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Error"].show();
		} else {
			me["Error"].hide();
		}
	},
};

var CanvasNoNd = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasNoNd, CanvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
};

var CanvasStatus = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasStatus, CanvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Error"];
	},
	update: func() {
		Value.Misc.wow = pts.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Error"].show();
		} else {
			me["Error"].hide();
		}
	},
};

var CanvasXx = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasXx]};
		canvas.parsesvg(canvasGroup, file);
		m.page = canvasGroup;
		
		return m;
	},
};

var setup = func() {
	display = canvas.new({
		"name": "SD",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	
	display.addPlacement({"node": "sd.screen"});
	
	var airGroup = display.createGroup();
	var configGroup = display.createGroup();
	var conseqGroup = display.createGroup();
	var elecGroup = display.createGroup();
	var engDialsGroup = display.createGroup();
	var engTapesGroup = display.createGroup();
	var fuelGroup = display.createGroup();
	var hydGroup = display.createGroup();
	var miscGroup = display.createGroup();
	var noNdGroup = display.createGroup();
	var statusGroup = display.createGroup();
	var xxGroup = display.createGroup();
	
	air = CanvasAir.new(airGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-AIR.svg");
	config = CanvasConfig.new(configGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-CONFIG.svg");
	conseq = CanvasConseq.new(conseqGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-CONSEQ.svg");
	elec = CanvasElec.new(elecGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-ELEC.svg");
	engDials = CanvasEngDials.new(engDialsGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-ENG-Dials.svg");
	engTapes = CanvasEngTapes.new(engTapesGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-ENG-Tapes.svg");
	fuel = CanvasFuel.new(fuelGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-FUEL.svg");
	hyd = CanvasHyd.new(hydGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-HYD.svg");
	misc = CanvasMisc.new(miscGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-MISC.svg");
	noNd = CanvasNoNd.new(noNdGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-NOND.svg");
	status = CanvasStatus.new(statusGroup, "Aircraft/MD-11/Nasal/Displays/res/SD-STATUS.svg");
	xx = CanvasXx.new(xxGroup, "Aircraft/MD-11/Nasal/Displays/res/XX.svg");
	
	CanvasBase.setup();
	update.start();
	
	if (pts.Systems.Acconfig.Options.Du.sdFps.getValue() != 20) {
		rateApply();
	}
}

var rateApply = func() {
	update.restart(1 / pts.Systems.Acconfig.Options.Du.sdFps.getValue());
}

var update = maketimer(0.05, func() { # 20FPS
	CanvasBase.update();
});

var showSd = func() {
	var dlg = canvas.Window.new([512, 512], "dialog", nil, 0).set("resize", 1);
	dlg.setCanvas(display);
	dlg.set("title", "System Display");
}
