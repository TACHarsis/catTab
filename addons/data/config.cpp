#include "script_component.hpp"
// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {  };
        weapons[] = {
            "ItemcTab",
            "ItemAndroid",
            "ItemMicroDAGR",
            "ItemcTabHCam"
        };
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"ctab_main"};
        author = AUTHORS;
        authorUrl = "https://github.com/TACHarsis/catTab";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"
#include "CfgSounds.hpp"
#include "CtabHelmetClasses.hpp"
#include "CtabVehicleClasses.hpp"
