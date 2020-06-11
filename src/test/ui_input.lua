local Input = require "src.ui.input"
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

function M:testUnfocused()
  local i = Input:new({
    x = 0,
    y = 0,
    width = 200,
    height = 40,
    value = "starting"
  })

  drawAndSaveImage(function()
    i:draw()
  end, "ui_input_unfocused.png")
end

function M:testFocused()
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
  end, "ui_input_focused.png")
end

return M
