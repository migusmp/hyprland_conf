#!/bin/bash

APPS=(
  "Spotify::spotify"
  "Discord::discord"
  "Steam::steam"
  "Chrome::google-chrome-stable"
)

# Generamos el menu
OUTPUT=""
for app in "${APPS[@]}"; do
  IFS=":" read -r name icon app command <<< "$app"
  OUTPUT+="<span color='#ffffff' onclick=\"$command\">$icon</span> |"
done

# Eliminar el ultimo separador
OUTPUT=${OUTPUT%| }

echo "$OUTPUT"
