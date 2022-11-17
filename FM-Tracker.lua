-- Yu Gi Oh Forbidden Memories Tracker
-- Created by algae5
-- Card data and icons via YGO-FM-Database

-- Check the version of BizHawk that is running (Code from besteon's ironMON tracker)
if string.sub(client.getversion(), 1) ~= "2.8" then
	print("This version of BizHawk is not supported. Please update to version 2.8 or higher.")
	return
end

-- Import scripts and data
dofile("data/Cards.lua")
dofile("data/Types.lua")
dofile("scripts/Tracker.lua")
dofile("scripts/Render.lua")

-- Initialize the window, setting size and area for the tracker
Render.Window()
Render.ToggleButton()

-- Initialize to condensed view (These initializations should be relocated)
viewFull = false
clickCount = 0
lastClicked = input.getmouse().Left

while true do
    -- Initialize a blank deck every cycle, and re-read it from the memory
    deck = {}
    Tracker.ReadDeck() 

    -- A small wait cycle so the deck is not built and rendered on the same frame
    Tracker.Wait(2)

    -- Render the deck in the chosen fashion
    if viewFull then
        Render.Full()
    else
        Render.Condensed()
    end

    -- Wait for 1000 frames
    -- Not certain if rendering is the only expensive operation, in which case
    -- I can constantly verify if the deck has changed by re-tallying it and
    -- comparing, instead of only doing it randomly every 1000 seconds.
    Tracker.Wait(1000)
end

-- Due to Nymashock not implementing memory callbacks, cannot use event.onmemorywrite
