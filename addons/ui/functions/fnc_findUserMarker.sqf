#include "script_component.hpp"
/*
 	Name: Ctab_ui_fnc_findUserMarker
 	
 	Author(s):
		Gundy, Riouken

 	Description:
		Find user placed marker at provided position

	Parameters:
		0: OBJECT - Map control we took the position from
		1: ARRAY  - Position to look for marker
 	
 	Returns:
		INTEGER - Index of user marker, if not found -1
 	
 	Example:
		_markerIndex = [_ctrlScreen,[0,0]] call Ctab_ui_fnc_findUserMarker;
*/
params ["_ctrlScreen","_searchPos"];

private _return = -1;

// figure out radius around cursor box based on map zoom and scale
private _targetRadius = GVAR(iconSize) * 2 * (ctrlMapScale (_ctrlScreen)) * GVAR(mapScaleFactor);
private _maxDistance = _searchPos distanceSqr [(_searchPos select 0) + _targetRadius,(_searchPos select 1) + _targetRadius];

// find closest user marker within _maxDistance
{
	private _distance = _searchPos distanceSqr (_x select 1 select 0);
	if (_distance <= _maxDistance) then {
		_maxDistance = _distance;
		_return = _x select 0;
	};
} foreach GVAR(userMarkerList);

_return
