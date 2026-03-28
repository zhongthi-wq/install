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

# ── BUOC 2: Cai dat ──
Write-Host "[2/2] Dang cai dat..." -ForegroundColor Yellow
$log = "$env:TEMP\crd_install.log"
$p = Start-Process msiexec -ArgumentList "/i `"$CRDInstaller`" /quiet /norestart /l*v `"$log`"" -Wait -PassThru -Verb RunAs

if ($p.ExitCode -eq 0) {
    Write-Host "     Cai dat thanh cong!" -ForegroundColor Green

    Start-Sleep -Seconds 3
    $svc = Get-Service -Name "chromoting" -ErrorAction SilentlyContinue
    if ($svc) {
        Write-Host "     Service chromoting: $($svc.Status)" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "Mo trinh duyet de dang ky may..." -ForegroundColor Cyan
    Start-Process "https://remotedesktop.google.com/access"

    Write-Host ""
    Write-Host "  1. Dang nhap Google Account" -ForegroundColor White
    Write-Host "  2. Click 'Bat' hoac 'Set up'" -ForegroundColor White
    Write-Host "  3. Copy lenh trong o mau xam" -ForegroundColor White
    Write-Host "  4. Dan vao day roi nhan Enter" -ForegroundColor White
    Write-Host ""

    $AuthCommand = Read-Host "Dan lenh vao day >"
    if ($AuthCommand -ne "") {
        Invoke-Expression $AuthCommand
        Write-Host "HOAN TAT! Kiem tra: https://remotedesktop.google.com/access" -ForegroundColor Green
    }
} else {
    Write-Host "     Loi! Exit code: $($p.ExitCode)" -ForegroundColor Red
    Write-Host "     Xem log: $log" -ForegroundColor Yellow
    Select-String "Error|Fail|1603" $log | Select-Object -Last 10
}

Remove-Item $CRDInstaller -Force -ErrorAction SilentlyContinue
pause
