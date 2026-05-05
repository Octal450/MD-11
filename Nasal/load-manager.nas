# McDonnell Douglas MD-11 Load Manager
# Copyright (c) 2026 Josh Davidson (Octal450)

var LoadManager = {
	defaultFuel: 0,
	defaultWeight: [0, 0, 0, 0, 0, 0],
	Fuel: {
		tank: [props.globals.getNode("/systems/load-manager/fuel/tank[0]"), props.globals.getNode("/systems/load-manager/fuel/tank[1]"), props.globals.getNode("/systems/load-manager/fuel/tank[2]"), props.globals.getNode("/systems/load-manager/fuel/tank[3]"), props.globals.getNode("/systems/load-manager/fuel/tank[4]"), props.globals.getNode("/systems/load-manager/fuel/tank[5]"), props.globals.getNode("/systems/load-manager/fuel/tank[6]"), props.globals.getNode("/systems/load-manager/fuel/tank[7]")],
	},
	freighter: pts.Options.freighter.getBoolValue(),
	pax: [props.globals.getNode("/systems/load-manager/pax[0]"), props.globals.getNode("/systems/load-manager/pax[1]"), props.globals.getNode("/systems/load-manager/pax[2]")],
	tankCapacity: [props.globals.getNode("/systems/load-manager/tank-capacity[0]"), props.globals.getNode("/systems/load-manager/tank-capacity[1]"), props.globals.getNode("/systems/load-manager/tank-capacity[2]"), props.globals.getNode("/systems/load-manager/tank-capacity[3]"), props.globals.getNode("/systems/load-manager/tank-capacity[4]"), props.globals.getNode("/systems/load-manager/tank-capacity[5]"), props.globals.getNode("/systems/load-manager/tank-capacity[6]"), props.globals.getNode("/systems/load-manager/tank-capacity[7]")],
	totalFuel: props.globals.getNode("/systems/load-manager/total-fuel"),
	weightF: [props.globals.getNode("/systems/load-manager/weight-f[0]"), props.globals.getNode("/systems/load-manager/weight-f[1]"), props.globals.getNode("/systems/load-manager/weight-f[2]"), props.globals.getNode("/systems/load-manager/weight[3]"), props.globals.getNode("/systems/load-manager/weight[4]"), props.globals.getNode("/systems/load-manager/weight[5]")],
	weightP: [props.globals.getNode("/systems/load-manager/weight-p[0]"), props.globals.getNode("/systems/load-manager/weight-p[1]"), props.globals.getNode("/systems/load-manager/weight-p[2]"), props.globals.getNode("/systems/load-manager/weight[3]"), props.globals.getNode("/systems/load-manager/weight[4]"), props.globals.getNode("/systems/load-manager/weight[5]")],
	init: func() {
		me.getCapacities();
		me.getDefault();
		me.getLoad();
	},
	getCapacities: func() {
		for (var i = 0; i < 8; i = i + 1) {
			me.tankCapacity[i].setValue(math.round(pts.Consumables.Fuel.Tank.capacityGalUs[i].getValue() * pts.Consumables.Fuel.Tank.densityPpg[i].getValue()));
		}
	},
	getDefault: func() {
		me.defaultFuel = math.round(pts.Consumables.Fuel.totalFuelActual.getValue(), 100);
		
		for (var i = 0; i < 6; i = i + 1) {
			me.defaultWeight[i] = math.round(pts.Payload.Weight.weightLb[i].getValue(), 100);
		}
	},
	getLoad: func() {
		me.totalFuel.setValue(math.round(pts.Consumables.Fuel.totalFuelActual.getValue(), 100));
		
		for (var i = 0; i < 6; i = i + 1) {
			if (me.freighter) {
				me.weightF[i].setValue(math.round(pts.Payload.Weight.weightLb[i].getValue(), 100));
			} else {
				me.weightP[i].setValue(math.round(pts.Payload.Weight.weightLb[i].getValue(), 100));
			}
		}
	},
	openDialog: func(t = 0) {
		if (t and getprop("/devices/status/keyboard/shift")) {
			gui.showWeightDialog();
		} else {
			fgcommand("dialog-show", props.Node.new({"dialog-name": "load-manager"}));
		}
	},
	setDefault: func() {
		me.totalFuel.setValue(me.defaultFuel);
		
		for (var i = 0; i < 6; i = i + 1) {
			if (me.freighter) {
				me.weightF[i].setValue(me.defaultWeight[i]);
			} else {
				me.weightP[i].setValue(me.defaultWeight[i]);
			}
		}
	},
	setLoad: func() {
		if (!pts.Position.wow.getBoolValue() and pts.Payload.Armament.msg.getBoolValue()) {
			gui.popupTip("Load Manager usage is not allowed when airborne with OPRF damage enabled.");
			return;
		}
		
		settimer(func() {
			for (var i = 0; i < 8; i = i + 1) {
				pts.Consumables.Fuel.Tank.levelLbs[i].setValue(me.Fuel.tank[i].getValue());
			}
			
			for (var i = 0; i < 6; i = i + 1) {
				if (me.freighter) {
					pts.Payload.Weight.weightLb[i].setValue(math.round(me.weightF[i].getValue(), 100));
				} else {
					pts.Payload.Weight.weightLb[i].setValue(math.round(me.weightP[i].getValue(), 100));
				}
			}
			
			gui.popupTip("Load Manager: Fuel and payload have been applied to the aircraft!");
		}, 0.1); # Make sure the JSBSim side has refreshed
	},
	updatePax: func(n) {
		me.pax[n].setValue(math.round(me.weightP[n].getValue() / 150));
	},
};

gui.menuBind("fuel-and-payload", "core.LoadManager.openDialog(1)");

setlistener("/systems/load-manager/weight-p[0]", func() {
	LoadManager.updatePax(0);
}, 0, 0);
setlistener("/systems/load-manager/weight-p[1]", func() {
	LoadManager.updatePax(1);
}, 0, 0);
setlistener("/systems/load-manager/weight-p[2]", func() {
	LoadManager.updatePax(2);
}, 0, 0);
