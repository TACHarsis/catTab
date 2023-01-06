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

#include "\a3\editor_f\Data\Scripts\dikCodes.h"

params ["_display","_dikCode","_shiftKey","_ctrlKey","_altKey"];

private _displayName = GVAR(ifOpen) select 1;

private _return = switch (_dikCode) do {
    case(DIK_F1): {
        if (_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg),QGVARMAIN(FBCB2_dlg)]) exitWith {
            [_displayName,[[QSETTING_MODE,QSETTING_MODE_BFT]]] call FUNC(setSettings);
            true
        };
        false
    };
    case(DIK_F2): {
        if (_displayName in [QGVARMAIN(Tablet_dlg)]) exitWith {
            [_displayName,[[QSETTING_MODE,QSETTING_MODE_CAM_UAV]]] call FUNC(setSettings);
            true
        };
        false
    };
    case(DIK_F3): {
        if (_displayName in [QGVARMAIN(Tablet_dlg)]) exitWith {
            [_displayName,[[QSETTING_MODE,QSETTING_MODE_CAM_HELMET]]] call FUNC(setSettings);
            true
        };
        false
    };
    case(DIK_F4): {
        if (_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg),QGVARMAIN(FBCB2_dlg)]) exitWith {
            [_displayName,[[QSETTING_MODE,QSETTING_MODE_MESSAGES]]] call FUNC(setSettings);
            true
        };
        false
    };
    case(DIK_F5): {
        if (_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg),QGVARMAIN(microDAGR_dlg),QGVARMAIN(FBCB2_dlg)]) exitWith {
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
        if (_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg),QGVARMAIN(TAD_dlg),QGVARMAIN(microDAGR_dlg),QGVARMAIN(FBCB2_dlg)]) exitWith {
            [_displayName] call FUNC(caseButtonsMapTypeToggle)
        };
        false
    };
    case(DIK_F7): {
        if (_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg),QGVARMAIN(TAD_dlg),QGVARMAIN(microDAGR_dlg),QGVARMAIN(FBCB2_dlg)]) exitWith {
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
                [_displayName,QSETTING_MAP_TYPES] call FUNC(getSettings),
                [_displayName,QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings)
            ] call BIS_fnc_getFromPairs);

            private _markerIndex = [_ctrlScreen,GVAR(mapCursorPos)] call FUNC(userMarkerFindAtLocation);
            if (_markerIndex != -1) then {
                [call EFUNC(core,getPlayerEncryptionKey),_markerIndex] remoteExec [QFUNC(userMarkerDeleteServer), 2];
            } else {
                if!(_displayName in [QGVARMAIN(Tablet_dlg)]) exitWith {};

                private _closestUAV = [_ctrlScreen,GVAR(mapCursorPos)] call FUNC(uavLockFindAtLocation);
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
            private _ctrlScreen = _display displayCtrl ([
                [_displayName,QSETTING_MAP_TYPES] call FUNC(getSettings),
                [_displayName,QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings)
            ] call BIS_fnc_getFromPairs);

            private _closestUAV = [_ctrlScreen,GVAR(mapCursorPos)] call FUNC(uavFindAtLocation);
            if !(isNull _closestUAV) then {
                //setting new active UAV
                
                [QGVARMAIN(Tablet_dlg),[[QSETTING_CAM_UAV,_closestUAV call BIS_fnc_netId]], true,true] call FUNC(setSettings);
            } else {
                // deselect current uav
                [QGVARMAIN(Tablet_dlg),[[QSETTING_CAM_UAV,""]], true,true] call FUNC(setSettings);
            };
            true
        };
        false
    };

    default {false};
};

_return
