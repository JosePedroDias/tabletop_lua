--[[ button - allows action activation ]] --
local G = love.graphics

local Button = {x = 0, y = 0, width = 30, height = 30, padding = 5, label = nil}

function Button:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.font = o.font or G.getFont()
  o.color = o.color or {0, 0, 0, 1}
  o.background = o.background or {1, 1, 1, 1}
  o.canvas = G.newCanvas(o.width, o.height)
  o:redraw()
  return o
end

function Button:draw()
  G.setColor(1, 1, 1, 1)
  G.draw(self.canvas, self.x, self.y)
end

function Button:redraw()
  G.setCanvas(self.canvas)

  pcall(G.clear, self.background)

  local f = self.font
  G.setFont(f)
  local dy = math.floor(f:getHeight())

  if self.label then
    pcall(G.setColor, self.color)
    G.print(self.label, self.padding, (self.height - dy) / 2)
  end

  G.setCanvas()
end

function Button:onPointer(x, y)
  if x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y +
    self.height then if self.onClick then self.onClick(self.value) end end
end

return Button
