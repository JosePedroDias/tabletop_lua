local lt = require "src.ext.lunatest"
local utils = require "src.ext.utils"

function test_trim()
  lt.assert_equal(" cenas   ", "cenas", "trim failed")
end

