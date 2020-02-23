all: check_environment dependencies hext-emscripten.html
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

hext-emscripten.html:
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
		-o hext-emscripten.html \
		-I./build-dep/include \
		./build-dep/lib/libhext.a \
		./build-dep/lib/libgumbo.a \
		./build-dep/lib/libboost_regex.so \
		-s ALLOW_MEMORY_GROWTH=1 \
		-s DISABLE_EXCEPTION_CATCHING=0

run-tests:
	HTMLEXT="node ./htmlext.wasm.js" \
		./build/hext-0.8.3/test/blackbox.sh \
		./build/hext-0.8.3/test/case/*hext

clean:
	make -f Makefile.boost clean
	make -f Makefile.gumbo clean
	make -f Makefile.libhext clean
	rm -rf build-dep
	rm -rf build
	rm -f hext-emscripten.js
	rm -f hext-emscripten.wasm
	rm -f hext-emscripten.html

