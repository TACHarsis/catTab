#include "\a3\ui_f\hpp\defineDIKCodes.inc"

// CBA_fnc_addKeybind Parameters:
//  _modName           Name of the registering mod [String]
//  _actionId          Id of the key action. [String]
//  _displayName       Pretty name, or an array of strings for the pretty name and a tool tip [String]
//  _downCode          Code for down event, empty string for no code. [Code]
//  _upCode            Code for up event, empty string for no code. [Code]

//  Optional:
//  _defaultKeybind    The keybinding data in the format [DIK, [shift, ctrl, alt]] [Array]
//  _holdKey           Will the key fire every frame while down [Bool]
//  _holdDelay         How long after keydown will the key event fire, in seconds. [Float]
//  _overwrite         Overwrite any previously stored default keybind [Bool]

// Returns:
//  Returns the current keybind for the action [Array]

#define KEYBIND_NULL [0, [false, false, false]]

private _categoryMod = LLSTRING(General_Category_Mod);
private _categoryAndroid = LLSTRING(General_Category_Android);
private _categoryMicroDAGR = LLSTRING(General_Category_MicroDAGR);
private _categoryTAD = LLSTRING(General_Category_TAD);
private _categoryFBCB2 = LLSTRING(General_Category_FBCB2);
private _categoryTablet = LLSTRING(General_Category_Tablet);
[
    _categoryMod,
    QGVAR(ifMain),
    [LLSTRING(Keybind_Iface_Main), LLSTRING(Keybind_Iface_Main_Hint)],
    { [DEVICE_KEY_ORDER_MAIN] call FUNC(onIfButtonPressed) },
    "",
    [DIK_H, [false, false, false]]
] call cba_fnc_addKeybind;

[
    _categoryMod,
    QGVAR(ifSecondary),
    [LLSTRING(Keybind_Iface_Secondary), LLSTRING(Keybind_Iface_Secondary_Hint)],
    { [DEVICE_KEY_ORDER_SECONDARY] call FUNC(onIfButtonPressed) },
    "",
    [DIK_H, [false, true, false]]
] call cba_fnc_addKeybind;

[
    _categoryMod,
    QGVAR(ifTertiary),
    [LLSTRING(Keybind_Iface_Tertiary), LLSTRING(Keybind_Iface_Tertiary_Hint)],
    { [DEVICE_KEY_ORDER_TERTIARY] call FUNC(onIfButtonPressed) },
    "",
    [DIK_H, [false, false, true]]
] call cba_fnc_addKeybind;
//TODO: These direct shortcuts do not check for presence of the necessary items or vehicles
//      This is fine for now, but needs to be fixed eventually
[
    [_categoryMod, _categoryAndroid],
    QGVAR(android_dlg),
    [LLSTRING(Keybind_Toggle_Android_Dlg), LLSTRING(Keybind_Toggle_Android_Dlg_Hint)],
    { [QGVARMAIN(Android_dlg)] call FUNC(toggleInterface) },
    "",
    KEYBIND_NULL
] call cba_fnc_addKeybind;

[
    [_categoryMod, _categoryAndroid],
    QGVAR(android_dsp),
    [LLSTRING(Keybind_Toggle_Android_Dsp), LLSTRING(Keybind_Toggle_Android_Dsp_Hint)],
    { [QGVARMAIN(Android_dsp)] call FUNC(toggleInterface) },
    "",
    KEYBIND_NULL
] call cba_fnc_addKeybind;
[
    [_categoryMod, _categoryMicroDAGR],
    QGVAR(microDAGR_dlg),
    [LLSTRING(Keybind_Toggle_microDAGR_Dlg), LLSTRING(Keybind_Toggle_microDAGR_Dlg_Hint)],
    { [QGVARMAIN(microDAGR_dlg)] call FUNC(toggleInterface) },
    "",
    KEYBIND_NULL
] call cba_fnc_addKeybind;

[
    [_categoryMod, _categoryMicroDAGR],
    QGVAR(microDAGR_dsp),
    [LLSTRING(Keybind_Toggle_microDAGR_Dsp), LLSTRING(Keybind_Toggle_microDAGR_Dsp_Hint)],
    { [QGVARMAIN(microDAGR_dsp)] call FUNC(toggleInterface) },
    "",
    KEYBIND_NULL
] call cba_fnc_addKeybind;
[
    [_categoryMod, _categoryTAD],
    QGVAR(TAD_dlg),
    [LLSTRING(Keybind_Toggle_TAD_Dlg), LLSTRING(Keybind_Toggle_TAD_Dlg_Hint)],
    { [QGVARMAIN(TAD_dlg)] call FUNC(toggleInterface) },
    "",
    KEYBIND_NULL
] call cba_fnc_addKeybind;

[
    [_categoryMod, _categoryTAD],
    QGVAR(TAD_dsp),
    [LLSTRING(Keybind_Toggle_microDAGR_Dsp), LLSTRING(Keybind_Toggle_TAD_Dsp_Hint)],
    { [QGVARMAIN(TAD_dsp)] call FUNC(toggleInterface) },
    "",
    KEYBIND_NULL
] call cba_fnc_addKeybind;
[
    [_categoryMod, _categoryFBCB2],
    QGVAR(FBCB2_dlg),
    [LLSTRING(Keybind_Toggle_FBCB2_Dlg), LLSTRING(Keybind_Toggle_FBCB2_Dlg_Hint)],
    { [QGVARMAIN(FBCB2_dlg)] call FUNC(toggleInterface) },
    "",
    KEYBIND_NULL
] call cba_fnc_addKeybind;
[
    [_categoryMod, _categoryTablet],
    QGVAR(Tablet_dlg),
    [LLSTRING(Keybind_Toggle_Tablet_Dlg), LLSTRING(Keybind_Toggle_Tablet_Dlg_Hint)],
    { [QGVARMAIN(Tablet_dlg)] call FUNC(toggleInterface) },
    "",
    KEYBIND_NULL
] call cba_fnc_addKeybind;
[
    _categoryMod,
    QGVAR(zoomIn),
    [LLSTRING(Keybind_ZoomIn), LLSTRING(Keybind_ZoomIn_Hint)],
    { [true /*zoom in*/] call FUNC(caseButtonsOnZoomPressed) },
    "",
    [DIK_PGUP, [true, true, false]],
    false
] call cba_fnc_addKeybind;

[
    _categoryMod,
    QGVAR(zoomOut),
    [LLSTRING(Keybind_ZoomOut), LLSTRING(Keybind_ZoomOut_Hint)],
    { [false /*zoom out*/] call FUNC(caseButtonsOnZoomPressed) },
    "",
    [DIK_PGDN, [true, true, false]],
    false
] call cba_fnc_addKeybind;

[
    _categoryMod,
    QGVAR(toggleIfPosition),
    [LLSTRING(Keybind_Toggle_Iface_Position), LLSTRING(Keybind_Toggle_Iface_Position_Hint)],
    { [] call FUNC(toggleIfPosition) },
    "",
    [DIK_HOME, [true, true, false]]
] call cba_fnc_addKeybind;
