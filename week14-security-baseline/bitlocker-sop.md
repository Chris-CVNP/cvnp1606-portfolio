BitLocker process flow SOP
Step 1. Enforcement
ACME uses the Intune Disk encryption policy named ACME-BitLocker-Review located within the Intune admin center > Endpoint security > Disk encryption. This policy sets the require device encryption toggle switch to Enabled; however, removable storage media is encrypted using AES-CBC 128-bit instead of the XTS-AES 256-bit used for the operating system drive and fixed data drives. Additionally, the Intune Disk encryption policy sets the require additional authentication at startup toggle switch to enable, and Configure TPM startup is set to Require TPM. In addition to requiring TPM for booting, ACME allows users to create either a startup PIN or a startup key utilizing a TPM. Although both types of keys are allowed in conjunction with a TPM, neither type of key is required. Allow BitLocker without a compatible TPM is set to False. The policy requires a 48-digit recovery password, which BitLocker generates. Once encryption completes on an Entra-joined device, the device saves its recovery information, the recovery password, to Microsoft Entra ID. BitLocker does not turn on until the recovery information has been saved. The ACME-Autopilot group receives this policy.
Step 2. Recovery key backup path
Microsoft Entra ID stores recovery passwords once the encryption is completed on an Entra-joined device. On the Intune admin center portal, this is labeled as saving recovery information to Active Directory Domain Services, AD DS, for OS drives, and is configured as storing both recovery passwords and key packages. For example, if a technician needs to locate a particular recovery key for one of our devices, he/she would go into the Intune admin center, Devices > All devices > select device > Recovery keys. The technician can find the recovery key by looking at the key value area in the Recovery keys window, which is written as [RECOVERY-KEY-REDACTED] in all ACME documentation.
Step 3. Authorization
The only people authorized to view a BitLocker recovery key are those ACME IT staff members who have an active role in Intune that permits them to view BitLocker recovery keys. Any person attempting to access a recovery key must first have an existing support ticket opened for that specific device. In order to proceed with viewing a key, the technician must verify the identity of the user requesting the unlock. The technician must receive approval from either Riley Chen, ACME IT manager, or her designated backup before proceeding. We do not send any recovery keys via email or chat. Instead, the technician calls or phones in the recovery key to the user or manually enters it into the device.
Step 4. Documentation for tickets
When a technician views/retrieves or utilizes a BitLocker recovery key, each support ticket opened for that specific event must document the following:
* ticket #
* name of device
* user who requested the unlock and method used to verify their identity
* who approved the retrieval and when
* technician who accessed/entered the key
* date and time it was entered/accessed
* reason for needing recovery
* result