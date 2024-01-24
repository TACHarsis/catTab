class Extended_PreStart_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preStart));
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
        clientInit = QUOTE(call COMPILE_FILE(XEH_preInit_client));
        serverInit = QUOTE(call COMPILE_FILE(XEH_preInit_server));       
    };
};

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_postInit));
    };
};

class Extended_Respawn_EventHandlers {
    class CAManBase {
        class ADDON {
            clientRespawn = QUOTE(call FUNC(onPlayerRespawned));
        };
    };
};
