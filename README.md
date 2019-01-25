# Hext Emscripten

This is a full Make build process for compiling the C/C++ Hext and all its dependencies to JavaScript/WebAssembly.

In order to build this, you need [Emscripten](https://kripken.github.io/emscripten-site/docs/getting_started/downloads.html).

Then compilation is done with a single command:

    make

This will download, patch, and build all Hext dependencies. Then it will build libhext itself and a Hext wrapper which compiles to a JavaScript/WebAssembly/HTML payload for use in browser.

Running the code is accomplished by visiting the `hext_wrapper.html` file (via a local webserver like `python3 -m http.server 8080`) and calling the Emscripten compiled Hext library like this:

	const retVal = Module.ccall(
      "html2json",
      "number",
      ["string", "string"],
      ["<div @text:HI />", "<body><div>Hello</div><div>World</div></body>"]
    );

