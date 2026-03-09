# ── PowerShell profile ────────────────────────────────────────────────────────
# Managed by chezmoi
# Deployed to: ~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1 (Windows)
# Note: On macOS/Linux this file is excluded via .chezmoiignore

# ── Starship prompt ───────────────────────────────────────────────────────────
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

# ── zoxide (smart cd) ─────────────────────────────────────────────────────────
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# ── Aliases ───────────────────────────────────────────────────────────────────
Set-Alias -Name vim  -Value nvim
Set-Alias -Name vi   -Value nvim
Set-Alias -Name v    -Value nvim
Set-Alias -Name lg   -Value lazygit
Set-Alias -Name g    -Value git
Set-Alias -Name cls  -Value Clear-Host

function ll  { eza --icons --group-directories-first -la --git @args }
function ls  { eza --icons --group-directories-first @args }
function lt  { eza --icons --tree --level=2 @args }
function cat { bat --paging=never @args }

# chezmoi
function cz   { chezmoi @args }
function czd  { chezmoi diff }
function cza  { chezmoi apply }
function cze  { chezmoi edit --apply @args }
function czu  { chezmoi update }

# Git
function gs   { git status -sb }
function glog { git log --oneline --graph --decorate --all }

# ── WSL2: open current Windows dir in WSL ────────────────────────────────────
function wsl-here {
    wsl --cd (Get-Location).Path
}

Write-Host "PowerShell ready " -ForegroundColor Cyan -NoNewline
Write-Host "(chezmoi managed)" -ForegroundColor DarkGray
