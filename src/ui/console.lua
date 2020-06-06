--[[ console ui component - outputs lines in a translucent overlay ]] --
local Input = require "src.ui.input"

local G = love.graphics

local Console = {
  x = 0,
  y = 0,
  width = 400,
  height = 300,
  maxLines = 4,
  padding = 10
}

function Console:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.lines = o.lines or {}
  o.font = o.font or G.getFont()
  o.color = o.color or {1, 1, 1, 1}
  o.background = o.background or {0.2, 0.2, 0.2, 0.66}
  o.canvas = G.newCanvas(o.width, o.height)

  o.inputHeight = 40

  local console = o
  local input
  input = Input:new({
    x = 0 + o.x,
    y = o.height - o.inputHeight,
    width = 200,
    height = o.inputHeight,
    focused = true,
    onSubmit = function(msg)
      console:addLine(msg)
      SendEvent("say", msg)
      input:clear()
    end
  })

  o.input = input

  o:redraw()
  return o
end

function Console:addLine(line)
  table.insert(self.lines, line)
  if #self.lines > self.maxLines then table.remove(self.lines, 1) end
  self:redraw()
end

function Console:clear()
  self.lines = {}
  self:redraw()
end

function Console:draw()
  if self.dismissed then return end
  G.setColor(1, 1, 1, 1)
  G.draw(self.canvas, self.x, self.y)
  self.input:draw()
end

function Console:redraw()
  G.setCanvas(self.canvas)

  pcall(G.clear, self.background)

  pcall(G.setColor, self.color)
  local f = self.font
  local dy = math.floor(f:getHeight())

  for i, line in ipairs(self.lines) do
    G.print(line, self.padding, self.height - self.inputHeight - dy *
              (#self.lines - i + 2) + self.padding)
  end

  G.setCanvas()
end

function Console:toggle()
  self.dismissed = not self.dismissed
end

function Console:onKey(key)
  if key == "tab" then
    self:toggle()
  else
    self.input:onKey(key)
  end
end

function Console:onTextInput(text)
  if self.dismissed then return end
  self.input:onTextInput(text)
end

function Console:onPointer(x, y)
  if self.dismissed then return end
  return self.input:onPointer(x, y)
end

return Console
