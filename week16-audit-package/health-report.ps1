# Section 1 - OS Version
Write-Output "=== OS VERSION ==="
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsArchitecture | Format-List

# Section 2 - Defender Status
Write-Output "`n=== DEFENDER STATUS ==="
Get-MpComputerStatus | Select-Object AntivirusEnabled, RealTimeProtectionEnabled, AMRunningMode | Format-List

# Section 3 - Firewall Profiles
Write-Output "`n=== FIREWALL PROFILES ==="
Get-NetFirewallProfile | Select-Object Name, Enabled | Format-List

# Section 4 - Local Administrators
Write-Output "`n=== LOCAL ADMINISTRATORS ==="
Get-LocalGroupMember -Group "Administrators" | Select-Object Name, PrincipalSource | Format-List

# Section 5 - BitLocker Status (requires Administrator)
Write-Output "`n=== BITLOCKER STATUS ==="
manage-bde -status C:

# Section 6 - Disk Space
Write-Output "`n=== DISK SPACE ==="
Get-PSDrive C | Select-Object Used, Free | Format-List

# Section 7 - Recent Critical Events (last 7 days)
Write-Output "`n=== RECENT CRITICAL EVENTS (last 7 days) ==="
Get-WinEvent -FilterHashtable @{LogName='System','Application'; Level=1,2; StartTime=(Get-Date).AddDays(-7)} -ErrorAction SilentlyContinue | Select-Object -First 5 TimeCreated, LevelDisplayName, ProviderName | Format-Table