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

  return x >= self.x and x <= self.x + w and y >= self.y and y <= self.y + h
end

function Item:isHitByItem(it)
  local x1 = self.x - self.width / 2
  local x2 = self.x + self.width / 2
  local y1 = self.y - self.height / 2
  local y2 = self.y + self.height / 2

  local x1_ = it.x - it.width / 2
  local x2_ = it.x + it.width / 2
  local y1_ = it.y - it.height / 2
  local y2_ = it.y + it.height / 2

  return x1 < x2_ and x2 > x1_ and y1 < y2_ and y2 > y1_
end

function Item:genId()
  return utils.randomString(6, love.math.random)
end

function Item:move(x, y)
  self.x = x
  self.y = y
  SendEvent("update", {id = self.id, x = self.x, y = self.y})
end

return Item
