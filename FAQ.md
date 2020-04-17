# Frequently Asked Questions

## Download

### Q. The download will not extract or is corrupted. Why?

Try to download the aircraft again. The download may have failed for some reason.

### Q. I found other distributors offering downloads of the this aircraft. Can I use them?

Yes, but they may have changes that result in difficulties or issues. You should get the aircraft from [Octal450's repo](https://github.com/Octal450/MD-11.git).

## Startup

### Q. Error Code: 0x121 appears. Why?

This error occurs if you are attempting to use this aircraft on a version of FlightGear that is too old. See [INSTALL.md](https://github.com/Octal450/MD-11/blob/master/INSTALL.md) for more information.

### Q. Error Code: 0x223 appears. Why?

This error occurs when there is an issue with the scenery that prevents initialization, or if you are starting in air.

Starting in air is not possible with this aircraft.

The simulation is so complex that there is no support for starting it in mid-air. Therefore, please make sure that you start it on the ground, powering it up appropriately.

In case that you want to practice landing, it might be better to fly to your destination and by doing it by landing, and performing a missed approach (like real pilots do).

### Q. Error Code: 0x247 appears. Why?

This error most commonly occurs if your download is corrupted, or a serious problem with the aircraft's systems occurs.

This error can also appear if you are starting FlightGear for the very first time with this aircraft. This is a known issue and we are working to correct it. To fix this, simply start FlightGear again at an airport that is in a different scenery file. After this, all airports (including the original one attempted) will work properly.

## Behavior

### Q. I can't control the rudder with my aileron axis after turning on the FlightGear auto coordination system. Why?

This aircraft has a complex and realistic flight control system, which contains a yaw damper and turn coordinator. Therefore, auto coordination is not nessesary and the rudder is only used in the air when de-crabbing during crosswind landings.

When the aircraft detects that auto coordination has been turned on, it enables the aileron drives tiller system. This way, you will be able to control the nose wheel with the aileron axis to steer on the ground. Please use keyboard for rudder functionality.

### Q. Some menu items are greyed out when using this aircraft. Why?

Some functions in the regular menu (like Autopilot) have moved to custom menus. This is due to limitations in the way the default menus can be manipulated to prevent unsupported functionality (ex: Previous/Next Waypoint) from being executed.

Some of the functions may be implemented in custom way and still usable. Check the custom menus to the right of the "|" for these functions.

### Q. Why does the cold and dark state load after exiting replay mode?

The flight recording system does not record the systems or internal functions of the aircraft. Doing so would require recording thousands of properties, and this would likely cause bugs and a performance hit. This means, that after replay, the systems might be in an invalid state. To ensure the aircraft remains functional, we reset the aircraft to cold and dark to reset everything.

## Reporting Issues / Debugging

### Q. Where should I report issues?

Please use our [issues page](https://github.com/Octal450/MD-11/issues/new) to report bugs. Please fill out the template there to the best of your knowledge. Issues submitted with blank templates will be closed.

### Q. I encountered a strange behavior while flying. Should I report a bug?

Yes, please do so! If we do not know about the bugs, there is no-one to fix them. 

### Q. I have a flight recording which shows the problem. Could you please have a look?

It does not make sense sending in flight recordings, as they do not contain enough information. That is why they are more or less useless for us. We do not plan on recording full information in the recorder. See the "Why does the cold and dark state load after exiting replay mode?" section for more information.

Instead, for documenting issues, please perform the steps mentioned in the next question:

### Q. I want to document an issue. What is the right approach doing so?

Besides describing it with words, you may do two things, which helps us reproducing your issue locally such that it can be debugged:

1. Hit the screenshot buttons (hotkey `F3` by default) often and send them all in! Five screenshots with redundant data isn't a problem to sort out, but one screenshot missing out which would have contained vital information may prevent understanding the problem properly.

2. If able you may also dump the property tree. That is also a very helpful source of information. To do so, please open the "Nasal Console" from the "Debug" menu, paste this command, and press "Execute". `io.write_properties(getprop("/sim/fg-home") ~ "/Export/MD-11-dump.xml", "/");` The dumped file will be located in `$FGHOME/Export`.

## Do's and Don'ts

### Q. The current version has a bug, but I still want to keep flying. Can I downgrade?

First of all, did you ensure that the bug is reported on our [issues page](https://github.com/Octal450/MD-11/issues/new)? If not, please do so (see also questions above on how to report them)!

We suggest **never** downgrading your aircraft for the best expirience. If you must do so, **you must** delete your `MD-11-config.xml` file. You may find it in `$FGHOME/Export`.

### Q. I like increasing the simulation speed on long flights. However, I encounter issues with it once in a while. What's up?

Increasing the simulation speed is quite tricky for the simulator. Depending on hardware capabilities it can be very stressful and the algorithms behind the scenes can be challenged quite heavily. If the simulation is running faster than the corresponding algorithms can be computed, many funny (or even ugly things) may happen. **we suggest not setting simulation speed above 4x or below 1/2x at any time**.

Check your frame rate ("View" menu, option "View Options", toggle "Show frame rate") when increasing the simulation speed. As a rule of thumb, if the frame rate stays constantly above 10fps, you are fine. Keep in mind that already one little phase (and not just the average) where the frame rate drops below 10 frames per second, you are in danger facing issues.
