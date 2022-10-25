#include "script_component.hpp"
/*
 * Author: Gundy
 *
 * Description:
 *   Process cached notifications
 *
 * Arguments:
 *   NONE
 *
 * Return Value:
 *   TRUE <BOOL>
 *
 * Example:
 *   [] call cTab_devices_processNotifications;
 *
 * Public: No
 */

#include "..\devices\shared\cTab_gui_macros.hpp"

disableSerialization;

// make sure there is no PFH already, the interface is open and notifications are available
if (isNil QGVAR(processNotificationsPFH) && !(isNil QGVAR(ifOpen)) && count GVAR(notificationCache) != 0) then {
	private _displayName = GVAR(ifOpen) select 1;
	private _display = uiNamespace getVariable _displayName;
	private _ctrl = _display displayCtrl IDC_CTAB_NOTIFICATION;
	
	// only proceed if there is a notification control
	if !(isNull _ctrl) then {
		// run every 4 seconds
		GVAR(processNotificationsPFH) = [{
			if !(isNil QGVAR(ifOpen)) then {
				if (count GVAR(notificationCache) != 0) then {
					// grab and delete the oldest notification
					private _notification = GVAR(notificationCache) deleteAt 0;
					private _decayTime = _notification select 3;
					private _currentTime = [] call EFUNC(core,currentTime);
					// see if notification was issued in the same minute, if so, omit showing the time
					private _text = if (_currentTime isEqualTo (_notification select 1)) then {
						format ["%1",_notification select 2]
					} else {
						format ["%1: %2",_notification select 1,_notification select 2]
					};
					// if the counter on the notification is greater than 1, append the counter to the notification text
					if ((_notification select 4) > 1) then {
						_text = format ["%1 (x%2)",_text,_notification select 4];
					};
					
					// show the notification
					private _ctrl = _this select 0;
					_ctrl ctrlSetText _text;
					// make the control visible (it might have had its fade set to 1 before)
					_ctrl ctrlSetFade 0;
					_ctrl ctrlCommit 0;
					_ctrl ctrlShow true;
					
					// bring the control to the front. Enable is required before focus can be set
					_ctrl ctrlEnable true;
					ctrlSetFocus _ctrl;
					_ctrl ctrlEnable false;
					
					// make the control fade out
					_ctrl ctrlSetFade 1;
					_ctrl ctrlCommit _decayTime;
				} else {
					[_this select 1] call CBA_fnc_removePerFrameHandler;
					_ctrl ctrlShow false;
					GVAR(processNotificationsPFH) = nil;
				};
			} else {
				[_this select 1] call CBA_fnc_removePerFrameHandler;
				GVAR(processNotificationsPFH) = nil;
			};
		},4,_ctrl] call CBA_fnc_addPerFrameHandler;
	};
};

true
