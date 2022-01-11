#!/usr/bin/env node

var path = require('path');
var util = require('util');
var file = require('fs');

var importHext = (() => {
  switch( process.env.HEXT_JS )
  {
    case "hext-without-eval.js":
      return require("./hext-without-eval.js");

    case "hext.js":
    default:
      return require("./hext.js");
  }
})();

importHext().then(hext => {
  var args = process.argv.slice(2);
  var scriptname = path.basename(__filename);
  if( args.length < 1 )
  {
    console.log(util.format("Usage: %s <file-hext> <file-html>", scriptname));
    console.log("  Applies Hext from <file-hext> to the HTML document in" +
                " <file-html>");
    console.log("  and prints the result as JSON, one object per line.");
    process.exit();
  }
  if( args.length < 2 )
  {
    console.error(util.format("%s: Error: missing arguments", scriptname));
    process.exit(1);
  }

  var strhext = file.readFileSync(args[0], "utf-8");
  var strhtml = file.readFileSync(args[1], "utf-8");

  var rule;
  try
  {
    rule = new hext.Rule(strhext);
  }
  catch(e)
  {
    console.error(util.format("%s: In %s: %s", scriptname, args[0], e.message));
    process.exit(1);
  }

  var html = new hext.Html(strhtml);
  var result;
  try
  {
    result = rule.extract(html, 10000);
  }
  catch(e)
  {
    console.error(util.format("%s: In %s: %s", scriptname, args[0], e.message));
    process.exit(1);
  }

  for(var i in result)
    console.log(JSON.stringify(result[i]));
});

