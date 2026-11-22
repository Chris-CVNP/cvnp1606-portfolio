# CVNP1606 Week 16 — Evidence Collection Script (Capstone)
# Run as Administrator. Saves output to evidence-report.txt.
# NOTE: Week 16 requires you to write health-report.ps1 as part of the assignment.
#       This script verifies that file exists and runs it to capture its output here.
# Commit evidence-report.txt to your GitHub repo under week16-audit-package/.

$lines = @()
$lines += "=== CVNP1606-W16 Evidence Report (Capstone) ==="
$lines += "Generated : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += "Host      : $env:COMPUTERNAME"
$lines += ""

# ── Verify health-report.ps1 exists and run it ───────────────────────────────
$lines += "[HEALTH-REPORT.PS1]"
$hrPath = Join-Path $PSScriptRoot "health-report.ps1"
if (Test-Path $hrPath) {
    $lines += "  health-report.ps1 : FOUND"
    $lines += "  Running health-report.ps1 output below:"
    $lines += "  " + ("-" * 60)
    try {
        $hrOutput = & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $hrPath 2>&1
        $hrOutput | ForEach-Object { $lines += "  $_" }
    } catch {
        $lines += "  ERROR running health-report.ps1: $($_.Exception.Message)"
    }
    $lines += "  " + ("-" * 60)
} else {
    $lines += "  health-report.ps1 : NOT FOUND — create this file as required by the assignment"
}
$lines += ""

# ── Verify health-report-output.txt ──────────────────────────────────────────
$lines += "[HEALTH-REPORT-OUTPUT.TXT]"
$outPath = Join-Path $PSScriptRoot "health-report-output.txt"
if (Test-Path $outPath) {
    $lines += "  health-report-output.txt : FOUND ($((Get-Item $outPath).Length) bytes)"
} else {
    $lines += "  health-report-output.txt : NOT FOUND — run: .\health-report.ps1 | Out-File health-report-output.txt"
}
$lines += ""

# ── Ticket evidence folder check ─────────────────────────────────────────────
$lines += "[TICKET-EVIDENCE FOLDER]"
$tePath = Join-Path $PSScriptRoot "ticket-evidence"
if (Test-Path $tePath) {
    $artifacts = Get-ChildItem $tePath -ErrorAction SilentlyContinue
    $lines += "  ticket-evidence/ : FOUND ($($artifacts.Count) file(s))"
    $artifacts | ForEach-Object { $lines += "    $($_.Name)" }
} else {
    $lines += "  ticket-evidence/ : NOT FOUND"
}
$lines += ""

# ── Required files ────────────────────────────────────────────────────────────
$lines += "[REQUIRED FILES]"
@("health-report.ps1", "health-report-output.txt", "ai-validation.md", "portfolio-defense-notes.md", "README.md") | ForEach-Object {
    $p = Join-Path $PSScriptRoot $_
    if (Test-Path $p) { $lines += "  $_ : FOUND ($((Get-Item $p).Length) bytes)" }
    else              { $lines += "  $_ : NOT FOUND" }
}
$lines += ""
$lines += "Commit this file (evidence-report.txt) to your GitHub repo under week16-audit-package/."

$out = $lines -join "`n"
$out | Out-File -FilePath (Join-Path $PSScriptRoot "evidence-report.txt") -Encoding utf8
Write-Host $out

