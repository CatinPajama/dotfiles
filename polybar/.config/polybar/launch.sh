killall -q polybar

while pgrep -x polybar >/dev/null; do sleep 1; done

#polybar main &
polybar left &
polybar center &
polybar right &
