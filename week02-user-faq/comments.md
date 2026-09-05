# Troubleshooting Narrative

Which user request or FAQ entry was hardest to validate?
The display scaling entry was the hardest to validate. Although the user's request is basic (they want everything on their screen larger), there are multiple ways that Windows 11 allows a user to accomplish this and both paths produce different results. Therefore, when validating the entry, it was necessary to determine which path the user would ultimately be best served by, rather than simply identifying a valid path.

What evidence did you check first?
First I reviewed the About page to confirm the edition, version and build number that I was testing against. This allowed me to identify that my testing was being conducted using Windows 11 Enterprise Evaluation (25H2) Build Number 26200.9278. Next, I reviewed the Display page to view the various display scaling options offered by the system and to identify the current setting of the Scale option.

What tool path did you test?
During testing, I reviewed the following within the System > Display portion of the Settings application: Settings, System, Display, and then the Scale dropdown within Scale and layout. While testing I also became aware of Settings, System, Display, Custom scaling, which is another page located within the same section as the previously mentioned pages.

What did you revise after testing?
After testing, I modified the entry to direct users toward the Scale dropdown menu, and to advise against using the Custom scaling page. The Custom scaling page contains warnings that indicate that the selected scaling value will apply across all monitors, may render text and applications unreadable and is difficult to revert. Furthermore, during testing I discovered that the custom value I entered on that page did not take effect until I signed out and signed back in. Because the change was still pending, I was able to correct my mistake before signing out and returning to a desktop that could no longer be read. Additionally, I updated the escalation note to describe this consequence in simpler terms instead of indicating it as a compatibility problem.

How did you verify the final instruction?
To confirm whether or not the final instructions were accurate I opened the Scale dropdown menu contained within the Display page and verified which values were available and that 150% was indicated as Recommended and was already the selected value. I left my system configured at that value, thereby ensuring that my virtual machine remained in its established configuration, and I took a screenshot of the Scale dropdown menu which is included in screenshots/04-display-scale.png as supporting documentation. Since I did not apply a change to display scaling, AppliedDPI is not written in the Registry and collect-evidence.ps1 reports that the display scale is not set. I noted this limitation in validated-steps.md.

What was the support impact of writing the instruction clearly?
If an employee writes an instruction in a way that is confusingly written (as opposed to simply written), he/she may create something where a "simple" request becomes something larger.

The technician calls a user for custom scaling. The user enters a value in Custom scaling that will make his/her display unreadable, but the change will not be visible until the user signs out, therefore the user will have no way to undo this.

In contrast, if the technician provides clear instructions to the user when calling, then the technician has directed the user to the appropriate place (the Scale dropdown) and has told the user to begin with the Recommended value. This eliminates the risk associated with the second page, thereby eliminating the need for the technician to follow up with the user and ultimately closing the ticket at the initial time of contact rather than having the ticket come back as a machine the user cannot see well enough to fix.