#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_deleteVideoSourceCam

    Author(s):
        Gundy, Cat Harsis

    Description:
        Delete video source camera(s)

    Parameters:
        Optional:
        0: OBJECT - Camera to delete

    Returns:
        Nothing

    Example:
        // delete all video source cameras
        [_type] call Ctab_ui_fnc_deleteVideoSourceCam;
        // delete a specific video source camera
        [_type, _camID] call Ctab_ui_fnc_deleteVideoSourceCam;
*/
params ["_type", ["_camID", nil, [""]]];
// diag_log format ["DeleteVideoSourceCam: _type: %1, _camID: %2", _type, _camID];
private _context = GVAR(videoSourcesContext) get _type;
private _renderCamerasData = _context get QGVAR(renderCamerasData);
// diag_log format ["Context: %1", _context];
// diag_log format ["DeleteVideoSourceCam: _renderCamerasData: %1", _renderCamerasData];
// remove cameras
private _fnc_deleteCam = {
    params ["_renderCamerasData", "_camID"];
    // diag_log format ["_fnc_deleteCam: _renderCamerasData: %1, _camID: %2", _renderCamerasData, _camID];
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
        // diag_log format ["Delete Cam Cleanup done."];
    };
    _renderCamerasData deleteAt _camID;
};

if(!isNil "_camID") then {
    [_renderCamerasData, _camID] call _fnc_deleteCam;
} else {
    {
        // diag_log format ["In the delete-all-Loop: %1, %2", _x, _renderCamerasData];
        [_renderCamerasData, _x] call _fnc_deleteCam;
    } foreach _renderCamerasData;
};
