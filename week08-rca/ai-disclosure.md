# AI Disclosure

Claude AI helped me work on this project. It identified problems with the "Get-WinEvent" command in the Guide and the exported file, and it grouped together my Kernel-Power 41 and 6008 event pairs from the export.

How I compared its results to real proof: Every time stamp, event ID, source and level for each entry was examined in both the system log filter that is shown in Event Viewer and the full 6008 event IDs and messages produced by "Format-List" of "Get-WinEvent".