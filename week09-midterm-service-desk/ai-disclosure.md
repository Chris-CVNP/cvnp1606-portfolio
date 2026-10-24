# AI Disclosure - CVNP1606 Week 09 Midterm Service Desk Surge

Ticket CVNP1606-W09-009

What I asked the AI to help with:
I had the AI help me plan how I would work through tickets and which tool to use for each one.

What I verified on the live VM before including it in documentation:
I planned out the ticket assignments and prepared my VM. My first attempt to run the setup failed because my VM didn't have an audio driver installed, so I corrected that before proceeding. I also verified the locked account state and its unlock; the 4740 and 4625 events associated with this account; the Code 28 error and the subsequent recovery of the audio device; and the scheduled task that was slowing the workstation. Finally, I verified a failed ping test and a failed Test-NetConnection test related to the network ticket.

One AI suggestion I accepted, revised, or rejected and why:
First, the AI recommended rolling back the driver for the audio ticket. On my VM, I found that Roll Back Driver had no effect when clicked because there were no previous versions of the audio driver to roll back to. So I revised my process by uninstalling the device, then running Scan for hardware changes to let the system reload the correct driver from the local store.