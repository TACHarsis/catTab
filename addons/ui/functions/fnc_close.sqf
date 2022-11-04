#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_close
    
    Author(s):
        Gundy
    
    Description:
        Initiates the closing of currently open interface
    
    Parameters:
        No Parameters
    
    Returns:
        BOOLEAN - TRUE
    
    Example:
        [] call Ctab_ui_fnc_close;
*/

private ["_displayName","_display"];

if !(isNil QGVAR(ifOpen)) then {
    private _displayName = GVAR(ifOpen) select 1;
    private _display = uiNamespace getVariable _displayName;
    
    _display closeDisplay 0;
    //From Wiki. onUnload event doesn't fire for RscTitles displays started with cutRsc.
    if !([_displayName] call FUNC(isDialog)) then {
        [] call FUNC(onIfClose);
    };
};

true
