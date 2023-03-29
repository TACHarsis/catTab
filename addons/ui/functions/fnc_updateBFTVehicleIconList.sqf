#include "script_component.hpp"

params ["_bftVehicleList"];
GVAR(bftVehicleIcons) = [];
{
    private _vehicle = _x;

    private _groudIdx = "";
    private _name = "";
    private _customName = _x getVariable [QGVARMAIN(groupId),""];
    if !(_customName isEqualTo "") then {
        _name = _customName;
    } else {
        if (group _x == _playerGroup) then {
            _groudIdx = str(groupId _x)
        };
        _name = groupID group _x;
    };
    private _unitIcon = "";
    private _type = "LAND";
    switch (true) do {
        case (_x isKindOf "MRAP_01_base_F")         : {_unitIcon = QPATHTOEF(data,img\map\markers\b_mech_inf_wheeled.paa);};
        case (_x isKindOf "MRAP_02_base_F")         : {_unitIcon = QPATHTOEF(data,img\map\markers\b_mech_inf_wheeled.paa);};
        case (_x isKindOf "MRAP_03_base_F")         : {_unitIcon = QPATHTOEF(data,img\map\markers\b_mech_inf_wheeled.paa);};
        case (_x isKindOf "Wheeled_APC_F")          : {_unitIcon = QPATHTOEF(data,img\map\markers\b_mech_inf_wheeled.paa);};
        case (_x isKindOf "Truck_F" && 
            {getNumber (configfile >> "cfgVehicles" >> typeOf _x >> "transportSoldier") > 2}) 
                                                    : {_unitIcon = "\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";};
        case (_x isKindOf "Truck_F")                : {_unitIcon = "\A3\ui_f\data\map\markers\nato\b_support.paa";};
        case (_x isKindOf "Car_F")                  : {_unitIcon = "\A3\ui_f\data\map\markers\nato\b_motor_inf.paa";};
        case (_x in allUnitsUav)                    : {_unitIcon = "\A3\ui_f\data\map\markers\nato\b_uav.paa";
                                                        _name = format["%1(UAV)",_name];};
        case (_x isKindOf "UAV_01_base_F")          : {_unitIcon = "\A3\ui_f\data\map\markers\nato\b_uav.paa";
                                                        _type = "Air"};
        case (_x isKindOf "Helicopter")             : {_unitIcon = "\A3\ui_f\data\map\markers\nato\b_air.paa"; 
                                                        _type = "Air"};
        case (_x isKindOf "Plane")                  : {_unitIcon = "\A3\ui_f\data\map\markers\nato\b_plane.paa"; 
                                                        _type = "Air"};
        case (_x isKindOf "Tank" && 
            {getNumber (configfile >> "cfgVehicles" >> typeOf _x >> "transportSoldier") > 6}) 
                                                    : {_unitIcon = "\A3\ui_f\data\map\markers\nato\b_mech_inf.paa";};
        case (_x isKindOf "MBT_01_arty_base_F")     : {_unitIcon = "\A3\ui_f\data\map\markers\nato\b_art.paa";};
        case (_x isKindOf "MBT_01_mlrs_base_F")     : {_unitIcon = "\A3\ui_f\data\map\markers\nato\b_art.paa";};
        case (_x isKindOf "MBT_02_arty_base_F")     : {_unitIcon = "\A3\ui_f\data\map\markers\nato\b_art.paa";};
        case (_x isKindOf "Tank")                   : {_unitIcon = "\A3\ui_f\data\map\markers\nato\b_armor.paa";};
        case (_x isKindOf "StaticMortar")           : {_unitIcon = "\A3\ui_f\data\map\markers\nato\b_mortar.paa";};
        default                                       {_unitIcon = "\A3\ui_f\data\map\markers\nato\b_unknown.paa"; };
    };

    GVAR(bftVehicleIcons) pushBack [_x,_name,_type,_unitIcon];
} foreach _bftVehicleList;
