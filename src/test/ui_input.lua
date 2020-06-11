local lt = require "src.ext.lunatest"
local Input = require "src.ui.input"
local G = love.graphics

local canvas
local W = 200
local H = 40

local function drawAndSaveImage(fnToDraw, name)
  G.setCanvas(canvas)
  fnToDraw()
  G.setCanvas()
  canvas:newImageData():encode("png", name)
end

local function lsetup()
  canvas = G.newCanvas(W, H)
end

function test_input()
  lsetup()
  local i = Input:new({
    x = 0,
    y = 0,
    width = 200,
    height = 40,
    focused = true,
    value = "starting"
  })

  drawAndSaveImage(function()
    i:draw()
  end, "ui_input.png")
end
