
private _uavContext = createHashMap;
_uavContext set [QGVAR(sourcesHash), GVARMAIN(UAVVideoSources)];
_uavContext set [QGVAR(fnc_getListCtrlsData), {uiNamespace getVariable [QGVAR(UAVListCtrls), []]}];
_uavContext set [QGVAR(fnc_getVideoSlotUIs), {uiNamespace getVariable [QGVAR(UAVVideoSlotUIs), []]}];
_uavContext set [QGVAR(slotSettings), GVAR(uavCamSettings)];
_uavContext set [QGVAR(slotSettingsNames), GVAR(uavCamSettingsNames)];
_uavContext set [QGVAR(selectedSettingName), QSETTING_CAM_UAV_SELECTED];
_uavContext set [QGVAR(followSettingName), QSETTING_FOLLOW_UAV];
_uavContext set [QGVAR(modes), [QSETTING_MODE_CAM_UAV, QSETTING_MODE_CAM_UAV_FULL]];
_uavContext set [QGVAR(fnc_getCameraSettings), {
    params ["_unit"];

    // retrieve memory point name from vehicle config
    private _config = (configFile >> "CfgVehicles" >> typeOf _unit);
    private _camPosMemPt = getText (_config >> "uavCameraGunnerPos");
    private _camDirMemPt = getText (_config >> "uavCameraGunnerDir");

    //TODO: if now gunner camera is available, use the driver cam, or just none at all?
    // If memory points could be retrieved, create camera
    if !(_camPosMemPt isEqualTo "" || {_camDirMemPt isEqualTo ""}) exitWith {
        [[0, 0, 0], _camPosMemPt]
    };
    [[0, 0, 0], nil]
}];
_uavContext set [QGVAR(renderCamerasData), GVAR(UAVCamsData)];
_uavContext set [QGVAR(fnc_initContent), {
    params ["_videoSourceData", "_contentGrpCtrl"];

    private _contentHash = _contentGrpCtrl getVariable [QGVAR(feed_contentCtrlsHash), createHashMap];
    // diag_log format ["[INITCONTENT(UAV)]: contentCtrlsHash: %1", _contentHash];
    private _nameTextCtrl = (_contentHash get FEED_NAME) # 0;
    //TAG: video source data
    _videoSourceData params ["_unitNetID", "_unit", "_name", "_alive", "_enabled", "_group", "_side", "_status"];

    _nameTextCtrl ctrlSetText _name;
}];
_uavContext set [QGVAR(visionModes), [[0, 0], [1, 0], [2, 0]]];
_uavContext set [QGVAR(fnc_updateFrameGrp), {
    //TAG: cam data
    params ["_type", "_unitNetID", "_videoSourceData", "_camID", "_cam", "_renderTargetName", "_contentGrpCtrl"];
}];
_uavContext set [QGVAR(fnc_isSelected), { params ["_unit"]; !isNull _unit && {GVAR(selectedUAV) == _unit}}];

private _hCamContext = createHashMap;
_hCamContext set [QGVAR(sourcesHash), GVARMAIN(hCamVideoSources)];
_hCamContext set [QGVAR(fnc_getListCtrlsData), {uiNamespace getVariable [QGVAR(HCAMListCtrls), []]}];
_hCamContext set [QGVAR(fnc_getVideoSlotUIs), {uiNamespace getVariable [QGVAR(HCAMVideoSlotUIs), []]}];
_hCamContext set [QGVAR(slotSettings), GVAR(helmetCamSettings)];
_hCamContext set [QGVAR(slotSettingsNames), GVAR(hCamSettingsNames)];
_hCamContext set [QGVAR(selectedSettingName), QSETTING_CAM_HCAM_SELECTED];
_hCamContext set [QGVAR(followSettingName), QSETTING_FOLLOW_HCAM];
_hCamContext set [QGVAR(modes), [QSETTING_MODE_CAM_HCAM, QSETTING_MODE_CAM_HCAM_FULL]];
_hCamContext set [QGVAR(fnc_getCameraSettings), {
    params ["_unit"];

    [[0.12, 0, 0.15], "head"]
}];
_hCamContext set [QGVAR(renderCamerasData), GVAR(HelmetCamsData)];
_hCamContext set [QGVAR(fnc_initContent), {
    params ["_videoSourceData", "_contentGrpCtrl"];

    private _contentHash = _contentGrpCtrl getVariable [QGVAR(feed_contentCtrlsHash), createHashMap];
    // diag_log format ["[INITCONTENT(Hcam)]: contentCtrlsHash: %1", _contentHash];
    private _nameTextCtrl = (_contentHash get FEED_NAME) # 0;
    private _heartIconCtrl = (_contentHash get HEARTBEAT_ICON) # 0;
    private _heartTextIconCtrl = (_contentHash get HEARTBEAT_TEXT) # 0;
    //TAG: video source data
    _videoSourceData params ["_unitNetID", "_unit", "_name", "_alive", "_enabled", "_group", "_side", "_status"];

    _nameTextCtrl ctrlSetText _name;
    if(!isNull _unit) then {
        private _healthData = [_unit] call EFUNC(core,getUnitHealthData);
        //_healthData params ["_alive", "_conscious", "_health", "_heartRate", "_colorHint", "_stringHint"]
        _heartTextIconCtrl ctrlSetText _healthData # 5; // string hint
    } else {
        _heartTextIconCtrl ctrlSetText "(N/A)"; // string hint
    };
    _heartIconCtrl setVariable [QGVAR(time), 0];
}];
_hCamContext set [QGVAR(visionModes), [[0, 0], [1, 0]]];
_hCamContext set [QGVAR(fnc_updateFrameGrp), {
    //TAG: cam data
    params ["_type", "_unitNetID", "_videoSourceData", "_camID", "_cam", "_renderTargetName", "_contentGrpCtrl"];

    private _contentHash = _contentGrpCtrl getVariable [QGVAR(feed_contentCtrlsHash), createHashMap];
    private _nameTextCtrl = (_contentHash get FEED_NAME) # 0;
    private _heartIconCtrl = (_contentHash get HEARTBEAT_ICON) # 0;
    private _heartTextIconCtrl = (_contentHash get HEARTBEAT_TEXT) # 0;
    private _bpmAnim = 0;
    if(!isNull _unit) then {
        private _healthData = [_unit] call EFUNC(core,getUnitHealthData);
        _healthData params ["_alive", "_conscious", "_health", "_bpm", "_colorHint", "_stringHint"];
        _bpmAnim = _bpm;
        
        _heartIconCtrl ctrlSetTextColor _colorHint;
        _heartTextIconCtrl ctrlSetTextColor _colorHint;
        _heartTextIconCtrl ctrlSetText _stringHint;
        // diag_log format ["updating framegroup hcam: %1", _healthData];
    } else {
        _heartIconCtrl ctrlShow false;
        _heartTextIconCtrl ctrlShow false;
        _nameTextCtrl ctrlShow false;
    };

    if(_bpmAnim > 0) then {
        if(!(_heartIconCtrl in GVAR(animatedCtrls))) then {
            GVAR(animatedCtrls) pushBack _heartIconCtrl;
        };

        // calc length of 1 heartbeat
        private _timePerHeartbeat = (60 / _bpmAnim);
        // update params, the animation happens elsewhere
        _heartIconCtrl setVariable [QGVAR(animationParams), [GVAR(heartbeatAnimationArray), _timePerHeartbeat]];
        // diag_log format ["Updating hearticon params: %1", [GVAR(heartbeatAnimationArray), _timePerHeartbeat]];
    } else {
        if(_heartIconCtrl in GVAR(animatedCtrls)) then {
            GVAR(animatedCtrls) = GVAR(animatedCtrls) - [_heartIconCtrl];
        };
        _heartIconCtrl ctrlSetText GVAR(heartbeatDeathIcon);
    };
}];
_hCamContext set [QGVAR(fnc_isSelected), { params ["_unit"]; !isNull _unit && {GVAR(selectedHCam) == _unit}}];

GVAR(videoSourcesContext) = createHashMapFromArray [
    [VIDEO_FEED_TYPE_UAV, _uavContext],
    [VIDEO_FEED_TYPE_HCAM, _hCamContext]
];
