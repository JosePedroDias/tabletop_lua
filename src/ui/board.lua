--[[ manages the ui board ]] --
local assets = require "src.core.assets"
local consts = require "src.core.consts"
local utils = require "src.core.utils"
local settings = require "src.core.settings"

local ArcMenu = require "src.ui.arcmenu"

local Card = require "src.items.card"
local Chip = require "src.items.chip"
local Counter = require "src.items.counter"
local Dice = require "src.items.dice"
local Piece = require "src.items.piece"
local Zone = require "src.items.zone"

local G = love.graphics
local A = love.audio

local D2R = math.pi / 180

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
  o.canvas2 = G.newCanvas(o.width, o.height)

  o.items = {}
  o.zones = {}

  o:redraw()
  o:redrawOverlays()
  return o
end

function Board:mapCoords(x, y)
  if self.rotation == 0 then
    return x, y
  elseif self.rotation == 90 then
    return y, self.width - x
  elseif self.rotation == 180 then
    return self.width - x, self.height - y
  else
    return self.height - y, x
  end
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
      x, y = self:mapCoords(x, y)
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
        if value == "roll" then self:playSound("dies_shuffle") end
        if value == "turn" then self:playSound("cards_slide1") end
      end
      self:redraw()
    end
  })
end

function Board:draw()
  G.setColor(1, 1, 1, 1)

  if self.rotation == 0 then
    G.draw(self.canvas, 0, 0, 0)
  elseif self.rotation == 90 then
    G.draw(self.canvas, self.width, 0, D2R * 90)
  elseif self.rotation == 180 then
    G.draw(self.canvas, self.width, self.height, D2R * 180)
  else
    G.draw(self.canvas, 0, self.height, D2R * -90)
  end

  G.setColor(1, 1, 1, 0.66)
  G.draw(self.canvas2, 0, 0, 0)
  G.setColor(1, 1, 1, 1)

  if self.uiMenu then self.uiMenu:draw() end
end

function Board:redraw()
  G.setCanvas(self.canvas)

  pcall(G.clear, self.background)

  for _, it in ipairs(self.items) do it:draw() end

  G.setCanvas()
end

local function getPosFromRelativeRots(myRot, otherRot)
  assert(type(myRot) == "number", "myRot must be a number")
  assert(type(otherRot) == "number", "otherRot must be a number")

  -- print(settings.username, myRot, otherRot)
  local W = 96 + 20
  local gap = 300

  local diff = myRot - otherRot
  if diff < 0 then diff = diff + 360 end

  if diff == 0 then -- down
    return (consts.W - W) / 2 - gap, (consts.H - W) - 10
  elseif diff == 180 then -- up
    return (consts.W - W) / 2 + gap, 0
  elseif diff == 90 then -- left
    return 0, (consts.H - W) / 2 - gap
  else -- right
    return consts.W - W, (consts.H - W) / 2 + gap
  end
end

function Board:redrawOverlays()
  -- print(settings.username .. " - redrawOverlays " .. tostring(utils.countKeys(consts.userData)))

  G.setCanvas(self.canvas2)

  pcall(G.clear, {0, 0, 0, 0})

  local pad = 5
  local W = 96
  local x = 0
  local y = 0

  -- local f = self.font
  -- G.setFont(f)
  local f = G.getFont()

  for username, ud in pairs(consts.userData) do
    x, y = getPosFromRelativeRots(self.rotation, ud.rotation)

    local color = consts.colors[ud.color]

    pcall(G.setColor, color)
    G.rectangle("fill", x, y, W + pad * 2, W + pad * 2)

    G.setColor(1, 1, 1, 1)
    G.draw(consts.avatars[username], x + pad, y + pad)

    G.setColor(0, 0, 0, 1)
    local dx = f:getWidth(username)
    G.print(username, x + pad + (W - dx) / 2, y + pad + W)
  end

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

function Board:playSound(soundName, isRemote)
  A.play(assets.sfx[soundName])
  if not isRemote then SendEvent("playSound", {soundName = soundName}) end
end

function Board:onPointer(x, y)
  local x_ = x
  local y_ = y

  if self.uiMenu and self.uiMenu:onPointer(x, y) then return end

  x, y = self:mapCoords(x, y)

  for idx = #self.items, 1, -1 do
    local it = self.items[idx]

    if it.name ~= "Zone" then
      local res = it:isHit(x, y)

      if res then
        self:bringToFront(it, idx)
        self.selectedItem = it
        self.moveFrames = 0
        self.selectedDelta = {x - it.x, y - it.y}
        self:refreshZoneAssignments()
        self.initialZone = self:itemHitsAZone(it)
        self:redraw()

        -- if it.name == "Card" then self:playSound("cards_place1") end

        return
      end
    end
  end

  self:showCreateMenu(x_, y_)
end

function Board:onPointerMove(x, y)
  x, y = self:mapCoords(x, y)

  local it = self.selectedItem
  if it then
    self.moveFrames = self.moveFrames + 1
    it:move(x - self.selectedDelta[1], y - self.selectedDelta[2])
    self:redraw()
  end
end

function Board:itemHitsAZone(it)
  for zi, zone in ipairs(self.zones) do
    if zone:isHitByItem(it) then return zone, zi end
  end
end

function Board:onPointerUp(x, y)
  local x_ = x
  local y_ = y

  if not self.selectedItem then return end

  local it = self.selectedItem

  x, y = self:mapCoords(x, y)

  if self.moveFrames == 0 then
    self:affectItem(x_, y_, self.selectedItem)
  else
    if it.name == "Card" then
      self:playSound("cards_place1")
    elseif it.name == "Chip" then
      self:playSound("chips_collide1")
    end
  end

  self.selectedItem = nil

  local hitZone = self:itemHitsAZone(it)

  if self.initialZone then
    self.initialZone:remove(it)
    self.initialZone:doLayout(self)
  end

  if hitZone then
    hitZone:add(it)
    hitZone:doLayout(self)
  end

  if self.initialZone or hitZone then self:redraw() end
end

function Board:getItemFromId(id)
  return utils.findByAttribute(self.items, "id", id)
end

function Board:refreshZoneAssignments()
  for _, zone in ipairs(self.zones) do
    zone.items = {}
    for _, it in ipairs(self.items) do
      if it.name ~= "Zone" and zone:isHitByItem(it) then
        table.insert(zone.items, it)
      end
    end
  end
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
  elseif action == "setRotation" then
    self:setRotation(ev.data.to, ev.data.rotation, true)
  elseif action == "playSound" then
    self:playSound(ev.data.soundName, true)
  elseif action == "resetBoard" then
    self:reset(true)
  else
    print("unsupported action", action)
    return
  end
  self:redraw()
end

function Board:setRotation(username, rot, isRemote)
  assert(type(username) == "string", "username must be passed as string")
  assert(type(rot) == "number", "rot must be passed as number")

  if username == settings.username then
    self.rotation = rot
    self:redraw()
  end

  if consts.userData[username] then
    consts.userData[username].rotation = rot
    -- else
    --  print(settings.username .. ": do not know data of " .. username)
  end

  if not isRemote then
    SendEvent("setRotation", {to = username, rotation = rot})
  end

  self:redrawOverlays()
end

function Board:reset(isRemote)
  self.items = {}
  self.zones = {}
  if not isRemote then SendEvent("resetBoard") end
end

local REFERENCE_PLAYER_ORDER = {"p1", "p2", "p3", "p4", "S", "N", "W", "E"}

function Board:getPlayers(minAttendance, maxAttendance)
  local players = utils.shallowCopy(consts.roster)
  table.insert(players, 1, settings.username)

  local randomOrder = false
  if not randomOrder then
    -- to enforce an order
    table.sort(players, function(l, r)
      return utils.find(REFERENCE_PLAYER_ORDER, l) <
               utils.find(REFERENCE_PLAYER_ORDER, r)
    end)
  else
    -- ..or shuffle
    players = utils.shuffle(players)
  end

  assert(#players >= minAttendance and #players <= maxAttendance,
         "game requires " .. minAttendance .. " to " .. maxAttendance ..
           " players!")
  return players
end

return Board
