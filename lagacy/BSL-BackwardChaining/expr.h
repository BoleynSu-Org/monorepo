#ifndef SU_BOLEYN_BSL_EXPR_H
#define SU_BOLEYN_BSL_EXPR_H

#include <memory>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

#include "lex.h"

using namespace std;

struct Expr {
  string f;
  vector<shared_ptr<Expr>> xs;

  bool is_var() { return 'A' <= f[0] && f[0] <= 'Z'; }
  string to_string() {
    stringstream s;
    s << f;
    if (xs.size()) {
      s << "(";
      for (size_t i = 0; i < xs.size(); i++) {
        if (i) {
          s << ", ";
        }
        s << xs[i]->to_string();
      }
      s << ")";
    }
    return s.str();
  }
};

#endif
