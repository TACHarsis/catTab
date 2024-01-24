#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_videoSourceNearLocation
     Author(s):
        Gundy, Riouken, Cat Harsis

     Description:
        Find uav near provided position.

    Parameters:
        0: STRING - Type
        2: OBJECT - Map control we took the position from
        3: ARRAY  - Position to look for video source (Optional)
     Returns:
        ARRAY     - video source data array, empty if not found
     Example:
        _uav = [_mapControl, [0, 0]] call Ctab_ui_fnc_videoSourceNearLocation;
*/
params ["_type", "_mapControl", ["_searchPos", [], [[]], [2, 3]], ["_filterSides", [], [[sideAmbientLife]]]];
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
{
   //TAG: video source data
   _y params ["_unitNetID", "_unit", "_name", "_alive", "_enabled", "_group", "_side", "_status"];
   if(isNull _unit || !_enabled) then {continue};
   if(_filterSides isNotEqualTo [] && {!(_side in _filterSides)}) then {continue};

   private _unitPos = getPosASL _unit;
   _unitPos set [2, 0]; // only need 2D

   // find source within _maxDistance
   private _distance = _searchPos distanceSqr (_unitPos);
   if (_distance <= _maxDistance) then {
      _maxDistance = _distance;
      _sourceData = _y;
   };
} foreach _sources;

_sourceData
