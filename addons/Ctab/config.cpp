#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        // all we want to do here is ensure backwards compatibility
        requiredAddons[] = { "Ctab_main", "Ctab_data", "Ctab_ui", "Ctab_core" }; 
        author = AUTHORS;
        VERSION_CONFIG;
    };
};
