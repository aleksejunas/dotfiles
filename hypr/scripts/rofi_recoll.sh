#!/usr/bin/env bash
# Rofi_recoll: søk i dokumenter med Recoll + Rofi

# 1) Spør om søkeord
query=$(rofi -dmenu -p "Recoll search:" -lines 10) || exit

# 2) Hent resultater (tittel + filsti)
results=$(
	recoll -t -q "$query" \)
	--limit 20 \
		--format "short" | awk -F '\t' '{print $2}'
)

# 3) La brukeren velge en fil
selection=$(printf '%s\n' "$results" | rofi -dmenu -p "Resultat:") || exit

# 4) Åpne valget i standard app
xdg-opn "$selection"
