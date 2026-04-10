#!/bin/bash

#--------------------------------------------------------------------
# Script de pós instalação para Fedora Workstation 42 ---------------
# Autor: Jedielson da Fonseca----------------------------------------
#--------------------------------------------------------------------

#-------------------------------------------------
# ---Pacotes para instalação, downloads e cores---
#-------------------------------------------------

dnf_packages=(
    "tree"
    "mangohud"
    "gamemode"
    "vlc"
    "soundkonverter"
    "audacity"
    "libratbag-ratbagd"
    "piper"
)

flatpak_packages=(
    "com.usebottles.bottles"
    "com.github.finefindus.eyedropper"
    "com.github.tchx84.Flatseal"
    "org.localsend.localsend_app"
    "io.github.peazip.PeaZip"
    "net.davidotek.pupgui2"
    "com.protonvpn.www"
    "org.gimp.GIMP"
    "org.upscayl.Upscayl"
    "com.markopejic.downloader"
    "org.bunkus.mkvtoolnix-gui"
    "org.freedesktop.Platform.VulkanLayer.MangoHud"
    "com.github.Flacon"
    "org.qbittorrent.qBittorrent"
    "org.gnome.Boxes"
    "org.strawberrymusicplayer.strawberry"
    "com.valvesoftware.Steam"
    "org.hydrogenmusic.Hydrogen"
    "com.heroicgameslauncher.hgl"
    "com.github.Matoking.protontricks"
    "com.google.Chrome"
    "net.cozic.joplin_desktop"
    "org.freedesktop.Platform.VulkanLayer.gamescope"
    "io.gitlab.librewolf-community"
)

snap_packages=(
    "copilot-desktop"
)

rpm_downloads=( 
    "https://github.com/ente-io/ente/releases/download/auth-v4.4.17/ente-auth-v4.4.17-x86_64.rpm"
    "https://proton.me/download/pass/linux/proton-pass-1.36.0-1.x86_64.rpm"
    "https://github.com/TheAssassin/AppImageLauncher/releases/download/v3.0.0-beta-3/appimagelauncher_3.0.0-beta-2-gha287.96cb937_x86_64.rpm"
)

appimages_downloads=(
    "https://github.com/JediFonseca/mass_renamer/releases/download/mass_renamer-2.3.1-bugfix/mass_renamer-2.3.1-x86_64.AppImage"
)

remove_packages=(
    "kmail"
    "kaddressbook"
    "pim-sieve-editor"
    "korganizer"
    "kmouth"
    "plasma-discover"
    "dragon"
    "firefox"
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

echo -e "${HEADER}###########################################################${NOCOLOR}"
echo -e "${HEADER}##   Script de pós instalação do Fedora Workstation 42   ##${NOCOLOR}"
echo -e "${HEADER}###########################################################${NOCOLOR}"
echo
echo -e -n "${INFO}Pressione ENTER para iniciar instalação das dependências ou CTRL+C para cancelar.${NOCOLOR}"
read
echo

#-------------------------------------------------
# ---FASE 1 - Resolvendo dependências do script---
#-------------------------------------------------

echo -e "${INFO}Instalando o \"snapd\"...${NOCOLOR}"
sudo dnf install -y snapd
echo -e "${INFO}Criando link simbólico para Snapd...${NOCOLOR}"
sudo ln -s /var/lib/snapd/snap /snap
echo -e "${INFO}Adicionando o repositório \"Flathub\".${NOCOLOR}"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo -e "${INFO}Adicionando os repositórios \"free\" e \"non-free\" do \"RPM Fusion\".${NOCOLOR}"
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
echo -e "${INFO}Fase de instalação de dependências finalizada.${NOCOLOR}"

echo
echo -e -n "${INFO}Pressione ENTER para instalar os pacotes \"dnf\", flatpaks e snaps ou CTRL+C para cancelar.${NOCOLOR}"
read
echo

#------------------------------------------------------------------------------
# ---FASE 2 - Instalando pacotes dos repositórios oficiais, flatpaks e snaps---
#------------------------------------------------------------------------------

# Instalação dos pacotes DNF:
echo -e "${INFO}Iniciando instalação dos pacotes \"dnf\".${NOCOLOR}"
echo
sudo dnf install -y "${dnf_packages[@]}"
    if [ $? -ne 0 ]; then
        echo -e "${ERRORS}A instalação de um ou mais pacotes falhou. Verifique os nomes dos pacotes.${NOCOLOR}"
        echo
        echo -e "${INFO}Continuando a execução do script...${NOCOLOR}"
        echo
    else
        echo -e "${SUCCESS}Pacotes instalados com sucesso.${NOCOLOR}"
        echo
    fi

# Instalação dos pacotes flatpak:
echo -e "${INFO}Iniciando a instalação dos pacotes flatpak${NOCOLOR}"
echo
flatpak install -y flathub "${flatpak_packages[@]}"
    if [ $? -ne 0 ]; then
        echo -e "${ERRORS}A instalação de um ou mais flatpaks falhou. Verifique as IDs dos aplicativos.${NOCOLOR}"
        echo
    else
        echo -e "${SUCCESS}Flatpaks instalados com sucesso.${NOCOLOR}"
        echo
    fi

# Instalação dos pacotes snap:
#echo -e "${INFO}Iniciando a instalação dos pacotes snap.${NOCOLOR}"
#echo
#sudo snap wait system seed.loaded
#sudo snap refresh
#sudo snap install "${snap_packages[@]}"
#    if [ $? -ne 0 ]; then
#        echo -e "${ERRORS}A instalação de um ou mais snaps falhou. Verifique os nomes dos pacotes.${NOCOLOR}"
#    else
#        echo -e "${SUCCESS}Snaps instalados com sucesso.${NOCOLOR}"
#    fi

#Instalação de Codecs multimídia.
echo
echo -e "${INFO}Instalando codecs multimídia...${NOCOLOR}"

sudo dnf group install multimedia

echo -e "${INFO}Fase de instalação dos pacotes finalizada.${NOCOLOR}"

echo
echo -e -n "${INFO}Pressione ENTER para baixar os arquivos .rpm ou CTRL+C para cancelar.${NOCOLOR}"
read
echo

#-----------------------------------------------------
# ---FASE 3 Downloads dos arquivos .rpm e .appimage---
#-----------------------------------------------------

echo -e "${INFO}Iniciando o download dos pacotes .rpm...${NOCOLOR}"
echo
mkdir -p "$HOME/Downloads/RPMs"
wget --show-progress -P "$HOME/Downloads/RPMs" "${rpm_downloads[@]}"

echo -e "${INFO}Iniciando o download dos pacotes AppImage...${NOCOLOR}"
echo
mkdir -p "$HOME/Downloads/AppImages"
wget --show-progress -P "$HOME/Downloads/AppImages" "${appimages_downloads[@]}"
echo -e "${INFO}Tornando os AppImages executáveis...${NOCOLOR}"
chmod +x "$HOME/Downloads/AppImages/"*.AppImage

echo
echo -e "${INFO}Fase de Downloads finalizada.${NOCOLOR}"
echo

echo -e -n "${INFO}Pressione ENTER para instalar os pacotes .rpm ou CTRL+C para cancelar.${NOCOLOR}"
read
echo

#------------------------------------------
# ---FASE 4 Instalação dos arquivos .rpm---
#------------------------------------------

echo -e "${INFO}Iniciando a instalação dos pacotes .rpm.${NOCOLOR}"
echo
sudo dnf install -y "$HOME/Downloads/RPMs/"*.rpm
    if [ $? -ne 0 ]; then
        echo -e "${ERRORS}A instalação de um pacote .rpm ou mais falhou. Continuando...${NOCOLOR}"
        echo
    else
        echo -e "${SUCCESS}Pacotes .rpm instalados com sucesso.${NOCOLOR}"
        echo
    fi

#--------------------------------------------------
# ---FASE 5 Desinstalação de pacotes indesejados---
#--------------------------------------------------

echo -e "${INFO}Por fim, o script irá desinstalar os pacotes desnecessários.${NOCOLOR}"
echo
echo -e -n "${INFO}Pressione ENTER para prosseguir ou CTRL+C para encerrar o script.${NOCOLOR}"
read
echo
sudo dnf remove -y "${remove_packages[@]}"
sudo dnf autoremove -y
echo

echo -e -n "${INFO}Script finalizado. Pressione ENTER para encerrar a execução.${NOCOLOR}"
read
echo
