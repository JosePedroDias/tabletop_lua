--[[ button - allows action activation ]] --
local G = love.graphics

local ColorPicker = {x = 0, y = 0, cellwidth = 30, cellheight = 30, pad=2, rows=4, cols=4, highlightColor = {1, 1, 0, 1}}

function ColorPicker:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.value = o.value or 1
  o.dx = o.cellwidth + 2 * o.pad
  o.dy = o.cellheight + 2 * o.pad
  o.width = o.dx * o.cols
  o.height = o.dy * o.rows
  o.canvas = G.newCanvas(o.width, o.height)
  o:redraw()
  return o
end

function ColorPicker:draw()
  G.setColor(1, 1, 1, 1)
  G.draw(self.canvas, self.x, self.y)
end

function ColorPicker:redraw()
  G.setCanvas(self.canvas)

  pcall(G.clear, {0,0,0,0})

  local i = 1
  for y = 1, self.rows do
    for x = 1, self.cols do
        if self.value == i then
        pcall(G.setColor, self.highlightColor)
        G.rectangle(
            'fill',
            (x-1)*self.dx,
            (y-1)*self.dy,
            self.cellwidth + 2*self.pad,
            self.cellheight + 2*self.pad
        )
        end

      pcall(G.setColor, self.colors[i])
      G.rectangle(
        'fill',
        (x-1)*self.dx + self.pad,
        (y-1)*self.dy + self.pad,
        self.cellwidth,
        self.cellheight
      )
      
      i = i + 1
    end
  end

  G.setCanvas()
end

function ColorPicker:onPointer(x, y)
  if x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height then
    local X = x - self.x
    local Y = y - self.y
    local col = math.floor(X / self.dx)
    local row = math.floor(Y / self.dy)
    self.value = col + row * self.cols + 1
    self:redraw()
        if self.onClick then
            self.onClick(self.value)
        end
  end
end

return ColorPicker
