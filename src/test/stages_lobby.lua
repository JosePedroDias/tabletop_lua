local consts = require "src.core.consts"
local lobby = require "src.stages.lobby"
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

function xtest_lobby()
  lsetup()

  lobby.load()

  drawAndSaveImage(function()
    lobby.draw()
  end, "stages_lobby.png")
end
