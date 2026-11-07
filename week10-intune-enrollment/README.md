# Week 10: Intune and Entra Onboarding

Author: C A
Ticket: CVNP1606-W10-010

## Evidence Source

I could not get live Intune access because Microsoft denied my verification when I tried to set up my own tenant. Following the assignment's fallback option, I contacted the instructor and used the instructor-provided Week 10 enrollment evidence set. All analysis in this folder is based on that evidence set from the ATCC tenant, not on a tenant or VM I provisioned myself.

## Deliverables

join-state-evidence.md: the five dsregcmd /status fields with plain-language explanations
tenant-setup-notes.md: tenant name, trial expiry, groups, and configuration decisions
enrollment-diagnosis.md: state, root cause, remediation, and verification for the failed enrollment
pilot-group-design.md: four-wave rollout plan for all 50 ACME endpoints
ai-disclosure.md: AI tool use statement
evidence-report.txt: output of collect-evidence.ps1

## Evidence Files

groups-membership.jpg: ACME-All-Devices with Dynamic membership and ACME-Pilot-Devices with Assigned membership
all-devices-rule.jpg: ACME-All-Devices dynamic rule, deviceOSType Equals Windows
dsregcmd-status.txt: dsregcmd /status output for CVNP1601_SWOS
intune-managed-device.jpg: Intune All devices entry for CVNP1601_SWOS showing device name, Managed by Intune, and Last check-in
tenant-license.jpg: Microsoft Intune Plan 1 Trial license page
automatic-enrollment-license-limit.jpg: Intune notice that automatic MDM enrollment is available only for Microsoft Entra ID Premium subscribers

The Settings, Accounts, Access work or school screenshot was not included in the instructor evidence set, so it is not part of this submission.

## What I Can Do Now

Using an instructor-provided evidence set, I analyzed a Windows device's Entra join and Intune management state with dsregcmd and the Intune admin center, diagnosed a blank MdmUrl enrollment failure, and designed a four-wave pilot rollout to help ACME move 50 endpoints to cloud-first management.

## Troubleshooting Narrative

1. What was the most significant challenge you encountered during tenant setup or enrollment?
The most significant challenge was that Microsoft denied my verification when I tried to set up my own tenant, so I could not create a tenant or enroll my own VM. I used the instructor-provided Week 10 evidence set instead, as the assignment allows.

2. What evidence did you check first when something did not work as expected, and why?
I checked the dsregcmd /status capture first because it shows the device's own view of its join and MDM state. It showed AzureAdJoined YES but a blank MdmUrl, which meant the Entra join worked but the device did not record an Intune enrollment.

3. What did you try to resolve the issue?
I contacted the instructor, told him my verification was denied, and he provided the Week 10 evidence set screenshots for the assignment. I then compared the dsregcmd capture against the Intune device list, the license page, and the automatic enrollment notice in the evidence set. The Intune device list showed CVNP1601_SWOS as Managed by Intune, the license page showed only an Intune Plan 1 Trial, and the notice said automatic MDM enrollment is available only for Microsoft Entra ID Premium subscribers.

4. What resolved the issue, or what would you try next if you could not resolve it in the lab session?
Using the instructor evidence set resolved the tenant access problem. For the blank MdmUrl, I would next check the MDM user scope in the Intune admin center under Devices, Device onboarding, Enrollment, Windows tab, Automatic Enrollment, confirm the tenant has a Microsoft Entra ID P1 or P2 subscription and the user has an Intune license, and then run dsregcmd /status again.

5. How did you verify that enrollment succeeded from both the endpoint side and the portal side?
On the endpoint side, the dsregcmd capture shows AzureAdJoined YES, DomainJoined NO, and TenantName ATCC, but MdmUrl is blank. On the portal side, the Intune device list shows CVNP1601_SWOS as Managed by Intune, Compliant, with a Last check-in of 11/02/2026 08:57 PM and a join type of Microsoft Entra joined. The two sides do not fully agree, so the endpoint side does not confirm the Intune enrollment that the portal shows.

6. What would be the business impact on ACME if the pilot enrollment process had a misconfiguration that was not caught before full rollout?
If a misconfiguration such as a missing MDM user scope reached all 50 endpoints, every device could join Entra ID but never be managed by Intune, so no compliance or security policies would reach them. ACME would have 50 unmanaged devices with access to company resources, and IT would have to fix and re-verify each one, which costs time and delays the cloud-first rollout.

## AI Use

AI tools were used during this lab. See ai-disclosure.md for details.