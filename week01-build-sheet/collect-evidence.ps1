# CVNP1606 Week 01 — Evidence Collection Script
# Run as Administrator. Saves output to evidence-report.txt in the same folder.
# Commit evidence-report.txt to your GitHub portfolio repo under week01-build-sheet/.

$lines = @()
$lines += "=== CVNP1606-W01 Evidence Report ==="
$lines += "Generated : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += "Host      : $env:COMPUTERNAME"
$lines += ""

# ── System baseline ───────────────────────────────────────────────────────────
$lines += "[SYSTEM]"
try {
    $info = Get-ComputerInfo | Select-Object CsName, WindowsProductName, OsVersion, BiosFirmwareType
    $lines += "  Hostname   : $($info.CsName)"
    $lines += "  OS         : $($info.WindowsProductName)"
    $lines += "  Version    : $($info.OsVersion)"
    $lines += "  Firmware   : $($info.BiosFirmwareType)"
} catch { $lines += "  ERROR: $($_.Exception.Message)" }
$lines += ""

# ── Local accounts ────────────────────────────────────────────────────────────
$lines += "[LOCAL ACCOUNTS]"
Get-LocalUser | ForEach-Object {
    $lines += "  $($_.Name.PadRight(24)) Enabled: $($_.Enabled)"
}
$lines += ""

# ── Administrators group ──────────────────────────────────────────────────────
$lines += "[ADMINISTRATORS GROUP]"
Get-LocalGroupMember -Group "Administrators" | ForEach-Object {
    $lines += "  $($_.Name) ($($_.PrincipalSource))"
}
$lines += ""

# ── TPM state ─────────────────────────────────────────────────────────────────
$lines += "[TPM]"
try {
    $tpm = Get-CimInstance -Namespace root/cimv2/security/microsofttpm -ClassName Win32_Tpm -ErrorAction Stop
    $lines += "  TpmPresent   : $($tpm.IsActivated_InitialValue)"
    $lines += "  TpmEnabled   : $($tpm.IsEnabled_InitialValue)"
} catch { $lines += "  TPM query failed (may need admin or TPM not present): $($_.Exception.Message)" }
$lines += ""

# ── Required files ────────────────────────────────────────────────────────────
$lines += "[REQUIRED FILES]"
@("inventory.txt") | ForEach-Object {
    $p = Join-Path $PSScriptRoot $_
    if (Test-Path $p) { $lines += "  $_ : FOUND ($((Get-Item $p).Length) bytes)" }
    else              { $lines += "  $_ : NOT FOUND" }
}
$lines += ""
$lines += "Commit this file (evidence-report.txt) to your GitHub repo under week01-build-sheet/."

$out = $lines -join "`n"
$out | Out-File -FilePath (Join-Path $PSScriptRoot "evidence-report.txt") -Encoding utf8
Write-Host $out