#include "script_component.hpp"
/*
Figure out the scaling factor based on the current map (island) being played
Requires the scale of the map control to be at 0.001
*/

private _displayName = QGVAR(mapSize_dsp);
GVAR(RscLayer) cutRsc [_displayName,"PLAIN",0, false];

[    
    {
        !isNull (uiNamespace getVariable _this)
    },
    {
        params ["_displayName"];

        private _display = uiNamespace getVariable _displayName;
        private _mapCtrl = _display displayCtrl 1110;

        // get the screen postition of _mapCtrl as [x, y, w, h]
        private _mapScreenPos = ctrlPosition _mapCtrl;

        // Find the screen coordinate for the left side
        private _mapScreenX_left = _mapScreenPos select 0;
        // Find the screen height
        private _mapScreenH    = _mapScreenPos select 3;
        // Find the screen coordinate for top Y 
        private _mapScreenY_top = _mapScreenPos select 1;
        // Find the screen coordinate for middle Y 
        private _mapScreenY_middle = _mapScreenY_top + _mapScreenH / 2;

        // Get world coordinate for top Y in meters
        private _mapWorldY_top = (_mapCtrl ctrlMapScreenToWorld [_mapScreenX_left,_mapScreenY_top]) select 1;
        // Get world coordinate for middle Y in meters
        private _mapWorldY_middle = (_mapCtrl ctrlMapScreenToWorld [_mapScreenX_left,_mapScreenY_middle]) select 1;

        // calculate the difference between top and middle world coordinates, devide by the screen height and return
        GVAR(mapScaleFactor) = (abs(_mapWorldY_middle - _mapWorldY_top)) / _mapScreenH;
        
        _display closeDisplay 0;
        uiNamespace setVariable [_displayName, displayNull];

        GVAR(mapScaleUAV) = 0.8 / GVAR(mapScaleFactor);
        GVAR(mapScaleHCam) = 0.3 / GVAR(mapScaleFactor);

        // Beginning text and icon size
        GVAR(txtFctr) = 12;
        [] call FUNC(caseButtonsApplyTextSize);

        GVAR(mapScaleInitialized) = true;
    },
    _displayName,
    1, // 5 second timeout
    {
        throw "Unable to create map scale testing display.";
    }
] call CBA_fnc_waitUntilAndExecute;
