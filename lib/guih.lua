-- guih.lua: high-res GUI using smallest font size and scaling
local guih = {}

-- Set smallest text scale to simulate highest resolution
term.setTextScale(0.5) -- Smallest font

-- Draw 1 pixel using blit
function guih.drawPixel(x, y, colorChar)
    term.setCursorPos(x, y)
    term.blit(" ", "0", colorChar)
end

-- Fill a rectangle (x, y, width, height, bgColorChar)
function guih.fillRect(x, y, width, height, bgColorChar)
    for i = 0, height - 1 do
        term.setCursorPos(x, y + i)
        term.blit(string.rep(" ", width), string.rep("0", width), string.rep(bgColorChar, width))
    end
end

-- Draw a button with label (blit-style)
function guih.drawButton(x, y, width, height, label, bgColorChar, textColorChar)
    bgColorChar = bgColorChar or "1" -- orange
    textColorChar = textColorChar or "0" -- black

    guih.fillRect(x, y, width, height, bgColorChar)

    -- Center label
    local labelX = x + math.floor((width - #label) / 2)
    local labelY = y + math.floor(height / 2)

    for i = 1, #label do
        local char = label:sub(i, i)
        term.setCursorPos(labelX + i - 1, labelY)
        term.blit(char, textColorChar, bgColorChar)
    end
end

-- Draw a window with border and title
function guih.drawWindow(x, y, width, height, title)
    local border = "7" -- gray
    local fill = "f"   -- white

    -- Top and bottom borders
    guih.fillRect(x, y, width, 1, border)
    guih.fillRect(x, y + height - 1, width, 1, border)

    -- Sides
    for i = y + 1, y + height - 2 do
        term.setCursorPos(x, i)
        term.blit(" ", "0", border)
        term.setCursorPos(x + width - 1, i)
        term.blit(" ", "0", border)
    end

    -- Fill inside area
    guih.fillRect(x + 1, y + 1, width - 2, height - 2, fill)

    -- Title
    local titleX = x + math.floor((width - #title) / 2)
    term.setCursorPos(titleX, y)
    for i = 1, #title do
        local c = title:sub(i, i)
        term.blit(c, "0", border)
    end
end

-- Wait for mouse click inside a box (x, y, width, height)
function guih.waitForButtonClick(x, y, width, height)
    while true do
        local e, btn, px, py = os.pullEvent("mouse_click")
        if px >= x and px <= x + width - 1 and py >= y and py <= y + height - 1 then
            return true
        end
    end
end

return guih
