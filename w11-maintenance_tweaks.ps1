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

# Registros Críticos (Forçados)
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 0 /f
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f

Write-Host "SISTEMA BLINDADO COM SUCESSO!" -ForegroundColor Green
