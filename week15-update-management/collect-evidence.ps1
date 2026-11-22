# CVNP1606 Week 15 — Evidence Collection Script
# Run as Administrator. Saves output to evidence-report.txt.
# Commit evidence-report.txt to your GitHub portfolio repo under week15-update-management/.

$lines = @()
$lines += "=== CVNP1606-W15 Evidence Report ==="
$lines += "Generated : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += "Host      : $env:COMPUTERNAME"
$lines += ""

# ── Windows Update policy settings (registry) ─────────────────────────────────
$lines += "[WINDOWS UPDATE POLICY (registry)]"
$wuPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
if (Test-Path $wuPath) {
    Get-ItemProperty $wuPath -ErrorAction SilentlyContinue | Get-Member -MemberType NoteProperty |
        Where-Object { $_.Name -notmatch "^PS" } | ForEach-Object {
            $val = (Get-ItemProperty $wuPath).$($_.Name)
            $lines += "  $($_.Name.PadRight(40)) : $val"
        }
} else {
    $lines += "  No Windows Update GPO policy registry path found."
}
$lines += ""

# ── Last Windows Update activity ──────────────────────────────────────────────
$lines += "[RECENT WINDOWS UPDATES (last 30 days)]"
try {
    $wu = Get-HotFix -ErrorAction SilentlyContinue |
        Where-Object { $_.InstalledOn -gt (Get-Date).AddDays(-30) } |
        Sort-Object InstalledOn -Descending | Select-Object -First 10
    if ($wu) {
        $wu | ForEach-Object {
            $lines += "  $($_.HotFixID.PadRight(16)) $($_.InstalledOn.ToString('yyyy-MM-dd'))  $($_.Description)"
        }
    } else {
        $lines += "  No hotfixes installed in last 30 days."
    }
} catch { $lines += "  Get-HotFix failed: $($_.Exception.Message)" }
$lines += ""

# ── Windows Update service state ─────────────────────────────────────────────
$lines += "[WINDOWS UPDATE SERVICE]"
$svc = Get-Service -Name wuauserv -ErrorAction SilentlyContinue
if ($svc) {
    $lines += "  wuauserv Status  : $($svc.Status)"
    $lines += "  wuauserv StartType: $($svc.StartType)"
}
$lines += ""

# ── Required files ────────────────────────────────────────────────────────────
$lines += "[REQUIRED FILES]"
@("patch-strategy-memo.md", "remote-actions-checklist.md", "rollout-health-summary.md", "README.md") | ForEach-Object {
    $p = Join-Path $PSScriptRoot $_
    if (Test-Path $p) { $lines += "  $_ : FOUND ($((Get-Item $p).Length) bytes)" }
    else              { $lines += "  $_ : NOT FOUND" }
}
$lines += ""
$lines += "Commit this file (evidence-report.txt) to your GitHub repo under week15-update-management/."

$out = $lines -join "`n"
$out | Out-File -FilePath (Join-Path $PSScriptRoot "evidence-report.txt") -Encoding utf8
Write-Host $out
