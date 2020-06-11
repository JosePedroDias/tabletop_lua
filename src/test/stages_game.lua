local assets = require "src.core.assets"
local consts = require "src.core.consts"
local game = require "src.stages.game"

local G = love.graphics

local canvas
local W = consts.W
local H = consts.H

local function drawAndSaveImage(fnToDraw, name)
  G.setCanvas(canvas)
  fnToDraw()
  G.setCanvas()
  canvas:newImageData():encode("png", name)
end

local function lsetup()
  canvas = G.newCanvas(W, H)
end

function test_game()
  lsetup()

  assets.load()

  game.load()

  consts.roster = {"a", "b", "c"}

  local gamesModule = require "src.games.go-fish"
  gamesModule.setup()

  drawAndSaveImage(function()
    game.draw()
  end, "stages_game.png")
end
