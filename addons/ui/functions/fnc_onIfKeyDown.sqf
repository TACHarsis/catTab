#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_onIfKeyDown
     
     Author(s):
        Gundy, Riouken

     Description:
        Process onKeyDown events from cTab dialogs
        
    
    Parameters:
        0: OBJECT  - Display that called the onKeyDown event
        1: INTEGER - DIK code of onKeyDown event
        2: BOOLEAN - Shift key pressed
        3: BOOLEAN - Ctrl key pressed
        4: BOOLEAN - Alt key pressed
     
     Returns:
        BOOLEAN - If onKeyDown event was acted upon
     
     Example:
        [_display,_dikCode,_shiftKey,_ctrlKey,_altKey] call Ctab_ui_fnc_onIfKeyDown;
*/

#include "\a3\ui_f\hpp\defineDIKCodes.inc"

params ["_display","_dikCode","_shiftKey","_ctrlKey","_altKey"];

private _displayName = GVAR(ifOpen) select 1;
private _mode = [_displayName, QSETTING_MODE] call FUNC(getSettings);

private _return = switch (_dikCode) do {
    case(DIK_F1): {
        if (_displayName in [QGVARMAIN(Tablet_dlg), QGVARMAIN(Android_dlg),QGVARMAIN(FBCB2_dlg)]) exitWith {
            [_displayName,[[QSETTING_MODE, QSETTING_MODE_BFT]]] call FUNC(setSettings);
            true
        };
        false
    };
    case(DIK_F2): {
        if (_displayName in [QGVARMAIN(Tablet_dlg)]) exitWith {
            [_displayName,[[QSETTING_MODE, QSETTING_MODE_CAM_UAV]]] call FUNC(setSettings);
            true
        };
        false
    };
    case(DIK_F3): {
        if (_displayName in [QGVARMAIN(Tablet_dlg)]) exitWith {
            [_displayName,[[QSETTING_MODE, QSETTING_MODE_CAM_HCAM]]] call FUNC(setSettings);
            true
        };
        false
    };
    case(DIK_F4): {
        if (_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg),QGVARMAIN(FBCB2_dlg)]) exitWith {
            [_displayName,[[QSETTING_MODE, QSETTING_MODE_MESSAGES]]] call FUNC(setSettings);
            true
        };
        false
    };
    case(DIK_F5): {
        if (_displayName in [QGVARMAIN(Tablet_dlg), QGVARMAIN(Android_dlg), QGVARMAIN(microDAGR_dlg), QGVARMAIN(FBCB2_dlg)]) exitWith {
            [_displayName] call FUNC(toggleMapTools);
            true
        };
        false
    };
    case(DIK_F5): {
        if (_displayName in [QGVARMAIN(TAD_dlg)]) exitWith {
            [_displayName] call FUNC(toggleMapToolReferenceMode);
            true
        };
        false
    };
    case(DIK_F6): {
        if (_displayName in [QGVARMAIN(Tablet_dlg), QGVARMAIN(Android_dlg), QGVARMAIN(TAD_dlg), QGVARMAIN(microDAGR_dlg), QGVARMAIN(FBCB2_dlg)]) exitWith {
            [_displayName] call FUNC(caseButtonsMapTypeToggle)
        };
        false
    };
    case(DIK_F7): {
        if (_displayName in [QGVARMAIN(Tablet_dlg), QGVARMAIN(Android_dlg), QGVARMAIN(TAD_dlg), QGVARMAIN(microDAGR_dlg), QGVARMAIN(FBCB2_dlg)]) exitWith {
            [_displayName] call FUNC(caseButtonsCenterMapOnPlayerPosition)
        };
        false
    };
    case(DIK_F8): {
        if (_displayName in [QGVARMAIN(Tablet_dlg)]) exitWith {
            [] call FUNC(caseButtonsToggleFollow)
        };
        false
    };
    case(DIK_DELETE): {
        if (GVAR(cursorOnMap)) exitWith {
            private _ctrlScreen = _display displayCtrl ([
                [_displayName, QSETTING_MAP_TYPES] call FUNC(getSettings),
                [_displayName, QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings)
            ] call BIS_fnc_getFromPairs);

            private _markerIndex = [_ctrlScreen, GVAR(mapCursorPos)] call FUNC(userMarkerFindAtLocation);
            if (_markerIndex != -1) then {
                [call EFUNC(core,getPlayerEncryptionKey), _markerIndex] remoteExec [QFUNC(userMarkerDeleteServer), 2];
            } else {
                if!(_displayName in [QGVARMAIN(Tablet_dlg)]) exitWith {};

                private _closestUAV = [_ctrlScreen, GVAR(mapCursorPos)] call FUNC(uavLockFindAtLocation);
                if !(isNil "_closestUAV") then {
                    // unlock
                    _closestUAV lockCameraTo [objNull, [0]];
                };
            };

            true
        };
        false
    };

    case(DIK_SPACE): {
        if (_displayName in [QGVARMAIN(Tablet_dlg)] && {GVAR(cursorOnMap)}) exitWith {
            if !(_mode in [QSETTING_MODE_CAM_HCAM, QSETTING_MODE_CAM_UAV]) exitWith {false};

            private _ctrlScreen = _display displayCtrl ([
                [_displayName, QSETTING_MAP_TYPES] call FUNC(getSettings),
                [_displayName, QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings)
            ] call BIS_fnc_getFromPairs);

            if(_mode isEqualTo QSETTING_MODE_CAM_UAV) then {
                //TODO: Current/selected UAV is different now and doesn't just set/unset the only uav cam
                private _closestUAV = [_ctrlScreen, GVAR(mapCursorPos)] call FUNC(uavFindAtLocation);
                if !(isNull _closestUAV) then {
                    //setting new active UAV
                    [QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_UAV_0, _closestUAV call BIS_fnc_netId]], true, true] call FUNC(setSettings);
                    [QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_UAV_CURRENT, _closestUAV call BIS_fnc_netId]], true, true] call FUNC(setSettings);
                } else {
                    // deselect current uav
                    //[QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_UAV_0, ""]], true, true] call FUNC(setSettings);
                    [QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_UAV_CURRENT, ""]], true, true] call FUNC(setSettings);
                };
            } else {
                //TODO: Current/selected UAV is different now and doesn't just set/unset the only uav cam
                private _closestUnit = [_ctrlScreen, GVAR(mapCursorPos)] call FUNC(unitFindAtLocation);
                if !(isNull _closestHCam) then {
                    //setting new active UAV
                    [QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_HCAM_0, _closestHCam call BIS_fnc_netId]], true, true] call FUNC(setSettings);
                    [QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_HCAM_CURRENT, _closestHCam call BIS_fnc_netId]], true, true] call FUNC(setSettings);
                } else {
                    // deselect current uav
                    //[QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_HCAM_0, ""]], true, true] call FUNC(setSettings);
                    [QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_HCAM_CURRENT, ""]], true, true] call FUNC(setSettings);
                };
            };

            true
        };
        false
    };

    case(DIK_1);
    case(DIK_2);
    case(DIK_3);
    case(DIK_4);
    case(DIK_5);
    case(DIK_6): {
        if (_displayName in [QGVARMAIN(Tablet_dlg)] && {GVAR(cursorOnMap)}) exitWith {
            private _ctrlScreen = _display displayCtrl ([
                [_displayName, QSETTING_MAP_TYPES] call FUNC(getSettings),
                [_displayName, QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings)
            ] call BIS_fnc_getFromPairs);
   
            //TODO: Current/selected UAV is different now and doesn't just set/unset the only uav cam
            private _closestUAV = [_ctrlScreen, GVAR(mapCursorPos)] call FUNC(uavFindAtLocation);

            ["%1 pressed on UAV: %2", _dikCode-1, _closestUAV] call EFUNC(core,debugLog);
            // if !(isNull _closestUAV) then {
            //     //setting new active UAV
            //     [QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_UAV_0, _closestUAV call BIS_fnc_netId]], true, true] call FUNC(setSettings);
            //     [QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_UAV_CURRENT, _closestUAV call BIS_fnc_netId]], true, true] call FUNC(setSettings);
            // } else {
            //     // deselect current uav
            //     //[QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_UAV_0, ""]], true, true] call FUNC(setSettings);
            //     [QGVARMAIN(Tablet_dlg), [[QSETTING_CAM_UAV_CURRENT, ""]], true, true] call FUNC(setSettings);
            // };
            true
        };
        false
    };

    default {false};
};

_return
