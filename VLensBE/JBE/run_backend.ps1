# Khởi động Backend Java Spring Boot với đầy đủ biến môi trường
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "   VIETLENS - JAVA SPRING BOOT BACKEND (Port 8080)" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan

$envFile = Join-Path $PSScriptRoot "..\.env"
if (Test-Path $envFile) {
    Write-Host "Đang nạp biến môi trường từ: $envFile" -ForegroundColor Yellow
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^\s*([^#=]+)\s*=\s*(.*)$') {
            [System.Environment]::SetEnvironmentVariable($matches[1].Trim(), $matches[2].Trim())
        }
    }
}

Set-Location $PSScriptRoot
Write-Host "Đang khởi động Spring Boot trên cổng 8080..." -ForegroundColor Green
.\mvnw.cmd spring-boot:run
