-- [[ manages loading/saving of game settings ]] --
local utils = require "src.core.utils"

local M = {}

local SEP = "™"

-- will be stored at:
-- C:\Users\josep\AppData\Roaming\LOVE\tabletop\settings.txt
-- ~/Library/Application Support/LOVE/tabletop/settings.txt
local SETTINGS_FILE = "settings.txt"

local VERSION = "1"

-- 1=server, 2=username
local valuesInMemory = {"acor.sl.pt", "john doe"}

M.get = function()
  return valuesInMemory
end

M._set = function(server, username)
  valuesInMemory = {server, username}
end

M.load = function()
  local data = love.filesystem.read(SETTINGS_FILE)
  if data == nil then return M.get() end

  local status, matches = pcall(utils.split, data, SEP)
  if not status or matches[1] ~= VERSION or #matches ~= (#valuesInMemory + 1) then
  else
    table.remove(matches, 1)

    -- pcall(M._set, matches)
    M._set(matches[1], matches[2])
  end

  return M.get()
end

M.save = function(server, username)
  M._set(server, username)
  love.filesystem.write(SETTINGS_FILE,
                        utils.join({VERSION, server, username}, SEP))
end

return M
