#!/bin/bash

usage="$(basename "$0") [-h] [-i PROJECT] [-v VM] [-p PYTHON] [-d NOTEBOOKS]
Launch floating app in Hyprland in a separate empty space.
where:
    -h  show this help text
    -a  app to launch or script
    -n  name of the monitor
    -r  space to reserve
    -p  pin the app
    -o  check if there is already an instance running by providing a check parameter"

# Constants
SPACING=10;
SPACINGY=11;
SPACINGR=10;
SPACINGL=0;

options=':ha:n:r:p:o:'
while getopts $options option; do
  case "$option" in
    h) echo "$usage"; exit;;
    a) APP=$OPTARG;;
    n) MONITORNAME=$OPTARG;;
    r) RESERVESPACE=$OPTARG;;
    p) PIN=$OPTARG;;
    o) ONLYONCE=$OPTARG;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
  esac
done

if [ ! "$APP" ]; then
  echo "arguments -a must be provided"
  echo "$usage" >&2; exit 1
fi

PID=""
if [ -n "$ONLYONCE" ]; then
  PID=$(~/.config/hypr/scripts/helpers/get_client_pid.sh "$ONLYONCE")
  if [[ -n "$PID" ]]; then
    echo "Already running!"; exit 1
  fi
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

RESERVESPACETEMP=0
if [ ! "$RESERVESPACE" ] && [ ! "$MONITORNAME" ]; then
  RESERVESPACETEMP=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "reserved");
elif [ ! "$RESERVESPACE" ]; then
  RESERVESPACETEMP=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "reserved", "$MONITORNAME");
fi

if [ $((RESERVESPACETEMP - RESERVESPACE)) -gt 0 ]; then
  RESERVESPACE=$RESERVESPACETEMP
fi

if [ $((RESERVESPACE)) -eq 0 ]; then
  hyprctl dispatch exec [tile] "$APP" 
  echo "$usage" >&2; exit 1
fi

if [ ! "$MONITORNAME" ]; then
  MONITOR_ID=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "id")
  MONITORNAME=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "name")
else
  MONITOR_ID=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "id" "$MONITORNAME" )
fi

hyprctl keyword monitor "$MONITORNAME",addreserved,0,0,0,"$RESERVESPACE"
group=""
clients=();
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

hyprctl dispatch exec [float] "$APP" 
sleep 0.6;
new_clientpid=$(~/.config/hypr/scripts/helpers/get_client_pid.sh "floating:\s1")

if [[ $PIN == true ]]; then
  hyprctl dispatch pin "pid:$new_clientpid"
fi

if [[ ${#clients[@]} -eq 0 ]]; then
  # If there are no existing clients, add the new client at the top
  clients+=("{x=10, y=$SPACINGY, height=$((MONITORHEIGHT-SPACING)), width=60, spacing=0, pid=$new_clientpid}")
else
  # Calculate the average height of existing clients
  totalheight=0
  for c in "${clients[@]}"; do
    height=$(echo $c | sed -E 's/.*height=([0-9]+).*/\1/')
    totalheight=$((totalheight+height))
  done
  avgheight=$((totalheight/${#clients[@]}+1))  # add 1 to avoid division by zero

  # Calculate the new client's height and spacing
  newheight=$((avgheight))

  # Set the new client's height and spacing
  newy=0
  clients+=("{x=10, y=$newy, height=$newheight, width=60, pid=$new_clientpid}")

  # Adjust the height and spacing of all clients based on the new totalheight
  totalheight=$((totalheight+newheight))
  for i in "${!clients[@]}"; do
    c="${clients[$i]}"
    height=$(echo $c | sed -E 's/.*height=([0-9]+).*/\1/')
    newheight=$((height*MONITORHEIGHT/totalheight-SPACING))
    newy=$((i==0 ? $SPACINGY : $(echo ${clients[$i-1]} | sed -E 's/.*y=([0-9]+).*/\1/')+$(echo ${clients[$i-1]} | sed -E 's/.*height=([0-9]+).*/\1/')+SPACING))
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

  hyprctl dispatch resizewindowpixel exact $(($RESERVESPACE - $SPACINGR)) "$height",pid:"$pid"
  hyprctl dispatch movewindowpixel exact $(($MONITORWIDTH - $RESERVESPACE - $SPACINGL)) "$y",pid:"$pid"
done
