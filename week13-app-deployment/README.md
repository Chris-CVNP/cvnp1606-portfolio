# CVNP1606 Week 13: Intune Application Lifecycle

**Ticket:** CVNP1606-W13-013 | **Author:** C A

---

## Objectives

- Restore the lab VM to a clean baseline before starting work
- Analyze a Win32 app in Intune, including its install command, detection rule, and assignment
- Complete an app deployment worksheet covering source type, install logic, detection rule, target group, assignment type, and failure behavior
- Summarize how Microsoft 365 Apps update channels and configuration are governed in Intune
- Write a change-control note covering scope, pilot group, success criteria, and rollback
- Generate and commit an evidence report showing all required files FOUND

---

## Tools Used

- Proxmox VE web interface, VM 101 Snapshots panel, Rollback
- Microsoft Intune admin center, Apps > Windows apps, instructor Week 13 evidence set
- IntuneWinAppUtil.exe, Microsoft Win32 Content Prep Tool, instructor evidence
- PowerShell: `.\collect-evidence.ps1`

---

## Configuration

### Ticket Information

- **Ticket ID:** CVNP1606-W13-013
- **Submitted by:** Riley Chen, ACME IT Manager
- **Affected system:** ACME Managed Endpoint Fleet / Intune Tenant
- **Business impact:** High. Inconsistent app deployment is generating support tickets and compliance gaps across the fleet.
- **Initial evidence:** App not visible in Company Portal on Emily's device. No detection rule documented. No change-control record for the last app deployment.
- **Required outcome:** App assigned with a correct detection rule, deployment worksheet completed, Microsoft 365 Apps governance documented, and a change-control note covering the pilot group, success criteria, and rollback procedure.

### Scenario Summary

Riley flagged that ACME software is being installed inconsistently across managed endpoints, which has created a surge of app missing tickets, and Emily reported that her device is missing a department application her whole team should have. As Alex, I analyzed a Win32 app deployment in Intune, documented its install command, detection rule, and assignment in a deployment worksheet, summarized how Microsoft 365 Apps updates and configuration are governed, and wrote a change-control note for Maya to review before any production push. I do not have an Intune tenant of my own, so the Intune evidence comes from the instructor's Week 13 evidence set for the app ACME-Notepad++-ARM64, Notepad++ 8.9.8.1 for ARM64, assigned as Required to ACME-Pilot-Devices.

---

## Step 1: Restore the Clean Baseline

```text
Proxmox VE > VM 101 > Snapshots > select Baseline > Rollback > Yes
Then: Console > sign in > confirm desktop loads cleanly
```

**What it does:** Returns VM 101 to its known good Baseline snapshot so the week starts from a clean state.

**Expected output includes:** The rollback task completes with no error, and the VM boots to a clean desktop.

**Status:** Complete. The first rollback attempt failed with a ZFS error, documented in Troubleshooting Notes Issue 1. After the three newer snapshots were removed, the rollback to Baseline succeeded and the desktop loaded cleanly.
Evidence: screenshots/snapshot-manager-baseline.png, screenshots/desktop-after-boot.png

---

## Step 2: Analyze the Win32 App in Intune

```text
Intune admin center > Apps > Windows apps > ACME-Notepad++-ARM64 > Properties
Review: App information, Program, Requirements, Detection rules, Assignments
```

**What it does:** Shows how the app is packaged, installed, detected, and assigned.

**Expected output includes:**
- Source type: Win32 .intunewin, packaged from npp.8.9.8.1.Installer.arm64.exe with IntuneWinAppUtil
- Install command: npp.8.9.8.1.Installer.arm64.exe /S, install behavior System
- Detection rule: File, path C:\Program Files\Notepad++, file notepad++.exe, method File or folder exists, associated with a 32-bit app on 64-bit clients set to No
- Assignment: Required, included group ACME-Pilot-Devices

**Status:** Complete, using the instructor's Week 13 evidence set. The detection rule correctly identifies the app when it is present: the post-deployment local check on CVNP1601_SWOS returned True for C:\Program Files\Notepad++\notepad++.exe at file version 8.9.8.1.
Evidence: screenshots/app-created-overview.png, screenshots/app-upload-finished.png, screenshots/app-program.png, screenshots/app-requirements.png, screenshots/app-detection-requirements.png, screenshots/app-assignments.png, screenshots/app-empty-device-status.png, screenshots/app-device-status.png

---

## Step 3: Complete the App Deployment Worksheet

```text
File: app-deployment-worksheet.md
```

**What it does:** Records the seven required fields for the deployment: app name and version, source type, silent install switch, detection rule type and logic, target group, assignment type and why, and failure behavior.

**Expected output includes:** All seven fields filled in from the Intune evidence.

**Status:** Complete.

---

## Step 4: Write the Microsoft 365 Apps Configuration Summary

```text
File: m365-apps-config-summary.md
Reference: Intune > Apps > Windows apps > Add > Microsoft 365 Apps for Windows 10 and later
```

**What it does:** Recommends an update channel for ACME and explains update governance, app configuration policies, and first troubleshooting checks.

**Expected output includes:** A plain professional summary under 300 words that addresses all four required topics, with Monthly Enterprise Channel recommended.

**Status:** Complete.
Evidence: screenshots/m365-apps-selection.png, screenshots/m365-apps-channel.png, screenshots/m365-apps-channel-choices.png

---

## Step 5: Write the Change-Control Note

```text
File: change-control-note.md
```

**What it does:** Documents the change for Maya's review before production: what is changing, which group is targeted, the pilot approach, success criteria, and the rollback procedure.

**Expected output includes:** A pilot on ACME-Pilot-Devices, success defined as the detection rule passing with no Company Portal errors, and a rollback that removes the Required assignment and adds the group under Uninstall.

**Status:** Complete.

---

## Step 6: Run the Evidence Collection Script

```powershell
.\collect-evidence.ps1
```

**What it does:** Checks the week folder for every required deliverable and writes the results to evidence-report.txt.

**Expected output includes:** evidence-report.txt with every required file showing FOUND and zero NOT FOUND lines.

**Status:** Complete. Run as Administrator from the week13-app-deployment folder after all deliverables were in place. evidence-report.txt is committed.

---

## Troubleshooting Notes

### Issue 1: Snapshot rollback failed on ZFS storage

**Incorrect command:**

```text
Proxmox VE > VM 101 > Snapshots > select Baseline > Rollback
```

**Root Cause:** VM 101's disks are on local-zfs. ZFS can only roll back to the most recent snapshot, and three newer snapshots existed after Baseline. Proxmox returned: can't rollback, 'Baseline' is not most recent snapshot on 'local-zfs:vm-101-disk-2'.

**Resolution:** Removed the three newer snapshots, from newest to oldest, then ran Rollback on Baseline again.

**Result:** The rollback completed, and VM 101 booted to the Baseline state from 2026-09-29 with a clean desktop.

### Issue 2: Baseline snapshot used instead of W01_CleanBaseline

**Incorrect command:**

```text
Revert to W01_CleanBaseline (assignment and guide wording, VMware and VirtualBox steps)
```

**Root Cause:** The lab runs on Proxmox VE, which the instructor allows as a substitute for VMware. W01_CleanBaseline is an older snapshot in the VM 101 chain, and Baseline is the VM's later known good baseline, which includes the clipboard fix.

**Resolution:** Rolled back to Baseline through the Proxmox Snapshots panel instead of the VMware or VirtualBox snapshot manager.

**Result:** The VM started the week from a known good, clean state.

### Issue 3: No Intune tenant available

**Incorrect command:**

```text
Intune admin center > Apps > Windows apps (no tenant access)
```

**Root Cause:** My Microsoft Entra tenant signup was denied at verification in Week 10, so I have no Intune tenant of my own.

**Resolution:** Used the instructor's Week 13 evidence set for the Intune portions: app properties, detection rule, assignments, device install status, local state checks, and the Microsoft 365 Apps channel selection.

**Result:** All portal-based evidence requirements are covered with the instructor-provided captures. The written deliverables are based on that evidence.

---

## Troubleshooting Narrative

**What went wrong, or what could realistically have gone wrong?**
The rollback of VM 101 to the Baseline snapshot failed with the error can't rollback, 'Baseline' is not most recent snapshot on 'local-zfs:vm-101-disk-2'.

**What evidence did you check first?**
I checked the error message and the Snapshots panel, which showed three newer snapshots below Baseline in the chain, and I confirmed the VM disks were on local-zfs storage.

**What did you try?**
I first tried the rollback directly on Baseline from the Snapshots panel, which is the step that failed.

**What fixed it, or what would you try next?**
Removing the three newer snapshots from newest to oldest fixed it, because ZFS only allows a rollback to the most recent snapshot.

**How did you verify the result?**
I ran the rollback on Baseline again, confirmed the task completed with no error, started the VM, and confirmed the desktop loaded cleanly.

**What was the support or deployment impact of the issue or fix?**
The fix permanently removed three restore points and the VM's previous state, so on ZFS storage a technician needs to plan the snapshot chain before relying on rollback to an older snapshot.

---

## What I Can Do Now

I analyzed a Win32 application deployment in Intune with a verified file detection rule, documented the rollout plan in a change-control note, and summarized how Microsoft 365 Apps update governance should be set up so ACME stops getting app missing tickets.

---

## AI Use Statement

I used Claude to help draft the worksheet, the Microsoft 365 Apps summary, the change-control note, and this README from the instructor's Week 13 evidence set and my own lab work. I rewrote the drafts in my own words and checked the technical details against the evidence files and Microsoft documentation. Details are in ai-disclosure.md.

---

## Files In This Folder

- README.md
- app-deployment-worksheet.md
- m365-apps-config-summary.md
- change-control-note.md
- ai-disclosure.md
- collect-evidence.ps1
- evidence-report.txt
- screenshots/snapshot-manager-baseline.png
- screenshots/desktop-after-boot.png
- screenshots/app-created-overview.png
- screenshots/app-upload-finished.png
- screenshots/app-program.png
- screenshots/app-requirements.png
- screenshots/app-detection-requirements.png
- screenshots/app-assignments.png
- screenshots/app-empty-device-status.png
- screenshots/app-device-status.png
- screenshots/m365-apps-selection.png
- screenshots/m365-apps-channel.png
- screenshots/m365-apps-channel-choices.png