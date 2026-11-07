LAPS and Hello Note

Microsoft documents and the instructor provided evidence for Week 11 from the ATCC tenant were used as sources for this note. Since I don't have my own working Intune tenant, I did not create those settings or collect data on them.

Section A: Windows Hello for Business

What it replaces
Windows Hello for Business will replace your password with either a PIN number or a biometric gesture like facial recognition or fingerprints.

How it works
Once you enable Windows Hello for Business, the device generates a key pair associated to the device and the user. The private key remains in the device's TPM and never leaves it. The public key is then sent to Microsoft Entra ID or Active Directory. In order to get into the system, the user enters their PIN or completes a biometric gesture. This unlocks the private key in that device only. Once unlocked, the device uses the private key to authenticate the user.

Why it is better than using a password
Since passwords are secrets known to both parties, the user and the server, a user may use the same password somewhere else, which is reuse, an attacker may capture a password and send it again, which is a replay attack, or a user may be tricked into typing their password into a fake sign-in page, which is phishing. Windows Hello for Business removes this threat because there is no password to be stolen. Also, since the PIN number is only stored locally on the device, if an individual steals a user's PIN number, the thief will still be unable to log in until they have access to that exact device.

Evidence set results
In the ATCC tenant, the default Windows Hello for Business setup for all users and all devices is Enabled. Use a Trusted Platform Module is set to Required. The minimum PIN length allowed is 6 characters and the maximum PIN length allowed is 127 characters.

Section B: Windows LAPS

Problem it solves
Many organizations set a single password across all of their Windows machines. Therefore, if an adversary finds out what this password is through some means, for example by hacking a workstation, they can now log on as a local administrator on all other workstations that use this same password.

How rotation works
Windows LAPS manages a single local administrator account per device. Each device receives its unique password. The password is saved to Microsoft Entra ID or Active Directory for safe keeping. Then, when a specified amount of time passes, based upon the number of days configured within the LAPS policy called Password Age Days, Windows LAPS will rotate the password. Additionally, an administrator can also force-rotate it at any time using the Rotate local admin password device action from the Intune admin center. When either rotating the password, retrieving it or even accessing it via the Intune admin center, each activity is logged as an audit event.

Why it matters for ACME's cashier kiosks
ACME's technicians share one local administrator account for maintenance on the cashier kiosks, so one leaked password currently opens every kiosk. With Windows LAPS, each kiosk has its own password that changes on a schedule. A technician looks up the current password for the one kiosk they are working on, the lookup is audited, and a password exposed on one kiosk cannot unlock the others.

Evidence set results
The ATCC tenant has a Windows LAPS policy named ACME-LAPS under Endpoint security, Account protection. It backs up the password to Microsoft Entra ID only, uses large letters, small letters, numbers, and special characters, has a password length of 14, and has a Password Age Days value of 30. The policy has no included groups, so it is not assigned to any devices yet.