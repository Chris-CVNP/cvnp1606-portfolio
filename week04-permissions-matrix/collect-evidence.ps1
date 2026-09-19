# CVNP1606 Week 04 — Evidence Collection Script
# Run as Administrator. Saves output to evidence-report.txt.
# Commit evidence-report.txt to your GitHub portfolio repo under week04-permissions-matrix/.

$lines = @()
$lines += "=== CVNP1606-W04 Evidence Report ==="
$lines += "Generated : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += "Host      : $env:COMPUTERNAME"
$lines += ""

# ── HR security groups ────────────────────────────────────────────────────────
$lines += "[HR SECURITY GROUPS]"
@("HR-Managers", "HR-Staff", "Audit-Readonly") | ForEach-Object {
    $g = Get-LocalGroup -Name $_ -ErrorAction SilentlyContinue
    $lines += "  $_ : $(if ($g) { 'FOUND' } else { 'NOT FOUND' })"
}
$lines += ""

# ── hr-staff-test account ─────────────────────────────────────────────────────
$lines += "[HR-STAFF-TEST ACCOUNT]"
$acct = Get-LocalUser -Name "hr-staff-test" -ErrorAction SilentlyContinue
if ($acct) {
    $lines += "  hr-staff-test : FOUND | Enabled: $($acct.Enabled)"
    $inHRStaff  = (Get-LocalGroupMember -Group "HR-Staff"    -ErrorAction SilentlyContinue).Name -contains "$env:COMPUTERNAME\hr-staff-test"
    $inAdmin    = (Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue).Name -contains "$env:COMPUTERNAME\hr-staff-test"
    $inManagers = (Get-LocalGroupMember -Group "HR-Managers" -ErrorAction SilentlyContinue).Name -contains "$env:COMPUTERNAME\hr-staff-test"
    $lines += "  In HR-Staff       : $inHRStaff   (should be True)"
    $lines += "  In HR-Managers    : $inManagers  (should be False)"
    $lines += "  In Administrators : $inAdmin     (should be False)"
} else {
    $lines += "  hr-staff-test : NOT FOUND"
}
$lines += ""

# ── HR folder structure ───────────────────────────────────────────────────────
$lines += "[FOLDER STRUCTURE]"
@("C:\HR", "C:\HR\Payroll", "C:\HR\Payroll\CurrentYear", "C:\HR\Payroll\Archive") | ForEach-Object {
    $lines += "  $_ : $(if (Test-Path $_) { 'EXISTS' } else { 'MISSING' })"
}
$lines += ""

# ── Payroll share ─────────────────────────────────────────────────────────────
$lines += "[SMB SHARE: Payroll]"
$share = Get-SmbShare -Name "Payroll" -ErrorAction SilentlyContinue
if ($share) {
    $lines += "  Share path : $($share.Path)"
    $perms = Get-SmbShareAccess -Name "Payroll" -ErrorAction SilentlyContinue
    $perms | ForEach-Object { $lines += "  $($_.AccountName.PadRight(28)) $($_.AccessRight)" }
    $everyone = $perms | Where-Object { $_.AccountName -match "Everyone" }
    $lines += "  Everyone removed : $(if ($everyone) { 'NO — Everyone still present' } else { 'YES' })"
} else {
    $lines += "  Payroll share : NOT FOUND"
}
$lines += ""

# ── NTFS ACL on C:\HR\Payroll ─────────────────────────────────────────────────
$lines += "[NTFS ACL: C:\HR\Payroll]"
try {
    $acl = Get-Acl "C:\HR\Payroll"
    $acl.Access | ForEach-Object {
        $lines += "  $($_.IdentityReference.ToString().PadRight(32)) $($_.FileSystemRights)"
    }
} catch { $lines += "  Could not read ACL: $($_.Exception.Message)" }
$lines += ""

# ── Required files ────────────────────────────────────────────────────────────
$lines += "[REQUIRED FILES]"
@("acl-before.txt", "acl-after.txt", "access-test-results.md", "README.md") | ForEach-Object {
    $p = Join-Path $PSScriptRoot $_
    if (Test-Path $p) { $lines += "  $_ : FOUND ($((Get-Item $p).Length) bytes)" }
    else              { $lines += "  $_ : NOT FOUND" }
}
$lines += ""
$lines += "Commit this file (evidence-report.txt) to your GitHub repo under week04-permissions-matrix/."

$out = $lines -join "`n"
$out | Out-File -FilePath (Join-Path $PSScriptRoot "evidence-report.txt") -Encoding utf8
Write-Host $out
