#include "script_component.hpp"
/*
 	Name: Ctab_ui_fnc_centerMapOnPlayerPosition
 	
 	Author(s):
		Gundy

 	Description:
		Center BFT Map on current player position
	
	Parameters:
		0: STRING - Name of uiNamespace display / dialog variable
 	
 	Returns:
		BOOLEAN - TRUE
 	
 	Example:
		['Ctab_TAD_dlg'] call Ctab_ui_fnc_centerMapOnPlayerPosition;
*/


[_this select 0,[["mapWorldPos",getPosASL vehicle Ctab_player]],true,true] call FUNC(setSettings);

true
