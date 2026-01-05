<#
    SUPER SCRIPT DE RESTAURAÇÃO - VERSÃO BLINDADA (v3.0)
    Fiel ao autounattend.xml com correções estruturais de segurança e agendamento.
#>

# Configurações de ambiente
$ScriptDir = "C:\Windows\Setup\Scripts"
if (!(Test-Path $ScriptDir)) { New-Item -Path $ScriptDir -ItemType Directory }

Write-Host "Iniciando Restauração de Elite (Padrão Blindado)..." -ForegroundColor Cyan

# --- 1. RESTAURAR BLOQUEIO PERPÉTUO DO WINDOWS UPDATE (CORRIGIDO) ---
Write-Host "Configurando Tarefa de Bloqueio (SYSTEM + Repetição Horária)..." -ForegroundColor Yellow

# Script de pausa (Mantido, pois a lógica de data funciona bem)
$pauseScript = @'
$formatter = { $args[0].ToString("yyyy'-'MM'-'dd'T'HH':'mm':'ssK") };
$now = [datetime]::UtcNow;
$start = &$formatter $now;
$end = &$formatter $now.AddDays(7);
$params = @{ LiteralPath = 'Registry::HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings'; Type = 'String'; Force = $true };
Set-ItemProperty @params -Name 'PauseFeatureUpdatesStartTime' -Value $start;
Set-ItemProperty @params -Name 'PauseFeatureUpdatesEndTime' -Value $end;
Set-ItemProperty @params -Name 'PauseQualityUpdatesStartTime' -Value $start;
Set-ItemProperty @params -Name 'PauseQualityUpdatesEndTime' -Value $end;
Set-ItemProperty @params -Name 'PauseUpdatesStartTime' -Value $start;
Set-ItemProperty @params -Name 'PauseUpdatesExpiryTime' -Value $end;
'@
$pauseScript | Out-File -FilePath "$ScriptDir\PauseWindowsUpdate.ps1" -Encoding UTF8

# XML da Tarefa corrigido para SYSTEM (S-1-5-18) e CalendarTrigger
$taskXml = @"
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
	<Triggers>
		<CalendarTrigger>
			<StartBoundary>2024-01-01T00:00:00</StartBoundary>
			<Enabled>true</Enabled>
			<ScheduleByDay>
				<DaysInterval>1</DaysInterval>
			</ScheduleByDay>
			<Repetition>
				<Interval>PT1H</Interval>
				<StopAtDurationEnd>false</StopAtDurationEnd>
			</Repetition>
		</CalendarTrigger>
	</Triggers>
	<Principals>
		<Principal id="Author">
			<UserId>S-1-5-18</UserId>
			<RunLevel>HighestAvailable</RunLevel>
		</Principal>
	</Principals>
	<Settings>
		<MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
		<DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
		<StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
		<AllowHardTerminate>true</AllowHardTerminate>
		<StartWhenAvailable>true</StartWhenAvailable>
		<RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
		<IdleSettings>
			<StopOnIdleEnd>false</StopOnIdleEnd>
			<RestartOnIdle>false</RestartOnIdle>
		</IdleSettings>
		<AllowStartOnDemand>true</AllowStartOnDemand>
		<Enabled>true</Enabled>
		<Hidden>true</Hidden>
		<ExecutionTimeLimit>PT1H</ExecutionTimeLimit>
		<Priority>7</Priority>
	</Settings>
	<Actions Context="Author">
		<Exec>
			<Command>C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe</Command>
			<Arguments>-ExecutionPolicy "Unrestricted" -NoProfile -File "$ScriptDir\PauseWindowsUpdate.ps1"</Arguments>
		</Exec>
	</Actions>
</Task>
"@
$taskXml | Out-File -FilePath "$ScriptDir\PauseWindowsUpdate.xml" -Encoding UTF8

# Registra a tarefa com força total
Register-ScheduledTask -TaskName 'PauseWindowsUpdate' -Xml (Get-Content "$ScriptDir\PauseWindowsUpdate.xml" -Raw) -Force

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