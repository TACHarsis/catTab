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

//TODO: move to core?

// see if there is a selected UAV and if it is alive before continuing
if (isNil QGVAR(currentUAV) || {!alive GVAR(currentUAV)}) exitWith {false};

// make sure there is noone currently controlling the gunner seat
// unfortunately this fails as soon as there is a driver connected as only one unit is returned using UAVControl and it will alwasys be the driver if present.
// see http://feedback.arma3.com/view.php?id=23693
if (UAVControl GVAR(currentUAV) select 1 != "GUNNER") then {
    // see if there is actually a gunner AI that we can remote control
    private _uavGunner = gunner GVAR(currentUAV);
    if !(isNull _uavGunner) then {
        player remoteControl _uavGunner;
        [] call FUNC(close);
        GVAR(currentUAV) switchCamera "Gunner";
        GVAR(uavViewActive) = true;
        // spawn a loop in-case control of the UAV is released elsewhere
        [
            { (cameraOn != _this) || (!GVAR(uavViewActive)) },
            { GVAR(uavViewActive) = false; },
            GVAR(currentUAV)
        ] call CBA_fnc_waitUntilAndExecute;

        [QGVAR(remoteControlStarted)] call CBA_fnc_localEvent;
        
    } else {
        // maybe send error code instead of message?
        [QGVAR(remoteControlFailed), "No gunner optics available"] call CBA_fnc_localEvent;
    };
} else {
    // maybe send error code instead of message?
    [QGVAR(remoteControlFailed), "Another user has control"] call CBA_fnc_localEvent;
};

true
