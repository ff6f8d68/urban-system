-- files_gui.lua - GUI File Manager

local gui = require("/spaceos/lib/guih")

local function drawFileManagerWindow()
    gui.drawWindow(2, 2, 30, 15, "File Manager")
    gui.drawButton(3, 4, "List Files", 24, 1, colors.green, colors.white)
    gui.drawButton(3, 6, "Exit", 24, 1, colors.red, colors.white)
end

local function listFiles()
    term.setCursorPos(3, 8)
    term.setTextColor(colors.white)
    local files = fs.list("/")
    for i, file in ipairs(files) do
        print(file)
    end
end

-- Main
term.clear()
term.setCursorPos(1, 1)
drawFileManagerWindow()

while true do
    local event, button, x, y = os.pullEvent("mouse_click")
    if x >= 3 and x <= 26 then
        if y == 4 then
            listFiles()
        elseif y == 6 then
            return
        end
    end
end

