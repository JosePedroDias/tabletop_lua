--[[ chess ]] --
local assets = require "src.core.assets"
local utils = require "src.core.utils"

local Item = require "src.items.item"

local G = love.graphics

local D2R = math.pi / 180

local function electAsset(o)
  return "chess_" .. o.color:sub(1, 1) .. "_" .. o.piece
end

local W = 256
local H = 256

local w2 = W / 2
local h2 = H / 2
local S = 0.2

W = W * S
H = H * S

local COLORS = {"black", "white"}
local PIECES = {"bishop", "king", "knight", "pawn", "queen", "rook"}

local Chess = Item:new()

-------

Chess.name = "Chess"

function Chess.colors()
  return COLORS
end

function Chess.pieces()
  return PIECES
end

function Chess.parameterize()
  return coroutine.create(function()
    local color = coroutine.yield(COLORS)
    local piece = coroutine.yield(PIECES)
    return Chess:new({color = color, piece = piece})
  end)
end

function Chess.affect()
  return {}
end

-------

function Chess:new(o)
  o = o or Item:new(o)
  setmetatable(o, self)
  self.__index = self

  assert(utils.has(COLORS, o.color),
         "chess created with unsupported color: " .. o.color)
  assert(utils.has(PIECES, o.piece),
         "chess created with unsupported piece: " .. o.piece)

  o.width = W
  o.height = H

  local isLocal = not o.id
  o.id = o.id or ("chess_" .. o:genId())

  if isLocal then
    local o2 = utils.shallowCopy(o)
    o2.asset = nil
    SendEvent("new chess", o2)
  end

  o:redraw()

  return o
end

function Chess:draw()
  G.setColor(1, 1, 1, 1)
  G.draw(self.asset, self.x, self.y, D2R * self.rotation, S, S, w2, h2)
end

function Chess:redraw()
  self.asset = assets.gfx[electAsset(self)]
end

return Chess
