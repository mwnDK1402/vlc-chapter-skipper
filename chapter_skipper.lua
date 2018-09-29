-- chapter_skipper.lua -- VLC extension
--[[
Feel free to mail me with suggestions/improvements!

INSTALLATION:
Put the file in the VLC subdir /lua/extensions, by default:
* Windows (all users): %ProgramFiles%\VideoLAN\VLC\lua\extensions\
* Windows (current user): %APPDATA%\VLC\lua\extensions\
* Linux (all users): /usr/share/vlc/lua/extensions/
* Linux (current user): ~/.local/share/vlc/lua/extensions/
* Mac OS X (all users): /Applications/VLC.app/Contents/MacOS/share/lua/extensions/
(create directories if they don't exist)
Restart the VLC or in the VLC "Tools | Plugins and Extensions" item,
select "Reload Extensions"

USAGE:
	Go to the "View" menu and select "Chapter Skipper".

LICENSE:
	Go wild!
--]]

function descriptor()
	return {
		title = "Chapter Skipper",
		author = "Victor Pascu <victor.pscu@gmail.com>",
		version = 0.1,
		shortdesc = 'Chapter Skipper',
		url = 'https://github.com/VictorPascu',
		description = "This extension will skip a specified chapter when your video reaches it.",
		capabilities = {"input-listener"}
	}
end

-- local config = require "chapter_skipper_config"

keep_checking = true --to disable the check loop on deactivation
chapterToSkip = -1

--Run on plugin activation
function activate()
	vlc.playlist.pause()
	d = vlc.dialog("Chapter Skipper")
	d:show()
	d:add_label( "This extension will periodically check the chapter your video is at, with the first chapter being 0. ", 2, 1, 1, 1 )
	d:add_label( "It cause VLC to become unresponsive, but it will return to normal after the skip.", 2, 2, 1, 1 )
	d:add_label( "You can move the 'extension not responding' screen to another monitor to minimize viewing impact.", 2, 3, 1, 1 )

	fullscreenOption = d:add_check_box( "Go to fullscreen", true, 2, 4, 1, 1)
	restartOption = d:add_check_box( "Restart video", true, 2, 5, 1, 1)

	d:add_label( "Chapter # to skip", 1, 1, 1, 1 )
	chapterToSkipInput = d:add_text_input( 1, 1, 2, 1, 1 )
	d:add_button("Enable", click_Start, 1, 3, 1, 1)
	d:add_button("Disable", click_Disable, 1, 4, 1, 1)
end

--Verify input options and enter check loop
function click_Start()
	vlc.msg.info("Enabling chapter skipper")
	chapterToSkip = tonumber(chapterToSkipInput:get_text())
	vlc.msg.info("Target chapter:")
	vlc.msg.info(chapterToSkip)
	vlc.playlist.play()

	if restartOption:get_checked() then
		vlc.var.set(vlc.object.input(), "time", 0)
	end

	if fullscreenOption:get_checked() then
		vlc.video.fullscreen()
	end	

	d:hide()

	start_checker()
end

--Disable check loop.
function click_Disable()
	d:hide()
	vlc.msg.info("Disabled chapter skipper")
	deactivate()
end

--Start chapter skip loop
function start_checker()
	keep_checking = true

	vlc.msg.info("Running chapter skipper")

	while keep_checking do
		chapter_skip_check()
	end

	vlc.msg.info("Ending chapter skipper")
end

--Run on plugin deactivation
function deactivate()
	keep_checking = false
	vlc.msg.info("Deactivated chapter skipper")
end

-- If the current chapter matches the one we want to skip, skip it.
-- There's room for improvement here with chapter lists (instead of just one),
-- but that's probably for a future version.
function chapter_skip_check()
	if get_chapter() == chapterToSkip then
		vlc.msg.info("Skipping chapter")
		skip_chapter()
		deactivate()
	end
end

-- Get chapter number
function get_chapter()
	return vlc.var.get(vlc.object.input(), "chapter") 	
end

-- Skip wrapper
function skip_chapter()
	titlechap_offset('chapter', 1)
end

-- VLC's function for changing chapters
function titlechap_offset(var,offset)
    local input = vlc.object.input()
    vlc.var.set( input, var, vlc.var.get( input, var ) + offset )
end

function meta_changed()
end