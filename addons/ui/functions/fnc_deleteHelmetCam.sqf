#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_deleteHelmetCam
    
    Author(s):
        Gundy, Cat Harsis

    Description:
        Delete helmet camera(s)
    
    Parameters:
        NONE
    
    Returns:
        Nothing
    
    Example:
        [0] call Ctab_ui_fnc_deleteHelmetCam;

*/
params [["_camID", nil, [""]]];

// remove cameras
private _fnc_deleteCam = {
    params ["_camID"];
    private _camData = GVAR(HelmetCamsData) getOrDefault [_camID, []];
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
    GVAR(HelmetCamsData) deleteAt _camID;
};

if(!isNil "_camID") then {
    [_camID] call _fnc_deleteCam;
} else {
    {
        [_x] call _fnc_deleteCam;
    } foreach GVAR(HelmetCamsData)
};

// remove camera direction update event handler if no more cams are present
if (count GVAR(HelmetCamsData) == 0) then {
    if !(isNil QGVAR(helmetEventHandle)) then {
        [GVAR(helmetEventHandle)] call CBA_fnc_removePerFrameHandler;
        GVAR(helmetEventHandle) = nil;
    };
};
