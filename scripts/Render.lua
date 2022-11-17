Render = {}

function Render.Window()
    gui.use_surface("client")
    client.setwindowsize(3)
    client.SetGameExtraPadding(300, 0, 0, 0)
    gui.defaultTextBackground(0)
    -- Draw two rectangles in emucore, so they are in the background and not overwritten
    -- Can potentially only draw 1 when doing condensed view?
    gui.drawRectangle(5, 5, 150, 230, 0xFFBBBBBB, 0xFF222222, "emucore")
    gui.drawRectangle(160, 5, 150, 230, 0xFFBBBBBB, 0xFF222222, "emucore")
end

function Render.ToggleButton()
    -- Renders a button that when clicked, will toggle between condensed and full view
    gui.drawRectangle(250, 207, 50, 26, 0xFFDDDDDD, 0xFF227722, "emucore")
end

function Render.Full()
    -- Renders the full view of the deck
    -- Displays every single card, along with its type, name, and count in the deck
    -- Monsters also have their ATK/DEF displayed
    -- Sorted by type, ascending

    -- First, render toggle button text
    gui.drawText(790, 635, "Condensed", nil, nil, 24, "Helvetica", "bold", "center")
    gui.drawText(790, 660, "View", nil, nil, 24, "Helvetica", "bold", "center")

    x = 22
    y = 25
    for i = 0, 19 do
        if deck[i] then
            type = TYPES[i]
            -- Every time a render occurs, a new histogram has to be made
            -- For each monster type. May be expensive and slow for this kind of render
            subDeck = {}
            for j = 1, #(deck[i]) do
                if subDeck[deck[i][j]] then
                    subDeck[deck[i][j]] = subDeck[deck[i][j]] + 1
                else
                    subDeck[deck[i][j]] = 1
                end
            end
            for card,count in pairs(subDeck) do
                gui.drawRectangle(x, y, 415, 28, 0xFF999999, nil)
                gui.drawImage("icons/" .. type .. ".png", x + 5, y + 3, 17, 17, true)
                gui.drawText(x + 30, y + 6, type)
                gui.drawText(x + 120, y + 5, " (" .. count .. ")", nil, nil, 15)
                gui.drawText(x + 162, y + 6, string.sub(CARDS[card].Name, 1, 24))
                gui.drawText(x + 350, y + 1, "ATK " .. CARDS[card].Attack)
                gui.drawText(x + 350, y + 12, "DEF " .. CARDS[card].Defense)
                y = y + 32
                if y > 680 then
                    y = 25
                    x = 465
                end
            end      
        end
    end
    for i = 20, 23 do
        if deck[i] then
            type = TYPES[i]
            for card,count in pairs(deck[i]) do
                gui.drawRectangle(x, y, 415, 28, 0xFF999999, nil)
                gui.drawImage("icons/" .. type .. ".png", x + 5, y + 3, 17, 17, true)
                gui.drawText(x + 30, y + 6, type)
                gui.drawText(x + 120, y + 5, " (" .. count .. ")", nil, nil, 15)
                gui.drawText(x + 162, y + 6, CARDS[card].Name)
                y = y + 32
                if y > 680 then
                    y = 25
                    x = 465
                end
            end      
        end
    end
end

function Render.Condensed()
    -- Renders the Condensed View of the deck
    -- Displays the number of each Monster type, as well as
    -- Each Magic, Equip, Trap, and Ritual along with its name and count

    -- First, render toggle button text
    gui.drawText(790, 635, "Full", nil, nil, 24, "Helvetica", "bold", "center")
    gui.drawText(790, 660, "View", nil, nil, 24, "Helvetica", "bold", "center")

    x = 22
    y = 25
    -- Render all Monster cards as just the type and the count, if any
    for i = 0, 19 do
        if deck[i] then
            type = TYPES[i]
            gui.drawRectangle(x, y, 205, 38, 0xFF999999, nil)
            gui.drawImage("icons/" .. type .. ".png", x + 5, y + 3, 34, 34, true)
            gui.drawText(x + 45, y + 10, type, nil, nil, 16)
            gui.drawText(x + 152, y + 8, " (" .. #(deck[i]) .. ")", nil, nil, 20)
            if x == 22 then
                x = 230
            else
                y = y + 42
                x = 22
            end
        end
    end
    -- Align to left if there were an odd number of types represented
    if x == 230 then
        x = 22
        y = y + 42
    end
    -- For all non-monster cards, display individual cards
    for i = 20, 23 do
        if deck[i] then
            type = TYPES[i]
            for card,count in pairs(deck[i]) do
                gui.drawRectangle(x, y, 415, 38, 0xFF999999, nil)
                gui.drawImage("icons/" .. type .. ".png", x + 5, y + 3, 34, 34, true)
                gui.drawText(x + 45, y + 10, type, nil, nil, 16)
                gui.drawText(x + 85, y + 8, " (" .. count .. ")", nil, nil, 20)
                gui.drawText(x + 145, y + 10, CARDS[card].Name, nil, nil, 16)
                y = y + 42
                if y > 660 then
                    y = 25
                    x = 465
                end
            end      
        end
    end
end