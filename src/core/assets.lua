-- [[ basic asset loading ]] --
local M = {fonts = {}, sfx = {}, music = {}, gfx = {}}

M.load = function()
  local mainF = love.graphics.newFont("assets/font/NotoSans-Regular.ttf", 20)
  love.graphics.setFont(mainF)
  M.fonts["main"] = mainF

  local cardJokerGfx = love.graphics.newImage("assets/gfx/cards/joker.png");
  M.gfx["cardJoker"] = cardJokerGfx

  local cardsPlace1Sfx = love.audio.newSource("assets/sfx/cards/place1.ogg",
                                              "static")
  M.sfx["cardsPlace1"] = cardsPlace1Sfx

  -- local swingjedingMusic = love.audio.newSource("sounds/swingjeding.ogg", "stream")
  -- M.music["swingjeding"] = swingjedingMusic
end

return M
