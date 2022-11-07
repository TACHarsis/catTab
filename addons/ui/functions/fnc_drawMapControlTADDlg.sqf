#include "script_component.hpp"

// This is drawn every frame on the TAD dialog. fnc
params ["_ctrlScreen"];

// is disableSerialization really required? If so, not sure this is the right place to call it
disableSerialization;

private _display = ctrlParent _ctrlScreen;

GVAR(mapWorldPos) = [_ctrlScreen] call FUNC(ctrlMapCenter);
GVAR(mapScale) = ctrlMapScale _ctrlScreen;

[_ctrlScreen,true] call FUNC(drawUserMarkers);
[_ctrlScreen,1] call FUNC(drawBftMarkers);

// draw vehicle icon at own location
private _veh = vehicle Ctab_player;
private _playerPos = getPosASL _veh;
private _heading = direction _veh;
_ctrlScreen drawIcon [
    GVAR(playerVehicleIcon),
    GVAR(TADOwnIconColor),
    _playerPos,
    GVAR(ownVehicleIconScaledSize),GVAR(ownVehicleIconScaledSize),
    _heading,"", 1,GVAR(textSize),"TahomaB","right"
];

// update hook information
if (GVAR(drawMapTools)) then {
    [_display,_ctrlScreen,_playerPos,GVAR(mapCursorPos),0,true] call FUNC(drawHook);
} else {
    [_display,_ctrlScreen,_playerPos,GVAR(mapCursorPos),1,true] call FUNC(drawHook);
};


true
