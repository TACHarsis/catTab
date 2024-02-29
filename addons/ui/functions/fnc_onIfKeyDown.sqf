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

params ["_display", "_dikCode", "_shiftKey", "_ctrlKey", "_altKey"];

private _displayName = GVAR(ifOpen) select 1;
private _mode = [_displayName, QSETTING_MODE] call FUNC(getSettings);

private _videoSourceType = switch (_mode) do {
    case (QSETTING_MODE_CAM_UAV) : {VIDEO_FEED_TYPE_UAV};
    case (QSETTING_MODE_CAM_HCAM) : {VIDEO_FEED_TYPE_HCAM};
    default {""};
};
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
            [_displayName] call FUNC(caseButtonsCenterMap)
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

                private _turretPath = [0];
                private _closestVideoSourceLocked = [VIDEO_FEED_TYPE_UAV, _ctrlScreen, GVAR(mapCursorPos), _turretPath] call FUNC(videoSourceTurretLockNearLocation);
                if (_closestVideoSourceLocked isNotEqualTo []) then {
                    //TAG: video source data
                    _closestVideoSourceLocked params ["_unitNetID", "_unit", "_name", "_alive", "_enabled", "_group", "_side", "_status"];
                    // unlock
                    _unit lockCameraTo [objNull, _turretPath];
                };
            };
            true
        };
        false
    };

    case(DIK_SPACE): {
        if (_displayName in [QGVARMAIN(Tablet_dlg)] && {GVAR(cursorOnMap)}) exitWith {
            if !(_mode in [QSETTING_MODE_CAM_UAV, QSETTING_MODE_CAM_HCAM]) exitWith {false};
            if(_videoSourceType isEqualTo "") exitWith {false};

            private _ctrlScreen = _display displayCtrl ([
                [_displayName, QSETTING_MAP_TYPES] call FUNC(getSettings),
                [_displayName, QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings)
            ] call BIS_fnc_getFromPairs);

            private _context = GVAR(videoSourcesContext) get _videoSourceType;
            private _selectSetting = _context get QGVAR(selectedSettingName);
            private _followSetting = _context get QGVAR(followSettingName);

            private _closestVideoSourceData = [_videoSourceType, _ctrlScreen, GVAR(mapCursorPos), [] call EFUNC(core,getPlayerSides)] call FUNC(videoSourceNearLocation);
            if (_closestVideoSourceData isEqualTo []) then {
                // deselect current source
                [QGVARMAIN(Tablet_dlg), [[_selectSetting, ""]], true, true] call FUNC(setSettings);
                // unset follow
                [QGVARMAIN(Tablet_dlg), [[_followSetting, false]], true, true] call FUNC(setSettings);
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
            if(_videoSourceType isEqualTo "") exitWith {false};

            private _ctrlScreen = _display displayCtrl ([
                [_displayName, QSETTING_MAP_TYPES] call FUNC(getSettings),
                [_displayName, QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings)
            ] call BIS_fnc_getFromPairs);

            private _context = GVAR(videoSourcesContext) get _videoSourceType;
            private _slotSettings = _context get QGVAR(slotSettings);;
            private _slotSettingsNames = _context get QGVAR(slotSettingsNames);
            private _renderCameraDatas = _context get QGVAR(renderCamerasData);
            private _selectSetting = _context get QGVAR(selectedSettingName);
            private _followSetting = _context get QGVAR(followSettingName);

            private _slotIdx = (_dikCode - 2);
            private _modifierKeys = [_shiftKey, _ctrlKey, _altKey];
            [_videoSourceType, _ctrlScreen, GVAR(mapCursorPos), _dikCode, _modifierKeys,
                _slotIdx, _slotSettingsNames, _slotSettings, _selectSetting, _followSetting, _renderCameraDatas] call FUNC(feedSelectionMapShortcuts);
            true
        };
        false
    };

    default {false};
};

_return
