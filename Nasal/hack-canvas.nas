# Hack Canvas
# Copyright (c) 2024 Josh Davidson (Octal450)
# Based on work by Nikolai V. Chr.

# Element
canvas.Element._lastVisible = nil;
canvas.Element.show = func() {
	if (1 == me._lastVisible) {
		return me;
	}
	me._lastVisible = 1;
	me.setBool("visible", 1);
};
canvas.Element.hide = func() {
	if (0 == me._lastVisible) {
		return me;
	}
	me._lastVisible = 0;
	me.setBool("visible", 0);
};
canvas.Element.setVisible = func(vis) {
	if (vis == me._lastVisible) {
		return me;
	}
	me._lastVisible = vis;
	me.setBool("visible", vis);
};

# Path
canvas.Path._lastColor = "rgb(255,255,255)";
canvas.Path._newColor = "rgb(255,255,255)";
canvas.Path.setColor = func() {
	me._newColor = canvas._getColor(arg);
	if (me._newColor == me._lastColor) {
		return me;
	}
	me._lastColor = me._newColor;
	me.setStroke(me._newColor);
};
canvas.Path._lastColorFill = "rgb(255,255,255)";
canvas.Path._newColorFill = "rgb(255,255,255)";
canvas.Path.setColorFill = func() {
	me._newColorFill = canvas._getColor(arg);
	if (me._newColorFill == me._lastColorFill) {
		return me;
	}
	me._lastColorFill = me._newColorFill;
	me.setFill(me._newColorFill);
};

# Text
canvas.Text._lastText = canvas.Text["_lastText"];
canvas.Text.setText = func(text) {
	if (text == me._lastText and text != nil and size(text) == size(me._lastText)) {
		return me;
	}
	me._lastText = text;
	me.set("text", typeof(text) == "scalar" ? text : "");
};
