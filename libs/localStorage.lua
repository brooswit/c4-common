
local function buildStoreFileName(storeName)
    return storeName .. '.cc'
end

local function buildStorePathList(storeFileName)
    local disks = { 'disk', 'disk2', 'disk3', 'disk4', 'disk5' }
    local pathList = {}
    for k, disk in pairs(disks) do
        if fs.exists(disk .. '/') then
            table.insert(pathList, disk .. '/' .. storeFileName)
        end
    end
    table.insert(pathList, storeFileName)
    return pathList
end

local save

local function load(storeName)
    local storeFileName = buildStoreFileName(storeName)
    local storePaths = buildStorePathList(storeFileName)
    local data = {}
    for k, storePath in pairs(storePaths) do
        local storeExists = fs.exists(storePath)
        if storeExists then
            local file = fs.open(storePath, "r")
            if file ~= nil then
                local storeContents = file.readAll()
                file.close()
                local ran
                ran, decodedStore = pcall(textutils.unserialize, storeContents)
                if ran and type(decodedStore) == 'table' then
                    data = decodedStore
                    save(storeName, data)
                end
            end
        end
    end

    return data
end

save = function (storeName, data)
    local ran, text = pcall(textutils.serialize, data)
    if not ran then
        text = "{}"
    end

    local storeFileName = buildStoreFileName(storeName)
    local storePaths = buildStorePathList(storeFileName)

    for k, storePath in pairs(storePaths) do
        local file = fs.open(storePath, "w")
        if file ~= nil then
            file.write(text)
            file.close()
        end
    end
end

local cache = {}
local ttl = 5

function get(key, default)
    local now = os.clock()

    if cache[key] == nil or cache[key].time + ttl < now then
        cache[key] = {
            value = load(key),
            time = now
        }
    end

    local cachedData = cache[key].value

    return cachedData
end

function set(key, value)
    local now = os.clock()

    cache[key] = {
        value = value,
        time = now
    }

    save(key, value)
end
