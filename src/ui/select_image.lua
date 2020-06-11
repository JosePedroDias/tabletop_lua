--[[ select image - allow picking one out of several images. currently selected gets previewed, navigation done by buttons ]] --
local Button = require "src.ui.button"
local utils = require "src.core.utils"
local cropper = require "src.ui.cropper"

local G = love.graphics

local SelectImage = {x = 0, y = 0, width = 200, height = 200}

function SelectImage:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.font = o.font or G.getFont()
  o.color = o.color or {0, 0, 0, 1}
  o.background = o.background or {0, 0, 0, 0}
  o.selectedIndex = 1
  o.canvas = G.newCanvas(o.width, o.height)
  print(o.width, o.height)

  o.list = utils.map(o.list, function(img)
    return cropper(img, 200, 200) -- TODO
  end)

  local buttonW = 20
  local buttonBg = {0.33, 0.33, 0.33, 1}

  o.prev = Button:new({
    x = 0,
    y = 0,
    width = buttonW,
    height = o.height,
    background = buttonBg,
    label = "<",
    onClick = function()
      o:toPrevious()
    end
  })

  o.next = Button:new({
    x = o.width - buttonW,
    y = 0,
    width = buttonW,
    height = o.height,
    background = buttonBg,
    label = ">",
    onClick = function()
      o:toNext()
    end
  })

  o:redraw()
  return o
end

function SelectImage:getValue()
  return self.selectedIndex
end

function SelectImage:toPrevious()
  if self.selectedIndex > 1 then
    self.selectedIndex = self.selectedIndex - 1
  else
    self.selectedIndex = #self.list
  end
  self:redraw()
end

function SelectImage:toNext()
  if self.selectedIndex < #self.list then
    self.selectedIndex = self.selectedIndex + 1
  else
    self.selectedIndex = 1
  end
  self:redraw()
end

function SelectImage:draw()
  G.setColor(1, 1, 1, 1)
  G.draw(self.canvas, self.x, self.y)
end

function SelectImage:redraw()
  G.setCanvas(self.canvas)

  pcall(G.clear, self.background)

  print(self.selectedIndex)
  G.setColor(1, 1, 1, 1)
  G.draw(self.list[self.selectedIndex], 20, 0)

  self.prev:draw()
  self.next:draw()

  G.setCanvas()
end

function SelectImage:onPointer(x, y)
  local x1 = x - self.x
  local y1 = y - self.y
  if self.prev:onPointer(x1, y1) then return end
  if self.next:onPointer(x1, y1) then return end

  if x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y +
    self.height then if self.onClick then self.onClick(self.value) end end
end

return SelectImage
