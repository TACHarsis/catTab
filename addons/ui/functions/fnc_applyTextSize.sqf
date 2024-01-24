#include "script_component.hpp"
// fnc to set various text and icon sizes
params [["_textFctr", GVAR(txtFctr), [0]]];
GVAR(txtFctr) = _textFctr;
GVAR(iconSize) = GVAR(txtFctr) * 2;
GVAR(manSize) = GVAR(iconSize) * 0.75;
GVAR(groupOverlayIconSize) = GVAR(iconSize) * 1.625;
GVAR(userMarkerArrowSize) = GVAR(txtFctr) * 8 * GVAR(mapScaleFactor);
GVAR(textSize) = GVAR(txtFctr) / 12 * 0.035;
GVAR(airContactGroupTxtSize) = GVAR(txtFctr) / 12 * 0.060;
GVAR(airContactSize) = GVAR(txtFctr) / 12 * 32;
GVAR(airContactDummySize) = GVAR(txtFctr) / 12 * 20;
