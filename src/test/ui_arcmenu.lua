local lt = require "src.ext.lunatest"
local ArcMenu = require "src.ui.arcmenu"
local G = love.graphics

local canvas
local W = 320
local H = 320

local function drawAndSaveImage(fnToDraw, name)
  G.setCanvas(canvas)
  fnToDraw()
  G.setCanvas()
  canvas:newImageData():encode("png", name)
end

local function lsetup()
  canvas = G.newCanvas(W, H)
end

function test_arcmenu_3_w_cancel()
  lsetup()
  local i = ArcMenu:new({
    x = 160,
    y = 160,
    dismissableFirst = true,
    labels = {"one", "two", "three"}
  })

  drawAndSaveImage(function()
    i:draw()
  end, "ui_arcmenu_3_w_cancel.png")
end

function test_arcmenu_3_wo_cancel()
  lsetup()
  local i = ArcMenu:new({
    x = 160,
    y = 160,
    dismissableFirst = false,
    labels = {"one", "two", "three"}
  })

  drawAndSaveImage(function()
    i:draw()
  end, "ui_arcmenu_3_wo_cancel.png")
end

function test_arcmenu_12_wo_cancel()
  lsetup()
  local i = ArcMenu:new({
    x = 160,
    y = 160,
    dismissableFirst = false,
    labels = {
      "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
      "ten", "eleven", "twelve"
    }
  })

  drawAndSaveImage(function()
    i:draw()
  end, "ui_arcmenu_12_wo_cancel.png")
end
