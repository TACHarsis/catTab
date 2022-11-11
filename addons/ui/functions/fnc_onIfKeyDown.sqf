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

if (_dikCode == DIK_F1 && {_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg),QGVARMAIN(FBCB2_dlg)]}) exitWith {
    [_displayName,[[QSETTING_MODE,QSETTING_MODE_BFT]]] call FUNC(setSettings);
    true
};
if (_dikCode == DIK_F2 && {_displayName in [QGVARMAIN(Tablet_dlg)]}) exitWith {
    [_displayName,[[QSETTING_MODE,QSETTING_MODE_CAM_UAV]]] call FUNC(setSettings);
    true
};
if (_dikCode == DIK_F3 && {_displayName in [QGVARMAIN(Tablet_dlg)]}) exitWith {
    [_displayName,[[QSETTING_MODE,QSETTING_MODE_CAM_HELMET]]] call FUNC(setSettings);
    true
};
if (_dikCode == DIK_F4 && {_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg),QGVARMAIN(FBCB2_dlg)]}) exitWith {
    [_displayName,[[QSETTING_MODE,QSETTING_MODE_MESSAGES]]] call FUNC(setSettings);
    true
};
if (_dikCode == DIK_F5 && {_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg),QGVARMAIN(TAD_dlg),QGVARMAIN(microDAGR_dlg),QGVARMAIN(FBCB2_dlg)]}) exitWith {
    [_displayName] call FUNC(toggleMapTools);
    true
};
if (_dikCode == DIK_F6 && {_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg),QGVARMAIN(TAD_dlg),QGVARMAIN(microDAGR_dlg),QGVARMAIN(FBCB2_dlg)]}) exitWith {
    [_displayName] call FUNC(caseButtonsMapTypeToggle);
    true
};
if (_dikCode == DIK_F7 && {_displayName in [QGVARMAIN(Tablet_dlg),QGVARMAIN(Android_dlg),QGVARMAIN(TAD_dlg),QGVARMAIN(microDAGR_dlg),QGVARMAIN(FBCB2_dlg)]}) exitWith {
    [_displayName] call FUNC(caseButtonsCenterMapOnPlayerPosition);
    true
};
if (_dikCode == DIK_DELETE && {GVAR(cursorOnMap)}) exitWith {
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
            diag_log "unlocking";
            _closestUAV lockCameraTo [objNull, [0]];
        };
    };

    true
};

if (_dikCode == DIK_SPACE && {_displayName in [QGVARMAIN(Tablet_dlg)]} && {GVAR(cursorOnMap)}) exitWith {
    diag_log "at all?";
    private _ctrlScreen = _display displayCtrl ([
        [_displayName,QSETTING_MAP_TYPES] call FUNC(getSettings),
        [_displayName,QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings)
    ] call BIS_fnc_getFromPairs);

    private _closestUAV = [_ctrlScreen,GVAR(mapCursorPos)] call FUNC(uavFindAtLocation);
    diag_log format["closest uav: %1", _closestUAV];
    if !(isNull _closestUAV) then {
        //setting new active UAV
        diag_log "new uav";
        GVAR(currentUAV) = _closestUAV;
        [QGVARMAIN(Tablet_dlg),[[QSETTING_CAM_UAV,_closestUAV call BIS_fnc_netId]]] call FUNC(setSettings);
    } else {
        // deselect current uav
        diag_log "deselecting";
        GVAR(currentUAV) = objNull;
        [QGVARMAIN(Tablet_dlg),[[QSETTING_CAM_UAV,""]]] call FUNC(setSettings);
    };

    true
};

false