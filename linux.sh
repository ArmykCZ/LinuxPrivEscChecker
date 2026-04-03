#!/bin/bash

# použití parametru -e u echa z důvodů interpretování escape sekvence (pro zbarvení textu)

#barvy

RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # zakončení barvy

#PRO ZÁKLADNÍ INFORMACE

#==========================================================================================================================================

echo -e "====${RED}ZÁKLÁDNÍ INFORMACE${NC}====\n"

USER=$(whoami)

if [ "$USER" == "root" ]; then
	echo "Jsi root"
else
	echo "Nejsi root"
	echo "Jsi uživatel: $USER"
fi

echo #Pro prázdný řádek 

groups #vypíše pouze group bez žádných id

# -q u grepu pro quiet (grep nic nevypíše, jenom pro podmínku)
if groups | grep -qw "docker"; then #-q pro quit a -w pro přesnou shodu celého zapsaného textu (docker)
	echo -e "\n${GREEN}Nacházíš se v Docker group - využití eskalace priviligií!!${NC}\n"
fi

if [ "$EUID" -eq 0 ]; then #proměnná pro id uživatele
	echo -e "\n${GREEN}Jsi root!!${NC}\n"
fi



#==========================================================================================================================================


#SYSTEM INFO

echo -e "\n====${RED}SYSTEM INFO${NC}====\n"

# ^ znamená začátek řádku, tak že to nebude vypisovat řádky, které obsahuje někde v textu name=
grep "^NAME=" /etc/os-release
echo #Pro prázdný řádek  
uname -a 

echo #Pro prázdný řádek 

#==========================================================================================================================================


echo -e "\n====${RED}SUDO${NC}====\n"


if sudo -n -l >/dev/null 2>&1; then # pokud je vyžadováno heslo, tak -n to když tak přeskočí
    echo "sudo -l jde využít bez hesla, ale pžíkazy vyžadují heslo"
	if sudo -n -l 2>/dev/null | grep -q "NOPASSWD"; then   #vnoření podmínka
		echo -e "${GREEN}EXISTUJÍ PŘÍKAZY BEZ HESLA${NC}"
	fi
else
    echo "sudo -l vyžaduje heslo nebo není dostupné"
fi




#==========================================================================================================================================


echo -e "\n====${RED}SUID${NC}====\n"

find / -perm -4000 -type f 2>/dev/null #vypsání (jenom) souborů se suid bitem (složky to nevypisuje) 
# tento příkaz find tu bude na určitou dobu, později bych projel možnosti v gtfobins a udělal podmínky na možnosti eskalace privilegií

