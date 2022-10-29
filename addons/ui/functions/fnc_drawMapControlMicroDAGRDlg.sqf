#include "script_component.hpp"

// This is drawn every frame on the microDAGR dialog. fnc
params ["_ctrlScreen"];

private _display = ctrlParent _ctrlScreen;

// current position
private _veh = vehicle Ctab_player;
private _playerPos = getPosASL _veh;
private _heading = direction _veh;

[_ctrlScreen,false] call FUNC(drawUserMarkers);
[_ctrlScreen,GVAR(microDAGRmode)] call FUNC(drawBftMarkers);

GVAR(mapWorldPos) = [_ctrlScreen] call FUNC(ctrlMapCenter);
GVAR(mapScale) = ctrlMapScale _ctrlScreen;

// draw directional arrow at own location
_ctrlScreen drawIcon [
	"\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa",
	GVAR(mapToolsPlayerVehicleIconColor),
	_playerPos,
	GVAR(ownVehicleIconBaseSize),GVAR(ownVehicleIconBaseSize),
	_heading,"", 1,GVAR(txtSize),"TahomaB","right"
];

// update hook information
if (GVAR(drawMapTools)) then {
	[_display,_ctrlScreen,_playerPos,GVAR(mapCursorPos),0,false] call FUNC(drawHook);
};

true
