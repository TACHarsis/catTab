class CfgVehicles {
    class Box_NATO_WpsSpecial_F;
    class Box_cTab_items : Box_NATO_WpsSpecial_F {
        displayname = "[cTab] Computer Gear";
        icon = "iconCrateLarge";
        model = "\A3\weapons_F\AmmoBoxes\WpnsBox_large_F";
        scope = 2;
        transportmaxmagazines = 64;
        transportmaxweapons = 12;
        
        class TransportItems {
            MACRO_ADDITEM(ItemcTab,5);
            MACRO_ADDITEM(ItemAndroid,15);
            MACRO_ADDITEM(ItemMicroDAGR,25);
            MACRO_ADDITEM(ItemcTabHCam,25);
        };
        
        class TransportMagazines {};
        class TransportWeapons {};
    };
};
