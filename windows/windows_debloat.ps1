#Requires -RunAsAdministrator

# Para rodar, execute:
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# 1. Listas --------------------------------------------------------------------------------#

$AppsToRemove = @(
    "MicrosoftCorporationII.QuickAssist",         # Assistencia Rapida
    "Microsoft.WindowsCamera",                    # Camera
    "Microsoft.BingWeather",                      # Clima
    "Microsoft.WindowsSoundRecorder",             # Gravador de Som
    "Microsoft.WindowsFeedbackHub",               # Hub de Comentarios
    "Microsoft.BingSearch",                       # Microsoft Bing
    "Clipchamp.Clipchamp",                        # Microsoft Clipchamp
    "Microsoft.BingNews",                         # Microsoft Noticias
    "MSTeams",                                    # Microsoft Teams
    "Microsoft.Todos",                            # Microsoft To Do
    "Microsoft.MicrosoftStickyNotes",             # Notas Autoadesivas
    "Microsoft.OutlookForWindows",                # Outlook
    "Microsoft.Paint",                            # Paint
    "Microsoft.MSPaint",                          # Paint (legado)
    "Microsoft.PowerAutomateDesktop",             # Power Automate
    "Microsoft.WindowsAlarms",                    # Relogio
    "Microsoft.ZuneMusic",                        # Reprodutor Multimidia
    "Microsoft.MicrosoftSolitaireCollection",     # Solitaire & Casual Games
    "Microsoft.GamingApp",                        # Xbox
    "Microsoft.XboxGamingOverlay",                # Xbox Game Bar
    "Microsoft.GetHelp",                          # Obter Ajuda
    "Microsoft.Windows.DevHome",                  # Pagina inicial de desenvolvimento
    "Microsoft.YourPhone",                        # Vincular ao Celular
    "Microsoft.Copilot",                          # Copilot
    "Microsoft.Windows.Ai.Copilot.Provider",      # Copilot (provider)
    "Microsoft.549981C3F5F10",                    # Cortana
    "MicrosoftCorporationII.MicrosoftFamily",     # Family Safety
    "Microsoft.Edge.GameAssist",                  # Game Assist (overlay do Edge p/ Xbox)
    "Microsoft.Getstarted",                       # Dicas/Introdução
    "microsoft.windowscommunicationsapps",        # Email e Calendário (legado)
    "Microsoft.WindowsMaps",                      # Mapas
    "Microsoft.MixedReality.Portal",              # Portal de Realidade Mista
    "Microsoft.MicrosoftOfficeHub",               # "Instalar Office" (tile promocional, não é o Office em si)
    "Microsoft.Office.OneNote",                   # OneNote
    "Microsoft.Microsoft3DViewer",                # Visualizador 3D
    "Microsoft.WindowsStore",                     # Microsoft Store
    "Microsoft.StorePurchaseApp",                 # Compras da Microsoft Store
    "Microsoft.People",                           # Pessoas
    "Microsoft.SkypeApp",                         # Skype
    "Microsoft.Wallet",                           # Carteira
    "Microsoft.ZuneVideo",                        # Filmes e TV
    "MicrosoftTeams",                             # Microsoft Teams (Legacy Name)

    # Xbox Apps Legacy Names:

    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay"
)

$CapabilitiesToRemove = @(
    "Language.Handwriting",                       # Reconhecimento de escrita
    "MathRecognizer",                             # Reconhecimento matematico
    "OneCoreUAP.OneSync",                         # Sincronizacao de Email/Calendario/Contatos
    "App.StepsRecorder",                          # Gravador de Etapas
    "App.Support.QuickAssist",                    # Assistencia Rapida (capability)
    "Language.Speech",                            # Reconhecimento de voz
    "Language.TextToSpeech",                      # Texto para voz
    "Hello.Face.18967",                           # Windows Hello (reconhecimento facial)
    "Hello.Face.Migration.18967",                 # Windows Hello (migracao)
    "Hello.Face.20134",                           # Windows Hello (reconhecimento facial)
    "Microsoft.Windows.MSPaint",                  # Paint (legado, capability)
    "Microsoft.Windows.WordPad"                   # WordPad
)

$FeaturesToRemove = @(
    "Microsoft-RemoteDesktopConnection"           # Conexao de Area de Trabalho Remota (mstsc)
)

$RegistryTweaks = @(
    @{ Path = "Software\Policies\Microsoft\Windows\WindowsCopilot";                                    Name = "TurnOffWindowsCopilot";       Type = "REG_DWORD"; Value = "1" }   # Desativa o Copilot
    @{ Path = "Software\Microsoft\Windows\CurrentVersion\GameDVR";                                     Name = "AppCaptureEnabled";            Type = "REG_DWORD"; Value = "0" }  # Desativa gravacao em segundo plano (Game DVR)
    @{ Path = "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";                           Name = "HideFileExt";                  Type = "REG_DWORD"; Value = "0" }  # Mostra as extensoes de arquivo
    @{ Path = "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";                           Name = "LaunchTo";                     Type = "REG_DWORD"; Value = "1" }  # Explorer abre em "Este Computador"
    @{ Path = "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";                           Name = "TaskbarAl";                    Type = "REG_DWORD"; Value = "0" }  # Alinha os icones da barra de tarefas a esquerda
    @{ Path = "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";                           Name = "ShowTaskViewButton";           Type = "REG_DWORD"; Value = "0" }  # Oculta o botao de Visao de Tarefas
    @{ Path = "Software\Microsoft\Windows\CurrentVersion\Search";                                      Name = "SearchboxTaskbarMode";         Type = "REG_DWORD"; Value = "0" }  # Oculta a caixa de busca na barra de tarefas
    @{ Path = "Software\Microsoft\Edge\SmartScreenEnabled";                                            Name = "";                             Type = "REG_DWORD"; Value = "0" }  # Desativa o SmartScreen (Edge)
    @{ Path = "Software\Microsoft\Edge\SmartScreenPuaEnabled";                                         Name = "";                             Type = "REG_DWORD"; Value = "0" }  # Desativa deteccao de PUA (Edge)
    @{ Path = "Software\Microsoft\Windows\CurrentVersion\AppHost";                                     Name = "EnableWebContentEvaluation";   Type = "REG_DWORD"; Value = "0" }  # Desativa avaliacao de conteudo (SmartScreen p/ apps)
    @{ Path = "Software\Microsoft\Windows\CurrentVersion\AppHost";                                     Name = "PreventOverride";              Type = "REG_DWORD"; Value = "0" }  # Permite contornar avisos do SmartScreen
    @{ Path = "Software\Policies\Microsoft\Windows\Explorer";                                          Name = "DisableSearchBoxSuggestions";  Type = "REG_DWORD"; Value = "1" }  # Desativa sugestoes na busca do Windows
    @{ Path = "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings";  Name = "TaskbarEndTask";               Type = "REG_DWORD"; Value = "1" }  # Habilita "Finalizar Tarefa" no menu da barra de tarefas
    @{ Path = "Control Panel\Accessibility\StickyKeys";                                                Name = "Flags";                        Type = "REG_SZ";    Value = "10" } # Desativa ativacao das Teclas de Aderencia
    @{ Path = "Control Panel\Keyboard";                                                                Name = "InitialKeyboardIndicators";    Type = "REG_SZ";    Value = "2" }  # Mantem o Num Lock ativo ao iniciar
)

$RegistryTweaksHKLM = @(
    @{ Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer";                                    Name = "SmartScreenEnabled";              Type = "REG_SZ";    Value = "Off" }  # Desativa o SmartScreen (Explorer/Sistema)
    @{ Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components";                             Name = "ServiceEnabled";                  Type = "REG_DWORD"; Value = "0" }    # Desativa o servico do SmartScreen
    @{ Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components";                             Name = "NotifyMalicious";                 Type = "REG_DWORD"; Value = "0" }    # Desativa notificacao de app malicioso
    @{ Path = "SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components";                             Name = "NotifyUnsafeApp";                 Type = "REG_DWORD"; Value = "0" }    # Desativa notificacao de app inseguro
    @{ Path = "SYSTEM\CurrentControlSet\Control\CI\Policy";                                            Name = "VerifiedAndReputablePolicyState"; Type = "REG_DWORD"; Value = "0" }    # Desativa o Smart App Control
    @{ Path = "System\CurrentControlSet\Control\DeviceGuard";                                          Name = "EnableVirtualizationBasedSecurity"; Type = "REG_DWORD"; Value = "0" }  # Desativa a Seguranca Baseada em Virtualizacao (VBS)
    @{ Path = "System\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"; Name = "Enabled";                        Type = "REG_DWORD"; Value = "0" }  # Desativa o HVCI (Memory Integrity)
    @{ Path = "SYSTEM\CurrentControlSet\Control\FileSystem";                                           Name = "LongPathsEnabled";                Type = "REG_DWORD"; Value = "1" }    # Habilita caminhos de arquivo longos
    @{ Path = "SYSTEM\CurrentControlSet\Control\Session Manager\Power";                                Name = "HiberbootEnabled";                Type = "REG_DWORD"; Value = "0" }    # Desativa a Inicializacao Rapida (Fast Startup)
    @{ Path = "SOFTWARE\Policies\Microsoft\Dsh";                                                       Name = "AllowNewsAndInterests";           Type = "REG_DWORD"; Value = "0" }    # Desativa os Widgets
    @{ Path = "Software\Policies\Microsoft\Windows\CloudContent";                                      Name = "DisableWindowsConsumerFeatures";  Type = "REG_DWORD"; Value = "1" }    # Desativa recursos de consumidor (sugestoes, promocoes)
    @{ Path = "SYSTEM\CurrentControlSet\Control\BitLocker";                                            Name = "PreventDeviceEncryption";         Type = "REG_DWORD"; Value = "1" }    # Impede a criptografia automatica de dispositivo
)

$ContentDeliveryManagerKeys = @(
    "ContentDeliveryAllowed",
    "FeatureManagementEnabled",
    "OEMPreInstalledAppsEnabled",
    "PreInstalledAppsEnabled",
    "PreInstalledAppsEverEnabled",
    "SilentInstalledAppsEnabled",
    "SoftLandingEnabled",
    "SubscribedContentEnabled",
    "SubscribedContent-310093Enabled",
    "SubscribedContent-338387Enabled",
    "SubscribedContent-338388Enabled",
    "SubscribedContent-338389Enabled",
    "SubscribedContent-338393Enabled",
    "SubscribedContent-353694Enabled",
    "SubscribedContent-353696Enabled",
    "SubscribedContent-353698Enabled",
    "SystemPaneSuggestionsEnabled"
)

$AppsParaRemocaoManual = @(
    "Aplicativo Start Experiences",
    "Microsoft Edge",
    "Xbox Live"
)

# 2. Funcao: remove pacote AppX (usuario atual + provisionado) -----------------------------#

function Remove-AppXCompletely {
        
		foreach ($App in $AppsToRemove) {
			
			$Path = (Get-AppxPackage -Name "*$App*").InstallLocation
			if ($Path) { Get-Process | Where-Object { $_.Path -like "$Path\*" } | Stop-Process -Force -ErrorAction SilentlyContinue }
			
			Get-AppxPackage -Name "*$App*" | Remove-AppxPackage

			Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like "*$App*" } | Remove-AppxProvisionedPackage -Online

		}
		
}

# 3. Funcao: remove Windows Capabilities ---------------------------------------------------#

function Remove-CapabilitiesCompletely {

		foreach ($Capability in $CapabilitiesToRemove) {

			Get-WindowsCapability -Online | Where-Object { $_.Name -like "$Capability*" } | Remove-WindowsCapability -Online

		}

}

# 4. Funcao: remove Windows Optional Features -----------------------------------------------#

function Remove-FeaturesCompletely {

		foreach ($Feature in $FeaturesToRemove) {

			Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -eq $Feature -and $_.State -ne "Disabled" } | Disable-WindowsOptionalFeature -Online -Remove -NoRestart

		}

}

# 5. Funcao: Ajustes no Registro -------------------------------------------------------------#

function Set-RegistryTweaks {

		foreach ($Tweak in $RegistryTweaks) {

			if ($Tweak.Name -eq "") {
				reg.exe add "HKCU\$($Tweak.Path)" /ve /t $Tweak.Type /d $Tweak.Value /f | Out-Null
			} else {
				reg.exe add "HKCU\$($Tweak.Path)" /v $Tweak.Name /t $Tweak.Type /d $Tweak.Value /f | Out-Null
			}

		}

		foreach ($Key in $ContentDeliveryManagerKeys) {

			reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v $Key /t REG_DWORD /d 0 /f | Out-Null

		}

        foreach ($Tweak in $RegistryTweaksHKLM) {

			reg.exe add "HKLM\$($Tweak.Path)" /v $Tweak.Name /t $Tweak.Type /d $Tweak.Value /f | Out-Null

		}

		fsutil.exe behavior set disableLastAccess 1 | Out-Null

}

# 6. Remocao do OneDrive -----------------------------------------------------------------------#

function Remove-OneDrive {
    
	Write-Host "`nRemovendo o OneDrive..." -ForegroundColor Cyan
	Start-Process "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" -ArgumentList "/uninstall" -Wait -ErrorAction SilentlyContinue
	
}

# 7. Execucao do script --------------------------------------------------------------------#

Remove-AppXCompletely
Remove-CapabilitiesCompletely
Remove-FeaturesCompletely
Set-RegistryTweaks
Remove-OneDrive

Write-Host "`nProcesso concluido." -ForegroundColor Cyan
Write-Host "`n=====================================================" -ForegroundColor Magenta
Write-Host "LEMBRETE: os apps abaixo nao podem ser removidos de" -ForegroundColor Magenta
Write-Host "forma confiavel via script neste ambiente. Remova-os" -ForegroundColor Magenta
Write-Host "manualmente em Configuracoes > Aplicativos > Aplicativos instalados" -ForegroundColor Magenta
$AppsParaRemocaoManual | ForEach-Object { Write-Host "  - $_" -ForegroundColor Magenta }
Write-Host "=====================================================" -ForegroundColor Magenta