-- [[ manages loading/saving of game settings ]] --
require("src.ext.json") -- json.encode / decode
local LF = love.filesystem

-- will be stored at:
-- C:\Users\josep\AppData\Roaming\LOVE\tabletop\settings.json
-- ~/Library/Application Support/LOVE/tabletop/settings.json
local SETTINGS_FILE = "settings.json"

local DEFAULTS = {
  server = "acor.sl.pt",
  username = "john doe",
  email = "john.doe@somewhere.com",
  color = 1
}

local M = {}

M.load = function()
  -- set defaults
  for k, v in pairs(DEFAULTS) do M[k] = v end

  -- read raw string
  local data = LF.read(SETTINGS_FILE)
  if data == nil then return false end

  -- try to parse it
  local success, o = pcall(json.decode, data)
  if not success then return false end

  -- assign its pairs to the module itself
  for k, v in pairs(o) do M[k] = v end
  return true
end

M.save = function()
  local o = M
  local success, s = pcall(json.encode, o)
  if not success then return false end
  LF.write(SETTINGS_FILE, s)
  return true
end

return M
