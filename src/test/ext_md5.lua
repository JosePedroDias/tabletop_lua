local lt = require "src.ext.lunatest"
local md5 = require "src.ext.md5"

function test_md5()
  lt.assert_equal("0bc83cb571cd1c50ba6f3e8a78ef1346",
                  md5.sumhexa("myemailaddress@example.com"), "md5.1")
  lt.assert_equal("ca6f59bfc40276294269bba0aed97029",
                  md5.sumhexa("jose.pedro.dias@gmail.com"), "md5.2")
end
