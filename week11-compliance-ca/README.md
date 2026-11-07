# Week 11: Compliance, Conditional Access, Hello, and LAPS

Author: C A
Ticket: CVNP1606-W11-011

## Evidence Source

I do not have my own working Intune tenant because Microsoft denied my verification when I tried to set one up. Following the help guide's fallback, this submission uses the instructor-provided Week 11 evidence set from the ATCC tenant. The grader should evaluate my written analysis rather than live screenshots, because I could not configure these policies or capture these results myself.

## Deliverables

compliance-policy-summary.md: each compliance setting, required value, observed value, and result
conditional-access-memo.md: Emily Park's experience, the technician response, and why report-only comes first
laps-hello-note.md: Section A on Windows Hello for Business and Section B on Windows LAPS
security-exception-template.md: blank security exception form with all six required fields
ai-disclosure.md: AI tool use statement
evidence-report.txt: output of collect-evidence.ps1

## Evidence Files

Step 2, compliance policy:
compliance-settings.jpg: ACME-Windows-Baseline-Compliance settings showing BitLocker Required, Minimum OS version 10.0.19041, and Microsoft Defender Antimalware Required
compliance-assignment.jpg: the policy assigned to ACME-Pilot-Devices with status Active
pilot-device-member.jpg: CVNP1601_SWOS as the only member of ACME-Pilot-Devices

Step 3, compliance report:
compliance-per-setting-status.png: per-setting status showing BitLocker with 1 noncompliant device and the other two settings with 1 compliant device each
compliance-per-setting-status.txt: instructor transcript of the per-setting status view
compliance-device-result.png: CVNP1601_SWOS showing Not compliant for ACME-Windows-Baseline-Compliance
compliance-empty-monitor.jpg: the policy's Monitor page showing Device status with 0 total, which does not match the per-setting view

Step 5, Hello and LAPS:
hello-policy.jpg: tenant-wide Windows Hello for Business setting, Enabled with TPM Required
laps-policy.jpg: ACME-LAPS configuration settings
laps-assignment.jpg: ACME-LAPS with no included groups

## Conditional Access Policy

The evidence set does not include a Conditional Access policy, so I could not create or capture one. Based on the assignment, the policy would be configured as follows:

Name: ACME-Require-Compliant-Device-Report
Users: the test user account only, not all users
Target resources: Office 365
Grant: Grant access, Require device to be marked as compliant
Enable policy: Report-only

In report-only mode, the policy evaluates each sign-in and records what would have happened in the sign-in log without blocking the user.

## Evidence Not Available

These items require a working tenant or are not in the instructor evidence set:

Step 1: Snapshot Manager with W01_CleanBaseline selected and the desktop after restore. These apply to preparing a VM for live enrollment, which I could not do.
Step 4: Conditional Access policy screenshot confirming report-only mode, and the sign-in log showing a report-only result. Neither is in the evidence set. Question 2 of the Troubleshooting Narrative explains the result I would expect.
Step 5: Settings, Accounts, Sign-in options screenshot from the enrolled VM, with a note on whether it is Hello for Business or a local PIN only. The enrolled device in the evidence set is the instructor's, so I could not capture it.

## Portfolio Card

Using an instructor-provided evidence set, I analyzed a Windows compliance policy in Intune that requires BitLocker, a minimum OS version, and Microsoft Defender Antimalware, and identified BitLocker as the setting that made the test device noncompliant. I documented how a Conditional Access policy in report-only mode would affect ACME remote employees like Emily Park, explained Windows Hello for Business and Windows LAPS for ACME's endpoints and cashier kiosks, and built a security exception template with all six required fields.

## Troubleshooting Narrative

1. What compliance settings did you configure, and which ones failed on your test device? What does each failure mean in practical terms?

The ACME-Windows-Baseline-Compliance policy within the evidence set requires a minimum operating system version of 10.0.19041, Microsoft Defender Antimalware and BitLocker. Only the BitLocker setting was failing on CVNP1601_SWOS. In practical terms, Intune could not confirm that the drive is encrypted; therefore, data stored on this device could be read in case it is lost or stolen, and the device has been marked noncompliant.

2. After creating the CA policy, what did the sign-in log show for your test account? If you could not access sign-in logs, explain what you would expect to see and why.

Because I don't have my own working tenant, I am unable to view any sign-in logs. Additionally, there is no Conditional Access policy, nor any sign-in logs provided with the evidence set. Based on these facts, for the test account signing in from CVNP1601_SWOS I would expect to see the Report-only tab displaying Report-only: Failure, because the device is currently marked as noncompliant and therefore does not meet the Require device to be marked as compliant control. However, the user would still successfully sign in, as Report-only mode only logs the result of the attempt without blocking the user.

3. What is the difference between Entra registration and Intune enrollment? Why does Emily Park's device being Entra registered but not enrolled matter for compliance?

Registration of a device into Entra gives the device an identity within Entra ID and attaches a work account to it. However, this action does not place the device under management by Intune. Enrollment of a device into Intune places the device under MDM, thus allowing Intune to apply compliance policies and determine whether the device meets them. Since Emily's device is registered but not enrolled into Intune, Intune will be unable to evaluate the device or mark it as compliant, thus if there is a policy that requires a compliant device, she will be blocked.

4. If ACME flips the CA policy from report-only to On tomorrow, which users are most at risk of being blocked? How would you identify them before making the change?

Those users who are most at-risk are remote employees logging in from personal/unenrolled devices such as Emily's and those whose enrolled devices fail one of their compliance requirements, such as CVNP1601_SWOS failing BitLocker. I would identify these users by filtering the Entra sign-in logs for all results of Report-only: Failure on this policy and by reviewing the Intune compliance reports for devices that are noncompliant.

5. Describe a scenario where issuing a security exception to the compliance policy would be the right decision. What would the exception note need to include?

It would be correct to issue a security exception to the compliance policy when a remote worker needs email access in order to complete time sensitive tasks due to shipping delays of their replacement company laptop and the device they are using temporarily is unable to meet one of the requirements of the policy. The exception note should contain who it applies to, business justification for granting the exception, specific controls being waived by the exception, time-limited duration of exception approval, person responsible for approving the exception and compensating controls replacing the waived controls.

6. What is one thing you would do differently if you were building this compliance and CA setup for a real organization with 500 endpoints instead of a lab tenant?

If I were doing this for a real organization with 500 endpoints instead of a lab tenant I would implement the Conditional Access policy in phases via pilot groups similar to the 4 wave rollout plan outlined in Week 10. I would have each wave run in Report-only mode until both the sign-in logs and compliance reports indicate that there are no unforeseen failures; then I would enable enforcement on that group prior to proceeding to the next.

## AI Use

AI tools were used during this lab. See ai-disclosure.md for details.