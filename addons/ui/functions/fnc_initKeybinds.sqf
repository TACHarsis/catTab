#include "script_component.hpp"
#include "\a3\editor_f\Data\Scripts\dikCodes.h"
private _category = "CatTAB";
[
    _category,
    QGVAR(ifMain),
    ["Toggle Main Interface","Open cTab device in small overlay mode if available"],
    { [0] call FUNC(onIfButtonPressed) },
    "",
    [DIK_H,[false,false,false]]
] call cba_fnc_addKeybind;

[
    _category,
    QGVAR(ifSecondary),
    ["Toggle Secondary Interface","Open cTab device in interactable mode"],
    { [1] call FUNC(onIfButtonPressed) },
    "",
    [DIK_H,[false,true,false]]
] call cba_fnc_addKeybind;

[
    _category,
    QGVAR(ifTertiary),
    ["Toggle Tertiary Interface","Open private cTab device when in a vehicle with its own cTab device, or to open Tablet while also carrying a MicroDAGR"],
    { [2] call FUNC(onIfButtonPressed) },
    "",
    [DIK_H,[false,false,true]]
] call cba_fnc_addKeybind;

[
    _category,
    QGVAR(zoomIn),
    ["Zoom In","Zoom In on map while cTab is in small overlay mode"],
    { [true /*zoom in*/] call FUNC(caseButtonsOnZoomPressed) },
    "",
    [DIK_PGUP,[true,true,false]],
    false
] call cba_fnc_addKeybind;

[
    _category,
    QGVAR(zoomOut),
    ["Zoom Out","Zoom Out on map while cTab is in small overlay mode"],
    { [false /*zoom out*/] call FUNC(caseButtonsOnZoomPressed) },
    "",
    [DIK_PGDN,[true,true,false]],
    false
] call cba_fnc_addKeybind;

[
    _category,
    QGVAR(toggleIfPosition),
    ["Toggle Interface Position","Toggle overlay mode interface position from left to right or reset interactive mode interface position to default"],
    { [] call FUNC(toggleIfPosition) },
    "",
    [DIK_HOME,[true,true,false]]
] call cba_fnc_addKeybind;    
