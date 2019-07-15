all: check_environment dependencies build_wrapper

check_environment:
	if ! which em++ 2> /dev/null || \
		! which emar 2> /dev/null  || \
		! which emmake 2> /dev/null || \
		! which emcmake 2> /dev/null; then \
		echo "Emscripten not on PATH! Quitting."; \
		exit 1; \
	fi

dependencies:
	make -f Makefile.boost
	make -f Makefile.gumbo
	make -f Makefile.univalue
	make -f Makefile.libhext

build_wrapper:
	em++ -std=c++1z -O3 -DNDEBUG \
		./src/hext_wrapper.cpp \
		-o hext_wrapper.html \
		-I ./include \
		-I./hext_build/include \
		-I./gumbo_build/include  \
		-I./boost_build/include  \
		-I./univalue_build/include \
		-Wl,-rpath,../boost_build/lib \
		./hext_build/lib/libhext.a \
		./gumbo_build/lib/libgumbo.a \
		./boost_build/lib/libboost_regex.so \
		./univalue_build/lib/libunivalue.a \
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


