# Final ACME Audit
Ticket CVNP1606-W16-016

## Scenario Summary
Nexus Support Services manages ACME's endpoint fleet, and with the contract up for renewal, Riley Chen needed a final audit package proving ACME's managed endpoints are secure, supportable, fully documented, and recoverable. This package includes a PowerShell health-report script run on a live endpoint, three annotated ticket-evidence artifacts from local, cloud, and security work, an AI validation journal, and portfolio defense notes. Together they show the endpoint management work completed across the 16-week engagement.

## Tools Used Across the Course
- PowerShell: Get-ComputerInfo, Get-MpComputerStatus, Get-NetFirewallProfile, Get-LocalGroupMember, Get-WinEvent, Get-PSDrive, Get-PnpDevice, Get-NetAdapter, Resolve-DnsName, Test-NetConnection, Out-File, Get-Content
- Command line: manage-bde, dsregcmd /status, ipconfig /all, nslookup
- Event Viewer
- Device Manager
- Windows Settings
- Microsoft Intune admin center: endpoint security policies, disk encryption, update rings, Windows update reports, remote actions
- Microsoft Entra ID
- Windows Autopilot
- Microsoft Defender Antivirus
- Windows Defender Firewall
- BitLocker
- Proxmox VE
- Git and GitHub
- collect-evidence.ps1

## Three Things I Did Right
1. Documented every deviation instead of hiding them. Stated in each README file when I couldn't obtain my own Intune tenant and used the instructor's evidence. Listed the Settings screenshot as not available, instead of using an alternative, in Week 10.
2. Verified the AI's output with actual evidence before relying on it. Caught a DNS command error with a placeholder adapter name in Week 6 and corrected it by running Get-NetAdapter. Escalated a citation from a Week 8 desk discussion that came from a notebook AI response, since the referenced line was not in any ACME document.
3. Adhered to the sensitive data standard. Blurred the username in my Week 14 screenshots; used [RECOVERY-KEY-REDACTED] in the BitLocker SOP. Verified that manage-bde in health-report.ps1 only prints protectors and does not print the recovery key.

## One Thing I Would Do Differently
I spent too much time preparing to import a very large instructor-provided VMware VM, resizing my VM disk and enabling nested virtualization, prior to determining what the lab required. The instructor's follow-up email indicated that all that was necessary was a relatively small script bundle that seeded faults onto my existing VM. Next time, I will verify and confirm setup details with the instructor before altering my infrastructure.

## Portfolio Card

### What I Can Do Now
I completed a 16-week endpoint support practicum for the ACME engagement, built a PowerShell health-report script and an MSP audit package with curated local, cloud, and security ticket evidence, and prepared a technical portfolio I can walk through in an A+ or MD-102 interview.