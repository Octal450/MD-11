# McDonnell Douglas MD-11 IRS
# Copyright (c) 2025 Josh Davidson (Octal450)

var IRS = {
	setHdg: 1,
	Iru: {
		aligned: [props.globals.getNode("/systems/iru[0]/aligned"), props.globals.getNode("/systems/iru[1]/aligned"), props.globals.getNode("/systems/iru[2]/aligned")],
		aligning: [props.globals.getNode("/systems/iru[0]/aligning"), props.globals.getNode("/systems/iru[1]/aligning"), props.globals.getNode("/systems/iru[2]/aligning")],
		alignMcduMsgOut: [props.globals.getNode("/systems/iru[0]/align-mcdu-msg-out"), props.globals.getNode("/systems/iru[1]/align-mcdu-msg-out"), props.globals.getNode("/systems/iru[2]/align-mcdu-msg-out")],
		alignTimer: [props.globals.getNode("/systems/iru[0]/align-timer"), props.globals.getNode("/systems/iru[1]/align-timer"), props.globals.getNode("/systems/iru[2]/align-timer")],
		alignTimeRemainingMinutes: [props.globals.getNode("/systems/iru[0]/align-time-remaining-minutes"), props.globals.getNode("/systems/iru[1]/align-time-remaining-minutes"), props.globals.getNode("/systems/iru[2]/align-time-remaining-minutes")],
		allAligned: props.globals.getNode("/systems/iru-common/all-aligned-out"),
		anyAligned: props.globals.getNode("/systems/iru-common/any-aligned-out"),
		attAvail: [props.globals.getNode("/systems/iru[0]/att-avail"), props.globals.getNode("/systems/iru[1]/att-avail"), props.globals.getNode("/systems/iru[2]/att-avail")],
		mainAvail: [props.globals.getNode("/systems/iru[0]/main-avail"), props.globals.getNode("/systems/iru[1]/main-avail"), props.globals.getNode("/systems/iru[2]/main-avail")],
	},
	Controls: {
		knob: [props.globals.getNode("/controls/iru[0]/knob"), props.globals.getNode("/controls/iru[1]/knob"), props.globals.getNode("/controls/iru[2]/knob")],
		mcduBtn: props.globals.getNode("/controls/iru-common/mcdu-btn"),
	},
	init: func() {
		me.Controls.knob[0].setBoolValue(0);
		me.Controls.knob[1].setBoolValue(0);
		me.Controls.knob[2].setBoolValue(0);
		me.Controls.mcduBtn.setBoolValue(0);
	},
	anyAlignedUpdate: func() { # Called when the logical OR of the 3 aligned changes
		if (!me.Iru.aligned[0].getBoolValue() and !me.Iru.aligned[1].getBoolValue() and !me.Iru.aligned[2].getBoolValue()) {
			me.setHdg = 1;
		}
		if ((me.Iru.aligned[0].getBoolValue() or me.Iru.aligned[1].getBoolValue() or me.Iru.aligned[2].getBoolValue()) and me.setHdg) {
			me.setHdg = 0;
			afs.ITAF.syncHdg();
		}
	},
	mcduMsgUpdate: func() {
		if (me.Iru.alignMcduMsgOut[0].getBoolValue() or me.Iru.alignMcduMsgOut[1].getBoolValue() or me.Iru.alignMcduMsgOut[2].getBoolValue()) {
			if (IRS.Controls.mcduBtn.getBoolValue()) {
				mcdu.BASE.removeGlobalMessage("ALIGN IRS");
			} else {
				mcdu.BASE.setGlobalMessage("ALIGN IRS");
			}
		} else {
			mcdu.BASE.removeGlobalMessage("ALIGN IRS");
		}
	},
};

# IRS MCDU Messages Logic
setlistener("/systems/iru-common/any-aligned-out", func() {
	IRS.anyAlignedUpdate();
}, 0, 0);
setlistener("/systems/iru[0]/align-mcdu-msg-out", func() {
	IRS.mcduMsgUpdate();
}, 0, 0);
setlistener("/systems/iru[1]/align-mcdu-msg-out", func() {
	IRS.mcduMsgUpdate();
}, 0, 0);
setlistener("/systems/iru[2]/align-mcdu-msg-out", func() {
	IRS.mcduMsgUpdate();
}, 0, 0);
setlistener("/controls/iru-common/mcdu-btn", func() {
	IRS.mcduMsgUpdate();
}, 0, 0);
