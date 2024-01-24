#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_userMenuSelect
    
    Author(s):
        Gundy, Riouken
    
    Description:
        Process user menu select events, initiated by "devices\shared\cTab_markerMenu_controls.hpp"
        
    
    Parameters:
        0: INTEGER - Type of user menu select event - if this doesn't match a valid type it will be considered to be an IDC
    
    Returns:
        BOOLEAN - TRUE
    
    Example:
        [1] call Ctab_ui_fnc_userMenuSelect;
*/
//TODO: This function is another one of those nightmares. Fix it.

#include "..\devices\shared\cTab_defines.hpp"

params ["_type"];

disableSerialization;


private _displayName = GVAR(ifOpen) select 1;
private _display = (uiNamespace getVariable _displayName);

private _idcToShow = 0;

switch (_type) do {
    // send GVAR(cTabUserSelIcon) to server
    case (1) : {
        GVAR(cTabUserSelIcon) pushBack Ctab_player;
        [call EFUNC(core,getPlayerEncryptionKey), GVAR(cTabUserSelIcon)] remoteExec [QFUNC(UserMarkerAddServer), 2];
    };
    
    // Lock UAV cam to clicked position
    case (2) : {
        //TODO: get actual index of currently selected uav or whatever depending on how the function itself will work eventually
        [GVAR(cTabUserSelIcon) select 0, 0] call FUNC(lockUavCamTo);
    };

    default {
        _idcToShow = switch(_type) do {
            case (11) : {IDC_CTAB_MARKER_MENU_ENYSUB1};
            case (12) : {IDC_CTAB_MARKER_MENU_ENYSUB2};
            case (13) : {IDC_CTAB_MARKER_MENU_ENYSUB3};
            case (14) : {
                if (GVAR(cTabUserSelIcon) select 1 != 0) then {
                    GVAR(cTabUserSelIcon) set [2,0];
                    
                    IDC_CTAB_MARKER_MENU_ENYSUB3
                } else {IDC_CTAB_MARKER_MENU_ENYSUB4};
            };
            case (21) : {IDC_CTAB_MARKER_MENU_CASUSUB1};
            case (31) : {IDC_CTAB_MARKER_MENU_GENSUB1};
            default {_type};
        };
    };
};

// Hide all menu controls
{
    ctrlShow [_x,false];
} foreach [IDCS_CTAB_MARKER_MENUS];

// Bring the menu control we want to show into position and show it
if (_idcToShow != 0) then {
    private _control = _display displayCtrl _idcToShow;
    if !(isNull _control) then {
        private _controlPos = ctrlPosition _control;
        
        // figure out screen edge positions and where the edges of the control would be if we were just to move it blindly to userPos
        private _screenPos = ctrlPosition (_display displayCtrl IDC_CTAB_LOADINGTXT);
        private _screenEdgeX = (_screenPos select 0) + (_screenPos select 2);
        private _screenEdgeY = (_screenPos select 1) + (_screenPos select 3);
        private _controlEdgeX = (GVAR(userPos) select 0) + (_controlPos select 2);
        private _controlEdgeY = (GVAR(userPos) select 1) + (_controlPos select 3);
        
        // if control would be clipping the right edge, correct control position
        if (_controlEdgeX > _screenEdgeX) then {
            _controlPos set [0,_screenEdgeX - (_controlPos select 2)];
        } else {
            _controlPos set [0,GVAR(userPos) select 0];
        };
        // if control would be clipping the bottom edge, correct control position
        if (_controlEdgeY > _screenEdgeY) then {
            _controlPos set [1,_screenEdgeY - (_controlPos select 3)];
        } else {
            _controlPos set [1,GVAR(userPos) select 1];
        };
        
        // move to position and show
        _control ctrlSetPosition _controlPos;
        _control ctrlCommit 0;
        _control ctrlShow true;
        ctrlSetFocus _control;
    };
};

true
