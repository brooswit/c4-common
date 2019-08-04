print("LD: V13")
os.loadAPI("module")
module.require("json")
module.require("base64")
module.require("config")

local pollInterval = 5

local user = {}
local allFlags
local clientSideID
local isInitialized = false
local lastPoll = 0 - pollInterval

local function poll()
  if lastPoll + pollInterval > os.clock() then
    return
  end
  lastPoll = os.clock()

  user.key = "" .. (user.key or os.getComputerID())
  user.custom = user.custom or {}
  user.custom.time = os.time()*1000
  user.custom.hour = math.floor(os.time())
  user.custom.hourKey = user.custom.hour .. "+" .. user.key
  user.custom.day = os.day()
  user.custom.dayKey = user.custom.day .. "+" .. user.key
  for key,side in pairs(redstone.getSides()) do
    user.custom["redstone_" .. side] = redstone.getInput(side)
  end
  userString = json.encode(user)
  userBase64 = base64.encode(userString)
  url = "https://app.launchdarkly.com/sdk/evalx/" .. clientSideID .. "/users/" .. userBase64
  request = http.get(url)
  if not request then
    print("LD: request failed - " .. url)
  else
    local response = request.readAll()
    allFlags = json.decode(response)
  end
end

function init(newClientSideID)
  clientSideID = newClientSideID || config.get("ld-client-side-id")
  if(isInitialized == false) then
    isInitialized = true
    -- pollCoroutine = coroutine.create(function()
    --   while(true) do
    --     poll()
    --   end
    -- end)
    -- coroutine.resume(pollCoroutine)
  end
end

function variation(flagKey, defaultValue)
  poll()
  flagDetails = allFlags[flagKey]
  value = defaultValue
  if flagDetails then
    value = flagDetails.value
  end

  url = "https://events.launchdarkly.com/events/bulk/" .. clientSideID

  event = json.encode({
    kind = "index",
    user = user
  })

  local headers = {
    [ "Content-Type" ] = "application/json",
  }
  res = http.post(url, event, headers)

  return value
end

function identify(newUser)
    user = newUser
    isIdentifier = true
end
