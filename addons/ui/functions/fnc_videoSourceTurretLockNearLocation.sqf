#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_videoSourceTurretLockNearLocation
     Author(s):
        Gundy, Riouken, Cat Harsis

     Description:
        Find UAV near provided position.

    Parameters:
        0: OBJECT - Map control we took the position from
        1: ARRAY  - Position to look for uav
     Returns:
        OBJECT    - vehicle of turret if found or objNull otherwise
     Example:
        _markerIndex = [_mapControl,[0,0]] call Ctab_ui_fnc_videoSourceTurretLockNearLocation;
*/
params ["_type", "_mapControl", ["_searchPos", [], [[]], [2, 3]], ["_turretPath", [], [[]]]];

// this is awkward, but I think params saves default values by value and not by reference, and obviously the cursor pos will change
if(_searchPos isEqualTo []) then {
   _searchPos = GVAR(mapCursorPos);
};

private _sourceData = [];
//TODO: verify that this is a good radius and consider making it an optional parameter?
private _targetRadius = 2 * GVAR(iconSize) * (ctrlMapScale (_mapControl)) * GVAR(mapScaleFactor);
private _maxDistance = _targetRadius * _targetRadius;

private _context = GVAR(videoSourcesContext) get _type;
private _sources = _context get QGVAR(sourcesHash);
private _maxDistance = _searchPos distanceSqr [(_searchPos select 0) + _targetRadius,(_searchPos select 1) + _targetRadius];
{
   //TAG: video source data
   _y params ["_unitNetID", "_uav", "_name", "_alive", "_enabled", "_group", "_side", "_status"];
   if(isNull _uav || !_enabled) then {continue};

   private _lineTargetPos = [0,0,0];
   private _camLockedTo = _uav lockedCameraTo _turretPath;
   private _camIsLocked = !(isNil "_camLockedTo");
   if (_camIsLocked) then {
         _lineTargetPos = if((typeName _camLockedTo) isEqualTo "ARRAY") then { _camLockedTo } else { [] call {getPosASL _camLockedTo} };
         // find uav target marker within _maxDistance
         private _distance = _searchPos distanceSqr (_lineTargetPos);
         if (_distance <= _maxDistance) then {
            // update maxDistance
            _maxDistance = _distance;
            _sourceData = _y;
         };
   };
} foreach _sources;

_sourceData
