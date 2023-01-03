# Przed uruchomieniem skryptu, uruchom polecenie:
# Set-ExecutionPolicy Bypass Process -Force

# Chocolatey ----
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
refreshenv

# Drukarka Brother DCP-J315W ----
$PulpitDir = [Environment]::GetFolderPath("Desktop")
wget "https://download.brother.com/welcome/dlf004452/dcp-j315w-inst-B1-cd5.EXE" -outfile $PulpitDir\dcp-j315w.exe
& $PulpitDir\dcp-j315w.exe

# Minimum programów ----
choco install googlechrome --ignore-checksums -y
choco install grep sed awk gsudo oh-my-posh jre8 adobereader 7zip irfanview irfanviewplugins k-litecodecpackbasic driverbooster kate steam-client python r r.studio jamovi kdeconnect-kde git gh freshbing zoom microsoft-teams discord spotify gimp calibre qbittorrent vlc zotero anki -y
choco install office2019proplus --params '/Language:pl-pl' -y
choco install avastfreeantivirus --ignore-checksums -y
refreshenv

# Restart ----
Write-Output "Pamietaj o instalacji sterownika drukarki!"
$Decyzja = Read-Host "Zrestartowac komputer? (t/n)"
if ($Decyzja -match '^[TtYy]$' ) {
    Restart-Computer
}
