#!/bin/bash

#--------------------------------------------------------------------
# Script de pós instalação para Linux Mint 22.2 ---------------------
# Autor: Jedielson da Fonseca----------------------------------------
#--------------------------------------------------------------------

#---------------------------------------------------
# ---VERIFIQUE OS LINKS DE DOWNLOAD ANTES DE USAR---
#---------------------------------------------------

#-------------------------------------------------
# ---Pacotes para instalação, downloads e cores---
#-------------------------------------------------

apt_packages=(
    "gparted"
    "tree"
    "mangohud"
    "gamemode"
    "vlc"
    "kdeconnect"
    "qemu-kvm"
    "libvirt-daemon-system"
    "libvirt-clients"
    "bridge-utils"
    "virtinst"
    "gpaste-2"
    "gir1.2-gpaste-2"
    "linux-tools-generic"
    "audacious"
    "soundconverter"
    "audacity"
)

flatpak_packages=(
    "com.usebottles.bottles"
    "com.github.finefindus.eyedropper"
    "com.github.tchx84.Flatseal"
    "io.freetubeapp.FreeTube"
    "org.localsend.localsend_app"
    "io.github.peazip.PeaZip"
    "com.vysp3r.ProtonPlus"
    "com.protonvpn.www"
    "me.proton.Pass"
    "com.notesnook.Notesnook"
    "org.gimp.GIMP"
    "org.upscayl.Upscayl"
    "com.markopejic.downloader"
    "org.bunkus.mkvtoolnix-gui"
    "org.freedesktop.Platform.VulkanLayer.MangoHud"
    "com.valvesoftware.Steam"
    "net.lutris.Lutris"
    "com.github.Flacon"
    "org.hydrogenmusic.Hydrogen"
    "org.qbittorrent.qBittorrent"
)

snap_packages=(
    "copilot-desktop"
)

deb_downloads=(
    "https://proton.me/download/authenticator/linux/ProtonAuthenticator_1.1.4_amd64.deb"
    "https://data.nephobox.com/issue/terabox/Linux/1.42.2/TeraBox_1.42.2_amd64.deb"
    "https://github.com/TheAssassin/AppImageLauncher/releases/download/v3.0.0-beta-1/appimagelauncher_3.0.0-alpha-4-gha275.0bcc75d_amd64.deb"
)

appimages_downloads=(
    "https://github.com/JediFonseca/mass_renamer/releases/download/mass_renamer-2.3.1-bugfix/mass_renamer-2.3.1-x86_64.AppImage"
)

binaries_downloads=(
    "https://www.remotemouse.net/downloads/linux/RemoteMouse_x86_64.zip"
)

# Paleta de cores
HEADER='\033[0;36m'  # Ciano - para títulos.
SUCCESS='\033[0;32m' # Verde - para mensagens de sucesso.
INFO='\033[1;33m'   # Amarelo - para avisos.
NOCOLOR='\033[0m' # Reseta a cor para o padrão do terminal.
ERRORS='\033[0;31m' # Erros

#--------------------------------
# ---FASE 0 - Mensagem inicial---
#--------------------------------

echo -e "${HEADER}#####################################################${NOCOLOR}"
echo -e "${HEADER}##   Script de pós instalação do Linux Mint 22.2   ##${NOCOLOR}"
echo -e "${HEADER}#####################################################${NOCOLOR}"
echo
echo -e "${ERRORS}VERIFIQUE OS LINKS DE DOWNLOAD ANTES DE USAR${NOCOLOR}"
echo
echo -e "${INFO}Ao ser executado, este script irá:${NOCOLOR}"
echo -e "1. Remover o bloqueio do Linux Mint para instalação de pacotes Snap."
echo -e "2. Instalar o pacote \"snapd\" e adicionar o repositório \"Flathub\"."
echo -e "3. Instalar, dos repositórios do Mint, os pacotes: qemu-kvm,libvirt-daemon-system, libvirt-clients, gpaste-2,"
echo -e "   gir1.2-gpaste-2, bridge-utils, virtinst, kdeconnect, gparted, mangohud, VLC, gamemode, tree,"
echo -e "   linux-tools-generic, audacity, soundconverter e audacious."
echo -e "4. Instalar os flatpaks: Bottles, qBittorrent, Hydrogen, Flacon, Eye Dropper, Flatseal, FreeTube, LocalSend,"
echo -e "   PeaZip, ProtonPlus, Proton VPN, Proton Pass, Notesnook, Gimp, Upscayl,"
echo -e "   Media Downloader, Steam, Lutris, MKVToolNix GUI e MangoHud."
echo -e "5. Instalar o pacote Snap: copilot-desktop"
echo -e "6. Baixar, no formato .deb, os instaladores dos apps: TeraBox, Proton Authenticator e AppImageLauncher."
echo -e "7. Baixar, em AppImage, o app: Mass Renamer."
echo -e "8. Baixar o binário para Linux do Remote Mouse."
echo -e "9. Instalar os pacotes .deb baixados."
echo
echo -e -n "${INFO}Pressione ENTER para iniciar instalação das dependências ou CTRL+C para cancelar.${NOCOLOR}"
read

#-------------------------------------------------
# ---FASE 1 - Resolvendo dependências do script---
#-------------------------------------------------

echo -e "${INFO}Removendo o bloqueio de pacotes Snap do Linux Mint 22.2.${NOCOLOR}"
sudo rm /etc/apt/preferences.d/nosnap.pref
echo -e "${INFO}Instalando o \"snapd\"...${NOCOLOR}"
sudo apt update
sudo apt install -y snapd
echo -e "${INFO}Criando link simbólico para Snapd...${NOCOLOR}"
sudo ln -s /var/lib/snapd/snap /snap
echo -e "${INFO}Adicionando o repositório \"Flathub\"...${NOCOLOR}"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo -e "${INFO}Fase de instalação de dependências finalizada.${NOCOLOR}"
echo
echo -e -n "${INFO}Pressione ENTER para instalar os pacotes \"apt\", flatpaks e snaps ou CTRL+C para cancelar.${NOCOLOR}"
read

#------------------------------------------------------------------------------
# ---FASE 2 - Instalando pacotes dos repositórios oficiais, flatpaks e snaps---
#------------------------------------------------------------------------------

# Instalando pacotes do APT:
echo -e "${INFO}Iniciando instalação dos pacotes \"apt\".${NOCOLOR}"
sudo apt install -y "${apt_packages[@]}"
    if [ $? -ne 0 ]; then
        echo -e "${ERRORS}A instalação de um ou mais pacotes falhou. Verifique os nomes dos pacotes.${NOCOLOR}"
        echo -e "${INFO}Tentando corrigir...${NOCOLOR}"
        sudo apt --fix-broken install -y
        echo -e "${INFO}Repetindo a instalação dos pacotes...${NOCOLOR}"
        sudo apt install -y "${apt_packages[@]}"
            if [ $? -ne 0 ]; then
                echo -e "${ERRORS}A instalação de um pacote .deb ou mais falhou novamente.${NOCOLOR}"
                echo -e "${INFO}Continuando com a execução do script...${NOCOLOR}"
            else
                echo -e "${SUCCESS}Segunda tentativa: pacotes instalados com sucesso.${NOCOLOR}"
            fi
    else
        echo -e "${SUCCESS}Pacotes instalados com sucesso.${NOCOLOR}"
    fi

# Instalação dos pacotes flatpak:
echo -e "${INFO}Iniciando a instalação dos pacotes flatpak${NOCOLOR}"
flatpak install -y flathub "${flatpak_packages[@]}"
    if [ $? -ne 0 ]; then
        echo -e "${ERRORS}A instalação de um ou mais flatpaks falhou. Verifique as IDs dos aplicativos.${NOCOLOR}"
    else
        echo -e "${SUCCESS}Flatpaks instalados com sucesso.${NOCOLOR}"
    fi

# Instalação dos pacotes snap:
echo -e "${INFO}Iniciando a instalação dos pacotes snap.${NOCOLOR}"
sudo snap wait system seed.loaded
sudo snap refresh
sudo snap install "${snap_packages[@]}"
    if [ $? -ne 0 ]; then
        echo -e "${ERRORS}A instalação de um ou mais snaps falhou. Verifique os nomes dos pacotes.${NOCOLOR}"
    else
        echo -e "${SUCCESS}Snaps instalados com sucesso.${NOCOLOR}"
    fi
echo -e "${INFO}Fase de instalação dos pacotes finalizada.${NOCOLOR}"
echo
echo -e -n "${INFO}Pressione ENTER para baixar os arquivos .deb ou CTRL+C para cancelar.${NOCOLOR}"
read

#---------------------------------------------------------------
# ---FASE 3 Downloads dos arquivos .deb, binários e .appimage---
#---------------------------------------------------------------

# Downloads dos .deb:
echo -e "${INFO}Iniciando o download dos pacotes .deb...${NOCOLOR}"
mkdir -p "$HOME/Downloads/Debs"
wget --show-progress -P "$HOME/Downloads/Debs" "${deb_downloads[@]}"

# Downloads dos .AppImage:
echo -e "${INFO}Iniciando o download dos pacotes AppImage...${NOCOLOR}"
mkdir -p "$HOME/Downloads/AppImages"
wget --show-progress -P "$HOME/Downloads/AppImages" "${appimages_downloads[@]}"

# Downloads dos binários:
echo -e "${INFO}Iniciando o download dos binários...${NOCOLOR}"
mkdir -p "$HOME/Downloads/Binaries"
wget --show-progress -P "$HOME/Downloads/Binaries" "${binaries_downloads[@]}"

# Ajustando permissões de execução e finalizando:
echo -e "${INFO}Tornando os AppImages executáveis...${NOCOLOR}"
chmod +x "$HOME/Downloads/AppImages/"*.AppImage

echo -e "${INFO}Fase de Downloads finalizada.${NOCOLOR}"
echo
echo -e -n "${INFO}Pressione ENTER para instalar os pacotes .deb ou CTRL+C para cancelar.${NOCOLOR}"
read

#------------------------------------------
# ---FASE 4 Instalação dos arquivos .deb---
#------------------------------------------

echo -e "${INFO}Iniciando a instalação dos pacotes .deb.${NOCOLOR}"
sudo apt install -y "$HOME/Downloads/Debs/"*.deb
    if [ $? -ne 0 ]; then
        echo -e "${ERRORS}A instalação de um pacote .deb ou mais falhou. Tentando corrigir...${NOCOLOR}"
        sudo apt --fix-broken install -y
        echo -e "${INFO}Repetindo a instalação dos pacotes .deb...${NOCOLOR}"
        sudo apt install -y "$HOME/Downloads/Debs/"*.deb
            if [ $? -ne 0 ]; then
        	echo -e "${ERRORS}A instalação de um pacote .deb ou mais falhou novamente.${NOCOLOR}"
        	echo -e "${INFO}Continuando com a execução do script...${NOCOLOR}"
            else
        	echo -e "${SUCCESS}Segunda tentativa: pacotes .deb instalados com sucesso.${NOCOLOR}"
            fi
    else
        echo -e "${SUCCESS}Pacotes .deb instalados com sucesso.${NOCOLOR}"
    fi
echo
echo -e -n "${INFO}Script finalizado. Pressione ENTER para encerrar a execução.${NOCOLOR}"
read
