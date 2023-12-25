#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_deleteUAVcam
    
    Author(s):
        Gundy, Cat Harsis

    Description:
        Delete UAV camera(s)
    
    Parameters:
        Optional:
        0: OBJECT - Camera to delete
     
    Returns:
        Nothing
    
    Example:
        // delete all UAV cameras
        [] call Ctab_ui_fnc_deleteUAVcam;
        
        // delete a specific UAV camera
        [_camID] call Ctab_ui_fnc_deleteUAVcam;
*/
params [["_camID", nil, [""]]];

// remove cameras
private _fnc_deleteCam = {
    params ["_camID"];
    private _camData = GVAR(UAVCamsData) getOrDefault [_camID, []];
    if(_camData isNotEqualTo []) then {
        private _cam = _camData select 3;
        private _renderTargetName = _camData select 2;
        _cam cameraEffect ["TERMINATE","BACK", _renderTargetName];
        camDestroy _cam;
        private _frameGrp = _camData # 4;
        private _videoControllerCtrl = _frameGrp getVariable [QGVAR(videoController), controlNull];

        _videoControllerCtrl setVariable [QGVAR(cameraTarget), objNull];
        _videoControllerCtrl setVariable [QGVAR(cameraTargetType), nil];
        _videoControllerCtrl ctrlEnable false;
    };
    GVAR(UAVCamsData) deleteAt _camID;
};

if(!isNil "_camID") then {
    [_camID] call _fnc_deleteCam;
} else {
    {
        [_x] call _fnc_deleteCam;
    } foreach GVAR(UAVCamsData)
};

// remove camera direction update event handler if no more cams are present
if (count GVAR(UAVCamsData) == 0) then {
    if !(isNil QGVAR(uavEventHandle)) then {
        [GVAR(uavEventHandle)] call CBA_fnc_removePerFrameHandler;
        GVAR(uavEventHandle) = nil;
    };
};
