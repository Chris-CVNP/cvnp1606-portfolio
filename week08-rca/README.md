# Week 08: Event Logs and Root-Cause Analysis

Ticket: CVNP1606-W08-008

## Objectives

- Restore the VM to a clean baseline before investigating
- Filter the Windows System log for Critical and Error events in Event Viewer
- Query Event IDs 41 and 6008 with Get-WinEvent and export the results to event-export.txt
- Build a chronological event timeline in event-timeline.md
- Write a defensible root-cause analysis with an escalation note

## Tools Used

- Proxmox VE snapshot rollback
- Event Viewer, eventvwr.msc
- Get-WinEvent
- Where-Object
- Select-Object
- Format-List
- Out-File
- Get-Content
- git

## Configuration

### Ticket Information

- Ticket ID: CVNP1606-W08-008
- Submitted by: Riley Chen, ACME Branch Manager
- Affected system: ACME-W11-POS01
- Request: Investigate unexpected overnight reboots, build an event log timeline, and produce a written root-cause analysis
- Business impact: High, insurance audit requires documented cause within 48 hours
- Initial evidence: Event ID 6008 unexpected shutdown present in the System log, no user logged in at the time of reboot

### Scenario Summary

The cashier workstation ACME-W11-POS01 rebooted twice overnight with no one logged in, and the branch manager needs a documented cause for an insurance audit. I investigated the Windows System log on my lab VM, exported the Kernel-Power 41 and EventLog 6008 events, built a chronological timeline, and wrote a root-cause analysis based on that evidence.

## Step 1: Restore the Clean Baseline

In the Proxmox web interface, Datacenter > node > 101 > Snapshots, I selected W01_CleanBaseline, clicked Rollback, and confirmed with Yes. I then opened the console and signed in with my admin account.

Expected output includes: the rollback task completing and the desktop loading clean.

Status: Complete. The rollback task finished with one warning about the EFI disk Secure Boot certificates, which was already present on earlier VM starts and is not related to this lab. Screenshots: screenshots/01-snapshot-baseline-selected.png, screenshots/02-desktop-after-boot.png

## Step 2: Filter the System Log in Event Viewer

```powershell
eventvwr.msc
```

I expanded Windows Logs, selected System, clicked Filter Current Log, set Logged to Last 7 days, and checked Critical and Error. That returned 0 events, see Issue 1. I changed Logged to Any time and selected the Kernel-Power 41 event at 9/14/2026 5:03:27 PM.

Expected output includes: Critical and Error events with Kernel-Power 41 and EventLog 6008 entries, and the details panel for the selected event.

Status: Complete. 242 Critical and Error events. Screenshots: screenshots/03-event-viewer-system-log.png, screenshots/04-filtered-kernel-power-41-details.png

## Step 3: Update the Local Repo and Create the Week Folder

The snapshot rollback put the local repo back to its Week 5 state, so I pulled the later weeks before adding Week 8.

```powershell
cd C:\Users\REDACTED\Documents\cvnp1606-portfolio
```

```powershell
git fetch
```

```powershell
git status
```

```powershell
git pull
```

```powershell
mkdir week08-rca
```

Expected output includes: a fast-forward update bringing in week06-network-rca and week07-driver-change-note, and the new week08-rca folder.

Status: Complete.

## Step 4: Query the System Log with Get-WinEvent

These commands ran in PowerShell as administrator.

```powershell
cd C:\Users\REDACTED\Documents\cvnp1606-portfolio\week08-rca
```

```powershell
Get-WinEvent -LogName System -MaxEvents 50 | Where-Object {$_.Id -eq 6008 -or $_.Id -eq 41} | Select-Object TimeCreated, Id, Message | Format-List
```

```powershell
Get-WinEvent -LogName System -MaxEvents 50 | Where-Object {$_.Id -eq 6008 -or $_.Id -eq 41} | Select-Object TimeCreated, Id, Message | Out-File event-export.txt
```

```powershell
Get-Content event-export.txt
```

Expected output includes: Event ID 41 and 6008 entries with their timestamps and messages.

Status: No output. All three commands ran, but the filter and the file were empty, see Issue 2.

## Step 5: Rerun Get-WinEvent Without -MaxEvents 50

```powershell
Get-WinEvent -LogName System | Where-Object {$_.Id -eq 6008 -or $_.Id -eq 41} | Select-Object TimeCreated, Id, Message | Format-List
```

```powershell
Get-WinEvent -LogName System | Where-Object {$_.Id -eq 6008 -or $_.Id -eq 41} | Select-Object TimeCreated, Id, Message | Out-File event-export.txt
```

```powershell
Get-Content event-export.txt
```

Expected output includes: every Event ID 41 and 6008 in the System log, written to event-export.txt and displayed by Get-Content.

Status: Complete. The export holds 12 Kernel-Power 41 and EventLog 6008 pairs from 2/1/2026 through 9/14/2026, plus Hyper-V-Hypervisor events that also use ID 41. Screenshots: screenshots/05-get-winevent-filter.png, screenshots/06-event-export-get-content.png

## Step 6: Build the Event Timeline

I built event-timeline.md from the Format-List output and Event Viewer. It lists the 12 Kernel-Power 41 and EventLog 6008 pairs with timestamp, event ID, source, level, and meaning, followed by a Timeline Summary. The Hyper-V-Hypervisor ID 41 events were left out because they come from a different source and do not record shutdowns.

Status: Complete. See event-timeline.md

## Root-Cause Analysis

### Hypothesis

Evidence clearly shows the system was either turned off or rebooted, and that it did so unexpectedly, and not as part of a scheduled Windows update, based on the number of unclean shutdowns indicated by the multiple occurrences of Kernel-Power 41 events at a Critical Level.

### Additional supporting evidence

Those Kernel-Power 41 events are 12 System log entries at a Critical Level, each followed by an EventLog entry that showed a 6008 Error occurred immediately upon the next startup. The last entry listed for this pairing indicated an unexpected shutdown at 3:40pm on September 14th 2026, and every other entry in the list follows this exact pattern. This suggests that whatever caused the shutdown has happened repeatedly.

### Considerations regarding alternative possible causes

It's likely that the above-described shutdown was unplanned due to the nature of a planned restart, such as for Windows updates, which will shut down cleanly and therefore would not result in a Kernel-Power 41 and 6008 pair. It is also impossible to determine whether a system crash may have been experienced solely based on the messages of the Kernel-Power 41 and 6008 events. In order to do so, you would need to examine the BugcheckCode associated with each Kernel-Power 41 event. If a nonzero code is found, then a system crash did occur. And in order to further diagnose what led to that system crash, you would need to analyze the system crash dump.

### Escalation

If any of the Kernel-Power 41 events show a nonzero BugcheckCode, the issue should be escalated to a senior technician as crash dump analysis is required. If unclean shutdowns continue even after verifying the power source, escalate to your vendor as they may need to provide assistance in identifying a potential hardware failure such as the power supply or memory.

## Troubleshooting Narrative

The customer reported a problem with the checkout station ACME-W11-POS01, and the manager of the branch said the computer had rebooted twice overnight when no one was using the computer. The manager wanted a report documenting a reason for a possible insurance audit within 48 hours.
The manager sent us an Event ID 6008 unexpected shutdown entry in the System Log.
In investigating this issue, I performed these actions in this order:
1. I restored the VM to the clean baseline W01_CleanBaseline using Proxmox.
2. In Event Viewer I opened the System log and filtered all Critical and Error events from the past seven days. When I did this, there were none. Therefore, I changed my search criteria back to any time frame and located Kernel-Power 41 & 6008 entries. Next, I used Get-WinEvent as described in the guide. However, since the guide's command included -MaxEvents 50, only the 50 most recent events were searched. So I deleted -MaxEvents 50, saved the results to event-export.txt, verified that the data in the file was correct by running Get-Content, and built the timeline based upon the content in the file.

When I viewed the event logs, I saw twelve Kernel-Power 41 events recorded at the Critical level. They were immediately followed by an EventLog 6008 Error at the next boot. Each Kernel-Power 41 indicates that the system restarted before closing normally. Each of those was followed by an EventLog 6008 entry, which indicated that the system was shut down without completing its shutdown. There were also Hyper-V-Hypervisor events that have an ID of 41, however those are generated from a completely different source and indicate nothing regarding a shutdown.

My conclusion is that the system was either turned off or reset without properly shutting down Windows. This matches with being physically disconnected, a power loss, or having been forcibly disconnected, such as hitting the power button. All twelve were in the same sequence, and the last of these, a shutdown at 3:40:48 pm on 9/14/2026, was followed by a Kernel-Power 41 at 5:03:27 pm and a subsequent 6008 at 5:04:35 pm.

I considered two other possible explanations for what happened to cause these shutdowns. A planned restart due to Windows update is not likely since a planned restart will always clean up before restarting and will not generate both Kernel-Power 41 and 6008. It is hard to say whether we can rule out a crash. Although there is no indication in the event message as to whether Windows crashed into a Stop Error, we need to know the bug check code for each of the Kernel-Power 41 events to confirm it.

If I see any of the Kernel-Power 41 events contain any bug check codes other than zero, I would escalate this case to our senior technician, since any non-zero bug check code would require dump analysis. If the system continues to experience unclean shutdowns after checking the power source, I would escalate to our vendor, since an ongoing failure to properly shut down may be indicative of some type of hardware failure such as bad power supplies or RAM.

## Troubleshooting Notes

### Issue 1

Incorrect setting: Event Viewer Filter Current Log with Logged set to Last 7 days, as the assignment specifies.

Root Cause: The newest events in the restored System log are from 9/21/2026, so nothing fell inside the last 7 days.

Resolution: Changed Logged to Any time and kept Critical and Error checked.

Result: The filter returned 242 Critical and Error events, including the Kernel-Power 41 and EventLog 6008 entries.

### Issue 2

Incorrect command:

```powershell
Get-WinEvent -LogName System -MaxEvents 50 | Where-Object {$_.Id -eq 6008 -or $_.Id -eq 41} | Select-Object TimeCreated, Id, Message | Out-File event-export.txt
```

Root Cause: -MaxEvents 50 reads only the 50 newest System events before Where-Object filters them. None of those 50 were Event ID 41 or 6008, so the output and event-export.txt were empty.

Resolution: Removed -MaxEvents 50 and reran the filter, export, and Get-Content commands.

Result: event-export.txt held every Event ID 41 and 6008 in the System log, back to 2/1/2026.

### Issue 3

Command: the guide's Out-File export, run as written.

Root Cause: Out-File writes the results as a table, and the narrow Id column cuts Event ID 6008 down to 08. Long messages are also cut off and end in three dots.

Resolution: Kept the export command as the assignment and guide give it. The full event IDs and messages are in the Format-List output in screenshots/05-get-winevent-filter.png, which the timeline was built from.

Result: The 6008 rows in event-export.txt are identified by their message, The previous system shutdown at..., and the timeline shows the full IDs.

### Issue 4

Incorrect command:

```powershell
.\collect-evidence.ps1
```

Root Cause: The downloaded file was named collect-evidence .ps1, with a space before the extension, so PowerShell could not find collect-evidence.ps1. After the rename, the script still failed with ParserError UnexpectedToken, because it is saved as UTF-8 without a byte order mark. Windows PowerShell 5.1 reads BOM-less scripts as Windows-1252, so the em dash on line 12 decoded into characters that include a right double quotation mark, which ended the string early.

Resolution: Renamed the file to collect-evidence.ps1, unblocked it, and re-saved it as UTF-8 with a byte order mark without changing its contents.

```powershell
Unblock-File .\collect-evidence.ps1
```

```powershell
$c = Get-Content .\collect-evidence.ps1 -Raw -Encoding UTF8
```

```powershell
Set-Content .\collect-evidence.ps1 -Value $c -Encoding UTF8
```

Result: The script ran, and evidence-report.txt shows event-export.txt, event-timeline.md, and README.md as FOUND.

## What I Can Do Now

I used Event Viewer filters and Get-WinEvent to trace twelve unclean shutdowns through their Kernel-Power 41 and 6008 events, then turned that record into a timeline and root-cause analysis that a branch manager could hand to an insurance auditor as documented proof.

## AI Use Statement

AI use for this assignment is documented in ai-disclosure.md and ai-validation.md.

## Files In This Folder

- README.md
- event-export.txt
- event-timeline.md
- ai-disclosure.md
- ai-validation.md
- collect-evidence.ps1
- evidence-report.txt
- screenshots/01-snapshot-baseline-selected.png
- screenshots/02-desktop-after-boot.png
- screenshots/03-event-viewer-system-log.png
- screenshots/04-filtered-kernel-power-41-details.png
- screenshots/05-get-winevent-filter.png
- screenshots/06-event-export-get-content.png