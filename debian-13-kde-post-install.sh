#!/bin/bash

#--------------------------------------------------------------------
# Script de pós instalação para Debian 13 KDE -----------------------
# Autor: Jedielson da Fonseca----------------------------------------
#--------------------------------------------------------------------

#------------------
# --- VARIÁVEIS ---
#------------------

# Paleta de cores
colorblue='\033[0;36m'  # Ciano - para títulos.
colorgreen='\033[0;32m' # Verde - para mensagens de sucesso.
coloryellow='\033[1;33m'   # Amarelo - para avisos.
colorred='\033[0;31m' # Erros
nocolor='\033[0m' # Reseta a cor para o padrão do terminal.

# Ponto de montagem das partições extras
gamesdata="/mnt/Dados/"
mymusic="/mnt/Músicas/"

# Pastas do usuário para a criação de links simbólicos
source_documents="/mnt/Dados/User/Documentos (Arquivo)"
source_downloads="/mnt/Dados/User/Downloads (Arquivo)"
source_music="/mnt/Músicas/Minhas Músicas"
source_images="/mnt/Dados/User/Imagens (Arquivo)"
source_videos="/mnt/Dados/User/Vídeos (Arquivo)"
dest_documents="$HOME/Documentos/Documentos (Arquivo)"
dest_downloads="$HOME/Downloads/Downloads (Arquivo)"
dest_music="$HOME/Músicas/Minhas Músicas"
dest_images="$HOME/Imagens/Imagens (Arquivo)"
dest_videos="$HOME/Vídeos/Vídeos (Arquivo)"

# Links para os arquivos de configuração
strawlink="https://raw.githubusercontent.com/JediFonseca/config-files/main/strawberry.conf"
katerclink="https://raw.githubusercontent.com/JediFonseca/config-files/refs/heads/main/katerc"
dolphinrclink="https://raw.githubusercontent.com/JediFonseca/config-files/refs/heads/main/dolphinrc"
dolphinuilink="https://raw.githubusercontent.com/JediFonseca/config-files/refs/heads/main/dolphinui.rc"

# Caminhos para os arquivos de configuração
katercpath="$HOME/.config/katerc"
dolphinrcpath="$HOME/.config/dolphinrc"
dolphinuipath="$HOME/.local/share/kxmlgui5/dolphin/dolphinui.rc"

# Caminhos para os diretórios/pastas onde os arquivos de configuração se encontram
katercdir="$HOME/.config/"
dolphinrcdir="$HOME/.config/"
dolphinuidir="$HOME/.local/share/kxmlgui5/dolphin/"
strawdir="$HOME/.var/app/org.strawberrymusicplayer.strawberry/config/strawberry/"

#----------------------
# --- LISTAS/ARRAYS ---
#----------------------

declare -A apt_packages=(
    ["tree"]="Tree"
    ["mangohud"]="MangoHud"
    ["gamemode"]="GameMode"
    ["vlc"]="VLC"
    ["linux-cpupower"]="CPU Power"
    ["soundconverter"]="Sound Converter"
    ["audacity"]="Audacity"
    ["pipewire-audio-client-libraries"]="Pipewire Libraries"
    ["ratbagd"]="Ratbagd"
    ["piper"]="Piper"
    ["gnome-boxes"]="GNOME Boxes"
    ["lutris"]="Lutris"
    ["kde-config-flatpak"]="KDE Flatpak Config"
)

declare -A flatpak_packages=(
    ["com.usebottles.bottles"]="Bottles"
    ["com.github.finefindus.eyedropper"]="Eyedropper"
    ["org.localsend.localsend_app"]="LocalSend"
    ["io.github.peazip.PeaZip"]="PeaZip"
    ["net.davidotek.pupgui2"]="ProtonUp-Qt"
    ["com.protonvpn.www"]="Proton VPN"
    ["org.gimp.GIMP"]="GIMP"
    ["org.upscayl.Upscayl"]="Upscayl"
    ["com.markopejic.downloader"]="Video Downloader"
    ["org.freedesktop.Platform.VulkanLayer.MangoHud"]="MangoHud"
    ["org.freedesktop.Platform.VulkanLayer.gamescope"]="Gamescope"
    ["com.github.Flacon"]="Flacon"
    ["org.qbittorrent.qBittorrent"]="qBittorrent"
    ["org.strawberrymusicplayer.strawberry"]="Strawberry"
    ["com.valvesoftware.Steam"]="Steam"
    ["org.hydrogenmusic.Hydrogen"]="Hydrogen Drum Machine"
    ["com.heroicgameslauncher.hgl"]="Heroic Games Launcher"
    ["com.github.Matoking.protontricks"]="Protontricks"
    ["com.google.Chrome"]="Google Chrome"
    ["net.cozic.joplin_desktop"]="Joplin"
    ["io.gitlab.librewolf-community"]="LibreWolf"
    ["io.ente.auth"]="Ente Auth"
)

declare -A snap_packages=(
    ["copilot-desktop"]="Copilot Desktop"
)

declare -A deb_downloads=(
    ["https://proton.me/download/pass/linux/proton-pass_1.36.1_amd64.deb"]="Proton Pass"
    ["https://github.com/TheAssassin/AppImageLauncher/releases/download/v3.0.0-beta-3/appimagelauncher_3.0.0-beta-2-gha287.96cb937_amd64.deb"]="AppImageLauncher"
)

declare -A appimages_downloads=(
    ["https://github.com/JediFonseca/mass_renamer/releases/download/mass_renamer-2.3.1-bugfix/mass_renamer-2.3.1-x86_64.AppImage"]="Mass Renamer"
)

declare -A scripts_downloads=(
    ["https://raw.githubusercontent.com/JediFonseca/personal-scripts/main/myscripts"]="My Scripts"
    ["https://raw.githubusercontent.com/JediFonseca/personal-scripts/main/request-vm-ip"]="Request VM IP"
    ["https://raw.githubusercontent.com/JediFonseca/personal-scripts/main/rsync-go"]="Rsync Go"
    ["https://raw.githubusercontent.com/JediFonseca/pc-data/refs/heads/main/pcdata.sh"]="PC Data"
    ["https://raw.githubusercontent.com/JediFonseca/personal-scripts/refs/heads/main/debianup"]="Debian Uploader"
)

declare -A remove_packages=(
    ["kmail"]="KMail"
    ["kaddressbook"]="KAddressBook"
    ["pim-sieve-editor"]="PIM Sieve Editor"
    ["korganizer"]="KOrganizer"
    ["juk"]="Juk Music Player"
    ["kmouth"]="KMouth"
    ["libkdsoapwsdiscoveryclient0:amd64"]="Discover Libraries"
    ["plasma-discover"]="Plasma Discover"
    ["dragonplayer"]="Dragon Player"
    ["konqueror"]="Konqueror"
    ["firefox-esr"]="Firefox"
    ["libreoffice-*"]="LibreOffice"
    ["akregator"]="Akregator"
)

#----------------
# --- FUNÇÕES ---
#----------------

script_log () {
    log_file="$HOME/debian-13-post-install.log"
    exec 2> >(tee -a "$log_file")
}

#---------------------------------------------------------------------------------------

sudo_alive () {
sudo -v
while true; do sudo -v; sleep 60; done &
sudo_pid=$!
trap "kill $sudo_pid" EXIT
}

#---------------------------------------------------------------------------------------

basic_dependencies () {
command -v apt &>/dev/null || exit 1
command -v wget &>/dev/null || exit 2
command -v mkdir &>/dev/null || exit 3
command -v ping &>/dev/null || exit 4
command -v chmod &>/dev/null || exit 5
}

#---------------------------------------------------------------------------------------

internet_connection () {
clear

echo -e "${coloryellow}\nVerificando a conexão com a internet...\n${nocolor}"

ping -c 5 www.google.com.br
if [ "$?" -eq "0" ];
then
      echo -e "${colorgreen}\nConexão com a internet funcionando normalmente. Aguarde...${nocolor}"
      sleep 5
else
     echo -e "${colorred}\nERRO: Seu sistema não está conectado à internet.${nocolor}"
     exit 6
fi
}

#---------------------------------------------------------------------------------------

starting_message () {
clear

echo -e "${colorblue}---------- Script de pós instalação do Debian 13 KDE ----------${nocolor}"
echo
echo -e "${colorred}ATENÇÃO: Verifique os links e as variáveis de diretórios/arquivos antes de executar o script.${nocolor}"
echo
echo -e "${coloryellow}Ao ser executado, este script irá:${nocolor}"

echo -e "${colorblue}\nLidar com as dependências do script:${nocolor}"
echo "Instalar o \"snapd\" e o \"flatpak\", adicionar o repositório \"flathub\""
echo "e adicionar os repositórios do \"Lutris\" para o \"Debian\"."

echo -e "${colorblue}Instalar via APT:${nocolor}"
printf '%s, ' "${apt_packages[@]}" | sed 's/, $/./' | fold -s -w 80

echo -e "${colorblue}\nInstalar via Flatpak:${nocolor}"
printf '%s, ' "${flatpak_packages[@]}" | sed 's/, $/./' | fold -s -w 80

#echo -e "${colorblue}\nInstalar via Snap:${nocolor}"
#printf '%s, ' "${snap_packages[@]}" | sed 's/, $/./' | fold -s -w 80

echo -e "${colorblue}\nBaixar e instalar via .deb:${nocolor}"
printf '%s, ' "${deb_downloads[@]}" | sed 's/, $/./' | fold -s -w 80

echo -e "${colorblue}\nBaixar e permitir a execução dos AppImages:${nocolor}"
printf '%s, ' "${appimages_downloads[@]}" | sed 's/, $/./' | fold -s -w 80

echo -e "${colorblue}\nInstalar os seguintes pacotes complementares:${nocolor}"
echo "- \"steam-devices\": para complementar a instalação da Steam."

echo -e "${colorblue}Desinstalar os pacotes:${nocolor}"
printf '%s, ' "${remove_packages[@]}" | sed 's/, $/./' | fold -s -w 80

echo -e "${colorblue}\nBaixar e permitir a execução dos scripts pessoais:${nocolor}"
printf '%s, ' "${scripts_downloads[@]}" | sed 's/, $/./' | fold -s -w 80

echo -e "${colorblue}\nCriar os links simbólicos para as pastas:${nocolor}"
echo "Documentos (Arquivo), Downloads (Arquivo), Minhas Músicas, Imagens (Arquivo) e Vídeos (Arquivo)."

echo -e "${colorblue}Baixar e copiar arquivos de configuração para os apps:${nocolor}"
echo "Kate, Dolphin e Strawberry."

echo -e "${colorblue}Seleciona o modo Performance para o CPU Governor.${nocolor}"

echo -e "${colorblue}Permissões para flatpaks:${nocolor}"
echo "Conceder permissões necessárias para que os flatpaks possam acessar as partições extras."

echo -e "${coloryellow}\nEsse script foi pensado para ser executado apenas em instalações limpas do Debian 13 KDE${nocolor}"
echo -e "${coloryellow}após o sistema já ter sido totalmente atualizado e reiniciado.${nocolor}"
echo -e "Para ajuda e mais informações rode: ${colorblue}\"./debian-13-kde-post-install.sh --help\"${nocolor}."

echo -e -n "${coloryellow}\nPressione ENTER para iniciar a execução do script ou CTRL+C para cancelar.${nocolor}"
read -r
echo
}

#---------------------------------------------------------------------------------------

dependencies_installation () {
echo -e "${coloryellow}Instalando o \"snapd\"...${nocolor}"
sudo apt install -y snapd
sudo snap install snapd

echo -e "${coloryellow}Instalando o \"flatpak\" e adicionando o repositório \"Flathub\"...${nocolor}"
sudo apt update
sudo apt install flatpak -y
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo -e "${coloryellow}Adicionando os repositórios do \"Lutris\" para o \"Debian\".${nocolor}"
echo -e "Types: deb\nURIs: https://download.opensuse.org/repositories/home:/stryco\
re:/lutris/Debian_13/\nSuites: ./\nComponents: \nSigned-By: /etc/apt/keyrings/lutr\
is.gpg" | sudo tee /etc/apt/sources.list.d/lutris.sources > /dev/null

wget -q -O- https://download.opensuse.org/repositories/home:/strycore:/lutris/Debi\
an_13/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/lutris.gpg

echo -e "${coloryellow}Fase de instalação de dependências finalizada.${nocolor}"
}

#---------------------------------------------------------------------------------------

apt_installation () {
echo -e "${coloryellow}Iniciando instalação dos pacotes \"apt\".${nocolor}"
echo
sudo apt update
sudo apt install -y "${!apt_packages[@]}"
}

#---------------------------------------------------------------------------------------

flatpak_installation () {
echo -e "${coloryellow}Iniciando a instalação dos pacotes flatpak${nocolor}"
echo
flatpak install --user -y flathub "${!flatpak_packages[@]}"
}

#---------------------------------------------------------------------------------------

snap_installation () {
echo -e "${coloryellow}Iniciando a instalação dos pacotes snap.${nocolor}"
echo
sudo snap refresh
for sname in "${!snap_packages[@]}"; do
    sudo snap install "$sname"
done
}

#---------------------------------------------------------------------------------------

deb_downloads_list () {
echo -e "${coloryellow}Iniciando o download dos pacotes .deb...${nocolor}"
echo
mkdir -p "$HOME/Downloads/DEBs"
for url2 in "${!deb_downloads[@]}"; do
    wget --show-progress -P "$HOME/Downloads/DEBs" "$url2"
done
}

#---------------------------------------------------------------------------------------

appimage_downloads_list () {
echo -e "${coloryellow}Iniciando o download dos pacotes AppImage...${nocolor}"
echo
mkdir -p "$HOME/Downloads/AppImages"
for url3 in "${!appimages_downloads[@]}"; do
    wget --show-progress -P "$HOME/Downloads/AppImages" "$url3"
done
echo -e "${coloryellow}Tornando os AppImages executáveis...${nocolor}"
chmod +x "$HOME/Downloads/AppImages/"*.AppImage &>/dev/null
}

#---------------------------------------------------------------------------------------

deb_installation () {
echo -e "${coloryellow}Iniciando a instalação dos pacotes .deb.${nocolor}"
echo
sudo apt install -y "$HOME/Downloads/DEBs/"*.deb
}

#---------------------------------------------------------------------------------------

additional_packages () {
sudo apt update
sudo apt install steam-devices -y
}

#---------------------------------------------------------------------------------------

remove_packages_list () {
echo -e "${coloryellow}Desinstalando os pacotes indesejados.${nocolor}"
echo
sudo apt remove -y "${!remove_packages[@]}"
sudo apt autoremove -y
sudo apt autoclean -y
}

#---------------------------------------------------------------------------------------

config_files () {
echo -e "${coloryellow}Aplicando configurações personalizadas (Dolphin, Kate e Strawberry)...${nocolor}"

mkdir -p "$katercdir"
mkdir -p "$dolphinrcdir"
mkdir -p "$dolphinuidir"
mkdir -p "$strawdir"

wget -q -O "$katercpath" "$katerclink" &>/dev/null  # Utiliza "-O": sobrescreve o arquivo local com o remoto
wget -q -O "$dolphinrcpath" "$dolphinrclink" &>/dev/null
wget -q -O "$dolphinuipath" "$dolphinuilink" &>/dev/null
wget -nc -P "$strawdir" "$strawlink" &>/dev/null # Utiliza "-nc -P": só baixa o arquivo remoto se o local não existir
}

#---------------------------------------------------------------------------------------

my_folders () {
echo -e "${coloryellow}Criando os links para as pastas do usuário...${nocolor}"
echo

mkdir -p "$source_documents"
mkdir -p "$source_downloads"
mkdir -p "$source_images"
mkdir -p "$source_music"
mkdir -p "$source_videos"

ln -sfn "$source_documents" "$dest_documents"
ln -sfn "$source_downloads" "$dest_downloads"
ln -sfn "$source_music" "$dest_music"
ln -sfn "$source_images" "$dest_images"
ln -sfn "$source_videos" "$dest_videos"
}

#---------------------------------------------------------------------------------------

my_scripts () {
echo -e "${coloryellow}Iniciando o download dos scripts pessoais...${nocolor}"
echo
mkdir -p "$HOME/.local/bin"
for url1 in "${!scripts_downloads[@]}"; do
    wget -N -P "$HOME/.local/bin" "$url1"
done
chmod +x "$HOME/.local/bin/"* &>/dev/null
}

#---------------------------------------------------------------------------------------

cpu_governor () {
    clear

    echo -e "${coloryellow}Verificando o modo de energia atual da sua CPU...${nocolor}"
    cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    cpupower frequency-info
    echo -e "${coloryellow}Verifique, acima, o modo de energia atual da sua CPU.${nocolor}"
    echo -e -n "${coloryellow}Pressione ENTER para ativar o modo \"performance\" ou CTRL+C para cancelar.${nocolor}"
    read

    sudo cpupower frequency-set -g performance

    cat <<EOF | sudo tee /etc/systemd/system/cpupower-performance.service > /dev/null
    [Unit]
    Description=CPU Performance Governor
    After=cpupower.service

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/cpupower frequency-set -g performance

    [Install]
    WantedBy=multi-user.target
    EOF

    sudo systemctl enable cpupower-performance.service
    sudo systemctl start cpupower-performance.service

    echo -e "${coloryellow}Verificando o modo de energia ativo para a sua CPU...${nocolor}"
    cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    cpupower frequency-info
}

#---------------------------------------------------------------------------------------

flatpak_permissions () {
echo -e "\n${coloryellow}Verifique os caminhos para as partições de dados/jogos e músicas.${nocolor}\n"
echo -e "A partição de Jogos/Dados está montada em:${coloryellow} $gamesdata${nocolor}."
echo -e "A partição de Músicas está montada em:${coloryellow} $mymusic${nocolor}."
echo
echo "Se os caminhos estiverem incorretos, ajuste os valores das suas respectivas variáveis no início do script."
echo
echo -e -n "${coloryellow}Pressione ENTER para aplicar as permissões ou CTRL+C para cancelar.${nocolor}"
read -r

# Concede as permissões de filesystem necessárias aos flatpaks.
flatpak override --user --filesystem="$gamesdata:rw" --filesystem="$mymusic:rw"
flatpak override --user --filesystem="$gamesdata:rw" org.freedesktop.Platform.VulkanLayer.MangoHud
flatpak override --user --filesystem="$gamesdata:rw" org.freedesktop.Platform.VulkanLayer.gamescope
flatpak override --user --filesystem="$dest_documents:rw" io.gitlab.librewolf-community
flatpak override --user --filesystem="$dest_downloads:rw" io.gitlab.librewolf-community
flatpak override --user --filesystem="$dest_images:rw" io.gitlab.librewolf-community
flatpak override --user --filesystem="$dest_music:rw" io.gitlab.librewolf-community
flatpak override --user --filesystem="$dest_videos:rw" io.gitlab.librewolf-community

# Exibe as permissões concedidas aos flatpaks
echo -e "${coloryellow}Permissões de filesystem do Librewolf:${nocolor}"
flatpak info --show-permissions io.gitlab.librewolf-community
echo -e "${coloryellow}Permissões de filesystem do MangoHud:${nocolor}"
flatpak info --show-permissions org.freedesktop.Platform.VulkanLayer.MangoHud
echo -e "${coloryellow}Permissões de filesystem do GameScope:${nocolor}"
flatpak info --show-permissions org.freedesktop.Platform.VulkanLayer.gamescope
echo
echo -e "${coloryellow}As permissões foram aplicadas! Verifique as informações acima.${nocolor}"
}

#---------------------------------------------------------------------------------------

help_section () {

clear

echo -e "${colorblue}---------- Script de pós instalação do Debian 13 KDE ----------${nocolor}"
echo
echo -e "${coloryellow}Como usar esse script:${nocolor}"
echo
echo "Para executar o script por completo, basta rodar \"./debian-13-kde-post-install.sh\"."
echo "Você também pode rodar etapas específicas de forma isolada."
echo "Para isso, basta rodar o script com um (ou mais) dos parâmetros abaixo:"
echo
echo "--sudo-alive    #Autentica o \"sudo\" e o mantém assim até o encerramento do script."
echo "--basics        #Verifica se dependências básicas do script (como o apt) estão instalados."
echo "--net           #Checa a conexão com a internet."
echo "--dependencies  #Instala todas as dependências necessárias para o funcionamento do script."
echo "--apt           #Instala os pacotes listados via apt."
echo "--flatpak       #Instala os pacotes listados via flatpak."
echo "--snap          #Instala os pacotes listados via snap."
echo "--debd          #Baixa os arquivos .deb à partir dos links fornecidos."
echo "--appimage      #Baixa os arquivos .AppImage à partir dos links fornecidos."
echo "--debi          #Instala os pacotes .deb baixados."
echo "--add           #Instala pacotes adicionais complementares, como o \"steam-devices\"."
echo "--remove        #Desinstala os pacotes indicados na lista correspondente."
echo "--flatpak-per   #Ajusta as permissões de filesystem dos apps em flatpak."
echo "--myscripts     #Baixa e dá permissões de execução aos scripts pessoais."
echo "--myfolders     #Cria links para pastas de biblioteca."
echo "--config-files  #Instala arquivos de configuração pessoais para o Kate, Dolphin e o Strawberry."
echo "--gov           #Seleciona o modo Performance para o CPU Governor."
echo "--log           #Gera um log com os erros (se houverem)."
echo
echo "As funções irão rodar na mesma ordem que os parâmetros forem inseridos no comando."
echo
echo "Para informações mais detalhadas, leia o script."
echo
echo -e "${coloryellow}Exemplo de execução com parâmetros:${nocolor}"
echo "./debian-13-kde-post-install.sh --basics --dependencies --apt"
echo
echo -e "${coloryellow}Repositório oficial do projeto:${nocolor}"
echo "https://github.com/JediFonseca/post-install-scripts"
echo
}

#-------------------------------------
# --- Início da execução do script ---
#-------------------------------------

if [[ $# -eq 0 ]]; then

    script_log
    basic_dependencies
    internet_connection
    starting_message
    sudo_alive
    dependencies_installation
    apt_installation
    flatpak_installation
#   snap_installation
    deb_downloads_list
    appimage_downloads_list
    deb_installation
    additional_packages
    remove_packages_list
    my_scripts
    my_folders
    config_files
    cpu_governor
    flatpak_permissions
    echo
    echo -e "${colorgreen}Script finalizado! Recomenda-se reiniciar o sistema.${nocolor}"

else

    for arg in "$@"; do
        case "$arg" in
            --sudo-alive)   sudo_alive ;;
            --basics)       basic_dependencies ;;
            --net)          internet_connection ;;
            --dependencies) dependencies_installation ;;
            --apt)          apt_installation ;;
            --flatpak)      flatpak_installation ;;
            --snap)         snap_installation ;;
            --debd)         deb_downloads_list ;;
            --appimage)     appimage_downloads_list ;;
            --debi)         deb_installation ;;
            --add)          additional_packages ;;
            --remove)       remove_packages_list ;;
            --flatpak-per)  flatpak_permissions ;;
            --myscripts)    my_scripts ;;
            --myfolders)    my_folders ;;
            --config-files) config_files ;;
            --log)          script_log ;;
            --gov)          cpu_governor ;;
            --help)         help_section ;;
            *)
                echo -e "${colorred}Opção inválida: $arg${nocolor}"
                exit 7
                ;;
        esac
    done

fi
