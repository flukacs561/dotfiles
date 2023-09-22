#!/run/current-system/sw/bin/bash
# Ennek tényleg bash-nek kell lennie, különben nem működik
# (gondolom az awk nem POSIX parancs...)

NUM=$(awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget Master));

echo -e ${NUM}
