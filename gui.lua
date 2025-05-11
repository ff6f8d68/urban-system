-- Space Inc. GUI OS - Main System

-- Load required modules
local users = dofile("/spaceos/users.lua")

-- Create GUI table and functions
local gui = {
    drawButton = function(x, y, label, width, height, bgColor, textColor)
        term.setBackgroundColor(bgColor or colors.blue)
        term.setTextColor(textColor or colors.white)
        term.setCursorPos(x, y)
        term.write(string.rep(" ", width))
        term.setCursorPos(x + math.floor((width - #label) / 2), y + math.floor(height / 2))
        term.write(label)
    end,

    drawWindow = function(x, y, width, height, title)
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
    end,

    waitForButtonClick = function(x, y, width, height)
        while true do
            local event, button, mouseX, mouseY = os.pullEvent("mouse_click")
            if mouseX >= x and mouseX <= (x + width) and mouseY >= y and mouseY <= (y + height) then
                return true
            end
        end
    end
}

-- Try to load external GUI library
local success, result = pcall(require, "lib/guih")
if success then
    -- If library loads successfully, use its functions
    gui = result
end

-- Login system
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

-- Desktop drawing functions
local function drawDesktop()
    term.setBackgroundColor(colors.gray)
    term.clear()
    
    -- Draw desktop icons
    gui.drawButton(3, 3, "Terminal", 10, 2, colors.white, colors.black)
    gui.drawButton(3, 6, "Files", 10, 2, colors.white, colors.black)
    gui.drawButton(3, 9, "Settings", 10, 2, colors.white, colors.black)
end

-- Application launcher with floating windows
local function openApp(name)
    local window = {
        x = 5,
        y = 5,
        width = 40,
        height = 20,
        title = name
    }
    
    -- Create window
    gui.drawWindow(window.x, window.y, window.width, window.height, window.title)
    
    -- Launch app in the window
    local appPath = "/spaceos/apps/" .. name:lower() .. "_gui.lua"
    if fs.exists(appPath) then
        -- Save current terminal state
        local oldTerm = term.current()
        
        -- Create a new window for the app
        local appWindow = window.create(
            term.current(),
            window.x + 1,
            window.y + 1,
            window.width - 2,
            window.height - 2
        )
        
        -- Set the new window as current
        term.redirect(appWindow)
        
        -- Run the app
        shell.run(appPath)
        
        -- Restore original terminal
        term.redirect(oldTerm)
    else
        -- Draw error message in window
        term.setCursorPos(window.x + 2, window.y + 2)
        term.setTextColor(colors.red)
        print("Error: App not found")
        sleep(2)
    end
end

-- Click detection
local function detectClick(x, y)
    if x >= 3 and x <= 12 then
        if y >= 3 and y <= 4 then
            openApp("Terminal")
        elseif y >= 6 and y <= 7 then
            openApp("Files")
        elseif y >= 9 and y <= 10 then
            openApp("Settings")
        end
    end
end

-- Main system loop
local function main()
    -- Login first
    if not login() then
        return
    end
    
    -- Main desktop loop
    while true do
        drawDesktop()
        local e, btn, x, y = os.pullEvent("mouse_click")
        detectClick(x, y)
    end
end

-- Start the system
main()
