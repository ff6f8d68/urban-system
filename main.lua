local users = dofile("/spaceos/users.lua")

local function login()
    term.clear()
    term.setCursorPos(1, 1)
    print("== Space Inc. OS Login ==")
    write("Username: ")
    local u = read()
    write("Password: ")
    local p = read("*")
    if users[u] == p then
        return true
    else
        print("Access Denied.")
        sleep(2)
        os.reboot()
    end
end

local function drawDesktop()
    term.setBackgroundColor(colors.gray)
    term.clear()
    term.setCursorPos(3, 3)
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.black)
    write(" Terminal ")
    term.setCursorPos(3, 6)
    write(" Files ")
    term.setCursorPos(3, 9)
    write(" Settings ")
end

local function openApp(name)
    if name == "Terminal" then
        shell.run("/spaceos/apps/terminal_gui.lua")
    elseif name == "Files" then
        shell.run("/spaceos/apps/files_gui.lua")
    elseif name == "Settings" then
        shell.run("/spaceos/apps/settings_gui.lua")
    end
end

local function detectClick(x, y)
    if x >= 3 and x <= 12 then
        if y == 3 then openApp("Terminal")
        elseif y == 6 then openApp("Files")
        elseif y == 9 then openApp("Settings")
        end
    end
end

-- Main loop
login()
while true do
    drawDesktop()
    local e, btn, x, y = os.pullEvent("mouse_click")
    detectClick(x, y)
end

