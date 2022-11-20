#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_drawUserMarkers
    
    Author(s):
        Gundy, Riouken, Cat Harsis

    Description:
        Draw userMarkers held in GVAR(userMarkerListTranslated) to map control
        
        List format:
            Index 0: ARRAY  - marker position
            Index 1: STRING - path to marker icon
            Index 2: INTEGER - Size of icon
            Index 3: STRING - path to marker size icon
            Index 4: INTEGER - Size of icon overlay
            Index 5: STRING - direction of reported movement
            Index 6: ARRAY  - marker color
            Index 7: STRING - marker time
            Index 8: STRING - text alignment
    
    Parameters:
        0: OBJECT  - Map control to draw BFT icons on
        1: BOOLEAN - Highlight marker under cursor
    
    Returns:
        BOOLEAN - Always TRUE
    
    Example:
        [_ctrlScreen] call Ctab_ui_fnc_drawUserMarkers;
*/
params  ["_ctrlScreen","_highlightCursorMarker", "_drawText"];

private _arrowLength = GVAR(userMarkerArrowSize) * ctrlMapScale _ctrlScreen;
private _cursorMarkerIndex = [
        -1,
        [_ctrlScreen,GVAR(mapCursorPos)] call FUNC(userMarkerFindAtLocation)
    ] select _highlightCursorMarker;

{
    _x params ["_markerIndex", "_markerData"];
    _markerData params ["_pos","_texture1","_iconSize","_texture2","_overlayIconSize","_dir","_color",["_text", "", [""]],["_align", "left", [""]]];

    private _color = [GVAR(miscColor), _color] select (_markerIndex != _cursorMarkerIndex);
    if(_dir > 0) then {
        private _secondPos = [_pos,_arrowLength,_dir] call BIS_fnc_relPos;
        _ctrlScreen drawArrow [_pos, _secondPos, _color];
    };
    
    _ctrlScreen drawIcon [
        _texture1,
        _color,
        _pos, 
        _iconSize, _iconSize, 
        0, ["",_text] select _drawText, 0, GVAR(textSize),"TahomaB",_align
    ];
    if (_texture2 != "") then {
        _ctrlScreen drawIcon [
            _texture2,
            _color,
            _pos,
            _overlayIconSize, _overlayIconSize,
            0, "", 0, GVAR(textSize),"TahomaB","right"
        ];
    };
} foreach GVAR(userMarkerListTranslated);

true
