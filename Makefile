build/linal: build linal/*.pony
	ponyc linal -o build --debug

build:
	mkdir build

test: build/linal
	build/linal

clean:
	rm -rf build

.PHONY: clean test
