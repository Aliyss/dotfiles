SPOTIFYFOUND=$(hyprctl clients | grep -o -P -c " \-> Spotify:")

if [[ $SPOTIFYFOUND -le 0 ]]
then
  if [[ -n $1 && $1 == "float" ]]; then
    ~/.config/hypr/scripts/launch-float-app.sh -a "LD_PRELOAD=~/Sources/spotifywm/spotifywm.so spotify" -r "$2" -p true -o true
  else
    hyprctl dispatch exec [tile] LD_PRELOAD=~/Sources/spotifywm/spotifywm.so spotify
  fi
fi
