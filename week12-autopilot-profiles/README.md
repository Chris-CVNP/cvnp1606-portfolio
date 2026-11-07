# Week 12: Autopilot, Provisioning, and Configuration Profiles

Author: C A
Ticket: CVNP1606-W12-012

## Evidence Source

I do not have my own working Intune tenant because Microsoft denied my verification when I tried to set one up. Following the help guide's fallback, this submission uses the instructor-provided Week 12 evidence set from the ATCC tenant. My written analysis is based on those captures, not on a tenant or VM I configured myself.

## Scenario Summary

Riley Chen requested a zero-touch deployment process for ACME's next new-hire cohort, so laptops can ship directly to employees with minimal technician involvement. The ticket required selecting the correct Windows Autopilot deployment mode for four ACME scenarios, creating a Windows configuration profile with verified group targeting, and documenting a repeatable deployment process that another technician could follow without follow-up questions.

## Tools Used

Microsoft Intune admin center, reviewed through the instructor evidence set
Microsoft Entra admin center, reviewed through the instructor evidence set
Windows Autopilot and the Enrollment Status Page, reviewed through the instructor evidence set
Microsoft Learn documentation for Autopilot deployment modes, hardware hash registration, and portal navigation

## Steps Taken

1. Reviewed the three Autopilot deployment modes and selected the correct mode for each of the four ACME scenarios in deployment-decision-tree.md.
2. Analyzed ACME-Display-Timeout-Policy, its assignment to ACME-Intune-Pilot, and its device status and local registry result in profile-evidence.md.
3. Reviewed the ACME Standard User Autopilot profile and the ACME-Pilot-ESP Enrollment Status Page settings and assignments.
4. Wrote repeatable-deployment-note.md as a 12-step procedure from hardware hash collection through first-boot verification.
5. Ran collect-evidence.ps1 and committed evidence-report.txt.

## Deliverables

deployment-decision-tree.md: mode selection, justification, and a non-working alternative for all four ACME scenarios
profile-evidence.md: what the profile enforces, targeting, verification, and support impact
repeatable-deployment-note.md: numbered deployment procedure
ai-validation.md: AI tool use statement
evidence-report.txt: output of collect-evidence.ps1

## Evidence Files

Task 3, configuration profile:
profile-settings.jpg: ACME-Display-Timeout-Policy with Turn off the display, plugged in, set to Enabled and the display timeout set to 900 seconds
profile-assignment.jpg: the profile assigned to ACME-Intune-Pilot with status Active and no filter
pilot-device-member.png: CVNP1601_SWOS as the only member of ACME-Intune-Pilot

Task 4, profile verification:
device-profile-status.png: profile device status showing 1 Succeeded and CVNP1601_SWOS with a Check-in status of Success
profile-local-state.txt: the device's power policy registry path showing ACSettingIndex 900

Autopilot and Enrollment Status Page:
autopilot-profile.png: ACME Standard User set to User-Driven and Microsoft Entra joined, assigned to ACME-Autopilot
autopilot-profile-unassigned.jpg: the same profile showing no included groups
enrollment-status-page.png: ACME-Pilot-ESP settings with Block device use until all apps and profiles are installed set to Yes
enrollment-status-page-assignment.png: ACME-Pilot-ESP assigned to ACME-Autopilot

## Evidence Not Available

Task 1: Snapshot Manager with W01_CleanBaseline restored and the desktop after boot. These apply to preparing a VM for live enrollment, which I could not do.
Per-device verification: the Intune page under Devices, All devices, CVNP1601_SWOS, Device configuration. The evidence set shows the profile's device status view instead.
Hardware hash upload and first boot: no device in the evidence set was registered with Autopilot or run through the out-of-box experience.

## What I Can Do Now

Using an instructor-provided evidence set, I selected and justified the correct Windows Autopilot deployment mode for four ACME scenarios, analyzed a targeted Intune configuration profile, and wrote a repeatable deployment note that a Tier 1 technician could follow to provision ACME's new-hire laptops without asking follow-up questions.

## Troubleshooting Narrative

1. What went wrong, or what could realistically have gone wrong?
I wasn't able to access my own Intune tenant, so I used the instructor's provided evidence package. Two different Autopilot captures for the ACME Standard User show differing information; one capture shows it is assigned to ACME-Autopilot, but the second shows that it does not include any groups. If the Autopilot profile is unassigned when a new laptop ships, the laptop will not receive the Autopilot profile. Therefore, a new employee will be required to go through a standard setup rather than receiving the managed ACME deployment.

2. What evidence did you check first?
Initially I reviewed the assignments part of both Autopilot profile captures, because the Autopilot profile can only reach a device via an assigned group. After that, I reviewed the Enrollment Status Page capture. This page was also assigned to ACME-Autopilot. The description of this page indicates that the ACME-Autopilot group is empty.

3. What did you try?
A comparison of the Autopilot profile capture, Enrollment Status Page capture and configuration profile capture was performed. The purpose of the comparison was to determine which groups each item targeted. The configuration profile targets ACME-Intune-Pilot, which includes CVNP1601_SWOS. On the other hand, the Autopilot profile and Enrollment Status Page target ACME-Autopilot. However, there are no computers within this group.

4. What fixed it, or what would you try next?
Next, I would review ACME Standard User under Devices > Windows > Enrollment > Deployment Profiles. Once located, I would confirm whether ACME-Autopilot is listed within Included Groups with a status of Active. Following that, I would upload the computer's hardware hash into Windows Autopilot Devices. Next, I would add this computer to ACME-Autopilot. Finally, prior to sending the computer to a user, I would verify its Profile status shows Assigned within Windows Autopilot Devices.

5. How did you verify the result?
For the configuration profile, the profile's device status displayed 1 Succeeded with CVNP1601_SWOS reporting successfully into the system. Additionally, the computer's Power Policy Registry Path showed ACSettingIndex = 900. Unfortunately, due to lack of data within the evidence set, I was unable to verify that an Autopilot deployment had taken place. Furthermore, I was unable to validate that any computer within the evidence set had completed the out-of-box experience, OOBE.

6. What was the support or deployment impact of the issue or fix?
If an Autopilot profile is not assigned properly, the first day of employment for new employees will be delayed due to having to manually configure/fix each laptop to join and configure them in accordance with ACME's standards. Manually configuring each laptop will delay the start of work for new hires. By verifying the Autopilot profile assignment and Profile status prior to shipping these items, this potential delay will be avoided. Also, since we verified the display timeout profile was applied to pilot devices, all pilot devices will turn off their displays at a consistent time.

## AI Use

AI tools were used during this lab. See ai-validation.md for details.