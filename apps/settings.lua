term.clear()
term.setCursorPos(1, 1)
print("[Settings]")
print("1. Reboot")
print("2. Change user (logout)")

term.write("\nOption: ")
local choice = read()

if choice == "1" then
    os.reboot()
elseif choice == "2" then
    shell.run("/spaceos/main.lua")
end

