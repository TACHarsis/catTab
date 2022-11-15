#include "script_component.hpp"

params ["_bftGroupList"];
GVAR(bftGroupIcons) = [];
{
    _x params ["_group", "_leader"];
    
    _groupSize = count units _group;
    _sizeIcon = switch (true) do {
        case (_groupSize <= 3) : {"\A3\ui_f\data\map\markers\nato\group_0.paa"};
        case (_groupSize <= 9) : {"\A3\ui_f\data\map\markers\nato\group_1.paa"};
        default {"\A3\ui_f\data\map\markers\nato\group_2.paa"};
    };
    GVAR(bftGroupIcons) pushBack [_group, _leader, "\A3\ui_f\data\map\markers\nato\b_inf.paa",_sizeIcon];
} foreach _bftGroupList;
