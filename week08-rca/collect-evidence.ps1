# CVNP1606 Week 08 — Evidence Collection Script
# Run as Administrator. Saves output to evidence-report.txt.
# Commit evidence-report.txt to your GitHub portfolio repo under week08-rca/.

$lines = @()
$lines += "=== CVNP1606-W08 Evidence Report ==="
$lines += "Generated : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += "Host      : $env:COMPUTERNAME"
$lines += ""

# ── Recent critical/error events in System log ───────────────────────────────
$lines += "[SYSTEM LOG — CRITICAL & ERROR (last 7 days)]"
try {
    $events = Get-WinEvent -FilterHashtable @{
        LogName   = 'System'
        Level     = @(1, 2)   # 1=Critical, 2=Error
        StartTime = (Get-Date).AddDays(-7)
    } -ErrorAction SilentlyContinue | Select-Object -First 15
    if ($events) {
        $events | ForEach-Object {
            $lines += "  $($_.TimeCreated.ToString('yyyy-MM-dd HH:mm:ss'))  ID:$($_.Id.ToString().PadLeft(5))  $($_.ProviderName) — $($_.LevelDisplayName)"
        }
    } else {
        $lines += "  No Critical or Error events found in the last 7 days."
    }
} catch { $lines += "  Could not query event log: $($_.Exception.Message)" }
$lines += ""

# ── Unexpected shutdown events (6008/41) ─────────────────────────────────────
$lines += "[UNEXPECTED SHUTDOWN EVENTS (6008 / 41)]"
try {
    $shutdownEvents = Get-WinEvent -FilterHashtable @{
        LogName = 'System'; Id = @(6008, 41)
    } -ErrorAction SilentlyContinue | Select-Object -First 10
    if ($shutdownEvents) {
        $shutdownEvents | ForEach-Object {
            $lines += "  $($_.TimeCreated.ToString('yyyy-MM-dd HH:mm:ss'))  ID:$($_.Id)  $($_.Message.Substring(0,[Math]::Min(80,$_.Message.Length)))"
        }
    } else {
        $lines += "  No Event ID 6008 or 41 found."
    }
} catch { $lines += "  Could not query shutdown events: $($_.Exception.Message)" }
$lines += ""

# ── Last boot time ────────────────────────────────────────────────────────────
$lines += "[LAST BOOT]"
$os = Get-CimInstance Win32_OperatingSystem
$lines += "  Last boot : $($os.LastBootUpTime.ToString('yyyy-MM-dd HH:mm:ss'))"
$lines += ""

# ── Required files ────────────────────────────────────────────────────────────
$lines += "[REQUIRED FILES]"
@("event-export.txt", "event-timeline.md", "README.md") | ForEach-Object {
    $p = Join-Path $PSScriptRoot $_
    if (Test-Path $p) { $lines += "  $_ : FOUND ($((Get-Item $p).Length) bytes)" }
    else              { $lines += "  $_ : NOT FOUND" }
}
$lines += ""
$lines += "Commit this file (evidence-report.txt) to your GitHub repo under week08-rca/."

$out = $lines -join "`n"
$out | Out-File -FilePath (Join-Path $PSScriptRoot "evidence-report.txt") -Encoding utf8
Write-Host $out

