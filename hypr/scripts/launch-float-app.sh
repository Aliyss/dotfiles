#!/bin/bash
set -e

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
MAINMONITORNAME=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "name" "5120x1440" )
SPACING=5;

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

RESERVESPACETEMP=0
if [ ! "$RESERVESPACE" ] && [ ! "$MONITORNAME" ]; then
  RESERVESPACETEMP=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "reserved");
elif [ ! "$RESERVESPACE" ]; then
  RESERVESPACETEMP=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "reserved", "$MONITORNAME");
fi

if [ $(($RESERVESPACETEMP - $RESERVESPACE)) -gt 0 ]; then
  RESERVESPACE=$RESERVESPACETEMP
fi

if [ $(($RESERVESPACE)) -eq 0 ]; then
  echo "arguments -r must be provided or greater than 0"
  echo "$usage" >&2; exit 1
fi

if [ ! "$MONITORNAME" ]; then
    MONITOR_ID=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "id")
else
    MONITOR_ID=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "id" "$MONITORNAME" )
fi

hyprctl keyword monitor "$MAINMONITORNAME",addreserved,0,0,0,"$RESERVESPACE"
group=""
clients=();
grouped=$(hyprctl clients | grep -A 10 -P "Window.*+" | grep -A 5 -C 5 -P "floating:\s1" | grep -A 11 -C 11 -P "monitor: $MONITOR_ID" | awk '{$1=$1};1' | grep -C 9 "pid:\s");

while read -r line; do
  if [ "$line" == "--" ] && [ -n "$group" ]; then
      clientx=$(echo "$group" | grep -P "at:\s" | cut -d' ' -f2 | sed 's/,.*//');
      clienty=$(echo "$group" | grep -P "at:\s" | cut -d' ' -f2 | sed 's/.*,//');
      clienth=$(echo "$group" | grep -P "size:\s" | cut -d' ' -f2 | sed 's/,.*//');
      clientw=$(echo "$group" | grep -P "size:\s" | cut -d' ' -f2 | sed 's/.*,//');
      clientpid=$(echo "$group" | grep -P "pid:\s" | cut -d' ' -f2);
      
      clients+=("{x=$clientx, y=$clienty, height=$clienth, width=$clientw, pid=$clientpid}")
      group=""
  else
      group+="$line"$'\n'
  fi
done <<< "$grouped"

if [[ -n "$group" ]]; then
  clientx=$(echo "$group" | grep -P "at:\s" | cut -d' ' -f2 | sed 's/,.*//');
  clienty=$(echo "$group" | grep -P "at:\s" | cut -d' ' -f2 | sed 's/.*,//');
  clienth=$(echo "$group" | grep -P "size:\s" | cut -d' ' -f2 | sed 's/,.*//');
  clientw=$(echo "$group" | grep -P "size:\s" | cut -d' ' -f2 | sed 's/.*,//');
  clientpid=$(echo "$group" | grep -P "pid:\s" | cut -d' ' -f2);
  
  clients+=("{x=$clientx, y=$clienty, height=$clienth, width=$clientw, pid=$clientpid}")
  group=""
fi

# Calculate the total height of all clients
total_height=0
total_spacing=0
total_ratio=0

for i in "${!clients[@]}"; do
  client="${clients[$i]}"
  height="${client#*height=}"
  height="${height%%,*}"
  total_height=$((total_height + height))
  if [ $i -gt 0 ]; then
    prev_client="${clients[$((i-1))]}"
    prev_height="${prev_client#*height=}"
    prev_height="${prev_height%%,*}"
    prev_y="${prev_client#*y=}"
    prev_y="${prev_y%%,*}"
    total_spacing=$((total_spacing + height + prev_height + prev_y - ${client#*y=} - prev_y))
  fi
  total_ratio=$(echo "$total_ratio + $height/$MONITORHEIGHT" | bc -l)
done

# Calculate the average height of all clients
new_total_height=$((MONITORHEIGHT - total_height - (num_clients * SPACING) + total_spacing))
new_ratio=$(echo "$new_total_height/$MONITORHEIGHT" | bc -l)


prev_y=0

for i in "${!clients[@]}"; do
  client="${clients[$i]}"
  height="${client#*height=}"
  height="${height%%,*}"
  ratio=$(echo "$height/$MONITORHEIGHT" | bc -l)
  new_height=$(printf "%.0f" "$(echo $ratio*$new_total_height/$total_ratio | bc -l)")
  new_y=$((prev_y + prev_height + SPACING))
  echo "$client"
  clients[$i]=$(echo "$client" | sed "s/height=$height/height=$new_height/")
  clients[$i]=$(echo "${clients[$i]}" | sed "s/y=[0-9]*/y=$new_y/")
  echo "${clients[$i]}"
  prev_y=$new_y
  prev_height=$new_height
done

# Calculate the new height of the new client
# new_client_height=$((MONITORHEIGHT - total_height - (num_clients * SPACING)))
# echo "num: $num_clients"
# echo "new_client_height: $new_client_height"
# echo "avg_height: $avg_height"
# if [ $new_client_height -gt $avg_height ]; then
#   new_client_height=$avg_height
# fi

new_client_height=$(printf "%.0f" "$(echo $new_ratio*$new_total_height | bc -l)")
new_client_y=$((prev_y + prev_height + SPACING))
hyprctl dispatch exec [float] "$APP" 
sleep 0.3;
new_clientpid=$(~/.config/hypr/scripts/helpers/get_client_pid.sh "floating:\s1")
new_client="{x=10, y=$new_client_y, height=$new_client_height, width=60, pid=$new_clientpid}"
clients+=("$new_client")
# # Add the new client
# hyprctl dispatch exec [float] "$APP" 
# sleep 0.3;
# new_clientpid=$(~/.config/hypr/scripts/helpers/get_client_pid.sh "floating:\s1")
# echo "$new_client_height"
# new_client="{x=10, y=0, height=$new_client_height, width=60, pid=$new_clientpid}"
# clients+=("$new_client")
#
# # Adjust the heights of the existing clients
# new_total_height=$((total_height + new_client_height + SPACING))
# for i in "${!clients[@]}"; do
#   client="${clients[$i]}"
#   old_height="${client#*height=}"
#   old_height="${old_height%%,*}"
#   echo "$old_height"
#   new_height=$((old_height * (MONITORHEIGHT) / new_total_height))
#   new_y=$((i * (new_height + SPACING)))
#   new_client=$(echo "$client" | sed "s/height=$old_height/height=$new_height/")
#   new_client=$(echo "$new_client" | sed "s/y=[0-9]*/y=$new_y/")
#   clients[$i]="$new_client"
# done

for client in "${clients[@]}"; do
  echo "$client"
  height=$(echo "$client" | sed 's/.*height=\([0-9]*\).*/\1/')
  y=$(echo "$client" | sed 's/.*y=\([0-9]*\).*/\1/')
  pid=$(echo "$client" | sed 's/.*pid=\([0-9]*\).*/\1/')
 
  hyprctl dispatch resizewindowpixel exact $(($RESERVESPACE - 10)) "$height",pid:"$pid"
  hyprctl dispatch movewindowpixel exact $(($MONITORWIDTH - $RESERVESPACE)) "$y",pid:"$pid"
done
