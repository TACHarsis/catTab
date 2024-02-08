#include "script_component.hpp"
/*
    Name: Ctab_ui_fnc_translateUserMarker
    Author(s):
        Gundy

    Description:
        Take the condensed user marker data and translate it so that it can be drawn much quicker
        Received marker data format:
            Index 0: ARRAY   - 2D marker position
            Index 1: INTEGER - number of icon
            Index 2: INTEGER - size type
            Index 3: INTEGER - octant of reported movement
            Index 4: STRING  - marker time
            Index 5: OBJECT  - marker creator
        Translated marker data format:
            Index 0: ARRAY  - marker position
            Index 1: STRING - path to marker icon
            Index 2: STRING - path to marker size icon
            Index 3: STRING - direction of reported movement
            Index 4: ARRAY  - marker color
            Index 5: STRING - marker time
            Index 6: STRING - text alignment
    Parameters:
        0: ARRAY - Marker data
    Returns:
        ARRAY - Translated marker data
    Example:
        [[1714.35,5716.82],0,0,0,"12:00"] call Ctab_ui_fnc_translateUserMarker;
*/
params ["_pos", "_markerIcon", "_markerSize", "_markerDir", "_text"];
private _color = GVAR(colorOPFOR);

private _texture1 = switch (_markerIcon) do {
    case (0)     : {"\A3\ui_f\data\map\markers\nato\o_inf.paa"};
    case (1)     : {"\A3\ui_f\data\map\markers\nato\o_mech_inf.paa"};
    case (2)     : {"\A3\ui_f\data\map\markers\nato\o_motor_inf.paa"};
    case (3)     : {"\A3\ui_f\data\map\markers\nato\o_armor.paa"};
    case (4)     : {"\A3\ui_f\data\map\markers\nato\o_air.paa";};
    case (5)     : {"\A3\ui_f\data\map\markers\nato\o_plane.paa"};
    case (6)     : {"\A3\ui_f\data\map\markers\nato\o_naval.paa"};
    case (7)     : {"\A3\ui_f\data\map\markers\nato\o_unknown.paa"};
    case (10)     : {QPATHTOEF(data,img\map\markers\o_inf_rifle.paa)};
    case (11)     : {QPATHTOEF(data,img\map\markers\o_inf_mg.paa)};
    case (12)     : {QPATHTOEF(data,img\map\markers\o_inf_at.paa)};
    case (13)     : {QPATHTOEF(data,img\map\markers\o_inf_mmg.paa)};
    case (14)     : {QPATHTOEF(data,img\map\markers\o_inf_mat.paa)};
    case (15)     : {QPATHTOEF(data,img\map\markers\o_inf_mmortar.paa)};
    case (16)     : {QPATHTOEF(data,img\map\markers\o_inf_aa.paa)};
    _color = GVAR(colorINDEPENDENT);
    case (20)     : {"\A3\ui_f\data\map\markers\military\join_CA.paa"};
    case (21)     : {"\A3\ui_f\data\map\markers\military\circle_CA.paa"};
    case (22)     : {"\A3\ui_f\data\map\mapcontrol\Hospital_CA.paa"};
    case (23)     : {"\A3\ui_f\data\map\markers\military\warning_CA.paa"};
    _color = GVAR(colorBLUFOR);
    case (30) : {"\A3\ui_f\data\map\markers\nato\b_hq.paa"};
    case (31) : {"\A3\ui_f\data\map\markers\military\end_CA.paa"};
    default {""};
};

private _texture2 = switch(_markerSize) do {
    case (0) : {""};
    case (1) : {"\A3\ui_f\data\map\markers\nato\group_0.paa"};
    case (2) : {"\A3\ui_f\data\map\markers\nato\group_1.paa"};
    case (3) : {"\A3\ui_f\data\map\markers\nato\group_2.paa"};
    case (4) : {"\A3\ui_f\data\map\markers\nato\group_3.paa"};
    case (5) : {"\A3\ui_f\data\map\markers\nato\group_4.paa"};
    case (6) : {"\A3\ui_f\data\map\markers\nato\group_5.paa"};

    default {""};
};

private _dir = switch(_markerDir) do {
    case (1) : {0};
    case (2) : {45};
    case (3) : {90};
    case (4) : {135};
    case (5) : {180};
    case (6) : {225};
    case (7) : {270};
    case (8) : {315};
    default {-1};
};

private _align = ["right", "left"] select (_dir > 0) && (_dir < 180);

[_pos,_texture1, GVAR(iconSize) + (_markerSize * 0.75), _texture2, GVAR(groupOverlayIconSize) + (_markerSize * 0.75 * 1.65), _dir, _color, _text, _align]
