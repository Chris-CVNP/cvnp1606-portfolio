Join State Evidence

Source: instructor-provided Week 10 evidence set, dsregcmd /status output for device CVNP1601_SWOS, captured 2026-11-05.

AzureAdJoined: YES
The device is joined to Microsoft Entra ID at the operating system level, so its device identity belongs to the organization.

WorkplaceJoined: NO
No Entra registered work account was added to the device, which means it is not on the BYOD registration path.

MDMUrl: blank
The device has no MDM enrollment address recorded, which means either automatic MDM enrollment is not configured in the tenant or the user is not in its scope.

TenantName: ATCC
The device is joined to the ATCC tenant, which confirms which organization's directory it belongs to.

DeviceId: redacted in the instructor evidence set
This is the unique ID Entra ID assigns the device in the tenant, and a technician uses it to match the endpoint to its device record in the portal.