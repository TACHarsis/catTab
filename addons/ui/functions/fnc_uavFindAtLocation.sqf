#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_uavFindAtLocation
     
     Author(s):
        Gundy, Riouken, Cat Harsis

     Description:
        Find uav near provided position.

    Parameters:
        0: OBJECT - Map control we took the position from
        1: ARRAY  - Position to look for uav
     
     Returns:
        OBJECT    - UAV if found or objNull otherwise
     
     Example:
        _uav = [_mapControl, [0, 0]] call Ctab_ui_fnc_uavFindAtLocation;
*/
params [
   "_mapControl",
   [
      "_searchPos", 
      [0, 0],
      [[]], [2, 3]
   ]
];

private _foundUAV = objNull;
private _targetRadius = GVAR(iconSize) * 2 * (ctrlMapScale (_mapControl)) * GVAR(mapScaleFactor);

private _maxDistance = _searchPos distanceSqr [(_searchPos select 0) + _targetRadius, (_searchPos select 1) + _targetRadius];
{
   private _uav = _x;
   private _uavPos = getPosASL _uav;
   _uavPos = [_uavPos # 0, _uavPos # 1, 0];

   // find uav within _maxDistance
   private _distance = GVAR(mapCursorPos) distanceSqr (_uavPos);
   if (_distance <= _maxDistance) then {
      _maxDistance = _distance;
      _foundUAV = _uav;
   };
} foreach GVARMAIN(UAVList);


_foundUAV
