-- main.lua - Space Inc. OS GUI Shell

local gui = require("/spaceos/lib/guih")

local function drawMainWindow()
    term.clear()
    gui.drawWindow(2, 2, 30, 15, "Space Inc. OS v1.0.4")

    -- Draw buttons for launching apps
    gui.drawButton(3, 4, "File Manager", 24, 1, colors.blue, colors.white)
    gui.drawButton(3, 6, "Terminal", 24, 1, colors.green, colors.white)
    gui.drawButton(3, 8, "Settings", 24, 1, colors.yellow, colors.white)
end

local function openApp(name)
    if name == "File Manager" then
        shell.run("/spaceos/apps/files_gui.lua")
    elseif name == "Terminal" then
        shell.run("/spaceos/apps/terminal_gui.lua")
    elseif name == "Settings" then
        shell.run("/spaceos/apps/settings_gui.lua")
    end
end

-- Main loop
drawMainWindow()

while true do
    local event, button, x, y = os.pullEvent("mouse_click")
    if x >= 3 and x <= 26 then
        if y == 4 then
            openApp("File Manager")
        elseif y == 6 then
            openApp("Terminal")
        elseif y == 8 then
            openApp("Settings")
        end
    end
end

