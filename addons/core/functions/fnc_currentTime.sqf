#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_currentTime
     Author(s):
        Gundy

     Description:
        Retrieve current in-game time in HH:MM format
    Parameters:
        NONE
     Returns:
        STRING - Current in-game time in format "HH:MM"
     Example:
        _time = call Ctab_ui_fnc_currentTime;
*/

private _date = date;
private _hour = _date select 3;
private _min = _date select 4;
if (_hour < 10) then {_hour = format ["0%1", _hour];};
if (_min < 10) then {_min = format ["0%1", _min];};

format ["%1:%2", _hour, _min]
