--[[ playing dice ]] --
require "src.items.item"

local assets = require "src.core.assets"
local utils = require "src.core.utils"

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

local VALUES = {1, 2, 3, 4, 5, 6}

-- value - 1 2 3 4 5 6
-- color - red white
local Dice = {x = 0, y = 0, rotation = 0}

function Dice:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self

  o.color = o.color or "white"
  if not utils.has(VALUES, o.value) then
    return print("dice created with unsupported value: " .. o.value)
  end

  o.asset = assets.gfx[electAsset(o)]
  o.width = W
  o.height = H

  return o
end

function Dice:draw()
  G.setColor(1, 1, 1, 1)
  G.draw(self.asset, self.x, self.y, D2R * self.rotation, S, S, w2, h2)
end

function Dice:roll()
  self.value = love.math.random(6)
  self.asset = assets.gfx[electAsset(self)]
end

return Dice
