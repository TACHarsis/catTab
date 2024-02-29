#include "script_component.hpp"

disableSerialization;

params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

if(_button != 0) exitWith {};

//TODO: Put the selection stuff in here

private _displayName = GVAR(ifOpen) select 1;
if !(_displayName in [QGVARMAIN(Tablet_dlg)] && {GVAR(cursorOnMap)}) exitWith {};
private _display = uiNamespace getVariable _displayName;
private _mode = [_displayName, QSETTING_MODE] call FUNC(getSettings);
if !(_mode in [QSETTING_MODE_CAM_UAV, QSETTING_MODE_CAM_HCAM]) exitWith {};

private _videoSourceType = switch (_mode) do {
    case (QSETTING_MODE_CAM_UAV) : {VIDEO_FEED_TYPE_UAV};
    case (QSETTING_MODE_CAM_HCAM) : {VIDEO_FEED_TYPE_HCAM};
    default {""};
};
if(_videoSourceType isEqualTo "") exitWith {};

private _ctrlScreen = _display displayCtrl ([
    [_displayName, QSETTING_MAP_TYPES] call FUNC(getSettings),
    [_displayName, QSETTING_CURRENT_MAP_TYPE] call FUNC(getSettings)
] call BIS_fnc_getFromPairs);

private _context = GVAR(videoSourcesContext) get _videoSourceType;
private _selectSetting = _context get QGVAR(selectedSettingName);
private _followSetting = _context get QGVAR(followSettingName);
private _closestVideoSourceData = [_videoSourceType, _ctrlScreen, GVAR(mapCursorPos), [] call EFUNC(core,getPlayerSides)] call FUNC(videoSourceNearLocation);
if (_closestVideoSourceData isNotEqualTo []) then {
    //TAG: video source data
    _closestVideoSourceData params ["_unitNetID", "_unit", "_name", "_alive", "_enabled", "_group", "_side", "_status"];
    //selecting source
    [QGVARMAIN(Tablet_dlg), [[_selectSetting, _unitNetID]], true, true] call FUNC(setSettings);
}//;
 else {
    // deselect current source
    [QGVARMAIN(Tablet_dlg), [[_selectSetting, ""]], true, true] call FUNC(setSettings);
    // unset follow
    [QGVARMAIN(Tablet_dlg), [[_followSetting, false]], true, true] call FUNC(setSettings);
};
