--[[ playing card ]] --
local assets = require "src.core.assets"
local utils = require "src.core.utils"

local Item = require "src.items.item"

local G = love.graphics

local D2R = math.pi / 180

local function electAsset(o)
  if o.isTurned then
    return "cards_back_" .. o.back
  elseif o.isJoker then
    return "cards_joker"
  else
    return "cards_" .. o.suit .. o.value
  end
end

local W = 140
local H = 190

local w2 = W / 2
local h2 = H / 2
local S = 0.5

W = W * S
H = H * S

local SUITS = {"c", "h", "s", "d"}
local VALUES = {
  "2", "3", "4", "5", "6", "7", "8", "9", "10", "j", "q", "k", "a"
}
local BACKS = {"blue", "green", "red"}

-- suit - CHSD Clubs Hearts Spades Diamonds
-- value - 2 3 4 5 6 7 8 9 10 J Q K A
-- back - blue green red
-- isJoker
local Card = Item:new()

-------

Card.name = "Card"

function Card.backs()
  return BACKS
end

function Card.suits()
  return SUITS
end

function Card.values()
  return VALUES
end

function Card.parameterize()
  return coroutine.create(function()
    local back = coroutine.yield(BACKS)
    local joker = coroutine.yield({"joker", "other"})
    if joker == "joker" then return Card:new({back = back, isJoker = true}) end
    local value = coroutine.yield(VALUES)
    local suit = coroutine.yield(SUITS)
    return Card:new({back = back, value = value, suit = suit})
  end)
end

function Card.affect()
  return {"turn", "rotate90"}
end

-------

function Card:new(o)
  o = o or Item:new(o)
  setmetatable(o, self)
  self.__index = self

  o.back = o.back or "blue"
  o.isTurned = o.isTurned or false
  o.isJoker = o.isJoker or false
  if not o.isJoker then
    assert(utils.has(VALUES, o.value),
           "card created with unsupported value: " .. o.value)
    assert(utils.has(SUITS, o.suit),
           "card created with unsupported suit: " .. o.suit)

  end

  o.asset = assets.gfx[electAsset(o)]
  o.width = W
  o.height = H

  o.id = "card_" .. o:genId()

  return o
end

function Card:draw()
  G.setColor(1, 1, 1, 1)
  -- ( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
  G.draw(self.asset, self.x, self.y, D2R * self.rotation, S, S, w2, h2)
end

function Card:turn()
  self.isTurned = not self.isTurned
  self.asset = assets.gfx[electAsset(self)]
end

function Card:rotate90()
  if self.rotation == 90 then
    self.rotation = 0
  else
    self.rotation = 90
  end
end

return Card
