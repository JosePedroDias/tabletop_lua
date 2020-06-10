--[[ avatars - avatar listing, loading and saving feature ]] --
local utils = require "src.core.utils"

local M = {}

local LG = love.graphics
local F = love.filesystem

M.avatarImages = {}

local FAIL_LIST = {".DS_Store"}

M.listAvatars = function()
  if not F.getInfo("avatars", "directory") then
    local success = F.createDirectory("avatars")
    assert(success, "could not create avatars directory")
  end

  local list = F.getDirectoryItems("avatars")
  list = utils.filter(list, function(item)
    return not utils.has(FAIL_LIST, item)
  end)
  return list
end

M.onDrop = function(file)
  local avatars = M.listAvatars()
  local filename = file:getFilename()
  local ext = string.match(filename, "%.[a-z+]+$")
  local filename2 = tostring(#avatars + 1) .. ext

  file:open("r")
  local data = file:read()
  local success = love.filesystem.write("avatars/" .. filename2, data)
  assert(success, "could not save avatar")
end

M.loadAvatarImages = function()
  local avatars = M.listAvatars()
  for i, name in ipairs(avatars) do
    M.avatarImages[i] = LG.newImage("avatars/" .. name)
  end
end

return M
