#include "script_component.hpp"
	
// This is drawn every frame on the android display. fnc
params ["_ctrlScreen"];

private _display = ctrlParent _ctrlScreen;

// current position
private _veh = vehicle Ctab_player;
private _playerPos = getPosASL _veh;
private _heading = direction _veh;

[_ctrlScreen,false] call FUNC(drawUserMarkers);
[_ctrlScreen,0] call FUNC(drawBftMarkers);

// change scale of map and centre to player position
_ctrlScreen ctrlMapAnimAdd [0, GVAR(mapScale), _playerPos];
ctrlMapAnimCommit _ctrlScreen;

// draw directional arrow at own location
_ctrlScreen drawIcon [
	"\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa",
	GVAR(mapToolsPlayerVehicleIconColor),
	_playerPos,
	GVAR(ownVehicleIconBaseSize),GVAR(ownVehicleIconBaseSize),
	_heading,"", 1,GVAR(txtSize),"TahomaB","right"
];

true
