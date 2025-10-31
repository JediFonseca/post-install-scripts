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
    "Automattic.Simplenote",
    "EmoteInteractive.RemoteMouse",
    "VideoLAN.VLC",
    "Mozilla.Firefox.pt-BR",
    "Audacity.Audacity",
    "LocalSend.LocalSend",
    "7zip.7zip",
    "GIMP.GIMP.3",
    "Upscayl.Upscayl",
    "qBittorrent.qBittorrent",
    "Hydrogen-Music.Hydrogen",
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
    "https://downloader.markopejic.com/static/Media%20Downloader%20v5.0.0%20Installer.zip",
    "https://www.foobar2000.org/downloads/foobar2000-x64_v2.25.3.exe",
    "https://www.foobar2000.org/getcomponent/2e7ae2f1682c8cd507188453d6c590f6/foo_scrobble-1.6.0.22456.fb2k-component",
    "https://www.foobar2000.org/getcomponent/e49c218fdddd549e5e428dc63acb8aff/foo_openlyrics-v1.12.fb2k-component",
    "https://www.oo-software.com/en/download/current/ooshutup10"
    "https://www.x360ce.com/files/x360ce.zip"
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
Write-Host "   GOG Galaxy, Simplenote, Remote Mouse, VLC, iTunes, Firefox, Audacity, Localsend, 7zip, Gimp,"
Write-Host "   Upscayl, qBittorrent, Hydrogen, Terabox, Proton Pass e Proton Authenticator."
Write-Host "2. Instalar os Microsoft Virtual C++ Redistributable de 32 e 64 bits nas versões de"
Write-Host "   2005, 2008, 2010, 2012, 2013 e 2015+."
Write-Host "3. Baixar os executáveis dos apps: Media Downloader, O&O ShutUp10++, foobar2000 e x360ce."
Write-Host "4. Baixar os plugins para o foobar2000: foo_scrobble e OpenLyrics."
Write-Host "5. Habilitar o menu de contexto clássico e reiniciar o processo explorer.exe."
Write-Host "6. (Opcional) Abrir o navegador padrão na página de download do driver da RX580."
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

# Pasta de destino
$destino = "$env:USERPROFILE\Downloads\EXEs"

# Downloads com status em MB
foreach ($url in $downloads) {
    $saida = Join-Path $destino (Split-Path $url -Leaf)
    curl.exe -L -C - $url -o $saida -#
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

#--------------------------------------------------------
# ---Habilitando o modo de energia "Máximo Desempenho"---
#--------------------------------------------------------

Write-Host "Habilitando o modo de energia Máximo Desempenho..." -ForegroundColor Yellow
Write-Host "." -ForegroundColor Green
Write-Host ".." -ForegroundColor Green
Write-Host "..." -ForegroundColor Green
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
Write-Host "Modo de energia Máximo Desempenho habilitado." -ForegroundColor Yellow

# Mensagem final

Write-Host "Script finalizado!" -ForegroundColor Yellow
Write-Host "Pressione ENTER se você deseja abrir a página de download do driver da RX580 no site da AMD" -ForegroundColor Yellow
Write-Host "ou CTRL+C para não abrir a página e encerrar a execução do script agora." -ForegroundColor Yellow
Read-Host
Start-Process "https://www.amd.com/pt/support/downloads/drivers.html/graphics/radeon-600-500-400/radeon-rx-500-series/radeon-rx-580.html"
Write-Host "Você chegou ao final do script." -ForegroundColor Green










