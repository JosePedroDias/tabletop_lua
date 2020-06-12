--[[ checkers ]] --
local assets = require "src.core.assets"
local utils = require "src.core.utils"

local Item = require "src.items.item"

local G = love.graphics

local D2R = math.pi / 180

local function electAsset(o)
  return "checkers_" .. o.color
end

local W = 64
local H = 64

local w2 = W / 2
local h2 = H / 2
local S = 1

W = W * S
H = H * S

local COLORS = {"black", "white"}

local Checkers = Item:new()

-------

Checkers.name = "Checkers"

function Checkers.colors()
  return COLORS
end

function Checkers.parameterize()
  return coroutine.create(function()
    local color = coroutine.yield(COLORS)
    return Checkers:new({color = color})
  end)
end

function Checkers.affect()
  return {}
end

-------

function Checkers:new(o)
  o = o or Item:new(o)
  setmetatable(o, self)
  self.__index = self

  assert(utils.has(COLORS, o.color),
         "checkers created with unsupported color: " .. o.color)

  o.width = W
  o.height = H

  local isLocal = not o.id
  o.id = o.id or ("checkers_" .. o:genId())

  if isLocal then
    local o2 = utils.shallowCopy(o)
    o2.asset = nil
    SendEvent("new checkers", o2)
  end

  o:redraw()

  return o
end

function Checkers:draw()
  G.setColor(1, 1, 1, 1)
  G.draw(self.asset, self.x, self.y, 0, S, S, w2, h2)
end

function Checkers:redraw()
  self.asset = assets.gfx[electAsset(self)]
end

return Checkers
