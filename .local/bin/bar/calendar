LABEL="${LABEL:-}"
DATEFTM=${DateFMT:-"+%m/%d/%Y %I:%M:%S %P"}
blockdate=$(date "$DATEFTM")

year=$(date '+%Y')
month=$(date '+%m')
(( month == 12 )) && month=1 && year=$((year + 1)) || month=$((month + 1))
date=$(cal $month $year | sed -n '1s/^  *//;1s/  *$//p')
case "$BLOCK_BUTTON" in
    1|2|3)
cal --color=always $month $year \
    | sed 's/\x1b\[[7;]*m/\<b\>\<u\>/g' \
    | sed 's/\x1b\[[27;]*m/\<\/u\>\<\/b\>/g' \
    | tail -n +2 \
    | rofi \
        -dmenu \
        -markup-rows \
        -no-fullscreen \
        -font "Monospace 11" \
        -hide-scrollbar \
        -bw 2 \
        -m -3 \
        -theme-str '#window {anchor: northeast; location: northwest; width: 260; height: 170; y-offset: -187;}' \
        -eh 1 \
        -width -10 \
        -p "$date" > /dev/null
esac
echo "$LABEL$blockdate"
