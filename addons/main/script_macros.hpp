#include "\x\cba\addons\main\script_macros_common.hpp"

#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)

#ifdef DISABLE_COMPILE_CACHE
    #undef PREP
    #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
    #undef PREP
    #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

#define LEGACY_AUTHOR "Gundy, Riouken , Raspu"
#define AUTHORS "Cat Harsis, Gundy, Riouken, Raspu"

#define MACRO_ADDITEM(ITEM,COUNT) class _xx_##ITEM { \
    name = #ITEM; \
    count = COUNT; \
}

#define MACRO_GROUND_HOLDER(OBJECT,DISPLAYNAME) class DOUBLES(OBJECT,gh) : DOUBLES(OBJECT,gh) { \
    displayName = DISPLAYNAME; \
    class TransportItems { \
        MACRO_ADDITEM(OBJECT),1); \
    }; \
}

// AFM macros
#define IS_MOD_LOADED(modclass)     (isClass (configFile >> "CfgPatches" >> #modclass))

// global defs
#define VIDEO_FEED_TYPE_UAV QUOTE(uav_type)
#define VIDEO_FEED_TYPE_HCAM QUOTE(hCam_type)

#define GROUPS QUOTE(groups)
#define SOURCES QUOTE(sources)
#define NAMENESS QUOTE(name)
#define ALIVENESS QUOTE(alive)
#define HELMET QUOTE(cameraHelmet)
#define ITEM QUOTE(cameraItem)
#define GROUPNESS QUOTE(group)
#define SIDENESS QUOTE(group)
#define STATUS QUOTE(cameraStatus)
#define OFFLINE         0
#define ONLINE          1
#define DESTROYED       2
#define LOST            3
