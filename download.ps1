$TickMark = [Char]0x2713

function Expand-ZipFile($FilePath, $DestinationPath) {
  New-Item -ItemType Directory -Path $DestinationPath -WarningAction SilentlyContinue -Force | Out-Null

  $Shell = New-Object -ComObject Shell.Application
  $ZipFile = $Shell.Namespace($FilePath)

  # vOption flags: http://msdn.microsoft.com/en-us/library/windows/desktop/bb787866(v=vs.85).aspx
  $Shell.Namespace($DestinationPath).CopyHere($ZipFile.Items(), 0x14) | Out-Null
}

$DownloadUrl = "http://mirror.ctan.org/systems/texlive/tlnet/install-tl.zip"
$FilePath = "$PSScriptRoot\install-tl.zip"
$DestinationPath = "$PSScriptRoot"

Write-Host "Downloading $DownloadUrl... " -NoNewline
(New-Object Net.WebClient).DownloadFile($DownloadUrl, $FilePath)
Write-Host $TickMark

Write-Host "Extracting $FilePath... " -NoNewline
Expand-ZipFile -FilePath $FilePath -DestinationPath $DestinationPath
Write-Host $TickMark
