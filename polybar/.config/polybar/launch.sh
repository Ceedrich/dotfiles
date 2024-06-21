# Get battery/adapter
p_BATTERY=""
p_ADAPTER=""

for ps in /sys/class/power_supply/BAT*; do
  if [ -d "$ps" ]; then
    p_BATTERY=$(basename "$ps")
    break
  fi
done

for ps in /sys/class/power_supply/ADP*; do
  if [ -d "$ps" ]; then
    p_ADAPTER=$(basename "$ps")
    break
  fi
done

export p_BATTERY
export p_ADAPTER

NETWORKS=$(ip link show | awk 'NR % 2 {print $1}' | awk -F ":" '{print $1}')

# WIRELESS CONNECTION
p_WIRELESS=$(echo "$NETWORKS" | grep wl | awk 'NR=1')
p_WIRED=$(echo "$NETWORKS" | grep -E "eno|eth" | awk 'NR=1')
export p_WIRELESS
export p_WIRED

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload toph --config="$1"&
  done
else
  polybar --reload toph --config "$1"&
fi
