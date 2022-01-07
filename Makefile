all: check_environment dependencies hext.js
test: all run-tests

check_environment:
	if ! which em++ 2> /dev/null || \
		! which emar 2> /dev/null  || \
		! which emmake 2> /dev/null || \
		! which emcmake 2> /dev/null; then \
		echo "Emscripten not on PATH! Quitting."; \
		exit 1; \
	fi

.PHONY: dependencies
dependencies:
	mkdir -p build
	mkdir -p build-dep
	make -f Makefile.boost
	make -f Makefile.gumbo
	make -f Makefile.libhext

hext.js:
	em++ -std=c++17 -O3 -DNDEBUG \
		-Weverything \
		-Wno-c++98-compat \
		-Wno-c++98-compat-pedantic \
		-Wno-documentation \
		-Wno-documentation-html \
		-Wno-documentation-unknown-command \
		-Wno-exit-time-destructors \
		-Wno-global-constructors \
		-Wno-padded \
		-Wno-switch-enum \
		-Wno-weak-vtables \
		-Wno-missing-prototypes \
		--bind \
		./wrapper/hext-emscripten.cpp \
		-o $@ \
		-I./build-dep/include \
		./build-dep/lib/libhext.a \
		./build-dep/lib/libgumbo.a \
		--extern-post-js ./wrapper/extern-post.js \
		-s MODULARIZE=1 \
		-s EXPORT_NAME="loadHext" \
		-s EXPORT_ES6=1 \
		-s SINGLE_FILE=1 \
		-s ALLOW_MEMORY_GROWTH=1 \
		-s DISABLE_EXCEPTION_CATCHING=0
	sed -i 's/export default loadHext;//g' $@
	grep -sq 'export default loadHext' $@ \
		&& (echo "loadHext export detected. Failing build." && exit 1) \
		|| echo "Build successful."

run-tests:
	HTMLEXT="node ./htmlext.wasm.js" \
		./build/hext-*/test/blackbox.sh \
		./build/hext-*/test/case/*hext

clean:
	make -f Makefile.boost clean
	make -f Makefile.gumbo clean
	make -f Makefile.libhext clean
	rm -rf build-dep
	rm -rf build
	rm -f hext-emscripten.js
	rm -f hext-emscripten.wasm
	rm -f hext-emscripten.html

