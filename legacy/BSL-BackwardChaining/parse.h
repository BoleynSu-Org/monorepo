#ifndef SU_BOLEYN_BSL_PARSE_H
#define SU_BOLEYN_BSL_PARSE_H

#include <iostream>
#include <map>
#include <memory>
#include <string>
#include <utility>
#include <vector>

#include "expr.h"
#include "lex.h"

using namespace std;

struct Parser {
  Lexer lexer;
  Token t;

  Parser(istream& in) : lexer(in) {}

  bool match(TokenType token_type) {
    while (lexer.look_at(0).token_type == SPACE) {
      lexer.next();
    }
    t = lexer.look_at(0);
    return lexer.look_at(0).token_type == token_type;
  }

  bool accept(TokenType token_type) {
    if (match(token_type)) {
      lexer.next();
      return true;
    }
    return false;
  }

  void expect(TokenType token_type) {
    if (!accept(token_type)) {
      cerr << "ERROR!" << endl;  // FIXME
      cerr << lexer.look_at(0).position.beginRow << ","
           << lexer.look_at(0).position.beginColumn << ":"
           << "expect " << token_type << " but get "
           << lexer.look_at(0).token_type << " (" << lexer.look_at(0).data
           << ")" << endl;
    }
  }
  shared_ptr<Expr> parse_expr() {
    auto expr = make_shared<Expr>();
    if (match(CONST)) {
      expr->f = lexer.next().data;
      if (accept(LEFT_PARENTHESIS)) {
        for (;;) {
          expr->xs.push_back(parse_expr());
          if (!accept(COMMA)) {
            break;
          }
        }
        expect(RIGHT_PARENTHESIS);
      }
    } else if (match(VAR)) {
      expr->f = lexer.next().data;
    } else {
      cerr << "ERROR!" << endl;
      cerr << "expect a CONST or VAR" << endl;
    }
    return expr;
  }
  vector<pair<shared_ptr<Expr>, vector<shared_ptr<Expr>>>> parse() {
    vector<pair<shared_ptr<Expr>, vector<shared_ptr<Expr>>>> rules;
    while (match(CONST)) {
      auto h = parse_expr();
      vector<shared_ptr<Expr>> b;
      if (accept(IF)) {
        do {
          b.push_back(parse_expr());
        } while (accept(COMMA));
      }
      rules.emplace_back(h, b);
      expect(DOT);
    }
    expect(END);
    return rules;
  }
};

#endif
