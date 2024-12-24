#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Screenshots scripts

iDIR="$HOME/.config/swaync/icons"
sDIR="$HOME/.config/hypr/scripts"
notify_cmd_shot="notify-send -h string:x-canonical-private-synchronous:shot-notify -u low -i ${iDIR}/picture.png"

time=$(date "+%d-%b_%H-%M-%S")
dir="$(xdg-user-dir)/Pictures/Screenshots"
file="Screenshot_${time}_${RANDOM}.png"

active_window_class=$(hyprctl -j activewindow | jq -r '(.class)')
active_window_file="Screenshot_${time}_${active_window_class}.png"
active_window_path="${dir}/${active_window_file}"

# notify and view screenshot
notify_view() {
    if [[ "$1" == "active" ]]; then
        if [[ -e "${active_window_path}" ]]; then
            ${notify_cmd_shot} "Screenshot of '${active_window_class}' Saved."
            "${sDIR}/Sounds.sh" --screenshot
        else
            ${notify_cmd_shot} "Screenshot of '${active_window_class}' not Saved"
            "${sDIR}/Sounds.sh" --error
        fi
    elif [[ "$1" == "swappy" ]]; then
		${notify_cmd_shot} "Screenshot Captured."
    else
        local check_file="$dir/$file"
        if [[ -e "$check_file" ]]; then
            ${notify_cmd_shot} "Screenshot Saved."
            "${sDIR}/Sounds.sh" --screenshot
        else
            ${notify_cmd_shot} "Screenshot NOT Saved."
            "${sDIR}/Sounds.sh" --error
        fi
    fi
}



# countdown
countdown() {
	for sec in $(seq $1 -1 1); do
		notify-send -h string:x-canonical-private-synchronous:shot-notify -t 1000 -i "$iDIR"/timer.png "Taking shot in : $sec"
		sleep 1
	done
}

# take shots
# shotnow() {
# 	cd ${dir} && grim - | tee "$file" | wl-copy
# 	sleep 2
# 	notify_view
# }
shotnow() {
    echo "Directorio de capturas: $dir"
    if [[ ! -d "$dir" ]]; then
      echo "El directorio $dir no existe. Creando el directorio."
      mkdir -p "$dir"
    fi

    cd "${dir}" || { echo "No se pudo cambiar al directorio"; exit 1; }
    echo "Capturando pantalla..."
    if grim - | tee "$file" | wl-copy; then
        echo "Captura guardada como $file"
    else
        echo "Error: la captura no se guardó."
    fi
    sleep 2
    notify_view
}


shot5() {
	countdown '5'
	sleep 1 && cd ${dir} && grim - | tee "$file" | wl-copy
	sleep 1
	notify_view
	
}

shot10() {
	countdown '10'
	sleep 1 && cd ${dir} && grim - | tee "$file" | wl-copy
	notify_view
}

shotwin() {
	w_pos=$(hyprctl activewindow | grep 'at:' | cut -d':' -f2 | tr -d ' ' | tail -n1)
	w_size=$(hyprctl activewindow | grep 'size:' | cut -d':' -f2 | tr -d ' ' | tail -n1 | sed s/,/x/g)
	cd ${dir} && grim -g "$w_pos $w_size" - | tee "$file" | wl-copy
	notify_view
}

shotarea() {
	tmpfile=$(mktemp)
	grim -g "$(slurp)" - >"$tmpfile"
	if [[ -s "$tmpfile" ]]; then
		wl-copy <"$tmpfile"
		mv "$tmpfile" "$dir/$file"
	fi
	rm "$tmpfile"
	notify_view
}

shotactive() {
    active_window_class=$(hyprctl -j activewindow | jq -r '(.class)')
    active_window_file="Screenshot_${time}_${active_window_class}.png"
    active_window_path="${dir}/${active_window_file}"

    hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "${active_window_path}"
	sleep 1
    notify_view "active"  
}

# shotswappy() {
# 	tmpfile=$(mktemp)
# 	grim -g "$(slurp)" - >"$tmpfile" && "${sDIR}/Sounds.sh" --screenshot && notify_view "swappy"
# 	swappy -f - <"$tmpfile"
# 	rm "$tmpfile"
# }

shotswappy() {
    mkdir -p "$dir"  # Crear el directorio si no existe
    local temp_file=$(mktemp --suffix=.png)  # Archivo temporal para la captura
    echo "Capturando pantalla..."

    # Captura la pantalla en un archivo temporal
    if grim -g "$(slurp)" "$temp_file"; then
        echo "Captura tomada en $temp_file"

        # Abrir Swappy para editar la captura
        echo "Abriendo Swappy para editar..."
        swappy -f "$temp_file"  # Editar con Swappy

        # Una vez editado, mover el archivo temporal a la ubicación final
        local final_file="Screenshot_$(date +%d-%b_%H-%M-%S).png"
        mv "$temp_file" "$dir/$final_file"
        echo "Captura guardada como $dir/$final_file"

        # Copiar al portapapeles
        wl-copy < "$dir/$final_file"
        notify_view "swappy"  # Notificar que se completó la acción
    else
        echo "Error: la captura no se guardó."
        rm -f "$temp_file"  # Limpiar el archivo temporal si falló
    fi
}

if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

if [[ "$1" == "--now" ]]; then
	shotnow
elif [[ "$1" == "--in5" ]]; then
	shot5
elif [[ "$1" == "--in10" ]]; then
	shot10
elif [[ "$1" == "--win" ]]; then
	shotwin
elif [[ "$1" == "--area" ]]; then
	shotarea
elif [[ "$1" == "--active" ]]; then
	shotactive
elif [[ "$1" == "--swappy" ]]; then
	shotswappy
else
	echo -e "Available Options : --now --in5 --in10 --win --area --active --swappy"
fi

exit 0
