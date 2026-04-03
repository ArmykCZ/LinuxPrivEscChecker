#!/bin/bash

# použití parametru -e u echa z důvodů interpretování escape sekvence (pro zbarvení textu)

#barvy

RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # zakončení barvy

#PRO ZÁKLADNÍ INFORMACE

echo -e "====${RED}ZÁKLÁDNÍ INFORMACE${NC}====\n"

USER=$(whoami)

if [ "$USER" == "root" ]; then
	echo "Jsi root"
else
	echo "Nejsi root"
	echo "Jsi uživatel: " && whoami
fi

id

# -q u grepu pro quiet (grep nic nevypíše, jenom pro podmínku)
if id | grep -q "docker"; then
	echo -e "${GREEN}Nacházíš se v Docker group - využití eskalace priviligií!!${NC}\n"
fi

if id | grep -q  "uid=0"; then
	echo -e "${GREEN}Jsi root!!${NC}\n"
fi



#SYSTEM INFO

echo -e "\n====${RED}SYSTEM INFO${NC}====\n"

# ^ znamená začátek řádku, tak že to nebude vypisovat řádky, které obsahuje někde v textu name=
cat /etc/os-release | grep "^NAME="
echo #Pro prázdný řádek  
uname -a 





