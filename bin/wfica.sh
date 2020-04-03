#!/usr/bin/env bash

OUTPUT=$(xrandr | grep ' connected' | cut -f1 -d' ')
MODE=$(xrandr | grep ' connected' | cut -f3 -d' ')
MODE=${MODE:0:-4}

xrandr -d $DISPLAY --output $OUTPUT --mode 1920x1080
/opt/Citrix/ICAClient/wfica.sh "$@"
xrandr -d $DISPLAY --output $OUTPUT --mode $MODE
