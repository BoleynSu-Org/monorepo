#ifndef SU_BOLEYN_BSL_LEX_H
#define SU_BOLEYN_BSL_LEX_H

#include <cstdio>
#include <iostream>
#include <queue>
#include <string>

using namespace std;

struct Position {
  string fileNamespace, filename;
  int beginRow, beginColumn, endRow, endColumn;
};

enum TokenType {
  LEFT_PARENTHESIS,
  RIGHT_PARENTHESIS,
  IF,
  COMMA,
  DOT,
  VAR,
  CONST,
  SPACE,
  ERROR,
  END
};

struct Token {
  TokenType token_type;
  string data;
  Position position;
};

struct Lexer {
  istream& is;
  Position position;
  deque<Token> tokens;
  Lexer(istream& is) : is(is) {
    position.endRow = 1;
    position.endColumn = 1;
  }
  Token new_token() {
    position.beginRow = position.endRow;
    position.beginColumn = position.endColumn;
    TokenType token_type;
    string data;
    char c = is.get();
    if (c == EOF) {
      return {END, "", position};
    } else if (c == ' ' || c == '\t') {
      data.push_back(c);
      position.endColumn++;
    } else if (c == '\n') {
      data.push_back(c);
      position.endColumn++;
      position.endRow++;
      position.endColumn = 1;
    } else if (c == '\r') {
      data.push_back(c);
      position.endColumn++;
      c = is.get();
      if (c != EOF) {
        if (c == '\n') {
          data.push_back(c);
          position.endColumn++;
        } else {
          is.putback(c);
        }
      }
      position.endRow++;
      position.endColumn = 1;
    } else if (('A' <= c && c <= 'Z') || ('a' <= c && c <= 'z') || c == '_' ||
               c == '\'') {
      for (;;) {
        data.push_back(c);
        position.endColumn++;
        c = is.get();
        if (c == EOF) {
          break;
        }
        if (!(('0' <= c && c <= '9') || ('A' <= c && c <= 'Z') ||
              ('a' <= c && c <= 'z') || c == '_' || c == '\'')) {
          is.putback(c);
          break;
        }
      }
    } else {
      data.push_back(c);
      position.endColumn++;
      if (c == ':') {
        c = is.get();
        if (c != EOF) {
          if (c == '-') {
            data.push_back(c);
            position.endColumn++;
          } else {
            is.putback(c);
          }
        }
      } else if (c == '%') {
        for (;;) {
          c = is.get();
          if (c == EOF) {
            break;
          }
          if (c == '\r' || c == '\n') {
            is.putback(c);
            break;
          }
          data.push_back(c);
          position.endColumn++;
        }
      }
    }
    if (data == "(") {
      token_type = LEFT_PARENTHESIS;
    } else if (data == ")") {
      token_type = RIGHT_PARENTHESIS;
    } else if (data == ":-") {
      token_type = IF;
    } else if (data == ",") {
      token_type = COMMA;
    } else if (data == ".") {
      token_type = DOT;
    } else {
      c = data[0];
      if ('A' <= c && c <= 'Z') {
        token_type = VAR;
      } else if (('a' <= c && c <= 'z') || c == '_' || c == '\'') {
        token_type = CONST;
      } else if (c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '%') {
        token_type = SPACE;
      } else {
        token_type = ERROR;
      }
    }
    return {token_type, data, position};
  }
  Token look_at(int i) {
    while (i >= (int)tokens.size()) {
      tokens.push_back(new_token());
    }
    return tokens[i];
  }
  Token next() {
    if (tokens.empty()) {
      return new_token();
    }
    Token token = tokens.front();
    tokens.pop_front();
    return token;
  }
};

#endif
