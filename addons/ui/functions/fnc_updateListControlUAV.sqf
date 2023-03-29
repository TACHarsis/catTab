#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"

if (isNil QGVAR(ifOpen)) exitWith {};

private _displayName = GVAR(ifOpen) select 1;
private _display = uiNamespace getVariable _displayName;
private _displaySettings = [_displayName] call FUNC(getSettings);
private _mode = _displaySettings get QSETTING_MODE;

if (isNil "_mode") exitWith {};

if (_mode isEqualTo QSETTING_MODE_CAM_UAV) then {
    private _data = [_displayName,QSETTING_CAM_UAV] call FUNC(getSettings);
    private _uav = _data call BIS_fnc_objectFromNetId;
    private _UAVListCtrl = _display displayCtrl IDC_CTAB_UAVLIST;

    // Populate list of UAVs
    lbClear _UAVListCtrl;
    _UAVListCtrl lbSetCurSel -1;
    private _deselectIndex = _UAVListCtrl lbAdd format ["*DESELECT"];
    _UAVListCtrl lbSetData [_deselectIndex, ""];
    {
        if !((crew _x isEqualTo [])) then {
            private _index = _UAVListCtrl lbAdd format ["%1:%2 (%3)",groupId group _x,groupId _x,getText (configfile >> "cfgVehicles" >> typeOf _x >> "displayname")];
            _UAVListCtrl lbSetData [_index, _x call BIS_fnc_netId];
        };
    } foreach GVARMAIN(UAVList);

    lbSort [_UAVListCtrl, "ASC"];
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
            [_displayName,[[QSETTING_CAM_UAV,""]]] call FUNC(setSettings);
            _UAVListCtrl lbSetCurSel _deselectIndex;
        };
    } else {
        _UAVListCtrl lbSetCurSel _deselectIndex;
    };
};
