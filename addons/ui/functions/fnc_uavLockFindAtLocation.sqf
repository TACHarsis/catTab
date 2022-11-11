#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_uavFindAtLocation
     
     Author(s):
        Gundy, Riouken, Cat Harsis

     Description:
        Find UAV near provided position.

    Parameters:
        0: OBJECT - Map control we took the position from
        1: ARRAY  - Position to look for uav
     
     Returns:
        OBJECT    - UAV if found or objNull otherwise
     
     Example:
        _markerIndex = [_mapControl,[0,0]] call Ctab_ui_fnc_uavFindAtLocation;
*/
params [
   "_mapControl",
   [
      "_searchPos", 
      [0,0],
      [[]],[2,3]
   ]
];

private _foundUAV = objNull;
private _targetRadius = GVAR(iconSize) * 2 * (ctrlMapScale (_mapControl)) * GVAR(mapScaleFactor);

private _maxDistance = _searchPos distanceSqr [(_searchPos select 0) + _targetRadius,(_searchPos select 1) + _targetRadius];
{
   private _uav = _x;
   private _lineTargetPos = [0,0,0];
   private _camLockedTo = _uav lockedCameraTo [];
   private _camIsLocked = !(isNil "_camLockedTo");
   if (_camIsLocked) then {
         _lineTargetPos = if((typeName _camLockedTo) isEqualTo "ARRAY") then { _camLockedTo } else { [] call {getPosASL _camLockedTo} };
         // find uav target marker within _maxDistance
         private _distance = GVAR(mapCursorPos) distanceSqr (_lineTargetPos);
         if (_distance <= _maxDistance) then {
            _maxDistance = _distance;
            _foundUAV = _uav;
         };
   };
} foreach GVARMAIN(UAVList);
        

_foundUAV
