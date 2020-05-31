--[[ manages the ui board ]] --
local assets = require "src.core.assets"

local Dice = require "src.items.dice"
local Card = require "src.items.card"

local G = love.graphics

local Board = {
  rotation = 0,
  width = 600,
  height = 600,
  x = 100,
  y = 0,
  background = {0.33, 0.66, 0.33, 1}
}

function Board:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.canvas = G.newCanvas(o.width, o.height)

  o.items = {}

  table.insert(o.items, Card:new({suit = "s", value = "5", x = 200, y = 300}))
  table.insert(o.items,
               Card:new({isJoker = true, x = 300, y = 300, rotation = 90}))
  table.insert(o.items, Card:new({
    suit = "s",
    value = "5",
    isTurned = true,
    x = 400,
    y = 300
  }))

  table.insert(o.items, Dice:new({value = 6, x = 200, y = 500}))
  table.insert(o.items, Dice:new({
    color = "red",
    value = 2,
    x = 300,
    y = 500,
    rotation = 45
  }))

  o:redraw()
  return o
end

function Board:draw()
  G.setColor(1, 1, 1, 1)
  G.draw(self.canvas, self.x, self.y)
end

function Board:redraw()
  G.setCanvas(self.canvas)

  pcall(G.clear, self.background)

  for _, it in ipairs(self.items) do it:draw() end

  G.setCanvas()
end

return Board
