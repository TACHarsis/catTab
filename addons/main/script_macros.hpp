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
