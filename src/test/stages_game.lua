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
  settings.username = "S"
end

function M:testGame()
  assets.load()

  game.load()

  consts.roster = {"N", "W", "E"}
  consts.userData["S"] = {color = 1, email = "p1@a.com", rotation = 0}
  consts.userData["N"] = {color = 2, email = "p2@a.com", rotation = 0}
  consts.userData["W"] = {color = 4, email = "p3@a.com", rotation = 0}
  consts.userData["E"] = {color = 5, email = "p4@a.com", rotation = 0}

  for username, ud in pairs(consts.userData) do
    game.obtainAvatar(username, ud.email)
  end

  local gamesModule = require "src.games.go-fish"
  gamesModule.setup()

  drawAndSaveImage(function()
    game.draw()
  end, "stages_game.png")
end

return M
