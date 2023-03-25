#define COMPONENT ui
#define COMPONENT_BEAUTIFIED UI
#include "\z\Ctab\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_UI
    #define DEBUG_MODE_FULL
#endif
    #ifdef DEBUG_SETTINGS_UI
    #define DEBUG_SETTINGS DEBUG_SETTINGS_UI
#endif

#include "\z\Ctab\addons\main\script_macros.hpp"
#include "settings_macros.hpp"

#define POS_X(pos) (pos select 0)
#define POS_Y(pos) (pos select 1)
#define POS_W(pos) (pos select 2)
#define POS_H(pos) (pos select 3)

#define GROUP_X(pos) (pos select 0)
#define GROUP_Y(pos) (pos select 1)
#define GROUP_W(pos) (pos select 2)
#define GROUP_H(pos) (pos select 3)
#define CONTENT_X(pos) (pos select 4)
#define CONTENT_Y(pos) (pos select 5)
