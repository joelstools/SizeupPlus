![](.common/joelstools.png?raw=true)

# Sizeup Plus

Sizeup Plus extends the SizeUp window utility from Irradiated Software (http://www.irradiatedsoftware.com/sizeup/)
with shortcuts to set a window to any particular size and origin, or docked to the corners, sides, top, or
bottom.
It supports this as a script which can be bound to a keyboard shortcut.
The script figures out what the window geometry should be, and then tells SizeUp to set it, so SizeUp
is an integral part of this solution.
SizeUp is an awesome utility for organizing windows while you are working on your desktop, and is invaluable
if you are a presenter instructor and to move the active window to one location or another, or even between monitors.
The missing piece is to be able to set windows to particular sizes and in particular locations, such as
docking to the middle of the left or right screen edge.
That is what Sizeup Plus is about!

## Revision History

2020-06-27 - Joel Mussman

## License

This project and code is released under the MIT license. You may use and modify all or part of it as you choose, as long as attribution to the source is provided per the license. See the details in the [license file](./LICENSE.md) or at the [Open Source Initiative](https://opensource.org/licenses/MIT).

## Installation and Use

### SizeUp

The first required piece is SizeUp from Irradiated Software (http://www.irradiatedsoftware.com/sizeup/).
$12.99 at the time this was written, so that is ridiculously inexpensive for what you get.

### Sizeup Plus Scripts

Some shortcut managers, including FastScripts, do not have a way to pass arguments to a script when it is executed.
For that reason this script evaluates the name of the script to understand what geometry it is supposed to set the window to.
You will make copies of the script in your folder, each one with a different name for a different geometry.
Copy the file, do not make an alias to it, or the script will read the name of the shared file and not the alias.

Copy the [SizeupPlus.applescript](./SizeupPlus.applescript) file to your scripts folder.
Your default personal script folder is in ~/Library/Scripts, where ~ is your home directory.
You can put them pretty much anyplace else if you prefer, although FastScripts and other utilities do have some rules.

Make copies of the script to specify different geometries.
Do not make aliases to a single script, or the script will only see the name of the shared file, not the aliases.
The script name defines the position and size (width and height).
All of the possible names are case insensitive and begin with sp:

|Name|Description|
|---|---|
|spTopLeft-[Width]x[Height]|Dock to the top-left corner|
|spTopCenter-[Width]x[Height]|Dock to the top-center edge|
|spTopRight-[Width]x[Height]|Dock to the top-right corner|
|spMiddleLeft-[Width]x[Height]|Dock to the middle-left edge|
|spMiddleCenter-[Width]x[Height]|Center on the screen|
|spMiddleRight-[Width]x[Height]|Dock to the middle-right edge|
|spBottomLeft-[Width]x[Height]|Dock to the bottom-left corner|
|spBottomCenter-[Width]x[Height]|Dock to the bottom-center edge|
|spBottomRight-[Width]x[Height]|Dock to the bottom-right corner|
|spOrigin-[Width]x[Height]|Set the size, keep the origin the same|
|sp[xOffset]x[yOffset]-[width]x[height]|Set the size and move the origin|

### FastScripts

I recommend FastScripts from Red Sweater Software (https://www.red-sweater.com/fastscripts/) for linking
keyboard shortcuts to scripts and programs (although you can use Automator or other solutions).
You get ten shortcuts for free.
A full license is $15 if you buy it directly and $25 in the Mac App Store at the time this was written.

FastScript has a rule that if the script is under a directory named *Applications* or a subdirectory of
that directory the shortcut for the script will be bound to the application matching the name.
See the FAQ for more full details: https://help.red-sweater.com/fastscripts/faq/.
If you placed your scripts in ~/Library/Scripts, you are all set.

When you launch FastScripts it shows as an icon on the menu bar.
A new installation is primed with only the /Library/Scripts folder.
You can see this if you select *FastScripts &rarr; Preferences...*
If the folder you want is not there, then click on *FastScripts &rarr; Create Code Scripts Folder* and add your scripts folder
(instructions are in the [FAQ](https://help.red-sweater.com/fastscripts/faq/)).

Check the FastScript instructions to create shortcuts, but in a nutshell you will click on the shortcut on the script line,
and press the shortcut combination you want to launch the script:
![](.common/fastscripts-shortcuts.png?raw=true)

Now when you press that shortcut on an active window the script should launch and tell SizeUp to set the window geometry.

## MacOS Security

The first time that you run SizeUp you will have to grant it permissions to control the applications to change the window geometry.

The first time you run a Sizeup Plus script through FastScripts you will have to grant it permissions to control SizeUp.
After that you should not see any more permission issues.

## Support

Since I give this away for free, and if you would like to keep seeing more things like this, then please consider
a contribution to *Joel's Coffee Fund* at **Smallrock Internet** to help keep the good stuff coming :)<br />

[![Donate](.common/Donate-Paypal.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=XPUGVGZZ8RUAA)

## Contributing

We are always looking for ways to make the template better. But remember: Keep it simple. Keep it minimal. Don't add every single feature just because you can, add a feature when a feature is required.

## Authors and Acknowledgments

* Joel Mussman

The Joel's Tools logo was inspired by an image found at https://www.pngwing.com/.

<hr>
Copyright © 2020 Joel Mussman. All rights reserved.