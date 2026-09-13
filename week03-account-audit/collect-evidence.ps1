# CVNP1606 Week 03 — Evidence Collection Script
# Run as Administrator. Saves output to evidence-report.txt.
# Commit evidence-report.txt to your GitHub portfolio repo under week03-account-audit/.

$lines = @()
$lines += "=== CVNP1606-W03 Evidence Report ==="
$lines += "Generated : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += "Host      : $env:COMPUTERNAME"
$lines += ""

# ── All local accounts ────────────────────────────────────────────────────────
$lines += "[LOCAL ACCOUNTS]"
Get-LocalUser | ForEach-Object {
    $lines += "  $($_.Name.PadRight(28)) Enabled: $($_.Enabled)"
}
$lines += ""

# ── seasonal-staff account check ─────────────────────────────────────────────
$lines += "[SEASONAL-STAFF ACCOUNT]"
$sa = Get-LocalUser -Name "seasonal-staff" -ErrorAction SilentlyContinue
if ($sa) {
    $lines += "  seasonal-staff : FOUND | Enabled: $($sa.Enabled)"
    $inAdmin = (Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue).Name -contains "$env:COMPUTERNAME\seasonal-staff"
    $lines += "  In Administrators group : $inAdmin  (should be False)"
} else {
    $lines += "  seasonal-staff : NOT FOUND"
}
$lines += ""

# ── Administrators group membership ──────────────────────────────────────────
$lines += "[ADMINISTRATORS GROUP]"
Get-LocalGroupMember -Group "Administrators" | ForEach-Object {
    $lines += "  $($_.Name) ($($_.PrincipalSource))"
}
$lines += ""

# ── Users group membership ────────────────────────────────────────────────────
$lines += "[USERS GROUP (standard accounts)]"
Get-LocalGroupMember -Group "Users" | ForEach-Object {
    $lines += "  $($_.Name) ($($_.PrincipalSource))"
}
$lines += ""

# ── Required files ────────────────────────────────────────────────────────────
$lines += "[REQUIRED FILES]"
@("local-users-export.txt", "least-privilege-memo.md", "README.md") | ForEach-Object {
    $p = Join-Path $PSScriptRoot $_
    if (Test-Path $p) { $lines += "  $_ : FOUND ($((Get-Item $p).Length) bytes)" }
    else              { $lines += "  $_ : NOT FOUND" }
}
$lines += ""
$lines += "Commit this file (evidence-report.txt) to your GitHub repo under week03-account-audit/."

$out = $lines -join "`n"
$out | Out-File -FilePath (Join-Path $PSScriptRoot "evidence-report.txt") -Encoding utf8
Write-Host $out
