-- settings_gui.lua - GUI Settings

local gui = require("/spaceos/lib/guih")

local function drawSettingsWindow()
    gui.drawWindow(2, 2, 30, 15, "Settings")
    gui.drawButton(3, 4, "Reboot", 24, 1, colors.green, colors.white)
    gui.drawButton(3, 6, "Change User (Logout)", 24, 1, colors.yellow, colors.white)
end

local function reboot()
    os.reboot()
end

-- Main
term.clear()
term.setCursorPos(1, 1)
drawSettingsWindow()

while true do
    local event, button, x, y = os.pullEvent("mouse_click")
    if x >= 3 and x <= 26 then
        if y == 4 then
            reboot()
        elseif y == 6 then
            shell.run("/spaceos/main.lua")
        end
    end
end

