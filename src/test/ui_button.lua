local Button = require "src.ui.button"
local G = love.graphics

local M = {}

local canvas
local W = 200
local H = 40

local function drawAndSaveImage(fnToDraw, name)
  G.setCanvas(canvas)
  fnToDraw()
  G.setCanvas()
  canvas:newImageData():encode("png", name)
end

function M:setup()
  canvas = G.newCanvas(W, H)
end

function M:test()
  local i = Button:new({
    x = 0,
    y = 0,
    width = 200,
    height = 40,
    label = "click me"
  })

  drawAndSaveImage(function()
    i:draw()
  end, "ui_button.png")
end

return M
