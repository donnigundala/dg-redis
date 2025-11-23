-- FlushTags Lua Script
-- Keys: {tag1, tag2, ...}
-- Args: prefix

local prefix = ARGV[1]
local keysToDelete = {}
local tagsToDelete = {}

-- Iterate over all provided tags
for i, tagName in ipairs(KEYS) do
    local tagKey = prefix .. ":tag:" .. tagName
    table.insert(tagsToDelete, tagKey)
    
    -- Get all keys associated with this tag
    local keys = redis.call("SMEMBERS", tagKey)
    for _, key in ipairs(keys) do
        table.insert(keysToDelete, key)
    end
end

-- Delete all associated keys
if #keysToDelete > 0 then
    -- Process in chunks to avoid blocking for too long
    for i = 1, #keysToDelete, 1000 do
        local chunk = {}
        for j = i, math.min(i + 999, #keysToDelete) do
            table.insert(chunk, keysToDelete[j])
        end
        redis.call("DEL", unpack(chunk))
    end
end

-- Delete the tag sets themselves
if #tagsToDelete > 0 then
    redis.call("DEL", unpack(tagsToDelete))
end

return #keysToDelete
