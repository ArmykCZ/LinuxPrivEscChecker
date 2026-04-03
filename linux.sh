#!/bin/bash

# použití parametru -e u echa z důvodů interpretování escape sekvence (pro zbarvení textu)

#barvy

RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # zakončení barvy

echo -e "====${RED}Základní informace${NC}===="

USER=$(whoami)

if [ "$USER" == "root" ]; then
	echo "Jsi root"
else
	echo "Nejsi root"
	echo "Jsi uživatel" && whoami
fi

