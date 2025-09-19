#!/bin/bash

#--------------------------------------------------------------------
# Script de pós instalação para Ubuntu 24.04 ------------------------
# Autor: Jedielson da Fonseca----------------------------------------
#--------------------------------------------------------------------

#-------------------------------------------------
# ---Pacotes para instalação, downloads e cores---
#-------------------------------------------------

apt_packages=(
    "gparted"
    "gnome-software"
    "gnome-software-plugin-flatpak"
    "gnome-tweaks"
    "tree"
    "mangohud"
    "gamemode"
)

flatpak_packages=(
    "com.usebottles.bottles"
    "page.codeberg.libre_menu_editor.LibreMenuEditor"
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
    "com.microsoft.Edge"
    "com.github.unrud.VideoDownloader"
    "org.bunkus.mkvtoolnix-gui"
    "org.freedesktop.Platform.VulkanLayer.MangoHud"
    "com.mattjakeman.ExtensionManager"
    "org.videolan.VLC"
)

snap_packages=(
    "copilot-desktop"
)

deb_downloads=(
    "https://cdn.fastly.steamstatic.com/client/installer/steam.deb"
    "https://proton.me/download/authenticator/linux/ProtonAuthenticator_1.1.4_amd64.deb"
    "https://data.nephobox.com/issue/terabox/Linux/1.41.5/TeraBox_1.41.5_amd64.deb"
    "https://github.com/lutris/lutris/releases/download/v0.5.18/lutris_0.5.18_all.deb"
    "https://github.com/TheAssassin/AppImageLauncher/releases/download/v3.0.0-beta-1/appimagelauncher_3.0.0-alpha-4-gha275.0bcc75d_amd64.deb"
)

appimages_downloads=(
    "https://github.com/JediFonseca/mass_renamer/releases/download/Mass_Renamer-2.2/mass_renamer-2.2-x86_64.AppImage"
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

echo -e "${HEADER}########################################################${NOCOLOR}"
echo -e "${HEADER}##   Script de pós instalação do Ubuntu 24.04.3 LTS   ##${NOCOLOR}"
echo -e "${HEADER}########################################################${NOCOLOR}"
echo
echo -e "${INFO}Ao ser executado, este script irá:${NOCOLOR}"
echo -e "1. Instalar o pacote \"flatpak\" e adicionar o repositório \"Flathub\"."
echo -e "2. Instalar, dos repositórios do Ubuntu, os pacotes: gparted, gnome-software, gnome-tweaks,"
echo -e "   mangohud, gamemode, tree e gnome-software-plugin-flatpak."
echo -e "3. Instalar os flatpaks: Bottles, Menu Editor, Eye Dropper, Flatseal, FreeTube, LocalSend,"
echo -e "   PeaZip, ProtonPlus, Proton VPN, Proton Pass, Notesnook, Gimp, Upscayl, Microsoft Edge"
echo -e "   Video Downloader, MKVToolNix GUI, VLC, MangoHud e GNOME Extensions Manager."
echo -e "4. Instalar o pacote Snap: copilot-desktop"
echo -e "5. Baixar, no formato .deb, os instaladores dos apps: TeraBox, Proton Authenticator, Steam, Lutris e AppImageLauncher."
echo -e "6. Baixar, em AppImage, o app: Mass Renamer."
echo -e "7. Instalar os pacotes .deb baixados."
echo
echo -e -n "${INFO}Pressione ENTER para iniciar instalação das dependências ou CTRL+C para cancelar.${NOCOLOR}"
read
echo

#-------------------------------------------------
# ---FASE 1 - Resolvendo dependências do script---
#-------------------------------------------------

echo -e "${INFO}Instalando o pacote \"flatpak\" e adicionando o repositório \"Flathub\".${NOCOLOR}"
echo
sudo apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo
echo -e "${INFO}Fase de instalação de dependências finalizada.${NOCOLOR}"

echo
echo -e -n "${INFO}Pressione ENTER para instalar os pacotes \"apt\", flatpaks e snaps ou CTRL+C para cancelar.${NOCOLOR}"
read
echo

#------------------------------------------------------------------------------
# ---FASE 2 - Instalando pacotes dos repositórios oficiais, flatpaks e snaps---
#------------------------------------------------------------------------------

# Instalando pacotes do APT:
echo -e "${INFO}Iniciando instalação dos pacotes \"apt\".${NOCOLOR}"
echo
sudo apt update
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
echo
flatpak install -y flathub "${flatpak_packages[@]}"
    if [ $? -ne 0 ]; then
        echo -e "${ERRORS}A instalação de um ou mais flatpaks falhou. Verifique as IDs dos aplicativos.${NOCOLOR}"
    else
        echo -e "${SUCCESS}Flatpaks instalados com sucesso.${NOCOLOR}"
    fi

# Instalação dos pacotes snap:
echo -e "${INFO}Iniciando a instalação dos pacotes snap.${NOCOLOR}"
echo
sudo snap wait system seed.loaded
sudo snap refresh
sudo snap install "${snap_packages[@]}"
    if [ $? -ne 0 ]; then
        echo -e "${ERRORS}A instalação de um ou mais snaps falhou. Verifique os nomes dos pacotes.${NOCOLOR}"
    else
        echo -e "${SUCCESS}Snaps instalados com sucesso.${NOCOLOR}"
    fi
echo
echo -e "${INFO}Fase de instalação dos pacotes finalizada.${NOCOLOR}"

echo
echo -e -n "${INFO}Pressione ENTER para baixar os arquivos .deb ou CTRL+C para cancelar.${NOCOLOR}"
read
echo

#-----------------------------------------------------
# ---FASE 3 Downloads dos arquivos .deb e .appimage---
#-----------------------------------------------------

echo -e "${INFO}Iniciando o download dos pacotes .deb...${NOCOLOR}"
echo
mkdir -p "$HOME/Downloads/Debs"
wget --show-progress -P "$HOME/Downloads/Debs" "${deb_downloads[@]}"

echo -e "${INFO}Iniciando o download dos pacotes AppImage...${NOCOLOR}"
echo
mkdir -p "$HOME/Downloads/AppImages"
wget --show-progress -P "$HOME/Downloads/AppImages" "${appimages_downloads[@]}"
echo
echo -e "${INFO}Tornando os AppImages executáveis...${NOCOLOR}"

echo
chmod +x "$HOME/Downloads/AppImages/"*.AppImage

echo
echo -e "${INFO}Fase de Downloads finalizada.${NOCOLOR}"
echo

echo -e -n "${INFO}Pressione ENTER para instalar os pacotes .deb ou CTRL+C para cancelar.${NOCOLOR}"
read
echo

#------------------------------------------
# ---FASE 4 Instalação dos arquivos .deb---
#------------------------------------------

echo -e "${INFO}Iniciando a instalação dos pacotes .deb.${NOCOLOR}"
echo
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

echo -e -n "${INFO}Script finalizado. Pressione ENTER para encerrar a execução.${NOCOLOR}"
read
echo
