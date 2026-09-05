# Validated Steps

Nexus Support Services
Ticket CVNP1606-W02-002
Validation record for every FAQ entry in README.md.

System used for testing, all entries:
Windows 11 Enterprise Evaluation, version 25H2, OS build 26200.9278, installed
1/25/2026. Virtual machine CVNP1606-LAB-Win11 running on a Proxmox VE host,
accessed through the browser console.

## Entry 1: Mouse pointer size

Exact path tested:
Settings > Accessibility > Mouse pointer and touch

Evidence:
screenshots/02-mouse-pointer.png
screenshots/07-accessibility-change.png

Limitation or alternate path found:
There are no apparent headings on this page as it relates to the Four Pointer Style
Tiles. Therefore the Steps for Accessibility will be referencing the tiles based on
their location within the tile layout. The Size Slider numeric values can also only
be seen when being slid through a tooltip. That is why the Accessibility Evidence
Screenshot was taken during the slide operation rather than once the slide had been
released. As is typical of many other pages in this Section, changes are made
immediately; however, there is an "Apply" button associated with the Text size page,
and you would need to click that before making your selections permanent.

## Entry 2: Default app for a file type or link type

Exact path tested:
Settings > Apps > Default apps > Set a default for a file type or link type

Evidence:
screenshots/03-default-apps.png

Limitation or alternate path found:
Microsoft Edge was the only browser available on this test system so it would have
been impossible to verify the entry through changing the default between two
browsers. The validation of the entry took place against a link type as both will
bring up the same dialog box and call the "Set default" button. This page has two
search boxes that are completely independent of each other. One search box is located
within the "Set a default for a file type or link type" section while the second is
located in the "Set defaults for applications" section. Both search boxes will open
an additional dialog box but they will be different. Therefore the entry represents
the first dialog box. If another browser were installed onto your computer, you can
select the search box under "Set defaults for applications" because it would allow
you to switch your default browser much quicker than the first method.

## Entry 3: Display scaling

Exact path tested:
Settings > System > Display > Scale

Evidence:
screenshots/04-display-scale.png

Limitation or alternate path found:
The Scale dropdown was accessed and the possible options were reviewed. 150% was
identified as the Recommended option in the dropdown and was already the selected
value, which is the default established by the operating system. No scaling
adjustment was made. Because no scaling adjustments were made, AppliedDPI will not
be written in the registry and collect-evidence.ps1 reports that the display scale
is not set. When running the test, the Custom Scaling page was reached first
(System > Display > Custom Scaling). There is a warning placed on that page that
customizing this setting applies to ALL displays, can make text and apps unreadable,
and is difficult to reverse, and changes are NOT applied until you log off. This
entry was created to send users back to the dropdown.

## Entry 4: Startup applications

Exact path tested:
Task Manager > Startup apps

Evidence:
screenshots/05-startup-apps.png

Limitation or alternate path found:
The user utilized CTRL, SHIFT, and ESC keys to open the Task Manager. The same action
can be accomplished through right clicking on the task bar OR start menu. Using
Settings >> Apps >> Startup allows you to see the same entries as above however it
will display a toggle switch for each of them instead of the Publisher field that
would allow a Technician to make a decision on if they should enable/disable this
application. There was one enabled entry named Vmtoolsd that had a blank Publisher
field and when I tried to click "Open File Location" and "Properties", I could not
since these were both grayed out. The most likely explanation for this behavior is
that there are still Orphaned Registry Entries from the VMware Tools uninstallation
process that did not completely remove all files associated with VMware.

## Entry 5: Local account group membership

Exact path tested:
lusrmgr.msc > Users > account Properties > Member Of

Evidence:
screenshots/06-local-users.png

Limitation or alternate path found:
The shortcut referenced in the FAQ for opening the Run box by pressing the Windows
Key and "R" was unusable, since the Remote Console Session sends the Windows Key to
the Host machine and not the Guest machine. Therefore, Start Search was utilized to
open lusrmgr.msc. Additionally, Task Manager, File, Run New Task will work as well.
This test was executed against the "Test" account which has membership with only one
Group (Users) therefore the Screenshot provided above represents standard User Rights
as opposed to Administrator rights. Also noted within the Properties Dialog box was
the fact that changes to Group Membership may not take place until after the users
next Sign In.