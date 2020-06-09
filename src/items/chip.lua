--[[ chip ]] --
local assets = require "src.core.assets"
local utils = require "src.core.utils"

local Item = require "src.items.item"

local G = love.graphics

local D2R = math.pi / 180

local function electAsset(o)
  return "chips_" .. o.color
end

local W = 64
local H = 64

local w2 = W / 2
local h2 = H / 2
local S = 0.5

W = W * S
H = H * S

local COLORS = {
  "white_blue", -- 1
  "red_white", -- 5
  "blue_white", -- 10
  "green_white", -- 25
  "black_white", -- 100
  "white", -- dealer
  "blue", -- small blind?
  "green" -- big blind?
}

local Chip = Item:new()

-------

Chip.name = "Chip"

function Chip.colors()
  return COLORS
end

function Chip.parameterize()
  return coroutine.create(function()
    local color = coroutine.yield(COLORS)
    return Chip:new({color = color})
  end)
end

function Chip.affect()
  return {}
end

-------

function Chip:new(o)
  o = o or Item:new(o)
  setmetatable(o, self)
  self.__index = self

  assert(utils.has(COLORS, o.color),
         "chip created with unsupported color: " .. o.color)

  o.width = W
  o.height = H

  local isLocal = not o.id
  o.id = o.id or ("chip_" .. o:genId())

  if isLocal then
    local o2 = utils.shallowCopy(o)
    o2.asset = nil
    SendEvent("new chip", o2)
  end

  o:redraw()

  return o
end

function Chip:draw()
  G.setColor(1, 1, 1, 1)
  G.draw(self.asset, self.x, self.y, D2R * self.rotation, S, S, w2, h2)
end

function Chip:redraw()
  self.asset = assets.gfx[electAsset(self)]
end

return Chip
