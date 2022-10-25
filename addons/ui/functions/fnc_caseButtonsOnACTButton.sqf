#include "script_component.hpp"

/*
Function to execute the correct action when btnACT is pressed on Tablet
No Parameters
Returns TRUE
*/

//CC: ACT is the button that switches you into a headcam or uav
private _mode = [QGVARMAIN(Tablet_dlg),"mode"] call FUNC(getSettings);

switch (_mode) do {
	case ("UAV"): {[] call EFUNC(core,remoteControlUav);};
	case ("HCAM"): {[QGVARMAIN(Tablet_dlg),[["mode","HCAM_FULL"]]] call FUNC(setSettings);};
	case ("HCAM_FULL"): {[QGVARMAIN(Tablet_dlg),[["mode","HCAM"]]] call FUNC(setSettings);};
};

true
