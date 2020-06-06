--[[ counter ]] --
require "src.items.item"

local utils = require "src.core.utils"

local Item = require "src.items.item"

local G = love.graphics

local D2R = math.pi / 180

local Counter = Item:new()

-------

Counter.name = "Counter"

function Counter.parameterize()
  return coroutine.create(function()
    -- local color = coroutine.yield({"a", "b"})
    return Counter:new({})
  end)
end

function Counter.affect()
  return {"reset", "inc1", "dec1", "inc10", "dec10"}
end

-------

function Counter:new(o)
  o = o or Item:new(o)
  setmetatable(o, self)
  self.__index = self

  o.value = o.value or 0
  assert(o.value and type(o.value) == "number", "value must be a number")

  o.width = o.width or 40
  assert(o.width and type(o.width) == "number", "width must be a number")

  o.height = o.height or 24
  assert(o.height and type(o.height) == "number", "height must be a number")

  o.color = o.color or {1, 1, 1, 1}
  assert(o.color and type(o.color) == "table" and #o.color == 4,
         "color must be a table with 4 elements")

  o.font = o.font or G.getFont()

  local isLocal = not o.id
  o.id = o.id or ("counter_" .. o:genId())

  if isLocal then
    local o2 = utils.shallowCopy(o)
    o2.asset = nil
    SendEvent("new counter", o2)
  end

  o.canvas = G.newCanvas(o.width, o.height)
  o:redraw()

  return o
end

function Counter:redraw()
  G.setCanvas(self.canvas)

  pcall(G.clear, {0, 0, 0, 0})
  pcall(G.setColor, self.color)
  G.setFont(self.font)

  G.rectangle("line", 0, 0, self.width, self.height)

  local txt = tostring(self.value)
  local x = math.floor((self.width - self.font:getWidth(txt)) / 2)
  local y = math.floor((self.height - self.font:getHeight()) / 2)
  G.print(txt, x, y)

  G.setCanvas()
end

function Counter:draw()
  G.setColor(1, 1, 1, 1)
  -- G.draw(self.canvas, self.x, self.y)
  G.draw(self.canvas, self.x, self.y, D2R * self.rotation, 1, 1, self.width / 2,
         self.height / 2)
end

function Counter:setValue(v)
  self.value = v
  self:redraw()
end

function Counter:reset()
  self:setValue(0)
end

function Counter:inc1()
  self:setValue(self.value + 1)
end

function Counter:dec1()
  self:setValue(self.value - 1)
end

function Counter:inc10()
  self:setValue(self.value + 10)
end

function Counter:dec10()
  self:setValue(self.value - 10)
end

return Counter
