-- terminal_gui.lua - GUI Terminal

local gui = require("/spaceos/lib/guih")

local function drawTerminalWindow()
    gui.drawWindow(2, 2, 30, 15, "Terminal")
    gui.drawButton(3, 4, "Enter Command", 24, 1, colors.green, colors.white)
    gui.drawButton(3, 6, "Exit", 24, 1, colors.red, colors.white)
end

local function runCommand()
    term.setCursorPos(3, 8)
    term.setTextColor(colors.white)
    write("Command: ")
    local cmd = read()
    if cmd ~= "" then
        shell.run(cmd)
    end
end

-- Main
term.clear()
term.setCursorPos(1, 1)
drawTerminalWindow()

while true do
    local event, button, x, y = os.pullEvent("mouse_click")
    if x >= 3 and x <= 26 then
        if y == 4 then
            runCommand()
        elseif y == 6 then
            return
        end
    end
end

