#include "script_component.hpp"

// This is drawn every frame on the tablet helmet cam screen. fnc
params ["_mapCtrl"];

if (isNil QGVAR(helmetCams)) exitWith {};

private _camHost = GVAR(helmetCams) select 2;

private _display = ctrlParent _mapCtrl;
private _pos = getPosASL _camHost;

[_mapCtrl,false] call FUNC(drawUserMarkers);
[_mapCtrl,0] call FUNC(drawBftMarkers);

// draw icon at own location
private _vehicle = vehicle Ctab_player;
_mapCtrl drawIcon [
    "\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa",
    GVAR(mapToolsPlayerVehicleIconColor),
    getPosASL _vehicle,
    GVAR(ownVehicleIconBaseSize),GVAR(ownVehicleIconBaseSize),
    direction _vehicle,"", 1,GVAR(textSize),"TahomaB","right"
];

// draw icon at helmet cam location
_mapCtrl drawIcon [
    "\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa",
    GVAR(miscColor),
    _pos,
    GVAR(ownVehicleIconBaseSize),GVAR(ownVehicleIconBaseSize),
    direction _camHost,"",0,GVAR(textSize),"TahomaB","right"
];

_mapCtrl ctrlMapAnimAdd [0,GVAR(mapScaleHCam),_pos];
ctrlMapAnimCommit _mapCtrl;

true
