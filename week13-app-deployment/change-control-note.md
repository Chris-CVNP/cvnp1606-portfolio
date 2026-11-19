Change control note: acme-notepad++-arm64 Win32 app deployment
CVNP1606-W13-013
Riley Chen; Acme IT Manager
Alex; Endpoint Administrator
Maya; Approval required before deploying this App in Production
What is Changing
Acme Notepad++ v. 8.9.8.1 for ARM64 is now being deployed through Intune as a Win32 Application named "acme-notepad++-arm64". The Application was packaged with IntuneWinAppUtil into npp.8.9.8.1.installer.arm64.intunewin. Silent install command: npp.8.9.8.1.installer.arm64.exe /S (within System Context). Intune verifies the Installation of the Application via a File Detection Rule that checks for the presence of notepad++.exe at C:\Program Files\Notepad++. This replaces the variously installed (and often unsuccessfully installed) versions of Notepad++ that have resulted in many "App Missing" Tickets submitted.
Who/what Devices are Affected?
Only those devices inside the "ACME-Pilot-Devices" Entra ID group will be affected by this change during the pilot phase. All other Devices within the Fleet will continue to operate normally unless Maya determines that the pilot is successful and provides approval to deploy to the entire fleet.
Pilot Approach
The Application will only be Assigned as REQUIRED to ACME-Pilot-Devices; therefore the Application will Automatically Install on ALL Pilot Devices WITHOUT prompting Users to Launch the Company Portal. The First Verification Point for the Pilot is Device CVNP1601_SWOS. After the Pilot concludes and Maya signs off on the success criteria outlined below, the Application will then be Assigned to the Departmental Group(s) that require Access; therefore Devices such as Emily’s will receive the App.
Success criteria:
Intune device install status indicates "installed" for each pilot device.
Detection rule successfully passes; therefore notepad++.exe exists at c:\program files\notepad++.
Local check verifies file version = 8.9.8.1.
No errors occur when accessing Company Portal and users confirm app launches properly.
On the pilot, cvnp1601_swos indicates “installed” with last modified date/time of 11/06/2026 @ 09:11 pm; local check also confirmed that notepad++.exe exists at version 8.9.8.1.
Rollback procedure
If either the detection rule proves incorrect or the install fails on the pilot, open the acme-notepad++-arm64 properties, edit assignments, remove ACME-Pilot-Devices from the required section and add them to the Uninstall section, then save. Intune removes the application using the Uninstall command c:\program files\notepad++\Uninstall.exe /S on the pilot devices during its next sync. Verify that removal was successful by checking device install status within intune, correct the detection rule or install command prior to attempting another run of the pilot.