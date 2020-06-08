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
    y = pad,
    width = zW,
    height = zH,
    owner = players[2],
    layout = "x",
    color = {1, 0, 0, 0.25}
  })
  table.insert(board.items, z1)
  table.insert(board.zones, z1)
  table.insert(handZones, z1)
  SendEvent("setRotation", {to = players[1], rotation = 0})

  local z2 = Zone:new({
    x = consts.W / 2,
    y = consts.H - pad,
    width = zW,
    height = zH,
    owner = players[1],
    layout = "x",
    color = {0, 0, 1, 0.25}
  })
  table.insert(board.items, z2)
  table.insert(board.zones, z2)
  table.insert(handZones, z2)
  SendEvent("setRotation", {to = players[2], rotation = 180})

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
    SendEvent("setRotation", {to = players[3], rotation = -90})
  end

  if #players > 3 then
    local z4 = Zone:new({
      x = consts.W - pad,
      y = consts.H / 2,
      width = zH,
      height = zW,
      owner = players[4],
      layout = "y",
      rotation = 90,
      color = {1, 1, 0, 0.25}
    })
    table.insert(board.items, z4)
    table.insert(board.zones, z4)
    SendEvent("setRotation", {to = players[4], rotation = 90})
  end

  local cards = Card.several({"blue"}, false)
  cards = utils.shuffle(cards)

  -- assign hands
  local cardsPerHand = 5
  for zi, z in ipairs(handZones) do
    local x = utils.lerp(z.x, zc.x, 0.25)
    local y = utils.lerp(z.y, zc.y, 0.25)
    table.insert(board.items, Counter:new({x = x, y = y}))
    for _ = 1, cardsPerHand do
      local c = table.remove(cards)
      if zi > 2 then c.rotation = 90 end
      table.insert(board.items, c)
      c:turn()
      c:move(x, y)
    end
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
