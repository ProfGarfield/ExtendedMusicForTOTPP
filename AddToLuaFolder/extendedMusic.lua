
local linesPerWindow = 20
local settings = require("extendedMusicSettings")
if settings.disable then
    return
end

math.randomseed(os.time())
-- Helper Functions

local func = require("functions")

local function inTable(object,table)
    for key,value in pairs(table) do
        if value == object then
            return true
        end
    end
    return false
end

-- text.addMultiLineTextToDialog(text,dialogObject) --> void
-- adds text that is in multiple lines to a dialog object,
-- performing all necessary splitlines
local function addMultiLineTextToDialog(text,dialog)
    local lineTable = {func.splitlines(text)}
    for i=1,#lineTable do
        dialog:addText(lineTable[i])
    end
end

--  Menu Table Specification
--  menuTable[i]=optionName is the i'th option that will appear in the menu
--  and menu will return i if option is chosen
--  optionName will be a string
--  start counting at 1, can skip numbers (incl. 1), but don't have other entries in table

-- text.menu(menuTable,menuText,menuTitle="",canCancel=false,menuPage=1)-->integer,integer
-- returns the key of the menu table of the option chosen, second parameter returns menu page of selection
-- menuText is displayed above the options
-- menuTitle is the title of the menu
-- canCancel if true, offers a 'cancel' option on each page, returns 0 if selected
--           if false, there is no cancel option
-- menuPage is the "page" of the menu that is to be opened
-- imageInfo a way to get an image, either key for the imageTable, an imageObject,
--          or a table of arguments for civ.ui.loadImage
--  Arguments 4,5,6 (canCancel,imageInfo,menuPage) can be in any order; the code will
--  figure out which is which
--local function menu(menuTable,menuText,menuTitle,canCancel, menuPage,imageInfo)
local function menu(menuTable,menuText,menuTitle,arg4, arg5,arg6)
    local canCancel = false
    local menuPage = 1
    local image = nil
    local function setArgument(arg)
        if type(arg) == "boolean" then
            canCancel = arg
        elseif type(arg) =="number" then
            menuPage = arg
        elseif type(arg) ~= "nil" then
            image = toImage(arg)
        end
    end
    setArgument(arg4)
    setArgument(arg5)
    setArgument(arg6)

    local menuTextLines = 1 -- changed from general library
    menuTitle = menuTitle or ""
    menuPage = menuPage or 1
    local menuTableEntries = 0
    local maxMenuIndex = 0
    for index,val in pairs(menuTable) do
        menuTableEntries = menuTableEntries+1
        if index > maxMenuIndex then
            maxMenuIndex = index
        end
    end
    -- find the number of options possible per window
    -- the 2 is the forward and backward 
    local optionsPerPage = linesPerWindow - menuTextLines - 2
    if canCancel then
        optionsPerPage = optionsPerPage -1
    end
    local numberOfMenuOptions = menuTableEntries
    if numberOfMenuOptions <= optionsPerPage+2 then
        local menuDialog = civ.ui.createDialog()
        menuDialog.title = menuTitle
        addMultiLineTextToDialog(menuText,menuDialog)
        for i=1,maxMenuIndex do
            if menuTable[i] then
                menuDialog:addOption(menuTable[i],i)
            end
        end
        if canCancel then
            menuDialog:addOption("Cancel",0)
        end
        if image then
            menuDialog:addImage(image)
        end
        return menuDialog:show(),1
    end
    -- menu has too many options, so must be split into multiple pages
    local numberOfPages = math.ceil(menuTableEntries/optionsPerPage)
    local menuDialog = civ.ui.createDialog()
    if menuPage > numberOfPages then
        menuPage = numberOfPages
    elseif menuPage < 1 then
        menuPage = 1
    end
    menuDialog.title = menuTitle.." Page "..tostring(menuPage).." of "..tostring(numberOfPages)
    addMultiLineTextToDialog(menuText,menuDialog)
    if menuPage < numberOfPages then
        menuDialog:addOption("Next Page",-2)
    end
    if menuPage > 1 then
        menuDialog:addOption("Previous Page",-1)
    end
    local actualEntriesCount = 0
    -- this allows for missing keys in the menuTable
    -- go through all possible menu entries, counting each valid entry
    -- when you reach an entry count corresponding to the menu page you are supposed
    -- to be on, start adding entries to the menu dialog, until you get beyond that point
    for j = 1,maxMenuIndex do
        if menuTable[j] then
            actualEntriesCount = actualEntriesCount+1
            if actualEntriesCount >= ((menuPage-1)*optionsPerPage)+1 and
                actualEntriesCount <= math.min(menuPage*optionsPerPage,menuTableEntries) then
                menuDialog:addOption(menuTable[j],j)
            end
        end
    end
    if canCancel then
        menuDialog:addOption("Cancel",0)
    end
    if image then
        menuDialog:addImage(image)
    end
    local choice = menuDialog:show()
    if choice == -2 then
        return menu(menuTable,menuText,menuTitle,canCancel,menuPage+1,image)
    elseif choice == -1 then
        return menu(menuTable,menuText,menuTitle,canCancel,menuPage-1,image)
    elseif choice == 0 then
        return 0,menuPage
    else
        return choice,menuPage
    end
end


-- gen.clearGapsInArray(table,lowestValue=1)-->void
-- Re-indexes all integer keys and values
-- in a table, so that there are no gaps.
-- Starts at lowestValue, and maintains order
-- of integer keys
-- Non integer keys (including other numbers)
-- and integers below lowestValue are left unchanged
local function clearGapsInArray(table,lowestValue)
    lowestValue = lowestValue or 1
    local largestIndex = lowestValue-1
    for index,val in pairs(table) do
        if type(index) == "number" and index > largestIndex then
            largestIndex = index
        end
    end
    local nextIndex = lowestValue
    for i=lowestValue,largestIndex do
        if table[i] ~= nil then
            if nextIndex < i then
                table[nextIndex] = table[i]
                table[i] = nil
            end
            nextIndex = nextIndex+1
        end
    end
end


-- all integer values in the table are re-indexed so that they 
-- start at 1 and proceed without gaps
-- all other keys are ignored
local function makeArrayOneToN(table)
    local lowestIntKey = math.huge
    local highestIntKey = -math.huge
    local function isInt(number)
        return type(number)=="number" and number == math.floor(number)
    end
    local tempTable = {}
    for key,value in pairs(table) do
        if isInt(key) then
            if key < lowestIntKey then
                lowestIntKey = key
            end
            if key > highestIntKey then
                highestIntKey = key
            end
            tempTable[key] = value
            table[key] = nil
        end
    end
    local newIndex = 1
    for i=lowestIntKey,highestIntKey do
        if tempTable[i] ~= nil then
            table[newIndex] = tempTable[i]
            newIndex = newIndex+1
        end
    end
end

--#gen.copyTable(table)-->table
-- constructs (and returns) a new table with the same keys as the input
-- tables within the table are also copied
local function copyTable(table)
    if type(table) ~= "table" then
        return table
    end
    local newTable = {}
    for key,value in pairs(table) do
        newTable[key] = copyTable(value)
    end
    return newTable
end

-- Found this code on stackoverflow.com
-- https://stackoverflow.com/questions/5303174/how-to-get-list-of-directories-in-lua
local function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen([[dir "]]..directory..[[" /b]])
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

-- shuffle list, found code here
--https://www.programming-idioms.org/idiom/10/shuffle-a-list/2019/lua
function shuffleList(list)
	for i = #list, 2, -1 do
		local j = math.random(i)
		list[i], list[j] = list[j], list[i]
	end
end

--for key,val in pairs(scandir(civ.getToTDir().."\\Music")) do
--    print(key,val)
--end

local mp3List = {}
local mp3ListIndex = 1
local musicDirectoryFiles =scandir(civ.getToTDir().."\\Music") 
local isMp3 = {}
for key,fileName in pairs(musicDirectoryFiles) do
    if string.sub(fileName,-4,-1) == ".mp3" then
        mp3List[mp3ListIndex] = fileName
        mp3ListIndex = mp3ListIndex +1
        isMp3[fileName] = true
    end
end


local playlists = copyTable(settings.playlist)
-- build the 'everything' playlist
if settings.playlist[0] then
    local excludedFiles = {}
    for key,value in pairs(settings.playlist[0]) do
        if type(key) == "number" then
            excludedFiles[value] = true
        end
    end
    playlists[0] = {}
    playlists[0].name = settings.playlist[0].name
    playlists[0].randomize = settings.playlist[0].randomize
    local idx = 1
    for key, fileName in pairs(mp3List) do
        if not excludedFiles[fileName] then
            playlists[0][idx] = fileName
            idx = idx + 1
        end
    end
end
for number,playlist in pairs(settings.playlist) do
    if number ~= 0 then
        playlists[number] = playlist
    end
end

makeArrayOneToN(playlists)
for key, playlst in pairs(playlists) do
    makeArrayOneToN(playlst)
    if playlst.randomize then
        shuffleList(playlst)
    end
end



local pickMusic = settings.PICKMUSICTOT

local function validatePlaylist(playlist)
    local allFilesFound = true
    for key,fileName in pairs(playlist) do
        if type(key) == "number" and not isMp3[fileName] then
            print(tostring(playlist.name).." playlist has bad file name of "..tostring(fileName))
            allFilesFound = false
        end
    end
    return allFilesFound
end

local allFilesFound = true
for key,value in pairs(playlists) do
    allFilesFound =  validatePlaylist(value) and allFilesFound 
end
if not allFilesFound then
    civ.ui.text("There are invalid file names in your playlists.  See the console for more information.")
    error("The above files were not found in the Music directory.  Please change extendedMusicSettings.lua.")
end

local extendedMusicTrack = 0
local allFilesFound = true
for i=0,#pickMusic do
    if (not isMp3[pickMusic[i]]) and pickMusic[i] ~= "EXTENDED-MUSIC" then
        print("PICKMUSICTOT playlist has bad file name of "..tostring(fileName))
        allFilesFound = false
    end
    if pickMusic[i] == "EXTENDED-MUSIC" then
        extendedMusicTrack = i
    end
end
if not allFilesFound then
    civ.ui.text("A bad file name for PICKMUSICTOT was found.  See the console for more information.")
    error("The above files were not found in the Music Directory.  Please update PICKMUSICTOT in extendedMusicSettings.lua")
end



local activePlaylist = false -- if activePlaylist is false, then play tracks in standard fashion
local activePlaylistTrack = 1


local pickMusicMax = #pickMusic
local function randomPickMusicTrack()
    local choice = math.random(2,pickMusicMax)
    if pickMusic[choice] == "EXTENDED-MUSIC" then
        return randomPickMusicTrack()
    else
        return choice
    end
end

local changePlaylist = nil

local function playFromPlaylist(playlistJustChanged)
    if not activePlaylist then
        return changePlaylist()
    end
    local menuTable = {}
    if not playlistJustChanged then
        menuTable[1] = "Continue Playing "..activePlaylist[activePlaylistTrack]:sub(1,-5)
    end
    menuTable[2] = "Change Playlist"
    local offset = 3
    for i=1,#activePlaylist do
        menuTable[i+3] = activePlaylist[i]:sub(1,-5)
    end
    local menuText = activePlaylist.name
    local menuTitle = "Extended Music"
    local choice = menu(menuTable, menuText, menuTitle)
    if choice == 1 then
        return
    elseif choice == 2 then
        return changePlaylist()
    else
        activePlaylistTrack = choice - offset
        civ.playMusic(activePlaylist[activePlaylistTrack])
        return
    end
end

changePlaylist = function()
    if next(playlists) == nil then
        -- no registered playlists
        local dialog = civ.ui.createDialog()
        dialog.title = "Extended Music"
        dialog:addText("There are no registered playlists.  You can add a playlist by modifying extendedMusicSettings.lua, which can be found in "..civ.getToTDir().."\\lua")
        dialog:show()
        return
    end
    local menuTable = {}
    if activePlaylist then
        menuTable[1] = "Keep using "..activePlaylist.name
    end
    menuTable[2] = "Use the Pick Music Menu"
    local offset = 3
    for key,plist in pairs(playlists) do
        menuTable[key+offset] = plist.name
    end
    menuText = "Choose a playlist.  Playlists can be changed by modifying "..civ.getToTDir().."\\lua\\extendedMusicSettings.lua"
    menuTitle = "Extended Music"
    local choice = menu(menuTable,menuText,menuTitle)
    if choice == 1 then
        return
    elseif choice == 2 then
        activePlaylist = false
        activePlaylistTrack = 1
        return
    else
        activePlaylist = playlists[choice-offset]
        activePlaylistTrack = 1
        return playFromPlaylist(true)
    end
end

local function onSelectMusic(track)
    if track and pickMusic[track] then
        -- funeral march/ ode to joy or track picked from pick music menu
        -- and the track is actually in the pick music tracks from settings
        if pickMusic[track] == "EXTENDED-MUSIC" then
            local previousTrack = activePlaylistTrack
            local previousPlaylist = activePlaylist
            playFromPlaylist()
            if previousTrack == activePlaylistTrack and previousPlaylist == activePlaylist and activePlaylist then
                return track
            elseif activePlaylist then
                civ.playMusic(activePlaylist[activePlaylistTrack])
                return track
            else
                if track <= 2 then
                    civ.playMusic(pickMusic[3])
                    return 3
                else
                    civ.playMusic(pickMusic[track-1])
                    return track -1
                end
            end
        else
            civ.playMusic(pickMusic[track])
            return track
        end
    elseif track and (track == 0 or track == 1) then
        -- game trying to play ode to joy or funeral march, but nothing in PICKMUSICTOT
        -- so have the game play the default track
        return nil

    elseif track then
        -- or the track selected is not in the list
        civ.ui.text("The table PICKMUSICTOT does not have a file associated with track "..track..".  Please update extendedMusicSettings.lua.  Playing the default file for track "..track..".")
        return nil
    else
        -- game wants to play a random track (that is track == nil)
        if not activePlaylist then
            local choice = randomPickMusicTrack()
            civ.playMusic(pickMusic[choice])
            return choice
        else
            activePlaylistTrack = activePlaylistTrack + 1
            if activePlaylistTrack > #activePlaylist then
                activePlaylistTrack = 1
            end
            civ.playMusic(activePlaylist[activePlaylistTrack])
            return extendedMusicTrack
        end
    end
end

civ.scen.onSelectMusic(onSelectMusic)
