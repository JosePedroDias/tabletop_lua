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

  table.insert(o.items, Card:new({suit = "s", value = "5", x = 200, y = 300}))
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
  table.insert(o.items, Dice:new({color = "red", value = 2, x = 300, y = 500}))

  o:redraw()
  return o
end

function Board:showMenu(x, y, options)
  self.uiMenu = ArcMenu:new({
    x = x,
    y = y,
    dismissableFirst = true,
    labels = {"cancel", "spades", "diamonds", "clubs", "hearts"},
    callback = function(idx, label)
      print("got", idx, label)
      self.uiMenu = nil
      if idx > 1 then
        table.insert(self.items, Card:new(
                       {suit = label:sub(1, 1), value = "a", x = x, y = y}))
        self:redraw()
      end
    end
  })
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
  -- table.insert(self.items, 1, it)
end

function Board:onPointer(x, y)
  if self.uiMenu and self.uiMenu:onPointer(x, y) then return end

  -- for idx, it in ipairs(self.items) do
  for idx = #self.items, 1, -1 do
    local it = self.items[idx]

    local res = it:isHit(x, y)
    -- print("isHit(" .. tostring(utils.round(x)) .. "," .. tostring(utils.round(y)) .. ")", res, it.id)

    if res then
      self:bringToFront(it, idx)
      self.selectedItem = it
      self.selectedDelta = {x - it.x, y - it.y}
      self:redraw()
      return
    end

    --[[ if res then
      if it.id:sub(1, 1) == "c" then
        it:turn()
      else
        it:roll()
      end
      self:redraw()
      return res
    end ]]
  end

  self:showMenu(x, y)
end

function Board:onPointerMove(x, y)
  local it = self.selectedItem
  if it then
    it.x = x - self.selectedDelta[1]
    it.y = y - self.selectedDelta[2]
  end
  self:redraw()
end

function Board:onPointerUp(x, y)
  self.selectedItem = nil
end

return Board
