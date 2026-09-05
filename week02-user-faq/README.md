# Windows 11 User FAQ

Nexus Support Services
Ticket CVNP1606-W02-002
Prepared for the ACME pilot group after the Windows 11 refresh

All paths were tested on Windows 11 Enterprise Evaluation, version 25H2, OS build 26200.9278. AI use is disclosed in ai-disclosure.md and ai-validation.md.

## How do I make my mouse pointer easier to see in Windows 11?

User goal:
Make the mouse pointer larger and easier to spot without changing the size of anything else on screen.

Tool path tested:
Settings > Accessibility > Mouse pointer and touch

Steps:
1. Open Settings.
2. Select Accessibility.
3. Select Mouse pointer and touch.
4. Select a pointer style tile at the top of the page.
5. Drag the Size slider to the preferred size. The change applies immediately.

Evidence:
screenshots/02-mouse-pointer.png
screenshots/07-accessibility-change.png

When to escalate:
If the pointer is still hard to follow after style and size are adjusted, or it disappears entirely, collect device and display details and escalate for driver or hardware review.

## How do I choose which app opens a file type or link type in Windows 11?

User goal:
Control which application opens a specific kind of file or link.

Tool path tested:
Settings > Apps > Default apps

Steps:
1. Open Settings.
2. Select Apps.
3. Select Default apps.
4. Under Set a default for a file type or link type, enter the file extension or link type.
5. Select the result, choose the app, and select Set default.

Evidence:
screenshots/03-default-apps.png

When to escalate:
If the app the user wants is not listed, or Set default is missing or grayed out, confirm the app is installed and escalate for policy review rather than editing the registry.

## How do I make everything on my screen larger in Windows 11?

User goal:
Make text, icons, buttons, and app windows larger together.

Tool path tested:
Settings > System > Display > Scale

Steps:
1. Open Settings.
2. Select System.
3. Select Display.
4. Under Scale and layout, open the Scale drop-down menu.
5. Select a larger percentage and confirm the result.

Evidence:
screenshots/04-display-scale.png

When to escalate:
Use the Scale drop-down rather than Custom scaling, which applies to all displays and does not take effect until sign-out. If apps look blurry or cut off after a normal scale change, collect the app name and version and escalate.

## How do I stop programs from opening when I sign in to Windows 11?

User goal:
Speed up sign-in by preventing unneeded applications from launching automatically.

Tool path tested:
Task Manager > Startup apps

Steps:
1. Press Ctrl, Shift, and Esc to open Task Manager.
2. Select Startup apps.
3. Review the Startup impact column.
4. Right-click an unneeded application and select Disable.
5. Confirm the Status column reads Disabled.

Evidence:
screenshots/05-startup-apps.png

When to escalate:
Leave security, driver, backup, VPN, and management entries enabled. If an entry has a blank publisher or grayed-out Properties, record it on the ticket and escalate, since it points to an incomplete uninstall.

## How do I check which groups a local account belongs to in Windows 11?

User goal:
Confirm whether a local account has standard user or administrator rights.

Tool path tested:
Local Users and Groups (lusrmgr.msc) > Users

Steps:
1. Press the Windows key and R, type lusrmgr.msc, and select OK.
2. Approve the User Account Control prompt.
3. Select Users.
4. Double-click the account and select the Member Of tab.
5. Review the groups listed, then select Cancel.

Evidence:
screenshots/06-local-users.png

When to escalate:
Checking membership is safe, but changing it is not. Adding an account to Administrators requires approval, so document what you found and escalate. The snap-in is unavailable on Windows 11 Home.

## What I Can Do Now

I can write FAQs, document tickets, and prove my instructions work with screenshots so the next technician doesn't have to start over.