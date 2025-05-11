term.clear()
term.setCursorPos(1, 1)
print("[File Manager]")
local list = fs.list("/")
for i, f in ipairs(list) do
    print("- " .. f)
end
print("\nPress any key to return.")
os.pullEvent("key")

