--[[ console ui component - outputs lines in a translucent overlay ]] --
local G = love.graphics

Console = {x = 0, y = 0, width = 400, height = 300, maxLines = 4, padding = 10}

function Console:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.lines = o.lines or {}
  o.font = o.font or G.getFont()
  o.color = o.color or {1, 1, 1, 1}
  o.background = o.background or {0.2, 0.2, 0.2, 0.66}
  o.canvas = G.newCanvas(o.width, o.height)
  o:redraw()
  return o
end

function Console:addLine(line)
  table.insert(self.lines, line)
  if #self.lines > self.maxLines then return table.remove(self.lines, 1) end
  self:redraw()
end

function Console:clear()
  self.lines = {}
  self:redraw()
end

function Console:draw()
  G.setColor(1, 1, 1, 1)
  G.draw(self.canvas, self.x, self.y)
end

function Console:redraw()
  G.setCanvas(self.canvas)
  G.clear(0, 0, 0, 0)

  pcall(G.setColor, self.background)
  G.rectangle("fill", 0, 0, self.width, self.height)

  pcall(G.setColor, self.color)
  local f = self.font
  local dy = math.floor(f:getHeight())

  for i, line in ipairs(self.lines) do
    G.print(line, self.padding,
            self.height - dy * (#self.lines - i + 2) + self.padding)
  end

  G.setCanvas()
end
