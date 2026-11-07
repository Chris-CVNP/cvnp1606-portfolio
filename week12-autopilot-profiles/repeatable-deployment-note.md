Repeatable Deployment Note

Objective: register a new ACME Windows laptop with Windows Autopilot and deploy with the ACME Standard User Profile along with applying the ACME-Display-Timeout-Policy.

Source: instructor provided Week 12 evidence set from the ATCC tenant and Microsoft documentation.

Pre-requisites: an active Intune admin account, the new laptop internet connected, and the existing ACME Standard User Autopilot Profile, ACME-Pilot-ESP Enrollment Status Page, ACME-Autopilot group, and ACME-Intune-Pilot group.

1. Obtain the hardware hash: connect the new laptop to internet. Open Windows PowerShell as an administrator. Run each command separately:

[net.servicepointmanager]::securityprotocol = [net.securityprotocoltype]::tls12
New-Item -Type Directory -Path "c:\hwid"
Set-location -Path "c:\hwid"
$env:Path += ";c:\program Files\WindowsPowerShell\Scripts"
Set-executionpolicy -scope Process -executionpolicy remotesigned
Install-Script -name get-WindowsAutopilotInfo
Get-WindowsAutopilotInfo -outputfile autopilothwid.csv
Expected result: the file C:\HWID\AutopilotHWID.csv should exist. Copy this to your technician workstation.

2. Import the hardware hash: from the Intune admin center, navigate to Devices > Windows > Enrollment > Windows Autopilot. Select Devices. Click Import. Navigate to autopilothwid.csv. Select Import. Once the import is complete, click Sync. Then Refresh until the laptop's serial number appears. Sync can only run once per 10 min.

3. Add the laptop to the Autopilot group: from the Microsoft Entra admin center, go to Entra ID > Groups. Open ACME-Autopilot. Select Members. Then click Add members. Search for the laptop. Select it. Select Select.

4. Validate the Autopilot Profile assignment: in the Intune admin center, go to Devices > Windows > Enrollment > Windows Autopilot. Select Deployment Profiles. Open ACME Standard User. Confirm that Deployment mode is set to User-Driven. Confirm that Join to Microsoft Entra ID as is set to Microsoft Entra joined. And confirm that ACME-Autopilot is listed under Included Groups with a status of Active. Go back to Windows Autopilot Devices. Select Refresh. Verify that the laptop's Profile status shows Assigned.

5. Validate the Enrollment Status Page: in the Intune admin center, go to Devices > Windows > Enrollment > Windows Autopilot. Select Enrollment Status Page. Open ACME-Pilot-ESP. Select Properties. Confirm that Block device use until all apps and profiles are installed is Yes. Confirm that Block device use until required apps are installed if they are assigned to the user/device is All. Confirm that the error time limit is 60 minutes. And confirm that ACME-Autopilot is the Included group with a status of Active.

6. Create the configuration Profile: in the Intune admin center, go to Devices > Configuration. Select Create. Then select New Policy. Set Platform to Windows 10 and later. Set Profile type to Settings Catalog. Then select Create.

7. Name the configuration Profile: on the Basics tab, enter ACME-Display-Timeout-Policy as the name. Then select Next.

8. Define the setting: on the Configuration settings tab, select Add settings and search for Turn off the display. In Administrative Templates, System, Power Management, Video and Display Settings, select Turn off the display (plugged in). Enable it. Set When plugged in, turn display off after (seconds) to 900. Then select Next.

9. Apply the configuration Profile: Leave Scope tags at Default. Select Next. On the Assignments tab, select Add groups. Choose ACME-Intune-Pilot. Select Select. Then select Next. On Review + create, select Create.

10. Place the laptop into the target group: in the Microsoft Entra admin center, go to Entra ID > Groups. Open ACME-Intune-Pilot. Select Members. Then click Add members. Select the laptop. Select Select.

11. First boot experience: provide the laptop to the user. The user powers it on, connects to internet, signs in with their ACME organizational account at sign-in screen. Expected results: the Enrollment Status Page shows setup progress and the user does not reach desktop until required apps & profiles finish installing. The device name will follow the template used in the Autopilot Profile, ACME-%RAND:4%.

12. Verify that the Profile was applied successfully: in the Intune admin center, go to Devices > All devices. Select the laptop. Then select Device configuration. Expected results: ACME-Display-Timeout-Policy should show as Succeeded. If it says Pending, select Sync on the device's Overview page and check again after the device checks in.