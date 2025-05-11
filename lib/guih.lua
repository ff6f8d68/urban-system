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
    term.setBackgroundColor(colors.lightGray)
    term.clear()
    term.setCursorPos(x, y)
    term.setBackgroundColor(colors.gray)
    term.write(string.rep(" ", width))
    term.setCursorPos(x + math.floor((width - #title) / 2), y + math.floor(height / 2) - 1)
    term.setTextColor(colors.black)
    term.write(title)
    term.setBackgroundColor(colors.black)
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

