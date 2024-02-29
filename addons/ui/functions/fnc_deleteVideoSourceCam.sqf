#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_deleteVideoSourceCam

    Author(s):
        Gundy, Cat Harsis

    Description:
        Delete video source camera(s)

    Parameters:
        0: STRING - feed type to deleted
        1: STRING - Camera id of camera to delete (optional)

    Returns:
        Nothing

    Example:
        // delete all video source cameras
        [_type] call Ctab_ui_fnc_deleteVideoSourceCam;
        // delete a specific video source camera
        [_type, _camID] call Ctab_ui_fnc_deleteVideoSourceCam;
*/
params ["_type", ["_camID", nil, [""]]];
private _context = GVAR(videoSourcesContext) get _type;
private _renderCamerasData = _context get QGVAR(renderCamerasData);
// remove cameras
private _fnc_deleteCam = {
    params ["_renderCamerasData", "_camID"];
    private _camData = _renderCamerasData getOrDefault [_camID, []];
    if(_camData isNotEqualTo []) then {
        //TAG: cam data
        _camData params ["_type", "_unitNetID", "_videoSourceData", "_camID", "_cam", "_renderTargetName", "_contentGrpCtrl"];
        _cam cameraEffect ["TERMINATE", "BACK", _renderTargetName];
        camDestroy _cam;
        private _videoControllerCtrl = _contentGrpCtrl getVariable [QGVAR(feed_controllerCtrl), controlNull];

        _videoControllerCtrl setVariable [QGVAR(cameraTarget), objNull];
        private _canDisable = _videoControllerCtrl getVariable [QGVAR(canDisable), true];
        _videoControllerCtrl ctrlEnable !_canDisable;
    };
    _renderCamerasData deleteAt _camID;
};

if(!isNil "_camID") then {
    [_renderCamerasData, _camID] call _fnc_deleteCam;
} else {
    {
        [_renderCamerasData, _x] call _fnc_deleteCam;
    } foreach _renderCamerasData;
};
