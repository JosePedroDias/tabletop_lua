local consts = require "src.core.consts"
local lobby = require "src.stages.lobby"
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
end

function M:texstLobby()
  lobby.load()

  drawAndSaveImage(function()
    lobby.draw()
  end, "stages_lobby.png")
end

return M
