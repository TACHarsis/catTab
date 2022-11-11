#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_deleteUAVcam
    
    Author(s):
        Gundy

    Description:
        Delete UAV camera
    
    Parameters:
        Optional:
        0: OBJECT - Camera to delete
     
    Returns:
        BOOLEAN - TRUE
    
    Example:
        // delete all UAV cameras
        [] call Ctab_ui_fnc_deleteUAVcam;
        
        // delete a specific UAV camera
        [_cam] call Ctab_ui_fnc_deleteUAVcam;
*/
params [["_camToDelete", objNull, [objNull]]];

// remove cameras
for "_i" from (count GVAR(uAVcams) -1) to 0 step -1 do {
    private _cam = GVAR(uAVcams) select _i select 2;
    if (isNull _camToDelete || {_cam == _camToDelete}) then {
        GVAR(uAVcams) deleteAt _i;
        _cam cameraEffect ["TERMINATE","BACK"];
        camDestroy _cam;
    };
};

// remove camera direction update event handler if no more cams are present
if (count GVAR(uAVcams) == 0) then {
    if !(isNil QGVAR(uavEventHandle)) then {
        [GVAR(uavEventHandle)] call CBA_fnc_removePerFrameHandler;
        GVAR(uavEventHandle) = nil;
    };
};

true
