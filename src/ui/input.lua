--[[ input - allows for editing and submitting text ]] --
local G = love.graphics

Input = {
  x = 0,
  y = 0,
  width = 100,
  height = 30,
  padding = 5,
  value = "",
  focused = false
}

function Input:new(o)
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

function Input:setValue(value)
  self.value = value
  self:redraw()
end

function Input:clear()
  self:setValue("")
end

function Input:draw()
  G.setColor(1, 1, 1, 1)
  G.draw(self.canvas, self.x, self.y)
end

function Input:redraw()
  G.setCanvas(self.canvas)
  G.clear(0, 0, 0, 0)

  pcall(G.setColor, self.background)
  G.rectangle("fill", 0, 0, self.width, self.height)

  pcall(G.setColor, self.color)
  local suffix = ""
  if self.focused then suffix = "|" end
  local text = self.value .. suffix
  G.print(text, self.padding, self.padding)

  G.setCanvas()
end

function Input:onKey(key)
  if not self.focused then return end
  if key == "backspace" then
    self.value = string.sub(self.value, 1, #self.value - 1)
    if self.onChange then self.onChange(self.value, self) end
    self:redraw()
  elseif key == "return" then
    if self.onSubmit then self.onSubmit(self.value, self) end
  end
end

function Input:onTextInput(text)
  self.value = self.value .. text
  if self.onChange then self.onChange(self.value, self) end
  self:redraw()
end

function Input:onPointer(x, y)
  local isHit = false
  if x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y +
    self.height then isHit = true end

  if self.focused and not isHit then
    self.focused = false
  elseif not self.focused and isHit then
    self.focused = true
  else
    return
  end
  self:redraw()
end