#include "hext_wrapper.h"
#include <hext/ParseHext.h>
#include <hext/Html.h>
#include <univalue.h>

int html2json(std::string hext, std::string html)
{
  // Build a rule that extracts links containing images
  auto rule = hext::ParseHext(hext.c_str());

  // Some example HTML input
  auto parsed = hext::Html(html.c_str());

  // Do the actual extraction. Rule::extract returns
  // a std::vector<std::multimap<std::string, std::string>>
  // where each multimap contains a complete rule match.
  auto results = rule.extract(parsed);

  // Print all key-value pairs from each rule match
  for(auto result : results)
  {
    for(auto pair : result)
      std::cout << pair.first << ": " << pair.second << "\n";
    std::cout << "\n";
  }

  // Output:
  //   image: coffee.jpg
  //   link: /coffee
  //   title: #1 Coffee turns nights into code
  //
  //   image: beer.jpg
  //   link: /beer
  //   title: #2 Beer improves dance skill by 70%

  return 0;
}

/*
int main()
{
    std::string hext =
        "<a href:link @text:title>"
        "  <img src:image />"
        "</a>";
    std::string html =
        "<a href='/coffee'>"
        "  <span>#1</span>"
        "  <span>Coffee</span>"
        "  <img src='coffee.jpg' />"
        "  <span>turns nights into code</span>"
        "</a>"
        "<a href='/beer'>"
        "  <span>#2</span>"
        "  <span>Beer</span>"
        "  <img src='beer.jpg' />"
        "  <span>improves dance skill by 70%</span>"
        "</a>";

    return html2json(hext, html);
}
*/

