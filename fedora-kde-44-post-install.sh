#!/bin/bash

#--------------------------------------------------------------------
# Script de pós instalação para Fedora KDE 44 -----------------------
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

# Arquivo de configuração do Strawberry
strawlink="https://github.com/JediFonseca/strawberry/releases/download/1.2.18/strawberry.conf"
strawpath="$HOME/.var/app/org.strawberrymusicplayer.strawberry/config/strawberry/"

#----------------------
# --- LISTAS/ARRAYS ---
#----------------------

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

declare -A scripts_downloads=(
    ["https://raw.githubusercontent.com/JediFonseca/personal-scripts/main/myscripts"]="My Scripts"
    ["https://raw.githubusercontent.com/JediFonseca/personal-scripts/main/request-vm-ip"]="Request VM IP"
    ["https://raw.githubusercontent.com/JediFonseca/personal-scripts/main/rsync-go"]="Rsync Go"
    ["https://raw.githubusercontent.com/JediFonseca/personal-scripts/main/fedoraup"]="Fedora Up"
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
    ["libreoffice-*"]="LibreOffice"
    ["elisa-player"]="Elisa Player"
    ["akregator"]="Akregator"
    ["kamoso"]="Kamoso"
    ["kleopatra"]="Kleopatra"
    ["kmahjongg"]="Kmahjongg"
    ["kmines"]="Kmines"
    ["kolourpaint"]="KolourPaint"
    ["krdc"]="KRDC"
    ["krfb"]="Krfb"
    ["kpat"]="KPatience"
    ["kjournald"]="Kjournald"
    ["neochat"]="NeoChat"
    ["qrca"]="Qrca"
    ["skanpage"]="Skanpage"
)

#----------------
# --- FUNÇÕES ---
#----------------

# Função para criar links simbólicos para as pastas do usuário,
# além de baixar o .conf do Strawberry para a pasta correta.
my_folders () {
echo -e "${coloryellow}Criando os links para as pastas do usuário...${nocolor}"
echo
ln -sfn "$source_documents" "$dest_documents"
ln -sfn "$source_downloads" "$dest_downloads"
ln -sfn "$source_music" "$dest_music"
ln -sfn "$source_images" "$dest_images"
ln -sfn "$source_videos" "$dest_videos"

mkdir -p "$strawpath"
wget -nc -P "$strawpath" "$strawlink"

}



# Função para baixar scripts e copiá-los para o diretório correto
my_scripts () {
echo -e "${coloryellow}Iniciando o download dos scripts pessoais...${nocolor}"
echo
mkdir -p "$HOME/.local/bin"
for url1 in "${!scripts_downloads[@]}"; do
    wget -N -P "$HOME/.local/bin" "$url1"
done
chmod +x "$HOME/.local/bin/"* &>/dev/null
}



#Função para manter o sudo autenticado
sudo_alive () {
sudo -v
while true; do sudo -v; sleep 60; done &
sudo_pid=$!
trap "kill $sudo_pid" EXIT
}



# Função com as checagens de segurança
basic_dependencies () {
command -v dnf >/dev/null || exit 1
command -v wget >/dev/null || exit 2
command -v mkdir >/dev/null || exit 3
command -v ping >/dev/null || exit 4
command -v chmod >/dev/null || exit 5
command -v flatpak >/dev/null || exit 6
}



# Função com a checagem de conexão com a internet
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
     exit 7
fi
}



# Função com a mensagem inicial
starting_message () {
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

echo -e "${colorblue}\nInstalar via Snap:${nocolor}"
printf '%s, ' "${snap_packages[@]}" | sed 's/, $/./' | fold -s -w 80

echo -e "${colorblue}\nBaixar e instalar via .rpm:${nocolor}"
printf '%s, ' "${rpm_downloads[@]}" | sed 's/, $/./' | fold -s -w 80

echo -e "${colorblue}\nBaixar e permitir a execução dos AppImages:${nocolor}"
printf '%s, ' "${appimages_downloads[@]}" | sed 's/, $/./' | fold -s -w 80

echo -e "${colorblue}\nDesinstalar os pacotes:${nocolor}"
printf '%s, ' "${remove_packages[@]}" | sed 's/, $/./' | fold -s -w 80

echo -e "${colorblue}\nBaixar e permitir a execução dos scripts pessoais:${nocolor}"
printf '%s, ' "${scripts_downloads[@]}" | sed 's/, $/./' | fold -s -w 80

echo -e "${colorblue}\nCriar os links simbólicos para as pastas:${nocolor}"
echo "Documentos (Arquivo), Downloads (Arquivo), Minhas Músicas, Imagens (Arquivo) e Vídeos (Arquivo)."

echo -e "${colorblue}\nRealizar instalações e ajustes extras:${nocolor}"
echo "Instalar o grupo \"multimedia\" e o pacote \"steam-devices\", além de conceder ao \"Mangohud\""
echo "e ao \"Gamescope\" em Flatpak permissões para acessar a partição dos jogos."

echo -e "${coloryellow}\nEsse script foi pensado para ser executado apenas em instalações limpas do Fedora KDE${nocolor}"
echo -e "${coloryellow}após o sistema já ter sido totalmente atualizado e reiniciado.${nocolor}"

echo -e "\nPara ajuda e mais informações rode: ${colorblue}\"./fedora-kde-44-post-install.sh --help\"${nocolor}."

echo -e -n "${coloryellow}\nPressione ENTER para iniciar a execução do script ou CTRL+C para cancelar.${nocolor}"
read -r
echo
}



# Função de instalação de dependências para o script
dependencies_installation () {
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
  exit 8
fi

echo -e "${coloryellow}Adicionando o repositório \"Flathub\"...${nocolor}"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo -e "${coloryellow}Adicionando os repositórios \"free\" e \"non-free\" do \"RPM Fusion\".${nocolor}"
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo -e "${coloryellow}Fase de instalação de dependências finalizada.${nocolor}"
}



# Função de instalação dos pacotes via dnf
dnf_installation () {
echo -e "${coloryellow}Iniciando instalação dos pacotes \"dnf\".${nocolor}"
echo
sudo dnf install -y "${!dnf_packages[@]}"
}



# Função de instalação dos pacotes flatpak
flatpak_installation () {
echo -e "${coloryellow}Iniciando a instalação dos pacotes flatpak${nocolor}"
echo
flatpak install -y --noninteractive flathub "${!flatpak_packages[@]}"
}



# Função de instalação dos pacotes snap
snap_installation () {
echo -e "${coloryellow}Iniciando a instalação dos pacotes snap.${nocolor}"
echo
sudo snap refresh
for sname in "${!snap_packages[@]}"; do
    sudo snap install "$sname"
done
}



# Função de download dos arquivos rpm
rpm_downloads_list () {
echo -e "${coloryellow}Iniciando o download dos pacotes .rpm...${nocolor}"
echo
mkdir -p "$HOME/Downloads/RPMs"
for url2 in "${!rpm_downloads[@]}"; do
    wget --show-progress -P "$HOME/Downloads/RPMs" "$url2"
done
}



# Função com download e permissões de execução dos arquivos AppImage
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



# Função de instalação dos pacotes .rpm
rpm_installation () {
echo -e "${coloryellow}Iniciando a instalação dos pacotes .rpm.${nocolor}"
echo
sudo dnf install -y "$HOME/Downloads/RPMs/"*.rpm
}



# Função com a instalação de pacotes complementares
additional_packages () {
sudo dnf group install multimedia -y
sudo dnf install steam-devices -y
}



# Função com a remoção de pacotes indesejados
remove_packages_list () {
echo -e "${coloryellow}Desinstalando os pacotes indesejados.${nocolor}"
echo
sudo dnf remove -y "${!remove_packages[@]}"
sudo dnf autoremove -y
}



# Função que concede permissões para que o Mangohud e o Gamescope em flatpak possam acessar a partição de jogos
flatpak_permissions () {
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

echo -e "${coloryellow}As permissões foram aplicadas!${nocolor}"
}



# Função de ajuda
help_section () {

clear

echo -e "${colorblue}###################################################${nocolor}"
echo -e "${colorblue}##   Script de pós instalação do Fedora KDE 44   ##${nocolor}"
echo -e "${colorblue}###################################################${nocolor}"
echo
echo -e "${coloryellow}Como usar esse script:${nocolor}"
echo
echo "Para executar o script por completo, basta rodar \"./fedora-kde-44-post-install.sh\"."
echo "Você também pode rodar etapas específicas de forma isolada."
echo "Para isso, basta rodar o script com um (ou mais) dos parâmetros abaixo:"
echo
echo "--sudo-alive    #Autentica o \"sudo\" e o mantém assim até o encerramento do script."
echo "--basics        #Verifica se dependências básicas do script (como o dnf) estão instalados."
echo "--net           #Checa a conexão com a internet."
echo "--dependencies  #Instala todas as dependências necessárias para o funcionamento do script."
echo "--dnf           #Instala os pacotes listados via dnf."
echo "--flatpak       #Instala os pacotes listados via flatpak."
echo "--snap          #Instala os pacotes listados via snap."
echo "--rpmd          #Baixa os arquivos .rpm à partir dos links fornecidos."
echo "--appimage      #Baixa os arquivos .AppImage à partir dos links fornecidos."
echo "--rpmi          #Instala os pacotes .rpm baixados."
echo "--add           #Instala pacotes adicionais complementares, como o \"steam-devices\"."
echo "--remove        #Desinstala os pacotes indicados na lista correspondente."
echo "--flatpak-per   #Ajusta as permissões do Mangohud e do Gamescope em flatpak."
echo "--myscripts     #Baixa e dá permissões de execução aos scripts pessoais."
echo "--myfolders     #Cria os links simbólicos para as pastas do usuário."
echo
echo "As funções irão rodar na mesma ordem que os parâmetros forem inseridos no comando."
echo
echo "Para informações mais detalhadas, leia o script."
echo
echo -e "${coloryellow}Exemplo de execução com parâmetros:${nocolor}"
echo "./fedora-kde-44-post-install.sh --basics --dependencies --dnf"
echo
echo -e "${coloryellow}Repositório oficial do projeto:${nocolor}"
echo "https://github.com/JediFonseca/post-install-scripts"
echo
}

#-------------------------------------
# --- Início da execução do script ---
#-------------------------------------

if [[ $# -eq 0 ]]; then

    basic_dependencies
    internet_connection
    starting_message
    sudo_alive
    dependencies_installation
    dnf_installation
    flatpak_installation
    snap_installation
    rpm_downloads_list
    appimage_downloads_list
    rpm_installation
    additional_packages
    remove_packages_list
    my_scripts
    my_folders
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
            --dnf)          dnf_installation ;;
            --flatpak)      flatpak_installation ;;
            --snap)         snap_installation ;;
            --rpmd)         rpm_downloads_list ;;
            --appimage)     appimage_downloads_list ;;
            --rpmi)         rpm_installation ;;
            --add)          additional_packages ;;
            --remove)       remove_packages_list ;;
            --flatpak-per)  flatpak_permissions ;;
            --myscripts)    my_scripts ;;
            --myfolders)    my_folders ;;
            --help)         help_section ;;
            *)
                echo -e "${colorred}Opção inválida: $arg${nocolor}"
                exit 8
                ;;
        esac
    done

fi
