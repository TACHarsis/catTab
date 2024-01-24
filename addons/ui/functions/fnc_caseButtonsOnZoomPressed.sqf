#include "script_component.hpp"
/*
Function handling Zoom_Out keydown event
If supported cTab interface is visible, increase map scale
Returns TRUE when action was taken
Returns FALSE when no action was taken (i.e. no interface open, or unsupported interface)
*/
params [["_zoomIn", true, [false]]];
if (GVAR(openStart) || (isNil QGVAR(ifOpen))) exitWith {false};
private _displayName = GVAR(ifOpen) select 1;
if !([_displayName] call FUNC(isDialog)) exitWith {
    private _mapScale = ([_displayName,QSETTING_MAP_SCALE_DISPLAY] call FUNC(getSettings)) * ([2, 0.5] select _zoomIn);
    private _mapScaleMax = [_displayName,QSETTING_MAP_SCALE_MAX] call FUNC(getSettings);
    if (_mapScale > _mapScaleMax) then {
        _mapScale = _mapScaleMax;
    };
    _mapScale = [_displayName,[[QSETTING_MAP_SCALE_DISPLAY,_mapScale]]] call FUNC(setSettings);
    true
};
false
