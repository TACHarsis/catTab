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

if !(isNil QGVAR(helmetCams)) then {
    private _cam = GVAR(helmetCams) select 0;
    _cam cameraEffect ["TERMINATE","BACK"];
    camDestroy _cam;
    deleteVehicle (GVAR(helmetCams) select 1);
    GVAR(helmetCams) = nil;
};

true
