Profile Evidence
Evidence Source: Instructor provided evidence from the Week 12 ATCC Tenant.
What the Profile Enforces and the Business Need
This profile, ACME-Display-Timeout-Policy, will turn the display off after a period of time of 900 seconds, 15 minutes, as long as the device is plugged into power. This prevents an unattended screen from displaying company data to people who may be passing by. Additionally, this helps reduce energy usage.
Why the Scope is Correctly Targeted and Why It Is Appropriate
This profile is targeted at the ACME-Intune-Pilot group. The assignment has an Active status with no filter applied. There is only one member in that group: CVNP1601_SWOS. Therefore, the profile settings are being tested on just one pilot device before they reach the remaining devices in the ACME fleet.
Verification Methodology
Device Status within the profile indicates that there has been 1 Succeeded and 0 Error or Conflict. CVNP1601_SWOS checked in successfully on November 03, 2026 at 15:55. On the device, the Power Policy Registry Path also shows ACSettingIndex = 900. This supports the fact that the correct value was delivered to the endpoint. The per-device Device configuration page is not present in the evidence package.
Support Impact if Missing or Misconfigured
If the profile is missing, screens stay on and expose data at unattended desks. If the timeout is set too short, users lose their screen while working and call the helpdesk.