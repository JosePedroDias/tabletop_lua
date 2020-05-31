--[[ manages the ui board ]] --
local assets = require "src.core.assets"
local utils = require "src.core.utils"

local G = love.graphics

Card = {x = 0, y = 0, rotation = 0}

-- suit - CHSD Clubs Hearts Spades Diamonds
-- value - 2 3 4 5 6 7 8 9 10 J Q K A
-- back - blue green red
-- isJoker

local D2R = math.pi / 180

local SUITS = {"c", "h", "s", "d"}
local VALUES = {
  "2", "3", "4", "5", "6", "7", "8", "9", "10", "j", "q", "k", "a"
}

local function electAsset(o)
  if o.isTurned then
    return "cards_back_" .. o.deckColor
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

Card = {x = 0, y = 0, rotation = 0}

function Card:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self

  o.deckColor = o.deckColor or "blue"
  o.isTurned = o.isTurned or false
  o.isJoker = o.isJoker or false
  if not o.isJoker then
    if not utils.has(VALUES, o.value) then
      return print("card created with unsupported value: " .. o.value)
    elseif not utils.has(SUITS, o.suit) then
      return print("card created with unsupported suit: " .. o.suit)
    end
  end

  o.asset = assets.gfx[electAsset(o)]
  o.width = 140
  o.height = 190

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

