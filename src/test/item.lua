local lt = require "src.ext.lunatest"

local Item = require "src.items.item"

function test_isHitByItem()
  local a = Item:new({x = 0, y = 0, width = 10, height = 10})
  local b = Item:new({x = 0, y = 20, width = 10, height = 10})

  lt.assert_equal(a:isHitByItem(b), false, "a and b should not hit")
  -- lt.assert_equal(2 + 2, 4, "boom")
end

