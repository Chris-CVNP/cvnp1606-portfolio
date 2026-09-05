# Support Note Examples

Nexus Support Services
Ticket CVNP1606-W02-002
Internal examples of ticket documentation for common post-refresh requests.

## Note 1: Resolved user navigation issue

Ticket: Pointer visibility, ACME pilot group
Status: Resolved on first contact

User reported that after the Windows 11 refresh, the mouse pointer was difficult to
follow on screen and they could not find where the setting had moved. Confirmed the
user was on the refreshed build and that no display or driver issue was present.

Walked the user to Settings, Accessibility, Mouse pointer and touch. Had the user
select a pointer style, then drag the Size slider while watching the pointer change
on screen. User selected size 5 and confirmed the pointer was easy to track. The
change applies immediately, so no restart or sign-out was needed.

Confirmed with the user before closing that the setting held and that they could
reach the page again on their own. Advised that pointer size does not affect the
text cursor, which has its own controls under Settings, Accessibility, Text cursor,
in case they raise that separately.

Evidence: screenshots/02-mouse-pointer.png, screenshots/07-accessibility-change.png

## Note 2: Requires escalation or approval

Ticket: Orphaned startup entry, ACME pilot image
Status: Partially resolved, escalated for image review

While reviewing startup applications on the lab system, found an entry named
Vmtoolsd listed as Enabled with a blank Publisher field. Right-clicking the entry
showed Open file location and Properties both grayed out, which indicates the
executable the entry points to is no longer present on disk. The registry entry
survived an earlier VMware Tools removal that did not complete cleanly.

Disabled the entry, which is safe and reversible, and confirmed the Status column
changed to Disabled. Did not remove the underlying registry key.

Escalating rather than closing. Removing orphaned startup keys is a registry change
outside the scope of a user-facing fix, and if this entry survived the uninstall on
this system it is likely present on every machine built from the same image. That is
an image problem, not a single-user problem, and it needs owner approval before any
scripted cleanup is applied across the pilot group.

Requested from the escalation owner: confirmation of whether the pilot image was
built from a machine that previously ran VMware Tools, and approval for a scripted
removal if so.

Evidence: screenshots/05-startup-apps.png

## Note 3: Rewriting a vague response

Original note as written:

"User couldnt find display settings. Told them to just look in settings, its not
that hard. Should be fine now."

Problems with the original:

It blames the user rather than describing the issue. It records no tool path, so the
next technician has to start over. It never confirms the problem was actually
resolved, only assumes it. It includes no evidence and no escalation criteria.
"Should be fine now" is a guess presented as an outcome.

Rewritten note:

User reported that text and interface elements appeared too small following the
Windows 11 refresh and was unsure where the display size controls had moved.

Walked the user to Settings, System, Display. Under Scale and layout, opened the
Scale drop-down and had the user select the percentage marked Recommended. User
confirmed the desktop and an open application window were readable at the new size.

Advised the user to use the Scale drop-down rather than Custom scaling. Custom
values apply to all displays, do not take effect until sign-out, and can make the
screen unreadable if set too high, which makes recovery difficult.

Confirmed resolution with the user before closing. If an application appears blurry
or its buttons are cut off after a normal scale change, that is an application
compatibility issue rather than a display fault. Collect the application name and
version and escalate.

Evidence: screenshots/04-display-scale.png