# Install git before proceeding with work
winget install Git.Git

# Clone a repository from GitHub to ~/.dots
git clone https://github.com/katsuki-yuri/dots.git $Env:APPDATA\.dots

# Install all required applications using winget
$Apps = @(
    "Rustlang.Rustup",
    "Volta.Volta",
    "Starship.Starship",
    "Microsoft.VisualStudioCode",
    "Microsoft.VisualStudio.2022.BuildTools"
)

ForEach ($App in $Apps) {
    winget install $App
}

# Install cargo apps
$CargoApps = @(
    "lsd",
    "just",
    "topgrade"
)

ForEach ($App in $CargoApps) {
    cargo install $App
}

# Create a function that checks if file or folder on param exists, if exists delete it
Function Remove-FileIfExists($Path) {
    If (Test-Path -Path $Path) {
        Remove-Item -Path $Path -Force -Recurse
    }
}

# Check if the folder AppData\Roaming\lsd and config.yaml exists, if not create it and create symlink to the config.yaml file at APPDATA\.config\lsd\config.yaml:
If (!(Test-Path -Path $Env:APPDATA\lsd)) {
    Remove-FileIfExists($Env:APPDATA\lsd)
    New-Item -ItemType SymbolicLink -Path $Env:APPDATA\lsd -Target $Env:APPDATA\.dots\.config\lsd
}

# Check if topgrade.toml exists at AppData\Roaming, if not copy the file at ./config/windows.topgrade.toml as topgrade.toml:
If (!(Test-Path -Path $Env:APPDATA\topgrade.toml)) {
    Remove-FileIfExists($Env:APPDATA\topgrade.toml)
    New-Item -ItemType SymbolicLink -Path $Env:APPDATA\topgrade.toml -Target $Env:APPDATA\.dots\.config\windows.topgrade.toml
}

# Move ./shells/Microsoft.PowerShell_profile.ps1 to $PROFILE
Remove-FileIfExists($PROFILE)
New-Item -ItemType SymbolicLink -Path $PROFILE -Target $Env:APPDATA\.dots\shells\Microsoft.PowerShell_profile.ps1

# Override ./terms/Windows Terminal/settings.json with the one at AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
Remove-FileIfExists($Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json)
New-Item -ItemType SymbolicLink -Path $Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Target $Env:APPDATA\.dots\terms\Windows Terminal\settings.json

# Done
Write-Output "The installation has been successfully completed!"