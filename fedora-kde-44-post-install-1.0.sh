#!/bin/bash

#--------------------------------------------------------------------
# Script de pós instalação para Fedora KDE 44 -----------------------
# Autor: Jedielson da Fonseca----------------------------------------
#--------------------------------------------------------------------

# Paleta de cores
colorblue='\033[0;36m'  # Ciano - para títulos.
colorgreen='\033[0;32m' # Verde - para mensagens de sucesso.
coloryellow='\033[1;33m'   # Amarelo - para avisos.
nocolor='\033[0m' # Reseta a cor para o padrão do terminal.
colorred='\033[0;31m' # Erros

#-----------------------------
# ---Checagens de segurança---
#-----------------------------

# Verificar se os programas estão instalados:
command -v dnf >/dev/null || exit 1
command -v wget >/dev/null || exit 2
command -v mkdir >/dev/null || exit 3
command -v ping >/dev/null || exit 4
command -v chmod >/dev/null || exit 5
command -v flatpak >/dev/null || exit 6

clear

echo -e "${coloryellow}\nVerificando a conexão com a internet...\n${nocolor}"

ping -c 10 www.google.com.br
if [ "$?" -eq "0" ];
then
      echo -e "${colorgreen}\nConexão com à internet funcionando normalmente. Aguarde...${nocolor}"
      sleep 5
else
     echo -e "${colorred}\nERRO: Seu sistema não está conectado à internet.${nocolor}"
     exit
fi

#------------------------------------------
# ---Pacotes para instalação e downloads---
#------------------------------------------

declare -A dnf_packages=(
    ["tree"]="Tree"
    ["mangohud"]="MangoHud"
    ["gamemode"]="GameMode"
    ["vlc"]="VLC"
    ["soundkonverter"]="SoundKonverter"
    ["audacity"]="Audacity"
    ["libratbag-ratbagd"]="Ratbagd"
    ["piper"]="Piper"
)

declare -A flatpak_packages=(
    ["com.usebottles.bottles"]="Bottles"
    ["com.github.finefindus.eyedropper"]="Eyedropper"
    ["com.github.tchx84.Flatseal"]="Flatseal"
    ["org.localsend.localsend_app"]="LocalSend"
    ["io.github.peazip.PeaZip"]="PeaZip"
    ["net.davidotek.pupgui2"]="ProtonUp-Qt"
    ["com.protonvpn.www"]="Proton VPN"
    ["org.gimp.GIMP"]="GIMP"
    ["org.upscayl.Upscayl"]="Upscayl"
    ["com.markopejic.downloader"]="Video Downloader"
    ["org.bunkus.mkvtoolnix-gui"]="MKVToolNix"
    ["org.freedesktop.Platform.VulkanLayer.MangoHud"]="MangoHud"
    ["com.github.Flacon"]="Flacon"
    ["org.qbittorrent.qBittorrent"]="qBittorrent"
    ["org.gnome.Boxes"]="GNOME Boxes"
    ["org.strawberrymusicplayer.strawberry"]="Strawberry"
    ["com.valvesoftware.Steam"]="Steam"
    ["org.hydrogenmusic.Hydrogen"]="Hydrogen"
    ["com.heroicgameslauncher.hgl"]="Heroic Games Launcher"
    ["com.github.Matoking.protontricks"]="Protontricks"
    ["com.google.Chrome"]="Google Chrome"
    ["net.cozic.joplin_desktop"]="Joplin"
    ["org.freedesktop.Platform.VulkanLayer.gamescope"]="Gamescope"
    ["io.gitlab.librewolf-community"]="LibreWolf"
)

declare -A snap_packages=(
    ["copilot-desktop"]="Copilot Desktop"
)

declare -A rpm_downloads=(
    ["https://github.com/ente-io/ente/releases/download/auth-v4.4.17/ente-auth-v4.4.17-x86_64.rpm"]="Ente Auth"
    ["https://proton.me/download/pass/linux/proton-pass-1.36.0-1.x86_64.rpm"]="Proton Pass"
    ["https://github.com/TheAssassin/AppImageLauncher/releases/download/v3.0.0-beta-3/appimagelauncher_3.0.0-beta-2-gha287.96cb937_x86_64.rpm"]="AppImageLauncher"
)

declare -A appimages_downloads=(
    ["https://github.com/JediFonseca/mass_renamer/releases/download/mass_renamer-2.3.1-bugfix/mass_renamer-2.3.1-x86_64.AppImage"]="Mass Renamer"
)

declare -A remove_packages=(
    ["kmail"]="KMail"
    ["kaddressbook"]="KAddressBook"
    ["pim-sieve-editor"]="PIM Sieve Editor"
    ["korganizer"]="KOrganizer"
    ["kmouth"]="KMouth"
    ["plasma-discover"]="Plasma Discover"
    ["dragon"]="Dragon Player"
    ["firefox"]="Firefox"
)

#--------------------------------
# ---FASE 0 - Mensagem inicial---
#--------------------------------

clear

echo -e "${colorblue}###################################################${nocolor}"
echo -e "${colorblue}##   Script de pós instalação do Fedora KDE 44   ##${nocolor}"
echo -e "${colorblue}###################################################${nocolor}"
echo
echo -e "${colorred}ATENÇÃO: Verifique os links antes de executar o script.${nocolor}"
echo
echo -e "${coloryellow}Ao ser executado, este script irá:${nocolor}"

echo -e "${colorblue}\nLidar com as dependências do script:${nocolor}"
echo "Instalar o \"snapd\", adicionar o repositório \"flathub\" para Flatpaks"
echo "e adicionar os repositórios do \"RPM Fusion\" \"free\" e \"non-free\"."

echo -e "${colorblue}Instalar via DNF:${nocolor}"
printf '%s, ' "${dnf_packages[@]}" | sed 's/, $/./' | fold -s -w 80

echo -e "${colorblue}\nInstalar via Flatpak:${nocolor}"
printf '%s, ' "${flatpak_packages[@]}" | sed 's/, $/./' | fold -s -w 80

#echo -e "${colorblue}\nInstalar via Snap:${nocolor}"
#printf '%s, ' "${snap_packages[@]}" | sed 's/, $/./' | fold -s -w 80

echo -e "${colorblue}\nBaixar e instalar via .rpm:${nocolor}"
printf '%s, ' "${rpm_downloads[@]}" | sed 's/, $/./' | fold -s -w 80

echo -e "${colorblue}\nBaixar e permitir a execução dos AppImages:${nocolor}"
printf '%s, ' "${appimages_downloads[@]}" | sed 's/, $/./' | fold -s -w 80

echo -e "${colorblue}\nDesinstalar os pacotes:${nocolor}"
printf '%s, ' "${remove_packages[@]}" | sed 's/, $/./' | fold -s -w 80

echo -e "${colorblue}\nRealizar instalações e ajustes extras:${nocolor}"
echo "Instalar o grupo \"multimedia\" e o pacote \"steam-devices\", além de conceder ao \"Mangohud\""
echo "e ao \"Gamescope\" em Flatpak permissões para acessar a partição dos jogos."

echo -e "${coloryellow}\nEsse script foi pensado para ser executado apenas em instalações limpas do Fedora KDE${nocolor}"
echo -e "${coloryellow}após o sistema já ter sido totalmente atualizado e reiniciado.${nocolor}"

echo -e -n "${coloryellow}\nPressione ENTER para iniciar instalação das dependências ou CTRL+C para cancelar.${nocolor}"
read -r
echo

#-------------------------------------------------
# ---FASE 1 - Resolvendo dependências do script---
#-------------------------------------------------

sudo -v
while true; do sudo -v; sleep 60; done &
sudo_pid=$!
trap "kill $sudo_pid" EXIT

echo -e "${coloryellow}Instalando o \"snapd\"...${nocolor}"
sudo dnf install -y snapd
echo -e "${coloryellow}Criando link simbólico para Snapd...${nocolor}"
sudo ln -sfn /var/lib/snapd/snap /snap
echo -e "${coloryellow}Ativando serviço do Snapd...${nocolor}"
sudo systemctl enable --now snapd.socket
sudo snap wait system seed.loaded

if command -v snap &> /dev/null; then
  echo -e "${colorgreen}Snap instalado com sucesso!${nocolor}"
else
  echo -e "${colorred}\nErro: A instalação/ativação do comando \"snap\" falhou!${nocolor}"
  echo -e "${colorred}Verifique o funcionamento do mesmo e volte a rodar o script.${nocolor}"
  exit 7
fi

echo -e "${coloryellow}Adicionando o repositório \"Flathub\"...${nocolor}"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo -e "${coloryellow}Adicionando os repositórios \"free\" e \"non-free\" do \"RPM Fusion\".${nocolor}"
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo -e "${coloryellow}Fase de instalação de dependências finalizada.${nocolor}"

echo
echo -e -n "${coloryellow}Pressione ENTER para instalar os pacotes \"dnf\", flatpaks e snaps ou CTRL+C para cancelar.${nocolor}"
read -r
echo

#------------------------------------------------------------------------------
# ---FASE 2 - Instalando pacotes dos repositórios oficiais, flatpaks e snaps---
#------------------------------------------------------------------------------

# Instalação dos pacotes DNF:
echo -e "${coloryellow}Iniciando instalação dos pacotes \"dnf\".${nocolor}"
echo
sudo dnf install -y "${!dnf_packages[@]}"

# Instalação dos pacotes flatpak:
echo -e "${coloryellow}Iniciando a instalação dos pacotes flatpak${nocolor}"
echo
flatpak install -y --noninteractive flathub "${!flatpak_packages[@]}"

# Instalação dos pacotes snap:
#echo -e "${coloryellow}Iniciando a instalação dos pacotes snap.${nocolor}"
#echo
#sudo snap refresh
#sudo snap install "${!snap_packages[@]}"

echo -e "${coloryellow}Fase de instalação dos pacotes finalizada.${nocolor}"

echo
echo -e -n "${coloryellow}Pressione ENTER para baixar os arquivos .rpm  e .AppImage ou CTRL+C para cancelar.${nocolor}"
read -r
echo

#-----------------------------------------------------
# ---FASE 3 Downloads dos arquivos .rpm e .appimage---
#-----------------------------------------------------

echo -e "${coloryellow}Iniciando o download dos pacotes .rpm...${nocolor}"
echo
mkdir -p "$HOME/Downloads/RPMs"
for url in "${!rpm_downloads[@]}"; do
    wget --show-progress -P "$HOME/Downloads/RPMs" "$url"
done

echo -e "${coloryellow}Iniciando o download dos pacotes AppImage...${nocolor}"
echo
mkdir -p "$HOME/Downloads/AppImages"
for url in "${!appimages_downloads[@]}"; do
    wget --show-progress -P "$HOME/Downloads/AppImages" "$url"
done
echo -e "${coloryellow}Tornando os AppImages executáveis...${nocolor}"
chmod +x "$HOME/Downloads/AppImages/"*.AppImage 2>/dev/null

echo
echo -e "${coloryellow}Fase de Downloads finalizada.${nocolor}"
echo

echo -e -n "${coloryellow}Pressione ENTER para instalar os pacotes \".rpm\" ou CTRL+C para cancelar.${nocolor}"
read -r
echo

#------------------------------------------
# ---FASE 4 Instalação dos arquivos .rpm---
#------------------------------------------

echo -e "${coloryellow}Iniciando a instalação dos pacotes .rpm.${nocolor}"
echo
sudo dnf install -y "$HOME/Downloads/RPMs/"*.rpm

#--------------------------------------------------
# ---FASE 5 Desinstalação de pacotes indesejados---
#--------------------------------------------------

echo -e "${coloryellow}Agora, o script irá desinstalar os pacotes desnecessários.${nocolor}"
echo
echo -e -n "${coloryellow}Pressione ENTER para prosseguir ou CTRL+C para encerrar o script.${nocolor}"
read -r
echo
sudo dnf remove -y "${!remove_packages[@]}"
sudo dnf autoremove -y
echo

echo -e "${coloryellow}Por fim, o script irá instalar o grupo \"multimedia\", o pacote \"steam-devices\" e conceder${nocolor}"
echo -e "${coloryellow}ao \"Mangohud\" e ao \"Gamescope\" em Flatpak permissões para acessar a partição dos jogos.${nocolor}"
echo -e -n "${coloryellow}Pressione ENTER para continuar.${nocolor}"
read -r
echo

#----------------------------
# ---FASE 6 ajustes extras---
#----------------------------

#Instalação de Codecs multimídia.
echo -e "${coloryellow}Instalando codecs multimídia...${nocolor}"
sudo dnf group install multimedia -y

# Instalação do steam-devices para complementar a instalação da Steam em flatpak
sudo dnf install steam-devices -y

# Definindo o caminho para a partição aonde os jogos serão/estão instalados.

# Entrada de dados interativa.
# O loop vai rodar enquanto qualquer uma das variáveis estiver vazia.
while [[ -z "$gamesdata" || ! -d "$gamesdata" ]]; do

    echo -e "${colorred}--- Entrada de Dados (Campos Obrigatórios) ---${nocolor}"
    echo ""
    echo -e "${coloryellow}Definindo permissões para as versões em flatpak do mangohud e do gamescope:${nocolor}"
    echo -e "${coloryellow}Informe o caminho da pasta onde a partição de Jogos/Dados está montada.${nocolor}"
    echo -e "${coloryellow}Se possível, evite o uso de espaços no caminho do diretório.${nocolor}"
    read -r -p "Caminho do diretório: " gamesdata
    # Corrige "~/" para "/home/nomedousuario" para evitar erros na execução
    gamesdata="${gamesdata/#\~/$HOME}"

    if [[ -z "$gamesdata" || ! -d "$gamesdata" ]]; then
        echo -e "\n${colorred}ERRO: informe um diretório válido!${nocolor}\n"
    fi
done

# Feedback para o usuário sobre as variáveis que foram definidas.
echo -e "\n${colorgreen}Variáveis definidas com sucesso!${nocolor}\n"
echo -e "A partição de Jogos/Dados está montada em:${coloryellow} $gamesdata${nocolor}."

echo ""
echo -e -n "${coloryellow}Pressione ENTER para aplicar as permissões ou CTRL+C para cancelar.${nocolor}"
read -r

flatpak override --user --filesystem="$gamesdata:rw" org.freedesktop.Platform.VulkanLayer.MangoHud
flatpak override --user --filesystem="$gamesdata:rw" org.freedesktop.Platform.VulkanLayer.gamescope

echo ""
echo -e "${colorblue}As permissões foram aplicadas!${nocolor}"
echo -e "${colorgreen}Script finalizado! Recomenda-se reiniciar o sistema.${nocolor}"
