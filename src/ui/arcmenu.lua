--[[ arc menu ui component - allows picking an option out of a set of choices ]] --
local consts = require "src.core.consts"
local shape = require "src.core.shape"
local utils = require "src.core.utils"

local G = love.graphics

ArcMenu = {r1 = 60, r2 = 160}

function ArcMenu:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o:computeGeometry()
  o.canvas = G.newCanvas(o.r2 * 2, o.r2 * 2)
  o:redraw()
  return o
end

function ArcMenu:draw()
  G.draw(self.canvas, self.x - self.r2, self.y - self.r2)
end

function ArcMenu:onPointer(x, y)
  local hit = self:isHittingButton(x - self.x + self.r2, y - self.y + self.r2)
  if not hit then return end
  local cb = self.callbacks[hit] or self.callback
  if cb then cb(hit) end
end

function ArcMenu:redraw()
  G.setCanvas(self.canvas)

  for i, p in ipairs(self.buttons) do
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
  for i, p in ipairs(self.buttons2) do
    G.polygon("line", p)
    if self.labels[i] ~= nil then
      local dx = math.floor(f:getWidth(self.labels[i]) / 2)
      G.print(self.labels[i], self.centers[i][1] - dx, self.centers[i][2] - dy)
    end
  end
  G.setCanvas()
end

function ArcMenu:computeGeometry()
  self.callbacks = {}
  self.buttons = {} -- can be non-convex-simple (for strokes)
  self.buttons2 = {} -- array of triangles or simple convex
  self.polys = {} -- for collision detection
  self.centers = {}

  local pi2 = math.pi * 2
  local rt = (self.r2 - self.r1) / 2 + self.r1
  local numOpts = #self.labels
  if self.dismissableFirst then numOpts = numOpts - 1 end
  local arcAngle = pi2 / numOpts;
  local stepsPerArc = math.ceil(32 / numOpts);
  local center = {self.r2, self.r2}
  local stepsD = stepsPerArc * numOpts;

  -- inner circle
  if self.dismissableFirst then
    local poly = {}
    for i = 1, stepsD + 1 do
      local p = utils.polarMove(center, self.r1, (i / stepsD) * pi2)
      table.insert(poly, p[1])
      table.insert(poly, p[2])
    end
    table.insert(self.buttons, poly)
    table.insert(self.buttons2, poly)
    table.insert(self.centers, center)
  end

  -- arc segments (must be triangles since love only draws convex polys)
  for i = 0, numOpts - 1 do
    local angle0 = arcAngle * i
    local poly = {}
    local pi_, po_, tri

    for j = 0, stepsPerArc do
      local angle = (j / stepsD) * pi2 + angle0
      local pi = utils.polarMove(center, self.r1, angle)
      local po = utils.polarMove(center, self.r2, angle)

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
    table.insert(self.buttons, poly)
  end

  -- outer shape
  for i = 0, numOpts - 1 do
    local angle0 = arcAngle * i
    local poly = {}
    for j = 0, stepsPerArc do
      local p = utils.polarMove(center, self.r1, angle0 + (j / stepsD) * pi2)
      table.insert(poly, p[1])
      table.insert(poly, p[2])
    end
    for j = stepsPerArc, 0, -1 do
      local p = utils.polarMove(center, self.r2, angle0 + (j / stepsD) * pi2)
      table.insert(poly, p[1])
      table.insert(poly, p[2])
    end
    table.insert(self.buttons2, poly)

    -- center
    local c = utils.polarMove(center, rt, arcAngle * (i + 0.5))
    table.insert(self.centers, c)
  end

  for _, p in ipairs(self.buttons2) do
    local p2 = {}
    for j = 1, #p - 1, 2 do table.insert(p2, {x = p[j], y = p[j + 1]}) end
    table.insert(self.polys, p2)
  end
end

function ArcMenu:isHittingButton(x, y)
  if not self.polys then return end
  for i, p in ipairs(self.polys) do
    local res = shape.pointWithinShape(p, x, y)
    if res then return i end
  end
end

function ArcMenu:__gc()
  print("about to destroy ")
end
