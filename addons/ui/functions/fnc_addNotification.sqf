#include "script_component.hpp"
/*
 * Author: Gundy
 *
 * Description:
 *   Add a notification
 *
 * Arguments:
 *   0: App ID <STRING>
 *   1: Notification <STRING>
 *   2: Decay time in seconds <INTEGER>
 *
 * Return Value:
 *   TRUE <BOOL>
 *
 * Example:
 *   [_appID,"This is a notification",5] call Ctab_ui_fnc_addNotification;
 *
 * Public: No
 */

params ["_appID","_notification",["_decayTime", 5,[0]]];

private _time = [] call EFUNC(core,currentTime);
private _done = false;

// search for other _appID notifications
{
	// if we find one, override it and increase the counter
	if ((_x select 0) isEqualTo _appID) exitWith {
		GVAR(notificationCache) set [_forEachIndex,[_appID,_time,_notification,_decayTime,(_x select 4) + 1]];
		_done = true;
	};
} forEach GVAR(notificationCache);

// if we haven't added the notification to the cache above, do it now
if !(_done) then {
	GVAR(notificationCache) pushBack [_appID,_time,_notification,_decayTime,1];
};

[] call FUNC(processNotifications);

true
