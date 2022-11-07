#include "script_component.hpp"

// This is drawn every frame on the tablet uav screen. fnc
params ["_ctrlScreen"];

if (isNil QGVAR(actUAV)) exitWith {};
if (GVAR(actUAV) == player) exitWith {};

private _display = ctrlParent _ctrlScreen;
private _pos = getPosASL GVAR(actUAV);

[_ctrlScreen,false] call FUNC(drawUserMarkers);
[_ctrlScreen,0] call FUNC(drawBftMarkers);

// draw icon at own location
private _veh = vehicle Ctab_player;
_ctrlScreen drawIcon [
    "\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa",
    GVAR(mapToolsPlayerVehicleIconColor),
    getPosASL _veh,
    GVAR(ownVehicleIconBaseSize),GVAR(ownVehicleIconBaseSize),
    direction _veh,"", 1,GVAR(textSize),"TahomaB","right"
];

// draw icon at UAV location
_ctrlScreen drawIcon [
    "\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa"
    ,GVAR(miscColor),
    _pos,
    GVAR(ownVehicleIconBaseSize),GVAR(ownVehicleIconBaseSize),
    direction GVAR(actUAV),"",0,GVAR(textSize),"TahomaB","right"
];

_ctrlScreen ctrlMapAnimAdd [0,GVAR(mapScaleUAV),_pos];
ctrlMapAnimCommit _ctrlScreen;

true
