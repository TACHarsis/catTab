#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"

if (isNil QGVAR(ifOpen)) exitWith {};
params ["_type", ["_rebuild", false, [true]]];

// diag_log format ["UpdateListCtrls: Called %1", _type];

private _context = GVAR(videoSourcesContext) get _type;
//diag_log format ["UpdateListCtrls: _context %1", _context];
private _sources = _context get QGVAR(sourcesHash);
// diag_log format ["UpdateListCtrls: _sources %1", _sources];
private _listCtrls = [] call (_context get QGVAR(fnc_getListCtrlsData));
private _settingsNames = _context get QGVAR(slotSettingsNames);
private _modes = _context get QGVAR(modes);

private _displayName = GVAR(ifOpen) select 1;
private _display = uiNamespace getVariable _displayName;
private _displaySettings = [_displayName] call FUNC(getSettings);
private _mode = _displaySettings get QSETTING_MODE;
if (isNil "_mode") exitWith {};

// diag_log format ["UpdateListCtrls: Mode %1 vs %2", _mode, _modes];
if (_mode in _modes) then {
    // diag_log format ["UpdateListCtrls: Updating %1", _listCtrls];
    // diag_log format ["UpdateListCtrls: _sources %1", _sources];
    {
        private _listCtrl = _x;
        private _isBusy = _listCtrl getVariable [QGVAR(busy), false];
        if(_isBusy) then {continue}; // also maybe warn?

        _listCtrl setVariable [QGVAR(busy), true];
        private _deselectIndex = _listCtrl getVariable [QGVAR(deselectIdx), -1];

        // if required, rebuild the list
        if(_rebuild) then {
            lbClear _listCtrl;
            _listCtrl lbSetCurSel -1;
            _deselectIndex = _listCtrl lbAdd format ["*DESELECT"];
            _listCtrl lbSetTooltip [_deselectIndex, "Deselect current source."];
            _listCtrl setVariable [QGVAR(deselectIdx), _deselectIndex];
            _listCtrl lbSetData [_deselectIndex, ""];
            private _filterSides = [] call EFUNC(core,getPlayerSides);
            {
                //TAG: video source data
                _y params ["_unitNetID", "_unit", "_name", "_alive", "_enabled", "_group", "_side", "_status"];
                // diag_log format ["UpdateListCtrls: Checking %1: (%2) vs (%3)", _unit, _side, playerSide];
                if!(_side in _filterSides) then {continue};

                //TODO: get canonical side from here and only add entry if it matches playerSide (or you're logged admin or sth)
                //TODO: if we show cams of different sides, probably also should write that into the name
                //TODO: maybe group id and such should also be saved as string in case group gets deleted?
                //TODO: id of unit in group dependent on unit being existent
                private _groupId = [groupId _group, "(?)"] select (isNull _group);
                private _unitId = [format ["%1", groupId _unit], "99"] select (isNull _unit);
                private _index = _listCtrl lbAdd format ["%1:%2", _groupId, _unitId];
                _listCtrl lbSetData [_index, _unitNetID];
                _listCtrl lbSetTextRight [_index, _name];
                _listCtrl lbSetTooltip [_index, (GVAR(statusStrings) # _status)];
            } foreach _sources;
            lbSort [_listCtrl, "ASC"];
        };

        // select current entry
        private _frameIdx = _listCtrl getVariable [QGVAR(frameIdx), -1];
        private _settingName = _settingsNames select _frameIdx;
        private _data = [_displayName, _settingName] call FUNC(getSettings);
        _listCtrl lbSetCurSel _deselectIndex;
        if (_data isNotEqualTo "") then {
            // Find last selected source and select if found
            for "_i" from 0 to (lbSize _listCtrl - 1) do {
                if (_data isEqualTo (_listCtrl lbData _i)) exitWith {
                    if ((lbCurSel _listCtrl) != _i) then {
                        _listCtrl lbSetCurSel _i;
                        // diag_log format ["UpdateListCtrl setting cursel: %1 @ %2", _i, _settingName];
                    };
                };
            };
            // If no source could be selected, clear last selected source
            if ((lbCurSel _listCtrl) isEqualTo -1) then {
                [_displayName, [[_settingName, ""]]] call FUNC(setSettings);
                _listCtrl lbSetCurSel _deselectIndex;
                // diag_log format ["UpdateListCtrl setting cursel: DESELECT @ %2", _i, _settingName];
            };
        };
        _listCtrl setVariable [QGVAR(busy), false];
    } foreach _listCtrls;
};
