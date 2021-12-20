#include <hext/Html.h>
#include <hext/MaxSearchError.h>
#include <hext/ParseHext.h>
#include <hext/Result.h>
#include <hext/Rule.h>
#include <hext/SyntaxError.h>

#include <emscripten.h>
#include <emscripten/bind.h>
#include <emscripten/val.h>

#include <cstddef>
#include <cstdint>
#include <stdexcept>
#include <string>
#include <utility>


namespace {


emscripten::val ResultToVal(const hext::Result& result)
{
  emscripten::val envelope(emscripten::val::array());
  std::size_t env_index = 0;
  for(const auto& map : result)
  {
    emscripten::val obj(emscripten::val::object());
    auto it = map.cbegin();
    while( it != map.cend() )
    {
      if( map.count(it->first) < 2 )
      {
        obj.set(it->first, it->second);
        ++it;
      }
      else
      {
        // collapse multiple elements with same key to array
        emscripten::val arr(emscripten::val::array());
        std::size_t arr_index = 0;

        auto lower = map.lower_bound(it->first);
        auto upper = map.upper_bound(it->first);
        for(; lower != upper; ++lower)
          arr.set(arr_index++, lower->second);

        obj.set(it->first, arr);
        it = upper;
      }
    }

    envelope.set(env_index++, obj);
  }

  return envelope;
}


} // namespace


class Html
{
public:
  explicit Html(std::string str_html)
  : buffer_(std::move(str_html))
  , html_(buffer_.c_str(), buffer_.size())
  {}

  std::string buffer_;
  hext::Html html_;
};


class Rule
{
public:
  explicit Rule(const std::string& str_hext)
  : rule_()
  {
    try
    {
      this->rule_ = hext::ParseHext(str_hext.c_str(),
                                    str_hext.size());
    }
    catch( const hext::SyntaxError& e )
    {
      // requires em++ switch '-s DISABLE_EXCEPTION_CATCHING=0'
      emscripten::val::global("Error").new_(
        emscripten::val(
          std::string(e.what())
        )
      ).throw_();
    }
  }

  emscripten::val extract(const Html& html) const
  {
    return this->extract(html, 0);
  }

  emscripten::val extract(const Html& html, std::uint32_t max_searches) const
  {
    try
    {
      return ResultToVal(this->rule_.extract(html.html_, max_searches));
    }
    catch( const hext::MaxSearchError& e )
    {
      // requires em++ switch '-s DISABLE_EXCEPTION_CATCHING=0'
      emscripten::val::global("Error").new_(
        emscripten::val(
          std::string(e.what())
        )
      ).throw_();
    }
  }

private:
  hext::Rule rule_;
};


EMSCRIPTEN_BINDINGS(hext) {
  emscripten::class_<Html>("Html")
    .constructor<std::string>();
  emscripten::class_<Rule>("Rule")
    .constructor<std::string>()
    .function(
      "extract",
      emscripten::select_overload<emscripten::val(const Html&) const>(&Rule::extract))
    .function(
      "extract",
      emscripten::select_overload<emscripten::val(const Html&, std::uint32_t) const>(&Rule::extract));
}

