.PHONY: run-src symbolics clean dist run-dist test

os := $(shell uname)

ifeq ($(os),Darwin)
	love = /Applications/love.app/Contents/MacOS/love
else ifeq ($(os),Linux)
	love = love
else
	love = "C:\\Program Files\\LOVE\\lovec"
endif

args=`arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`
rootd = `pwd`
srcd = "$(rootd)/src"
gamename = tabletop.love

run-src:
	@$(love) $(srcd) $(call args)

symbolics:
	@mkdir src/assets
	@ln -s $(rootd)/assets/font $(rootd)/assets/gfx $(rootd)/assets/sfx src/assets

clean:
	@rm -rf build dist src/assets

dist:
	@rm -rf dist build
	@mkdir dist
	@mkdir build
	@cp -R src/* build
	@find ./build -type f -exec sed -iE 's/src.//g' {} \;
	@rm -rf ./build/*.luaE
	@cd build && zip -9 -q -r ../dist/$(gamename) . && cd ..
	@cd assets && zip -9 -q -r ../dist/$(gamename) . && cd ..
	@rm -rf build

run-dist: dist
	@$(love) dist/$(gamename)

test:
	@$(love) $(srcd) test
