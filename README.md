# Hext.js - Hext for JavaScript

[Hext](https://github.com/html-extract/hext) is a domain-specific language for extracting structured data from HTML documents.
Visit [Hext's documentation](https://hext.thomastrapp.com/) to learn more about Hext.

Hext.js is a JavaScript/WebAssembly module that can be used in a browser.

```html
<!-- latest hext.js release -->
<script src="https://cdn.jsdelivr.net/gh/html-extract/hext.js/dist/hext.js"></script>
<script>
(function() {
  // loadHext() returns a promise
  loadHext().then(hext => {
    // hext.Html's constructor expects a single argument
    // containing an UTF-8 encoded string of HTML.
    const html = new hext.Html(
      '<a href="one.html">  <img src="one.jpg" />  </a>' +
      '<a href="two.html">  <img src="two.jpg" />  </a>' +
      '<a href="three.html"><img src="three.jpg" /></a>');

    // hext.Rule's constructor expects a single argument
    // containing a Hext snippet.
    // Throws an Error on invalid syntax, with
    // Error.message containing the error description.
    const rule = new hext.Rule('<a href:link>' +
                               '  <img src:image />' +
                               '</a>');

    // hext.Rule.extract expects an argument of type
    // hext.Html. Returns an Array containing Objects
    // which contain key-value pairs of type String.
    const result = rule.extract(html);

    // hext.Rule.extract has a second, optional parameter
    // of type unsigned int, called max_searches.
    // The search for matching elements is aborted by
    // throwing an exception after this limit is reached.
    // The default is 0, which never aborts. If running
    // untrusted hext templates, it is recommend to set
    // max_searches to some high value, like 10000, to
    // protect against resource exhaustion.
    // const result = rule.extract(html, 10000);

    // print each key-value pair
    for(var i in result)
    {
      for(var key in result[i])
        console.log(key, "->", result[i][key]);
      console.log()
    }
  });
})();
</script>
```

The current development version is found in [dist/hext.js](./dist/hext.js).

Hext.js also works in Node ([example](./htmlext.wasm.js)). If performance is important, you may prefer using [Hext for Node](https://hext.thomastrapp.com/download) instead. Hext for Node is a native node addon for Linux and Mac OS. For other language bindings visit [hext.thomastrapp.com/download](https://hext.thomastrapp.com/download).


# Building Hext.js from source

[Hext](https://github.com/html-extract/hext) is written in C++. This repo contains a full build process for compiling Hext and all its dependencies to JavaScript/WebAssembly.

In order to build this, you need [Emscripten](https://emscripten.org/docs/getting_started/downloads.html) and the following packages:
`wget git python3 build-essential libxml2 libtool autoconf rapidjson-dev cmake`.

Then compilation is done with a single command:

    make

This will download and build all of Hext's dependencies. Then it will build libhext itself and a Hext wrapper which compiles to a JavaScript/WebAssembly module for use in browsers.


## Testing

Running `make test` will run libhext's [blackbox tests](https://github.com/html-extract/hext/tree/master/test/case) through [htmlext.wasm.js](./htmlext.wasm.js), which uses node.
To test the latest version of hext.js in your browser, visit [hext.thomastrapp.com/hext.js-test/](https://hext.thomastrapp.com/hext.js-test/).

