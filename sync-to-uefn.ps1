# sync-to-uefn.ps1
# Sincronitza els scripts Verse del repo al projecte UEFN
# Executa'l des de PowerShell quan vulguis pujar canvis al UEFN
# O deixa'l en mode --watch per sincronització automàtica

$RepoVerse = "C:\Users\arnau\Desktop\fortnite-maps\ascent\verse"
$UEFNProject = "C:\Users\arnau\Documents\Fortnite Projects\ASCENT"
$Files = @(
    "GameManager.verse",
    "WaterController.verse",
    "CheckpointTracker.verse",
    "TimerDisplay.verse",
    "LeaderboardManager.verse"
)

function Sync-Files {
    $changed = 0
    foreach ($file in $Files) {
        $src = Join-Path $RepoVerse $file
        $dst = Join-Path $UEFNProject $file
        if (Test-Path $src) {
            $srcTime = (Get-Item $src).LastWriteTime
            $dstExists = Test-Path $dst
            $dstTime = if ($dstExists) { (Get-Item $dst).LastWriteTime } else { [DateTime]::MinValue }
            if (-not $dstExists -or $srcTime -gt $dstTime) {
                Copy-Item $src $dst -Force
                Write-Host "[SYNC] $file -> UEFN" -ForegroundColor Green
                $changed++
            }
        }
    }
    if ($changed -eq 0) {
        Write-Host "[OK] Tot sincronitzat, cap canvi detectat." -ForegroundColor Cyan
    } else {
        Write-Host "[OK] $changed fitxer(s) sincronitzat(s)." -ForegroundColor Green
    }
}

# Mode watch: sincronitza automàticament cada 2 segons
if ($args[0] -eq "--watch") {
    Write-Host "Mode WATCH actiu — sincronitzant cada 2s. Ctrl+C per aturar." -ForegroundColor Yellow
    Write-Host "Repo: $RepoVerse" -ForegroundColor Gray
    Write-Host "UEFN: $UEFNProject" -ForegroundColor Gray
    while ($true) {
        Sync-Files
        Start-Sleep -Seconds 2
    }
} else {
    # Sincronització única
    Write-Host "Sincronitzant repo -> UEFN..." -ForegroundColor Yellow
    Sync-Files
}
