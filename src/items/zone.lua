--[[ zone - changes visibility of items and lays them out ]] --
local utils = require "src.core.utils"
local settings = require "src.core.settings"

local Item = require "src.items.item"

local G = love.graphics

local Zone = Item:new()

-------

Zone.name = "Zone"

-- owner (optional)
-- layout: center, x, y -> direction sort based on actual item axis
-- direction: 1, -1

local LAYOUTS = {"center", "x", "y"}

-------

function Zone:new(o)
  o = o or Item:new(o)
  setmetatable(o, self)
  self.__index = self

  o.color = o.color or {1, 1, 1, 0.25}
  o.textColor = o.textColor or {0, 0, 0, 1}

  o.items = {}

  o.x = o.x or 0
  o.y = o.y or 0
  o.width = o.width or 300
  o.height = o.height or 50
  o.layout = o.layout or "center"
  o.direction = o.direction or 1
  assert(utils.has(LAYOUTS, o.layout),
         "zone created with unsupported layout: " .. o.layout)

         o.font = o.font or G.getFont()

  local isLocal = not o.id
  o.id = "zone_" .. o:genId()

  if isLocal then
    local o2 = utils.shallowCopy(o)
    o2.asset = nil
    SendEvent("new zone", o2)
  end

  o.canvas = G.newCanvas(o.width, o.height)
  o:redraw()

  return o
end

function Zone:redraw()
  G.setCanvas(self.canvas)

  pcall(G.clear, {0, 0, 0, 0})

  pcall(G.setColor, self.color)
  G.rectangle("fill", 0, 0, self.width, self.height)

  pcall(G.setColor, self.textColor)
  if self.label then
    local x = 0
    local y = self.height - self.font:getHeight()
    G.print(self.label, x, y)
  end

  G.setCanvas()
end

function Zone:draw()
  G.setColor({1, 1, 1, 1})
  G.draw(self.canvas, self.x- self.width / 2, self.y - self.height / 2)
end

function Zone:remove(it)
  for i, v in ipairs(self.items) do
    if v == it then
      table.remove(self.items, i)
      if it.name == 'Card' then
        it:face_down()
        pcall(it.redraw, it)
      end
      return true
    end
  end
  return false
end

function Zone:add(it)
  for _, v in ipairs(self.items) do if v == it then return false end end
  table.insert(self.items, it)
  local dirty = false
  if it.name == 'Card' then
    if self.owner == settings.username then
      it:face_down()
      it:face_up(true)
      dirty = true
    end
  end
  if utils.hasKey(self, "rotation") and it.rotation ~= self.rotation then
    if it.name == 'Card' then
      it.rotation = self.rotation
      dirty = true
    end
  end
  if dirty then pcall(it.redraw, it) end
  return true
end

function Zone:doLayout(board)
  assert(board and type(board.bringToFront) == "function",
         "zone:doLayout must be passed the board instance")

  local n = #self.items
  if n == 0 then return end

  if self.layout == "center" then
    for _, it in ipairs(self.items) do
      it:move(self.x, self.y)
      board:bringToFront(it)
    end
    return
  end

  if n == 1 then
    self.items[1]:move(self.x, self.y)
    board:bringToFront(self.items[1])
    return
  end

  local itemDim, x, y, span, dx, dy

  if self.layout == "x" then
    itemDim = self.items[1].width
    y = self.y
    x = self.x - (self.width - itemDim) / 2 * self.direction
    span = (self.width - itemDim)
    dx = span / (n - 1) * self.direction
    dy = 0
    table.sort(self.items, function(l, r)
      return l.x < r.x
    end)
  else
    itemDim = self.items[1].height
    x = self.x
    y = self.y - (self.height - itemDim) / 2 * self.direction
    span = (self.height - itemDim)
    dy = span / (n - 1) * self.direction
    dx = 0
    table.sort(self.items, function(l, r)
      return l.y < r.y
    end)
  end

  local nn = #self.items
  for i = 1, nn do
    local it
    if self.direction == 1 then
      it = self.items[i]
    else
      it = self.items[nn + 1 - i]
    end
    it:move(x, y)
    board:bringToFront(it)
    x = x + dx
    y = y + dy
  end
end

return Zone
