-- Text Editor for SpaceOS
local WINDOW_WIDTH = 60
local WINDOW_HEIGHT = 30

-- Colors
local COLORS = {
    background = colors.white,
    toolbar = colors.lightGray,
    text = colors.black,
    button = colors.blue,
    buttonText = colors.white,
    activeButton = colors.lightBlue
}

-- UI Elements
local elements = {
    toolbar = {x = 2, y = 2, width = WINDOW_WIDTH - 4, height = 1},
    saveButton = {x = 2, y = 2, width = 8, height = 1},
    printButton = {x = 11, y = 2, width = 8, height = 1},
    newButton = {x = 20, y = 2, width = 8, height = 1},
    editorArea = {x = 2, y = 4, width = WINDOW_WIDTH - 4, height = WINDOW_HEIGHT - 6}
}

-- Editor state
local state = {
    text = "",
    cursor = {x = 1, y = 1},
    scroll = 0,
    filename = "untitled.txt"
}

-- Draw the editor UI
local function drawUI()
    -- Clear screen
    term.setBackgroundColor(COLORS.background)
    term.clear()
    
    -- Draw toolbar buttons
    local buttons = {
        {text = "💾 Save", x = elements.saveButton.x, y = elements.saveButton.y},
        {text = "🖨️ Print", x = elements.printButton.x, y = elements.printButton.y},
        {text = "📄 New", x = elements.newButton.x, y = elements.newButton.y}
    }
    
    for _, button in ipairs(buttons) do
        term.setBackgroundColor(COLORS.button)
        term.setTextColor(COLORS.buttonText)
        term.setCursorPos(button.x, button.y)
        term.write(string.rep(" ", 8))
        term.setCursorPos(button.x + 1, button.y)
        term.write(button.text)
    end
    
    -- Draw editor area
    term.setBackgroundColor(COLORS.background)
    term.setTextColor(COLORS.text)
    
    -- Split text into lines
    local lines = {}
    for line in state.text:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    
    -- Display visible lines
    for i = 1, elements.editorArea.height do
        local lineNum = i + state.scroll
        term.setCursorPos(elements.editorArea.x, elements.editorArea.y + i - 1)
        if lines[lineNum] then
            term.write(lines[lineNum]:sub(1, elements.editorArea.width))
        else
            term.write(string.rep(" ", elements.editorArea.width))
        end
    end
    
    -- Draw cursor
    term.setCursorPos(elements.editorArea.x + state.cursor.x - 1, 
                     elements.editorArea.y + state.cursor.y - 1)
end

-- Save the current text to a file
local function saveFile()
    local file = fs.open(state.filename, "w")
    if file then
        file.write(state.text)
        file.close()
        return true
    end
    return false
end

-- Print the current text
local function printText()
    local printer = peripheral.find("printer")
    if printer then
        printer.newPage()
        printer.write(state.text)
        printer.endPage()
        return true
    end
    return false
end

-- Create a new document
local function newDocument()
    state.text = ""
    state.cursor = {x = 1, y = 1}
    state.scroll = 0
    state.filename = "untitled.txt"
end

-- Handle text input
local function handleInput(char)
    if char == "\n" then
        -- Insert newline
        local beforeCursor = state.text:sub(1, state.cursor.x - 1)
        local afterCursor = state.text:sub(state.cursor.x)
        state.text = beforeCursor .. "\n" .. afterCursor
        state.cursor.x = 1
        state.cursor.y = state.cursor.y + 1
    elseif char == "\b" then
        -- Handle backspace
        if state.cursor.x > 1 then
            local beforeCursor = state.text:sub(1, state.cursor.x - 2)
            local afterCursor = state.text:sub(state.cursor.x)
            state.text = beforeCursor .. afterCursor
            state.cursor.x = state.cursor.x - 1
        end
    else
        -- Insert character
        local beforeCursor = state.text:sub(1, state.cursor.x - 1)
        local afterCursor = state.text:sub(state.cursor.x)
        state.text = beforeCursor .. char .. afterCursor
        state.cursor.x = state.cursor.x + 1
    end
end

-- Main editor loop
local function main()
    drawUI()
    
    while true do
        local event, button, x, y = os.pullEvent()
        
        if event == "mouse_click" then
            -- Check toolbar buttons
            if y == elements.saveButton.y and x >= elements.saveButton.x and x < elements.saveButton.x + 8 then
                if saveFile() then
                    term.setCursorPos(2, elements.editorArea.y + elements.editorArea.height + 1)
                    term.write("File saved successfully!")
                else
                    term.setCursorPos(2, elements.editorArea.y + elements.editorArea.height + 1)
                    term.write("Error saving file!")
                end
            elseif y == elements.printButton.y and x >= elements.printButton.x and x < elements.printButton.x + 8 then
                if printText() then
                    term.setCursorPos(2, elements.editorArea.y + elements.editorArea.height + 1)
                    term.write("Printing...")
                else
                    term.setCursorPos(2, elements.editorArea.y + elements.editorArea.height + 1)
                    term.write("No printer found!")
                end
            elseif y == elements.newButton.y and x >= elements.newButton.x and x < elements.newButton.x + 8 then
                newDocument()
            elseif y >= elements.editorArea.y and y < elements.editorArea.y + elements.editorArea.height then
                -- Set cursor position in editor
                state.cursor.x = x - elements.editorArea.x + 1
                state.cursor.y = y - elements.editorArea.y + 1
            end
        elseif event == "char" then
            handleInput(button)
        elseif event == "key" then
            if button == keys.backspace then
                handleInput("\b")
            elseif button == keys.enter then
                handleInput("\n")
            end
        end
        
        drawUI()
    end
end

-- Start the editor
main() 