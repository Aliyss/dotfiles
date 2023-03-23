
RESPONSE=""
if [[ -z "$1" ]]
then
  RESPONSE=""
else
  RESPONSE=$(hyprctl clients | grep -A 10 -P "Window.*+" | grep -A 5 -C 5 -P "$1" | grep "pid: " | sed 's/.*pid:\s//g' | sort --numeric-sort | tail -n 1)
fi

echo "$RESPONSE"
