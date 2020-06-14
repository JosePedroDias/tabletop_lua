-- https://luacheck.readthedocs.io/en/stable/config.html
-- https://luacheck.readthedocs.io/en/stable/warnings.html

-- luarocks --lua-dir=/usr/local/opt/lua@5.1 install luacheck
-- eval (luarocks --lua-dir=/usr/local/opt/lua@5.1 path --bin)

std = "luajit"
globals = {"love", "json"}
ignore = {"614"}
