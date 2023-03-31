function handle {
  if [[ $1 == closewindow\>\>* ]]; then
    address=$(echo "$1" | sed 's/.*>>//')
    ~/.config/hypr/scripts/close-window.sh "Window $address" 
  fi
}

socat - UNIX-CONNECT:/tmp/hypr/$(echo "$HYPRLAND_INSTANCE_SIGNATURE")/.socket2.sock | while read line; do handle "$line"; done
