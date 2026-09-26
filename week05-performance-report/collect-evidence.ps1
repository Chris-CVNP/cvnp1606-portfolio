# CVNP1606 Week 05 — Evidence Collection Script
# Run as Administrator. Saves output to evidence-report.txt.
# Commit evidence-report.txt to your GitHub portfolio repo under week05-performance-report/.

$lines = @()
$lines += "=== CVNP1606-W05 Evidence Report ==="
$lines += "Generated : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += "Host      : $env:COMPUTERNAME"
$lines += ""

# ── Top 10 CPU consumers (matches assignment command) ────────────────────────
$lines += "[TOP CPU PROCESSES]"
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 | ForEach-Object {
    $lines += "  $($_.ProcessName.PadRight(28)) CPU: $([math]::Round($_.CPU,1))s   WS: $([math]::Round($_.WorkingSet64/1MB,1)) MB"
}
$lines += ""

# ── Memory summary ────────────────────────────────────────────────────────────
$lines += "[MEMORY]"
$os = Get-CimInstance Win32_OperatingSystem
$totalGB  = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
$freeGB   = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
$usedGB   = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / 1MB, 1)
$lines += "  Total  : ${totalGB} GB"
$lines += "  Used   : ${usedGB} GB"
$lines += "  Free   : ${freeGB} GB"
$lines += ""

# ── Disk space ────────────────────────────────────────────────────────────────
$lines += "[DISK]"
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 } | ForEach-Object {
    $usedGB = [math]::Round($_.Used/1GB, 1)
    $freeGB = [math]::Round($_.Free/1GB, 1)
    $lines += "  $($_.Name): Used $usedGB GB | Free $freeGB GB"
}
$lines += ""

# ── Startup programs ──────────────────────────────────────────────────────────
$lines += "[STARTUP PROGRAMS (registry run key)]"
$runKeys = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
)
$runKeys | ForEach-Object {
    if (Test-Path $_) {
        $scope = if ($_ -match "HKLM") { "System" } else { "User" }
        Get-ItemProperty $_ | Get-Member -MemberType NoteProperty |
            Where-Object { $_.Name -notmatch "^PS" } | ForEach-Object {
                $lines += "  [$scope] $($_.Name)"
            }
    }
}
$lines += ""

# ── Required files ────────────────────────────────────────────────────────────
$lines += "[REQUIRED FILES]"
@("before-metrics.md", "after-metrics.md", "change-note.md", "README.md") | ForEach-Object {
    $p = Join-Path $PSScriptRoot $_
    if (Test-Path $p) { $lines += "  $_ : FOUND ($((Get-Item $p).Length) bytes)" }
    else              { $lines += "  $_ : NOT FOUND" }
}
$lines += ""
$lines += "Commit this file (evidence-report.txt) to your GitHub repo under week05-performance-report/."

$out = $lines -join "`n"
$out | Out-File -FilePath (Join-Path $PSScriptRoot "evidence-report.txt") -Encoding utf8
Write-Host $out
