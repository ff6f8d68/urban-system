-- Modern Web Browser for SpaceOS
local web = require("lib/web")

-- Constants for UI
local WINDOW_WIDTH = 60
local WINDOW_HEIGHT = 30
local URL_BAR_HEIGHT = 2
local TOOLBAR_HEIGHT = 2

-- Colors
local COLORS = {
    background = colors.white,
    toolbar = colors.lightGray,
    urlBar = colors.white,
    text = colors.black,
    button = colors.blue,
    buttonText = colors.white,
    activeButton = colors.lightBlue
}

-- UI Elements
local elements = {
    urlBar = {x = 2, y = 2, width = WINDOW_WIDTH - 4, height = 1},
    backButton = {x = 2, y = 4, width = 8, height = 1},
    forwardButton = {x = 11, y = 4, width = 8, height = 1},
    refreshButton = {x = 20, y = 4, width = 8, height = 1},
    homeButton = {x = 29, y = 4, width = 8, height = 1},
    contentArea = {x = 2, y = 6, width = WINDOW_WIDTH - 4, height = WINDOW_HEIGHT - 8}
}

-- Browser state
local state = {
    currentUrl = "https://www.google.com",
    history = {},
    historyIndex = 0
}

-- Draw the browser UI
local function drawUI()
    -- Clear screen
    term.setBackgroundColor(COLORS.background)
    term.clear()
    
    -- Draw URL bar
    term.setBackgroundColor(COLORS.urlBar)
    term.setTextColor(COLORS.text)
    term.setCursorPos(elements.urlBar.x, elements.urlBar.y)
    term.write(string.rep(" ", elements.urlBar.width))
    term.setCursorPos(elements.urlBar.x + 1, elements.urlBar.y)
    term.write(state.currentUrl)
    
    -- Draw toolbar buttons
    local buttons = {
        {text = "← Back", x = elements.backButton.x, y = elements.backButton.y},
        {text = "→ Forward", x = elements.forwardButton.x, y = elements.forwardButton.y},
        {text = "↻ Refresh", x = elements.refreshButton.x, y = elements.refreshButton.y},
        {text = "🏠 Home", x = elements.homeButton.x, y = elements.homeButton.y}
    }
    
    for _, button in ipairs(buttons) do
        term.setBackgroundColor(COLORS.button)
        term.setTextColor(COLORS.buttonText)
        term.setCursorPos(button.x, button.y)
        term.write(string.rep(" ", 8))
        term.setCursorPos(button.x + 1, button.y)
        term.write(button.text)
    end
    
    -- Draw content area
    term.setBackgroundColor(COLORS.background)
    term.setTextColor(COLORS.text)
    for y = elements.contentArea.y, elements.contentArea.y + elements.contentArea.height do
        term.setCursorPos(elements.contentArea.x, y)
        term.write(string.rep(" ", elements.contentArea.width))
    end
end

-- Handle URL navigation
local function navigateTo(url)
    if not url:match("^https?://") then
        url = "https://" .. url
    end
    
    state.currentUrl = url
    table.insert(state.history, url)
    state.historyIndex = #state.history
    
    -- Clear content area
    term.setBackgroundColor(COLORS.background)
    term.setTextColor(COLORS.text)
    for y = elements.contentArea.y, elements.contentArea.y + elements.contentArea.height do
        term.setCursorPos(elements.contentArea.x, y)
        term.write(string.rep(" ", elements.contentArea.width))
    end
    
    -- Fetch and display content
    local content = web.fetchText(url)
    if content then
        term.setCursorPos(elements.contentArea.x, elements.contentArea.y)
        -- Basic HTML stripping and display
        content = content:gsub("<.->", "")
        content = content:gsub("&nbsp;", " ")
        content = content:gsub("&amp;", "&")
        content = content:gsub("&lt;", "<")
        content = content:gsub("&gt;", ">")
        
        -- Display first page of content
        local lines = {}
        for line in content:gmatch("[^\r\n]+") do
            if #line > 0 then
                table.insert(lines, line)
            end
        end
        
        for i = 1, math.min(#lines, elements.contentArea.height) do
            term.setCursorPos(elements.contentArea.x, elements.contentArea.y + i - 1)
            term.write(lines[i]:sub(1, elements.contentArea.width))
        end
    else
        term.setCursorPos(elements.contentArea.x, elements.contentArea.y)
        term.write("Failed to load page")
    end
end

-- Main browser loop
local function main()
    drawUI()
    navigateTo(state.currentUrl)
    
    while true do
        local event, button, x, y = os.pullEvent("mouse_click")
        
        -- Check button clicks
        if y == elements.backButton.y and x >= elements.backButton.x and x < elements.backButton.x + 8 then
            if state.historyIndex > 1 then
                state.historyIndex = state.historyIndex - 1
                navigateTo(state.history[state.historyIndex])
            end
        elseif y == elements.forwardButton.y and x >= elements.forwardButton.x and x < elements.forwardButton.x + 8 then
            if state.historyIndex < #state.history then
                state.historyIndex = state.historyIndex + 1
                navigateTo(state.history[state.historyIndex])
            end
        elseif y == elements.refreshButton.y and x >= elements.refreshButton.x and x < elements.refreshButton.x + 8 then
            navigateTo(state.currentUrl)
        elseif y == elements.homeButton.y and x >= elements.homeButton.x and x < elements.homeButton.x + 8 then
            navigateTo("https://www.google.com")
        elseif y == elements.urlBar.y and x >= elements.urlBar.x and x < elements.urlBar.x + elements.urlBar.width then
            -- URL input
            term.setCursorPos(elements.urlBar.x + 1, elements.urlBar.y)
            term.setBackgroundColor(COLORS.urlBar)
            term.setTextColor(COLORS.text)
            term.write(string.rep(" ", elements.urlBar.width - 2))
            term.setCursorPos(elements.urlBar.x + 1, elements.urlBar.y)
            local newUrl = read()
            if newUrl and newUrl ~= "" then
                navigateTo(newUrl)
            end
        end
        
        drawUI()
    end
end

-- Start the browser
main() 