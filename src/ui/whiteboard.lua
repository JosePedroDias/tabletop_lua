--[[ whiteboard - allows drawing ]] --
local consts = require "src.core.consts"

local G = love.graphics

local Button = require "src.ui.button"

local Whiteboard = {x = 0, y = 0, width = 200, height = 200}

function Whiteboard:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self

  o.background = o.background or {1, 1, 1, 1}
  o.color = o.color or {0, 0, 0, 1}
  o.radius = o.radius or 2

  o.canvas = G.newCanvas(o.width, o.height)
  o:clear()

  o.buttons = {}
  local y = o.height
  local x = 0
  local dx = 32

  local function onR(v)
    print(v)
    o:setPenRadius(v)
  end

  local rs = {2, 5, 8, 11, 14}
  for _, r in ipairs(rs) do
    table.insert(o.buttons, Button:new({
      label = "" .. r,
      x = x,
      y = y,
      value = r,
      onClick = onR
    }))
    x = x + dx
  end

  x = 0
  y = y + 32

  local function onC(v)
    print(v)
    o:setPenColorIndex(v)
  end

  local cs = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}
  for _, c in ipairs(cs) do
    table.insert(o.buttons, Button:new({
      x = x,
      y = y,
      value = c,
      background = consts.colors[c],
      onClick = onC
    }))
    x = x + dx
  end

  return o
end

function Whiteboard:draw()
  G.setColor(1, 1, 1, 1)
  G.draw(self.canvas, self.x, self.y)

  for _, b in ipairs(self.buttons) do b:draw() end
end

function Whiteboard:clear()
  G.setCanvas(self.canvas)

  pcall(G.clear, self.background)

  G.setCanvas()
end

function Whiteboard:getPenRadius()
  return self.radius
end

function Whiteboard:setPenRadius(r)
  self.radius = r
end

function Whiteboard:getPenColorIndex()
  return self.colorIndex
end

function Whiteboard:setPenColorIndex(ci)
  self.colorIndex = ci
  self.color = consts.colors[ci]
end

function Whiteboard:dot(x, y)
  G.setCanvas(self.canvas)

  pcall(G.setColor, self.color)
  G.circle("fill", x, y, self.radius)

  G.setCanvas()
end

function Whiteboard:lineSegment(x1, y1, x2, y2)
  G.setCanvas(self.canvas)

  G.setLineWidth(self.radius * 2)
  pcall(G.setColor, self.color)
  G.line(x1, y1, x2, y2)

  G.setCanvas()
end

function Whiteboard:onPointer(x, y)
  self.isDown = true
  self.lastPoint = {x, y}
  if x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y +
    self.height then
    self:dot(x, y)
    return true
  end

  for _, b in ipairs(self.buttons) do if b:onPointer(x, y) then return true end end
end

function Whiteboard:onPointerMove(x, y)
  if self.isDown and x >= self.x and x <= self.x + self.width and y >= self.y and
    y <= self.y + self.height then
    if self.lastPoint then
      self:lineSegment(self.lastPoint[1], self.lastPoint[2], x, y)
    else
      self:dot(x, y)
    end
    self.lastPoint = {x, y}
  end
end

function Whiteboard:onPointerUp(x, y)
  self.isDown = false
  self.lastPoint = nil
end

return Whiteboard
