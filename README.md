# Hext Emscripten

[![Build Status](https://travis-ci.org/html-extract/hext-emscripten.svg?branch=master)](https://travis-ci.org/html-extract/hext-emscripten)

This is a full Make build process for compiling the C/C++ Hext and all its dependencies to JavaScript/WebAssembly.

In order to build this, you need [Emscripten](https://kripken.github.io/emscripten-site/docs/getting_started/downloads.html).

Then compilation is done with a single command:

    make

This will download, and build all Hext dependencies. Then it will build libhext itself and a Hext wrapper which compiles to a JavaScript/WebAssembly/HTML payload for use in browser.

Running the code is accomplished by visiting the `hext-emscripten.html` file (via a local webserver like `python3 -m http.server 8080`) and calling the Emscripten compiled Hext library like this:

```
// parse html
var html = new Module.Html("<body><div>Hello</div><div>World</div></body>")

// parse hext
var rule = new Module.Rule("<div @text:HI />");

// use rule to extract results from html
var results = rule.extract(html);

// results is an array containing objects with key/value-pairs
console.log(results);

// print results as JSON
console.log(JSON.stringify(results));
```

Using `hext-emscripten.js` with node does work as well:
```
#!/usr/bin/env node

var hext = require('./hext-emscripten.js');

hext.onRuntimeInitialized = function() {
  var html = new hext.Html("<body><div>Hello</div><div>World</div></body>")
  var rule = new hext.Rule("<div @text:HI />");
  var results = rule.extract(html);
  console.log(results);
};
```

Also check out [htmlext.wasm.js](./htmlext.wasm.js) which is a stripped down JavaScript port of the htmlext command line utility.

## Testing

Running `make test` will run libhext's [blackbox tests](https://github.com/html-extract/hext/blob/master/test/blackbox.sh) through `htmlext.wasm.js`.

