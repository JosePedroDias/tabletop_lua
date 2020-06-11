local fetchRemoteImage = require "src.ui.internet_image"
local G = love.graphics

local canvas
local W = 64
local H = 64

local function drawAndSaveImage(fnToDraw, name)
  G.setCanvas(canvas)
  fnToDraw()
  G.setCanvas()
  canvas:newImageData():encode("png", name)
end

local function lsetup()
  canvas = G.newCanvas(W, H)
end

function test_internet_image()
  lsetup()

  local i = fetchRemoteImage(
              "https://www.gravatar.com/avatar/ca6f59bfc40276294269bba0aed97029?s=64")

  drawAndSaveImage(function()
    G.draw(i, 0, 0)
  end, "ui_internet_image.png")
end
