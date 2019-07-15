all: check_environment dependencies build_wrapper

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
	make -f Makefile.univalue
	make -f Makefile.libhext

build_wrapper:
	em++ -std=c++1z -O3 -DNDEBUG \
		./src/hext_wrapper.cpp \
		-o hext_wrapper.html \
		-I ./include \
		-I./build-dep/include \
		-Wl,-rpath,../build-dep/lib \
		./build-dep/lib/libhext.a \
		./build-dep/lib/libgumbo.a \
		./build-dep/lib/libboost_regex.so \
		./build-dep/lib/libunivalue.a \
		-s EXPORTED_FUNCTIONS='["_html2json"]' \
		-s EXTRA_EXPORTED_RUNTIME_METHODS='["ccall"]'

install-autoscrape:
	cp hext_wrapper.wasm ../CJW/autoscrape-extractor-workbench/dist/
	cp hext_wrapper.js ../CJW/autoscrape-extractor-workbench/dist/

clean:
	make -f Makefile.boost clean
	make -f Makefile.gumbo clean
	make -f Makefile.univalue clean
	make -f Makefile.libhext clean
	rm -rf hext_wrapper.js
	rm -rf hext_wrapper.wasm
	rm -rf hext_wrapper.html


