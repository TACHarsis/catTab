#define COMPONENT ui
#define COMPONENT_BEAUTIFIED UI
#include "\z\Ctab\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_UI
    #define DEBUG_MODE_FULL
#endif
    #ifdef DEBUG_SETTINGS_UI
    #define DEBUG_SETTINGS DEBUG_SETTINGS_UI
#endif

#include "\z\Ctab\addons\main\script_macros.hpp"
#include "settings_macros.hpp"

#define POS_X(pos) (pos select 0)
#define POS_Y(pos) (pos select 1)
#define POS_W(pos) (pos select 2)
#define POS_H(pos) (pos select 3)

#define GROUP_X(pos) (pos select 0)
#define GROUP_Y(pos) (pos select 1)
#define GROUP_W(pos) (pos select 2)
#define GROUP_H(pos) (pos select 3)
#define CONTENT_X(pos) (pos select 4)
#define CONTENT_Y(pos) (pos select 5)

#define ARMA_UI_RATIO 1.3333333333333

#define R2T_METHOD_SHRINK   0
#define R2T_METHOD_ZOOMCROP 1
#define NUM_R2T_METHODS     2

#define DO_NOT_ALIGN        -1
#define ALIGN_CENTERLEFT    0
#define ALIGN_CENTER        1
#define ALIGN_CENTERRIGHT   2
#define ALIGN_UPLEFT        3
#define ALIGN_UPCENTER      4
#define ALIGN_UPRIGHT       5
#define ALIGN_LOLEFT        6
#define ALIGN_LOCENTER      7
#define ALIGN_LORIGHT       8
#define NUM_ALIGNMENTS      9

#define FEED_CONTROLLER     QUOTE(FeedController)
#define FEED_NAME           QUOTE(FeedName)
#define HEARTBEAT_ICON      QUOTE(FeedHBIcon)
#define HEARTBEAT_TEXT      QUOTE(FeedHBText)

#define DEVICE_KEY_ORDER_MAIN       0
#define DEVICE_KEY_ORDER_SECONDARY  1
#define DEVICE_KEY_ORDER_TERTIARY   2
#define DEVICE_KEY_ORDER_ACE        3
#define DEVICE_KEY_ORDER_COUNT      4
