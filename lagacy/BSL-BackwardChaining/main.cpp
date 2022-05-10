#include <fstream>
#include <iostream>

#include "expr.h"
#include "lex.h"
#include "parse.h"
#include "solver.h"

using namespace std;

int main(int argc, char* argv[]) {
  ifstream rules(argv[1]);
  Parser rules_parser(rules), quries_parser(cin);
  Solver solver(rules_parser.parse());
  cout << "| ?- ";
  while (!quries_parser.accept(END)) {
    auto ans = solver.solve(quries_parser.parse_expr());
    quries_parser.expect(DOT);
    cout << endl;
    cout << (ans ? "yes" : "no") << endl;
    cout << "| ?- ";
  }
  cout << endl;
}
