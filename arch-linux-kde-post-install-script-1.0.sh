#!/bin/bash

#--------------------------------------------------------------------
# Script de pós instalação para o Arch Linux ------------------------
# Autor: Jedielson da Fonseca----------------------------------------
#--------------------------------------------------------------------

#-------------------------------------------------
# ---Pacotes para instalação, downloads e cores---
#-------------------------------------------------

pacman_packages=(
    "tree"
    "mangohud"
    "gamemode"
    "vlc"
    "cpupower"
    "soundconverter"
    "audacity"
    "rclone"
    "libratbag"
    "piper"
)

flatpak_packages=(
    "com.usebottles.bottles"
    "com.github.finefindus.eyedropper"
    "com.github.tchx84.Flatseal"
    "org.localsend.localsend_app"
    "io.github.peazip.PeaZip"
    "com.vysp3r.ProtonPlus"
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
    "com.brave.Browser"
    "net.cozic.joplin_desktop"
    "org.mozilla.firefox"
    "me.proton.Pass"
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

echo -e "${HEADER}###############################################${NOCOLOR}"
echo -e "${HEADER}##   Script de pós instalação do Arch Linux  ##${NOCOLOR}"
echo -e "${HEADER}###############################################${NOCOLOR}"
echo
echo -e "${ERRORS}VERIFIQUE OS LINKS DE DOWNLOAD ANTES DE USAR${NOCOLOR}"
echo
echo -e "${INFO}Ao ser executado, este script irá:${NOCOLOR}"
echo -e "1. Instalar o pacote \"flatpak\" e adicionar o repositório \"Flathub\"."
echo -e "2. Instalar, dos repositórios do Arch Linux, os pacotes: tree, mangohud, gamemode, cpupower"
echo -e "   vlc, soundconverter, audacity, rclone, libratbag e piper."
echo -e "3. Instalar os flatpaks: Bottles, Eyedropper, Flatseal, LocalSend, PeaZip, ProtonPlus,"
echo -e "   Proton VPN, GIMP, Upscayl, Video Downloader, MKVToolNix, MangoHud, Flacon,"
echo -e "   qBittorrent, GNOME Boxes, Strawberry, Steam, Hydrogen, Heroic Games Launcher,"
echo -e "   Protontricks, Firefox, Proton Pass, Brave e Joplin."
echo -e "4. Baixar, em AppImage, os apps: Mass Renamer."
echo -e "5. Ativar o modo de energia \"performance\" para a CPU."
echo
echo -e -n "${INFO}Pressione ENTER para iniciar instalação das dependências ou CTRL+C para cancelar.${NOCOLOR}"
read
echo

#-------------------------------------------------
# ---FASE 1 - Resolvendo dependências do script---
#-------------------------------------------------

echo -e "${INFO}Instalando o pacote \"flatpak\" e adicionando o repositório \"Flathub\".${NOCOLOR}"
echo
sudo pacman -Syu flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo
echo -e "${INFO}Fase de instalação de dependências finalizada.${NOCOLOR}"

echo
echo -e -n "${INFO}Pressione ENTER para instalar os pacotes \"pacman\" e flatpaks ou CTRL+C para cancelar.${NOCOLOR}"
read
echo

#------------------------------------------------------------------------------
# ---FASE 2 - Instalando pacotes dos repositórios oficiais, flatpaks e snaps---
#------------------------------------------------------------------------------

# Instalando pacotes do pacman:
echo -e "${INFO}Iniciando instalação dos pacotes \"pacman\".${NOCOLOR}"
echo
sudo pacman -Syu -y "${pacman_packages[@]}"
echo
echo -e "${INFO}Instalação dos pacotes \"pacman\" finalizada."${NOCOLOR}"
echo

# Instalação dos pacotes flatpak:
echo -e "${INFO}Iniciando a instalação dos pacotes flatpak...${NOCOLOR}"
echo
flatpak install -y flathub "${flatpak_packages[@]}"
    if [ $? -ne 0 ]; then
        echo -e "${ERRORS}A instalação de um ou mais flatpaks falhou. Verifique as IDs dos aplicativos.${NOCOLOR}"
    else
        echo -e "${SUCCESS}Flatpaks instalados com sucesso.${NOCOLOR}"
    fi

echo
echo -e "${INFO}Fase de instalação dos pacotes finalizada.${NOCOLOR}"

echo
echo -e -n "${INFO}Pressione ENTER para baixar os arquivos AppImage ou CTRL+C para cancelar.${NOCOLOR}"
read
echo

#-----------------------------------------------------
# ---FASE 3 Downloads dos arquivos .appimage---
#-----------------------------------------------------

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

echo -e -n "${INFO}Pressione ENTER para ativar o modo "performance" ou CTRL+C para cancelar.${NOCOLOR}"
read
echo

#----------------------------
# ---FASE 4 Ajustes extras---
#----------------------------

#Selecionando o modo de energia "performance" para a CPU
echo -e "${INFO}Pressione ENTER para identificar o modo de energia atual${NOCOLOR}"
echo -e -n "${INFO}da sua CPU ou CTRL+C para cancelar...${NOCOLOR}"
read
echo

# Identificando o modo atual da CPU.
echo -e "${INFO}Verificando o modo de energia atual da sua CPU...${NOCOLOR}"
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
cpupower frequency-info
echo -e "${INFO}Verifique, acima, o modo de energia atual da sua CPU.${NOCOLOR}"
echo -e -n "${INFO}Pressione ENTER para ativar o modo \"performance\" ou CTRL+C para cancelar.${NOCOLOR}"
read

# Selecionando o modo "performance".
sudo cpupower frequency-set -g performance
echo -e "[Unit]\nDescription=Set CPU governor to performance mode\nAfter=cpupower.service\n\n[Service]\nExecStart=/usr/bin/cpupower frequency-set -g performance\nRemainAfterExit=true\n\n[Install]\nWantedBy=multi-user.target" | sudo tee /etc/systemd/system/cpupower-performance.service > /dev/null
sudo systemctl enable cpupower-performance.service
sudo systemctl start cpupower-performance.service

# Identificando novamente o modo ativo da CPU.
echo -e "${INFO}Verificando o modo de energia ativo para a sua CPU...${NOCOLOR}"
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
cpupower frequency-info

# Adicionando permissão para que o mangohud em flatpak possa acessar a partição onde os jogos estão instalados.
echo -e "${INFO}Adicionando permissão para que o mangohud em flatpak possa acessar a partição com os jogos.${NOCOLOR}"
echo -e "${INFO}Para que esse ajuste funcione, a partição deve estar montada em \"'/mnt/Dados (Linux)\".${NOCOLOR}"
echo
echo -e -n "${INFO}Pressione ENTER para prosseguir ou CTRL+C para encerrar o script.${NOCOLOR}"
read
echo -e "${HEADER}33%${NOCOLOR}"
echo -e "${HEADER}66%${NOCOLOR}"
flatpak override --user --filesystem='/mnt/Dados (Linux):rw' org.freedesktop.Platform.VulkanLayer.MangoHud
echo -e "${HEADER}100%${NOCOLOR}"
echo
echo -e -n "${INFO}Script finalizado. Pressione ENTER para encerrar a execução.${NOCOLOR}"
read
echo
