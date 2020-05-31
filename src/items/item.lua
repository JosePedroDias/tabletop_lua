--[[ generic item ]] --
local utils = require "src.core.utils"

local Item = {x = 0, y = 0, rotation = 0}

function Item:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self

  return o
end

function Item:isHit(x_, y_)
  local x, y, w, h

  -- TODO hack for 90 deg rotations to hit properly
  if self.rotation == 90 or self.rotation == 270 then
    w = self.width
    h = self.height
  else
    w = self.width
    h = self.height
  end
  x = x_ + (w / 2)
  y = y_ + (h / 2)

  -- print(x, y, self.x, self.y, self.width, self.height)

  return x >= self.x and x <= self.x + w and y >= self.y and y <= self.y + h
end

function Item:genId()
  return utils.randomString(6, love.math.random)
end

return Item
