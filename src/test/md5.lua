local lt = require "src.ext.lunatest"
local md5 = require "src.ext.md5"

function test_md5()
  local email = "myemailaddress@example.com"
  local res = md5(email)
  lt.assert_equal(res, "f9879d71855b5ff21e4963273a886bfcx", "boom")
end

