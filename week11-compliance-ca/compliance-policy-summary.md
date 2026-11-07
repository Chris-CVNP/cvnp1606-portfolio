Compliance Policy Summary

Source: instructor-provided Week 11 evidence set from the ATCC tenant. I do not have my own working Intune tenant, so I could not create this policy or capture these results myself.

Policy name: ACME-Windows-Baseline-Compliance
Platform: Windows 10 and later
Assigned to: ACME-Pilot-Devices, status Active
Action for noncompliance: Mark device noncompliant, Immediately
Test device: CVNP1601_SWOS, the only member of ACME-Pilot-Devices

Setting: BitLocker
Location in policy: Device Health
Required value: Required
Observed value: not shown in the evidence set
Result: Fail, 1 noncompliant device

Setting: Minimum OS version
Location in policy: Device Properties
Required value: 10.0.19041
Observed value: 10.0.26200.9711, from the Week 10 Intune device list
Result: Pass, 1 compliant device

Setting: Microsoft Defender Antimalware
Location in policy: System Security
Required value: Required
Observed value: not shown in the evidence set
Result: Pass, 1 compliant device

Overall device results
CVNP1601_SWOS is showing a Not compliant rating for the ACME-Windows-Baseline-Compliance and a Compliant rating for the Default Device Compliance Policy, both were last contacted at 11/02/2026 09:17 PM. BitLocker was the only failing setting; therefore, this is the reason the device is not compliant.

Failure Reason
There is no per-device detail view included within the evidence set; therefore, there is no failure reason shown for BitLocker. The per-setting report only counts devices by result; therefore, it will indicate that BitLocker failed to pass but not why. BitLocker may either be off, or the device may not have reported its state to Intune yet; since Intune checks the Require BitLocker setting through device health attestation, and the latter only measures BitLocker's state during boot-up time.

Evidence Discrepancies
On the policy's Monitor page Device Status is listed as 0 compliant, 0 non-compliant and 0 total. Both the Per-setting Status View and the device's compliance page show a non-compliant device. Therefore, these views are not consistent.