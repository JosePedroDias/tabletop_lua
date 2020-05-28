-- [[ basic asset loading ]] --
local M = {fonts = {}, sfx = {}, music = {}, gfx = {}}

local fontDir = "assets/font/"
local gfxDir = "assets/gfx"
local sfxDir = "assets/sfx"

M.load = function()
  -- local f = love.filesystem.getDirectoryItems("assets")
  -- for i, n in ipairs(f) do print(n) end

  local mainF = love.graphics.newFont(fontDir .. "/NotoSans-Regular.ttf", 20)
  love.graphics.setFont(mainF)
  M.fonts["main"] = mainF

  M.gfx["cards_joker"] = love.graphics.newImage(gfxDir .. "/cards/joker.png");

  M.sfx["cards_place1"] = love.audio.newSource(sfxDir .. "/cards/place1.ogg",
                                               "static")

  -- local swingjedingMusic = love.audio.newSource("sounds/swingjeding.ogg", "stream")
  -- M.music["swingjeding"] = swingjedingMusic
end

return M
