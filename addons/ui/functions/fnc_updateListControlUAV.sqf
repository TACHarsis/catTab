#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"

if (isNil QGVAR(ifOpen)) exitWith {};

private _displayName = GVAR(ifOpen) select 1;
private _display = uiNamespace getVariable _displayName;
private _displaySettings = [_displayName] call FUNC(getSettings);
private _mode = _displaySettings get QSETTING_MODE;
if (isNil "_mode") exitWith {};

if (_mode isEqualTo QSETTING_MODE_CAM_UAV) then {
    private _uavListCtrls = uiNamespace getVariable [QGVAR(UAVListCtrls), []];

    {
        private _UAVListCtrl = _x;
        lbClear _UAVListCtrl;

        _UAVListCtrl lbSetCurSel -1;
        private _deselectIndex = _UAVListCtrl lbAdd format ["*DESELECT"];
        _UAVListCtrl lbSetData [_deselectIndex, ""];
        {
            if !((crew _x isEqualTo [])) then {
                private _index = _UAVListCtrl lbAdd format ["%1:%2 (%3)", groupId group _x, groupId _x, getText (configfile >> "cfgVehicles" >> typeOf _x >> "displayname")];
                _UAVListCtrl lbSetData [_index, _x call BIS_fnc_netId];
            };
        } foreach GVARMAIN(UAVList);

        lbSort [_UAVListCtrl, "ASC"];
        private _settingName = GVAR(uavCamSettingsNames) select _foreachIndex;
        private _data = [_displayName, _settingName] call FUNC(getSettings);
        private _uav = _data call BIS_fnc_objectFromNetId;
        if !(isNull _uav) then {
            // Find last selected UAV and select if found
            for "_i" from 0 to (lbSize _UAVListCtrl - 1) do {
                if (_uav isEqualTo ((_UAVListCtrl lbData _i) call BIS_fnc_objectFromNetId)) exitWith {
                    if ((lbCurSel _UAVListCtrl) != _i) then {
                        _UAVListCtrl lbSetCurSel _i;
                    };
                };
            };
            // If no UAV could be selected, clear last selected UAV
            if ((lbCurSel _UAVListCtrl) isEqualTo -1) then {
                [_displayName,[[_settingName,""]]] call FUNC(setSettings);
                _UAVListCtrl lbSetCurSel _deselectIndex;
            };
        } else {
            _UAVListCtrl lbSetCurSel _deselectIndex;
        };
    } foreach _uavListCtrls;
};
