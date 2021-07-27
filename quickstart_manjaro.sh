#!/bin/bash

# Instrukcja ----
echo "Przed rozpoczęciem należy:"
echo "(1) umieścić folder OneDrive w katalogu domowym (inaczej wszystkie pliki zostaną pobrane z chmury)"
echo "(2) pobrać sterowniki własnościowe narzędziem Manjaro"
echo "(3) sprawdzić IP drukarki Brother DCP-J315W (jeśli będzie instalowana)"
read -rsn1 -p "Wciśnij dowolny przycisk, by kontynuować . . ."
echo
read -rp "Czy chcesz zainstalować linux-surface dla Surface Go (t/n)? " dec_surface
read -rp "Czy chcesz zainstalować i skonfigurować Optimusa (t/n)? " dec_optimus
read -rp "Czy chcesz zainstalować drukarkę Brother DCP-J315W (t/n)? " dec_brother
if [[ $dec_brother =~ ^[tTyY]$ ]]
then
    read -rp "Podaj adres IP drukarki " ip_drukarki
fi
read -rp "Czy chcesz zsynchronizować i uruchomić autostart OneDrive (t/n)? " dec_onedrive
echo
sudo -v
set -x

# Podstawowe pakiety ----
sudo sed 's/^#Color/Color/' -i /etc/pacman.conf #kolory w pacmanie
sudo sed 's/^#ParallelDownloads/ParallelDownloads/' -i /etc/pacman.conf #jednoczesne pobieranie w pacmanie
sudo pacman-mirrors --fasttrack
sudo pacman -Syyu
sudo pacman -S base-devel x11-ssh-askpass fish python-pip python-wxpython jre-openjdk libstdc++5 flite libreoffice-fresh gcc-fortran r yay gimp flatpak calibre flameshot gparted htop qbittorrent vlc etcher pdftk virtualbox aspell hspell libvoikko --needed
yay -S google-chrome rstudio-desktop-bin zotero anki-official-binary-bundle p3x-onenote ttf-times-new-roman ttf-windows virtualbox-ext-oracle visual-studio-code-bin plasma5-applets-eventcalendar --needed
sudo usermod -aG vboxusers $USER
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import -
yay -S spotify --needed #problemy z kluczem
flatpak install org.jamovi.jamovi -y

# Surface ----
if [[ dec_surface =~ ^[tTyY]$ ]]
then
    curl -s https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \ | sudo pacman-key --add -
    sudo pacman-key --finger 56C464BAAC421453
    sudo pacman-key --lsign-key 56C464BAAC421453
    sudo sed '$a[linux-surface]' -i /etc/pacman.conf
    sudo sed '$aServer = https://pkg.surfacelinux.com/arch/' -i /etc/pacman.conf
    sudo pacman -Syyu
    sudo pacman -S linux-surface linux-surface-headers iptsd iio-sensor-proxy surface-ath10k-firmware-override
    sudo systemctl enable iptsd
    yay -S rabbitvcs-nautilus #integracja Nautilusa z git
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    sudo sed 's/#WaylandEnable/WaylandEnable/' -i /etc/gdm/custom.conf #przełącza Wayland na X11
fi

# Optimus ----
if [[ $dec_optimus =~ ^[tTyY]$ ]]
then
	sudo pacman -S optimus-manager nvidia-prime --needed
    sudo sed 's/^DisplayCommand/#DisplayCommand/' -i /etc/sddm.conf #wymagane zmiany w plikach konfiguracyjnych
    sudo sed 's/^DisplayStopCommand/#DisplayStopCommand/' -i /etc/sddm.conf #wymagane zmiany w plikach konfiguracyjnych
#    sudo sed 's/^\(startup_mode=\)\(.*\)/\1hybrid/' -i /etc/optimus-manager/optimus-manager.conf #ustawia domyślny tryb startowy na hybrid, włączyć po resecie
	yay -S optimus-manager-qt
fi

# Drukarka (Brother DCP-J315W) ----
if [[ $dec_brother =~ ^[tTyY]$ ]]
then
    yay -S brother-dcpj315w brscan3
    lpadmin -p DCPJ315W -v lpd://$ip_drukarki/BINARY_P1
    sudo brsaneconfig3 -a name=DCP-J315W model=DCP-J315W ip=$ip_drukarki
fi

# OneDrive ----
if [[ $dec_onedrive =~ ^[TtyY]$ ]]
then
    yay -S onedrive-abraunegg-git
    onedrive --synchronize
    systemctl enable onedrive@$USER.service
    systemctl start onedrive@$USER.service
fi

# GRUB ----
GRUB_TIMEOUT=1
sudo sed "s/\(GRUB_TIMEOUT=\)\([[:digit:]]*\)/\1$GRUB_TIMEOUT/" -i /etc/default/grub
sudo update-grub

# Restart ----
echo "Pamiętaj o zmianie ustawień Optimusa na hybrid, komenda jest w skrypcie"
read -rp "Czy zrestartować komputer? (t/n) "
if [[ $REPLY =~ ^[TtYy]$ ]]
then
    systemctl reboot
fi
