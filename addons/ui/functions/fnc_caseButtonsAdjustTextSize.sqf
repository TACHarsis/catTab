#include "script_component.hpp"
// fnc to adjust icon and text size
params [["_adjustment", 0, [1]]];
(GVAR(txtFctr) + _adjustment) call FUNC(applyTextSize);
true
