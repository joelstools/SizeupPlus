# SizeupPlus.scpt
# Copyright © 2020 Joel Mussman. All rights reserved.
#
# This script is released under the MIT license.
#
# This script positions to SizeUp by Irradiated Software leaves off (http://www.irradiatedsoftware.com/sizeup/).
# It was inspired by a suggestion from Irradiated Software to use scripts to control SizeUp. FastScript from
# Red Sweater Software (https://www.red-sweater.com/fastscripts/) is the recommended # solution for creating
# shortcuts to run the script (although you can use Automator or other solutions).
#
# The focus of the script is to resize and position the current window in ways that SizeUp does not incorporate.
# Because FastScript does not have any way to pass arguments when it launches a script or program, the name that
# the script is saved with controls what the script tells SizeUp to do. Unlike SizeUp which resizes based on
# the halves and quarters of the screen, this script moves the window and sets the size based on what the
# user tells it through the script name. The naming options for deployment are:
#
#	spTopLeft-[Width]x[Height]
#	spTopCenter-[Width]x[Height]
#	spTopRight-[Width]x[Height]
#	spMiddleLeft-[Width]x[Height]
#	spMiddleCenter-[Width]x[Height]
#	spMiddleRight-[Width]x[Height]
#	spBottomLeft-[Width]x[Height]
#	spBottomCenter-[Width]x[Height]
#	spBottomRight-[Width]x[Height]
#	spOrigin-[Width]x[Height]
#	sp[xOffset]x[yOffset]-[width]x[height]
#
#	Middle is halfway vertical, while Center is halfway horizontal. Origin will change the size, but not the
#	upper-left corner of the window. Replace the [Width] and [Height] with the desired width and height
#	of the window.
#
#	Carefully follow FastScripts instructions for where to put the script(s). Make sure you leave it out
#	of any Applications folder where FastScripts will bind it to a particular application.
#
# Implemntation details:
#
#	Contrary to popular believe you can use regular expressions inside of AppleScript by
#	leveraging the Foundation framework. This script includes a good example of that.
#
# 	NSScreen's mainScreen is always the screen with the window that has focus; the frame in mainScreen
# 	has the origin and size of hte window.
#
#	 It was the "Access NSScreen.scpt" script (https://gist.github.com/henryroe/8810193) that gave me
# 	the understanding of how to read the width and height from the frame.
#
# 	I had trouble running the script from the shortcut until I realized that I needed to
# 	grab the application name and then force it to reactivate just prior to issuing the
# 	resize command.
#
#	SizeUp is used because the script will trigger a security question for each application window that it
#	would try to modify directly. By using SizeUp one security question is hit to ask if FastScripts can
#	control SizeUp, and SizeUp has already been granted control to resize and move windows.
#

use AppleScript version "2.4" # Yosemite (10.10) or later
use framework "Foundation"
use scripting additions

property NSRegularExpressionCaseInsensitive : a reference to 1
property NSRegularExpression : a reference to current application's NSRegularExpression
property NSNotFound : a reference to 9.22337203685477E+18 + 5807 -- see http://latenightsw.com/high-sierra-applescriptobjc-bugs/


# parseScriptName
# Return a four-element list containing the vertical and horizontal positions along with the width and the height.
#

on parseScriptName(name)
	
	set nsStringName to current application's NSString's stringWithString:name
	set pattern to "sp(Top|Middle|Bottom|Origin|\\d+x)(Left|Center|Right|\\d+-)?-?(\\d+)x(\\d+)"
	set regex to NSRegularExpression's regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive |error|:(missing value)
	set matches to regex's matchesInString:nsStringName options:0 range:{0, nsStringName's |length|()}
	set parts to {"", "", "", ""}
	
	# There will be one top-level match with the four captures underneath it
	
	repeat with aMatch in matches
		
		# Ignore the top level match, it is the whole original input; just spin through the captures
		#
		# set wholeRange to (aMatch's rangeAtIndex:0) as record
		# set wholevalue to text ((wholeRange's location) + 1) thru ((wholeRange's location) + (wholeRange's |length|)) of sample
		
		set numRanges to aMatch's numberOfRanges as integer
		
		repeat with rangeIndex from 1 to numRanges - 1
			set partRange to (aMatch's rangeAtIndex:rangeIndex) as record
			if partRange's location is not NSNotFound then
				set item rangeIndex of parts to text ((partRange's location) + 1) thru ((partRange's location) + (partRange's |length|)) of name
            end if
		end repeat
	end repeat
	
	set item 3 of parts to item 3 of parts as integer
	set item 4 of parts to item 4 of parts as integer
	return parts
end parseScriptName


# getScriptName
# Return the script name that is running
#

on getScriptName()
	
	# Get the path to the script file
	
	tell application "System Events"
		set myname to name of (path to me)
		set extension to name extension of (path to me)
	end tell
	
	# Strip off the extension
	
	if length of extension > 0 then
		# Make sure that `text item delimiters` has its default value here.
		set myname to items 1 through -(2 + (length of extension)) of myname as text
	end if
	
	return myname
end getScriptName


# getFrontApplicationName
# Return the name of the application that has focus
#

on getFrontApplicationName()
	
	tell application "System Events"
		set frontApp to first application process whose frontmost is true
		set frontAppName to name of frontApp
	end tell
	
	return frontAppName
end getFrontApplicationName


# min
# Choose the minimum value of two numbers
#

on min(x, y)
	if x ≤ y then
		return x
	else
		return y
	end if
end min


# main
# The main function of the program
#

on main()
	try
		
		set frontAppName to getFrontApplicationName()
		set scriptName to getScriptName()
		set newOrigin to parseScriptName(scriptName)
		
		# Break apart newOrigin
		
		set vertical to item 1 of newOrigin
		set horizontal to item 2 of newOrigin
		set windowWidth to item 3 of newOrigin as integer
		set windowHeight to item 4 of newOrigin as integer
		
		set originValueString to "\"" & scriptName & "\" -> { " & vertical & ", " & horizontal & ", " & windowWidth & ", " & windowHeight & " }"
		
		# Debugging statement left intact for future use
		# display dialog scriptName & ": " & originValueString
		
		# Check the results
		
		if windowWidth > 0 and windowHeight > 0 then
			
			# Get the width and height of the screen.
			
			# These references are left just to show how we got to the frame
			#
			# set mousePosition to current application's NSEvent's mouseLocation()
			# set allScreens to current application's NSScreen's screens()
			# set currentScreen to current application's NSScreen's mainScreen()
			
			set currentFrame to current application's NSScreen's mainScreen's visibleFrame() # returns {{0, 0}, {width, height}}, minus the dock if on-screen
			set screenWidth to item 1 of item 2 of currentFrame
			set screenHeight to item 2 of item 2 of currentFrame
			
			# Do not let the window width and height exceed the screen size.
			
			set windowWidth to min(windowWidth, screenWidth)
			set windowHeight to min(windowHeight, screenHeight)
			
			if windowWidth is equal to 0 and windowHeight is equal to 0 then
				display dialog ¬
					"SizeupPlus: cannot parse width and height from script name: " & originValueString & ". Please follow the script naming instructions."
				return
			end if
			
			# Calculate the origin based on the script file name.
			
			set xOffset to 0
			set yOffset to 0
			set offsetSet to false
			
			# The origin could be entered as two numbers (with trailing - and x) so try that first
			
			try
				set xOffset to (text 1 thru -2 of horizontal) as integer
				set yOffset to (text 1 thru -2 of vertical) as integer
				set offsetSet to true
			end try
			
			# If the origin is not numeric then check the values
			
			if not offsetSet then
				if vertical is equal to "Top" then
					set yOffset to 0
				else if vertical is equal to "Middle" then
					set yOffset to (screenHeight / 2) - (windowHeight / 2)
				else if vertical is equal to "Bottom" then
					set yOffset to (screenHeight - windowHeight)
				else if vertical is equal to "Origin" then
					set yOffset to -1
				else
					display dialog ¬
						"SizeupPlus: cannot parse vertical from script name: " & originValueString & ". Please follow the script naming instructions."
					return
				end if
				
				if horizontal is equal to "Left" then
					set xOffset to 0
				else if horizontal is equal to "Center" then
					set xOffset to (screenWidth / 2) - (windowWidth / 2)
				else if horizontal is equal to "Right" then
					set xOffset to (screenWidth - windowWidth)
				else if horizontal is equal to "" then
					set xOffset to -1
				else
					display dialog ¬
						"SizeupPlus: cannot parse horizontal from script name: " & originValueString & ". Please follow the script naming instructions."
					return
				end if
			end if
			
			# We have to reactivate the application that was active when we entered,
			# then we can tell SizeUp to set the window size.
			
			tell application frontAppName
				activate
				if yOffset is equal to -1 then
					tell application "SizeUp" to resize to {windowWidth, windowHeight}
				else
					tell application "SizeUp" to move and resize to {xOffset, yOffset, windowWidth, windowHeight}
				end if
			end tell
			
		else
			
			display dialog "SizeupPlus: cannot parse script name: " & originValueString & ". Please follow the script naming instructions."
		end if
		
	on error the errorMessage number the errorNumber
		
		# Catch any other error messages; normally we don't want to reveal internal workings to the user so
		# simply tell them something happened.
		#		
		# display dialog "SizeupPlus: error " & errorNumber & " : " & errorMessage
		
		display dialog "SizeupPlus: internal error."
	end try
end main

main()