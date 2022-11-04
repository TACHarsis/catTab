#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_isDialog
     
     Author(s):
        Gundy

     Description:
        Check if interface name ends with "dlg"
    
    Parameters:
        0: Name of interface
     
     Returns:
        BOOLEAN - True if interface name ends with "dlg"
     
     Example:
         // returns true
        [Ctab_Tablet_dlg] call Ctab_ui_fnc_isDialog;
        
        // returns false
        [Ctab_TAD_dsp] call Ctab_ui_fnc_isDialog;
*/

params  ["_interfaceName"];

(["dlg", _interfaceName] call BIS_fnc_inString)
