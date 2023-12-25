#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_hCamFindAtLocation
     
     Author(s):
        Gundy, Riouken, Cat Harsis

     Description:
        Find unit with helmet cam near provided position.

    Parameters:
        0: OBJECT - Map control we took the position from
        1: ARRAY  - Position to look for unit
     
     Returns:
        OBJECT    - unit found or objNull otherwise
     
     Example:
        _unit = [_mapControl, [0, 0]] call Ctab_ui_fnc_hCamFindAtLocation;
*/
params [
    "_mapControl",
    [
        "_searchPos", 
        [0, 0],
        [[]], [2, 3]
    ]
];

private _foundUnit = objNull;
private _targetRadius = GVAR(iconSize) * 2 * (ctrlMapScale (_mapControl)) * GVAR(mapScaleFactor);

private _maxDistance = _searchPos distanceSqr [(_searchPos select 0) + _targetRadius,(_searchPos select 1) + _targetRadius];
{
    private _unit = _x;
    private _unitPos = getPosASL _unit;
    _unitPos = [_unitPos # 0, _unitPos # 1, 0];

    // find uav within _maxDistance
    private _distance = GVAR(mapCursorPos) distanceSqr (_unitPos);
    if (_distance <= _maxDistance) then {
        _maxDistance = _distance;
        _foundUnit = _unit;
    };
} foreach GVARMAIN(hCamList);

_foundUnit
