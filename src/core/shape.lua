--[[ https://love2d.org/wiki/PointWithinShape ]] --
local M = {}

local function boundingBox(box, tx, ty)
  return (box[2].x >= tx and box[2].y >= ty) and
           (box[1].x <= tx and box[1].y <= ty) or
           (box[1].x >= tx and box[2].y >= ty) and
           (box[2].x <= tx and box[1].y <= ty)
end

local function colinear(line, x, y, e)
  e = e or 0.1
  local m = (line[2].y - line[1].y) / (line[2].x - line[1].x)
  local function f(x)
    return line[1].y + m * (x - line[1].x)
  end
  return math.abs(y - f(x)) <= e
end

local function pointWithinLine(line, tx, ty, e)
  e = e or 0.66
  if boundingBox(line, tx, ty) then
    return colinear(line, tx, ty, e)
  else
    return false
  end
end

local function crossingsMultiplyTest(pgon, tx, ty)
  local i, yflag0, yflag1, inside_flag
  local vtx0, vtx1

  local numverts = #pgon

  vtx0 = pgon[numverts]
  vtx1 = pgon[1]

  yflag0 = (vtx0.y >= ty)
  inside_flag = false

  for i = 2, numverts + 1 do
    yflag1 = (vtx1.y >= ty)

    if (yflag0 ~= yflag1) then

      if (((vtx1.y - ty) * (vtx0.x - vtx1.x) >= (vtx1.x - tx) *
        (vtx0.y - vtx1.y)) == yflag1) then inside_flag = not inside_flag end
    end

    yflag0 = yflag1
    vtx0 = vtx1
    vtx1 = pgon[i]
  end

  return inside_flag
end

local function pointWithinShape(shape, tx, ty)
  if #shape == 0 then
    return false
  elseif #shape == 1 then
    return shape[1].x == tx and shape[1].y == ty
  elseif #shape == 2 then
    return pointWithinLine(shape, tx, ty)
  else
    return crossingsMultiplyTest(shape, tx, ty)
  end
end

M.pointWithinShape = pointWithinShape

return M
