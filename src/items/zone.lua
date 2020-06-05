--[[ zone - changes visibility of items and lays them out ]] --
require "src.items.item"

local Item = require "src.items.item"

local G = love.graphics

local Zone = Item:new()

-------

Zone.name = "Zone"

-------

function Zone:new(o)
  o = o or Item:new(o)
  setmetatable(o, self)
  self.__index = self

  o.color = o.color or {1, 1, 1, 0.25}

  o.x = o.x or 0
  o.y = o.y or 0
  o.width = o.width or 300
  o.height = o.height or 50

  o.id = "zone_" .. o:genId()

  return o
end

function Zone:draw()
  pcall(G.setColor, self.color)
  G.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Zone
