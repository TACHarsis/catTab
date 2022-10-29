#include "script_component.hpp"

// This is drawn every frame on the TAD display. fnc
params ["_ctrlScreen"];

private _display = ctrlParent _ctrlScreen;

// current position
private _veh = vehicle Ctab_player;
private _playerPos = getPosASL _veh;
private _heading = direction _veh;

[_ctrlScreen,false] call FUNC(drawUserMarkers);
[_ctrlScreen,1] call FUNC(drawBftMarkers);

// change scale of map and centre to player position
_ctrlScreen ctrlMapAnimAdd [0, GVAR(mapScale), _playerPos];
ctrlMapAnimCommit _ctrlScreen;

// draw vehicle icon at own location
_ctrlScreen drawIcon [
	GVAR(playerVehicleIcon),
	GVAR(TADOwnIconColor),
	_playerPos,
	GVAR(ownVehicleIconBaseSize),GVAR(ownVehicleIconBaseSize),
	_heading,"", 1,GVAR(txtSize),"TahomaB","right"
];

// draw TAD overlay (two circles, one at full scale, the other at half scale + current heading)
_ctrlScreen drawIcon [
	QPATHTOEF(data,img\TAD_overlay_ca.paa),
	GVAR(TADOwnIconColor),
	_playerPos,
	250,250,
	_heading,"",1,GVAR(txtSize),"TahomaB","right"
];

true
