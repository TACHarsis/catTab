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
	GVAR(MicroDAGRfontColour),
	getPosASL _veh,
	GVAR(TADOwnIconBaseSize),GVAR(TADOwnIconBaseSize),
	direction _veh,"", 1,GVAR(txtSize),"TahomaB","right"
];

// draw icon at UAV location
_ctrlScreen drawIcon [
	"\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa"
	,GVAR(TADhighlightColour),
	_pos,
	GVAR(TADOwnIconBaseSize),GVAR(TADOwnIconBaseSize),
	direction GVAR(actUAV),"",0,GVAR(txtSize),"TahomaB","right"
];

_ctrlScreen ctrlMapAnimAdd [0,GVAR(mapScale)UAV,_pos];
ctrlMapAnimCommit _ctrlScreen;

true
