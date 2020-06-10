--[[ console ui component - outputs lines in a translucent overlay ]] --
local settings = require "src.core.settings"

local Input = require "src.ui.input"
local cc = require "src.ui.console_commands"

local G = love.graphics

local Console = {
  x = 0,
  y = 0,
  width = 400,
  height = 300,
  maxLines = 4,
  padding = 10,
  history = {}
  -- historyIndex
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
    width = o.width,
    height = o.inputHeight,
    focused = true,
    onSubmit = function(msg)
      if msg ~= self.history[#self.history] then
        table.insert(self.history, msg)
      end
      if #self.history > 20 then table.remove(self.history, 1) end

      if msg:sub(1, 1) == "/" then
        console:addLine(msg)
        local out = cc.processCommand(msg:sub(2))
        if type(out) == "string" then
          console:addLine(out)
        else
          for _, line in ipairs(out) do console:addLine(line) end
        end
      else
        console:addLine(os.date("%H:%M ") .. settings.username .. ": " .. msg)
        SendEvent("say", msg)
      end

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
  G.setFont(f)

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
  elseif key == "up" then
    if #self.history == 0 then return end
    if not self.historyIndex then
      self.historyIndex = #self.history
      self.input:setValue(self.history[self.historyIndex])
    else
      self.historyIndex = self.historyIndex - 1
      if self.historyIndex == 0 then self.historyIndex = #self.history end
      self.input:setValue(self.history[self.historyIndex])
    end
  elseif key == "down" then
    if #self.history == 0 then return end
    if not self.historyIndex then
      self.historyIndex = 1
      self.input:setValue(self.history[self.historyIndex])
    else
      self.historyIndex = self.historyIndex + 1
      if self.historyIndex > #self.history then self.historyIndex = 1 end
      self.input:setValue(self.history[self.historyIndex])
    end
  else
    self.historyIndex = nil
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
