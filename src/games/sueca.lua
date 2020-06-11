--[[ 
    sets up sueca card game for 4 players
    https://en.wikipedia.org/wiki/Sueca_(card_game)

    Ace, 7, King, Jack, Queen, 6, 5, 4, 3, 2
    each player gets 10 cards and a zone to see his/her cards

          p2 (180)
p3 (-90)           p4 (90)
          p1 (0)
 ]] --
local consts = require "src.core.consts"
local utils = require "src.core.utils"
local settings = require "src.core.settings"

local Card = require "src.items.card"
-- local Counter = require "src.items.counter"
local Zone = require "src.items.zone"

local M = {}

M.setup = function()
  local zW = 400
  local zH = 120
  local pad = 80

  local rotations = {0, 180, 270, 90}

  local board = consts.board
  local handZones = {}
  local players = utils.shallowCopy(consts.roster)
  table.insert(players, 1, settings.username)

  assert(#players == 4, "sueca needs 4 players!")

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
  consts.board:setRotation(players[1], rotations[1])

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
  consts.board:setRotation(players[2], rotations[2])

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
  consts.board:setRotation(players[3], rotations[3])

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
  consts.board:setRotation(players[4], rotations[4])

  local cards = Card.several({"red"}, false,
                             {"a", "7", "k", "j", "q", "6", "5", "4", "3", "2"})
  cards = utils.shuffle(cards)

  -- assign hands
  local cardsPerHand = 10
  for zi, z in ipairs(handZones) do
    local x = utils.lerp(z.x, zc.x, 0.33)
    local y = utils.lerp(z.y, zc.y, 0.33)

    for _ = 1, cardsPerHand do
      local c = table.remove(cards)
      table.insert(board.items, c)
      if zi > 2 then c:rotate90() end
      c:turn()
      c:move(x, y)
    end
  end

  board:redraw()
end

return M
