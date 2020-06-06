--[[ manages the ui board ]] --
local utils = require "src.core.utils"

local ArcMenu = require "src.ui.arcmenu"

local Dice = require "src.items.dice"
local Card = require "src.items.card"
local Piece = require "src.items.piece"
local Chip = require "src.items.chip"
local Counter = require "src.items.counter"
local Zone = require "src.items.zone"

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
  o.zones = {}

  local z1 = Zone:new({
    x = 200,
    y = 0 + 20,
    width = 600,
    height = 100,
    owner = "player2",
    color = {1, 0, 0, 0.25}
  })
  table.insert(o.items, z1)
  table.insert(o.zones, z1)

  local z2 = Zone:new({
    x = 200,
    y = 1000 - 100 - 20,
    width = 600,
    height = 100,
    owner = "player1",
    color = {1, 1, 1, 0.25}
  })
  table.insert(o.items, z2)
  table.insert(o.zones, z2)

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

  --[[ table.insert(o.items, Dice:new({value = 6, x = 200, y = 500}))
  table.insert(o.items, Dice:new({color = "red", value = 2, x = 300, y = 500})) ]]

  o:redraw()
  return o
end

function Board:showCreateMenu(x, y)
  self.uiMenu = ArcMenu:new({
    x = x,
    y = y,
    dismissableFirst = true,
    labels = {
      "cancel", "add card", "add dice", "add piece", "add chip", "add counter"
    },
    callback = function(idx)
      if idx == 1 then
        self.uiMenu = nil
        self:redraw()
        return
      end
      local it = Card
      if idx == 3 then
        it = Dice
      elseif idx == 4 then
        it = Piece
      elseif idx == 5 then
        it = Chip
      elseif idx == 6 then
        it = Counter
      end
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
      options:move(x, y)
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
  table.insert(labels, 1, "delete")
  table.insert(labels, 1, "cancel")
  self.uiMenu = ArcMenu:new({
    x = x,
    y = y,
    dismissableFirst = true,
    labels = labels,
    callback = function(idx, value)
      self.uiMenu = nil
      if idx == 1 then
        return
      elseif idx == 2 then
        self:delete(item)
      else
        item[value](item)
      end
      self:redraw()
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

function Board:delete(it, idx, isRemote)
  if not idx then idx = utils.indexOf(self.items, it) end
  table.remove(self.items, idx)
  if not isRemote then SendEvent("delete", {id = it.id}) end
end

function Board:bringToFront(it, idx, isRemote)
  if not idx then idx = utils.indexOf(self.items, it) end
  table.remove(self.items, idx)
  table.insert(self.items, it)
  if not isRemote then SendEvent("toFront", {id = it.id}) end
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
    it:move(x - self.selectedDelta[1], y - self.selectedDelta[2])
    self:redraw()
  end
end

function Board:onPointerUp(x, y)
  if self.selectedItem and self.moveFrames == 0 then
    self:affectItem(x, y, self.selectedItem)
  end
  self.selectedItem = nil

  for i, zone in ipairs(self.zones) do
    -- local hit = zone:isHit(x, y)
    -- print(i, hit)
  end
end

function Board:getItemFromId(id)
  return utils.findByAttribute(self.items, "id", id)
end

function Board:onEvent(ev)
  -- print("received event", utils.tableToString(ev))
  local action = ev.action

  if action:sub(1, 4) == "new " then
    local cls = Card
    if action == "new chip" then
      cls = Chip
    elseif action == "new counter" then
      cls = Counter
    elseif action == "new dice" then
      cls = Dice
    elseif action == "new piece" then
      cls = Piece
    else
      print("unsupported action")
      return
    end
    table.insert(self.items, cls:new(ev.data))
  elseif action == "update" then
    local item = self:getItemFromId(ev.data.id)
    for k, v in pairs(ev.data) do item[k] = v end
    if ev.data.isTurned ~= nil or ev.data.value then item:redraw() end
  elseif action == "toFront" then
    local item, itemIdx = self:getItemFromId(ev.data.id)
    self:bringToFront(item, itemIdx, true)
  elseif action == "delete" then
    local item, itemIdx = self:getItemFromId(ev.data.id)
    self:delete(item, itemIdx, true)
  else
    print("unsupported action", action)
    return
  end
  self:redraw()
end

return Board
