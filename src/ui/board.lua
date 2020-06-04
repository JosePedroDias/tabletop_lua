--[[ manages the ui board ]] --
local utils = require "src.core.utils"

local ArcMenu = require "src.ui.arcmenu"

local Dice = require "src.items.dice"
local Card = require "src.items.card"

local G = love.graphics

local Board = {
  rotation = 0,
  width = 600,
  height = 600,
  x = 0,
  y = 0,
  background = {0.33, 0.66, 0.33, 1}
}

function Board:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.canvas = G.newCanvas(o.width, o.height)

  o.items = {}

  --[[ table.insert(o.items, Card:new({suit = "s", value = "5", x = 200, y = 300}))
  table.insert(o.items,
               Card:new({isJoker = true, x = 300, y = 300, rotation = 90}))
  table.insert(o.items, Card:new({
    suit = "s",
    value = "5",
    isTurned = true,
    x = 400,
    y = 300
  }))

  table.insert(o.items, Dice:new({value = 6, x = 200, y = 500}))
  table.insert(o.items, Dice:new({color = "red", value = 2, x = 300, y = 500})) ]]

  o:redraw()
  return o
end

function Board:showCreateMenu(x, y)
  self.uiMenu = ArcMenu:new({
    x = x,
    y = y,
    dismissableFirst = true,
    labels = {"cancel", "add card", "add dice"},
    callback = function(idx)
      if idx == 1 then
        self.uiMenu = nil
        self:redraw()
        return
      end
      local it = Card
      if idx == 3 then it = Dice end
      self:showCreateMenu2(x, y, it)
    end
  })
end

function Board:showCreateMenu2(x, y, itemType)
  local co = itemType.parameterize()

  local function step(idx, label)
    if (idx == 1) then
      self.uiMenu = nil
      self:redraw()
      return
    end

    local _, options = coroutine.resume(co, label)
    local st = coroutine.status(co)

    if st == "dead" then
      self.uiMenu = nil
      options.x = x
      options.y = y
      table.insert(self.items, options)
      self:redraw()
    else
      local labels = utils.shallowCopy(options)
      table.insert(labels, 1, "cancel")
      self.uiMenu = ArcMenu:new({
        x = x,
        y = y,
        dismissableFirst = true,
        labels = labels,
        callback = step
      })
    end
  end

  step(0)
end

function Board:affectItem(x, y, item)
  local labels = utils.shallowCopy(item.affect())
  table.insert(labels, 1, "cancel")
  self.uiMenu = ArcMenu:new({
    x = x,
    y = y,
    dismissableFirst = true,
    labels = labels,
    callback = function(idx, value)
      self.uiMenu = nil
      if idx ~= 1 then
        self.dirty = true
        item[value](item)
        -- self:redraw() -- TODO FAILS?!
      end
    end
  })
end

function Board:update()
  if self.dirty then
    self.dirty = nil
    self:redraw()
  end
end

function Board:draw()
  G.setColor(1, 1, 1, 1)
  G.draw(self.canvas, self.x, self.y)

  if self.uiMenu then self.uiMenu:draw() end
end

function Board:redraw()
  G.setCanvas(self.canvas)

  pcall(G.clear, self.background)

  for _, it in ipairs(self.items) do it:draw() end

  G.setCanvas()
end

function Board:bringToFront(it, idx)
  if not idx then idx = utils.indexOf(self.items, it) end
  table.remove(self.items, idx)
  table.insert(self.items, it)
end

function Board:onPointer(x, y)
  if self.uiMenu and self.uiMenu:onPointer(x, y) then return end

  for idx = #self.items, 1, -1 do
    local it = self.items[idx]
    local res = it:isHit(x, y)

    if res then
      self:bringToFront(it, idx)
      self.selectedItem = it
      self.moveFrames = 0
      self.selectedDelta = {x - it.x, y - it.y}
      self:redraw()
      return
    end
  end

  self:showCreateMenu(x, y)
end

function Board:onPointerMove(x, y)
  local it = self.selectedItem
  if it then
    self.moveFrames = self.moveFrames + 1
    it.x = x - self.selectedDelta[1]
    it.y = y - self.selectedDelta[2]
    self:redraw()
  end
end

function Board:onPointerUp(x, y)
  if self.selectedItem and self.moveFrames == 0 then
    Board:affectItem(x, y, self.selectedItem)
  end
  self.selectedItem = nil
end

return Board
