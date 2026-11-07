Tenant Setup Notes

Source: instructor-provided Week 10 evidence set. I could not get my own tenant, so this tenant was set up by the instructor and I am documenting what the captures show.

Tenant name: ATCC, as shown in the upper right corner of the Intune admin center.

Trial expiry: instructor-provided tenant. The Billing, Your products page shows one product, Microsoft Intune Plan 1 Trial, with 25 licenses purchased, 1 assigned, 24 available, status Active, and an expiration date of 12/2/2026.

Groups created:

ACME-Pilot-Devices
Group type: Security
Membership type: Assigned
Purpose: Holds the devices in the pilot wave. Assigned membership means a technician adds each device by hand, so only the devices chosen for testing receive pilot policies.

ACME-All-Devices
Group type: Security
Membership Type: Dynamic
Dynamic Rule: deviceOSType = Windows; Rule Syntax: device.deviceOSType -eq Windows
Purpose: This will hold all of the Windows Devices within the Tenant. Since the group uses dynamic membership, Entra ID will automatically add each Windows device that enrolls into the group. Therefore, the group will capture all Windows devices when the Full Rollout is complete.

Configuration Decisions:
The Pilot Group uses assigned membership, since the pilot needs to be able to tightly manage what devices are added first. If the Pilot Group used a dynamic rule with an option such as deviceOSType it would pull in all of the windows devices at once and that would defeat the purpose of having a small test group.
The All Devices Group uses dynamic membership because 50 Endpoints is too many to manually enter, and using a rule based upon deviceOSType keeps the group up-to-date as new devices continue to enroll.
When logged into the Admin Center of Intune, you see a message saying Automatic MDM enrollment is available only for Microsoft Entra ID Premium subscribers, and since the tenant's only License is the Intune Plan 1 Trial, Automatic MDM Enrollment is Not Available In This Tenant. This corresponds with the blank value for MDMUrl in the dsregcmd Output.