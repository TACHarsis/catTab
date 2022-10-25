#include "script_component.hpp"

// This is drawn every frame on the TAD display. fnc
params ["_ctrlScreen"];

// is disableSerialization really required? If so, not sure this is the right place to call it
disableSerialization;

private _display = ctrlParent _ctrlScreen;

// current position
private _veh = vehicle Ctab_player;
private _playerPos = getPosASL _veh;
private _heading = direction _veh;

// change scale of map and centre to player position
_ctrlScreen ctrlMapAnimAdd [0, GVAR(mapScale), _playerPos];
ctrlMapAnimCommit _ctrlScreen;

[_ctrlScreen,false] call FUNC(drawUserMarkers);
[_ctrlScreen,1] call FUNC(drawBftMarkers);

// draw vehicle icon at own location
_ctrlScreen drawIcon [
	GVAR(playerVehicleIcon),
	GVAR(TADfontColour),
	_playerPos,
	GVAR(TADOwnIconBaseSize),GVAR(TADOwnIconBaseSize),
	_heading,"", 1,GVAR(txtSize),"TahomaB","right"
];

// draw TAD overlay (two circles, one at full scale, the other at half scale + current heading)
_ctrlScreen drawIcon [
	QPATHTOEF(data,img\TAD_overlay_ca.paa),
	GVAR(TADfontColour),
	_playerPos,
	250,250,
	_heading,"",1,GVAR(txtSize),"TahomaB","right"
];

true
