#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"

if (isNil QGVAR(ifOpen)) exitWith {};

private _displayName = GVAR(ifOpen) select 1;
private _display = uiNamespace getVariable _displayName;
private _displaySettings = [_displayName] call FUNC(getSettings);
private _mode = _displaySettings get QSETTING_MODE;
if (isNil "_mode") exitWith {};

if (_mode isEqualTo QSETTING_MODE_CAM_HCAM) then {
    private _helmetListCtrls = uiNamespace getVariable [QGVAR(HCAMListCtrls), []];
    {
        private _hcamListCtrl = _x;
        lbClear _hcamListCtrl;
        
        _hcamListCtrl lbSetCurSel -1;
        private _deselectIndex = _hcamListCtrl lbAdd format ["*DESELECT"];
        _hcamListCtrl lbSetData [_deselectIndex, ""];
        {
            private _index = _hcamListCtrl lbAdd format ["%1:%2 (%3)",groupId group _x,groupId _x,name _x];
            _hcamListCtrl lbSetData [_index, _x call BIS_fnc_netId];
        } foreach GVARMAIN(hCamList);

        lbSort [_hcamListCtrl, "ASC"];
        private _settingName = GVAR(helmetCamSettingsNames) select _foreachIndex;
        private _data = [_displayName, _settingName] call FUNC(getSettings);
        private _unit = _data call BIS_fnc_objectFromNetId;
        if (!isNull _unit) then {
            // Find last selected hCam and select if found
            for "_i" from 0 to (lbSize _hcamListCtrl - 1) do {
                if (_unit isEqualTo ((_hcamListCtrl lbData _i) call BIS_fnc_objectFromNetId)) exitWith {
                    if ((lbCurSel _hcamListCtrl) != _i) then {
                        _hcamListCtrl lbSetCurSel _i;
                    };
                };
            };
            // If no hCam could be selected, clear last selected hCam
            if ((lbCurSel _hcamListCtrl) isEqualTo -1) then {
                [_displayName, [[_settingName, ""]]] call FUNC(setSettings);
                _hcamListCtrl lbSetCurSel _deselectIndex;
            };
        } else {
            _hcamListCtrl lbSetCurSel _deselectIndex;
        };
    } foreach _helmetListCtrls;
};
