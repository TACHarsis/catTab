#include "script_component.hpp"

params ["_ctrlScreen"];

// is disableSerialization really required? If so, not sure this is the right place to call it
disableSerialization;

private _displaySettings = [QGVARMAIN(Tablet_dlg)] call FUNC(getSettings);
private _display = ctrlParent _ctrlScreen;

[QGVARMAIN(Tablet_dlg),_this] call FUNC(drawMapControl);

// switch(_displaySettings get QSETTING_MODE) do {
//     case (QSETTING_MODE_BFT) : {
//         [QGVARMAIN(Tablet_dlg),_this] call FUNC(drawMapControl);
//     };
//     case (QSETTING_MODE_CAM_UAV) : {
//         [QGVAR(TABLET_UAVS),_this] call FUNC(drawMapControl);
//     };
//     case (QSETTING_MODE_CAM_HELMET) : {
//         [QGVAR(TABLET_HCAM),_this] call FUNC(drawMapControl);
//     };
// };
