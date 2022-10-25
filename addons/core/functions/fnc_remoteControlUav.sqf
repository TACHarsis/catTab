#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_remoteControlUav
	
	Author(s):
		Gundy

	Description:
		Take control of the currently selected UAV's gunner turret
	
	Parameters:
		NONE
 	
	Returns:
		BOOLEAN - TRUE
	
	Example:
		[] call Ctab_ui_fnc_remoteControlUav;
*/

// see if there is a selected UAV and if it is alive before continuing
if (isNil QEGVAR(ui,actUAV) || {!alive EGVAR(ui,actUAV)}) exitWith {false};

// make sure there is noone currently controlling the gunner seat
// unfortunately this fails as soon as there is a driver connected as only one unit is returned using UAVControl and it will alwasys be the driver if present.
// see http://feedback.arma3.com/view.php?id=23693
if (UAVControl EGVAR(ui,actUAV) select 1 != "GUNNER") then {
	// see if there is actually a gunner AI that we can remote control
	private _uavGunner = gunner EGVAR(ui,actUAV);
	if !(isNull _uavGunner) then {
		[] call EFUNC(ui,close);
		player remoteControl _uavGunner;
		EGVAR(ui,actUAV) switchCamera "Gunner";
		EGVAR(ui,uavViewActive) = true;
		// spawn a loop in-case control of the UAV is released elsewhere
		EGVAR(ui,actUAV) spawn {
			waitUntil {(cameraOn != _this) || (!EGVAR(ui,uavViewActive))};
			EGVAR(ui,uavViewActive) = false;
		};
	} else {
		// show notification
		["UAV","No gunner optics available",5] call EFUNC(ui,addNotification);
	};
} else {
	// show notification
	["UAV","Another user has control",5] call EFUNC(ui,addNotification);
};

true
