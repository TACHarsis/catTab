#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {  };
        author = AUTHORS;
        VERSION_CONFIG;
    };
};

class CfgMods {
    class PREFIX {
        dir = "@CatTab";
        name = "Cat's advanced tactical Commander Tablets - cTab rework";
        //picture = QPATHTOEF(data,img\cTab_BFT_ico.paa);
        picture = "title_co.paa";
        hidePicture = "True";
        hideName = "True";
        actionName = "Website";
        action = "https://github.com/TACHarsis/catTab";
        overview = "Commander's Tablet / FBCB2 - Blue Force Tracking\nBattlefield tablet to access real time intel and blue force tracker.";
        tooltip = "Commander's Tablet / FBCB2 - Blue Force Tracking";
        author = AUTHORS;
    };
};
