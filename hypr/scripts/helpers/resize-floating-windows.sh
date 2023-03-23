
MAINMONITORID=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "id" "5120x1440" )
MAINMONITORNAME=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "name" "5120x1440" )
MAINMONITORRESERVED=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "reserved" "5120x1440" )

SUCCESS=false;

if [[ -z "$1" ]]
then
  SUCCESS=false
else
  PID=$1
  hyprctl dispatch resizewindowpixel exact $(($MAINMONITORRESERVED - 15)) 1420,pid:"$PID"
  hyprctl dispatch movewindowpixel exact 4310 10,pid:"$PID"
  SUCCESS=true
fi

echo $SUCCESS
