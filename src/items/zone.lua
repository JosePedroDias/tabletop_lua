--[[ zone - changes visibility of items and lays them out ]] --
local utils = require "src.core.utils"

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

  local isLocal = not o.id
  o.id = "zone_" .. o:genId()

  if isLocal then
    local o2 = utils.shallowCopy(o)
    o2.asset = nil
    SendEvent("new zone", o2)
  end

  return o
end

function Zone:draw()
  pcall(G.setColor, self.color)
  G.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2,
              self.width, self.height)
end

return Zone
