--[[ manages the ui board ]] --
local consts = require "src.core.consts"
local utils = require "src.core.utils"

local ArcMenu = require "src.ui.arcmenu"

local Card = require "src.items.card"
local Chip = require "src.items.chip"
local Counter = require "src.items.counter"
local Dice = require "src.items.dice"
local Piece = require "src.items.piece"
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

  if consts.arg[2] then
    local z1 = Zone:new({
      x = consts.W / 2,
      y = 80,
      width = 600,
      height = 120,
      owner = "p2",
      layout = "x",
      color = {1, 0, 0, 0.25}
    })
    table.insert(o.items, z1)
    table.insert(o.zones, z1)

    local z2 = Zone:new({
      x = consts.W / 2,
      y = consts.H - 80,
      width = 600,
      height = 100,
      owner = "p1",
      layout = "x",
      -- rotation = 90,
      color = {0, 0, 1, 0.25}
    })
    table.insert(o.items, z2)
    table.insert(o.zones, z2)

    local z3 = Zone:new({
      x = consts.W / 2,
      y = consts.H / 2,
      width = 120,
      height = 120,
      color = {1, 1, 1, 0.25}
    })
    table.insert(o.items, z3)
    table.insert(o.zones, z3)

    local cards = Card.several({"blue"}, false)
    cards = utils.shuffle(cards)

    -- assign hands
    local cardsPerHand = 5
    local handZones = {z1, z2}
    for _, z in ipairs(handZones) do
      local y = utils.lerp(z.y, z3.y, 0.25)
      table.insert(o.items, Counter:new({x = z.x - 200, y = y}))
      for _ = 1, cardsPerHand do
        local c = table.remove(cards)
        table.insert(o.items, c)
        c:turn()
        c:move(z.x, y)
      end
    end

    -- assign to center z3
    for _, c in ipairs(cards) do
      table.insert(o.items, c)
      c:turn()
      c:move(z3.x, z3.y)
      z3:add(c)
    end
    z3:doLayout(o)
  end

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

    if it.name ~= "Zone" then
      local res = it:isHit(x, y)

      if res then
        self:bringToFront(it, idx)
        self.selectedItem = it
        self.moveFrames = 0
        self.selectedDelta = {x - it.x, y - it.y}
        self.initialPosition = {x, y}
        self:redraw()
        return
      end
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
  if not self.selectedItem then return end

  if self.selectedItem and self.moveFrames == 0 then
    self:affectItem(x, y, self.selectedItem)
  end
  local it = self.selectedItem
  self.selectedItem = nil

  -- print(x, y)
  local hitZone
  for i, zone in ipairs(self.zones) do
    if not hitZone then
      local hit = zone:isHit(x, y)
      if hit then hitZone = i end
    end
  end

  if hitZone then
    for i, zone in ipairs(self.zones) do
      if i == hitZone then
        zone:add(it)
        zone:doLayout(self)
      else
        zone:remove(it)
        zone:doLayout(self)
      end
    end
    self:redraw()
  elseif self.initialPosition then
    x = self.initialPosition[1]
    y = self.initialPosition[2]
    for _, zone in ipairs(self.zones) do
      local hit = zone:isHit(x, y)
      if hit then
        zone:remove(it)
        zone:doLayout(self)
        self:redraw()
        return
      end
    end
  end
end

function Board:getItemFromId(id)
  return utils.findByAttribute(self.items, "id", id)
end

function Board:onEvent(ev)
  -- print("received event", utils.tableToString(ev))
  local action = ev.action

  if action:sub(1, 4) == "new " then
    local cls
    if action == "new card" then
      cls = Card
    elseif action == "new chip" then
      cls = Chip
    elseif action == "new counter" then
      cls = Counter
    elseif action == "new dice" then
      cls = Dice
    elseif action == "new piece" then
      cls = Piece
    elseif action == "new zone" then
      cls = Zone
    else
      print("unsupported action", action)
      return
    end
    local it = cls:new(ev.data)
    table.insert(self.items, it)
    if it.name == "Zone" then table.insert(self.zones, it) end
  elseif action == "update" then
    local item = self:getItemFromId(ev.data.id)
    if not item then
      print("unknown item", ev.data.id)
      return
    end
    for k, v in pairs(ev.data) do item[k] = v end
    if ev.data.isTurned ~= nil or ev.data.value then item:redraw() end
  elseif action == "toFront" then
    local item, itemIdx = self:getItemFromId(ev.data.id)
    if not item then
      print("unknown item", ev.data.id)
      return
    end
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
