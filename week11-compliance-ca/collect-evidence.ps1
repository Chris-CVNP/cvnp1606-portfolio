# CVNP1606 Week 11 — Evidence Collection Script
# Run as Administrator. Saves output to evidence-report.txt.
# Commit evidence-report.txt to your GitHub portfolio repo under week11-compliance-ca/.

$lines = @()
$lines += "=== CVNP1606-W11 Evidence Report ==="
$lines += "Generated : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += "Host      : $env:COMPUTERNAME"
$lines += ""

# ── BitLocker status (Compliance policy: Require BitLocker) ──────────────────
$lines += "[BITLOCKER STATUS]"
try {
    $bl = Get-BitLockerVolume -ErrorAction SilentlyContinue
    if ($bl) {
        $bl | ForEach-Object {
            $lines += "  Drive: $($_.MountPoint)  Protection: $($_.ProtectionStatus)  EncryptionPct: $($_.EncryptionPercentage)%"
        }
    } else {
        $lines += "  BitLocker: Not configured or not available."
    }
} catch { $lines += "  BitLocker query failed: $($_.Exception.Message)" }
$lines += ""

# ── Defender status (Compliance policy: Require Defender) ───────────────────
$lines += "[DEFENDER STATUS]"
try {
    $mp = Get-MpComputerStatus -ErrorAction SilentlyContinue
    if ($mp) {
        $lines += "  AntivirusEnabled       : $($mp.AntivirusEnabled)"
        $lines += "  RealTimeProtection     : $($mp.RealTimeProtectionEnabled)"
        $lines += "  AntivirusSignatureAge  : $($mp.AntivirusSignatureAge) day(s)"
    } else {
        $lines += "  Defender status unavailable."
    }
} catch { $lines += "  Defender query failed: $($_.Exception.Message)" }
$lines += ""

# ── Windows Hello (credential provider check) ────────────────────────────────
$lines += "[WINDOWS HELLO]"
$helloPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device"
if (Test-Path $helloPath) {
    $hello = Get-ItemProperty $helloPath -ErrorAction SilentlyContinue
    $lines += "  DevicePasswordLessBuildVersion: $($hello.DevicePasswordLessBuildVersion)"
} else {
    $lines += "  Hello registry key not found."
}
$lines += ""

# ── Device join state ─────────────────────────────────────────────────────────
$lines += "[DEVICE JOIN STATE]"
$dsreg = dsregcmd /status 2>&1 | Where-Object { $_ -match "AzureAdJoined|EnterpriseJoined|DomainJoined|WorkplaceJoined" }
$dsreg | ForEach-Object { $lines += "  $_" }
$lines += ""

# ── Required files ────────────────────────────────────────────────────────────
$lines += "[REQUIRED FILES]"
@("compliance-policy-summary.md", "conditional-access-memo.md", "laps-hello-note.md", "README.md") | ForEach-Object {
    $p = Join-Path $PSScriptRoot $_
    if (Test-Path $p) { $lines += "  $_ : FOUND ($((Get-Item $p).Length) bytes)" }
    else              { $lines += "  $_ : NOT FOUND" }
}
$lines += ""
$lines += "Commit this file (evidence-report.txt) to your GitHub repo under week11-compliance-ca/."

$out = $lines -join "`n"
$out | Out-File -FilePath (Join-Path $PSScriptRoot "evidence-report.txt") -Encoding utf8
Write-Host $out
