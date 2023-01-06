#include "script_component.hpp"
#include "..\devices\shared\cTab_defines.hpp"

GVAR(settings) = createHashMap;

GVAR(settings) set [QSETTINGS_COMMON, createHashMapFromArray [
        [QSETTING_MODE,QSETTING_MODE_BFT],
        [QSETTING_MAP_SCALE_MIN,0.1],
        [QSETTING_MAP_SCALE_MAX,2 ^ round(sqrt(2666 * GVAR(mapScaleFactor) / 1024))]
    ]
];

GVAR(settings) set [QSETTINGS_MAIN,    [] ];

GVAR(settings) set [QSETTINGS_TABLET, createHashMapFromArray [
        [QSETTING_DEVICE_ENVIRONMENT,   QDEVICE_GROUND],
        [QSETTING_POSITION_DIALOG,      []],
        [QSETTING_MODE,                 QSETTING_MODE_DESKTOP],
        [QSETTING_SHOW_ICON_TEXT,       true],
        [QSETTING_MAP_WORLD_POS,        []],
        [QSETTING_MAP_SCALE_DISPLAY,    2],
        [QSETTING_MAP_SCALE_DIALOG,     2],
        [QSETTING_MAP_TYPES,            [
                                            [QMAP_TYPE_SAT,IDC_CTAB_SCREEN],
                                            [QMAP_TYPE_TOPO,IDC_CTAB_SCREEN_TOPO]
                                        ]],
        [QSETTING_CURRENT_MAP_TYPE,     QMAP_TYPE_SAT],
        [QSETTING_CAM_UAV,              ""],
        [QSETTING_FOLLOW_UAV,           false],
        [QSETTING_FOLLOW_HCAM,          false],
        [QSETTING_CAM_HELMET,           ""],
        [QSETTING_MAP_TOOLS,            true],
        [QSETTING_HOOK_REFERENCE_MODE,  true],
        [QSETTING_NIGHT_MODE,           2],
        [QSETTING_BRIGHTNESS,           0.9]
    ]
];

GVAR(settings) set [QSETTINGS_ANDROID, createHashMapFromArray [
        [QSETTING_DEVICE_ENVIRONMENT,   QDEVICE_GROUND],
        [QSETTING_POSITION_DIALOG,      []],
        [QSETTING_POSITION_DISPLAY,     false],
        [QSETTING_MODE,                 QSETTING_MODE_BFT],
        [QSETTING_SHOW_ICON_TEXT,       true],
        [QSETTING_MAP_WORLD_POS,        []],
        [QSETTING_MAP_SCALE_DISPLAY,    0.4],
        [QSETTING_MAP_SCALE_DIALOG,     0.4],
        [QSETTING_MAP_TYPES,            [
                                            [QMAP_TYPE_SAT,IDC_CTAB_SCREEN],
                                            [QMAP_TYPE_TOPO,IDC_CTAB_SCREEN_TOPO]
                                        ]],
        [QSETTING_CURRENT_MAP_TYPE,     QMAP_TYPE_SAT],
        [QSETTING_SHOW_MENU,            false],
        [QSETTING_MAP_TOOLS,            true],
        [QSETTING_HOOK_REFERENCE_MODE,  true],
        [QSETTING_NIGHT_MODE,           2],
        [QSETTING_BRIGHTNESS,           0.9]
    ]
];

GVAR(settings) set [QSETTINGS_FBCB2, createHashMapFromArray [
        [QSETTING_DEVICE_ENVIRONMENT,   QDEVICE_GROUND],
        [QSETTING_POSITION_DIALOG,      []],
        [QSETTING_MAP_WORLD_POS,        []],
        [QSETTING_SHOW_ICON_TEXT,       true],
        [QSETTING_MAP_SCALE_DISPLAY,    2],
        [QSETTING_MAP_SCALE_DIALOG,     2],
        [QSETTING_MAP_TYPES,            [
                                            [QMAP_TYPE_SAT,IDC_CTAB_SCREEN],
                                            [QMAP_TYPE_TOPO,IDC_CTAB_SCREEN_TOPO]
                                        ]],
        [QSETTING_CURRENT_MAP_TYPE,     QMAP_TYPE_SAT],
        [QSETTING_MAP_TOOLS,            true],
        [QSETTING_HOOK_REFERENCE_MODE,  true]
    ]
];

GVAR(settings) set [QSETTINGS_TAD, createHashMapFromArray [
        [QSETTING_DEVICE_ENVIRONMENT,   QDEVICE_AIR],
        [QSETTING_POSITION_DIALOG,      []],
        [QSETTING_POSITION_DISPLAY,     false],
        [QSETTING_MAP_WORLD_POS,        []],
        [QSETTING_SHOW_ICON_TEXT,       true],
        [QSETTING_MAP_SCALE_DISPLAY,    2],
        [QSETTING_MAP_SCALE_DIALOG,     2],
        [QSETTING_MAP_SCALE_MIN,        1],
        [QSETTING_MAP_TYPES,            [
                                            [QMAP_TYPE_SAT,IDC_CTAB_SCREEN],
                                            [QMAP_TYPE_TOPO,IDC_CTAB_SCREEN_TOPO],
                                            [QMAP_TYPE_BLACK,IDC_CTAB_SCREEN_BLACK]
                                        ]],
        [QSETTING_CURRENT_MAP_TYPE,     QMAP_TYPE_SAT],
        [QSETTING_MAP_TOOLS,            true],
        [QSETTING_HOOK_REFERENCE_MODE,  true],
        [QSETTING_NIGHT_MODE,           0],
        [QSETTING_BRIGHTNESS,           0.8]
    ]
];

GVAR(settings) set [QSETTINGS_MICRODAGR, createHashMapFromArray [
        [QSETTING_DEVICE_ENVIRONMENT,   QDEVICE_GROUND],
        [QSETTING_POSITION_DIALOG,      []],
        [QSETTING_POSITION_DISPLAY,     false],
        [QSETTING_MAP_WORLD_POS,        []],
        [QSETTING_SHOW_ICON_TEXT,       true],
        [QSETTING_MAP_SCALE_DISPLAY,    0.4],
        [QSETTING_MAP_SCALE_DIALOG,     0.4],
        [QSETTING_MAP_TYPES,            [
                                            [QMAP_TYPE_SAT,IDC_CTAB_SCREEN],
                                            [QMAP_TYPE_TOPO,IDC_CTAB_SCREEN_TOPO]
                                        ]],
        [QSETTING_CURRENT_MAP_TYPE,     QMAP_TYPE_SAT],
        [QSETTING_MAP_TOOLS,            true],
        [QSETTING_HOOK_REFERENCE_MODE,  true],
        [QSETTING_NIGHT_MODE,           2],
        [QSETTING_BRIGHTNESS,           0.9]
    ]
];

