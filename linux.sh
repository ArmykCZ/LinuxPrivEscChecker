#!/bin/bash

# použití parametru -e u echa z důvodů interpretování escape sekvence (pro zbarvení textu)

#barvy

RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" # zakončení barvy
BLUE='\033[0;34m'
YELLOW='\033[1;33m'

#==========================================================================================================================================
#přidání menu pro program 

clear
echo -e "${BLUE}==============================${NC}"
echo -e "${GREEN}       Vítej ve scriptu!       ${NC}"
echo -e "${BLUE}==============================${NC}\n"

echo -e "${YELLOW}O co jde:${NC}"
echo -e "Tento script automaticky spustí úžitečné příkazy, které jsou potřeba při eskalaci privilegií."
echo -e "${BLUE}Barevná logika (význam):${NC}"
echo -e "${RED}Červená${NC} → HIGH / kritický"
echo -e "${YELLOW}Žlutá${NC} → MEDIUM / podezřelé"
echo -e "${GREEN}Zelená${NC} → LOW / info"
echo -e "${BLUE}Modrá${NC} → INFO"
# čekání na enter
read -rp "Stiskni Enter pro pokračování..." 

echo -e "${BLUE}Hlavní část scriptu se spouští...${NC}"

sleep 1 #zastavení programu na 1 sekundu
clear #příkaz pro clean reminálu

#PRO ZÁKLADNÍ INFORMACE

#==========================================================================================================================================

echo -e "====${BLUE}ZÁKLÁDNÍ INFORMACE${NC}====\n"

USER=$(whoami)

if [ "$USER" == "root" ]; then
	echo -e "${RED}Jsi root${NC}"
else
	echo -e "${GREEN}Nejsi root${NC}"
	echo "Jsi uživatel: $USER"
fi

echo #Pro prázdný řádek 

groups #vypíše pouze group bez žádných id

# -q u grepu pro quiet (grep nic nevypíše, jenom pro podmínku)
if groups | grep -qw "docker"; then #-q pro quit a -w pro přesnou shodu celého zapsaného textu (docker)
	echo -e "\n${RED}Nacházíš se v Docker group - využití eskalace priviligií!!${NC}\n"
fi

if [ "$EUID" -eq 0 ]; then #proměnná pro id uživatele
	echo -e "\n${RED}Jsi root!!${NC}\n"
fi

#==========================================================================================================================================
#SYSTEM INFO
echo -e "\n====${BLUE}SYSTEM INFO${NC}====\n"

# ^ znamená začátek řádku, tak že to nebude vypisovat řádky, které obsahuje někde v textu name=
grep "^NAME=" /etc/os-release
echo #Pro prázdný řádek  
uname -a 

echo #Pro prázdný řádek 

#==========================================================================================================================================

echo -e "\n====${BLUE}SUDO${NC}====\n"

if sudo -n -l >/dev/null 2>&1; then # pokud je vyžadováno heslo, tak -n to když tak přeskočí
    echo -e "${BLUE}sudo -l lze spustit bez hesla (listing)${NC}"
	if sudo -n -l 2>/dev/null | grep -q "NOPASSWD"; then   #vnoření podmínka
		echo -e "${RED}EXISTUJÍ PŘÍKAZY BEZ HESLA${NC}"
	fi
else
    echo "sudo -l vyžaduje heslo nebo není dostupné"
fi

#==========================================================================================================================================

echo -e "\n====${BLUE}SUID${NC}====\n"

#vytvoření systému hledání možných zranitelností v programech se SUID bitem

#mega ultra unprivileged seznam XDDD pro https://gtfobins.org/#//^unprivileged$ 
seznam=(7z R aa-exec ab acr alpine ansible-playbook ansible-test aoss apache2 apache2ctl apport-cli
apt apt-get aptitude ar aria2c arj arp as ascii-xfr ascii85 ash aspell asterisk at atobm
autoconf autoheader autoreconf awk aws base32 base58 base64 basenc basez bash bashbug
batcat bbot bc bconsole bee borg bridge bundle bundler busctl busybox byebug bzip2
c89 c99 cabal cancel capsh cargo cat cc cdist certbot check_by_ssh check_cups check_log
check_memory check_raid check_ssl_cert check_statusfile choom chrt clamscan clisp cmake
cmp cobc code codex column comm composer cowsay cowthink cp cpan cpio cpulimit crash
crontab csh csplit csvtool cupsfilter curl cut dash date dc dd debugfs dhclient dialog
diff dig distcc dmesg dmidecode dmsetup dnsmasq doas docker dos2unix dosbox dotnet dpkg
dstat dvips easy_install easyrsa eb ed egrep elvish emacs enscript env eqn espeak ex
exiftool expand expect facter fastfetch ffmpeg fgrep file find finger firejail fish flock
fmt fold forge fping ftp fzf g++ gawk gcc gcloud gcore gdb gem genie genisoimage ghc ghci
gimp ginsh git gnuplot go grc grep gtester guile gzip hashcat hd head hexdump hg highlight
hping3 iconv iftop ionice ip irb ispell java jjs joe join journalctl jq jrunscript jshell
jtag julia knife ksh ksshell kubectl last lastb latex latexmk ld.so ldconfig less lftp
links loginctl logrotate logsave look lp ltrace lua lualatex luatex lwp-download lwp-request
m4 mail make man mawk minicom more mosquitto msfconsole msgattrib msgcat msgconv msgfilter
msgmerge msguniq mtr multitime mutt mv mypy mysql nano nasm nawk nc ncdu ncftp needrestart
neofetch nft nginx nice nl nm nmap node nohup npm nroff nsenter ntpdate nvim octave od
opencode openssl openvpn pandoc paste pax pdb pdflatex pdftex perf perl perlbug pexec pg
php pic pico pidstat pip pipx plymouth podman poetry posh pr procmail pry psftp psql ptx
puppet pwsh pygmentize pyright python qpdf rake ranger rc readelf red redcarpet redis
restic rev rlogin rlwrap rpm rpmdb rpmquery rpmverify rsync rtorrent ruby run-mailcap
run-parts runscript rustc rustdoc rustfmt rustup rvim sash scanmem scp screen script scrot
sed service setarch setlock sftp sg shred shuf slsh smbclient socat socket soelim softlimit
sort split sqlite3 sqlmap ss ssh ssh-agent ssh-copy-id ssh-keygen ssh-keyscan sshfs sshpass
start-stop-daemon stdbuf strace strings sysctl systemctl tac tail tar task taskset tasksh
tbl tclsh tcpdump tcsh tdbtool tee telnet terraform tex tftp tic time timedatectl timeout
tmate tmux top torify torsocks troff tsc tshark ul unexpand uniq unshare urlget uuencode uv
vagrant valgrind vi view vim vimdiff virsh volatility w3m watch wc wget whiptail whois
wireshark wish xargs xdg-user-dir xdotool xelatex xetex xmodmap xmore xpad xxd xz yarn yash
yelp yt-dlp zathura zcat zgrep zic zip zless zsh zsoelim zypper)

find / -perm -4000 -type f 2>/dev/null | while IFS= read -r file; do   #-r aby nemazal v path /, IFS pro to, aby nerozděloval podle mezer a speciálních znaků
    binarka=$(basename "$file") # uložení do proměnné, basename znamená, že veme celou file (cestu souboru) a veme jenom poslední část, tak že pro nás název aplikace ezz prostě :D

    for item in "${seznam[@]}"; do #veme každý item z našeho velkého seznamu XDDD, zrovna mi tady pomohl ai jo :I, klid XD
        if [ "$binarka" = "$item" ]; then   #každý vypsaný řádek z find příkazu se projede touto hračkou a jestli se název programu ROVNÁ s nějakým z itemů v seznamu, tak to dá program vědět :D
            echo -e "${YELLOW}[!]UNPRIVILEGED SUID nalezen: $file${NC}"
            echo "    → $binarka je v seznamu (zkontroluj GTFOBins)"
	    echo -e "${BLUE}https://gtfobins.org/gtfobins/$item/${NC}"
        fi
    done
done

echo 

find / -perm -4000 -type f 2>/dev/null #vypsání (jenom) souborů se suid bitem (složky to nevypisuje) 
# tento příkaz find tu bude na určitou dobu, později bych projel možnosti v gtfobins a udělal podmínky na možnosti eskalace privilegií

find / -writable -type f 2>/dev/null | head -n 10
