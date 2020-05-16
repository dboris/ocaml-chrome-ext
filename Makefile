BUILD=_build/default

.PHONY: all release build dist debug clean

all: release dist

release:
	dune build --profile release @default

build:
	dune build @default

dist:
	mkdir -p dist
	cp -f $(BUILD)/test/*.{js,json,html} dist/ 2>/dev/null || true

debug: build dist
	cp -f $(BUILD)/test/*.ml dist/ 2>/dev/null || true

clean:
	dune clean
	rm -Rf dist
