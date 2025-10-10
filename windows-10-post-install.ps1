# Script de instalação de aplicativos via winget
# Requer Windows 10 com App Installer (winget) já configurado

# Comando para habilitar a execução de scripts:
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

# Lista de pacotes
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

# Instalação em loop
foreach ($app in $apps) {
    Write-Host "`nInstalando: $app" -ForegroundColor Cyan
    winget install --id $app --accept-package-agreements --accept-source-agreements
}