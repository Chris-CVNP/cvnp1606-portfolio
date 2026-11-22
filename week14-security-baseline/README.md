# Week 14: Endpoint Security at Scale
Ticket CVNP1606-W14-014

## Objectives
- Document one Intune endpoint security policy with its type, key settings, and assigned group
- Verify local Defender and firewall posture with PowerShell
- Document baseline variance between local state and policy intent
- Write a BitLocker SOP with no real recovery keys
- Confirm all sensitive data is redacted from the submission

## Tools Used
- Get-MpComputerStatus
- Get-NetFirewallProfile
- Out-File
- Get-Content
- collect-evidence.ps1
- Intune admin center, instructor-provided screenshots

## Configuration

### Ticket Information
- Ticket ID: CVNP1606-W14-014
- Submitted by: Riley Chen, ACME IT Manager
- Affected system: ACME Managed Endpoint Fleet / Intune Security Policies
- Business impact: Critical
- Initial evidence: Two devices show non-compliant Defender status in Intune. BitLocker enforcement policy exists but recovery-key backup to Entra ID is unverified. No baseline variance note on file.

### Scenario Summary
ACME is going through an external security audit, and Riley needs documented proof that every managed endpoint meets the security baseline. I documented the ACME-Firewall-Baseline endpoint security policy, verified Defender and firewall posture on my lab VM with PowerShell, recorded the differences between the local state and the policy in a baseline variance note, wrote a BitLocker SOP, and reviewed every file in the submission for sensitive data.

## Step 1: Restore the clean baseline
Status: Not performed. See Troubleshooting Notes, Issue 1.

## Step 2: Document an endpoint security policy in Intune
Location: Intune admin center > Endpoint security > Firewall > ACME-Firewall-Baseline

Expected output includes:
- Policy type: Windows Firewall, platform Windows
- Enable Domain, Private, and Public Network Firewall: True
- Default Inbound Action: Block on all three profiles
- Default Outbound Action: Allow on all three profiles
- Enable Log Dropped Packets: Enable Logging Of Dropped Packets
- Assigned group: ACME-Pilot-Devices, no filter, no excluded groups

Evidence: screenshots/01-security-policy-settings.png, screenshots/02-security-policy-assignment.png

Status: Complete

## Step 3: Verify Defender and firewall posture with PowerShell

```
Get-MpComputerStatus | Out-File defender-status.txt
```
Exports the full Defender status to defender-status.txt.

```
Get-NetFirewallProfile | Out-File firewall-status.txt
```
Exports the Domain, Private, and Public firewall profiles to firewall-status.txt.

```
Get-Content defender-status.txt
```
Expected output includes:
- AMRunningMode: Normal
- AntivirusEnabled: True
- RealTimeProtectionEnabled: True

Evidence: screenshots/03-defender-status.png

```
Get-Content firewall-status.txt
```
Expected output includes:
- Enabled: True for Domain, Private, and Public
- DefaultInboundAction: NotConfigured
- DefaultOutboundAction: NotConfigured
- LogBlocked: False

Evidence: screenshots/04-firewall-status.png

Variance findings are documented in baseline-variance-note.md.

Status: Complete

## Step 4: Write bitlocker-sop.md
Covers enforcement, recovery key backup path, authorization, and ticket documentation. Every key value appears only as [RECOVERY-KEY-REDACTED].

Status: Complete

## Step 5: Complete redaction-checklist.md
Every screenshot and document in the folder was reviewed. The username was blurred in the PowerShell prompt in 03-defender-status.png and 04-firewall-status.png. All other files passed.

Status: Complete

## Step 6: Run the evidence collection script

```
.\collect-evidence.ps1
```
Expected output includes:
- evidence-report.txt created in the week folder
- All required files show FOUND

Status: Complete

## Troubleshooting Notes

### Issue 1
Task: Restore the W01_CleanBaseline snapshot.
Root Cause: Rolling the VM back to the Week 1 snapshot would have removed all work done on the VM since Week 1.
Resolution: I chose not to roll back and ran the Task 3 commands on the VM in its current state.
Result: Task 1 screenshots are not included.

### Issue 2
Task: Document an endpoint security policy in the Intune admin center.
Root Cause: I do not have access to an Intune tenant.
Resolution: I used the instructor-provided screenshots and saved policy text for ACME-Firewall-Baseline.
Result: The lab VM is not enrolled in Intune, so the policy never reached it. This is the cause of the three variances in baseline-variance-note.md.

## Troubleshooting Narrative

What went wrong, or what could realistically have gone wrong?
ACME Lab VM firewalls are not running the settings of the ACME-Firewall-Baseline. The default profile actions for DefaultInboundAction and DefaultOutboundAction in Get-NetFirewallProfile are NotConfigured; and, the LogBlocked option is false on all three profiles; whereas, according to the policy, they should be Block; Allow; and log dropped packets.

What evidence did you check first?
First, I looked at the enabled state of the domain, private, and public profiles in firewall-status.txt to determine if the policy was being enforced. Then, I compared those results with the instructor-provided screenshots and saved policy text from Intune to identify where the policy differed.

What did you try?
Before trying anything else, I made sure Defender was working correctly to eliminate it as a possible cause. To begin troubleshooting the problem, I took a look at each individual firewall setting and compared them to the policy settings provided by my instructor. Once I identified differences in three of the firewall settings, I determined that was probably where the error occurred.

What fixed it, or what would you try next?
The device isn't enrolled in Intune nor is it part of ACME-Pilot-Devices, therefore, it will never receive the policy. Enrolling the device into Intune, putting it into ACME-Pilot-Devices and forcing Intune to sync would solve this issue.

How did you verify the result?
Once I got my export files written, as indicated by Get-Content, I reviewed them to make certain that they contained the information noted about how much the firewall profile differed from the policy. When Intune finishes syncing after enrollment, I would run another instance of Get-NetFirewallProfile to confirm that DefaultInboundAction is Block on all three profiles, DefaultOutboundAction is Allow on all three profiles, and LogBlocked is true on all three profiles.

What was the security or compliance impact of the issue or fix?
Because the LogBlocked field is false, when traffic is blocked by the firewall, for example during testing, the event won't appear in pfirewall.log for auditing purposes. Furthermore, this device will be considered out-of-baseline since it is unenrolled and does not currently meet requirements, and will remain so until it is successfully enrolled and audited.

## Portfolio Card

### What I Can Do Now
I documented an Intune Windows Firewall policy, verified Defender and firewall posture on a lab VM with Get-MpComputerStatus and Get-NetFirewallProfile, recorded the baseline variances for an external audit, wrote a BitLocker recovery key SOP, and redacted the submission so no keys, credentials, or PII were exposed.

## AI Use Statement
Tool: Claude by Anthropic.
What it helped with: giving the PowerShell steps in the order the assignment lists them and correcting my written work.
How I verified it: I ran Get-MpComputerStatus and Get-NetFirewallProfile on my lab VM and checked every value in the variance note against my own output. I checked the policy settings against the instructor-provided Intune screenshots and saved policy text.

## Files In This Folder
- README.md
- baseline-variance-note.md
- bitlocker-sop.md
- redaction-checklist.md
- ai-disclosure.md
- defender-status.txt
- firewall-status.txt
- collect-evidence.ps1
- evidence-report.txt
- screenshots/01-security-policy-settings.png
- screenshots/02-security-policy-assignment.png
- screenshots/03-defender-status.png
- screenshots/04-firewall-status.png