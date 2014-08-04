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
collection-latexrecommended 1
collection-wintools 1
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
option_src 1
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

# TODO:
# - [x] Run install-tl-windows.bat with the generated profile.
# - [ ] `rm -r $TARGET_DIR/texmf-dist/doc`
# - [ ] Compress portable install using 7za.exe
