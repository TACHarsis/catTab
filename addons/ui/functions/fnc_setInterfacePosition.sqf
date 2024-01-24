#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_setInterfacePosition
    Author(s):
        Gundy
    Description:
        Move the whole interface by a provided offset
    Parameters:
        0: STRING - uiNamespace variable name of interface
        1: ARRAY  - offset in the form of [x,y]
    Returns:
        BOOLEAN - TRUE
    Example:
        [QGVARMAIN(Tablet_dlg),[0.2,0.1]] call Ctab_ui_fnc_setInterfacePosition;
*/
#include "\a3\ui_f\hpp\defineResincl.inc"
params ["_displayName","_offset"];

disableSerialization;

private _display = uiNamespace getVariable _displayName;
private _isDialog = [_displayName] call FUNC(isDialog);

// get both classes "controls" and "controlsBackground" if they exist
private _displayConfigContainers = if (_isDialog) then {
        "true" configClasses (configFile >> _displayName)
    } else {
        "true" configClasses (configFile >> "RscTitles" >> _displayName)
    };

{
    if (isClass _x) then {
        private _displayConfigClasses = "true" configClasses _x;
        {
            if (isClass _x) then {
                if (isNumber (_x >> "idc")) then {
                    private _idc = getNumber (_x >> "idc");
                    if (_idc > 0) then {
                        private _ctrl = _display displayCtrl _idc;
                        private _configPosition = [getNumber (_x >> "x"),getNumber (_x >> "y")];
                        private _newPosition = (_configPosition vectorAdd _offset);
                        _newPosition = [_newPosition # 0, _newPosition # 1];
                        _ctrl ctrlSetPosition _newPosition;
                        _ctrl ctrlCommit 0;
                    } else {diag_log str ["invalid IDC",_x]};
                } else {diag_log str ["missing IDC",_x]};
            };
        } forEach _displayConfigClasses;
    };
} forEach _displayConfigContainers;
