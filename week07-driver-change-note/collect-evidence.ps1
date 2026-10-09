# CVNP1606 Week 07 — Evidence Collection Script
# Run as Administrator. Saves output to evidence-report.txt.
# Commit evidence-report.txt to your GitHub portfolio repo under week07-driver-change-note/.

$lines = @()
$lines += "=== CVNP1606-W07 Evidence Report ==="
$lines += "Generated : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += "Host      : $env:COMPUTERNAME"
$lines += ""

# ── Device Manager — non-OK devices ──────────────────────────────────────────
$lines += "[PNP DEVICES — NON-OK STATUS]"
$nonOK = Get-PnpDevice | Where-Object { $_.Status -ne "OK" }
if ($nonOK) {
    $nonOK | ForEach-Object {
        $lines += "  Status: $($_.Status.PadRight(12)) Class: $($_.Class.PadRight(20)) Name: $($_.FriendlyName)"
    }
} else {
    $lines += "  All devices status: OK (remediation may have succeeded)"
}
$lines += ""

# ── All devices summary ───────────────────────────────────────────────────────
$lines += "[PNP DEVICES — ALL (summary by status)]"
Get-PnpDevice | Group-Object Status | ForEach-Object {
    $lines += "  $($_.Name.PadRight(16)) : $($_.Count) device(s)"
}
$lines += ""

# ── Signed drivers (recently installed) ───────────────────────────────────────
$lines += "[RECENTLY MODIFIED DRIVERS (last 30 days)]"
try {
    $recent = Get-CimInstance Win32_PnPSignedDriver |
        Where-Object { $_.DriverDate -gt (Get-Date).AddDays(-30) } |
        Select-Object -First 10
    if ($recent) {
        $recent | ForEach-Object {
            $lines += "  $($_.DeviceName) | Version: $($_.DriverVersion) | Date: $($_.DriverDate)"
        }
    } else {
        $lines += "  No drivers modified in last 30 days."
    }
} catch { $lines += "  Could not query driver dates: $($_.Exception.Message)" }
$lines += ""

# ── Required files ────────────────────────────────────────────────────────────
$lines += "[REQUIRED FILES]"
@("hardware-inventory.txt", "change-note.md", "rollback-plan.md", "README.md") | ForEach-Object {
    $p = Join-Path $PSScriptRoot $_
    if (Test-Path $p) { $lines += "  $_ : FOUND ($((Get-Item $p).Length) bytes)" }
    else              { $lines += "  $_ : NOT FOUND" }
}
$lines += ""
$lines += "Commit this file (evidence-report.txt) to your GitHub repo under week07-driver-change-note/."

$out = $lines -join "`n"
$out | Out-File -FilePath (Join-Path $PSScriptRoot "evidence-report.txt") -Encoding utf8
Write-Host $out

