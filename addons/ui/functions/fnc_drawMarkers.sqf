#include "script_component.hpp"
/*
 	Name: Ctab_ui_fnc_drawMarkers
 	
 	Author(s):
		Gundy

 	Description:
		Draw map markers provided by allMapMarkers. 

	Parameters:
		0: OBJECT  - Map control to draw BFT icons on
 	
 	Returns:
		BOOLEAN - Always TRUE
 	
 	Example:
		[_ctrlScreen] call Ctab_ui_fnc_drawMarkers;
*/
params  ["_ctrlScreen"];

{
	
	private _marker = _x;
	
	private _pos = getMarkerPos _marker;
	private _type = getMarkerType _marker;
	private _size = getMarkerSize _marker;
	private _icon = getText(configFile/"CfgMarkers"/_type/"Icon");
	private _colorType = getMarkerColor _marker;  
	private _color = if (_icon != "" && {_colorType == "Default"}) then {
		getArray(configFile/"CfgMarkers"/_type/"color")
	} else {
		getArray(configFile/"CfgMarkerColors"/_colorType/"color")
	};
	if (typeName (_color select 0) == "STRING") then {
		_color = [
			call compile (_color select 0),
			call compile (_color select 1),
			call compile (_color select 2),
			call compile (_color select 3)
		];
	};
	private _brushType = markerBrush _marker;
	private _brush = getText(configFile/"CfgMarkerBrushes"/_brushType/"texture");
	private _shape = markerShape _marker;
	private _alpha = markerAlpha _marker;
	private _dir = markerDir _marker;
	private _text = markerText _marker;
	
	switch (_shape) do {
	    case "ICON": {
	    	_ctrlScreen drawIcon [_icon,_color,_pos,(_size select 0) * GVAR(iconSize),(_size select 1) * GVAR(iconSize),_dir,_text,0,GVAR(txtSize),"TahomaB","right"];
	    };
	    case "RECTANGLE": {
	    	_ctrlScreen drawRectangle [_pos,_size select 0,_size select 1,_dir,_color,_brush];
		};
		case "ELLIPSE": {
	    	_ctrlScreen drawEllipse [_pos,_size select 0,_size select 1,_dir,_color,_brush];
		};
	};
} forEach allMapMarkers;

true
