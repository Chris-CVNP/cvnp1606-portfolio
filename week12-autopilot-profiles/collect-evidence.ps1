# CVNP1606 Week 12 — Evidence Collection Script
# Run as Administrator. Saves output to evidence-report.txt.
# Commit evidence-report.txt to your GitHub portfolio repo under week12-autopilot-profiles/.

$lines = @()
$lines += "=== CVNP1606-W12 Evidence Report ==="
$lines += "Generated : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += "Host      : $env:COMPUTERNAME"
$lines += ""

# ── Device join / Autopilot state ─────────────────────────────────────────────
$lines += "[DEVICE JOIN STATE (dsregcmd /status)]"
try {
    $dsreg = dsregcmd /status 2>&1
    $relevant = $dsreg | Where-Object {
        $_ -match "AzureAdJoined|EnterpriseJoined|DomainJoined|WorkplaceJoined|AutopilotEnrolled|TenantName|DeviceId|MDMUrl"
    }
    $relevant | ForEach-Object { $lines += "  $_" }
} catch { $lines += "  dsregcmd failed: $($_.Exception.Message)" }
$lines += ""

# ── Intune configuration profile status (registry) ───────────────────────────
$lines += "[CONFIGURATION PROFILES (registry)]"
$csePath = "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device"
if (Test-Path $csePath) {
    $policies = Get-ChildItem $csePath -ErrorAction SilentlyContinue | Select-Object -First 10
    $lines += "  MDM policy keys found: $($policies.Count) (sample below)"
    $policies | ForEach-Object { $lines += "  $($_.PSChildName)" }
} else {
    $lines += "  MDM policy path not found — device may not be enrolled."
}
$lines += ""

# ── Required files ────────────────────────────────────────────────────────────
$lines += "[REQUIRED FILES]"
@("deployment-decision-tree.md", "profile-evidence.md", "repeatable-deployment-note.md", "README.md") | ForEach-Object {
    $p = Join-Path $PSScriptRoot $_
    if (Test-Path $p) { $lines += "  $_ : FOUND ($((Get-Item $p).Length) bytes)" }
    else              { $lines += "  $_ : NOT FOUND" }
}
$lines += ""
$lines += "Commit this file (evidence-report.txt) to your GitHub repo under week12-autopilot-profiles/."

$out = $lines -join "`n"
$out | Out-File -FilePath (Join-Path $PSScriptRoot "evidence-report.txt") -Encoding utf8
Write-Host $out
