SPOTIFYFOUND=$(hyprctl clients | grep -o -P -c " \-> Spotify:")

FOOTFOUND=$(hyprctl clients | grep -o -P -c "class:\sfoot")
EDGEFOUND=$(hyprctl clients | grep -o -P -c "class:\sMicrosoft-edge-dev")

if [[ $FOOTFOUND -lt 1 ]]
then
  hyprctl dispatch exec foot;
  sleep 0.3;
fi 

if [[ $EDGEFOUND -lt 1 ]]
then
  hyprctl dispatch exec microsoft-edge-dev;
  sleep 0.3
fi

if [[ $EDGEFOUND -lt 2 ]]
then
  hyprctl dispatch focus class:^Microsoft-edge-dev\$;
  hyprctl dispatch movewindow l;
  hyprctl dispatch exec microsoft-edge-dev;
  sleep 0.3
  hyprctl dispatch splitratio 0.18
fi

if [[ -z "$1" ]]
then
    echo "No argument supplied"
elif [[ $1 = "super" ]]
then
  if [[ $SPOTIFYFOUND -ge 1 ]]
  then

    FLOATINGFOOT=$(hyprctl clients | grep -A 10 -P "Window.*+" | grep -A 5 -P "floating: 1" | grep -A 2 -P -c "class:\sfoot")

    if [[ $FLOATINGFOOT -lt 1 ]]
    then
      hyprctl dispatch exec [float] foot;
      sleep 0.3;
    fi

    if [[ $FLOATINGFOOT -lt 2 ]]
    then
      pid=$(hyprctl clients | grep -A 10 -P "Window.*+" | grep -A 2 -P "class:\sfoot" | grep "pid: " | sed 's/.*pid:\s//g' | sort --numeric-sort | tail -n 1)
      hyprctl dispatch movewindowpixel exact 4312 10,pid:"$pid";
      hyprctl dispatch resizewindowpixel exact 796 395,pid:"$pid";

      hyprctl dispatch exec [float] foot;
      sleep 0.3;
      pid=$(hyprctl clients | grep -A 10 -P "Window.*+" | grep -A 2 -P "class:\sfoot" | grep "pid: " | sed 's/.*pid:\s//g' | sort --numeric-sort | tail -n 1)
      hyprctl dispatch movewindowpixel exact 4312 420,pid:"$pid";
      hyprctl dispatch resizewindowpixel exact 796 395,pid:"$pid";
    fi

    hyprctl dispatch movewindowpixel exact 4312 825,title:^Spotify\$;
    hyprctl dispatch resizewindowpixel exact 796 605,title:^Spotify\$;
    
  fi
fi
