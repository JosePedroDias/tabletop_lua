local lt = require "src.ext.lunatest"
local gravatar = require "src.ext.gravatar"

function test_gravatar()
  lt.assert_equal(
    "https://www.gravatar.com/avatar/ca6f59bfc40276294269bba0aed97029?s=64",
    gravatar("jose.pedro.dias@gmail.com", 64))

  lt.assert_equal(
    "https://www.gravatar.com/avatar/8ed1abac29dc8c79a235ef26563fa17d?s=64",
    gravatar("jose.pedro.dias2@gmail.com", 64))
  -- blue default

  lt.assert_equal(
    "https://www.gravatar.com/avatar/8ed1abac29dc8c79a235ef26563fa17d?s=64&d=monsterid",
    gravatar("jose.pedro.dias2@gmail.com", 64, "monsterid"))
  -- monsterid

  lt.assert_equal(
    "https://www.gravatar.com/avatar/ca6f59bfc40276294269bba0aed97029?s=64&d=monsterid&f=y",
    gravatar("jose.pedro.dias@gmail.com", 64, "monsterid", true))
  -- force monsterid for an email with actual avatar
end
