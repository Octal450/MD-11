# Hack Canvas
# Authors: Nikolai V. Chr., Josh Davidson (Octal450)
# Inspired from what Thorsten did with setTextUpdate()
# All these methods return me so they can be chained
# This file should be loaded before any canvas use

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
canvas.Path._lastColor = nil;
canvas.Path.setColor = func() {
	me._newColor = canvas._getColor(arg);
	if (me._newColor == me._lastColor) {
		return me;
	}
	me._lastColor = me._newColor;
	me.setStroke(me._newColor);
};
canvas.Path._lastColorFill = nil;
canvas.Path.setColorFill = func() {
	me._newColorFill = canvas._getColor(arg);
	if (me._newColorFill == me._lastColorFill) {
		return me;
	}
	me._lastColorFill = me._newColorFill;
	me.setFill(me._newColorFill);
};

# Text
canvas.Text._lastColor = nil;
canvas.Text.setColor = func() {
	me._newColor = canvas._getColor(arg);
	if (me._newColor == me._lastColor) {
		return me;
	}
	me._lastColor = me._newColor;
	me.set("fill", me._newColor);
};
canvas.Text._lastColorFill = nil;
canvas.Text.setColorFill = func() {
	me._newColorFill = canvas._getColor(arg);
	if (me._newColorFill == me._lastColorFill) {
		return me;
	}
	me._lastColorFill = me._newColorFill;
	me.set("background", me._newColorFill);
};
canvas.Text._lastText = canvas.Text["_lastText"];
canvas.Text.setText = func(text) {
	if (text == me._lastText and text != nil and size(text) == size(me._lastText)) {
		return me;
	}
	me._lastText = text;
	me.set("text", typeof(text) == "scalar" ? text : "");
};
