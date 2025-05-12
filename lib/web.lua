-- web.lua
-- Simulated enhanced web module for ComputerCraft Tweaked with full internet access

local web = {}

-- Open a full URL in a browser-like UI (hypothetical)
function web.openURL(url)
    print("[Web] Opening URL: " .. url)

    -- Hypothetical API: open a browser window
    if browser then
        return browser.open(url)
    else
        -- Fallback: HTTP get and basic render
        local res = http.get(url)
        if res then
            local content = res.readAll()
            res.close()
            print("[Web] Fetched content. Rendering...")
            -- simulate a render (strip HTML)
            local clean = content:gsub("<.->", "")
            print(clean:sub(1, 800)) -- only preview part
            return true
        else
            print("[Web] Failed to fetch page.")
            return false
        end
    end
end

-- Play a video directly (e.g., YouTube)
function web.playVideo(url)
    print("[Web] Attempting to play video: " .. url)

    -- Hypothetical API that supports media rendering
    if videoPlayer and videoPlayer.play then
        return videoPlayer.play(url)
    elseif shell then
        -- Use shell/browser fallback
        shell.run("open", url)  -- In your custom environment
        return true
    else
        return false, "No video playback support in environment."
    end
end

-- Search a query on Google (basic use case)
function web.searchGoogle(query)
    local encoded = query:gsub(" ", "+")
    local url = "https://www.google.com/search?q=" .. encoded
    return web.openURL(url)
end

-- Fetch raw text content from a URL
function web.fetchText(url)
    local res = http.get(url)
    if res then
        local data = res.readAll()
        res.close()
        return data
    else
        return nil, "Failed to fetch URL."
    end
end

return web 