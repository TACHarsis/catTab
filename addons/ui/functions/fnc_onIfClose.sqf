#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_onIfClose
    
    Author(s):
        Gundy
    
    Description:
        Closes the currently open interface and remove any previously registered eventhandlers.
    
    Parameters:
        No Parameters
    
    Returns:
        BOOLEAN - TRUE
    
    Example:
        [] call Ctab_ui_fnc_onIfClose;
*/

// remove helmet and UAV cameras
[VIDEO_FEED_TYPE_HCAM] call FUNC(deleteVideoSourceCam);
[VIDEO_FEED_TYPE_UAV] call FUNC(deleteVideoSourceCam);


if !(isNil QGVAR(ifOpen)) then {
    GVAR(ifOpen) params ["_ifType", "_displayName", "_player", "_playerKilledEhId", "_vehicle", "_vehicleGetOutEhId", "_draw3dEhId", "_aceUnconciousEhId", "_acePlayerInventoryChangedEhId"];

    if !(isNil "_playerKilledEhId") then {_player removeEventHandler ["killed", _playerKilledEhId]};
    if !(isNil "_vehicleGetOutEhId") then {_vehicle removeEventHandler ["GetOut", _vehicleGetOutEhId]};
    if !(isNil "_draw3dEhId") then {removeMissionEventHandler ["Draw3D", _draw3dEhId]};
    if !(isNil "_aceUnconciousEhId") then {["medical_onUnconscious", _aceUnconciousEhId] call ace_common_fnc_removeEventHandler};
    if !(isNil "_acePlayerInventoryChangedEhId") then {["playerInventoryChanged", _acePlayerInventoryChangedEhId] call ace_common_fnc_removeEventHandler};

    // remove notification system related PFH
    if !(isNil QGVAR(processNotificationsPFH)) then {
        [GVAR(processNotificationsPFH)] call CBA_fnc_removePerFrameHandler;
        GVAR(processNotificationsPFH) = nil;
    };

    // don't call this part if we are closing down before setup has finished
    if !(GVAR(openStart)) then {
        if ([_displayName] call FUNC(isDialog)) then {
            // convert mapscale to km
            private _mapScale = GVAR(mapScale) * GVAR(mapScaleFactor) / 0.86 * (safezoneH * 0.8);

            // get the current position of the background control
            private _backgroundPosition = [_displayName] call FUNC(getBackgroundPosition);
            private _backgroundPositionX = _backgroundPosition select 0 select 0;
            private _backgroundPositionY = _backgroundPosition select 0 select 1;

            // get the original position of the background control
            private _backgroundConfigPositionX = _backgroundPosition select 1 select 0;
            private _backgroundConfigPositionY = _backgroundPosition select 1 select 1;

            // calculate x and y as offsets to the original
            private _xOffset = _backgroundPositionX - _backgroundConfigPositionX;
            private _yOffset = _backgroundPositionY - _backgroundConfigPositionY;

            // figure out if the interface position has changed
            private _backgroundOffset = [[], [_xOffset,_yOffset]] select (_xOffset != 0 || _yOffset != 0);
            
            // Save mapWorldPos and mapScaleDlg of current dialog so it can be restored later
            [_displayName,[[QSETTING_MAP_WORLD_POS,GVAR(mapWorldPos)],[QSETTING_MAP_SCALE_DIALOG,_mapScale],[SETTING_POSITION_DIALOG,_backgroundOffset]],false] call FUNC(setSettings);
        };
    };

    uiNamespace setVariable [_displayName, displayNull];
    GVAR(ifOpen) = nil;
};

GVAR(cursorOnMap) = false;
GVAR(openStart) = false;

true
