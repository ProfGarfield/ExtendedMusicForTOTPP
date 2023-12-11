# Extended Music For TOTPP

## Purpose

This module adds to the [Test of Time Patch Project](https://forums.civfanatics.com/threads/the-test-of-time-patch-project.517282/) by allowing the user to play extra music they add to their Music directory (in the form of .mp3 files), and by allowing them to create playlists and select from these playlists within the game.

It also provides all the Civilization II Music converted to .mp3 files as required for the Test of Time Patch Project DirectShow Music patch.

## Requirements

Test of Time Patch Project Version 0.18.1 or later.

## Installation

Download the contents of this repository.  Towards the top right of this page, there is a green button labeled "Code".  Click on it and select Download Zip.  Download the contents of this repository.  This is a fairly large download since it contains all the Civilization II Music.

In your Test of Time directory, there is a folder called `lua`.  Copy the files in the `AddToLuaFolder` directory from the download to the `lua` folder.  You will be asked to replace the existing init.lua file.  Do so.  It comes with the TOTPP download, so it is easy to replace if you need to.

If your Test of Time directory already has a `Music` folder (as it will if you have already been using the DirectShow Music Patch), move it out of your Test of Time folder.

Copy the downloaded Music folder and all its contents into the Test of Time directory.  If you were using the old "CustomMusicForTOTPP" patch, you may have music files you wish to add into the new Music folder.  Having this music folder and its contents is essential to making sure the sample playlists work properly.

If you haven't already, enable the DirectShow Music patch in the TOTPPlauncher.  Also, make sure that the Lua Scripting and Lua Scenario Events patches are enabled.

### Optional Installation Instruction

Find the `Game.txt` files for games that you play regularly.  For example, in the `Original` and `Fantasy` folders.  (The Game.txt file in the Test of Time directory won't do anything.)  Open these files and search for the line

`@PICKMUSICTOT`

It should look something like this:

```
@PICKMUSICTOT
@width=480
@title=Select Music
@options
"Funeral March"
"Ode to Joy"
"Crusade"
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
```

Comment out these lines by placing a semicolon as the first character of each line (or, delete these lines), like so:

```
;@PICKMUSICTOT
;@width=480
;@title=Select Music
;@options
;"Funeral March"
;"Ode to Joy"
;"Crusade"
;"Alien"
;"Mongol Horde"
;"The Apocolypse"
;"Jurassic Jungle"
;"New World"
;"Tolkien"
;"Mars Expedition"
;"Jules Verne"
;"They're Here"
;"The Dome"
```

Then, add in the following lines in their place:
```
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
```

If you comment out the lines without replacing them in an Extended Original game (or most scenarios), Civ II will default to the information in the `Game.txt` file in the `Original` folder.  Similarly, if the lines are commented out in the Midgard scenario, the game will refer to the file in the `Fantasy` folder.

The folder ModifiedGameTxt contains Game.txt files to replace the standard files, if you don't want to make the changes yourself.

## Usage

### Choosing a Playlist in Game

In order to choose a playlist in game, open the Pick Music Menu, and choose the third option.  If you changed `@PICKMUSICTOT` as suggested above, this line will be called "Choose Playlist".  Otherwise, it will be called "Crusade".  Selecting this option will open the menu to choose a playlist or to select a particular track in the playlist.

Note that some Lua scenarios may override this option with their own custom music.

### Creating and Changing Playlists

One of the default playlists contains all the .mp3 files in the Music Folder (except Ode to Joy and the Funeral March).  If that's all you're interested in, you don't have to do anything.

In order to create or change a playlists, open the file `extendedMusicSettings.lua`.  If you are ever having trouble with this file, you can disable custom music by making the following change to `init.lua`:
```lua
-- To disable extended music, comment out the next line
require("extendedMusic")
```
Comment out the `require("extendedMusic")` line by placing 2 dashes at the start
```lua
-- To disable extended music, comment out the next line
--require("extendedMusic")
```

To create a new playlist, write a line
```lua
playlist[X] = {
```
where X is a number that hasn't been used for a playlist already.  (If you do reuse a number, only the playlist defined later in the file will exist.)

Next, choose a name for the playlist, and put it on the next line as shown:
```lua
playlist[X] = {
name = "My Playlist Name",
}
```
`name` must be lowercase, and the name must start and end with quotation marks (either both " or both ').  The name can't contain the type of quotation mark you use to surround the name.  So `"My 'Happy' Playlist"` is OK, but `"My "Happy" Playlist"` is not.
Now, decide if you want your playlist order randomized.  If so, the next line should be 
```lua
randomize = true,
```
If not, either omit the line, or write
```lua
randomize = false
```
After this, write the names of the files you wish to play.  Follow the same convention as for the name.  Surround the name with either " quotes, or ' quotes, and the type of quote mark you use can't be a part of the file name.  Finish the line off with a comma.
```lua
"Hammurabi's Code.mp3",
```
At the end of the playlist, add a `}` to close the `{` from the first line.

Here is an example playlist:
```lua
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
```

### The "Everything" Playlist

The `playlist[0]` is special.  It is built the same way as all the other playlists, but it contains all the .mp3 files in the Music folder, _except_ the files in the playlist.  If you don't want this playlist, you can delete it, or comment it out by adding -- to the start of each line of the playlist.

### Changing the Pick Music Menu Tracks

Towards the end of the extendedMusicSettings.lua file, there are a series of lines of the form
```lua
PICKMUSICTOT[X] = "Some Music File.mp3"
```
By changing the file names for these lines, you can change the music that is played when you choose the corresponding item in the Pick Music Menu.  (Note that you don't need to place a comma after each file name here.)  Two lines are particularly important:
```lua
PICKMUSICTOT[0] = "Funeral March.mp3" 
PICKMUSICTOT[1] = "Ode to Joy.mp3"
```
The `PICKMUSICTOT[0]` determines the file that will be played when a tribe is destroyed, while `PICKMUSICTOT[1]` determines the file that will be played when a city begins celebrating the We Love the Leader Day.

In addition, You can use `"EXTENDED-MUSIC"` (spelled exactly like that) to specify that a track number should instead open the playlist menu.  This is track number 2 (third track, but track numbers start at 0) by default.

## More Information

If you need further help with this extension, would like to report a bug, or have other comments on it, the best place to do so is in this [Civfanatics thread](https://forums.civfanatics.com/threads/totpp-custom-music-patch.650161/).



