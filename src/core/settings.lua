-- [[ manages loading/saving of game settings ]] --
local utils = require "src.core.utils"

local M = {}

-- will be stored at: C:\Users\josep\AppData\Roaming\LOVE\tabletop_lua\settings.txt
local SETTINGS_FILE = "settings.txt"

local VERSION = "1"

-- 1=ghost
local valuesInMemory = {"on"}

M.get = function()
  return valuesInMemory[1]
end

M._set = function(ghost)
  valuesInMemory = {ghost}
  M.ghost = ghost
end

M.load = function()
  local data = love.filesystem.read(SETTINGS_FILE)
  if data == nil then return M.get() end

  local status, matches = pcall(utils.split, data, " ")
  if not status or matches[1] ~= VERSION or #matches ~= (#valuesInMemory + 1) then
    return M.get()
  end

  M._set(matches[2])

  return matches[2]
end

M.save = function(ghost)
  M._set(ghost)
  love.filesystem.write(SETTINGS_FILE, utils.join({VERSION, ghost}, " "))
end

return M
