#include "script_component.hpp"
/*
     Name: Ctab_ui_fnc_caseButtonsToggleFollow
     
     Author(s):
        Cat Harsis

     Description:
        Toggle auto-follow current UAV or Helmet Cam
    
    Parameters:
        None
     
     Returns:
        BOOLEAN - TRUE
     
     Example:
        [] call Ctab_ui_fnc_caseButtonsToggleFollow;
*/

private _mode = [QGVARMAIN(Tablet_dlg), QSETTING_MODE] call FUNC(getSettings);
switch(_mode) do {
   case (QSETTING_MODE_CAM_UAV) : {
      private _prevValue = [QGVARMAIN(Tablet_dlg), QSETTING_FOLLOW_UAV] call FUNC(getSettings);
      [QGVARMAIN(Tablet_dlg),[[QSETTING_FOLLOW_UAV,!_prevValue]],true,true] call FUNC(setSettings);
   };
   case (QSETTING_MODE_CAM_HELMET) : {
      private _prevValue = [QGVARMAIN(Tablet_dlg), QSETTING_FOLLOW_HCAM] call FUNC(getSettings);
      [QGVARMAIN(Tablet_dlg),[[QSETTING_FOLLOW_HCAM,!_prevValue]],true,true] call FUNC(setSettings);
   };
};

true
