#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = { "Ctab_core", "Ctab_data", "Ctab_ui" };
        author = AUTHORS;
        VERSION_CONFIG;
    };
};

class CfgMods {
    class PREFIX {
        dir = "@CatTab";
        name = "Cat's advanced tactical Commander tablets - cTab rework";
        //picture = QPATHTOEF(data,img\cTab_BFT_ico.paa);
        picture = "title_co.paa";
        hidePicture = "True";
        hideName = "True";
        actionName = "Website";
        action = "https://github.com/TACHarsis/catTab";
        overview = "Cat's advanced tactical Commander tablets / FBCB2 - Blue Force Tracking\nBattlefield tablet to access real time intel and blue force tracker.";
        tooltip = "Cat's advanced tactical Commander tablets / FBCB2 - Blue Force Tracking";
        author = AUTHORS;
    };
};
