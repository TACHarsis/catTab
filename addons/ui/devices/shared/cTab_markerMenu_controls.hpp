class MainSubmenu: cTab_RscControlsGroup {
    #undef cTab_MENU_MAX_ELEMENTS
    #ifndef cTab_IS_TABLET
        #define cTab_MENU_MAX_ELEMENTS 4
    #else
        #define cTab_MENU_MAX_ELEMENTS 5
    #endif
    idc = IDC_CTAB_MARKER_MENU_MAIN;
    x = QUOTE(MENU_X);
    y = QUOTE(MENU_Y);
    w = QUOTE(MENU_W);
    h = QUOTE(MENU_H(cTab_MENU_MAX_ELEMENTS));
    class controls {
        class mainbg: cTab_IGUIBack {
            idc = IDC_USRMN_MAINBG;
            x = QUOTE(0);
            y = QUOTE(0);
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_H(cTab_MENU_MAX_ELEMENTS));
        };
        class op4btn: cTab_MenuItem {
            idc = IDC_USRMN_OP4BTN;
            text = "Enemy SALUTE"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(1));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE([11] call FUNC(userMenuSelect));
        };
        class medbtn: cTab_MenuItem {
            idc = IDC_USRMN_MEDBTN;
            text = "Medical"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(2));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE([21] call FUNC(userMenuSelect));
        };
        class genbtn: cTab_MenuItem {
            idc = IDC_USRMN_GENBTN;
            text = "General"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(3));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE([31] call FUNC(userMenuSelect));
        };
        #ifdef cTab_IS_TABLET
            class lockUavCam: cTab_MenuItem {
                idc = ICD_USRMN_LOCKBTN;
                text = "Lock UAV Cam"; //--- ToDo: Localize;
                toolTip = "Lock UAV Cam to this position, a UAV has to be previously selected, del on lock to release";
                x = QUOTE(0);
                y = QUOTE(MENU_elementY(4));
                w = QUOTE(MENU_W);
                h = QUOTE(MENU_elementH);
                sizeEx = QUOTE(MENU_sizeEx);
                action = QUOTE([2] call FUNC(userMenuSelect));
            };
        #endif
        class exit: cTab_MenuExit {
            idc = -1;
            text = "Exit"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(cTab_MENU_MAX_ELEMENTS));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE([0] call FUNC(userMenuSelect));
        };
    };
};

class EnemySub1: cTab_RscControlsGroup {
    #undef cTab_MENU_MAX_ELEMENTS
    #define cTab_MENU_MAX_ELEMENTS 9
    idc = IDC_CTAB_MARKER_MENU_ENYSUB1;
    x = QUOTE(MENU_X);
    y = QUOTE(MENU_Y);
    w = QUOTE(MENU_W);
    h = QUOTE(MENU_H(cTab_MENU_MAX_ELEMENTS));
    class controls {
        class IGUIBack_2201: cTab_IGUIBack {
            idc = IDC_USRMN_ENY_IGUIBACK;
            x = QUOTE(0);
            y = QUOTE(0);
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_H(cTab_MENU_MAX_ELEMENTS));
        };
        class infbtn: cTab_MenuItem {
            idc = IDC_USRMN_INFBTN;
            text = "Infantry"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(1));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,0)];[12] call FUNC(userMenuSelect));
        };
        class mecinfbtn: cTab_MenuItem {
            idc = IDC_USRMN_MECINFBTN;
            text = "Mechanized Inf"; //--- ToDo: Localize;
            toolTip = "Equipped with APCs/IFVs";
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(2));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,1)];[12] call FUNC(userMenuSelect));
        };

        class motrinfbtn: cTab_MenuItem {
            idc = IDC_USRMN_MOTRINFBTN;
            text = "Motorized Inf"; //--- ToDo: Localize;
            toolTip = "Equipped with un-protected vehicles";
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(3));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,2)];[12] call FUNC(userMenuSelect));
        };
        class amrbtn: cTab_MenuItem {
            idc = IDC_USRMN_AMRBTN;
            text = "Armor"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(4));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,3)];[12] call FUNC(userMenuSelect));
        };
        class helibtn: cTab_MenuItem {
            idc = IDC_USRMN_HELIBTN;
            text = "Helicopter"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(5));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,4)];[12] call FUNC(userMenuSelect));
        };
        class plnbtn: cTab_MenuItem {
            idc = IDC_USRMN_PLNBTN;
            text = "Plane"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(6));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,5)];[12] call FUNC(userMenuSelect));
        };
        class nvlbtn: cTab_MenuItem {
            idc = IDC_USRMN_NVLBTN;
            text = "Naval"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(7));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,6)];[12] call FUNC(userMenuSelect));
        };
        class uknbtn: cTab_MenuItem {
            idc = IDC_USRMN_UKNBTN;
            text = "Unknown"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(8));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,7)];[12] call FUNC(userMenuSelect));
        };
        class exit: cTab_MenuExit {
            idc = -1;
            text = "Exit"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(cTab_MENU_MAX_ELEMENTS));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE([0] call FUNC(userMenuSelect));
        };
    };
};

class EnemySub2: cTab_RscControlsGroup {
    #undef cTab_MENU_MAX_ELEMENTS
    #define cTab_MENU_MAX_ELEMENTS 8
    idc = IDC_CTAB_MARKER_MENU_ENYSUB2;
    x = QUOTE(MENU_X);
    y = QUOTE(MENU_Y);
    w = QUOTE(MENU_W);
    h = QUOTE(MENU_H(cTab_MENU_MAX_ELEMENTS));
    class controls {
        class IGUIBack_2202: cTab_IGUIBack {
            idc = IDC_USRMN_ENY_IGUIBACK;
            x = QUOTE(0);
            y = QUOTE(0);
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_H(cTab_MENU_MAX_ELEMENTS));
        };
        class ftbtn: cTab_MenuItem {
            idc = IDC_USRMN_FTBTN;
            text = "Singular"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(1));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE([14] call FUNC(userMenuSelect));
        };
        class patbtn: cTab_MenuItem {
            idc = IDC_USRMN_PATBTN;
            text = "Patrol"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(2));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(2,1)];[13] call FUNC(userMenuSelect));
        };
        class sqdbtn: cTab_MenuItem {
            idc = IDC_USRMN_SQDBTN;
            text = "Squad"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(3));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(2,2)];[13] call FUNC(userMenuSelect));
        };
        class sctbtn: cTab_MenuItem {
            idc = IDC_USRMN_SCTBTN;
            text = "Section"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(4));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(2,3)];[13] call FUNC(userMenuSelect));
        };
        class pltnbtn: cTab_MenuItem {
            idc = IDC_USRMN_PLTNBTN;
            text = "Platoon"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(5));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(2,4)];[13] call FUNC(userMenuSelect));
        };
        class cpnynbtn: cTab_MenuItem {
            idc = IDC_USRMN_CPNYBTN;
            text = "Company"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(6));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(2,5)];[13] call FUNC(userMenuSelect));
        };
        class btlnbtn: cTab_MenuItem {
            idc = IDC_USRMN_BTNYBTN;
            text = "Battalion"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(7));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(2,6)];[13] call FUNC(userMenuSelect));
        };
        class exit: cTab_MenuExit {
            idc = -1;
            text = "Exit"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(cTab_MENU_MAX_ELEMENTS));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE([0] call FUNC(userMenuSelect));
        };
    };
};

class EnemySub3: cTab_RscControlsGroup {
    #undef cTab_MENU_MAX_ELEMENTS
    #define cTab_MENU_MAX_ELEMENTS 10
    idc = IDC_CTAB_MARKER_MENU_ENYSUB3;
    x = QUOTE(MENU_X);
    y = QUOTE(MENU_Y);
    w = QUOTE(MENU_W);
    h = QUOTE(MENU_H(cTab_MENU_MAX_ELEMENTS));
    class controls {
        class IGUIBack_2203: cTab_IGUIBack {
            idc = IDC_USRMN_ENY_IGUIBACK;
            x = QUOTE(0);
            y = QUOTE(0);
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_H(cTab_MENU_MAX_ELEMENTS));
        };
        class stnbtn: cTab_MenuItem {
            idc = IDC_USRMN_STNBTN;
            text = "Stationary"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(1));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE([1] call FUNC(userMenuSelect));
        };
        class nthbtn: cTab_MenuItem {
            idc = IDC_USRMN_NTHBTN;
            text = "N"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(2));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(3,1)];[1] call FUNC(userMenuSelect));
        };
        class nebtn: cTab_MenuItem {
            idc = IDC_USRMN_NEBTN;
            text = "NE"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(3));
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(3,2)];[1] call FUNC(userMenuSelect));
        };
        class ebtn: cTab_MenuItem {
            idc = IDC_USRMN_EBTN;
            text = "E"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(4));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(3,3)];[1] call FUNC(userMenuSelect));
        };
        class sebtn: cTab_MenuItem {
            idc = IDC_USRMN_SEBTN;
            text = "SE"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(5));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(3,4)];[1] call FUNC(userMenuSelect));
        };
        class sbtn: cTab_MenuItem {
            idc = IDC_USRMN_SBTN;
            text = "S"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(6));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(3,5)];[1] call FUNC(userMenuSelect));
        };
        class swbtn: cTab_MenuItem {
            idc = IDC_USRMN_SWBTN;
            text = "SW"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(7));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(3,6)];[1] call FUNC(userMenuSelect));
        };
        class wbtn: cTab_MenuItem {
            idc = IDC_USRMN_WBTN;
            text = "W"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(8));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(3,7)];[1] call FUNC(userMenuSelect));
        };
        class RscText_1022: cTab_MenuItem {
            idc = IDC_USRMN_NWBTN;
            text = "NW"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(9));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(3,8)];[1] call FUNC(userMenuSelect));
        };
        class exit: cTab_MenuExit {
            idc = -1;
            text = "Exit"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(cTab_MENU_MAX_ELEMENTS));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE([0] call FUNC(userMenuSelect));
        };
    };
};

class EnemySub4: cTab_RscControlsGroup {
    #undef cTab_MENU_MAX_ELEMENTS
    #define cTab_MENU_MAX_ELEMENTS 8
    idc = IDC_CTAB_MARKER_MENU_ENYSUB4;
    x = QUOTE(MENU_X);
    y = QUOTE(MENU_Y);
    w = QUOTE(MENU_W);
    h = QUOTE(MENU_H(cTab_MENU_MAX_ELEMENTS));
    class controls {
        class IGUIBack_2202: cTab_IGUIBack {
            idc = IDC_USRMN_ENY_IGUIBACK;
            x = QUOTE(0);
            y = QUOTE(0);
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_H(cTab_MENU_MAX_ELEMENTS));
        };
        class rifle_btn: cTab_MenuItem {
            idc = -1;
            text = "Rifle"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(1));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,10)];[13] call FUNC(userMenuSelect));
        };
        class lmg_btn: cTab_MenuItem {
            idc = -1;
            text = "MG"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(2));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,11)];[13] call FUNC(userMenuSelect));
        };
        class at_btn: cTab_MenuItem {
            idc = -1;
            text = "AT"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(3));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,12)];[13] call FUNC(userMenuSelect));
        };
        class mmg_btn: cTab_MenuItem {
            idc = -1;
            text = "Static MG"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(4));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,13)];[13] call FUNC(userMenuSelect));
        };
        class mat_btn: cTab_MenuItem {
            idc = -1;
            text = "Static AT"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(5));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,14)];[13] call FUNC(userMenuSelect));
        };
        class aa_btn: cTab_MenuItem {
            idc = -1;
            text = "Static AA"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(6));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,15)];[13] call FUNC(userMenuSelect));
        };
        class mmortar_btn: cTab_MenuItem {
            idc = -1;
            text = "Mortar"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(7));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,12)];[13] call FUNC(userMenuSelect));
        };
        class exit: cTab_MenuExit {
            idc = -1;
            text = "Exit"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(cTab_MENU_MAX_ELEMENTS));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE([0] call FUNC(userMenuSelect));
        };
    };
};

class CasulSub1: cTab_RscControlsGroup {
    #undef cTab_MENU_MAX_ELEMENTS
    #define cTab_MENU_MAX_ELEMENTS 5
    idc = IDC_CTAB_MARKER_MENU_CASUSUB1;
    x = QUOTE(MENU_X);
    y = QUOTE(MENU_Y);
    w = QUOTE(MENU_W);
    h = QUOTE(MENU_H(cTab_MENU_MAX_ELEMENTS));
    class controls {
        class IGUIBack_2204: cTab_IGUIBack {
            idc = IDC_USRMN_CASU_IGUIBACK;
            x = QUOTE(0);
            y = QUOTE(0);
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_H(cTab_MENU_MAX_ELEMENTS));
        };
        class casltybtn: cTab_MenuItem {
            idc = IDC_USRMN_CASLTYBTN;
            text = "Casualty"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(1));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,20)];[1] call FUNC(userMenuSelect));
        };
        class ccpbtn: cTab_MenuItem {
            idc = IDC_USRMN_CCPBTN;
            text = "CCP"; //--- ToDo: Localize;
            toolTip = "Casualty Collection Point";
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(2));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,21)];[1] call FUNC(userMenuSelect));
        };
        class basbtn: cTab_MenuItem {
            idc = IDC_USRMN_BASBTN;
            text = "BAS"; //--- ToDo: Localize;
            toolTip = "Battalion Aid Station";
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(3));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,22)];[1] call FUNC(userMenuSelect));
        };
        // Mass Casualty Incident
        class mcibtn: cTab_MenuItem {
            idc = IDC_USRMN_MCIBTN;
            text = "MCI"; //--- ToDo: Localize;
            toolTip = "Mass Casualty Incident";
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(4));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,23)];[1] call FUNC(userMenuSelect));
        };
        class exit: cTab_MenuExit {
            idc = -1;
            text = "Exit"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(cTab_MENU_MAX_ELEMENTS));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE([0] call FUNC(userMenuSelect));
        };
    };
};

class GenSub1: cTab_RscControlsGroup {
    #undef cTab_MENU_MAX_ELEMENTS
    #define cTab_MENU_MAX_ELEMENTS 3
    idc = IDC_CTAB_MARKER_MENU_GENSUB1;
    x = QUOTE(MENU_X);
    y = QUOTE(MENU_Y);
    w = QUOTE(MENU_W);
    h = QUOTE(MENU_H(cTab_MENU_MAX_ELEMENTS));
    class controls {
        class IGUIBack_2205: cTab_IGUIBack {
            idc = IDC_USRMN_GEN_IGUIBACK;
            x = QUOTE(0);
            y = QUOTE(0);
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_H(cTab_MENU_MAX_ELEMENTS));
        };
        class hqbtn: cTab_MenuItem {
            idc = IDC_USRMN_HQBTN;
            text = "HQ"; //--- ToDo: Localize;
            toolTip = "Headquaters";
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(1));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,30)];[1] call FUNC(userMenuSelect));
        };
        class lzbtn: cTab_MenuItem {
            idc = IDC_USRMN_LZBTN;
            text = "LZ"; //--- ToDo: Localize;
            toolTip = "Landing Zone";
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(2));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE(GVAR(cTabUserSelIcon) set [ARR_2(1,31)];[1] call FUNC(userMenuSelect));
        };
        class exit: cTab_MenuExit {
            idc = -1;
            text = "Exit"; //--- ToDo: Localize;
            x = QUOTE(0);
            y = QUOTE(MENU_elementY(cTab_MENU_MAX_ELEMENTS));
            w = QUOTE(MENU_W);
            h = QUOTE(MENU_elementH);
            sizeEx = QUOTE(MENU_sizeEx);
            action = QUOTE([0] call FUNC(userMenuSelect));
        };
    };
};
