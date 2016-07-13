$TargetDir = "$PSScriptRoot\texlive"
Remove-Item -Path $TargetDir -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Recurse -Force

$Date = ((Get-Date).ToUniversalTime()).ToString("ddd MMM  d HH:mm:ss yyyy UTC")
$PosixTargetDir = $TargetDir -replace "\\","/"

$ProfilePath = "$PSScriptRoot\texlive.profile"
@"
# texlive.profile generated on $Date
selected_scheme scheme-custom
TEXDIR $PosixTargetDir
TEXMFCONFIG `$TEXMFSYSCONFIG
TEXMFHOME `$TEXMFLOCAL
TEXMFLOCAL $PosixTargetDir/texmf-local
TEXMFSYSCONFIG $PosixTargetDir/texmf-config
TEXMFSYSVAR $PosixTargetDir/texmf-var
TEXMFVAR `$TEXMFSYSVAR
binary_win32 1
collection-basic 1
collection-binextra 1
collection-latex 1
in_place 0
option_adjustrepo 1
option_autobackup 0
option_desktop_integration 0
option_doc 0
option_file_assocs 0
option_fmt 1
option_letter 0
option_menu_integration  0
option_path 0
option_post_code 1
option_src 0
option_sys_bin /usr/local/bin
option_sys_info /usr/local/share/info
option_sys_man /usr/local/share/man
option_w32_multi_user 0
option_write18_restricted 1
portable 1
"@ | Out-File $ProfilePath -Encoding utf8

$PosixProfilePath = $ProfilePath -replace "\\","/"
$InstallScriptPath = (Get-ChildItem .\install-tl-*\install-tl-windows.bat).FullName
Invoke-Expression "$InstallScriptPath -profile $PosixProfilePath"

# Install individual packages...
Set-Item env:Path "$TargetDir\bin\win32;$env:Path"
Invoke-Expression "tlmgr install framed"

Remove-Item -Path "$TargetDir\texmf-dist\doc" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Recurse -Force
Remove-Item -Path "$TargetDir\texmf-dist\source" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Recurse -Force

$TarballPath = "$PSScriptRoot\texlive.tar"
$PackagePath = "$TarballPath.xz"
Remove-Item -Path $PackagePath -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Force
Invoke-Expression "7z a -ttar $TarballPath $TargetDir"
Invoke-Expression "7z a -txz -mx9 $PackagePath $TarballPath"
Remove-Item -Path $TarballPath
