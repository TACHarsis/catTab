#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"

//params ["_mainPop", "_sendingCtrlArry"];

disableSerialization;

//diag_log format["OnIfMapClicked: %1", _this];
private _worldPos = (_this # 0) ctrlMapScreenToWorld [_this # 2, _this #3];
//diag_log format["OnIfMapClicked World: %1", _worldPos];
