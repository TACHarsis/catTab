#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_userMarkerFindAtLocation
     
     Author(s):
        Gundy, Riouken

     Description:
        Find user placed marker at provided position.
        CC: This is used on the client only and with the refactor it works on the client only.

    Parameters:
        0: OBJECT - Map control we took the position from
        1: ARRAY  - Position to look for marker
     
     Returns:
        INTEGER - Index of user marker, if not found -1
     
     Example:
        _markerIndex = [_mapControl,[0,0]] call Ctab_ui_fnc_userMarkerFindAtLocation;
*/
params [
   "_mapControl",
   [
      "_searchPos", 
      [0,0],
      [[]],[2,3]
   ]
];

private _markerIdx = -1;
private _targetRadius = GVAR(iconSize) * 2 * (ctrlMapScale (_mapControl)) * GVAR(mapScaleFactor);

private _maxDistance = _searchPos distanceSqr [(_searchPos select 0) + _targetRadius,(_searchPos select 1) + _targetRadius];

// find closest user marker within _maxDistance
{
    private _distance = _searchPos distanceSqr (_x select 1 select 0);
    if (_distance <= _maxDistance) then {
        _maxDistance = _distance;
        _markerIdx = _x select 0;
    };
} foreach GVAR(userMarkerListTranslated);

_markerIdx
