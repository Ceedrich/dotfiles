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

NETWORKS=$(ip link show | awk 'NR%2 {print $2}' | awk -F ":" '{print $1}')

# WIRELESS CONNECTION
p_WIRELESS=$(echo "$NETWORKS" | grep wl | awk 'NR=1')
p_WIRED=$(echo "$NETWORKS" | grep -E "eno|eth" | awk 'NR=1')
export p_WIRELESS
export p_WIRED

## Get right config
REQUIRED_VERSION=3.7.0
polybar_version=$(polybar --version | grep polybar | awk '{print $2}')
config_file="${XDG_CONFIG_HOME:-$HOME/.config}/polybar"
if [ $REQUIRED_VERSION = $(printf "$REQUIRED_VERSION\n$polybar_version" | sort -V | head -n 1) ]; then
  config_file="$config_file/config.ini"
else
  config_file="$config_file/config_OLD.ini"
fi

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload toph --config="$config_file"&
  done
else
  polybar --reload toph --config="$config_file"&
fi
