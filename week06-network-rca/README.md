# CVNP1606 Week 6: Network Diagnostics and Root Cause Analysis

Ticket CVNP1606-W06-006, ACME-EMILY-REMOTE

---

## Objectives

- Simulate a connectivity fault on a Windows 11 VM
- Run the full diagnostic command set and capture the output as evidence
- Identify the fault layer and document the root cause
- Write instructions a non-technical user can follow
- Document the tier 1 and escalation boundary

---

## Tools Used

- Get-NetAdapter: find the name of the network adapter
- Get-DnsClientServerAddress: show the DNS server set on each adapter
- Set-DnsClientServerAddress: set the DNS fault and restore the original server
- ipconfig /all: show the IP address, gateway, and DNS servers
- ipconfig /flushdns: clear the DNS cache after the fix
- ping: test the local stack, the gateway, and an external address
- nslookup and Resolve-DnsName: test name resolution
- Test-NetConnection: test whether a specific TCP port is reachable
- Out-File and Get-Content: save the evidence to a file and read it back

---

## Configuration

### Ticket Information

- Ticket ID: CVNP1606-W06-006
- Submitted by: Emily Park, ACME Remote Employee, via helpdesk portal
- Affected system: ACME-EMILY-REMOTE
- Business impact: High. Emily is blocked from all ACME resources during working hours.

### Scenario Summary

Emily Park reported that she could not reach the ACME intranet or shared drives from her remote laptop, although some external websites still loaded. I simulated the problem on my Windows 11 VM by changing the DNS server to 1.2.3.4, ran the diagnostic commands, and found that IP addressing and routing worked while name resolution did not. I set the DNS server back to 10.10.50.1, and name lookups were answered again.

### Fault Simulated

I chose the DNS fault. The DNS server on the network adapter was changed to 1.2.3.4 while the IP address and gateway were left correct. The symptom was that IP addresses could still be reached but names would not resolve.

---

## Step 1: Identify the adapter and record the original DNS server

```
Get-NetAdapter
```

```
Get-DnsClientServerAddress -AddressFamily IPv4
```

Expected output includes: the adapter name Ethernet and the original DNS server 10.10.50.1.

Status: Complete.

## Step 2: Set the DNS fault

Run from a PowerShell window opened as administrator.

```
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 1.2.3.4
```

```
Get-DnsClientServerAddress -AddressFamily IPv4
```

Expected output includes: Ethernet showing ServerAddresses {1.2.3.4}.

Status: Complete. See screenshots/01-dns-fault-configuration.png and Troubleshooting Notes, Issue 1 and Issue 2.

## Step 3: Read the adapter configuration

```
ipconfig /all
```

Expected output includes: IPv4 Address 10.10.50.102, Default Gateway 10.10.50.1, DNS Servers 1.2.3.4.

Status: Complete. See screenshots/02-ipconfig-all-dns-fault.png.

## Step 4: Test layer by layer

```
ping 127.0.0.1
```

```
ping 10.10.50.1
```

```
ping 8.8.8.8
```

```
nslookup acme.internal
```

```
Resolve-DnsName acme.internal
```

Expected output includes: replies from all three ping targets with 0% loss, "DNS request timed out" from nslookup against 1.2.3.4, and a timeout error from Resolve-DnsName.

Status: Complete. See screenshots/03-layer-tests-ping-nslookup.png.

## Step 5: Test port reachability

```
Test-NetConnection -ComputerName 8.8.8.8 -Port 443
```

```
Test-NetConnection -ComputerName 8.8.8.8 -Port 80
```

Expected output includes: TcpTestSucceeded True on port 443. Port 80 returned TcpTestSucceeded False.

Status: Complete. See screenshots/04-test-netconnection-port-80-investigation.png and Troubleshooting Notes, Issue 3.

## Step 6: Export the evidence

```
Set-Location C:\Users\****\Documents\cvnp1606-portfolio
```

```
New-Item -ItemType Directory week06-network-rca
```

```
Set-Location week06-network-rca
```

```
ipconfig /all | Out-File connectivity-evidence.txt -Encoding utf8
```

```
ping 8.8.8.8 | Out-File connectivity-evidence.txt -Append -Encoding utf8
```

```
nslookup acme.internal | Out-File connectivity-evidence.txt -Append -Encoding utf8
```

```
Test-NetConnection -ComputerName 8.8.8.8 -Port 80 | Out-File connectivity-evidence.txt -Append -Encoding utf8
```

```
Get-Content connectivity-evidence.txt
```

Expected output includes: all four sections in one file, in the order ipconfig, ping, nslookup, Test-NetConnection.

Status: Complete. See screenshots/05-evidence-export-get-content.png.

## Step 7: Restore the DNS server

Run from a PowerShell window opened as administrator.

```
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 10.10.50.1
```

```
ipconfig /flushdns
```

Expected output includes: the DNS resolver cache flushed successfully.

Status: Complete.

## Step 8: Verify the fix

```
ipconfig /all
```

```
nslookup acme.internal
```

```
Resolve-DnsName www.microsoft.com
```

Expected output includes: DNS Servers 10.10.50.1, an answer from 10.10.50.1 of "Non-existent domain" for the simulated name acme.internal, and CNAME, AAAA, and A records for www.microsoft.com.

Status: Complete. See screenshots/06-fix-verification-after.png.

---

## Root Cause

The problem was located in the DNS Layer. The DNS Server for the Adapter is listed at 1.2.3.4; this is a Non-Answering DNS server. It doesn't respond to DNS queries, and therefore each Hostname Lookup Failed. Within the file connectivity-evidence.txt, we see a valid IPv4 address (10.10.50.102), a valid Default Gateway of 10.10.50.1, and an invalid DNS server entry of 1.2.3.4. As shown below, pinging 8.8.8.8 resulted in 4 packets sent and 4 packets received; and as you can also see in connectivity-evidence.txt, when performing an nslookup on acme.internal it returns DNS request timed out against server unknown at 1.2.3.4. This proves that while IP addressing/routing were working properly, name resolution was not working properly. To verify my diagnosis, I changed the DNS Server back to its previous value of 10.10.50.1; after making the change, I ran another nslookup, and it now received an answer from 10.10.50.1 rather than timing out. Also, I ran Resolve-DnsName www.microsoft.com, and now the name resolved to address records.

---

## Troubleshooting Narrative

### 1. What fault did you simulate and what symptom did it produce?

I changed the DNS Server for the Network Adapter to "1.2.3.4" while leaving both the IP Address and Gateway unchanged. After doing this, the PC was able to connect to IP Addresses as usual; however, it could not resolve Names.

### 2. Which diagnostic command gave you the first clear signal of the fault layer?

ipconfig /all was run and the IP Address/Gateway were correct. However, the DNS Servers field stated "1.2.3.4", which is NOT A VALID DNS SERVER. After running nslookup acme.internal it timed out using the above mentioned address; therefore, this pretty much confirmed my suspicions.

### 3. What did you try first to resolve it?

The DNS Server was switched back to "10.10.50.1", and then I ran ipconfig /flushdns to clear any stale data from the computer.

### 4. What confirmed the fix worked, or what would you try next if it did not?

I ran nslookup acme.internal again and it responded from "10.10.50.1" (the internal DNS) rather than timing out. Additionally, when I ran Resolve-DnsName www.microsoft.com, it returned multiple addresses. If either of these commands had failed, I would have escalated it to Kevin, our Network Administrator, since at that point it could be either the DNS Server or the VPN; neither of those are Tier 1 tasks.

### 5. How did you verify the result after the fix?

One last time I ran ipconfig /all and the DNS Servers field stated "10.10.50.1". I then placed the "before/after" side-by-side for comparison purposes. The "Before Fix" resulted in the nslookup command timing out and "After Fix", the command successfully returned an Answer.

### 6. What was the support or business impact of leaving this issue unresolved?

This was classified as High Impact. Emily could not access the Intranet nor her Shared Drives and therefore could not perform her duties until it was resolved.

---

## Troubleshooting Notes

### Issue 1: Placeholder left in the DNS command

Incorrect command:

```
Set-DnsClientServerAddress -InterfaceAlias "[adapter name from Get-NetAdapter]" -ServerAddresses 1.2.3.4
```

Root Cause: The command still contained placeholder text instead of the real adapter name. PowerShell treats square brackets as wildcard characters, so it returned a WildcardPatternException.

Resolution: Used the adapter name Ethernet from the Get-NetAdapter output.

Result: The wildcard error was gone. The command then failed for a different reason, covered in Issue 2.

### Issue 2: Access denied when changing the DNS server

Incorrect command, run from a PowerShell window that was not opened as administrator:

```
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 1.2.3.4
```

Root Cause: The command returned "Access to a CIM resource was not available to the client" (MI RESULT 2, access denied). Changing adapter settings needs an elevated session.

Resolution: Ran the same command from a PowerShell window opened as administrator.

Result: The DNS server changed to 1.2.3.4, confirmed with Get-DnsClientServerAddress.

### Issue 3: Port 80 test to 8.8.8.8 failed

Command with the unexpected result:

```
Test-NetConnection -ComputerName 8.8.8.8 -Port 80
```

Root Cause: TcpTestSucceeded returned False while PingSucceeded was True. This test uses an IP address, so it is not caused by the DNS fault. Two extra tests were run to find the cause:

```
Test-NetConnection -ComputerName 1.1.1.1 -Port 80
```

```
try { (New-Object Net.Sockets.TcpClient).Connect('8.8.8.8',80) } catch { $_.Exception.InnerException.Message }
```

Port 443 to 8.8.8.8 had already returned True. Port 80 to 1.1.1.1 returned True, which rules out a general outbound block on the lab network. The direct connection to 8.8.8.8 on port 80 timed out with no response. Port 80 on 8.8.8.8 is filtered. The address is a public DNS resolver and is not documented as serving HTTP on port 80.

Resolution: No fix needed. The command is the one the assignment specifies, so the output was kept in connectivity-evidence.txt as is.

Result: The False result is expected for this target and is unrelated to the DNS fault. See screenshots/04-test-netconnection-port-80-investigation.png.

---

## Evidence

- connectivity-evidence.txt: output of all four diagnostic commands with the fault in place
- screenshots/01-dns-fault-configuration.png: fault configuration, DNS server set to 1.2.3.4
- screenshots/02-ipconfig-all-dns-fault.png: ipconfig /all showing IP, gateway, and DNS fields
- screenshots/03-layer-tests-ping-nslookup.png: ping tests and name lookup failures
- screenshots/04-test-netconnection-port-80-investigation.png: Test-NetConnection results with TcpTestSucceeded, plus the port 80 investigation
- screenshots/05-evidence-export-get-content.png: the export commands and Get-Content showing all four sections
- screenshots/06-fix-verification-after.png: DNS server restored and name resolution working
- evidence-report.txt: output of collect-evidence.ps1

---

## Escalation Note

The full note is in escalation-note.md. Tier 1 actions on this ticket were running the diagnostics, correcting the DNS server setting on the laptop, flushing the DNS cache, and verifying the fix. A DNS server or VPN problem, or a firewall or VPN server configuration problem, would be escalated to Kevin, ACME Network Administrator.

---

## Portfolio Card

### What I Can Do Now

Using ipconfig /all, ping, nslookup, Resolve-DnsName, and Test-NetConnection, I isolated a DNS fault on a remote worker's Windows laptop, verified the fix with a before and after test, and documented which problems tier 1 can fix and which go to the network administrator.

---

## AI Use Statement

I used Claude to assist with this lab. It gave me the PowerShell commands to set and restore the DNS server since the assignment did not include them, and it explained the command output when I had an output that was not expected. I ran every command myself on my Windows 11 VM, checked each result against the real output, and rewrote the drafts in my own words. Full details are in ai-validation.md and ai-disclosure.md.

---

## Files In This Folder

- README.md
- connectivity-evidence.txt
- user-instructions.md
- escalation-note.md
- ai-validation.md
- ai-disclosure.md
- collect-evidence.ps1
- evidence-report.txt
- screenshots/
  - 01-dns-fault-configuration.png
  - 02-ipconfig-all-dns-fault.png
  - 03-layer-tests-ping-nslookup.png
  - 04-test-netconnection-port-80-investigation.png
  - 05-evidence-export-get-content.png
  - 06-fix-verification-after.png