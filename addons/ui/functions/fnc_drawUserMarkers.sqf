#include "script_component.hpp"
/*
	Name: Ctab_ui_fnc_drawUserMarkers
	
	Author(s):
		Gundy, Riouken

	Description:
		Draw userMarkers held in GVAR(userMarkerListTranslated) to map control
		
		List format:
			Index 0: ARRAY  - marker position
			Index 1: STRING - path to marker icon
			Index 2: STRING - path to marker size icon
			Index 3: STRING - direction of reported movement
			Index 4: ARRAY  - marker color
			Index 5: STRING - marker time
			Index 6: STRING - text alignment
	
	Parameters:
		0: OBJECT  - Map control to draw BFT icons on
		1: BOOLEAN - Highlight marker under cursor
	
	Returns:
		BOOLEAN - Always TRUE
	
	Example:
		[_ctrlScreen] call Ctab_ui_fnc_drawUserMarkers;
*/
params  ["_ctrlScreen","_highlightCursorMarker"];

private _arrowLength = GVAR(userMarkerArrowSize) * ctrlMapScale _ctrlScreen;
private _cursorMarkerIndex = if (_highlightCursorMarker) then {[_ctrlScreen,GVAR(mapCursorPos)] call FUNC(userMarkerFind)} else {-1};

{
	private _markerData = _x select 1;
	private _pos = _markerData select 0;
	private _texture1 = _markerData select 1;
	private _texture2 = _markerData select 2;
	private _dir = _markerData select 3;
	private _color = if (_x select 0 != _cursorMarkerIndex) then {_markerData select 4} else {GVAR(miscColor)};
	private _text = "";
	if (_dir < 360) then {
		private _secondPos = [_pos,_arrowLength,_dir] call BIS_fnc_relPos;
		_ctrlScreen drawArrow [_pos, _secondPos, _color];
	};
	if (GVAR(BFTtxt)) then {_text = _markerData select 5;};
	
	_ctrlScreen drawIcon [
		_texture1,
		_color,
		_pos, 
		GVAR(iconSize), GVAR(iconSize), 
		0, _text, 0, GVAR(txtSize),"TahomaB",_markerData select 6
	];
	if (_texture2 != "") then {
		_ctrlScreen drawIcon [
			_texture2,
			_color,
			_pos,
			GVAR(groupOverlayIconSize), GVAR(groupOverlayIconSize),
			0, "", 0, GVAR(txtSize),"TahomaB","right"
		];
	};
} foreach GVAR(userMarkerListTranslated);

true
