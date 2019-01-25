#include "hext_wrapper.h"
#include <hext/ParseHext.h>
#include <hext/Html.h>
#include <univalue.h>

/**
 * Extract JSON data specified in a hext template from a
 * source HTML document and output the result as a JSON
 * string.
 */
const char * html2json(std::string hext, std::string html)
{
  auto rule = hext::ParseHext(hext.c_str());
  auto parsed = hext::Html(html.c_str());
  auto results = rule.extract(parsed);

  UniValue json_results(UniValue::VARR);
  for(auto result : results)
  {
      UniValue json_row(UniValue::VOBJ);
      for(auto pair : result)
      {
          json_row.pushKV(pair.first, pair.second);
      }
      json_results.push_back(json_row);
  }

    return json_results.write().c_str();
}

