local lt = require "src.ext.lunatest"
local gravatar = require "src.ext.gravatar"

function test_gravatar()
  lt.assert_equal(
    "https://www.gravatar.com/avatar/ca6f59bfc40276294269bba0aed97029?s=64",
    gravatar("jose.pedro.dias@gmail.com", 64))
end
