local lt = require "src.ext.lunatest"
local utils = require "src.core.utils"

function test_trim()
  lt.assert_equal(utils.trim(" cenas   "), "cenas", "trim failed")
end
