# Week 15: Cloud Updates, Remote Actions, and Reporting
Ticket CVNP1606-W15-015

## Objectives
- Document a pilot and production update ring strategy in Intune
- Write a patch strategy memo with a rollback path, monitoring signal, and escalation trigger
- Define authorization levels for six Intune remote actions
- Interpret the Windows quality update reports and make a rollout recommendation

## Tools Used
- Intune admin center: Devices > By platform > Windows > Manage updates > Windows updates > Update rings tab
- Intune admin center: Reports > Windows updates
- collect-evidence.ps1
- Instructor-provided screenshots and exported report

## Configuration

### Ticket Information
- Ticket ID: CVNP1606-W15-015
- Submitted by: Riley Chen, ACME IT Manager
- Affected system: ACME Branch Device Fleet / Intune Update Policies
- Business impact: High
- Initial evidence: No update ring structure documented. Remote action usage log incomplete. Rollout health report not reviewed after last patch cycle. Branch devices averaging 45+ days behind on quality updates.

### Scenario Summary
ACME branch devices missed the last patch cycle, and Riley needs a controlled rollout strategy before the next Patch Tuesday. I documented the pilot and production update rings, wrote a patch strategy memo with a continuity and recovery proof for Maya to review, set authorization levels for the six Intune remote actions, and used the Windows quality update reports to write a rollout health summary with a recommendation.

## Step 1: Restore the clean baseline
Status: Not performed. See Troubleshooting Notes, Issue 1.

## Step 2: Document pilot and production update ring settings in Intune
Location: Intune admin center > Devices > By platform > Windows > Manage updates > Windows updates > Update rings tab

There are two update rings identified with the project. There is the pilot version of an update ring called ACME-Ring-1-Pilot and there is also the standard version of an update ring called ACME-Ring-2-Standard. These are both Update ring for Windows 10 and later policies from within the Microsoft Intune admin center at Devices > By platform > Windows > Manage updates > Windows updates > Update rings tab.

ACME-Ring-1-Pilot has Quality Deferrals set to 0 days and Feature Deferrals set to 7 days. For Quality updates the Deadline is set to 2 Days; for Feature updates the Deadline is set to 7 Days. The Restart Grace Period is set to 1 Day. This update ring is assigned to the ACME-Pilot-Devices group.

ACME-Ring-2-Standard is the Production Ring. The Quality Deferrals are set to 7 days; the Feature Deferrals are set to 30 days. For Quality updates the Deadline is set to 3 Days; for Feature updates the Deadline is set to 14 Days. The Restart Grace Period is set to 2 Days. ACME-Ring-2-Standard, the production ring, is assigned to the ACME-Standard Group, but because ACME-Pilot-Devices was specifically excluded as part of that assignment, Pilot Devices will only be receiving one of these rings.

The Quality updates being available on the Pilot Ring as soon as those Quality updates are released, and the Production Ring waiting 7 days after the Quality updates have been released to get them, provides a window of time, 7 days, to test the Quality updates on the Pilot Device before the rest of your Branch Fleet receives those same Quality updates. Those details were displayed in screenshot images provided by the Instructor, screenshots 01 through 06.

Expected output includes:
- ACME-Ring-1-Pilot: quality deferral 0 days, feature deferral 7 days, quality deadline 2 days, feature deadline 7 days, grace period 1 day, assigned to ACME-Pilot-Devices
- ACME-Ring-2-Standard: quality deferral 7 days, feature deferral 30 days, quality deadline 3 days, feature deadline 14 days, grace period 2 days, assigned to ACME-Standard with ACME-Pilot-Devices excluded

Evidence:
- screenshots/01-pilot-ring-settings.png
- screenshots/02-pilot-ring-deadlines.png
- screenshots/03-pilot-ring-assignment.png
- screenshots/04-production-ring-settings.png
- screenshots/05-production-ring-deadlines.png
- screenshots/06-production-ring-assignment.png

Status: Complete

## Step 3: Write patch-strategy-memo.md
Covers ring rationale, deferral value choices, monitoring strategy, and the continuity and recovery proof with rollback path, monitoring signal, and escalation trigger.

Status: Complete

## Step 4: Write remote-actions-checklist.md
Covers Sync, Restart, Remote lock, Wipe, Retire, and Fresh Start with what each action does, who is authorized to trigger it, whether it is reversible, and what must be recorded in the support ticket.

Status: Complete

## Step 5: Write rollout-health-summary.md
Location: Intune admin center > Reports > Windows updates

Expected output includes:
- Devices current: 1 of 2, CVNP1601_SWOS on 2026-10 B
- Devices pending: 1 of 2, CVNP1606-LAB on 2026-08 B
- Devices with errors: 0
- Recommendation: Investigate a specific device, CVNP1606-LAB

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
Resolution: I chose not to roll back the VM.
Result: Task 1 screenshots are not included.

### Issue 2
Task: Document the update rings and review the update compliance report in the Intune admin center.
Root Cause: I do not have access to an Intune tenant.
Resolution: I used the instructor-provided screenshots, saved ring properties, and exported Windows quality update report.
Result: All ring settings and device counts in this folder come from the instructor-provided evidence.

## Troubleshooting Narrative

What went wrong, or what could realistically have gone wrong?
The lab device, CVNP1606-LAB, is two months behind on security updates. The CVNP1606-LAB device is at the 2026-08 B level. The most recent month of security updates available from the report is 2026-10 B; therefore, the 2026-09 B level update, as well as the 2026-10 B level update, were not applied by this device.

What evidence did you check first?
First, I reviewed the Windows quality update distribution report to determine the date of the most recently released security update and how many computers were running the most recent level. Then I reviewed the Windows quality update device version report to identify the quality update level each computer had successfully installed and the date of its most recent check-in with Intune.

What did you try?
First, I determined whether each device was using the same version of Quality Update as 2026-10 B. CVNP1601_SWOS was at the correct version; however, CVNP1606-LAB was not. To eliminate the possibility that the lab device was offline and unable to check in, I reviewed its last check-in time, then I reviewed both reports for a failed status or error code.

What fixed it, or what would you try next?
Since CVNP1606-LAB last checked into Intune on November 5th, I know that the lab device is online but not updating. My next step will be to force a sync of CVNP1606-LAB through Intune and review the Windows update status in Intune for an error code. Also, until this is resolved, my plan is to hold the production ring and prevent any issues from spreading.

How did you verify the result?
To confirm accuracy, I confirmed all data shown in the report results against the report screenshots provided by the instructor and exported report. Once I perform a sync to update the lab device, I will generate another Windows quality update device version report and confirm that CVNP1606-LAB is reporting the correct version, 2026-10 B.

What was the update governance or continuity impact of the issue or fix?
Having one of your workstations missing 2 levels of security updates creates a security gap and conflicts with goals of reducing/eliminating backlogged patches on the branch fleet. Delaying the production ring until this issue can be identified prevents potential update problems from spreading throughout the branch fleet. Escalating to Maya provides a clear stop point should performing a sync on CVNP1606-LAB fail to resolve the issue.

## Portfolio Card

### What I Can Do Now
I documented a pilot and production update ring strategy in Intune for ACME branch devices, wrote a patch strategy memo with a rollback path, monitoring signal, and escalation trigger, set authorization levels for six remote actions, and used the Windows quality update reports to recommend investigating a lagging device before the production rollout.

## AI Use Statement
Tool: Claude by Anthropic.

What it helped with: It helped correct my written work and checked my documents against the assignment requirements.

How I verified its output against real evidence: I checked every ring setting against the instructor-provided update ring screenshots and saved ring properties, and every device count and update version in the rollout health summary against the instructor-provided Windows quality update reports and export.

## Files In This Folder
- README.md
- patch-strategy-memo.md
- remote-actions-checklist.md
- rollout-health-summary.md
- ai-disclosure.md
- collect-evidence.ps1
- evidence-report.txt
- screenshots/01-pilot-ring-settings.png
- screenshots/02-pilot-ring-deadlines.png
- screenshots/03-pilot-ring-assignment.png
- screenshots/04-production-ring-settings.png
- screenshots/05-production-ring-deadlines.png
- screenshots/06-production-ring-assignment.png