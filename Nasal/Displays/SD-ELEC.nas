# McDonnell Douglas MD-11 SD
# Copyright (c) 2026 Josh Davidson (Octal450)

var CanvasElec = {
	new: func(canvasGroup, file) {
		var m = {parents: [CanvasElec, CanvasBase]};
		m.init(canvasGroup, file);
		
		return m;
	},
	getKeys: func() {
		return ["Ac1_box", "Ac1_off", "Ac2_box", "Ac2_off", "Ac3_box", "Ac3_off", "AcGndSvc_box", "AcGndSvc_off", "AcTie1", "AcTie2", "AcTie3", "Adg", "Adg_hz", "Adg_hz_box", "Adg_hz_error", "Adg_volt", "Adg_volt_box", "Adg_volt_error", "Alert_error", "Apu_hz",
		"Apu_hz_box", "Apu_hz_error", "Apu_load", "Apu_load_box", "Apu_load_error", "Apu_volt", "Apu_volt_box", "Apu_volt_error", "ApuGroup", "ApuPwr1", "ApuPwr2", "ApuPwr3", "Bat", "Bat_amp", "Bat_amp_error", "Bat_volt", "Bat_volt_box", "Bat_volt_error",
		"Dc1_box", "Dc1_off", "Dc2_box", "Dc2_off", "Dc3_box", "Dc3_off", "DcGndSvc_box", "DcGndSvc_off", "DcTie1", "DcTie3", "Disc1", "Disc2", "Disc3", "ExtPwr", "ExtPwr_hz", "ExtPwr_hz_box", "ExtPwr_hz_error", "ExtPwr_line", "ExtPwr_volt", "ExtPwr_volt_box",
		"ExtPwr_volt_error", "ExtPwrGroup", "Gen1", "Gen1_hz", "Gen1_hz_box", "Gen1_hz_error", "Gen1_load", "Gen1_load_box", "Gen1_load_error", "Gen1_volt", "Gen1_volt_box", "Gen1_volt_error", "Gen2", "Gen2_hz", "Gen2_hz_box", "Gen2_hz_error", "Gen2_load",
		"Gen2_load_box", "Gen2_load_error", "Gen2_volt", "Gen2_volt_box", "Gen2_volt_error", "Gen3", "Gen3_hz", "Gen3_hz_box", "Gen3_hz_error", "Gen3_load", "Gen3_load_box", "Gen3_load_error", "Gen3_volt", "Gen3_volt_box", "Gen3_volt_error", "GenBus1", "GenBus2",
		"GenBus3", "GlyPwrGroup", "GlyPwr_hz", "GlyPwr_hz_error", "GlyPwr_volt", "GlyPwr_volt_error", "LEmerAc_box", "LEmerAc_off", "LEmerDc_box", "LEmerDc_off", "REmerAc_box", "REmerAc_off", "REmerDc_box", "REmerDc_off", "Tr1_fill", "Tr1_load", "Tr1_load_error",
		"Tr1_stroke", "Tr1_volt", "Tr1_volt_error", "Tr2A_fill", "Tr2A_load", "Tr2A_load_error", "Tr2A_stroke", "Tr2A_volt", "Tr2A_volt_error", "Tr2B_fill", "Tr2B_load", "Tr2B_load_error", "Tr2B_stroke", "Tr2B_volt", "Tr2B_volt_error", "Tr3_fill", "Tr3_load",
		"Tr3_load_error", "Tr3_stroke", "Tr3_volt", "Tr3_volt_error"];
	},
	setup: func() {
		# Hide unimplemented objects
		me["Apu_load_box"].hide();
		me["Apu_hz_box"].hide();
		me["Apu_volt_box"].hide();
		me["ExtPwr_hz_box"].hide();
		me["ExtPwr_volt_box"].hide();
		me["Gen1_load_box"].hide();
		me["Gen2_load_box"].hide();
		me["Gen3_load_box"].hide();
	},
	update: func() {
		Value.Misc.wow = pts.Position.wow.getBoolValue();
		Value.Misc.annunTestWow = pts.Controls.Switches.annunTest.getBoolValue() and Value.Misc.wow;
		
		# Errors, these don't have separate logic yet.
		if (Value.Misc.annunTestWow) {
			me["Adg_hz_error"].show();
			me["Adg_volt_error"].show();
			me["Alert_error"].show();
			me["Apu_hz_error"].show();
			me["Apu_load_error"].show();
			me["Apu_volt_error"].show();
			me["Bat_amp_error"].show();
			me["Bat_volt_error"].show();
			me["ExtPwr_hz_error"].show();
			me["ExtPwr_volt_error"].show();
			me["Gen1_hz_error"].show();
			me["Gen1_load_error"].show();
			me["Gen1_volt_error"].show();
			me["Gen2_hz_error"].show();
			me["Gen2_load_error"].show();
			me["Gen2_volt_error"].show();
			me["Gen3_hz_error"].show();
			me["Gen3_load_error"].show();
			me["Gen3_volt_error"].show();
			me["GlyPwr_hz_error"].show();
			me["GlyPwr_volt_error"].show();
			me["Tr1_load_error"].show();
			me["Tr2A_load_error"].show();
			me["Tr2B_load_error"].show();
			me["Tr3_load_error"].show();
			me["Tr1_volt_error"].show();
			me["Tr2A_volt_error"].show();
			me["Tr2B_volt_error"].show();
			me["Tr3_volt_error"].show();
		} else {
			me["Adg_hz_error"].hide();
			me["Adg_volt_error"].hide();
			me["Alert_error"].hide();
			me["Apu_hz_error"].hide();
			me["Apu_load_error"].hide();
			me["Apu_volt_error"].hide();
			me["Bat_amp_error"].hide();
			me["Bat_volt_error"].hide();
			me["ExtPwr_hz_error"].hide();
			me["ExtPwr_volt_error"].hide();
			me["Gen1_hz_error"].hide();
			me["Gen1_load_error"].hide();
			me["Gen1_volt_error"].hide();
			me["Gen2_hz_error"].hide();
			me["Gen2_load_error"].hide();
			me["Gen2_volt_error"].hide();
			me["Gen3_hz_error"].hide();
			me["Gen3_load_error"].hide();
			me["Gen3_volt_error"].hide();
			me["GlyPwr_hz_error"].hide();
			me["GlyPwr_volt_error"].hide();
			me["Tr1_load_error"].hide();
			me["Tr2A_load_error"].hide();
			me["Tr2B_load_error"].hide();
			me["Tr3_load_error"].hide();
			me["Tr1_volt_error"].hide();
			me["Tr2A_volt_error"].hide();
			me["Tr2B_volt_error"].hide();
			me["Tr3_volt_error"].hide();
		}
		
		# Battery
		Value.Elec.Bus.dcBatDirect = math.round(systems.ELECTRICAL.Bus.dcBatDirect.getValue());
		me["Bat_volt"].setText(sprintf("%d", Value.Elec.Bus.dcBatDirect));
		
		if (Value.Elec.Bus.dcBatDirect < 22) {
			me["Bat"].setColor(0.9412, 0.7255, 0);
			me["Bat_volt"].setColor(0.9412, 0.7255, 0);
			me["Bat_volt_box"].show();
		} else {
			if (systems.ELECTRICAL.Rcb.dcBatLEmerDc.getBoolValue() or systems.ELECTRICAL.Relay.siLEmerAc.getBoolValue()) {
				me["Bat"].setColor(0, 1, 0);
				
				me["Bat_amp"].setText(sprintf("%d", math.round(math.max(systems.ELECTRICAL.Source.Bat1.amp.getValue(), systems.ELECTRICAL.Source.Bat2.amp.getValue()))));
				me["Bat_amp"].show();
			} else {
				me["Bat"].setColor(1, 1, 1);
				me["Bat_amp"].hide();
			}
			
			me["Bat_volt"].setColor(1, 1, 1);
			me["Bat_volt_box"].hide();
		}
		
		# Busses
		if (systems.ELECTRICAL.Lights.lEmerDc.getBoolValue()) {
			me["LEmerDc_box"].setColor(0.9412, 0.7255, 0);
			me["LEmerDc_off"].show();
		} else {
			me["LEmerDc_box"].setColor(0, 1, 0);
			me["LEmerDc_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.dc1.getBoolValue()) {
			me["Dc1_box"].setColor(0.9412, 0.7255, 0);
			me["Dc1_off"].show();
		} else {
			me["Dc1_box"].setColor(0, 1, 0);
			me["Dc1_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.dc2.getBoolValue()) {
			me["Dc2_box"].setColor(0.9412, 0.7255, 0);
			me["Dc2_off"].show();
		} else {
			me["Dc2_box"].setColor(0, 1, 0);
			me["Dc2_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.dcGndSvc.getBoolValue()) {
			me["DcGndSvc_box"].setColor(0.9412, 0.7255, 0);
			me["DcGndSvc_off"].show();
		} else {
			me["DcGndSvc_box"].setColor(0, 1, 0);
			me["DcGndSvc_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.dc3.getBoolValue()) {
			me["Dc3_box"].setColor(0.9412, 0.7255, 0);
			me["Dc3_off"].show();
		} else {
			me["Dc3_box"].setColor(0, 1, 0);
			me["Dc3_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.rEmerDc.getBoolValue()) {
			me["REmerDc_box"].setColor(0.9412, 0.7255, 0);
			me["REmerDc_off"].show();
		} else {
			me["REmerDc_box"].setColor(0, 1, 0);
			me["REmerDc_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.lEmerAc.getBoolValue()) {
			me["LEmerAc_box"].setColor(0.9412, 0.7255, 0);
			me["LEmerAc_off"].show();
		} else {
			me["LEmerAc_box"].setColor(0, 1, 0);
			me["LEmerAc_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.ac1.getBoolValue()) {
			me["Ac1_box"].setColor(0.9412, 0.7255, 0);
			me["Ac1_off"].show();
		} else {
			me["Ac1_box"].setColor(0, 1, 0);
			me["Ac1_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.ac2.getBoolValue()) {
			me["Ac2_box"].setColor(0.9412, 0.7255, 0);
			me["Ac2_off"].show();
		} else {
			me["Ac2_box"].setColor(0, 1, 0);
			me["Ac2_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.acGndSvc.getBoolValue()) {
			me["AcGndSvc_box"].setColor(0.9412, 0.7255, 0);
			me["AcGndSvc_off"].show();
		} else {
			me["AcGndSvc_box"].setColor(0, 1, 0);
			me["AcGndSvc_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.ac3.getBoolValue()) {
			me["Ac3_box"].setColor(0.9412, 0.7255, 0);
			me["Ac3_off"].show();
		} else {
			me["Ac3_box"].setColor(0, 1, 0);
			me["Ac3_off"].hide();
		}
		
		if (systems.ELECTRICAL.Lights.rEmerAc.getBoolValue()) {
			me["REmerAc_box"].setColor(0.9412, 0.7255, 0);
			me["REmerAc_off"].show();
		} else {
			me["REmerAc_box"].setColor(0, 1, 0);
			me["REmerAc_off"].hide();
		}
		
		# TR's
		me["Tr1_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Tr1.volt.getValue())));
		me["Tr2A_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Tr2a.volt.getValue())));
		me["Tr2B_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Tr2b.volt.getValue())));
		me["Tr3_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Tr3.volt.getValue())));
		
		if (systems.ELECTRICAL.Failures.tr1.getBoolValue()) {
			me["Tr1_fill"].setColor(0.9412, 0.7255, 0);
			me["Tr1_fill"].setColorFill(0.9412, 0.7255, 0);
			me["Tr1_stroke"].setColor(0.9412, 0.7255, 0);
		} else {
			me["Tr1_fill"].setColor(1, 1, 1);
			me["Tr1_fill"].setColorFill(1, 1, 1);
			me["Tr1_stroke"].setColor(1, 1, 1);
		}
		
		if (systems.ELECTRICAL.Failures.tr2a.getBoolValue()) {
			me["Tr2A_fill"].setColor(0.9412, 0.7255, 0);
			me["Tr2A_fill"].setColorFill(0.9412, 0.7255, 0);
			me["Tr2A_stroke"].setColor(0.9412, 0.7255, 0);
		} else {
			me["Tr2A_fill"].setColor(1, 1, 1);
			me["Tr2A_fill"].setColorFill(1, 1, 1);
			me["Tr2A_stroke"].setColor(1, 1, 1);
		}
		
		if (systems.ELECTRICAL.Failures.tr2b.getBoolValue()) {
			me["Tr2B_fill"].setColor(0.9412, 0.7255, 0);
			me["Tr2B_fill"].setColorFill(0.9412, 0.7255, 0);
			me["Tr2B_stroke"].setColor(0.9412, 0.7255, 0);
		} else {
			me["Tr2B_fill"].setColor(1, 1, 1);
			me["Tr2B_fill"].setColorFill(1, 1, 1);
			me["Tr2B_stroke"].setColor(1, 1, 1);
		}
		
		if (systems.ELECTRICAL.Failures.tr3.getBoolValue()) {
			me["Tr3_fill"].setColor(0.9412, 0.7255, 0);
			me["Tr3_fill"].setColorFill(0.9412, 0.7255, 0);
			me["Tr3_stroke"].setColor(0.9412, 0.7255, 0);
		} else {
			me["Tr3_fill"].setColor(1, 1, 1);
			me["Tr3_fill"].setColorFill(1, 1, 1);
			me["Tr3_stroke"].setColor(1, 1, 1);
		}
		
		# Relays/RCBs
		Value.Elec.Relay.idgAcGen1 = systems.ELECTRICAL.Relay.idgAcGen1.getBoolValue();
		Value.Elec.Relay.idgAcGen2 = systems.ELECTRICAL.Relay.idgAcGen2.getBoolValue();
		Value.Elec.Relay.idgAcGen3 = systems.ELECTRICAL.Relay.idgAcGen3.getBoolValue();
		
		if (systems.ELECTRICAL.Rcb.dcTieDc1.getBoolValue()) {
			me["DcTie1"].setColor(0, 1, 0);
			me["DcTie1"].setTranslation(0, 10);
		} else {
			me["DcTie1"].setColor(1, 1, 1);
			me["DcTie1"].setTranslation(0, 0);
		}
		
		if (systems.ELECTRICAL.Rcb.dcTieDc3.getBoolValue()) {
			me["DcTie3"].setColor(0, 1, 0);
			me["DcTie3"].setTranslation(0, 10);
		} else {
			me["DcTie3"].setColor(1, 1, 1);
			me["DcTie3"].setTranslation(0, 0);
		}
		
		if (systems.ELECTRICAL.Relay.acTieAcGen1.getBoolValue()) {
			me["AcTie1"].setColor(0, 1, 0);
			me["AcTie1"].setTranslation(10, 0);
		} else {
			me["AcTie1"].setColor(1, 1, 1);
			me["AcTie1"].setTranslation(0, 0);
		}
		
		if (systems.ELECTRICAL.Relay.acTieAcGen2.getBoolValue()) {
			me["AcTie2"].setColor(0, 1, 0);
			me["AcTie2"].setTranslation(10, 0);
		} else {
			me["AcTie2"].setColor(1, 1, 1);
			me["AcTie2"].setTranslation(0, 0);
		}
		
		if (systems.ELECTRICAL.Relay.acTieAcGen3.getBoolValue()) {
			me["AcTie3"].setColor(0, 1, 0);
			me["AcTie3"].setTranslation(10, 0);
		} else {
			me["AcTie3"].setColor(1, 1, 1);
			me["AcTie3"].setTranslation(0, 0);
		}
		
		if (Value.Elec.Relay.idgAcGen1) {
			me["GenBus1"].setColor(0, 1, 0);
			me["GenBus1"].setTranslation(10, 0);
		} else {
			me["GenBus1"].setColor(1, 1, 1);
			me["GenBus1"].setTranslation(0, 0);
		}
		
		if (Value.Elec.Relay.idgAcGen2) {
			me["GenBus2"].setColor(0, 1, 0);
			me["GenBus2"].setTranslation(10, 0);
		} else {
			me["GenBus2"].setColor(1, 1, 1);
			me["GenBus2"].setTranslation(0, 0);
		}
		
		if (Value.Elec.Relay.idgAcGen3) {
			me["GenBus3"].setColor(0, 1, 0);
			me["GenBus3"].setTranslation(10, 0);
		} else {
			me["GenBus3"].setColor(1, 1, 1);
			me["GenBus3"].setTranslation(0, 0);
		}
		
		# IDG's
		me["Gen1_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Idg1.outputVolt.getValue())));
		me["Gen1_hz"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Idg1.outputHertz.getValue())));
		
		me["Gen2_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Idg2.outputVolt.getValue())));
		me["Gen2_hz"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Idg2.outputHertz.getValue())));
		
		me["Gen3_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Idg3.outputVolt.getValue())));
		me["Gen3_hz"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Idg3.outputHertz.getValue())));
		
		if (systems.ELECTRICAL.Failures.gen1.getBoolValue()) {
			me["Disc1"].setText("FAULT");
			me["Disc1"].show();
			
			me["Gen1"].setColor(0.9412, 0.7255, 0);
			me["Gen1_hz"].setColor(0.9412, 0.7255, 0);
			me["Gen1_hz_box"].show();
			me["Gen1_volt"].setColor(0.9412, 0.7255, 0);
			me["Gen1_volt_box"].show();
		} else {
			if (!systems.ELECTRICAL.Controls.genDrive1.getBoolValue()) {
				me["Disc1"].setText("DISC");
				me["Disc1"].show();
			} else {
				me["Disc1"].hide();
			}
			
			if (Value.Elec.Relay.idgAcGen1) {
				me["Gen1"].setColor(0, 1, 0);
			} else {
				me["Gen1"].setColor(1, 1, 1);
			}
			
			me["Gen1_hz"].setColor(1, 1, 1);
			me["Gen1_hz_box"].hide();
			me["Gen1_volt"].setColor(1, 1, 1);
			me["Gen1_volt_box"].hide();
		}
		
		if (systems.ELECTRICAL.Failures.gen2.getBoolValue()) {
			me["Disc2"].setText("FAULT");
			me["Disc2"].show();
			
			me["Gen2"].setColor(0.9412, 0.7255, 0);
			me["Gen2_hz"].setColor(0.9412, 0.7255, 0);
			me["Gen2_hz_box"].show();
			me["Gen2_volt"].setColor(0.9412, 0.7255, 0);
			me["Gen2_volt_box"].show();
		} else {
			if (!systems.ELECTRICAL.Controls.genDrive2.getBoolValue()) {
				me["Disc2"].setText("DISC");
				me["Disc2"].show();
			} else {
				me["Disc2"].hide();
			}
			
			if (Value.Elec.Relay.idgAcGen2) {
				me["Gen2"].setColor(0, 1, 0);
			} else {
				me["Gen2"].setColor(1, 1, 1);
			}
			
			me["Gen2_hz"].setColor(1, 1, 1);
			me["Gen2_hz_box"].hide();
			me["Gen2_volt"].setColor(1, 1, 1);
			me["Gen2_volt_box"].hide();
		}
		
		if (systems.ELECTRICAL.Failures.gen3.getBoolValue()) {
			me["Disc3"].setText("FAULT");
			me["Disc3"].show();
			
			me["Gen3"].setColor(0.9412, 0.7255, 0);
			me["Gen3_hz"].setColor(0.9412, 0.7255, 0);
			me["Gen3_hz_box"].show();
			me["Gen3_volt"].setColor(0.9412, 0.7255, 0);
			me["Gen3_volt_box"].show();
		} else {
			if (!systems.ELECTRICAL.Controls.genDrive3.getBoolValue()) {
				me["Disc3"].setText("DISC");
				me["Disc3"].show();
			} else {
				me["Disc3"].hide();
			}
			
			if (Value.Elec.Relay.idgAcGen3) {
				me["Gen3"].setColor(0, 1, 0);
			} else {
				me["Gen3"].setColor(1, 1, 1);
			}
			
			me["Gen3_hz"].setColor(1, 1, 1);
			me["Gen3_hz_box"].hide();
			me["Gen3_volt"].setColor(1, 1, 1);
			me["Gen3_volt_box"].hide();
		}
		
		# APU
		if (systems.APU.n2.getValue() >= 95) {
			me["Apu_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Apu.outputVolt.getValue())));
			me["Apu_hz"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Apu.outputHertz.getValue())));
			
			if (systems.ELECTRICAL.Relay.apuAcGen1.getBoolValue()) {
				me["ApuPwr1"].setColor(0, 1, 0);
			} else {
				me["ApuPwr1"].setColor(1, 1, 1);
			}
			
			if (systems.ELECTRICAL.Relay.apuAcGen2.getBoolValue()) {
				me["ApuPwr2"].setColor(0, 1, 0);
			} else {
				me["ApuPwr2"].setColor(1, 1, 1);
			}
			
			if (systems.ELECTRICAL.Relay.apuAcGen3.getBoolValue()) {
				me["ApuPwr3"].setColor(0, 1, 0);
			} else {
				me["ApuPwr3"].setColor(1, 1, 1);
			}
			
			me["ApuGroup"].show();
		} else {
			me["ApuGroup"].hide();
		}
		
		# EXT PWR and EXT GLY PWR
		if (systems.ELECTRICAL.Controls.groundCart.getBoolValue()) {
			me["ExtPwr_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Ext.volt.getValue())));
			me["ExtPwr_hz"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Ext.hertz.getValue())));
			me["GlyPwr_volt"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Ext.voltGalley.getValue())));
			me["GlyPwr_hz"].setText(sprintf("%d", math.round(systems.ELECTRICAL.Source.Ext.hertzGalley.getValue())));
			
			if (systems.ELECTRICAL.Relay.extAcTie.getBoolValue()) {
				me["ExtPwr"].setColor(0, 1, 0);
			} else {
				me["ExtPwr"].setColor(1, 1, 1);
			}
			
			me["ExtPwrGroup"].show();
			me["GlyPwrGroup"].show();
		} else {
			me["ExtPwrGroup"].hide();
			me["GlyPwrGroup"].hide();
		}
		
		# ADG
		if (pts.Controls.Switches.adgHandle.getValue() == 1) {
			me["Adg"].setColor(0, 1, 0);
			
			Value.Elec.Source.adgHertz = math.round(systems.ELECTRICAL.Source.Adg.hertz.getValue());
			Value.Elec.Source.adgVolt = math.round(systems.ELECTRICAL.Source.Adg.volt.getValue());
			
			me["Adg_volt"].setText(sprintf("%d", Value.Elec.Source.adgVolt));
			me["Adg_volt"].show();
			me["Adg_hz"].setText(sprintf("%d", Value.Elec.Source.adgHertz));
			me["Adg_hz"].show();
			
			if (Value.Elec.Source.adgVolt < 112 or Value.Elec.Source.adgVolt > 118) {
				me["Adg_volt"].setColor(0.9412, 0.7255, 0);
				me["Adg_volt_box"].show();
			} else {
				me["Adg_volt"].setColor(1, 1, 1);
				me["Adg_volt_box"].hide();
			}
			if (Value.Elec.Source.adgHertz < 396 or Value.Elec.Source.adgHertz > 404) {
				me["Adg_hz"].setColor(0.9412, 0.7255, 0);
				me["Adg_hz_box"].show();
			} else {
				me["Adg_hz"].setColor(1, 1, 1);
				me["Adg_hz_box"].hide();
			}
		} else {
			me["Adg"].setColor(1, 1, 1);
			me["Adg_hz"].hide();
			me["Adg_hz_box"].hide();
			me["Adg_volt"].hide();
			me["Adg_volt_box"].hide();
		}
	},
};
