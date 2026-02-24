<#
    SUPER SCRIPT DE RESTAURAÇÃO - VERSÃO BLINDADA (v4.0)
    Fiel ao autounattend.xml com correções estruturais de segurança e agendamento.
#>

# Configurações de ambiente
$ScriptDir = "C:\Windows\Setup\Scripts"
if (!(Test-Path $ScriptDir)) { New-Item -Path $ScriptDir -ItemType Directory }

Write-Host "Iniciando Restauração de Elite (Padrão Blindado)..." -ForegroundColor Cyan

# --- 1. LIMPEZA DE BLOATWARE ---
Write-Host "Limpando Bloatware..." -ForegroundColor Yellow

$packages = @(
    'Microsoft.Microsoft3DViewer',
    'Microsoft.BingSearch',
    'Microsoft.WindowsCamera',
    'Clipchamp.Clipchamp',
    'Microsoft.WindowsAlarms',
    'Microsoft.Copilot',
    'Microsoft.549981C3F5F10',
    'Microsoft.Windows.DevHome',
    'MicrosoftCorporationII.MicrosoftFamily',
    'Microsoft.WindowsFeedbackHub',
    'Microsoft.Edge.GameAssist',
    'Microsoft.GetHelp',
    'Microsoft.Getstarted',
    'microsoft.windowscommunicationsapps',
    'Microsoft.WindowsMaps',
    'Microsoft.MixedReality.Portal',
    'Microsoft.BingNews',
    'Microsoft.MicrosoftOfficeHub',
    'Microsoft.Office.OneNote',
    'Microsoft.OutlookForWindows',
    'Microsoft.Paint',
    'Microsoft.MSPaint',
    'Microsoft.People',
    'Microsoft.PowerAutomateDesktop',
    'MicrosoftCorporationII.QuickAssist',
    'Microsoft.SkypeApp',
    'Microsoft.ScreenSketch',
    'Microsoft.MicrosoftSolitaireCollection',
    'Microsoft.MicrosoftStickyNotes',
    'MicrosoftTeams',
    'MSTeams',
    'Microsoft.Todos',
    'Microsoft.WindowsSoundRecorder',
    'Microsoft.Wallet',
    'Microsoft.BingWeather',
    'Microsoft.Xbox.TCUI',
    'Microsoft.XboxApp',
    'Microsoft.YourPhone',
    'Microsoft.ZuneVideo'
)

foreach ($app in $packages) {
    Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq $app} | Remove-AppxProvisionedPackage -AllUsers -Online -ErrorAction SilentlyContinue
}

# --- 2. BLOQUEAR REINSTALAÇÃO SILENCIOSA DE BLOATWARE ---
Write-Host "Bloqueando reinstalação silenciosa de bloatware (ContentDeliveryManager)..." -ForegroundColor Yellow

$cdmPath = "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
$cdmNames = @(
    'ContentDeliveryAllowed',
    'FeatureManagementEnabled',
    'OEMPreInstalledAppsEnabled',
    'PreInstalledAppsEnabled',
    'PreInstalledAppsEverEnabled',
    'SilentInstalledAppsEnabled',
    'SoftLandingEnabled',
    'SubscribedContentEnabled',
    'SubscribedContent-310093Enabled',
    'SubscribedContent-338387Enabled',
    'SubscribedContent-338388Enabled',
    'SubscribedContent-338389Enabled',
    'SubscribedContent-338393Enabled',
    'SubscribedContent-353694Enabled',
    'SubscribedContent-353696Enabled',
    'SubscribedContent-353698Enabled',
    'SystemPaneSuggestionsEnabled'
)

foreach ($name in $cdmNames) {
    reg.exe add $cdmPath /v $name /t REG_DWORD /d 0 /f
}

# --- 3. RESTAURAR MENU DE CONTEXTO CLÁSSICO ---
Write-Host "Restaurando menu de contexto clássico..." -ForegroundColor Yellow

reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

# --- 5. REGISTROS CRÍTICOS (HKLM e HKCU) ---
Write-Host "Forçando registros críticos..." -ForegroundColor Yellow

# Desativar Virtualização Baseada em Segurança (VBS) — necessário para VirtualBox
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 0 /f

# Desativar Fast Startup (Inicialização Rápida)
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f

# Habilitar caminhos longos no sistema de arquivos
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f

# Barra de tarefas alinhada à esquerda
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 0 /f

# Mostrar extensões de arquivos
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f

Write-Host "SISTEMA BLINDADO COM SUCESSO!" -ForegroundColor Green

