#include "script_component.hpp"
#include "mapControlOptions.hpp"
// This is drawn every frame on the android dialog. fnc
params ["_ctrlScreen", "_keys"];

// is disableSerialization really required? If so, not sure this is the right place to call it
disableSerialization;

private _display = ctrlParent _ctrlScreen;

// current position
private _playerVehicle = vehicle Ctab_player;
private _playerPos = getPosASL _playerVehicle;
private _playerHeading = direction _playerVehicle;


{
    switch (_x) do {
        case (DMC_SCALE_POSITION) : {
            GVAR(mapWorldPos) = [_ctrlScreen] call FUNC(ctrlMapCenter);
            GVAR(mapScale) = ctrlMapScale _ctrlScreen;
        };
        case (DMC_RECENTER) : {
            // change scale of map and centre to player position
            private _pos = if (isNull _y) then { _playerPos } else { getPosASL _y };
            _ctrlScreen ctrlMapAnimAdd [0, GVAR(mapScale), _pos];
            ctrlMapAnimCommit _ctrlScreen;
        };
        case (DMC_DRAW_MARKERS): {
            _y params ["_highlights", "_mode"];
            [_ctrlScreen,_highlights] call FUNC(drawUserMarkers);
            [_ctrlScreen,_mode] call FUNC(drawBftMarkers);
        };
        case (DMC_DRAW_HOOK): {
            // update hook information
            _y params [["_mode", 0], ["_isTad", false]];
            if (GVAR(drawMapTools) || _isTad) then {
                [_display,_ctrlScreen,_playerPos,GVAR(mapCursorPos),_mode,_isTad] call FUNC(drawHook);
            };
        };
        case (DMC_VEHICLE_AVATAR) : {
            _ctrlScreen drawIcon [
                [_y, "\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa"] select (_y isEqualTo ""),
                GVAR(mapToolsPlayerVehicleIconColor),
                _playerPos,
                GVAR(ownVehicleIconBaseSize),GVAR(ownVehicleIconBaseSize),
                _playerHeading,"", 1,GVAR(textSize),"TahomaB","right"
            ];
        };
        case (DMC_HUMAN_AVATAR) : {
            private _pos = if(isNull _y) then { _playerPos } else { getPosASL _y};
            private _heading = if(isNull _y) then { _playerHeading } else { direction _y};
            _ctrlScreen drawIcon [
                "\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa",
                GVAR(mapToolsPlayerVehicleIconColor),
                _pos,
                GVAR(ownVehicleIconBaseSize),GVAR(ownVehicleIconBaseSize),
                _heading,"", 1,GVAR(textSize),"TahomaB","right"
            ];
        };
        case (DMC_TAD_OVERLAY) : {
            // draw TAD overlay (two circles, one at full scale, the other at half scale + current heading)
            _ctrlScreen drawIcon [
                QPATHTOEF(data,img\map\overlay\TAD_overlay_ca.paa),
                GVAR(TADOwnIconColor),
                _playerPos,
                250,250,
                _playerHeading,"",1,GVAR(textSize),"TahomaB","right"
            ];
        };
    };
} foreach _keys;




true
