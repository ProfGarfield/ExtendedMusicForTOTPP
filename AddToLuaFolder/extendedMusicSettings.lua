-- If you want to disable extended music, change the false in the next line to true
if false then -- change this to "if true then" (without quote marks) to disable extended music
    return {disable = true}
end
--
-- Note that any line starting with a -- is a comment
-- as is anything between --[[ and --]]
-- You can write playlists of files in the Music folder
local playlist = {}

-- You are allowed to skip numbers for playlists, and to have the same playlist twice

playlist[1] = {
name = "Classic Civ II Music",    -- this is the name that will appear in the extended menu
randomize = true,   -- if randomize is set to true, the tracks will play in any order; if false or absent, the tracks will only play in order
"Tenochtitlan Revealed.mp3",
"Harvest of the Nile.mp3",
"Aristotle's Pupil.mp3",
"Augustus Rises.mp3",
"Gautama Ponders.mp3",
"Hammurabi's Code.mp3",
"The Shining Path.mp3",
}

playlist[2] = {
name = "Multiplayer Gold Edition Music",
randomize = true,
"Crusade.mp3",
"Alien.mp3",
"Mongol Horde.mp3",
"The Apocalypse.mp3",
"Jurassic Jungle.mp3",
"New World.mp3",
"Tolkien.mp3",
"Mars Expedition.mp3",
"Jules Verne.mp3",
}

playlist[3] ={
name = "Conflicts in Civilization Music",
randomize = true,
"Tenochtitlan Revealed.mp3",
"Harvest of the Nile.mp3",
"Aristotle's Pupil.mp3",
"Augustus Rises.mp3",
"Gautama Ponders.mp3",
"Hammurabi's Code.mp3",
"The Shining Path.mp3",
"The Civil War.mp3",
"Crusade.mp3",
"The Great War.mp3",
"American Revolution.mp3",
"Jihad.mp3",
"Alien.mp3",
"Mongol Horde.mp3",
"The Apocalypse.mp3",
}

playlist[4] ={
name = "Fantastic Worlds Music",
randomize = true,
"Tenochtitlan Revealed.mp3",
"Harvest of the Nile.mp3",
"Aristotle's Pupil.mp3",
"Augustus Rises.mp3",
"Gautama Ponders.mp3",
"Hammurabi's Code.mp3",
"The Shining Path.mp3",
"The Civil War.mp3",
"Crusade.mp3",
"The Great War.mp3",
"American Revolution.mp3",
"Jihad.mp3",
"Alien.mp3",
"Mongol Horde.mp3",
"The Apocalypse.mp3",
"Jurassic Jungle.mp3",
"New World.mp3",
"Tolkien.mp3",
"Mars Expedition.mp3",
"Jules Verne.mp3",
"They're Here.mp3",
}

playlist[5] = {
name = "All Civilization Music",
randomize = true,
"Crusade.mp3",
"Alien.mp3",
"Mongol Horde.mp3",
"The Apocalypse.mp3" ,
"Jurassic Jungle.mp3",
"New World.mp3",
"Tolkien.mp3",
"Mars Expedition.mp3",
"Jules Verne.mp3",
"They're Here.mp3",
"The Dome.mp3",
"Tenochtitlan Revealed.mp3",
"Harvest of the Nile.mp3",
"Aristotle's Pupil.mp3",
"Augustus Rises.mp3",
"Gautama Ponders.mp3",
"Hammurabi's Code.mp3",
"The Shining Path.mp3",
"The Civil War.mp3",
"The Great War.mp3",
"American Revolution.mp3",
"Jihad.mp3",
}

-- playlist[0] is special
-- playlist[0] includes all .mp3 files in <Test of Time Directory>\Music
-- EXCEPT for any files listed here
-- If you don't want this playlist to be available, simply delete it 
-- or comment it out (use -- to make the rest of a line a comment, or --[[ to start comments
-- and --]] to end them
playlist[0] = {
name = "All Available Music",
randomize = true,
"Funeral March.mp3", -- we don't want to play the funeral march randomly
"Ode to Joy.mp3", -- we don't want to play the We Love the ____ Day music randomly

}


-- The files in this list determine what file is played
-- when the player chooses a track from the Pick Music Menu
local PICKMUSICTOT = {}

-- This file will be played when a Civilization is destroyed
PICKMUSICTOT[0] = "Funeral March.mp3" 
-- This file will be played when a city begins celebrating We Love the _____ Day
PICKMUSICTOT[1] = "Ode to Joy.mp3"
PICKMUSICTOT[2] = "EXTENDED-MUSIC" -- Setting a track to "EXTENDED-MUSIC" will open a menu in game to change
                                    -- playlists or select music from the currently active playlist
                                    -- Don't use tracks 0 or 1 for this
PICKMUSICTOT[3] = "Alien.mp3"
PICKMUSICTOT[4] = "Mongol Horde.mp3"
PICKMUSICTOT[5] = "The Apocalypse.mp3" -- note: In the Pick Music Menu, this is spelled "The Apocolypse.mp3", but this file name is correct
PICKMUSICTOT[6] = "Jurassic Jungle.mp3"
PICKMUSICTOT[7] = "New World.mp3"
PICKMUSICTOT[8] = "Tolkien.mp3"
PICKMUSICTOT[9] = "Mars Expedition.mp3"
PICKMUSICTOT[10] = "Jules Verne.mp3"
PICKMUSICTOT[11] = "They're Here.mp3"
PICKMUSICTOT[12] = "The Dome.mp3"
PICKMUSICTOT[13] = "Crusade.mp3"

-- You may wish to replace @PICKMUSICTOT with the following,
-- to include all the Civilization Music Provided
-- This is done in the Game.txt file 
-- If you comment out the @PICKMUSICTOT in an extended original game,
-- or in a scenario (I think any game where the leftmost menu menu is 'Game')
-- It will refer to @PICKMUSICTOT in the Original folder
-- If you comment out the @PICKMUSICTOT in a Midgard game, it will refer to the
-- @PICKMUSICTOT in the Fantasy directory
--
--
--
--[[
@PICKMUSICTOT
@width=480
@title=Select Music
@options
"Funeral March"
"Ode to Joy"
"Choose Playlist"
"Alien"
"Mongol Horde"
"The Apocolypse"
"Jurassic Jungle"
"New World"
"Tolkien"
"Mars Expedition"
"Jules Verne"
"They're Here"
"The Dome"
"Crusade"
"Tenochtitlan Revealed"
"Harvest of the Nile"
"Aristotle's Pupil"
"Augustus Rises"
"Gautama Ponders"
"Hammurabi's Code"
"The Shining Path"
"The Civil War"
"The Great War"
"American Revolution"
"Jihad"
]]


-- (these can stay here even if you don't change the @PICKMUSICTOT information)
PICKMUSICTOT[14] = "Tenochtitlan Revealed.mp3"
PICKMUSICTOT[15] = "Harvest of the Nile.mp3"
PICKMUSICTOT[16] = "Aristotle's Pupil.mp3"
PICKMUSICTOT[17] = "Augustus Rises.mp3"
PICKMUSICTOT[18] = "Gautama Ponders.mp3"
PICKMUSICTOT[19] = "Hammurabi's Code.mp3"
PICKMUSICTOT[20] = "The Shining Path.mp3"
PICKMUSICTOT[21] = "The Civil War.mp3"
PICKMUSICTOT[22] = "The Great War.mp3"
PICKMUSICTOT[23] = "American Revolution.mp3"
PICKMUSICTOT[24] = "Jihad.mp3"


return {
    playlist = playlist,
    PICKMUSICTOT = PICKMUSICTOT,
}
