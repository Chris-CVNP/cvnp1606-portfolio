# AI Validation

## What I asked the AI to help with

I asked Claude to explain why my Event Viewer filter and the guide's Get-WinEvent command returned no events, and pull the Kernel-Power 41 and 6008 pairs out of my export.

## How I verified it against what I observed

I compared each timeline entry to the Format-List output of Get-WinEvent and to the filtered System log in Event Viewer. I confirmed the 9/14/2026 Kernel-Power 41 at 5:03:27 PM in the event details panel, and I confirmed that the 6008 messages give the shutdown times used in the timeline.

## One suggestion I accepted

The AI pointed out that -MaxEvents 50 only reads the 50 newest System events before filtering, which is why the first export was empty. I removed -MaxEvents 50, reran the commands, and the export then included all 41 and 6008 events.

## One suggestion I revised

The AI had me filter the System log to the last 7 days, as the assignment says, but the filter returned zero events because the newest events in the log were from 9/21. I changed the date range to Any time, which brought up the Kernel-Power 41 and 6008 events, and I documented the change in Troubleshooting Notes.

## One suggestion I rejected

The AI suggested adding Format-List to the export command, because the table format cuts 6008 down to 08 in event-export.txt. I rejected it because the assignment and guide give the export command, and I followed it as written.