SPACING=10;
SPACINGY=11;
SPACINGR=10;
SPACINGL=0;

ACTIVECLIENTENDTIMEOUT=1

ACTIVECLIENTAT=$(~/.config/hypr/scripts/helpers/get_client_details.sh "at" "$1")
ACTIVECLIENTFLOATING=$(~/.config/hypr/scripts/helpers/get_client_details.sh "floating" "$1" "Window")

if [[ $ACTIVECLIENTFLOATING != 1 ]]; then
  exit
fi

MONITORSIZE=""
if [ ! "$MONITORNAME" ]; then
  MONITORSIZE=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "size");
else
  MONITORSIZE=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "size" "$MONITORNAME");
fi

MONITORWIDTH=$(echo "$MONITORSIZE" | sed 's/x.*//')
MONITORHEIGHT=$(echo "$MONITORSIZE" | sed 's/.*x//')

MONITORHEIGHT=$((MONITORHEIGHT-2*SPACINGY))

RESERVESPACE=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "reserved");


ACTIVECLIENTATX=$(echo "$ACTIVECLIENTAT" | sed 's/,.*//')
if (((MONITORWIDTH - ACTIVECLIENTATX) > RESERVESPACE )); then
  exit
fi

MONITOR_ID=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "id")
MONITORNAME=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "name")

group=""
clients=();
sleep $ACTIVECLIENTENDTIMEOUT
grouped=$(hyprctl clients | grep -A 10 -P "Window.*+" | grep -A 5 -C 5 -P "floating:\s1" | grep -A 11 -C 11 -P "monitor: $MONITOR_ID" | awk '{$1=$1};1' | grep -C 9 "pid:\s");
if [[ -n "$grouped" ]]; then
  while read -r line; do
    if [ "$line" == "--" ] && [ -n "$group" ]; then
        clientx=$(echo "$group" | grep -P "at:\s" | cut -d' ' -f2 | sed 's/,.*//');
        clienty=$(echo "$group" | grep -P "at:\s" | cut -d' ' -f2 | sed 's/.*,//');
        clienth=$(echo "$group" | grep -P "size:\s" | cut -d' ' -f2 | sed 's/.*,//');
        clientw=$(echo "$group" | grep -P "size:\s" | cut -d' ' -f2 | sed 's/,.*//');
        clientpid=$(echo "$group" | grep -P "pid:\s" | cut -d' ' -f2);
        
        clients+=("{x=$clientx, y=$clienty, height=$clienth, width=$clientw, pid=$clientpid}")
        group=""
    else
        group+="$line"$'\n'
    fi
  done <<< "$grouped"
fi

if [[ -n "$grouped" && -n "$group" ]]; then
  clientx=$(echo "$group" | grep -P "at:\s" | cut -d' ' -f2 | sed 's/,.*//');
  clienty=$(echo "$group" | grep -P "at:\s" | cut -d' ' -f2 | sed 's/.*,//');
  clienth=$(echo "$group" | grep -P "size:\s" | cut -d' ' -f2 | sed 's/.*,//');
  clientw=$(echo "$group" | grep -P "size:\s" | cut -d' ' -f2 | sed 's/,.*//');
  clientpid=$(echo "$group" | grep -P "pid:\s" | cut -d' ' -f2);
  
  clients+=("{x=$clientx, y=$clienty, height=$clienth, width=$clientw, pid=$clientpid}")
  group=""
fi

if [[ -z "$grouped" ]]; then
  # If there are no existing clients
  hyprctl keyword monitor "$MONITORNAME",addreserved,0,0,0,0
else
  # Calculate the average height of existing clients
  totalheight=0
  for c in "${clients[@]}"; do
    height=$(echo "$c" | sed -E 's/.*height=([0-9]+).*/\1/')
    totalheight=$((totalheight+height))
  done

  for i in "${!clients[@]}"; do
    c="${clients[$i]}"
    echo "$c"
    height=$(echo "$c" | sed -E 's/.*height=([0-9]+).*/\1/')
    newheight=$((height*MONITORHEIGHT/totalheight-SPACING))
    echo "$newheight"
    newy=$((i==0 ? "$SPACINGY" : $(echo "${clients[$i-1]}" | sed -E 's/.*y=([0-9]+).*/\1/')+$(echo "${clients[$i-1]}" | sed -E 's/.*height=([0-9]+).*/\1/')+SPACING))
    clients[$i]=$(echo "$c" | sed -E "s/(y=)[0-9]+/\1$newy/" | sed -E "s/(height=)[0-9]+/\1$newheight/") 
  done
fi

for i in "${!clients[@]}"; do
  client="${clients[$i]}"
  height=$(echo "$client" | sed 's/.*height=\([0-9]*\).*/\1/')
  y=$(echo "$client" | sed 's/.*y=\([0-9]*\).*/\1/')
  pid=$(echo "$client" | sed 's/.*pid=\([0-9]*\).*/\1/')

  if [[ i -eq $((${#clients[@]} - 1)) ]]; then
    height=$((height+SPACING))
  fi

  hyprctl dispatch resizewindowpixel exact $((RESERVESPACE - SPACINGR)) "$height",pid:"$pid"
  hyprctl dispatch movewindowpixel exact $((MONITORWIDTH - RESERVESPACE - SPACINGL)) "$y",pid:"$pid"
done
