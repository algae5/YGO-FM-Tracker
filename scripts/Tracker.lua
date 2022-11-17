Tracker = {}

function Tracker.Wait(time)
    -- time - int number of frames to wait
    -- Simple function that advances frames- this is essentially a way to wait before
    -- Doing any more actions for time amount of frames
    -- While waiting, check to see if the click state has changed from frame to frame
    -- NOTE TO SELF: move click listener to separate function, and click handler to another
    for dummy = 1, time do 
        mouse = input.getmouse()
        if mouse.Left ~= lastClicked then
            if ((mouse.X > -50) and (mouse.X < 0)) and ((mouse.Y > 207) and (mouse.Y < 231)) then
                clickCount = clickCount + 1
                lastClicked = ( not(lastClicked))
            else
                clickCount = 0
                lastClicked = ( not(lastClicked))
            end
        end
        if (clickCount > 1) then
            if mouse.Left then 
                clickCount = 1
            else
                clickCount = 0
                viewFull = ( not(viewFull))
                break
            end
        end
        emu.frameadvance()
    end
end

function Tracker.ReadDeck()
    -- Creates a table, deck, representing the deck of cards currently equipped by
    -- the player. Sorted by type, ascending. Reads the deck from memory
    address = 0x1D0200
    for dummy = 1, 40 do
        card = memory.readbyte(address)
        card = card + (256 * memory.readbyte(address + 1))
        address = address + 2
        if card == 0 then break end
        typeNumber = CARDS[card].Type
        if deck[typeNumber] then
            table.insert(deck[typeNumber], (card))
        else
            deck[typeNumber] = {card}
        end
    end

    -- After every card is collected, change the cards of type 20-23 into a Histogram
    -- Instead of an array, to simplify rendering
    Tracker.SortNonMonsters()
end

function Tracker.SortNonMonsters()
    for i = 20, 23 do
        if deck[i] then
            subDeck = {}
            for j = 1, #(deck[i]) do
                if subDeck[deck[i][j]] then
                    subDeck[deck[i][j]] = subDeck[deck[i][j]] + 1
                else
                    subDeck[deck[i][j]] = 1
                end
            end
            deck[i] = subDeck
        end
    end
end