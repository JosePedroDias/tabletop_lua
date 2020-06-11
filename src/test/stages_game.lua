local assets = require "src.core.assets"
local consts = require "src.core.consts"
local settings = require "src.core.settings"
local game = require "src.stages.game"

local G = love.graphics

local M = {}

local canvas
local W = consts.W
local H = consts.H

local function drawAndSaveImage(fnToDraw, name)
  G.setCanvas(canvas)
  fnToDraw()
  G.setCanvas()
  canvas:newImageData():encode("png", name)
end

function M:setUp()
  canvas = G.newCanvas(W, H)
  settings.username = "batman"
end

function M:testGame()
  assets.load()

  game.load()

  consts.roster = {"a", "b", "c"}

  local gamesModule = require "src.games.go-fish"
  gamesModule.setup()

  drawAndSaveImage(function()
    game.draw()
  end, "stages_game.png")
end

return M
