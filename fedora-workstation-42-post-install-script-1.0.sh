#!/bin/bash

#--------------------------------------------------------------------
# Script de pós instalação para Fedora Workstation 42 ---------------
# Autor: Jedielson da Fonseca----------------------------------------
#--------------------------------------------------------------------

#-------------------------------------------------
# ---Pacotes para instalação, downloads e cores---
#-------------------------------------------------

dnf_packages=(
    "gparted"
    "gnome-tweaks"
    "tree"
    "kdeconnectd"
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
    "com.valvesoftware.Steam"
    "net.lutris.Lutris"
    "org.videolan.VLC"
)

snap_packages=(
    "copilot-desktop"
)

rpm_downloads=( 
    "https://data.nephobox.com/issue/terabox/Linux/1.41.5/TeraBox-1.41.5.x86_64.rpm"
    "https://proton.me/download/authenticator/linux/ProtonAuthenticator-1.1.4-1.x86_64.rpm"
    "https://github.com/TheAssassin/AppImageLauncher/releases/download/v3.0.0-beta-1/appimagelauncher_3.0.0-alpha-4-gha275.0bcc75d_x86_64.rpm"
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

echo -e "${HEADER}###########################################################${NOCOLOR}"
echo -e "${HEADER}##   Script de pós instalação do Fedora Workstation 42   ##${NOCOLOR}"
echo -e "${HEADER}###########################################################${NOCOLOR}"
echo
echo -e "${INFO}Ao ser executado, este script irá:${NOCOLOR}"
echo -e "1. Instalar o \"snapd\" e adicionar os repositórios \"Flathub\" e \"RPM Fusion\"."
echo -e "2. Instalar, dos repositórios do Fedora, os pacotes: gparted,kdeconnectd"
echo -e "   gnome-tweaks, mangohud, gamemode e tree."
echo -e "3. Instalar os flatpaks: Bottles, Menu Editor, Eye Dropper, Flatseal, FreeTube, LocalSend,"
echo -e "   PeaZip, ProtonPlus, Proton VPN, Proton Pass, Notesnook, Gimp, Upscayl, Microsoft Edge"
echo -e "   Video Downloader, MKVToolNix GUI, MangoHud, GNOME Extensions Manager, Steam, Lutris e VLC."
echo -e "4. Instalar o pacote Snap: copilot-desktop."
echo -e "5. Instalar pacotes multimídia e Vulkan."
echo -e "6. Baixar, no formato .rpm, os instaladores dos apps: TeraBox, Proton Authenticator e AppImageLauncher."
echo -e "7. Baixar, em AppImage, o app: Mass Renamer."
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

#Instalação de Codecs multimídia e Vulkan.
echo
echo -e "${INFO}Instalando codecs multimídia do \"RPM Fusion\".${NOCOLOR}"
sudo dnf -y install ffmpeg-free ffmpeg
sudo dnf -y update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf -y install mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf -y install mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
sudo dnf -y install mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
sudo dnf -y install mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686

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
echo
echo -e "${INFO}Tornando os AppImages executáveis...${NOCOLOR}"
echo
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
