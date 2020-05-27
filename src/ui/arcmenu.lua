--[[ this is an optional overlay to be used on mobile devices ]] --
local utils = require "src.core.utils"
local shape = require "src.core.shape"

local M = {}

local G = love.graphics

local buttons = {}
local labels = {}
local callbacks = {}

local r1 = 60
local r2 = 160

local function fireButton(i)
  local cb = callbacks[i]
  if cb ~= nil then cb() end
end

local function pressingButton(x, y)
end

local function computeGeometry(x, y, numOpts, dismissableFirst)
  local pi2 = math.pi * 2
  if dismissableFirst then numOpts = numOpts - 1 end
  local arcAngle = pi2 / numOpts;
  local stepsPerArc = math.ceil(32 / numOpts);
  -- const midRadius = innerRadius + (radius - innerRadius) / 2;
  buttons = {}
  local center = {x, y}
  local stepsD = stepsPerArc * numOpts;

  print("d" .. tostring(dismissableFirst) .. " no" .. tostring(numOpts))

  -- inner circle
  if dismissableFirst then
    local poly = {}
    for i = 1, stepsD + 1 do
      local p = utils.polarMove(center, r2, (i / stepsD) * pi2)
      table.insert(poly, p[1])
      table.insert(poly, p[2])
    end
    table.insert(buttons, poly)
  end

  -- arc segments
  for i = 0, numOpts - 1 do
    local angle0 = arcAngle * i
    local poly = {}
    for j = 0, stepsPerArc do
      -- for j = stepsPerArc, 0, -1 do
      local p = utils.polarMove(center, r1, angle0 + (j / stepsD) * pi2)
      table.insert(poly, p[1])
      table.insert(poly, p[2])
    end
    for j = stepsPerArc, 0, -1 do
      local p = utils.polarMove(center, r2, angle0 + (j / stepsD) * pi2)
      table.insert(poly, p[1])
      table.insert(poly, p[2])
    end
    table.insert(buttons, poly)
  end
end

M.setup = function(dismissableFirst, cbs, lbls, x, y)
  callbacks = cbs
  labels = lbls
  computeGeometry(x, y, #lbls, dismissableFirst)
end

M.update = function(dt)
end

M.draw = function()
  local colors = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}
  -- G.setColor(1, 1, 1, 0.75)
  for i, p in ipairs(buttons) do
    if i == 1 then
      pcall(G.setColor, colors[i])
      G.polygon("fill", p)
    end

  end
end

M.onPointer = function(x, y)
  local i = pressingButton(x, y)
  if not i then return end

  fireButton(i)
end

M.onPointerUp = function(x, y)
end

return M
