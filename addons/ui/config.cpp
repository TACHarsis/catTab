#include "script_component.hpp"
// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"Ctab_core", "Ctab_data"};
        author = AUTHORS;
        authorUrl = "https://github.com/TACHarsis/catTab";
        VERSION_CONFIG;
    };
};

//#pragma hemtt suppress pw3_padded_arg config

#include "CfgEventHandlers.hpp"
#include "CfgNotifications.hpp"
#include "devices\devices.hpp"
#include "RscTitles.hpp"
#include "CfgUIGrids.hpp"
