

RESPONSE=""
if [[ -z "$1" && -z "$2" ]]
then
  RESPONSE=""
elif [[ $1 == "pid" ]]
then
  RESPONSE=$(hyprctl clients | grep -A 10 -P "Window.*+" | grep -A 2 -P "$2" | grep "pid: " | sed 's/.*pid:\s//g' | sort --numeric-sort | tail -n 1)
elif [[ $1 == "size" ]]
then
  RESPONSE=$(hyprctl clients | grep -A 10 -P "Window.*+" | grep -A 2 -P "$2" | grep "size: " | sed 's/.*size:\s//g' | sort | tail -n 1)
elif [[ $1 == "at" ]]
then
  RESPONSE=$(hyprctl clients | grep -A 10 -P "Window.*+" | grep -A 2 -P "$2" | grep "pid: " | sed 's/.*at:\s//g' | sort | tail -n 1)
elif [[ $1 == "size" && -z "$2" ]]
then
  RESPONSE=$(hyprctl clients | grep -A 10 -P "Window.*+" | grep -A 2 -P "$2" | grep "pid: " | sed 's/.*pid:\s//g' | sort --numeric-sort | tail -n 1)
elif [[ $1 == "size" ]]
then
  RESPONSE=$(hyprctl clients | grep -A 10 -P "Window.*+" | grep -A 2 -P "$2" | grep "pid: " | sed 's/.*pid:\s//g' | sort --numeric-sort | tail -n 1)
fi

echo "$RESPONSE"
