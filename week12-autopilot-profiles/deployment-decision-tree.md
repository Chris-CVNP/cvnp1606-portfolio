Deployment decision tree
Reference Source: Microsoft documentation; instructor provided evidence set from the ATCC tenant, Week 12.
Questions to ask for each device
Is there going to be a user present to log in during the initial configuration process? Will this be a shared device, but no user has been assigned to it? Or, will a technical person need to configure the device prior to sending it to the end-user?
Example scenario 1: new hire receiving laptop on first day at office
Mode: User-driven
Why it's correct: there is a single user owner for this device, the new hire, which allows him/her to enter their organization email address and complete the out of box experience, OOBE. Once completed, the device will automatically join Microsoft Entra ID and enroll in Intune eliminating the need for a technical person to manually configure the device. The ACME Standard User profile provided by the ATCC tenant was set to User-Driven with Microsoft Entra joined.
Alternative that would not work: Self-deploying. Self-deploying is intended for devices with no assigned user. Therefore, if this were to occur, the laptop would not be configured for the new hire that uses it daily.
Example scenario 2: kiosk device in break room with no assigned user
Mode: Self-deploying
Why it is correct: during the OOBE process, no user logs into the device. Self-deploying is used for kiosks and shared devices. Since Self-deploying uses hardware verification based upon TPM 2.0 and TPM device attestation, as opposed to user login verification, hardware-based authentication replaces user-based authentication.
Alternative that would not work: User-driven. User-driven requires a user to provide their organizational credentials during the OOBE process. Since the break room kiosk has no assigned user, no one can log in during the OOBE process.
Example scenario 3: remote employee receives pre-staged laptop shipped from warehouse
Mode: Pre-provisioning
Why it is correct: prior to shipping the laptop from the Nexus warehouse, a technician initiates the technician flow by pressing the Windows key five consecutive times at the sign-in screen. The device-targeted apps and policies are installed on the laptop during the technician flow. After completing the technician phase, the technician reseals the laptop. When the remote employee receives the laptop and begins the OOBE, only the user phase remains. By doing so, it reduces the amount of time spent by the employee waiting for setup to be completed. The laptop must also contain TPM 2.0 and support TPM device attestation.
Alternative that would not work: Self-deploying. Since Self-deploying does not link the device to a user or initiate a user phase for that employee, when deployed for a remote employee, Self-deploying does not meet the requirements necessary for this scenario.
Example scenario 4: Replacement laptop for existing employee whose primary device failed
Mode: User-driven
Why it is correct: the replacement laptop belongs to an existing employee who currently has an organizational account. As such, he/she can perform the OOBE and allow the laptop to join Microsoft Entra ID and enroll in Intune. Since his/her targeted apps and policies are tied to his/her account, he/she is able to quickly begin performing work again without having a technician recreate the settings by hand.
Alternative that would not work: Self-deploying. Self-deploying is designed for devices with no assigned user. If deployed for an existing employee whose primary device failed, the replacement laptop would not be properly configured for them.