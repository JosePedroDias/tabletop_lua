local lt = require "src.ext.lunatest"

function test_addition()
  lt.assert_equal(2 + 2, 4, "boom")
end

