--[[ scales an image to the given dimensions ]] --
-- TODO make it work for AR != 1
local G = love.graphics
local function cropper(img, width, height)
  local canvas = G.newCanvas(width, height)
  local background = {0, 0, 0, 1}

  G.setCanvas(canvas)

  pcall(G.clear, background)

  G.setColor(1, 1, 1, 1)

  local w = img:getWidth()
  local h = img:getHeight()
  local s = math.min(width / w, height / h)
  local x = 0
  local y = 0
  if w > h then
    y = ((w / h) - 1) * height / 2
  elseif h > h then
    x = ((h / w) - 1) * height / 2
  end

  -- ( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
  G.draw(img, x, y, 0, s, s)
  print(x, y, s)

  G.setCanvas()

  return canvas
end

return cropper
