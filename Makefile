BUILD=_build/default/test
DIST_DIR=dist
SHELL=/bin/zsh

all: release dist

dev: buildwatch dist

watch: dist
	fswatch -0 -v $(BUILD)/*.{html,css,js}(N) | xargs -0 -n 1 -I {} cp -f '{}' $(DIST_DIR)

test: dist
	web-ext run --target chromium --source-dir $(DIST_DIR)

release:
	dune build --profile release @default

build:
	dune build @default

buildwatch:
	dune build --watch --profile release @default

dist:
	mkdir -p dist
	cp -f $(BUILD)/*.{js,json,html}(N) $(DIST_DIR)

debug: build dist
	cp -f $(BUILD)/*.ml $(DIST_DIR)

clean:
	dune clean
	rm -Rf dist

.PHONY: all dev watch test release build buildwatch dist debug clean
