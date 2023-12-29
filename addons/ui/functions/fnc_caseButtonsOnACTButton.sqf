#include "script_component.hpp"

/*
Function to execute the correct action when btnACT is pressed on Tablet
No Parameters
Returns TRUE
*/

params ["_data"];

//CC: ACT is the button that switches you into a headcam or uav
private _mode = [QGVARMAIN(Tablet_dlg), QSETTING_MODE] call FUNC(getSettings);

switch (_mode) do {
    //case (QSETTING_MODE_CAM_UAV): {[] call FUNC(remoteControlUav);};
    case (QSETTING_MODE_CAM_UAV): {[QGVARMAIN(Tablet_dlg), [[QSETTING_MODE, QSETTING_MODE_CAM_UAV_FULL]]] call FUNC(setSettings);};
    case (QSETTING_MODE_CAM_UAV_FULL): {[QGVARMAIN(Tablet_dlg), [[QSETTING_MODE, QSETTING_MODE_CAM_UAV]]] call FUNC(setSettings);};
    case (QSETTING_MODE_CAM_HCAM): {[QGVARMAIN(Tablet_dlg), [[QSETTING_MODE, QSETTING_MODE_CAM_HCAM_FULL]]] call FUNC(setSettings);};
    case (QSETTING_MODE_CAM_HCAM_FULL): {[QGVARMAIN(Tablet_dlg), [[QSETTING_MODE, QSETTING_MODE_CAM_HCAM]]] call FUNC(setSettings);};
};

true
