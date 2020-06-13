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

local xNames = {"a", "b", "c", "d", "e", "f", "g", "h"}
local yNames = {8, 7, 6, 5, 4, 3, 2, 1}

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

  o.toCell = {}
  o.cells = {}
  local x0 = (1 / 16 - 1 / 2) * W
  local dx = W / 8
  for y = 0, 8 - 1 do
    for x = 0, 8 - 1 do
      local xl = xNames[x + 1]
      local yl = yNames[y + 1]
      local cell = {x = x0 + dx * x, y = x0 + dx * y, xl = xl, yl = yl}
      table.insert(o.cells, cell)
      o.toCell[xl .. tostring(yl)] = cell
    end
  end

  if isLocal then
    local o2 = utils.shallowCopy(o)
    o2.asset = nil
    SendEvent("new gameboard", o2)
  end

  return o
end

function GameBoard:getCell(label)
  return self.toCell[label]
end

function GameBoard:draw()
  G.setColor(1, 1, 1, 1)
  G.draw(self.asset, self.x, self.y, 0, S, S, w2, h2)
end

function GameBoard:nearestCell(x_, y_)
  local x = x_ - self.x
  local y = y_ - self.y
  local bestDist = 100000
  local bestCell
  for _, c in ipairs(self.cells) do
    local dist = utils.distSquared(x, y, c.x, c.y)
    if dist < bestDist then
      bestDist = dist
      bestCell = c
    end
  end
  return bestCell, bestDist
end

return GameBoard
