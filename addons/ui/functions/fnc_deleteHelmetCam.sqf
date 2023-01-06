#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_deleteHelmetCam
    
    Author(s):
        Gundy

    Description:
        Delete helmet camera
    
    Parameters:
        NONE
    
    Returns:
        BOOLEAN - TRUE
    
    Example:
        call Ctab_ui_fnc_deleteHelmetCam;

*/

if !(isNil QGVAR(helmetCamData)) then {
    private _cam = GVAR(helmetCamData) select 0;
    _cam cameraEffect ["TERMINATE","BACK"];
    camDestroy _cam;
    deleteVehicle (GVAR(helmetCamData) select 1);

    if !(isNil QGVAR(helmetEventHandle)) then {
        [GVAR(helmetEventHandle)] call CBA_fnc_removePerFrameHandler;
        GVAR(helmetEventHandle) = nil;
    };

    GVAR(helmetCamData) = nil;
};

true
