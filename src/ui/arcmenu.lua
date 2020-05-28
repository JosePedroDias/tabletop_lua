--[[ this is an optional overlay to be used on mobile devices ]] --
local consts = require "src.core.consts"
local shape = require "src.core.shape"
local utils = require "src.core.utils"

local M = {}

local G = love.graphics

local buttons = {} -- poly or array of simple convex polys
local buttons2 = {} -- any poly
local centers = {}
local labels = {}
local callbacks = {}
local dismissableFirst

local r1 = 60
local r2 = 160
local rt = (r2 - r1) / 2 + r1

local function fireButton(i)
  local cb = callbacks[i]
  if cb ~= nil then cb() end
end

local function pressingButton(x, y)
end

local function computeGeometry(x, y, numOpts)
  local pi2 = math.pi * 2
  if dismissableFirst then numOpts = numOpts - 1 end
  local arcAngle = pi2 / numOpts;
  local stepsPerArc = math.ceil(32 / numOpts);
  buttons = {}
  buttons2 = {}
  centers = {}
  local center = {x, y}
  local stepsD = stepsPerArc * numOpts;

  -- inner circle
  if dismissableFirst then
    local poly = {}
    for i = 1, stepsD + 1 do
      local p = utils.polarMove(center, r1, (i / stepsD) * pi2)
      table.insert(poly, p[1])
      table.insert(poly, p[2])
    end
    table.insert(buttons, poly)
    table.insert(buttons2, poly)
    table.insert(centers, center)
  end

  -- arc segments (must be triangles since love only draws convex polys)
  for i = 0, numOpts - 1 do
    local angle0 = arcAngle * i
    local poly = {}
    local pi_, po_, tri

    for j = 0, stepsPerArc do
      local angle = (j / stepsD) * pi2 + angle0
      local pi = utils.polarMove(center, r1, angle)
      local po = utils.polarMove(center, r2, angle)

      if j > 0 then
        tri = {}
        table.insert(tri, pi_[1])
        table.insert(tri, pi_[2])
        table.insert(tri, po_[1])
        table.insert(tri, po_[2])
        table.insert(tri, pi[1])
        table.insert(tri, pi[2])
        table.insert(poly, tri)

        tri = {}
        table.insert(tri, pi[1])
        table.insert(tri, pi[2])
        table.insert(tri, po[1])
        table.insert(tri, po[2])
        table.insert(tri, po_[1])
        table.insert(tri, po_[2])
        table.insert(poly, tri)
      end

      pi_ = pi
      po_ = po
    end
    table.insert(buttons, poly)
  end

  -- outer shape
  for i = 0, numOpts - 1 do
    local angle0 = arcAngle * i
    local poly = {}
    for j = 0, stepsPerArc do
      local p = utils.polarMove(center, r1, angle0 + (j / stepsD) * pi2)
      table.insert(poly, p[1])
      table.insert(poly, p[2])
    end
    for j = stepsPerArc, 0, -1 do
      local p = utils.polarMove(center, r2, angle0 + (j / stepsD) * pi2)
      table.insert(poly, p[1])
      table.insert(poly, p[2])
    end
    table.insert(buttons2, poly)

    -- center
    local c = utils.polarMove(center, rt, arcAngle * (i + 0.5))
    table.insert(centers, c)
  end
end

M.setup = function(dismissableFirst_, cbs, lbls, x, y)
  dismissableFirst = dismissableFirst_
  callbacks = cbs
  labels = lbls
  computeGeometry(x, y, #lbls)
end

M.update = function(dt)
end

M.draw = function()
  for i, p in ipairs(buttons) do
    pcall(G.setColor, consts.colors[i + 1])

    if type(p[1]) == "table" then
      for _, t in ipairs(p) do G.polygon("fill", t) end
    else
      G.polygon("fill", p)
    end
  end

  local f = G.getFont()
  local dy = math.floor(f:getHeight() / 2)
  G.setColor(consts.colors[16])
  for i, p in ipairs(buttons2) do
    G.polygon("line", p)

    local dx = math.floor(f:getWidth(labels[i]) / 2)
    G.print(labels[i], centers[i][1] - dx, centers[i][2] - dy)
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
