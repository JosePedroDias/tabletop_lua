-- [[ main file! ]] --
local assets = require "src.core.assets"
local consts = require "src.core.consts"
local screen = require "src.core.screen"
local stages = require "src.core.stages"
local settings = require "src.core.settings"

local menu = require "src.stages.menu"

require("src.ext.json")
local noobhub = require("src.ext.noobhub")
local hub

function love.load()
  -- settings.load()

  --[[ hub = noobhub.new({server = "acor.sl.pt", port = 1337});
  hub:subscribe({
    channel = "ch1",
    callback = function(message)
      print("message received  = " .. json.encode(message));

      -- hub:publish({message = {from = "love2d", data = "amazing stuffz"}})
    end
  }) ]]

  love.keyboard.setKeyRepeat(true)

  -- image resolution fix
  local sW, sH = screen.getCurrentResolution()
  -- screen.setSize(sW, sH, consts.W, consts.H, true)
  screen.setSize(800, 600, consts.W, consts.H, false)

  -- load resources
  assets.load()

  stages.setStage("menu", menu)

  stages.toStage("menu")

  settings.load()
end

function love.focus(f)
  stages.currentStage.focus(f)
end

function love.update(dt)
  if hub then hub:enterFrame() end
  stages.currentStage.update(dt)
end

function love.draw()
  screen.startDraw()
  stages.currentStage.draw()
  screen.endDraw()
end

function love.keypressed(key, scancode, isRepeat)
  stages.currentStage.onKey(key, scancode, isRepeat)
end

function love.keyreleased(key, scancode)
  stages.currentStage.onKeyUp(key, scancode)
end

function love.mousepressed(_x, _y)
  local x, y = screen.coords(_x, _y)
  stages.currentStage.onPointer(x, y)
end

function love.mousemoved(_x, _y)
  local x, y = screen.coords(_x, _y)
  stages.currentStage.onPointerMove(x, y)
end

function love.mousereleased(_x, _y)
  local x, y = screen.coords(_x, _y)
  stages.currentStage.onPointerUp(x, y)
end

function love.textinput(text)
  stages.currentStage.onTextInput(text)
end
