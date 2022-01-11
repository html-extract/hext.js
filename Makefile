all: check_environment dependencies hext.mjs hext.js hext-without-eval.js
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

em_flags = -std=c++17 \
	-O3 \
	-DNDEBUG \
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
	-I./build-dep/include \
	./build-dep/lib/libhext.a \
	./build-dep/lib/libgumbo.a \
	-s MODULARIZE=1 \
	-s EXPORT_NAME="loadHext" \
	-s SINGLE_FILE=1 \
	-s ALLOW_MEMORY_GROWTH=1 \
	-s DISABLE_EXCEPTION_CATCHING=0

hext.mjs:
	em++ $(em_flags) \
		--extern-post-js ./wrapper/extern-post.js \
		-s EXPORT_ES6=1 \
		-o $@
	sed -i 's/export default loadHext;//g' $@
	grep -sq 'export default loadHext' $@ \
		&& (echo "loadHext export detected. Failing build." && exit 1) \
		|| echo "Build successful."

hext.js:
	em++ $(em_flags) -o $@

hext-without-eval.js:
	em++ $(em_flags) -s DYNAMIC_EXECUTION=0 -o $@

run-tests:
	HTMLEXT="node ./htmlext.wasm.js" \
		./build/hext-*/test/blackbox.sh \
		./build/hext-*/test/case/*hext
	HEXT_JS=hext-without-eval.js HTMLEXT="node ./htmlext.wasm.js" \
		./build/hext-*/test/blackbox.sh \
		./build/hext-*/test/case/*hext

clean:
	make -f Makefile.boost clean
	make -f Makefile.gumbo clean
	make -f Makefile.libhext clean
	rm -rf build-dep
	rm -rf build
	rm -f hext.js
	rm -f hext.mjs
	rm -f hext-without-eval.js

