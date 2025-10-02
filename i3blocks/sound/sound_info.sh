#!/bin/sh

VOLUME_MUTE="🔇"
VOLUME_LOW="🔈"
VOLUME_MID="🔉"
VOLUME_HIGH="🔊"

# Obtiene el volumen promedio de todos los sinks
SOUND_LEVEL=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{sum=0; n=0; for(i=5;i<=NF;i+=2){gsub("%","",$i); sum+=$i; n++} if(n>0) printf("%d\n", sum/n)}')

# Comprueba si el sink está muteado
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print ($2=="yes" ? 1 : 0)}')

# Selecciona el icono según el estado
ICON=$VOLUME_MUTE
if [ "$MUTED" = "1" ]; then
    ICON="$VOLUME_MUTE"
else
    if [ "$SOUND_LEVEL" -lt 34 ]; then
        ICON="$VOLUME_LOW"
    elif [ "$SOUND_LEVEL" -lt 67 ]; then
        ICON="$VOLUME_MID"
    else
        ICON="$VOLUME_HIGH"
    fi
fi

# Muestra el resultado
printf " %s:%3s%% \n" "$ICON" "$SOUND_LEVEL"

