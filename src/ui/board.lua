--[[  ]] --
local assets = require "src.core.assets"

local G = love.graphics

Board = {
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
  o:redraw()
  return o
end

function Board:draw()
  G.setColor(1, 1, 1, 1)
  G.draw(self.canvas, self.x, self.y)
end

function Board:redraw()
  G.setCanvas(self.canvas)
  G.clear(0, 0, 0, 0)

  pcall(G.setColor, self.background)
  G.rectangle("fill", 0, 0, self.width, self.height)

  G.setColor(1, 1, 1, 1)
  G.draw(assets.gfx["cards_d2"], 20, 20)

  G.setCanvas()
end
