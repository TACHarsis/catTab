#include "script_component.hpp"

params ["_display", "_exitCode"];

uiNamespace setVariable [QGVAR(UAVListCtrls), []];
uiNamespace setVariable [QGVAR(HCAMListCtrls), []];
uiNamespace setVariable [QGVAR(UAVVideoSlotUIs), []];
uiNamespace setVariable [QGVAR(HCAMVideoSlotUIs), []];
