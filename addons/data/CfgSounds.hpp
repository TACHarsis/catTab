class CfgSounds {
    sounds[] = {};
    class GVARMAIN(phoneVibrate) {
        // filename, volume, pitch
        sound[] = {QPATHTOF(sounds\phoneVibrate.wss),1,1};
        // subtitle delay in seconds, subtitle text 
        titles[] = {};
    };
    class GVARMAIN(mailSent) {
        sound[] = {QPATHTOF(sounds\mailSent.wss),1,1};
        titles[] = {};
    };
};
