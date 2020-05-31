--[[ input - allows for editing and submitting text ]] --
local G = love.graphics

FPS = {x = 0, y = 0}

function FPS:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.font = o.font or G.getFont()
  o.color = o.color or {1, 1, 1, 1}
  o.i = 0
  return o
end

function FPS:update(t)
  self.i = self.i + 1
end

function FPS:draw()
  pcall(G.setColor, self.color)
  G.print("" .. self.i, self.x, self.y)
end
