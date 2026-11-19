# CVNP1606 Week 13 — Evidence Collection Script
# Run as Administrator. Saves output to evidence-report.txt.
# Commit evidence-report.txt to your GitHub portfolio repo under week13-app-deployment/.

$lines = @()
$lines += "=== CVNP1606-W13 Evidence Report ==="
$lines += "Generated : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += "Host      : $env:COMPUTERNAME"
$lines += ""

# ── Recently installed applications ──────────────────────────────────────────
$lines += "[INSTALLED APPLICATIONS (Win32_Product — last 90 days)]"
try {
    $apps = Get-CimInstance Win32_Product -ErrorAction SilentlyContinue |
        Where-Object { $_.InstallDate -ge (Get-Date).AddDays(-90).ToString("yyyyMMdd") } |
        Select-Object -First 15
    if ($apps) {
        $apps | ForEach-Object {
            $lines += "  $($_.Name.PadRight(40)) Version: $($_.Version)  Installed: $($_.InstallDate)"
        }
    } else {
        $lines += "  No applications installed in last 90 days via Win32_Product."
    }
} catch { $lines += "  Win32_Product query failed: $($_.Exception.Message)" }
$lines += ""

# ── Apps from registry (faster, broader) ─────────────────────────────────────
$lines += "[INSTALLED APPS (registry — sample)]"
$regPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)
$regApps = $regPaths | ForEach-Object {
    Get-ItemProperty $_ -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -and $_.InstallDate } |
        Select-Object DisplayName, DisplayVersion, InstallDate
} | Sort-Object InstallDate -Descending | Select-Object -First 10
$regApps | ForEach-Object {
    $lines += "  $($_.DisplayName.PadRight(40)) v$($_.DisplayVersion)  Date: $($_.InstallDate)"
}
$lines += ""

# ── Intune app status (IME log check) ─────────────────────────────────────────
$lines += "[INTUNE IME LOG]"
$imePath = "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\IntuneManagementExtension.log"
if (Test-Path $imePath) {
    $lines += "  IME log found: $imePath"
    $lines += "  Size: $([math]::Round((Get-Item $imePath).Length / 1KB, 1)) KB"
    $lines += "  Last modified: $((Get-Item $imePath).LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'))"
} else {
    $lines += "  IME log not found — Intune Management Extension may not be installed."
}
$lines += ""

# ── Required files ────────────────────────────────────────────────────────────
$lines += "[REQUIRED FILES]"
@("app-deployment-worksheet.md", "change-control-note.md", "README.md") | ForEach-Object {
    $p = Join-Path $PSScriptRoot $_
    if (Test-Path $p) { $lines += "  $_ : FOUND ($((Get-Item $p).Length) bytes)" }
    else              { $lines += "  $_ : NOT FOUND" }
}
$lines += ""
$lines += "Commit this file (evidence-report.txt) to your GitHub repo under week13-app-deployment/."

$out = $lines -join "`n"
$out | Out-File -FilePath (Join-Path $PSScriptRoot "evidence-report.txt") -Encoding utf8
Write-Host $out
