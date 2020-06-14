-- [[ game screen handling ]] --
local noobhub = require("src.ext.noobhub")

local consts = require "src.core.consts"
local settings = require "src.core.settings"
local utils = require "src.core.utils"

local Console = require "src.ui.console"
local Board = require "src.ui.board"

local gravatar = require "src.ext.gravatar"
local fetchRemoteImage = require "src.ui.internet_image"

consts.roster = {} -- TODO: ugly
consts.userData = {}
consts.avatars = {}
consts.ignoreFrom = {}

local M = {}

local hub

local ui = {}

function SendEvent(action, data)
  hub:publish({
    message = {from = settings.username, action = action, data = data}
  })
end

local function parseHubEvent(ev)
  -- ignore self messages (for vanilla noobhub servers)
  if ev.from == settings.username or consts.ignoreFrom[ev.from] then return end

  if ev.action == "say" then
    ui.console:addLine(os.date("%H:%M ") .. ev.from .. ": " .. ev.data)
  elseif ev.action == "status" then
    if ev.data.online then
      if ev.data.version ~= consts.version then
        consts.ignoreFrom[ev.from] = true
        print(ev.from .. " with version " .. (ev.data.version or "") .. " therefore ignored")
        ui.console:addLine(os.date("%H:%M ") .. ev.from .. " with version " .. (ev.data.version or "???") .. " therefore ignored")
        return
      end

      if not utils.has(consts.roster, ev.from) then
        ui.console:addLine(os.date("%H:%M ") .. ev.from .. " got in")
        table.insert(consts.roster, ev.from)

        -- print(settings.username .. " got info about " .. ev.from .. " - " .. ev.data.email .. ", " .. ev.data.color)
        consts.userData[ev.from] = {
          email = ev.data.email,
          color = ev.data.color,
          rotation = 0
        }

        M.obtainAvatar(ev.from, ev.data.email)
        -- ui.board:updateAvatars()
        SendEvent("status", {
          online = true,
          email = settings.email,
          color = settings.color,
          version = consts.version
        })

        consts.board:redrawOverlays()
      end
    else
      ui.console:addLine(os.date("%H:%M ") .. ev.from .. " left")
      table.remove(consts.roster, utils.indexOf(consts.roster))
      consts.userData[ev.from] = nil
      consts.avatars[ev.from] = nil
      ui.board:redrawOverlays()
    end
  else
    ui.board:onEvent(ev)
  end
end

M.obtainAvatar = function(username, email)
  if consts.avatars[username] then return end
  local url = gravatar(email, 96, "monsterid")
  local avatar = fetchRemoteImage(url)
  consts.avatars[username] = avatar
end

M.load = function()
  consts.userData[settings.username] = {
    color = settings.color,
    email = settings.email,
    rotation = 0
  }

  M.obtainAvatar(settings.username, settings.email)

  local l = 500
  love.window.setTitle("tabletop - " .. settings.username)

  -- TODO for dev purposes
  if settings.username == "p1" then
    love.window.setPosition(l, l)
  elseif settings.username == "p2" then
    love.window.setPosition(l, 0)
  elseif settings.username == "p3" then
    love.window.setPosition(0, l / 2)
  else
    love.window.setPosition(l * 2, l / 2)
  end

  hub = noobhub.new({server = settings.server, port = settings.port});
  hub:subscribe({channel = settings.channel, callback = parseHubEvent}) -- TODO: add server and channel input in lobby

  SendEvent("status", {
    online = true,
    email = settings.email,
    color = settings.color,
    version = consts.version
  })

  ui.console = Console:new({
    x = consts.W - 400,
    y = 0,
    width = 400,
    height = consts.H,
    maxLines = 20,
    dismissed = true
  })

  ui.board = Board:new({width = consts.W, height = consts.H})
  consts.board = ui.board -- TODO: ugly
end

M.unload = function()
end

M.update = function(dt)
  if hub then hub:enterFrame() end
end

M.draw = function()
  ui.board:draw()
  ui.console:draw()
end

M.onKey = function(key)
  -- print(key)
  if key == "escape" then
    SendEvent("status", {online = false})
    love.event.quit()
  elseif key == "f1" then
    -- gets stored in the same folder as settings. ex: ~/Library/Application Support/LOVE/tabletop
    local file = "shot_" .. os.date("%Y-%m-%d_%H-%M-%S") .. ".png"
    print("saving screenshot to " .. file)
    love.graphics.captureScreenshot(file)
  end
  ui.console:onKey(key)
end

M.onTextInput = function(text)
  ui.console:onTextInput(text)
end

M.onPointer = function(x, y)
  if ui.console:onPointer(x, y) then return end
  ui.board:onPointer(x, y)
end

M.onPointerMove = function(x, y)
  ui.board:onPointerMove(x, y)
end

M.onPointerUp = function(x, y)
  ui.board:onPointerUp(x, y)
end

return M
