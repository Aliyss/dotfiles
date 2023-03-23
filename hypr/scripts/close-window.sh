
SPOTIFYFOUND=$(hyprctl activewindow | grep -o -P -c " \-> Spotify:")
FLOATINGFOOTFOUND=$(hyprctl clients | grep -A 10 -P "Window.*+" | grep -A 5 -P "floating: 1" | grep -A 2 -P -c "class:\sfoot")

hyprctl dispatch killactive

if [[ $SPOTIFYFOUND -gt 0 || $FLOATINGFOOTFOUND -gt 0 ]]
then
    sleep 0.3
    FLOATINGFOOT=$(hyprctl clients | grep -A 10 -P "Window.*+" | grep -A 5 -P "floating: 1" | grep -A 2 -P -c "class:\sfoot")
    SPOTIFYFOUND=$(hyprctl clients | grep -o -P -c " \-> Spotify:")
    
    if [[ $FLOATINGFOOT -lt 1 ]]
    then
      if [[ $SPOTIFYFOUND -lt 1 ]]
      then
        hyprctl keyword monitor DP-2,addreserved,0,0,0,0.3
      else
        hyprctl dispatch movewindowpixel exact 4312 10,title:^Spotify\$;
        hyprctl dispatch resizewindowpixel exact 796 1415,title:^Spotify\$;
      fi
    elif [[ $FLOATINGFOOT -lt 2 ]]
    then
      pid=$(hyprctl clients | grep -A 10 -P "Window.*+" | grep -A 5 -P "floating: 1" | grep -A 2 -P "class:\sfoot" | grep "pid: " | sed 's/.*pid:\s//g' | sort --numeric-sort | tail -n 1)
      if [[ $SPOTIFYFOUND -gt 0 ]]
      then
        hyprctl dispatch movewindowpixel exact 4312 10,pid:"$pid";
        hyprctl dispatch resizewindowpixel exact 796 800,pid:"$pid";
      else
        hyprctl dispatch movewindowpixel exact 4312 10,pid:"$pid";
        hyprctl dispatch resizewindowpixel exact 796 1415,pid:"$pid";
      fi
    else
      pid=$(hyprctl clients | grep -A 10 -P "Window.*+" | grep -A 5 -P "floating: 1" | grep -A 2 -P "class:\sfoot" | grep "pid: " | sed 's/.*pid:\s//g' | sort --numeric-sort | tail -n 1)
      hyprctl dispatch movewindowpixel exact 4312 10,pid:"$pid";
      hyprctl dispatch resizewindowpixel exact 796 700,pid:"$pid";
      
      pid=$(hyprctl clients | grep -A 10 -P "Window.*+" | grep -A 5 -P "floating: 1" | grep -A 2 -P "class:\sfoot" | grep "pid: " | sed 's/.*pid:\s//g' | sort --numeric-sort -r | tail -n 1)
      hyprctl dispatch movewindowpixel exact 4312 725,pid:"$pid";
      hyprctl dispatch resizewindowpixel exact 796 700,pid:"$pid";
    fi

fi

