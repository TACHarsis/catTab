#include "script_component.hpp"

/*
Function to toggle text next to BFT icons
Parameter 0: String of uiNamespace variable for which to toggle showIconText for
Returns TRUE
*/

params ["_displayName"];

if (GVAR(BFTtxt)) then {GVAR(BFTtxt) = false} else {GVAR(BFTtxt) = true};
[_displayName,[["showIconText",GVAR(BFTtxt)]]] call FUNC(setSettings);

true
