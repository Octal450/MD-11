# McDonnell Douglas MD-11 Engine Start Dialog
# Copyright (c) 2024 Josh Davidson (Octal450)

var engineStartCanvas = {
	new: func() {
		var m = {parents: [engineStartCanvas]};
		m._title = "Engine Start Panel";
		m._dialog = nil;
		m._canvas = nil;
		m._svg = nil;
		m._root = nil;
		m._svgKeys = nil;
		m._key = nil;
		m._dialogUpdate = maketimer(0.1, m, m._update);
		m._startCmd = [0, 0, 0];
		
		return m;
	},
	getKeys: func() {
		return ["cutoff1", "cutoff2", "cutoff3", "start1", "start2", "start3"];
	},
	close: func() {
		me._dialogUpdate.stop();
		me._dialog.del();
		me._dialog = nil;
	},
	open: func() {
		if (me._dialog != nil and singleInstance) return; # Prevent more than one open
		
		me._dialog = canvas.Window.new([307, 200], "dialog", nil, 0);
		me._dialog.set("title", me._title);
		me._dialog.onClose = func() { panel2d.engineStartDialog.close(); };
		me._canvas  = me._dialog.createCanvas();
		me._root = me._canvas.createGroup();
		
		me._svg = me._root.createChild("group");
		canvas.parsesvg(me._svg, "Aircraft/MD-11/gui/canvas/engine-start.svg", {"font-mapper": font_mapper});
		
		me._svgKeys = me.getKeys();
		foreach(me._key; me._svgKeys) {
			me[me._key] = me._svg.getElementById(me._key);
		}
		
		# Set up clickspots
		me["start1"].addEventListener("click", func(e) {
			systems.ENGINE.Controls.startCmd[0].setBoolValue(!systems.ENGINE.Controls.startCmd[0].getBoolValue());
		});
		me["start2"].addEventListener("click", func(e) {
			systems.ENGINE.Controls.startCmd[1].setBoolValue(!systems.ENGINE.Controls.startCmd[1].getBoolValue());
		});
		me["start3"].addEventListener("click", func(e) {
			systems.ENGINE.Controls.startCmd[2].setBoolValue(!systems.ENGINE.Controls.startCmd[2].getBoolValue());
		});
		
		me["cutoff1"].addEventListener("click", func(e) {
			systems.ENGINE.Controls.cutoff[0].setBoolValue(!systems.ENGINE.Controls.cutoff[0].getBoolValue());
		});
		me["cutoff2"].addEventListener("click", func(e) {
			systems.ENGINE.Controls.cutoff[1].setBoolValue(!systems.ENGINE.Controls.cutoff[1].getBoolValue());
		});
		me["cutoff3"].addEventListener("click", func(e) {
			systems.ENGINE.Controls.cutoff[2].setBoolValue(!systems.ENGINE.Controls.cutoff[2].getBoolValue());
		});
		
		me._update();
		me._dialogUpdate.start();
	},
	_update: func() {
		me._startCmd[0] = systems.ENGINE.Controls.startCmd[0].getValue();
		me._startCmd[1] = systems.ENGINE.Controls.startCmd[1].getValue();
		me._startCmd[2] = systems.ENGINE.Controls.startCmd[2].getValue();
		
		me["start1"].setTranslation(0, me._startCmd[0] * -8);
		me["start2"].setTranslation(0, me._startCmd[1] * -8);
		me["start3"].setTranslation(0, me._startCmd[2] * -8);
		
		if (me._startCmd[0]) {
			me["start1"].setColorFill(1,0,0);
		} else {
			me["start1"].setColorFill(0.3333,0,0);
		}
		if (me._startCmd[1]) {
			me["start2"].setColorFill(1,0,0);
		} else {
			me["start2"].setColorFill(0.3333,0,0);
		}
		if (me._startCmd[2]) {
			me["start3"].setColorFill(1,0,0);
		} else {
			me["start3"].setColorFill(0.3333,0,0);
		}
		
		me["cutoff1"].setRotation((systems.ENGINE.Controls.cutoff[0].getValue() - 1) * 180 * D2R);
		me["cutoff2"].setRotation((systems.ENGINE.Controls.cutoff[1].getValue() - 1) * 180 * D2R);
		me["cutoff3"].setRotation((systems.ENGINE.Controls.cutoff[2].getValue() - 1) * 180 * D2R);
	},
};

var engineStartDialog = engineStartCanvas.new();
