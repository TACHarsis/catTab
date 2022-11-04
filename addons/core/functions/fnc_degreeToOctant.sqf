#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_degreeToOctant
     
     Author(s):
        Gundy

     Description:
        Calculate octant from direction
    
    Parameters:
        0: INTEGER - Degree value to convert 0 to 360.
     
     Returns:
        STRING - Matching octant as either N, NE, E, SE, S, SW, W, NW
     
     Example:
        _octant = [direction player] call Ctab_ui_fnc_degreeToOctant;
*/

params ["_dir"];

private _octant = round (_dir / 45);

["N ","NE","E ","SE","S ","SW","W ","NW","N "] select _octant
