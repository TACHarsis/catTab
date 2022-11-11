#include "script_component.hpp"

params ["_controlData", "_backgroundData"];
_controlData params ["_control", "_config"];
_backgroundData params ["_backgroundMode", "_backgroundPresetImagePath", "_customColor", "_customImageName"];

switch (_backgroundMode) do {
    case (0 /* preset */): {
        diag_log format ["setting preset path: %1", _backgroundPresetImagePath];
        _control ctrlSetText _backgroundPresetImagePath;
    };
    case (1 /* customImage */): {
        private _customImagePath = format["\z\Ctab\custom_backgrounds\%1", _customImageName];
        private _fileExists = fileExists _customImagePath;

        if(_fileExists) then {
            diag_log format ["setting custom path: %1", _customImagePath];
            _control ctrlSetText _customImagePath;
        } else { // Fall back to colors
            diag_log format ["File  does not exist falling back on color!
%1",_customImagePath];
            [_ControlData, [2,"", _customColor, ""]] call FUNC(setDeviceBackground); 
        };
    };
    case (2 /* customColor */): {
        diag_log format ["setting custom color: %1", _customColor];
        _control ctrlSetText format[
                "#(argb,8,8,3)color(%1,%2,%3,1)",
                _customColor select 0,
                _customColor select 1,
                _customColor select 2];
    };
};
