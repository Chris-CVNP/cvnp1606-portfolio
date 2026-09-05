# CVNP1606 Week 02 — Evidence Collection Script
# Run as Administrator. Saves output to evidence-report.txt.
# Commit evidence-report.txt to your GitHub portfolio repo under week02-user-faq/.

$lines = @()
$lines += "=== CVNP1606-W02 Evidence Report ==="
$lines += "Generated : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += "Host      : $env:COMPUTERNAME"
$lines += ""

# ── Windows edition (confirms student is on correct OS) ──────────────────────
$lines += "[SYSTEM]"
try {
    $info = Get-ComputerInfo | Select-Object CsName, WindowsProductName, OsVersion
    $lines += "  Hostname : $($info.CsName)"
    $lines += "  OS       : $($info.WindowsProductName)"
    $lines += "  Version  : $($info.OsVersion)"
} catch { $lines += "  ERROR: $($_.Exception.Message)" }
$lines += ""

# ── Display and accessibility settings ───────────────────────────────────────
$lines += "[DISPLAY SCALE]"
try {
    $scale = Get-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "AppliedDPI" -ErrorAction SilentlyContinue
    if ($scale) { $lines += "  AppliedDPI : $($scale.AppliedDPI) (100% = 96 dpi)" }
    else        { $lines += "  AppliedDPI : not set (default)" }
} catch { $lines += "  Could not read display scale." }
$lines += ""

# ── Required portfolio files ──────────────────────────────────────────────────
$lines += "[REQUIRED FILES]"
@("README.md", "support-note-examples.md") | ForEach-Object {
    $p = Join-Path $PSScriptRoot $_
    if (Test-Path $p) { $lines += "  $_ : FOUND ($((Get-Item $p).Length) bytes)" }
    else              { $lines += "  $_ : NOT FOUND" }
}
$lines += ""
$lines += "Commit this file (evidence-report.txt) to your GitHub repo under week02-user-faq/."

$out = $lines -join "`n"
$out | Out-File -FilePath (Join-Path $PSScriptRoot "evidence-report.txt") -Encoding utf8
Write-Host $out
