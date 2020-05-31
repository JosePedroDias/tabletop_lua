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

  pcall(G.clear, self.background)

  G.setColor(1, 1, 1, 1)
  -- ( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
  G.draw(assets.gfx["cards_d2"], 300, 300, math.pi / 180 * 90, 0.5, 0.5, 70, 95) -- 140x190

  G.setCanvas()
end
