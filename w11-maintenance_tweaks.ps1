<#
    SUPER SCRIPT DE RESTAURAÇÃO - VERSÃO BLINDADA (v3.0)
    Fiel ao autounattend.xml com correções estruturais de segurança e agendamento.
#>

# Configurações de ambiente
$ScriptDir = "C:\Windows\Setup\Scripts"
if (!(Test-Path $ScriptDir)) { New-Item -Path $ScriptDir -ItemType Directory }

Write-Host "Iniciando Restauração de Elite (Padrão Blindado)..." -ForegroundColor Cyan

# --- 2. RE-APLICAR OTIMIZAÇÕES E REMOÇÕES ---
Write-Host "Limpando Bloatware e forçando registros HKLM..." -ForegroundColor Yellow

$packages = @('Microsoft.Microsoft3DViewer','Microsoft.BingSearch','Microsoft.WindowsCamera','Clipchamp.Clipchamp','Microsoft.WindowsAlarms','Microsoft.Copilot','Microsoft.549981C3F5F10','Microsoft.Windows.DevHome','MicrosoftCorporationII.MicrosoftFamily','Microsoft.WindowsFeedbackHub','Microsoft.Edge.GameAssist','Microsoft.GetHelp','Microsoft.Getstarted','microsoft.windowscommunicationsapps','Microsoft.WindowsMaps','Microsoft.MixedReality.Portal','Microsoft.BingNews','Microsoft.MicrosoftOfficeHub','Microsoft.Office.OneNote','Microsoft.OutlookForWindows','Microsoft.Paint','Microsoft.MSPaint','Microsoft.People','Microsoft.PowerAutomateDesktop','MicrosoftCorporationII.QuickAssist','Microsoft.SkypeApp','Microsoft.ScreenSketch','Microsoft.MicrosoftSolitaireCollection','Microsoft.MicrosoftStickyNotes','MicrosoftTeams','MSTeams','Microsoft.Todos','Microsoft.WindowsSoundRecorder','Microsoft.Wallet','Microsoft.BingWeather','Microsoft.Xbox.TCUI','Microsoft.XboxApp','Microsoft.YourPhone','Microsoft.ZuneVideo')

foreach ($app in $packages) {
    Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq $app} | Remove-AppxProvisionedPackage -AllUsers -Online -ErrorAction SilentlyContinue
}

# Bloquear reinstalação silenciosa de bloatware
$cdmPath = "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
$cdmNames = @('ContentDeliveryAllowed','SilentInstalledAppsEnabled','OEMPreInstalledAppsEnabled',
              'PreInstalledAppsEnabled','SubscribedContentEnabled')
foreach ($name in $cdmNames) {
    reg.exe add $cdmPath /v $name /t REG_DWORD /d 0 /f
}

# Restaurar menu de contexto clássico
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

# Restaurar plano de energia Máximo Desempenho
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61

# Registros Críticos (Forçados)
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 0 /f
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f

Write-Host "SISTEMA BLINDADO COM SUCESSO!" -ForegroundColor Green

