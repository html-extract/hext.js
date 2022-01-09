# Hext.js — Use Hext in a browser or with Node

![Hext Logo](https://raw.githubusercontent.com/html-extract/html-extract.github.io/master/hext-logo-x100.png)

Hext is a domain-specific language for extracting structured data from HTML. It can be thought of as a counterpart to templates, which are typically used by web developers to structure content on the web.

Note: This package is a JavaScript/WebAssembly port of Hext. Hext is also available as a native node addon: npm install hext
See [hext.thomastrapp.com](https://hext.thomastrapp.com/) for more.

## Using Hext.js with Node

See [hext.thomastrapp.com/download#hext-for-javascript](https://hext.thomastrapp.com/download#hext-for-javascript).

```
const loadHext = require('./hext.js');

loadHext().then(hext => {
  const html = new hext.Html("<ul><li>Hello</li><li>World</li></ul>");
  const rule = new hext.Rule("<li @text:my_text />");
  const result = rule.extract(html).map(x => x.my_text).join(", ");
  console.log(result); // "Hello, World"
});
```

## License

[Hext](https://hext.thomastrapp.com/) is released under the terms of the Apache License v2.0. The source code is hosted on [Github](https://github.com/html-extract/hext.git).
This binary package includes content authored by third parties:
* [gumbo-parser](https://github.com/google/gumbo-parser). Copyright 2010 Google Inc. See gumbo.license.

