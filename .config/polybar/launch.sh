if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload toph --config="$1"&
  done
else
  polybar --reload toph --config "$1"&
fi
