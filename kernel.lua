-- kernel.lua - Space Inc. OS System Kernel
-- Provides core system functionalities like command execution, library management, and factory reset.

-- Function to run a command
function runCommand(command)
    print("Running command: " .. command)
    local success, result = pcall(function()
        shell.run(command)
    end)
    
    if not success then
        print("Error: " .. result)
    else
        print("Command executed successfully.")
    end
end

-- Function to reset the system to factory settings
function resetSystem()
    -- Confirm the reset
    print("WARNING: This will remove all SpaceOS data and reset the system to factory settings.")
    print("Do you wish to continue? (y/n)")
    local confirmation = read()
    
    if confirmation:lower() == "y" then
        -- Deleting user data, applications, system files
        print("Resetting system... This may take some time.")
        
        -- Remove SpaceOS files (example locations)
        if fs.exists("/spaceos") then
            fs.delete("/spaceos")
            print("SpaceOS system files removed.")
        end
        
        -- Optionally, remove or reset specific files or folders
        if fs.exists("/spaceos/users") then
            fs.delete("/spaceos/users")
            print("User data deleted.")
        end
        
        if fs.exists("/spaceos/apps") then
            fs.delete("/spaceos/apps")
            print("Applications removed.")
        end
        
        -- Reset the filesystem to a basic state
        fs.makeDir("/spaceos")
        fs.makeDir("/spaceos/apps")
        fs.makeDir("/spaceos/users")
        
        print("System reset to factory state.")
    else
        print("Reset aborted.")
    end
end

-- Function to list all libraries
function listLibraries()
    print("Listing all libraries installed in SpaceOS:")
    local libraries = fs.list("/spaceos/lib")
    if #libraries == 0 then
        print("No libraries found.")
    else
        for _, lib in ipairs(libraries) do
            print(lib)
        end
    end
end

-- Function to run a library directly
function runLibrary(libraryName)
    print("Running library: " .. libraryName)
    if fs.exists("/spaceos/lib/" .. libraryName) then
        local success, result = pcall(function()
            dofile("/spaceos/lib/" .. libraryName)
        end)
        
        if not success then
            print("Error loading library: " .. result)
        else
            print("Library executed successfully.")
        end
    else
        print("Error: Library not found.")
    end
end

-- Main loop: Interface for debugging and system management
local function showKernelMenu()
    while true do
        term.clear()
        term.setCursorPos(1, 1)
        print("=== Space Inc. OS Kernel ===")
        print("1. Run Command")
        print("2. Reset System to Factory")
        print("3. List Libraries")
        print("4. Run Library")
        print("5. Exit")
        print("Choose an option (1-5):")
        
        local choice = tonumber(read())
        
        if choice == 1 then
            print("Enter the command to run:")
            local command = read()
            runCommand(command)
        elseif choice == 2 then
            resetSystem()
        elseif choice == 3 then
            listLibraries()
        elseif choice == 4 then
            print("Enter the library name to run:")
            local libName = read()
            runLibrary(libName)
        elseif choice == 5 then
            print("Exiting kernel...")
            break
        else
            print("Invalid option. Please try again.")
        end
        
        print("\nPress Enter to return to the menu.")
        read()
    end
end

-- Start the kernel menu
showKernelMenu()
