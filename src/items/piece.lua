--[[ piece ]] --
require "src.items.item"

local assets = require "src.core.assets"
local utils = require "src.core.utils"

local Item = require "src.items.item"

local G = love.graphics

local D2R = math.pi / 180

local function electAsset(o)
  return "pieces_" .. o.color .. "_" .. o.value
end

local W = 64
local H = 64

local w2 = W / 2
local h2 = H / 2
local S = 0.5

W = W * S
H = H * S

local VALUES = utils.map(utils.times(19, 0), function(v)
  v = tostring(v)
  if v:len() == 1 then v = "0" .. v end
  return v
end)

local COLORS = {"black", "blue", "green", "purple", "red", "white", "yellow"}

local Piece = Item:new()

-------

Piece.name = "Piece"

function Piece.colors()
  return COLORS
end

function Piece.values()
  return VALUES
end

function Piece.parameterize()
  return coroutine.create(function()
    local color = coroutine.yield(COLORS)
    local value = coroutine.yield(VALUES)
    return Piece:new({color = color, value = value})
  end)
end

function Piece.affect()
  return {}
end

-------

function Piece:new(o)
  o = o or Item:new(o)
  setmetatable(o, self)
  self.__index = self

  assert(utils.has(COLORS, o.color),
         "piece created with unsupported color: " .. o.color)
  assert(utils.has(VALUES, o.value),
         "piece created with unsupported value: " .. o.value)

  o.width = W
  o.height = H

  local isLocal = not o.id
  o.id = o.id or ("piece_" .. o:genId())

  if isLocal then
    local o2 = utils.shallowCopy(o)
    o2.asset = nil
    SendEvent("new piece", o2)
  end

  o:redraw()

  return o
end

function Piece:draw()
  G.setColor(1, 1, 1, 1)
  G.draw(self.asset, self.x, self.y, D2R * self.rotation, S, S, w2, h2)
end

function Piece:redraw()
  self.asset = assets.gfx[electAsset(self)]
end

return Piece
