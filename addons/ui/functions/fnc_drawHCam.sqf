#include "script_component.hpp"

// This is drawn every frame on the tablet helmet cam screen. fnc
params ["_ctrlScreen"];

if (isNil QGVAR(hCams)) exitWith {};

private _camHost = GVAR(hCams) select 2;

private _display = ctrlParent _ctrlScreen;
private _pos = getPosASL _camHost;

[_ctrlScreen,false] call FUNC(drawUserMarkers);
[_ctrlScreen,0] call FUNC(drawBftMarkers);

// draw icon at own location
private _veh = vehicle Ctab_player;
_ctrlScreen drawIcon [
	"\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa",
	GVAR(mapToolsPlayerVehicleIconColor),
	getPosASL _veh,
	GVAR(ownVehicleIconBaseSize),GVAR(ownVehicleIconBaseSize),
	direction _veh,"", 1,GVAR(txtSize),"TahomaB","right"
];

// draw icon at helmet cam location
_ctrlScreen drawIcon [
	"\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa",
	GVAR(miscColor),
	_pos,
	GVAR(ownVehicleIconBaseSize),GVAR(ownVehicleIconBaseSize),
	direction _camHost,"",0,GVAR(txtSize),"TahomaB","right"
];

_ctrlScreen ctrlMapAnimAdd [0,GVAR(mapScaleHCam),_pos];
ctrlMapAnimCommit _ctrlScreen;

true
