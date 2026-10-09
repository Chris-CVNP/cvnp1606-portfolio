# Change Note

Ticket CVNP1606-W07-007

## Before state

The device that caused an error was VMware Pointing Device which was located as a yellow warning triangle in Mice and other pointing devices within Device Manager. When I ran Get-PnpDevice to list all PnP devices on my system, VMware Pointing Device had a status of Error. On the General tab for the VMware Pointing Device, Code 19 indicated that Windows could not start this hardware device because there was incomplete or corrupted configuration data stored in the registry for this hardware. The Hardware ID for the VMware Pointing Device was ACPI\PNP0F13. The driver provider for the VMware Pointing Device was Broadcom Inc. The driver for the VMware Pointing Device was dated October 22nd, 2024. The driver version was 12.5.15.0.

## Action taken and reason

I removed the device from Device Manager. Then, I let Windows reload the driver when it performed a hardware check. I left unchecked the box that would allow the removal of the drivers' package. I chose to Reinstall rather than Rollback, as the Roll Back Driver option on the Driver Tab was grayed out. This indicated that there were no prior versions of the driver for Windows to roll back to; therefore, uninstalling/reinstalling was my only viable solution without using an external driver package.

## Expected after state

The expected outcome was that after reinstalling the driver, Windows would install the driver for the VMware pointing device, the pointing device would start, and Device Manager should show it as VMware Pointing Device with no yellow warning and indicate it is working. However, I received an unexpected result. Even after reinstalling the same driver, the pointing device still shows the yellow warning symbol. The reason is that I am now running this virtual machine on something other than VMware. As a result, the VMware pointing device appears as a leftover device after removing the VMware application.

## Performed by

C A performed the change on 10/08/2026 at about 8:30 PM Central.