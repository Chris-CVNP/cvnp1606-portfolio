Sync
What the action does: Synchronizes the device to force it to contact Intune immediately, and then apply any pending policies and applications.
Who is authorized to trigger it: Technician.
Whether it is reversible: Yes. This action doesn't delete, modify or change ANYTHING on the device.
What must be recorded in the support ticket: The device name, why the synchronization was needed, the date/time it was initiated, if the device contacted Intune after the sync.
Restart
What the action does: Forces the device to restart, generally due to an update pending or some other policy which requires the device to restart.
Who is authorized to trigger it: Technician.
Whether it is reversible: Yes. After restarting, the device should resume normal operation; however, any user's un-saved work will be lost; therefore, the user will be notified prior to initiating the restart.
What must be recorded in the support ticket: The device name, reasons for restarting the device, that the user was informed of potential loss of un-saved data, date/time the restart was initiated, and that the device resumed normal operation.
Remote lock
What the action does: Immediately locks the screen of the device. This is done in cases where a device has been reported lost/stolen.
Who is authorized to trigger it: Technician.
Whether it is reversible: Yes. The user may unlock the device using their PIN/password.
What must be recorded in the support ticket: The device name, who reported the device as being lost/stolen and at what time, time the remote lock was issued and confirmation from Intune that the device received the lock.
Wipe
What the action does: Performs a factory reset on the device, wiping all data stored on it including all applications and preferences.
Who is authorized to trigger it: Requires Manager approval prior to having a technician initiate the Wipe.
Whether it is reversible: No. All data contained within the device will be completely removed.
What must be recorded in the support ticket: The device name, reason(s) for performing the Wipe, Manager who approved the Wipe and at what time, verification that necessary data was backed up prior to Wipe or that no data existed on the device, Technician who initiated the Wipe, and time Wipe was initiated.
Retire
What the action does: Completely removes all company applications/data/policies while leaving personal data/apps on the device. Also unenrolls the device from Intune management.
Who is authorized to trigger it: Requires Manager approval prior to allowing a senior technician to perform this on corporate-owned devices.
Whether it is reversible: No. The device would require enrollment into Intune to allow for management once again.
What must be recorded in the support ticket: The device name, whether it is corporate or privately owned, Reason for Retiring the device, Manager approval of Retire, Senior technician who initiated the Retire, Time that Retire was initiated.
Fresh Start
What the action does: Resets Windows back to its original installation state and removes ALL previously installed applications. The administrator can choose to keep the user's data. Is typically performed when a device becomes so damaged or corrupted that it cannot be repaired through normal means.
Who is authorized to trigger it: A senior technician, with Manager approval prior to performing this action on a production environment device.
Whether it is reversible: No. Any apps that were removed during Fresh Start will need to be re-installed manually.
What must be recorded in the support ticket: The device name, reason why regular repair methods could not be utilized on the device, whether or not user data was retained upon completion of Fresh Start, Manager approval of Fresh Start, Technician who initiated Fresh Start, Time that Fresh Start was initiated, Apps which are currently missing and need to be re-installed on the device.