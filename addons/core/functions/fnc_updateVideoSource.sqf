#include "script_component.hpp"

params ["_type", "_unitNetID", ["_addIfNotFound", false, [true]]];
private _sourceData = [];
if(_unitNetID in GVAR(deadExclusionList) ) exitWith {_sourceData};

private _context = GVAR(videoSourcesContext) get _type;
private _sourcesHash = _context get QGVAR(sourcesHash);
_sourceData = _sourcesHash getOrDefault [_unitNetID, []];
private _dataWasFound = _sourceData isEqualTo [];
if(_dataWasFound && !_addIfNotFound) exitWith {_sourceData};

private _fnc_prepareUnit = _context get QGVAR(fnc_prepareUnit);
private _unit = _unitNetID call BIS_fnc_objectFromNetId;
private _isEnabled = false;
private _isDeleted = false;
if(isNull _unit) then {
    if(!_dataWasFound) exitWith {_sourceData};
    _isDeleted = true;
} else {
    _isEnabled = [_unit] call _fnc_prepareUnit;
};

if(!_isEnabled && _dataWasFound) exitWith {_sourceData};

if(_dataWasFound) then {
    private _fnc_getName = _context get QGVAR(fnc_getName);
    private _name = [_unit] call _fnc_getName;
    //TAG: video source data
    _sourceData = [_unitNetID, _unit, _name, nil, nil, nil, nil, nil];
    _sourcesHash set [_unitNetID, _sourceData];
};

private _fnc_getStatus = _context get QGVAR(fnc_getStatus);

private _isAlive = [false, alive _unit] select (isNull _unit);

private _prevSourceData = +_sourceData;
//TAG: video source data
_sourceData set [4, _isEnabled];
if(!isNull _unit) then {
    _sourceData set [3, _isAlive];
    _sourceData set [5, _unit getVariable [QGVAR(originalGroup), group _unit]];
    _sourceData set [6, _unit getVariable [QGVAR(originalSide), side _unit]];
    _sourceData set [7, [_unit, _isEnabled] call _fnc_getStatus];
} else {
    _sourceData set [3, false];
    _sourceData set [7, LOST];
};

if(_dataWasFound) then {
    [QGVAR(videoSourceAdded), [_type, _sourceData]] call CBA_fnc_localEvent;
} else {
    {
        _x params ["_idx", "_name"];
        private _prevValue = _prevSourceData # _idx;
        private _newValue = _sourceData # _idx;
        if(_prevValue isNotEqualTo _newValue) then {
            [QGVAR(videoSourceChanged_) + _name, [_type, _sourceData, _newValue, _prevValue]] call CBA_fnc_localEvent;
        };
    } foreach [
        //TAG: video source data
        [2, NAMENESS],
        [3, ALIVENESS],
        [4, ENABLED],
        [5, GROUPNESS],
        [6, SIDENESS],
        [7, STATUS]
        //TODO: maybe group id and such should also be saved as string in case group gets deleted?
        //TODO: maybe unit id in group also should be saved? Or strung somewhere?
    ];
};

_sourceData
