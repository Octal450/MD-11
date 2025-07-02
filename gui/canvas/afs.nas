# McDonnell Douglas MD-11 AFS Dialog
# Copyright (c) 2025 Josh Davidson (Octal450)

var afsCanvas = {
	new: func() {
		var m = {parents: [afsCanvas]};
		m._title = "AFS Panel";
		m._dialog = nil;
		m._canvas = nil;
		m._svg = nil;
		m._root = nil;
		m._svgKeys = nil;
		m._key = nil;
		m._dialogUpdate = maketimer(0.05, m, m._update);
		m._ovrd = [0, 0];
		m._vert = 0;
		
		return m;
	},
	getKeys: func() {
		return ["AfsDisc", "AfsOvrd1", "AfsOvrd2", "AfsOvrd1Click", "AfsOvrd2Click", "AltKnob", "AltMinus", "AltPlus", "Alt_7seg", "ApprLand", "AtsDisc", "Autoflight", "BankAuto", "BankLimit", "Bank5", "Bank10", "Bank15", "Bank20", "Bank25", "Display", "Fd1",
		"Fd2", "FeetInd", "FeetMeter", "FmsSpd", "FpaInd", "Ga", "HdgInd", "HdgKnob", "HdgMinus", "HdgPlus", "HdgTrk", "Hdg_7seg", "IasInd", "IasMach", "MachInd", "MeterInd", "Nav", "Prof", "SpdKnob", "SpdMinus", "SpdPlus", "Spd_7seg", "TrkInd", "VsFpa",
		"VsInd", "VsKnob", "VsMinus", "VsPlus", "Vs_7seg"];
	},
	close: func() {
		me._dialogUpdate.stop();
		me._dialog.del();
		me._dialog = nil;
	},
	open: func() {
		if (me._dialog != nil) return; # Prevent more than one open
		
		me._dialog = canvas.Window.new([599, 200], "dialog", nil, 0);
		me._dialog.set("title", me._title);
		me._dialog.onClose = func() { panel2d.afsDialog.close(); };
		me._canvas  = me._dialog.createCanvas();
		me._root = me._canvas.createGroup();
		
		me._svg = me._root.createChild("group");
		canvas.parsesvg(me._svg, "Aircraft/MD-11/gui/canvas/afs.svg", {"font-mapper": font_mapper});
		
		me._svgKeys = me.getKeys();
		foreach(me._key; me._svgKeys) {
			me[me._key] = me._svg.getElementById(me._key);
			if (find("_7seg", me._key) != -1) me[me._key].setFont("Std7SegCustom.ttf");
		}
		
		# Set up clickspots
		# Center Buttons
		me["Autoflight"].addEventListener("click", func(e) {
			cockpit.ApPanel.autoflight();
		});
		me["ApprLand"].addEventListener("click", func(e) {
			cockpit.ApPanel.appr();
		});
		
		me["AfsDisc"].addEventListener("click", func(e) {
			cockpit.ApPanel.apDisc();
		});
		me["AtsDisc"].addEventListener("click", func(e) {
			cockpit.ApPanel.atDisc();
		});
		me["Fd1"].addEventListener("click", func(e) {
			cockpit.ApPanel.fd1();
		});
		me["Ga"].addEventListener("click", func(e) {
			cockpit.ApPanel.toga();
		});
		me["Fd2"].addEventListener("click", func(e) {
			cockpit.ApPanel.fd2();
		});
		
		me["AfsOvrd1Click"].addEventListener("click", func(e) {
			me._ovrd[0] = afs.Input.ovrd1.getBoolValue();
			if (e.shiftKey or me._ovrd[0]) {
				afs.Input.ovrd1.setBoolValue(!me._ovrd[0]);
			} else {
				gui.popupTip("Shift + D or Yoke Btn: AFS Off\nCtrl + D or Throttle Btn: ATS Off\n\nThis is the emergency override, shift click to use");
			}
		});
		me["AfsOvrd1Click"].setColorFill(0,0,0,0); # Make it invisible
		
		me["AfsOvrd2Click"].addEventListener("click", func(e) {
			me._ovrd[1] = afs.Input.ovrd2.getBoolValue();
			if (e.shiftKey or me._ovrd[1]) {
				afs.Input.ovrd2.setBoolValue(!me._ovrd[1]);
			} else {
				gui.popupTip("Shift + D or Yoke Btn: AFS Off\nCtrl + D or Throttle Btn: ATS Off\n\nThis is the emergency override, shift click to use");
			}
		});
		me["AfsOvrd2Click"].setColorFill(0,0,0,0); # Make it invisible
		
		# Speed
		me["SpdKnob"].addEventListener("click", func(e) {
			if (e.shiftKey or e.button == 1) {
				cockpit.ApPanel.spdPull();
			} else if (e.button == 0) {
				cockpit.ApPanel.spdPush();
			}
		});
		me["SpdKnob"].addEventListener("wheel", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.spdAdjust(10 * e.deltaY);
			} else {
				cockpit.ApPanel.spdAdjust(e.deltaY);
			}
		});
		me["SpdMinus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.spdAdjust(-10);
			} else {
				cockpit.ApPanel.spdAdjust(-1);
			}
		});
		me["SpdPlus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.spdAdjust(10);
			} else {
				cockpit.ApPanel.spdAdjust(1);
			}
		});
		
		me["IasMach"].addEventListener("click", func(e) {
			cockpit.ApPanel.ktsMach();
		});
		
		me["FmsSpd"].addEventListener("click", func(e) {
			cockpit.ApPanel.fmsSpd();
		});
		
		# Heading
		me["HdgKnob"].addEventListener("click", func(e) {
			if (e.shiftKey or e.button == 1) {
				cockpit.ApPanel.hdgPull();
			} else if (e.button == 0) {
				cockpit.ApPanel.hdgPush();
			}
		});
		me["HdgKnob"].addEventListener("wheel", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.hdgAdjust(10 * e.deltaY);
			} else {
				cockpit.ApPanel.hdgAdjust(e.deltaY);
			}
		});
		me["HdgMinus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.hdgAdjust(-10);
			} else {
				cockpit.ApPanel.hdgAdjust(-1);
			}
		});
		me["HdgPlus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.hdgAdjust(10);
			} else {
				cockpit.ApPanel.hdgAdjust(1);
			}
		});
		
		me["HdgTrk"].addEventListener("click", func(e) {
			cockpit.ApPanel.hdgTrk();
		});
		
		me["Nav"].addEventListener("click", func(e) {
			cockpit.ApPanel.nav();
		});
		
		# Bank Limit
		me["BankAuto"].addEventListener("click", func(e) {
			afs.Input.bankLimitSw.setValue(0);
		});
		me["Bank5"].addEventListener("click", func(e) {
			afs.Input.bankLimitSw.setValue(1);
		});
		me["Bank10"].addEventListener("click", func(e) {
			afs.Input.bankLimitSw.setValue(2);
		});
		me["Bank15"].addEventListener("click", func(e) {
			afs.Input.bankLimitSw.setValue(3);
		});
		me["Bank20"].addEventListener("click", func(e) {
			afs.Input.bankLimitSw.setValue(4);
		});
		me["Bank25"].addEventListener("click", func(e) {
			afs.Input.bankLimitSw.setValue(5);
		});
		
		# Altitude
		me["AltKnob"].addEventListener("click", func(e) {
			if (e.shiftKey or e.button == 1) {
				cockpit.ApPanel.altPull();
			} else if (e.button == 0) {
				cockpit.ApPanel.altPush();
			}
		});
		me["AltKnob"].addEventListener("wheel", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.altAdjust(10 * e.deltaY);
			} else {
				cockpit.ApPanel.altAdjust(e.deltaY);
			}
		});
		me["AltMinus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.altAdjust(-10);
			} else {
				cockpit.ApPanel.altAdjust(-1);
			}
		});
		me["AltPlus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.altAdjust(10);
			} else {
				cockpit.ApPanel.altAdjust(1);
			}
		});
		
		# Vertical Speed
		me["VsKnob"].addEventListener("wheel", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.vsAdjust(-10 * e.deltaY); # Inverted
			} else {
				cockpit.ApPanel.vsAdjust(-1 * e.deltaY); # Inverted
			}
		});
		me["VsMinus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.vsAdjust(-10);
			} else {
				cockpit.ApPanel.vsAdjust(-1);
			}
		});
		me["VsPlus"].addEventListener("click", func(e) {
			if (e.shiftKey) {
				cockpit.ApPanel.vsAdjust(10);
			} else {
				cockpit.ApPanel.vsAdjust(1);
			}
		});
		
		me["VsFpa"].addEventListener("click", func(e) {
			cockpit.ApPanel.vsFpa();
		});
		
		me._update();
		me._dialogUpdate.start();
	},
	_update: func() {
		# Display
		if (systems.ELECTRICAL.Outputs.fcp.getValue() >= 24) {
			if (pts.Controls.Switches.annunTest.getBoolValue()) {
				me["FeetInd"].show();
				me["FpaInd"].show();
				me["HdgInd"].show();
				me["IasInd"].show();
				me["MachInd"].show();
				me["MeterInd"].show();
				me["TrkInd"].show();
				me["VsInd"].show();
				me["Alt_7seg"].setText("88888");
				me["Hdg_7seg"].setText("888");
				me["Spd_7seg"].setText(".888");
				me["Vs_7seg"].setText("-888.8");
			} else {
				# Speed
				if (afs.Output.showSpd.getBoolValue()) {
					if (afs.Input.ktsMach.getBoolValue()) {
						me["IasInd"].hide();
						me["MachInd"].show();
						me["Spd_7seg"].setText("." ~ sprintf("%03d", afs.Input.mach.getValue() * 1000));
					} else {
						me["IasInd"].show();
						me["MachInd"].hide();
						me["Spd_7seg"].setText(sprintf("%03d", afs.Input.kts.getValue()));
					}
				} else {
					if (afs.Input.ktsMach.getBoolValue()) {
						me["IasInd"].hide();
						me["MachInd"].show();
					} else {
						me["IasInd"].show();
						me["MachInd"].hide();
					}
					me["Spd_7seg"].setText("---");
				}
				
				# Heading
				if (afs.Input.trk.getBoolValue()) {
					me["HdgInd"].hide();
					me["TrkInd"].show();
				} else {
					me["HdgInd"].show();
					me["TrkInd"].hide();
				}
				if (afs.Output.showHdg.getBoolValue()) {
					me["Hdg_7seg"].setText(sprintf("%03d", afs.Input.hdg.getValue()));
				} else {
					me["Hdg_7seg"].setText("---");
				}
				
				# Altitude
				me["MeterInd"].hide(); # Unused, so we hide it
				me["Alt_7seg"].setText(sprintf("%03d", afs.Input.alt.getValue()));
				
				# Vertical Speed
				me._vert = afs.Output.vert.getValue();
				if (me._vert == 1 or me._vert == 5) {
					if (afs.Input.vsFpa.getBoolValue()) {
						me["FpaInd"].show();
						me["VsInd"].hide();
						me["Vs_7seg"].setText(sprintf("%2.1f", afs.Input.fpa.getValue()));
					} else {
						me["FpaInd"].hide();
						me["VsInd"].show();
						me["Vs_7seg"].setText(sprintf("%d", afs.Input.vs.getValue()));
					}
				} else {
					if (afs.Input.vsFpa.getBoolValue()) {
						me["FpaInd"].show();
						me["VsInd"].hide();
					} else {
						me["FpaInd"].hide();
						me["VsInd"].show();
					}
					me["Vs_7seg"].setText("----");
				}
			}
			
			me["Display"].show();
		} else {
			me["Display"].hide();
		}
		
		# Bank Limit
		me["BankLimit"].setRotation(afs.Input.bankLimitSw.getValue() * 60 * D2R);
		
		# AFS OVRD
		me["AfsOvrd1"].setTranslation(0, afs.Input.ovrd1.getValue() * 20);
		me["AfsOvrd2"].setTranslation(0, afs.Input.ovrd2.getValue() * 20);
	},
};

var afsDialog = afsCanvas.new();
