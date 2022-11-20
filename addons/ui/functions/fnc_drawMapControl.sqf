#include "script_component.hpp"

// This is drawn every frame on the android dialog. fnc
params ["_displayName", "_ctrlScreenArray"];
private _ctrlScreen = _ctrlScreenArray # 0;


// is disableSerialization really required? If so, not sure this is the right place to call it
disableSerialization;
private _displaySettings = [_displayName] call FUNC(getSettings);
private _display = ctrlParent _ctrlScreen;

// current position
private _playerVehicle = vehicle Ctab_player;
private _playerPos = getPosASL _playerVehicle;
private _playerHeading = direction _playerVehicle;


private _drawOptions = GVAR(displayDrawOptions) getOrDefault [_displayName, nil];

if(isNil "_drawOptions") exitWith { diag_log format["[Ctab] draMapControl(): ""%1"" has no draw options", _displayName]; };

private _condition = _drawOptions getOrDefault [DMC_CONDITION, {true}];
if(!([] call _condition)) exitWith {};

_fnc_getValue = {
    if((typeName _this) isEqualTo "CODE") then { [] call _this } else { _this }
};

{
    private _optionName = _x;
    private _params = _y call _fnc_getValue;

    switch (_optionName) do {
        case (DMC_SAVE_SCALE_POSITION) : {
            GVAR(mapWorldPos) = [_ctrlScreen] call FUNC(ctrlMapCenter);
            GVAR(mapScale) = ctrlMapScale _ctrlScreen;
        };
        case (DMC_RECENTER) : {
            // change scale of map and centre to given unit's position or player's as default
            _params params [["_unit",_playerVehicle], ["_mapScale",GVAR(mapScale)]];
            private _unit = _unit call _fnc_getValue;
            private _mapScale = _mapScale call _fnc_getValue;

            private _pos = if (isNull _unit) then { _playerPos } else { getPosASL _unit };
            _ctrlScreen ctrlMapAnimAdd [0, _mapScale, _pos];
            ctrlMapAnimCommit _ctrlScreen;
        };
        case (DMC_DRAW_MARKERS): {
            _params params ["_highlights", "_bftOptions"];
            private _drawText = [_displayName, QSETTING_SHOW_ICON_TEXT] call FUNC(getSettings);
            [_ctrlScreen,_highlights,_drawText] call FUNC(drawUserMarkers);
            [_ctrlScreen,_displayName,_bftOptions] call FUNC(drawBftMarkers);
        };
        case (DMC_DRAW_HOOK): {
            [_display,_displayName,_ctrlScreen,_playerPos,GVAR(mapCursorPos),_instrumentMode,_referenceMode,_drawMapTools] call FUNC(drawHook);
        };
        case (DMC_VEHICLE_AVATAR) : {
            private _customIconPath = _params call _fnc_getValue;
            _ctrlScreen drawIcon [
                [_customIconPath, "\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa"] select (_customIconPath isEqualTo ""),
                GVAR(mapToolsPlayerVehicleIconColor),
                _playerPos,
                GVAR(ownVehicleIconBaseSize),GVAR(ownVehicleIconBaseSize),
                _playerHeading,"", 1,GVAR(textSize),"TahomaB","right"
            ];
        };
        case (DMC_HUMAN_AVATAR) : {
            {
                private _unit = _x call _fnc_getValue;
                private _pos = _playerPos;
                private _heading = _playerHeading;
                if !(isNull _unit) then {
                    _pos = getPosASL _unit;
                    _heading = direction _unit;
                };
                
                _ctrlScreen drawIcon [
                    "\A3\ui_f\data\map\VehicleIcons\iconmanvirtual_ca.paa",
                    GVAR(mapToolsPlayerVehicleIconColor),
                    _pos,
                    GVAR(ownVehicleIconBaseSize),GVAR(ownVehicleIconBaseSize),
                    _heading,"", 1,GVAR(textSize),"TahomaB","right"
                ];
            } foreach _params;
        };
        case (DMC_TAD_OVERLAY) : {
            // draw TAD overlay (two circles, one at full scale, the other at half scale + current heading)
            _ctrlScreen drawIcon [
                QPATHTOEF(data,img\map\overlay\TAD_overlay_ca.paa),
                GVAR(TADOwnSideColor),
                _playerPos,
                250,250,
                _playerHeading,"",1,GVAR(textSize),"TahomaB","right"
            ];
        };
    };
} foreach _drawOptions;
