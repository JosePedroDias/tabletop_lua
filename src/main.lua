-- [[ main file! ]] --
local lu = require "src.ext.luaunit"

local assets = require "src.core.assets"
local avatars = require "src.core.avatars"
local consts = require "src.core.consts"
local screen = require "src.core.screen"
local stages = require "src.core.stages"
local settings = require "src.core.settings"

local lobby = require "src.stages.lobby"
local game = require "src.stages.game"

function love.load(arg)
  -- stores command line arguments to consts.arg. TODO
  -- 1=username
  -- 2=host
  consts.arg = arg

  if arg[1] == "test" then
    local suite = {}
    local runner = lu.LuaUnit.new()
    for _, filename in ipairs(love.filesystem.getDirectoryItems("test")) do
      filename = filename:gsub(".lua", "")
      _G["T" .. filename] = require("src.test." .. filename)
      table.insert(suite, "T" .. filename)
    end

    -- local success, result = pcall(runner.runSuite, suite)

    -- runner:setOutputType("tap") -- tap text
    love.event.quit(runner:runSuite("Tcore_settings", -- "Tone"
    "Tcore_utils", "Text_gravatar", "Text_md5", -- "Tstages_game", 
    "Tstages_lobby", "Tui_arcmenu", "Tui_button", "Tui_input",
                                    "Tui_internet_image"))
  end

  settings.load()

  love.keyboard.setKeyRepeat(true)

  -- image resolution fix
  local sW, sH = screen.getCurrentResolution()
  -- screen.setSize(sW, sH, consts.W, consts.H, true)
  -- screen.setSize(1024, 768, consts.W, consts.H, false)
  screen.setSize(600, 600, consts.W, consts.H, false)

  -- load resources
  assets.load()

  stages.setStage("lobby", lobby)
  stages.setStage("game", game)

  if #consts.arg > 0 then
    settings.username = consts.arg[1]
    settings.save()
    stages.toStage("game")
  else
    stages.toStage("lobby")
  end
end

function love.focus(f)
  stages.currentStage.focus(f)
end

function love.update(dt)
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

function love.filedropped(file)
  avatars.listAvatars()
  avatars.onDrop(file)
end

-- custom error handling to notify server I'm leaving
function love.errorhandler(msg)
  print(msg)
  pcall(SendEvent, "status", "out")
  love.event.quit()
end
