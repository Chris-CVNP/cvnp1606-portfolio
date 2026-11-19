Application name and version
ACME-Notepad++-ARM64 (version 8.9.8.1)
Source type
A Win32 .intunewin. I used the official npp.8.9.8.1.installer.arm64.exe to package the Microsoft Win32 content prep tool (IntuneWinAppUtil) into the npp.8.9.8.1.installer.arm64.intunewin and then upload this as a Win32 application in intune.
Silent install switch
/s. My full silent install string would be npp.8.9.8.1.installer.arm64.exe /s. When i created my install rule, i chose "System" so the app will install across all users on the machine.
Detection rule type & logic
My detection rule is a manually entered file detection rule. Intune looks for the existence of the file "notepad++.exe" in the path c:\program files\notepad++ using the file/folder exists detection method. It has been checked by me that there are no issues associated with running a 32 bit application on a 64 bit client since the associated with a 32-bit app on 64-bit clients field is set to no. Once intunewin detects "notepad++.exe", it will mark the application as being installed. Upon reviewing the files locally on cvnp1601_swos, i could confirm that the file existed in that location with a version number of 8.9.8.1.
Target group name
ACME-Pilot-Devices.
Assignment type and why
Required. We want the pilot group to have the app installed on their devices automatically. Users should not have to manually start Company Portal for this process in order to confirm that both the install and the detection rule are working prior to releasing the app to the remaining devices in our entire fleet. Since we view notepad++ as a required app all users within a specific department will need access to it; therefore, we consider it a required app and not optional (available).
What happens if detection rule fails to match
If the installer completes successful then the detection rule cannot locate notepad++.exe, intune will report that the install was unsuccessful with error 0x87D1041C. The application was not found after installing the application successfully. Due to the fact that the assignment is required, when intune determines that the app has been removed from the device during subsequent check-in's it attempts to install it again. This causes an uninstall/install cycle (loop) until the issue is resolved. The solution is to update your detection rule in order for it to match where the app is being installed.