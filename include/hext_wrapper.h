#ifndef WRAPPER_H_INCLUDED
#define WRAPPER_H_INCLUDED

#include <iostream>

extern "C" {

const char * html2json(std::string hext, std::string html);

}

#endif // WRAPPER_H_INCLUDED

