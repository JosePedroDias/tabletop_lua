-- [[ screen to capture user name ]] --
local consts = require "src.core.consts"
local settings = require "src.core.settings"
local stages = require "src.core.stages"

local Button = require "src.ui.button"
local ColorPicker = require "src.ui.color_picker"
local Input = require "src.ui.input"

local gravatar = require "src.ext.gravatar"
local fetchRemoteImage = require "src.ui.internet_image"

-- local Whiteboard = require "src.ui.whiteboard"

local G = love.graphics

local M = {}

local ui = {}

local state = {
  t=0
}

local FETCH_DEBOUNCE_SECS = 0.5

M.next = function()
  settings.username = ui.iusername.value
  settings.email = ui.iemail.value
  settings.color = ui.colorPicker.value
  settings.save()
  stages.toStage("game")
end

M.updateAvatar = function(email)
  local url = gravatar(email, 96, "monsterid")
  M.avatar = fetchRemoteImage(url)
  M.draw()
end

M.load = function()
  ui.iusername = Input:new({
    x = (consts.W - 300) / 2,
    y = (consts.H - 140) / 2,
    width = 300,
    height = 40,
    focused = true,
    value = settings.username,
    onSubmit = M.next
  })

  ui.iemail = Input:new({
    x = (consts.W - 300) / 2,
    y = (consts.H - 40) / 2,
    width = 300,
    height = 40,
    value = settings.email,
    onChange = function()
      state.nextUpdateAvatarT = state.t + FETCH_DEBOUNCE_SECS
    end,
    onSubmit = M.next
  })

  ui.bContinue = Button:new({
    x = (consts.W - 300) / 2,
    y = (consts.H + 140) / 2,
    width = 300,
    height = 40,
    color = {1, 1, 1, 1},
    background = {0.3, 0.6, 0.3, 1},
    label = "continue",
    onClick = M.next
  })

  ui.colorPicker = ColorPicker:new({
    x = (consts.W - 300) / 2,
    y = (consts.H + 240) / 2,
    cols = 8,
    rows = 2,
    cellwidth = 34,
    cellheight = 34,
    colors = consts.colors,
    value = settings.color
  })

  M.updateAvatar(settings.email)

  -- ui.whiteboard = Whiteboard:new({width = 600, height = 400})
end

M.update = function(dt)
  state.t = state.t + dt
  if state.nextUpdateAvatarT and (state.t > state.nextUpdateAvatarT) then
    state.nextUpdateAvatarT = nil
    M.updateAvatar(ui.iemail.value)
  end
end

M.draw = function()
  if M.avatar then
    love.graphics.draw(M.avatar, (consts.W - 96) / 2, (consts.H - 400) / 2)
  end

  ui.iusername:draw()
  ui.iemail:draw()
  ui.bContinue:draw()
  ui.colorPicker:draw()

  G.setColor(0.33, 0.33, 0.33, 1)
  G.print("tabletop   " .. consts.version .. "   " .. consts.gitHash .. "   " .. consts.gitDate, 15, consts.H - 30)
  G.setColor(1, 1, 1, 1)

  -- ui.whiteboard:draw()
end

M.onKey = function(key)
  if key == "escape" then love.event.quit() end
  if ui.iusername:onKey(key) then return end
  if ui.iemail:onKey(key) then return end
end

M.onTextInput = function(text)
  if ui.iusername:onTextInput(text) then return end
  if ui.iemail:onTextInput(text) then return end
end

M.onPointer = function(x, y)
  ui.iusername:onPointer(x, y)
  ui.iemail:onPointer(x, y)
  ui.bContinue:onPointer(x, y)
  ui.colorPicker:onPointer(x, y)

  -- ui.whiteboard:onPointer(x, y)
end

return M
