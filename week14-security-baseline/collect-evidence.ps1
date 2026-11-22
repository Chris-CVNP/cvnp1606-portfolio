# CVNP1606 Week 14 — Evidence Collection Script
# Run as Administrator. Saves output to evidence-report.txt.
# Commit evidence-report.txt to your GitHub portfolio repo under week14-security-baseline/.

$lines = @()
$lines += "=== CVNP1606-W14 Evidence Report ==="
$lines += "Generated : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += "Host      : $env:COMPUTERNAME"
$lines += ""

# ── Defender posture ──────────────────────────────────────────────────────────
$lines += "[DEFENDER STATUS]"
try {
    $mp = Get-MpComputerStatus -ErrorAction SilentlyContinue
    if ($mp) {
        $lines += "  AntivirusEnabled          : $($mp.AntivirusEnabled)"
        $lines += "  RealTimeProtectionEnabled : $($mp.RealTimeProtectionEnabled)"
        $lines += "  AMRunningMode             : $($mp.AMRunningMode)"
        $lines += "  AntivirusSignatureAge     : $($mp.AntivirusSignatureAge) day(s)"
        $lines += "  NISSignatureAge           : $($mp.NISSignatureAge) day(s)"
        $lines += "  QuickScanAge              : $($mp.QuickScanAge) day(s)"
    }
} catch { $lines += "  Defender query failed: $($_.Exception.Message)" }
$lines += ""

# ── Firewall profiles ─────────────────────────────────────────────────────────
$lines += "[FIREWALL PROFILES]"
try {
    Get-NetFirewallProfile | ForEach-Object {
        $lines += "  $($_.Name.PadRight(12)) Enabled: $($_.Enabled)  DefaultInbound: $($_.DefaultInboundAction)"
    }
} catch { $lines += "  Firewall query failed: $($_.Exception.Message)" }
$lines += ""

# ── BitLocker status ──────────────────────────────────────────────────────────
$lines += "[BITLOCKER]"
try {
    Get-BitLockerVolume -ErrorAction SilentlyContinue | ForEach-Object {
        $lines += "  $($_.MountPoint) : Protection=$($_.ProtectionStatus)  Encryption=$($_.EncryptionPercentage)%  Method=$($_.EncryptionMethod)"
    }
} catch { $lines += "  BitLocker query failed: $($_.Exception.Message)" }
$lines += ""

# ── Required files ────────────────────────────────────────────────────────────
$lines += "[REQUIRED FILES]"
@("defender-status.txt", "firewall-status.txt", "baseline-variance-note.md", "bitlocker-sop.md", "redaction-checklist.md", "README.md") | ForEach-Object {
    $p = Join-Path $PSScriptRoot $_
    if (Test-Path $p) { $lines += "  $_ : FOUND ($((Get-Item $p).Length) bytes)" }
    else              { $lines += "  $_ : NOT FOUND" }
}
$lines += ""
$lines += "Commit this file (evidence-report.txt) to your GitHub repo under week14-security-baseline/."

$out = $lines -join "`n"
$out | Out-File -FilePath (Join-Path $PSScriptRoot "evidence-report.txt") -Encoding utf8
Write-Host $out
