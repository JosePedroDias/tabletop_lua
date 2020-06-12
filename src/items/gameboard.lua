--[[ gameboard - somewhat similar to a zone but not ]] --
local assets = require "src.core.assets"
local utils = require "src.core.utils"

local Item = require "src.items.item"

local G = love.graphics

local GameBoard = Item:new()

-------

local W = 1024
local H = 1024

local w2 = W / 2
local h2 = H / 2
local S = 0.6

W = W * S
H = H * S

GameBoard.name = "GameBoard"

function GameBoard.affect()
  return {}
end

-------

function GameBoard:new(o)
  o = o or Item:new(o)
  setmetatable(o, self)
  self.__index = self

  o.width = W
  o.height = H

  o.asset = assets.gfx.chessboard

  local isLocal = not o.id
  o.id = "gameboard_" .. o:genId()

  if isLocal then
    local o2 = utils.shallowCopy(o)
    o2.asset = nil
    SendEvent("new gameboard", o2)
  end

  return o
end

function GameBoard:draw()
  G.setColor(1, 1, 1, 1)
  -- G.draw(assets.gfx.chessboard)
  G.draw(self.asset, self.x, self.y, 0, S, S, w2, h2)
end

return GameBoard
