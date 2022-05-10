#ifndef SU_BOLEYN_BSL_SOLVER_H
#define SU_BOLEYN_BSL_SOLVER_H

#include <stack>
#include <string>
#include <utility>
#include <vector>

#include "expr.h"

using namespace std;

struct Solver {
  vector<pair<shared_ptr<Expr>, vector<shared_ptr<Expr>>>> rules;
  map<string, shared_ptr<Expr>> vars;
  Solver(vector<pair<shared_ptr<Expr>, vector<shared_ptr<Expr>>>>&& rules)
      : rules(rules) {}
  pair<shared_ptr<Expr>, vector<shared_ptr<Expr>>> inst(
      pair<shared_ptr<Expr>, vector<shared_ptr<Expr>>> rule,
      map<string, shared_ptr<Expr>>& m) {
    pair<shared_ptr<Expr>, vector<shared_ptr<Expr>>> r;
    r.first = inst(rule.first, m);
    for (auto& e : rule.second) {
      r.second.push_back(inst(e, m));
    }
    return r;
  }
  shared_ptr<Expr> inst(shared_ptr<Expr> e, map<string, shared_ptr<Expr>>& m) {
    if (e->is_var()) {
      if (!m.count(e->f)) {
        auto t = make_shared<Expr>();
        stringstream s;
        s << e->f << "_" << t;
        t->f = s.str();
        m[e->f] = t;
      }
      return m[e->f];
    } else {
      auto t = make_shared<Expr>();
      t->f = e->f;
      for (auto x : e->xs) {
        t->xs.push_back(inst(x, m));
      }
      return t;
    }
  }
  shared_ptr<Expr> find(shared_ptr<Expr> x,
                        map<shared_ptr<Expr>, shared_ptr<Expr>>& p) {
    if (p.count(x)) {
      return p[x] = find(p[x], p);
    } else {
      return x;
    }
  }
#ifdef SOUND
  bool occ(shared_ptr<Expr> a, shared_ptr<Expr> b,
           map<shared_ptr<Expr>, shared_ptr<Expr>>& p) {
    if (b->is_var()) {
      return a == b;
    } else {
      for (size_t i = 0; i < b->xs.size(); i++) {
        if (occ(a, find(b->xs[i], p), p)) {
          return true;
        }
      }
      return false;
    }
  }
#endif
  bool unify(shared_ptr<Expr> a, shared_ptr<Expr> b,
             map<shared_ptr<Expr>, shared_ptr<Expr>>& p) {
    a = find(a, p);
    b = find(b, p);
    if (a != b) {
      if (a->is_var()) {
#ifdef SOUND
        if (occ(a, b, p)) {
          return false;
        }
#endif
        p[a] = b;
      } else if (b->is_var()) {
#ifdef SOUND
        if (occ(b, a, p)) {
          return false;
        }
#endif
        p[b] = a;
      } else {
        if (a->f == b->f && a->xs.size() == b->xs.size()) {
          for (size_t i = 0; i < a->xs.size(); i++) {
            if (!unify(a->xs[i], b->xs[i], p)) {
              return false;
            }
          }
        } else {
          return false;
        }
      }
    }
    return true;
  }
  string to_string(shared_ptr<Expr> e,
                   map<shared_ptr<Expr>, shared_ptr<Expr>>& par) {
    if (e->is_var()) {
      e = find(e, par);
      if (e->is_var()) {
        return e->f;
      } else {
        return to_string(e, par);
      }
    } else {
      stringstream s;
      s << e->f;
      if (e->xs.size()) {
        s << "(";
        for (size_t i = 0; i < e->xs.size(); i++) {
          if (i) {
            s << ", ";
          }
          s << to_string(e->xs[i], par);
        }
        s << ")";
      }
      return s.str();
    }
  }
  bool solve(vector<shared_ptr<Expr>> goals,
             map<shared_ptr<Expr>, shared_ptr<Expr>>& par) {
    //    for (size_t i = 0; i < goals.size(); i++) {
    //      cout << to_string(goals[i], par) << (i + 1 == goals.size() ? ".\n" :
    //      ",");
    //    }
    if (goals.empty()) {
      if (vars.size()) {
        cout << endl;
        for (auto& v : vars) {
          cout << v.first << " = " << to_string(v.second, par) << endl;
        }
      }
      return true;
    } else {
      for (auto& rule : rules) {
        map<string, shared_ptr<Expr>> m;
        pair<shared_ptr<Expr>, vector<shared_ptr<Expr>>> r = inst(rule, m);
        vector<shared_ptr<Expr>> g(goals);
        map<shared_ptr<Expr>, shared_ptr<Expr>> p = par;
        if (unify(r.first, g.back(), p)) {
          //          cout << to_string(r.first, p) << " u " <<
          //          to_string(g.back(), p)
          //               << endl;
          g.pop_back();
          g.insert(g.end(), r.second.rbegin(), r.second.rend());
          if (solve(g, p)) {
            return true;
          }
        } else {
          //          cout << to_string(r.first, p) << " !u " <<
          //          to_string(g.back(), p)
          //               << endl;
        }
      }
      return false;
    }
  }
  bool solve(shared_ptr<Expr> expr) {
    vector<shared_ptr<Expr>> goals;
    map<shared_ptr<Expr>, shared_ptr<Expr>> par;
    vars.clear();
    goals.push_back(inst(expr, vars));
    return solve(goals, par);
  }
};

#endif
