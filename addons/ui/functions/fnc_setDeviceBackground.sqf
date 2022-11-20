#include "script_component.hpp"

params ["_controlData", "_backgroundData"];
_controlData params ["_control", "_config"];
_backgroundData params ["_backgroundMode", "_backgroundPresetImagePath", "_customColor", "_customImageName"];

switch (_backgroundMode) do {
    case (0 /* preset */): {
        _control ctrlSetText _backgroundPresetImagePath;
    };
    case (1 /* customImage */): {
        private _customImagePath = format["\z\Ctab\custom_backgrounds\%1", _customImageName];
        private _fileExists = fileExists _customImagePath;

        if(_fileExists) then {
            _control ctrlSetText _customImagePath;
        } else { // Fall back to colors
            [_ControlData, [2,"", _customColor, ""]] call FUNC(setDeviceBackground); 
        };
    };
    case (2 /* customColor */): {
        _control ctrlSetText format[
                "#(argb,8,8,3)color(%1,%2,%3,1)",
                _customColor select 0,
                _customColor select 1,
                _customColor select 2];
    };
};
