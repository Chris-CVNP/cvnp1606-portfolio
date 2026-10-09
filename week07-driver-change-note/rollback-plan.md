# Rollback Plan

Ticket CVNP1606-W07-007

## What was changed and the restore target

VMware Pointing Device was uninstalled in Device Manager and Windows reinstalled it on the next hardware scan. The driver package was not deleted. The restore target state is VMware Pointing Device installed with the Broadcom Inc. driver version 12.5.15.0 dated 10/22/2024. The named restore point is the W01_CleanBaseline snapshot of the VM, which was taken before this change.

## Steps to restore the prior state

### Method 1, Device Manager

1. Open Device Manager and expand Mice and other pointing devices.
2. If VMware Pointing Device is missing, select Action then Scan for hardware changes.
3. Double-click VMware Pointing Device and open the Driver tab.
4. If the driver version is not 12.5.15.0, select Update Driver.
5. Select Browse my computer for drivers.
6. Select Let me pick from a list of available drivers on my computer.
7. Select VMware Pointing Device from the list and select Next.
8. Close the dialog when Windows reports the driver is installed.

### Method 2, snapshot

Use this method if Method 1 does not restore the target state.

1. Confirm all work in the portfolio repo is pushed to GitHub, because the rollback removes everything on the VM since the snapshot.
2. In the Proxmox web interface select the VM, then Snapshots.
3. Select W01_CleanBaseline and select Rollback.
4. Start the VM and sign in.

## Responsible party and notification

C A, the junior technician who made the change, executes the rollback. The lead at Nexus Support Services must be notified before the rollback starts and after it is verified. Alex Torres, the ACME Office Manager who submitted the ticket, must be notified of the outcome.

## Verification

In Device Manager, VMware Pointing Device is listed under Mice and other pointing devices. The Driver tab shows Broadcom Inc. as the provider, a driver date of 10/22/2024, and driver version 12.5.15.0. The prior state included the yellow warning triangle and Code 19, so a successful rollback returns the device to that state and does not mean the device is working. HID-compliant mouse and Remote Desktop Mouse Device show no warning icon and the pointer still works.

## Escalation path

If neither method restores the target state, or if the pointer stops working, stop making changes. Send the lead at Nexus Support Services the hardware-inventory.txt file, the change note, and the screenshots, and state which methods were tried and what Device Manager shows now. The lead decides whether to try a manual driver installation or to contact the manufacturer support channel.