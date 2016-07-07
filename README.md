# CheckInCheckOut
A software for checking out barcode tagged items for the SDM Foundation Melrose.

The barcodes must be Code128. It has a manager screen for the checked out devices and a screen with a camera feed to scan. 
There are two files outputed: one that is a log for each file outputed and one that is a log for the day.
When the app is closed, every file is logged so closing is not a worry. 
The data output on the daily file is that of three time blocks, four device types, the total devices checked out,
and the amount of devices that are "missing" (not yet checked back in).
