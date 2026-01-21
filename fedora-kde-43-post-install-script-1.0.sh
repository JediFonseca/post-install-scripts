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
    "soundkonverter"
    "audacity"
    "rclone"
    "rclone-browser"
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
    "com.valvesoftware.Steam"
    "net.lutris.Lutris"
    "org.videolan.VLC"
    "com.github.Flacon"
    "org.qbittorrent.qBittorrent"
    "org.strawberrymusicplayer.strawberry"
    "org.hydrogenmusic.Hydrogen"
    "com.heroicgameslauncher.hgl"
    "com.brave.Browser"
    "net.cozic.joplin_desktop"
    "com.github.Matoking.protontricks"
)

snap_packages=(
    "copilot-desktop"
)

rpm_downloads=( 
    "https://data.nephobox.com/issue/terabox/Linux/1.42.2/TeraBox-1.42.2.x86_64.rpm"
    "https://proton.me/download/pass/linux/proton-pass-1.33.5-1.x86_64.rpm"
    "https://proton.me/download/authenticator/linux/ProtonAuthenticator-1.1.4-1.x86_64.rpm"
    "https://github.com/TheAssassin/AppImageLauncher/releases/download/v3.0.0-beta-3/appimagelauncher_3.0.0-beta-2-gha287.96cb937_x86_64.rpm"
)

appimages_downloads=(
    "https://github.com/JediFonseca/mass_renamer/releases/download/mass_renamer-2.3.1-bugfix/mass_renamer-2.3.1-x86_64.AppImage"
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
echo -e "${INFO}Ao ser executado, este script irá:${NOCOLOR}"
echo -e "1. Instalar o \"snapd\" e adicionar os repositórios \"Flathub\" e \"RPM Fusion\"."
echo -e "2. Instalar, dos repositórios do Fedora, os pacotes: tree, mangohud, gamemode, soundkonverter."
echo -e "   audacity, rclone, rclone-browser, libratbag-ratbagd e piper."
echo -e "3. Instalar os flatpaks: Bottles, Eye Dropper, Flatseal, ProtonUp-Qt, Local Send, PeaZip, Brave,"
echo -e "   Proton VPN, Gimp, Upscayl, Media Downloader, Heroic Launcher, Joplin, Protontricks,"
echo -e "   MKV ToolNix GUI, Mangohud, Steam, Lutris, VLC, Flacon, qBittorrent, Strawberry e Hydrogen."
echo -e "4. Instalar o pacote Snap: copilot-desktop. (Desativado)"
echo -e "5. Instalar pacotes multimídia e Vulkan."
echo -e "6. Baixar, no formato .rpm, os instaladores dos apps: TeraBox, Proton Authenticator, AppImageLauncher e"
echo -e "   Proton Pass."
echo -e "7. Baixar, em AppImage, os apps: Mass Renamer."
echo -e "8. Instalar os pacotes .rpm baixados."
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

echo -e -n "${INFO}Script finalizado. Pressione ENTER para encerrar a execução.${NOCOLOR}"
read
echo
