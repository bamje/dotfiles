$ENV:STARSHIP_CONFIG = "$HOME\.starship\starship.toml"
Invoke-Expression (&starship init powershell)

# set default editor
$env:EDITOR = 'code --wait'
# Import-Module VMware.PowerCLI

# Import-Module Veeam.Backup.PowerShell -UseWindowsPowerShell #compatibility mode, works only on 5.1

import-Module Terminal-Icons
