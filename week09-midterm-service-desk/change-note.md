# Change Note - Ticket C Audio Driver Recovery

Ticket CVNP1606-W09-009

What changed:
I fixed the issue by reinstalling the original audio device driver. My audio device previously failed with the error Error code 28 - drivers for this device are not installed. To resolve the issue, I removed the audio device from Device Manager, and then I performed a Scan for hardware changes so that Windows would be able to locate the existing audio driver, which existed locally, and reinstall it.

What evidence confirmed the problem:
In Device Manager, a yellow warning triangle appeared next to the audio device under Other devices, and the General tab showed Error code 28 - drivers for this device are not installed. Since the audio stopped working immediately after a Windows Update overnight, this supported the conclusion that the problem was due to missing drivers.

Who approved the change:
Since I responded to the call, I can approve my own change, and in a lab environment, I believe this is acceptable.

Rollback steps if the change makes things worse:
If installing the device driver causes other issues than what existed before, you will need to remove the device driver. This can be accomplished by going back into the Device Manager, selecting your audio device, right-clicking and choosing Uninstall device, and then running another Scan for hardware changes to put everything back the way they were originally. Alternatively, you could restore your VM to the earlier snapshot.

How I verified the result:
After reinstalling the original audio device driver, I reviewed the audio device within the Device Manager window. It now reports functioning without any errors.