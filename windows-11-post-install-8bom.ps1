# Script de instalação de aplicativos via winget
# Requer Windows 10 com App Installer (winget) já configurado.

# Comando para habilitar a execução de scripts:
# Set-ExecutionPolicy RemoteSigned

#------------------
# --- VARIÁVEIS ---
#------------------

$documents_source = "D:\Usuários\Documentos (Arquivo)"
$images_source = "D:\Usuários\Imagens (Arquivo)"
$downloads_source = "D:\Usuários\Downloads (Arquivo)"
$videos_source = "D:\Usuários\Vídeos (Arquivo)"
$music_source = "E:\Minhas Músicas"

$documents_dest = "$env:USERPROFILE\Documents\Documentos (Arquivo)"
$images_dest = "$env:USERPROFILE\Pictures\Imagens (Arquivo)"
$downloads_dest = "$env:USERPROFILE\Downloads\Downloads (Arquivo)"
$videos_dest = "$env:USERPROFILE\Videos\Vídeos (Arquivo)"
$music_dest = "$env:USERPROFILE\Music\Minhas Músicas"

#----------------------
# --- ARRAYS/LISTAS ---
#----------------------

# Pacotes para serem instalados com o winget:
$apps = @{
    # Launchers
    "Valve.Steam" = "Steam"
    "ElectronicArts.EADesktop" = "EA App"
    "GOG.Galaxy" = "GOG Galaxy"

    # Utilitários
    "Joplin.Joplin" = "Joplin"
    "Guru3D.Afterburner" = "MSI Afterburner"
    "VideoLAN.VLC" = "VLC Media Player"
    "LibreWolf.LibreWolf" = "Librewolf"
    "Audacity.Audacity" = "Audacity"
    "LocalSend.LocalSend" = "LocalSend"
    "7zip.7zip" = "7zip"
    "GIMP.GIMP.3" = "Gimp"
    "Upscayl.Upscayl" = "Upscayl"
    "qBittorrent.qBittorrent" = "qBittorrent"
    "Hydrogen-Music.Hydrogen" = "Hydrogen Drum Machine"
    "Notepad++.Notepad++" = "Notepad++"
    "9PGDP7TDQVX7" = "Media Downloader"
    "ente-io.auth-desktop" = "Ente Auth"
    "CPUID.CPU-Z" = "CPU-Z"
    "TechPowerUp.GPU-Z" = "GPU-Z"
    "Oracle.VirtualBox" = "VirtualBox"
    "Google.Chrome" = "Google Chrome"

    # Proton Apps
    "Proton.ProtonPass" = "Proton Pass"
    "Proton.ProtonVPN" = "Proton VPN"
}

$vcredists = @(
    "Microsoft.VCRedist.2005.x86",
    "Microsoft.VCRedist.2005.x64",
    "Microsoft.VCRedist.2008.x86",
    "Microsoft.VCRedist.2010.x86",
    "Microsoft.VCRedist.2010.x64",
    "Microsoft.VCRedist.2012.x86",
    "Microsoft.VCRedist.2012.x64",
    "Microsoft.VCRedist.2013.x86",
    "Microsoft.VCRedist.2013.x64",
    "Microsoft.VCRedist.2015+.x86",
    "Microsoft.VCRedist.2015+.x64"
)

# Links de download:
$downloads = @{
    "https://github.com/JediFonseca/strawberry/releases/download/1.2.19/StrawberrySetup-1.2.19.18.g91ad44c1-msvc-x64.exe" = "Strawberry Music Player"
    "https://www.remotemouse.net/downloads/RemoteMouse.exe" = "Remote Mouse"
}

#----------------
# --- FUNÇÕES ---
#----------------

function initial_message {
	
	clear
	
	Write-Host "################################################" -ForegroundColor Cyan
	Write-Host "##   Script de pós instalação do Windows 11   ##" -ForegroundColor Cyan
	Write-Host "################################################" -ForegroundColor Cyan
	Write-Host ""
	Write-Host "IMPORTANTE:" -ForegroundColor Red
	Write-Host "Antes de executar, leia as instruções no cabeçalho do script e verifique"
	Write-Host "os links de download. SEMPRE execute este script como administrador."
	Write-Host ""
	Write-Host "Ao ser executado, esse script irá:" -ForegroundColor Yellow
	Write-Host ""
	
	Write-Host "01. Instalar, com o winget, os apps:" -ForegroundColor Cyan
	$ListaApps = ((($apps.Values -join ', ') + '.') -replace "(.{1,80})(?:\s|$)", "`$1`n").Trim()
	Write-Host $ListaApps

	Write-Host '02. Instalar todos os "Microsoft VCRedists" de 2005 à 2015+;' -ForegroundColor Cyan
	Write-Host "03. Criar a pasta ""$env:USERPROFILE\Downloads\EXEs"";" -ForegroundColor Cyan

	Write-Host "04. Baixar os executáveis para os apps:" -ForegroundColor Cyan
	$ListaDownloads = ((($downloads.Values -join ', ') + '.') -replace "(.{1,80})(?:\s|$)", "`$1`n").Trim()
	Write-Host $ListaDownloads
	
	Write-Host "05. Habilitar o menu de contexto clássico;" -ForegroundColor Cyan
	Write-Host "06. Criar links simbólicos para as pastas do usuário;" -ForegroundColor Cyan
	Write-Host "07. Abrir páginas de downloads de drivers no site da AMD." -ForegroundColor Cyan
	Write-Host ""
	Write-Host "Pressione ENTER para iniciar a execução do script ou CTRL+C para cancelar." -ForegroundColor Yellow
	Read-Host
}

#-------------------------------------------------------------------------------------------

function install_apps {
	Write-Host "Instalando os apps com o winget..." -ForegroundColor Yellow

	foreach ($ident in $apps.Keys) {
		winget install --id $ident --accept-package-agreements --accept-source-agreements --silent
}
}

#-------------------------------------------------------------------------------------------

function vcr_install {
	Write-Host 'Instalando os "Microsoft VCRedists" de 2005 à 2015+...' -ForegroundColor Yellow

	foreach ($ident2 in $vcredists) {
		winget install --id $ident2 --accept-package-agreements --accept-source-agreements --silent
}	
}

#-------------------------------------------------------------------------------------------

function download_exes {
	
	Write-Host "Criando a pasta EXEs..." -ForegroundColor Yellow
	New-Item -Path "$env:USERPROFILE\Downloads\EXEs" -ItemType Directory -Force | Out-Null
	$destino = "$env:USERPROFILE\Downloads\EXEs"

	Write-Host "Fazendo o download dos EXEs..." -ForegroundColor Yellow
	
	foreach ($url in $downloads.Keys) {
		$saida = Join-Path $destino (Split-Path $url -Leaf)
		curl.exe -L -C - "$url" -o "$saida" -#
}
}

#-------------------------------------------------------------------------------------------

function context_menu {
	Write-Host "Habilitando o menu de contexto clássico..." -ForegroundColor Yellow
	reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

	Write-Host "Pressione ENTER para reiniciar o explorer e aplicar a alteração." -ForegroundColor Yellow
	Read-Host

	Stop-Process -Name explorer -Force
	Start-Process explorer.exe
	Write-Host 'Iniciando o processo "explorer.exe". Aguarde...' -ForegroundColor Yellow
	Start-Sleep -Seconds 5
	Write-Host "Menu de contexto clássico habilitado!" -ForegroundColor Green
}

#-------------------------------------------------------------------------------------------

function user_folders {
	Write-Host 'Criando as pastas do usuário na partição "Dados" (Se não existirem)...' -ForegroundColor Yellow
	New-Item -Path "$documents_source" -ItemType Directory -Force | Out-Null
	New-Item -Path "$downloads_source" -ItemType Directory -Force | Out-Null
	New-Item -Path "$images_source" -ItemType Directory -Force | Out-Null
	New-Item -Path "$videos_source" -ItemType Directory -Force | Out-Null
	New-Item -Path "$music_source" -ItemType Directory -Force | Out-Null
	
	New-Item -Path "$documents_dest" -Target "$documents_source" -ItemType SymbolicLink -Force | Out-Null
	New-Item -Path "$downloads_dest" -Target "$downloads_source" -ItemType SymbolicLink -Force | Out-Null
	New-Item -Path "$images_dest" -Target "$images_source" -ItemType SymbolicLink -Force | Out-Null
	New-Item -Path "$videos_dest" -Target "$videos_source" -ItemType SymbolicLink -Force | Out-Null
	New-Item -Path "$music_dest" -Target "$music_source" -ItemType SymbolicLink -Force | Out-Null
}

#-------------------------------------------------------------------------------------------

function final_message {
	Write-Host "Script finalizado!" -ForegroundColor Yellow
	Write-Host "Pressione ENTER se você deseja abrir as páginas de downloads de drivers no site da AMD" -ForegroundColor Yellow
	Write-Host "ou CTRL+C para não abrir a página e encerrar a execução do script agora." -ForegroundColor Yellow
	Read-Host
	
	Start-Process "msedge.exe" "https://www.amd.com/pt/support/downloads/drivers.html/graphics/radeon-600-500-400/radeon-rx-500-series/radeon-rx-580.html"
	Start-Sleep -Seconds 1
	Start-Process "msedge.exe" "https://www.amd.com/pt/support/downloads/drivers.html/chipsets/am4/b450.html"
	Write-Host "Você chegou ao final do script." -ForegroundColor Green
}

#---------------------------
# --- EXECUÇÃO DO SCRIPT ---
#---------------------------

if ($args.Count -eq 0) {
    # Roda o script completo
    initial_message
    install_apps
	vcr_install
    download_exes
	context_menu
	user_folders
	final_message
    Write-Host "`nScript finalizado! Recomenda-se reiniciar o sistema." -ForegroundColor Green
}
else {
    # Itera sobre cada argumento passado no comando
    foreach ($argumento in $args) {
        switch ($argumento) {
            "--init"    { initial_message }
            "--apps"    { install_apps }
            "--vcr"     { vcr_install }
            "--exes"    { download_exes }
            "--menu"    { context_menu }
            "--final"   { final_message }
            "--folders" { user_folders }
            Default { 
                Write-Host "Opção inválida: $argumento" -ForegroundColor Red
            }
        }
    }
}
