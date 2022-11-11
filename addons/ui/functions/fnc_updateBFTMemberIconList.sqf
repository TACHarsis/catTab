#include "script_component.hpp"

params ["_bftMemberList"];
GVAR(bftMemberIcons) = [];
{
    GVAR(bftMemberIcons) pushBack [_x,_x call EFUNC(ui,getInfMarkerIcon),"",name _x,str([_x] call CBA_fnc_getGroupIndex)];
} foreach _bftMemberList;