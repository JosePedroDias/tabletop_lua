--[[ playing dice ]] -- "
local assets = require "src.core.assets"
local utils = require "src.core.utils"

local Item = require "src.items.item"

local G = love.graphics

local D2R = math.pi / 180

local function electAsset(o)
  return "dices_" .. o.color .. "_" .. o.value
end

local W = 64
local H = 64

local w2 = W / 2
local h2 = H / 2
local S = 0.5

W = W * S
H = H * S

local VALUES = {1, 2, 3, 4, 5, 6}

local COLORS = {"red", "white"}

local Dice = Item:new()

-------

Dice.name = "Dice"

function Dice.colors()
  return COLORS
end

function Dice.values()
  return VALUES
end

function Dice.parameterize()
  return coroutine.create(function()
    local color = coroutine.yield(COLORS)
    -- local color = "white"

    -- coroutine.yield(VALUES)
    local value = love.math.random(6)

    return Dice:new({color = color, value = value})
  end)
end

function Dice.affect()
  return {"roll"}
end

-------

function Dice:new(o)
  o = o or Item:new(o)
  setmetatable(o, self)
  self.__index = self

  o.color = o.color or "white"
  assert(utils.has(COLORS, o.color),
         "dice created with unsupported color: " .. o.color)
  assert(utils.has(VALUES, o.value),
         "dice created with unsupported value: " .. o.value)

  o.width = W
  o.height = H

  local isLocal = not o.id
  o.id = o.id or ("dice_" .. o:genId())

  if isLocal then
    local o2 = utils.shallowCopy(o)
    o2.asset = nil
    SendEvent("new dice", o2)
  end

  o:redraw()

  return o
end

function Dice:draw()
  G.setColor(1, 1, 1, 1)
  G.draw(self.asset, self.x, self.y, D2R * self.rotation, S, S, w2, h2)
end

function Dice:redraw()
  self.asset = assets.gfx[electAsset(self)]
end

function Dice:roll()
  self.value = love.math.random(6)
  self.asset = assets.gfx[electAsset(self)]

  SendEvent("update", {id = self.id, value = self.value})
end

return Dice
