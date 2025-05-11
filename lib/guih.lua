-- guih.lua: helper functions for Space Inc. GUI OS

-- Draw a basic button with a label
function drawButton(x, y, label, width, height, bgColor, textColor)
    term.setBackgroundColor(bgColor or colors.blue)
    term.setTextColor(textColor or colors.white)
    term.setCursorPos(x, y)
    term.write(string.rep(" ", width))
    term.setCursorPos(x + math.floor((width - #label) / 2), y + math.floor(height / 2))
    term.write(label)
end

-- Create a simple window with title
function drawWindow(x, y, width, height, title)
    -- Window border
    term.setBackgroundColor(colors.gray)
    for i = y, y + height do
        term.setCursorPos(x, i)
        term.write(" ")
        term.setCursorPos(x + width, i)
        term.write(" ")
    end
    for i = x, x + width do
        term.setCursorPos(i, y)
        term.write(" ")
        term.setCursorPos(i, y + height)
        term.write(" ")
    end

    -- Title bar
    term.setCursorPos(x + math.floor((width - #title) / 2), y)
    term.setBackgroundColor(colors.lightGray)
    term.setTextColor(colors.black)
    term.write(title)

    -- Inside window
    term.setBackgroundColor(colors.white)
    for i = y + 1, y + height - 1 do
        term.setCursorPos(x + 1, i)
        term.write(string.rep(" ", width - 2))
    end
end

-- Wait for a mouse click within the window
function waitForButtonClick(x, y, width, height)
    while true do
        local event, button, mouseX, mouseY = os.pullEvent("mouse_click")
        if mouseX >= x and mouseX <= (x + width) and mouseY >= y and mouseY <= (y + height) then
            return true
        end
    end
end
