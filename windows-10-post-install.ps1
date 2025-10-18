# Script de instalação de aplicativos via winget
# Requer Windows 10 com App Installer (winget) já configurado.

# Rodar primeiro o comando para habilitar a execução de scripts:
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

# Rodar o script no terminal (como administrador) com o comando:
# powershell -ExecutionPolicy Bypass -File "C:\Users\jedif\Downloads\windows-10-post-install.ps1"

#------------------------------------------
# ---Pacotes para instalação e downloads---
#------------------------------------------

# Pacotes para serem instalados com o winget:
$apps = @(
    # Launchers
    "Valve.Steam",
    "EpicGames.EpicGamesLauncher",
    "ElectronicArts.EADesktop",
    "Ubisoft.Connect",
    "GOG.Galaxy",

    # Utilitários
    "Streetwriters.Notesnook",
    "EmoteInteractive.RemoteMouse",
    "VideoLAN.VLC",
    "Mozilla.Firefox",
    "Audacity.Audacity",
    "LocalSend.LocalSend",
    "7zip.7zip",
    "GIMP.GIMP.3",
    "Upscayl.Upscayl",
    "qBittorrent.qBittorrent",
    "Hydrogen-Music.Hydrogen",
    "Clementine.Clementine",
    "Baidu.TeraBox",

    # Proton Apps
    "Proton.ProtonPass",
    "Proton.ProtonAuthenticator",

    # Visual C++ Redistributables
    "Microsoft.VCRedist.2005.x86",
    "Microsoft.VCRedist.2005.x64",
    "Microsoft.VCRedist.2008.x86",
    "Microsoft.VCRedist.2008.x64",
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
$downloads = @(
    "https://downloader.markopejic.com/static/Media%20Downloader%20v5.0.0%20Installer.zip"
)

#-----------------------
# ---Mensagem inicial---
#-----------------------

Write-Host "################################################" -ForegroundColor Cyan
Write-Host "##   Script de pós instalação do Windows 11   ##" -ForegroundColor Cyan
Write-Host "################################################" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANTE:" -ForegroundColor Red
Write-Host "Antes de executar, leia as instruções no cabeçalho do script e verifique"
Write-Host "os links de download. SEMPRE execute este script como administrador."
Write-Host ""
Write-Host "Ao ser executado, este script irá:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Instalar, com o winget, os pacotes: Steam, Epic Games Launcher, EA App, Ubisoft Connect,"
Write-Host "   GOG Galaxy, Notesnook, Remote Mouse, VLC, Firefox, Audacity, Localsend, 7zip, Gimp,"
Write-Host "   Upscayl, qBittorrent, Hydrogen, Clementine, Terabox, Proton Pass e Proton Authenticator."
Write-Host "2. Instalar os Microsoft Virtual C++ Redistributable de 32 e 64 bits nas versões de"
Write-Host "   2005, 2008, 2010, 2012, 2013 e 2015+."
Write-Host "3. Baixar os executáveis dos apps: Media Downloader e Driver AMD para a RX580 no Windows 11."
Write-Host "4. Habilitar o menu de contexto clássico do Windows 10 e reiniciar o explorer."
Write-Host ""
Write-Host "Pressione ENTER para iniciar a execução do script ou CTRL+C para cancelar." -ForegroundColor Yellow
Read-Host

#------------------------------------------
# ---Instalação dos pacotes com o winget---
#------------------------------------------

Write-Host "Instalando os apps com o winget..." -ForegroundColor Yellow

foreach ($app in $apps) {
    winget install --id $app --accept-package-agreements --accept-source-agreements --silent
}

#----------------------------------
# ---Fazendo o download dos EXEs---
#----------------------------------

Write-Host "Criando a pasta EXEs..." -ForegroundColor Yellow

# Cria pasta "EXEs" dentro de Downloads
New-Item -Path "$env:USERPROFILE\Downloads\EXEs" -ItemType Directory | Out-Null

Write-Host "Fazendo o download dos EXEs..." -ForegroundColor Yellow

# Define a pasta de destino
$destino = "$env:USERPROFILE\Downloads\EXEs"

# Loop para baixar cada arquivo
foreach ($url in $downloads) {
    $nomeArquivo = Split-Path $url -Leaf
    $arquivoDestino = Join-Path $destino $nomeArquivo
    Invoke-WebRequest -Uri $url -OutFile $arquivoDestino
}

#----------------------------------------------
# ---Habilitando o menu de contexto clássico---
#----------------------------------------------

Write-Host "Habilitando o menu de contexto clássico..." -ForegroundColor Yellow

reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

Write-Host "Pressione ENTER para reiniciar o explorer e aplicar a alteração." -ForegroundColor Yellow
Read-Host

Stop-Process -Name explorer -Force
Start-Process explorer.exe

# Mensagem final

Write-Host "Script finalizado. Pressione ENTER para encerrar a execução." -ForegroundColor Yellow

Read-Host
