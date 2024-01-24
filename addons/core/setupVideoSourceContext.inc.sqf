private _uavContext = createHashMap;
_uavContext set [QGVAR(fnc_getUnits), {allUnitsUAV}];
_uavContext set [QGVAR(fnc_prepareUnit), {
    params ["_unit"];
    _unit in allUnitsUAV
}];
// _uavContext set [QGVAR(fnc_updateEntry), {
//     params ["_unit"];
// }];
_uavContext set [QGVAR(fnc_getName), {
    params ["_unit"];
    getText (configfile >> "cfgVehicles" >> typeOf _unit >> "displayname")
}];
_uavContext set [QGVAR(fnc_getStatus), {
    params ["_unit", "_isEnabled"];
    if(isNull _unit) exitWith { LOST };
    if(!alive _unit) exitWith { DESTROYED };
    if(!_isEnabled) exitWith { OFFLINE };
    ONLINE
}];
_uavContext set [QGVAR(sourcesHash), GVARMAIN(UAVVideoSources)];
private _hCamContext = createHashMap;
_hCamContext set [QGVAR(fnc_getUnits), {private _all = allUnits + allDeadMen; _all arrayIntersect _all}];
_hCamContext set [QGVAR(fnc_prepareUnit), {
    params ["_unit"];
    private _hasCameraItem = [_unit, ["ItemcTabHCam"]] call FUNC(checkGear);
    _unit setVariable [QGVAR(cameraItem), _hasCameraItem];
    private _hasCameraHelmet = _unit getVariable [QGVAR(cameraHelmet), false];
    // diag_log format ["%1 has item? [%2] has helmet? [%3]", _unit, _hasCameraItem, _hasCameraHelmet];
    // diag_log format ["(_hasCameraHelmet %1 || _hasCameraItem %2)", _hasCameraHelmet, _hasCameraItem];
    (_hasCameraHelmet || _hasCameraItem)
}];
// _hCamContext set [QGVAR(fnc_updateEntry), {
//     params ["_unit"];
// }];
_hCamContext set [QGVAR(fnc_getName), {
    params ["_unit"];
    name _unit
}];
_hCamContext set [QGVAR(fnc_getStatus), {
    params ["_unit", "_isEnabled"];
    if(isNull _unit) exitWith { LOST };
    if(!_isEnabled) exitWith { OFFLINE };
    ONLINE
}];
_hCamContext set [QGVAR(sourcesHash), GVARMAIN(hCamVideoSources)];
GVAR(videoSourcesContext) = createHashMapFromArray [
    [VIDEO_FEED_TYPE_UAV, _uavContext],
    [VIDEO_FEED_TYPE_HCAM, _hCamContext]
];
GVAR(deadExclusionList) = [];
