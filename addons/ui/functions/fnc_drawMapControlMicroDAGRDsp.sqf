#include "script_component.hpp"

// This is drawn every frame on the microDAGR display. fnc
params ["_ctrlScreen"];

private _display = ctrlParent _ctrlScreen;

// current position
private _veh = vehicle Ctab_player;
private _playerPos = getPosASL _veh;
private _heading = direction _veh;
// change scale of map and centre to player position
_ctrlScreen ctrlMapAnimAdd [0, GVAR(mapScale), _playerPos];
ctrlMapAnimCommit _ctrlScreen;

[_ctrlScreen,false] call FUNC(drawUserMarkers);
[_ctrlScreen,GVAR(microDAGRmode)] call FUNC(drawBftMarkers);

// draw directional arrow at own location
_ctrlScreen drawIcon [
	"\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa",
	GVAR(MicroDAGRfontColour),
	_playerPos,
	GVAR(TADOwnIconBaseSize),GVAR(TADOwnIconBaseSize),
	_heading,"", 1,GVAR(txtSize),"TahomaB","right"
];

true
