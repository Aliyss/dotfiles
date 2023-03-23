
RESPONSE=""

MONITORID=$(hyprctl activewindow | grep "monitor:\s" | cut -d' ' -f2)

if [[ -z "$1" && -z "$2" ]]
then
  RESPONSE=""
elif [[ $1 == "id" ]]
then
  RESPONSE=$MONITORID
elif [[ $1 == "id" && -z "$2" ]]
then
  RESPONSE=$(hyprctl monitors | grep -A 1 Monitor | sed 's/@.*//' | sed 's/://g' | sed "s/Monitor\s$2\s(ID//" | sed 's/).*//' | awk '{$1=$1};1' | head -n 1)
elif [[ $1 == "name" ]]
then
  RESPONSE=$(hyprctl monitors | grep -A 1 Monitor | sed 's/@.*//' | sed 's/\s(.*)://g' | sed 's/Monitor\s//' | awk '{$1=$1};1' | grep -C 1 "$2" | head -n 1)
elif [[ $1 == "reserved" && -z "$2" ]]
then
  RESPONSE=$(hyprctl monitors | grep -A 9 "(ID\s$MONITORID)" | grep "reserved:\s" | cut -d' ' -f4 | head -n 1)
elif [[ $1 == "reserved" ]]
then
  RESPONSE=$(hyprctl monitors | grep -A 9 "(ID\s$2)" | grep "reserved:\s" | cut -d' ' -f4 | head -n 1)
elif [[ $1 == "size" && -z "$2" ]]
then
  RESPONSE=$(hyprctl monitors | grep -A 1 Monitor | sed 's/@.*//' | sed 's/://g' | sed 's/Monitor.*(ID//' | sed 's/).*//' | awk '{$1=$1};1' | grep -A 1 "^$MONITORID\$" | tail -n 1)
elif [[ $1 == "size" ]]
then
  RESPONSE=$(hyprctl monitors | grep -A 1 Monitor | sed 's/@.*//' | sed 's/\s(.*)://g' | sed 's/Monitor\s//' | awk '{$1=$1};1' | grep -A 1 "$2" | tail -n 1)
fi

echo "$RESPONSE"

