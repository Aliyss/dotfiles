
SPOTIFYFOUND=$(hyprctl clients | grep -o -P -c " \-> Spotify:")
MAINMONITORID=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "id" "5120x1440" )
MAINMONITORNAME=$(~/.config/hypr/scripts/helpers/get_active_monitor_size.sh "name" "5120x1440" )

SPOTIFYIDENTIFIER="Spotify";

if [[ $SPOTIFYFOUND -le 0 && $MAINMONITORID ]]
then
  hyprctl keyword monitor "$MAINMONITORNAME",addreserved,0,0,0,810
  hyprctl dispatch exec [float] LD_PRELOAD=~/Sources/spotifywm/spotifywm.so spotify
  sleep 0.2
  SPOTIFYPID=$(~/.config/hypr/scripts/helpers/get_client_pid.sh "class:\s$SPOTIFYIDENTIFIER") 
  SUCCESS=$(~/.config/hypr/scripts/helpers/resize-floating-windows.sh "$SPOTIFYPID")
  hyprctl dispatch pin pid:"$SPOTIFYPID"
  echo "$SUCCESS"
fi
