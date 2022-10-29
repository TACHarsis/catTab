#define COMPONENT ui
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