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

// Additional DIK codes usable with addKeybind
//      0xFA    :   Custom user action 1            0x104   :  Custom user action 11        0xF0    :   Left mouse button
//      0xFB    :   Custom user action 2            0x105   :  Custom user action 12        0xF1    :   Right mouse button
//      0xFC    :   Custom user action 3            0x106   :  Custom user action 13        0xF2    :   Middle mouse button
//      0xFD    :   Custom user action 4            0x107   :  Custom user action 14        0xF3    :   Mouse #4
//      0xFE    :   Custom user action 5            0x108   :  Custom user action 15        0xF4    :   Mouse #5
//      0xFF    :   Custom user action 6            0x109   :  Custom user action 16        0xF5    :   Mouse #6
//      0x100   :  Custom user action 7             0x10A   :  Custom user action 17        0xF6    :   Mouse #7
//      0x101   :  Custom user action 8             0x10B   :  Custom user action 18        0xF7    :   Mouse #8
//      0x102   :  Custom user action 9             0x10C   :  Custom user action 19        0xF8    :   Mouse wheel up
//      0x103   :  Custom user action 10            0x10D   :  Custom user action 20        0xF9    :   Mouse wheel down

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
    {[DEVICE_KEY_ORDER_MAIN] call FUNC(onIfButtonPressed)},
    "",
    [DIK_H, [false, false, false]]
] call cba_fnc_addKeybind;

[
    _categoryMod,
    QGVAR(ifSecondary),
    [LLSTRING(Keybind_Iface_Secondary), LLSTRING(Keybind_Iface_Secondary_Hint)],
    {[DEVICE_KEY_ORDER_SECONDARY] call FUNC(onIfButtonPressed)},
    "",
    [DIK_H, [false, true, false]]
] call cba_fnc_addKeybind;

[
    _categoryMod,
    QGVAR(ifTertiary),
    [LLSTRING(Keybind_Iface_Tertiary), LLSTRING(Keybind_Iface_Tertiary_Hint)],
    {[DEVICE_KEY_ORDER_TERTIARY] call FUNC(onIfButtonPressed)},
    "",
    [DIK_H, [false, false, true]]
] call cba_fnc_addKeybind;

[
    [_categoryMod, _categoryAndroid],
    QGVAR(android_dlg),
    [LLSTRING(Keybind_Toggle_Android_Dlg), LLSTRING(Keybind_Toggle_Android_Dlg_Hint)],
    {[QGVARMAIN(Android_dlg), QITEM_ANDROID] call FUNC(toggleInterface)},
    "",
    KEYBIND_NULL
] call cba_fnc_addKeybind;
[
    [_categoryMod, _categoryAndroid],
    QGVAR(android_dsp),
    [LLSTRING(Keybind_Toggle_Android_Dsp), LLSTRING(Keybind_Toggle_Android_Dsp_Hint)],
    {[QGVARMAIN(Android_dsp), QITEM_ANDROID] call FUNC(toggleInterface)},
    "",
    KEYBIND_NULL
] call cba_fnc_addKeybind;

[
    [_categoryMod, _categoryMicroDAGR],
    QGVAR(microDAGR_dlg),
    [LLSTRING(Keybind_Toggle_microDAGR_Dlg), LLSTRING(Keybind_Toggle_microDAGR_Dlg_Hint)],
    {[QGVARMAIN(microDAGR_dlg), QITEM_MICRODAGR] call FUNC(toggleInterface)},
    "",
    KEYBIND_NULL
] call cba_fnc_addKeybind;
[
    [_categoryMod, _categoryMicroDAGR],
    QGVAR(microDAGR_dsp),
    [LLSTRING(Keybind_Toggle_microDAGR_Dsp), LLSTRING(Keybind_Toggle_microDAGR_Dsp_Hint)],
    {[QGVARMAIN(microDAGR_dsp), QITEM_MICRODAGR] call FUNC(toggleInterface)},
    "",
    KEYBIND_NULL
] call cba_fnc_addKeybind;

[
    [_categoryMod, _categoryTAD],
    QGVAR(TAD_dlg),
    [LLSTRING(Keybind_Toggle_TAD_Dlg), LLSTRING(Keybind_Toggle_TAD_Dlg_Hint)],
    {[QGVARMAIN(TAD_dlg), "", QSETTINGS_TAD] call FUNC(toggleInterface)},
    "",
    KEYBIND_NULL
] call cba_fnc_addKeybind;
[
    [_categoryMod, _categoryTAD],
    QGVAR(TAD_dsp),
    [LLSTRING(Keybind_Toggle_TAD_Dsp), LLSTRING(Keybind_Toggle_TAD_Dsp_Hint)],
    {
        [QGVARMAIN(TAD_dsp), "", QSETTINGS_TAD] call FUNC(toggleInterface)},
    "",
    KEYBIND_NULL
] call cba_fnc_addKeybind;

[
    [_categoryMod, _categoryFBCB2],
    QGVAR(FBCB2_dlg),
    [LLSTRING(Keybind_Toggle_FBCB2_Dlg), LLSTRING(Keybind_Toggle_FBCB2_Dlg_Hint)],
    {[QGVARMAIN(FBCB2_dlg), "", QSETTINGS_FBCB2] call FUNC(toggleInterface)},
    "",
    KEYBIND_NULL
] call cba_fnc_addKeybind;

[
    [_categoryMod, _categoryTablet],
    QGVAR(Tablet_dlg),
    [LLSTRING(Keybind_Toggle_Tablet_Dlg), LLSTRING(Keybind_Toggle_Tablet_Dlg_Hint)],
    {[QGVARMAIN(Tablet_dlg), QITEM_TABLET] call FUNC(toggleInterface)},
    "",
    KEYBIND_NULL
] call cba_fnc_addKeybind;

[
    _categoryMod,
    QGVAR(zoomIn),
    [LLSTRING(Keybind_ZoomIn), LLSTRING(Keybind_ZoomIn_Hint)],
    {[true /*zoom in*/] call FUNC(caseButtonsOnZoomPressed)},
    "",
    [DIK_PGUP, [true, true, false]],
    false
] call cba_fnc_addKeybind;

[
    _categoryMod,
    QGVAR(zoomOut),
    [LLSTRING(Keybind_ZoomOut), LLSTRING(Keybind_ZoomOut_Hint)],
    {[false /*zoom out*/] call FUNC(caseButtonsOnZoomPressed)},
    "",
    [DIK_PGDN, [true, true, false]],
    false
] call cba_fnc_addKeybind;

[
    _categoryMod,
    QGVAR(toggleIfPosition),
    [LLSTRING(Keybind_Toggle_Iface_Position), LLSTRING(Keybind_Toggle_Iface_Position_Hint)],
    {[] call FUNC(toggleIfPosition)},
    "",
    [DIK_HOME, [true, true, false]]
] call cba_fnc_addKeybind;
