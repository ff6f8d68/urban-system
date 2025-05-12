-- Space Inc. GUI OS - Main System

-- Load required modules
local users = dofile("/spaceos/users.lua")

-- Load GUI library with proper error handling
local gui
local success, result = pcall(function()
    -- Try different possible paths
    local paths = {
        "/spaceos/lib/guih",
        "lib/guih",
        "../lib/guih",
        "./lib/guih"
    }
    
    for _, path in ipairs(paths) do
        local success, lib = pcall(require, path)
        if success and type(lib) == "table" then
            return lib
        end
    end
    
    error("Could not find GUI library in any of the expected locations")
end)

if not success then
    print("Error loading GUI library: " .. tostring(result))
    print("Using fallback GUI functions")
    
    -- Create fallback GUI functions
    gui = {
        drawButton = function(x, y, label, width, height, bgColor, textColor)
            if not x or not y or not label then
                error("drawButton requires x, y, and label parameters")
            end
            term.setBackgroundColor(bgColor or colors.blue)
            term.setTextColor(textColor or colors.white)
            term.setCursorPos(x, y)
            term.write(string.rep(" ", width or 10))
            term.setCursorPos(x + math.floor(((width or 10) - #label) / 2), y + math.floor((height or 1) / 2))
            term.write(label)
        end,
        
        drawWindow = function(x, y, width, height, title)
            if not x or not y or not width or not height or not title then
                error("drawWindow requires x, y, width, height, and title parameters")
            end
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
            if not x or not y or not width or not height then
                error("waitForButtonClick requires x, y, width, and height parameters")
            end
            while true do
                local event, button, mouseX, mouseY = os.pullEvent("mouse_click")
                if mouseX >= x and mouseX <= (x + width) and mouseY >= y and mouseY <= (y + height) then
                    return true
                end
            end
        end,
        
        createWindowContext = function(x, y, width, height)
            if not x or not y or not width or not height then
                error("createWindowContext requires x, y, width, and height parameters")
            end
            local oldTerm = term.current()
            local window = window.create(
                term.current(),
                x + 1,
                y + 1,
                width - 2,
                height - 2
            )
            return window, oldTerm
        end
    }
else
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
    
    -- Draw desktop icons with modern styling
    local icons = {
        {text = "🌐 Browser", x = 3, y = 3, app = "browser"},
        {text = "💻 Terminal", x = 3, y = 6, app = "terminal"},
        {text = "📁 Files", x = 3, y = 9, app = "files"},
        {text = "📝 Text", x = 3, y = 12, app = "text"},
        {text = "⚙️ Settings", x = 3, y = 15, app = "settings"}
    }
    
    for _, icon in ipairs(icons) do
        -- Draw icon background
        term.setBackgroundColor(colors.white)
        term.setTextColor(colors.black)
        term.setCursorPos(icon.x, icon.y)
        term.write(string.rep(" ", 12))
        term.setCursorPos(icon.x + 1, icon.y)
        term.write(icon.text)
    end
end

-- Application launcher with floating windows
local function openApp(name)
    local window = {
        x = 5,
        y = 5,
        width = 60,  -- Increased width for better visibility
        height = 30, -- Increased height for better visibility
        title = name
    }
    
    -- Create window
    gui.drawWindow(window.x, window.y, window.width, window.height, window.title)
    
    -- Launch app in the window
    local appPath = "spaceos/apps/" .. name:lower() .. "_gui.lua"
    if fs.exists(appPath) then
        -- Create window context
        local appWindow, oldTerm = gui.createWindowContext(window.x, window.y, window.width, window.height)
        
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
        print("Error: App not found at " .. appPath)
        sleep(2)
    end
end

-- Click detection
local function detectClick(x, y)
    local icons = {
        {y = 3, app = "browser"},
        {y = 6, app = "terminal"},
        {y = 9, app = "files"},
        {y = 12, app = "text"},
        {y = 15, app = "settings"}
    }
    
    if x >= 3 and x <= 14 then
        for _, icon in ipairs(icons) do
            if y >= icon.y and y <= icon.y + 1 then
                openApp(icon.app)
                return
            end
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
