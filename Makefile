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
gamenamenoext = tabletop
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
	@rm -rf ext/luaunit.lua build/test
	@find ./build -type f -exec sed -iE 's/src.//g' {} \;
	@rm -rf ./build/*.luaE
	@cd build && zip -9 -q -r ../dist/$(gamename) . && cd ..
	@cd assets && zip -9 -q -r ../dist/$(gamename) . && cd ..
	@rm -rf build

# https://love2d.org/wiki/Game_Distribution
# https://github.com/MisterDA/love-release
binaries:	dist
	@rm -rf game-binaries
	@mkdir -p game-binaries/win32 game-binaries/win64 game-binaries/mac64 game-binaries/any
# windows
	@cp -R binaries/win32 game-binaries
	@cp -R binaries/win64 game-binaries
	@cat binaries/win32/love.exe dist/$(gamename) > binaries/win32/$(gamenamenoext).exe
	@cat binaries/win64/love.exe dist/$(gamename) > binaries/win64/$(gamenamenoext).exe
# mac
	@cp -R binaries/mac64/love.app game-binaries/mac64/${gamenamenoext}.app
	@cp dist/$(gamename) game-binaries/mac64/${gamenamenoext}.app/Contents/Resources
# mac - replaces CFBundleIdentifier
	@sed -i -e 's/<string>org.love2d.love<\/string>/<string>com.josepedrodias.tabletop<\/string>/g' game-binaries/mac64/${gamenamenoext}.app/Contents/Info.plist
# mac - replaces CFBundleName
	@sed -i -e 's/<string>LÖVE<\/string>/<string>tabletop<\/string>/g' game-binaries/mac64/${gamenamenoext}.app/Contents/Info.plist
# mac - removes UTExportedTypeDeclarations
	@sed -i.bak -e '104,132d' game-binaries/mac64/${gamenamenoext}.app/Contents/Info.plist
# any
	@cp dist/$(gamename) game-binaries/any

run-dist:	dist
	@$(love) dist/$(gamename)

test:
	@$(love) $(srcd) test
