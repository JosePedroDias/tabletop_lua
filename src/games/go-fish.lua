--[[ 
    sets up go fish card game to 2 to 4 players
    each player gets 5 cards, a counter and a zone to see his/her cards

          p2 (180)
p3 (-90)           p4 (90)
          p1 (0)
 ]] --
local consts = require "src.core.consts"
local utils = require "src.core.utils"
local settings = require "src.core.settings"

local Card = require "src.items.card"
local Counter = require "src.items.counter"
local Zone = require "src.items.zone"

local M = {}

M.setup = function()
  local zW = 400
  local zH = 120
  local pad = 80

  local rotations = {0, 180, -90, 90}

  local board = consts.board
  local handZones = {}
  local players = utils.shallowCopy(consts.roster)
  table.insert(players, 1, settings.username)

  local zc = Zone:new({
    x = consts.W / 2,
    y = consts.H / 2,
    width = zH,
    height = zH,
    color = {1, 1, 1, 0.25}
  })
  table.insert(board.items, zc)
  table.insert(board.zones, zc)

  ----

  local z1 = Zone:new({
    x = consts.W / 2,
    y = consts.H - pad,
    width = zW,
    height = zH,
    owner = players[1],
    layout = "x",
    color = {0, 0, 1, 0.25}
  })
  table.insert(board.items, z1)
  table.insert(board.zones, z1)
  table.insert(handZones, z1)
  SendEvent("setRotation", {to = players[1], rotation = rotations[1]})

  local z2 = Zone:new({
    x = consts.W / 2,
    y = pad,
    width = zW,
    height = zH,
    owner = players[2],
    layout = "x",
    direction = -1,
    color = {1, 0, 0, 0.25}
  })
  table.insert(board.items, z2)
  table.insert(board.zones, z2)
  table.insert(handZones, z2)
  SendEvent("setRotation", {to = players[2], rotation = rotations[2]})

  if #players > 2 then
    local z3 = Zone:new({
      x = pad,
      y = consts.H / 2,
      width = zH,
      height = zW,
      owner = players[3],
      layout = "y",
      rotation = 90,
      color = {0, 1, 1, 0.25}
    })
    table.insert(board.items, z3)
    table.insert(board.zones, z3)
    table.insert(handZones, z3)
    SendEvent("setRotation", {to = players[3], rotation = rotations[3]})
  end

  if #players > 3 then
    local z4 = Zone:new({
      x = consts.W - pad,
      y = consts.H / 2,
      width = zH,
      height = zW,
      owner = players[4],
      layout = "y",
      direction = -1,
      rotation = 90,
      color = {1, 1, 0, 0.25}
    })
    table.insert(board.items, z4)
    table.insert(board.zones, z4)
    table.insert(handZones, z4)
    SendEvent("setRotation", {to = players[4], rotation = rotations[4]})
  end

  local cards = Card.several({"blue"}, false)
  cards = utils.shuffle(cards)

  -- assign hands
  local cardsPerHand = 5
  for zi, z in ipairs(handZones) do
    local x = utils.lerp(z.x, zc.x, 0.25)
    local y = utils.lerp(z.y, zc.y, 0.25)
    local dx = 0
    local dy = 0

    if zi < 3 then
      dx = -zW / 2
    else
      dy = -zW / 2
    end

    for _ = 1, cardsPerHand do
      local c = table.remove(cards)

      table.insert(board.items, c)
      if zi > 2 then c:rotate90() end
      c:turn()
      c:move(x, y)
    end

    table.insert(board.items, Counter:new(
                   {x = x + dx, y = y + dy, rotation = rotations[zi]}))
  end

  -- assign remainer deck to center
  for _, c in ipairs(cards) do
    table.insert(board.items, c)
    c:turn()
    c:move(zc.x, zc.y)
    zc:add(c)
  end
  zc:doLayout(board)

  board:redraw()
end

return M
