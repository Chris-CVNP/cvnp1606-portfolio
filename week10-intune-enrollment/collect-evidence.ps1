# CVNP1606 Week 10 — Evidence Collection Script
# Run as Administrator. Saves output to evidence-report.txt.
# Commit evidence-report.txt to your GitHub portfolio repo under week10-intune-enrollment/.

$lines = @()
$lines += "=== CVNP1606-W10 Evidence Report ==="
$lines += "Generated : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += "Host      : $env:COMPUTERNAME"
$lines += ""

# ── Entra / domain join state ─────────────────────────────────────────────────
$lines += "[DEVICE JOIN STATE (dsregcmd /status)]"
try {
    $dsreg = dsregcmd /status 2>&1
    $relevant = $dsreg | Where-Object {
        $_ -match "AzureAdJoined|EnterpriseJoined|DomainJoined|WorkplaceJoined|MdmUrl|IsDeviceRoamingEnabled|TenantName|DeviceId"
    }
    $relevant | ForEach-Object { $lines += "  $_" }
} catch { $lines += "  dsregcmd failed: $($_.Exception.Message)" }
$lines += ""

# ── MDM enrollment check ──────────────────────────────────────────────────────
$lines += "[MDM ENROLLMENT (registry)]"
$mdmPath = "HKLM:\SOFTWARE\Microsoft\Enrollments"
if (Test-Path $mdmPath) {
    $enrollments = Get-ChildItem $mdmPath -ErrorAction SilentlyContinue
    if ($enrollments) {
        $lines += "  MDM enrollment records found: $($enrollments.Count)"
        $enrollments | Select-Object -First 3 | ForEach-Object {
            $upn = (Get-ItemProperty $_.PSPath -Name "UPN" -ErrorAction SilentlyContinue).UPN
            $type = (Get-ItemProperty $_.PSPath -Name "EnrollmentType" -ErrorAction SilentlyContinue).EnrollmentType
            if ($upn) { $lines += "  UPN: $upn  Type: $type" }
        }
    } else {
        $lines += "  No MDM enrollment records found."
    }
} else {
    $lines += "  MDM enrollment registry path not found."
}
$lines += ""

# ── Required files ────────────────────────────────────────────────────────────
$lines += "[REQUIRED FILES]"
@("join-state-evidence.md", "tenant-setup-notes.md", "pilot-group-design.md", "enrollment-diagnosis.md", "README.md") | ForEach-Object {
    $p = Join-Path $PSScriptRoot $_
    if (Test-Path $p) { $lines += "  $_ : FOUND ($((Get-Item $p).Length) bytes)" }
    else              { $lines += "  $_ : NOT FOUND" }
}
$lines += ""
$lines += "Commit this file (evidence-report.txt) to your GitHub repo under week10-intune-enrollment/."

$out = $lines -join "`n"
$out | Out-File -FilePath (Join-Path $PSScriptRoot "evidence-report.txt") -Encoding utf8
Write-Host $out
