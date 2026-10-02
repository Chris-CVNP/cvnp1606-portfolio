# CVNP1606 Week 06 — Evidence Collection Script
# Run as Administrator. Saves output to evidence-report.txt.
# Commit evidence-report.txt to your GitHub portfolio repo under week06-network-rca/.
# Run AFTER you have repaired the simulated fault.

$lines = @()
$lines += "=== CVNP1606-W06 Evidence Report ==="
$lines += "Generated : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$lines += "Host      : $env:COMPUTERNAME"
$lines += ""

# ── IP configuration summary ──────────────────────────────────────────────────
$lines += "[IP CONFIGURATION]"
Get-NetIPConfiguration | Where-Object { $_.IPv4Address } | ForEach-Object {
    $lines += "  Adapter      : $($_.InterfaceAlias)"
    $lines += "  IPv4 Address : $($_.IPv4Address.IPAddress)"
    $lines += "  Prefix       : /$($_.IPv4Address.PrefixLength)"
    $lines += "  Gateway      : $($_.IPv4DefaultGateway.NextHop)"
    $lines += "  DHCP Enabled : $($_.NetIPv4Interface.Dhcp -eq 'Enabled')"
    $lines += ""
}

# ── DNS servers ───────────────────────────────────────────────────────────────
$lines += "[DNS SERVERS]"
Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object { $_.ServerAddresses } | ForEach-Object {
    $lines += "  $($_.InterfaceAlias) : $($_.ServerAddresses -join ', ')"
}
$lines += ""

# ── Connectivity test ─────────────────────────────────────────────────────────
$lines += "[CONNECTIVITY TESTS]"
@("127.0.0.1", "8.8.8.8") | ForEach-Object {
    $result = Test-Connection -ComputerName $_ -Count 1 -ErrorAction SilentlyContinue
    $status = if ($result) { "REACHABLE" } else { "UNREACHABLE" }
    $lines += "  Ping $_ : $status"
}
$lines += ""

# ── Network profile ───────────────────────────────────────────────────────────
$lines += "[NETWORK PROFILES]"
Get-NetConnectionProfile | ForEach-Object {
    $lines += "  $($_.InterfaceAlias.PadRight(24)) Category: $($_.NetworkCategory)"
}
$lines += ""

# ── Required files ────────────────────────────────────────────────────────────
$lines += "[REQUIRED FILES]"
@("connectivity-evidence.txt", "user-instructions.md", "escalation-note.md", "README.md") | ForEach-Object {
    $p = Join-Path $PSScriptRoot $_
    if (Test-Path $p) { $lines += "  $_ : FOUND ($((Get-Item $p).Length) bytes)" }
    else              { $lines += "  $_ : NOT FOUND" }
}
$lines += ""
$lines += "Commit this file (evidence-report.txt) to your GitHub repo under week06-network-rca/."

$out = $lines -join "`n"
$out | Out-File -FilePath (Join-Path $PSScriptRoot "evidence-report.txt") -Encoding utf8
Write-Host $out
