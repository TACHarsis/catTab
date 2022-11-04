#include "script_component.hpp"
// cTab - Commander's Tablet with FBCB2 Blue Force Tracking
// Battlefield tablet to access real time intel and blue force tracker.
// By - Riouken
// http://forums.bistudio.com/member.php?64032-Riouken
// You may re-use any of this work as long as you provide credit back to me.

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"Ctab_main", "cba_settings"};
        author = AUTHORS;
        authorUrl = "https://github.com/TACHarsis/catTab";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgNotifications.hpp"
#include "devices\devices.hpp"
#include "RscTitles.hpp"
#include "CfgUIGrids.hpp"
