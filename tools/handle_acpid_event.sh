#/bin/usr/env bash

export LID_STATE=$(awk '{print$NF}' /proc/acpi/button/lid/LID1/state)
export XAUTHORITY=/home/marc/.Xauthority
export DISPLAY=:0.0
export XDG_RUNTIME_DIR=/run/user/1000
export WAYLAND_DISPLAY=$XDG_RUNTIME_DIR/wayland-1

coproc acpi_listen
trap 'kill $COPROC_PID' EXIT

while read -u "${COPROC[0]}" -a event; do
    echo "${event[@]}"

    if grep -q "open" <<< "${event[@]}"; then
      echo "it is open"
      WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR wlr-randr --output eDP-1 --on
    elif grep -q "close" <<< "${event[@]}"; then
      echo "it is closed"
      WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR wlr-randr --output eDP-1 --off
    else 
      echo "Dont know :)"
    fi

done
