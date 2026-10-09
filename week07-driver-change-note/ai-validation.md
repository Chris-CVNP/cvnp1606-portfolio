# AI Validation

## What I asked the AI to help with

I utilized Claude to compare my screenshots of the hardware inventory hardware-inventory.txt and also to compare them to the project specifications. I also had it draft the change note and the README pieces, which I rewrote, and write the rollback plan from my results.

## What I verified on the live VM

I went into Device Manager and found that VMware Pointing Device had a yellow warning symbol for an error. It listed as Code 19 in Device Manager. I looked up all of the information about the device including the Hardware ID, the name of the driver's provider, the date the driver was created, and the version number of the driver from the properties for the device. I ran Get-PnpDevice to verify if there were any errors associated with PnP, and when finished; I went back into Device Manager to see what changes occurred after I uninstalled the device and Windows reinstalled the driver.

## One AI suggestion I rejected

After uninstalling the device and letting Windows reinstall the driver, did not resolve the problem with the fault, the AI suggested a manual driver install which will enable me to use a different mouse driver. I did not agree with this idea because, I had already removed VMware software from this virtual machine. Since the software has been removed, the device is now obsolete and it is normal for it to be faulty.