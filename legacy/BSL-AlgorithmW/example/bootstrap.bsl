-- ffi types
data FfiString {}
data FfiInt {}

-- builtin types
data Char {}
data Int {}

-- std library
data Unit {
    Unit:Unit
}

data Bool {
    False:Bool;
    True:Bool
}

data List a {
  Nil:forall a.List a;
  Cons:forall a.a->List a->List a
}

data Pair a b {
    Pair:forall a.forall b.a->b->Pair a b
}

data Either a b {
    Left:forall a.forall b.a->Either a b;
    Right:forall a.forall b.b->Either a b
}

data Maybe a {
    Nothing:forall a.Maybe a;
    Just:forall a.a->Maybe a
}

data RealWorld {
    RealWorld:RealWorld
}

data Ordering {
    LT:Ordering;
    EQ:Ordering;
    GT:Ordering
}

data Eq a {
    MkEq:forall a.(a->a->Bool)->Eq a
}

data Ord a {
    MkOrd:forall a.(Eq a)-> -- Eq a
                   (a->a->Ordering)-> -- compare
                   Ord a
}

data Functor f {
    MkFunctor:forall f.(forall a.forall b.(a->b)->f a->f b)-> -- fmap
                       Functor f
}

data Applicative f {
    MkApplicative:forall f.Functor f-> -- Functor f
                           (forall a.a->f a)-> -- pure
                           (forall a.forall b.f (a->b)->f a->f b)-> -- ap
                           Applicative f
}

data Monad m {
  MkMonad:forall m.Applicative m-> -- Applicative m
                   (forall a.forall b.m a->(a->m b)->m b)-> -- bind
                   Monad m
}

data Alternative f {
    MkAlternative:forall f.Applicative f-> -- Applicative fApplicative f
                           (forall a.f a)-> -- empty
                           (forall a.f a->f a->f a)-> -- alt
                           Alternative f
}

data IO a {
    IO:forall a.(RealWorld->Pair RealWorld a)->IO a
}

-- parser combinator
data ParsingError e {
    ParsingError:forall e.e->ParsingError e;
    GenericParsingError:forall e.List Char->ParsingError e
}

data Parser t e a {
    Parser:forall t.forall e.forall a.(List t->Either (ParsingError e) (Pair (List t) a))-> -- runParser
                                      Parser t e a
}

-- impl
data Token {
  Data:Token;
  Forall:Token;
  Dot:Token;
  Colon:Token;
  Arrow:Token;
  Semicolon:Token;

  Lambda:Token;
  Let:Token;
  Equal:Token;
  In:Token;
  Rec:Token;
  And:Token;
  Case:Token;
  Of:Token;
  Ffi:List Char->Token;

  LeftParenthesis:Token;
  RightParenthesis:Token;
  LeftBrace:Token;
  RightBrace:Token;

  Identifier:List Char->Token;

  Whitespace:List Char->Token;
  Comment:List Char->Token;
}

data Position {
    Position:List Char-> -- filename
             Int-> -- row
             Int-> -- column
             Position
}

data Expr {
    VarExpr:List Char->Expr;
    AppExpr:Expr->Expr->Expr;
    AbsExpr:List Char->Expr->Expr;
    LetExpr:List Char->Expr->Expr->Expr;
    RecExpr:List (Pair (List Char) Expr)->Expr->Expr;
    CaseExpr:Expr->List (Pair (List Char) (Pair (List (List Char)) Expr))->Expr;
    FfiExpr:List Char->Expr;
}

data Mono {
    MonoTerm:Int->Mono;
    MonoFunc:Mono->Mono->Mono
}

data Poly {
    PolyTerm:Mono->Poly;
    PolyForall:Int->Poly->Poly
}

data TypeInferState {
    TypeInferState:Int-> -- nextVar
                   List (Pair Int Mono)-> -- par
                   TypeInferState;
}

data TypeInfer a {
    TypeInfer:forall a.(TypeInferState->Either (List Char) (Pair TypeInferState a))-> -- runTypeInfer
                       TypeInfer a
}

-- ffi
let toChar:FfiInt -> Char = \c -> ffi ` ({
    char* c = BSL_RT_MALLOC(sizeof (char));
    *c = (int)$c;
    c;
}) `
in
rec toString:FfiString -> List Char = \s -> ffi ` ({
    char* s = $s;
    void* ret;
    if (!s[0]) {
        ret = $Nil;
    } else {
        ret = BSL_RT_CALL(BSL_RT_CALL($Cons, BSL_RT_CALL($toChar, s[0])), BSL_RT_CALL($toString, s + 1));
    }
    ret;
}) `
in
let toInt:FfiInt -> Int = \i -> ffi ` ({
    int* i = BSL_RT_MALLOC(sizeof (int));
    *i = (int)$i;
    i;
}) `
in

let readChar:IO (Maybe Char) = IO \r -> Pair r ffi ` ({
    int c = getchar();
    void* ret;
    if (c == -1) {
        ret = $Nothing;
    } else {
        ret = BSL_RT_CALL($Just, BSL_RT_CALL($toChar, c));
    }
    ret;
}) `
in
let writeChar:Char->IO Unit = \c -> IO \r -> Pair r ffi ` ({
    putchar(*(char*)$c);
    $Unit;
}) `
in
let runIO =
    let runIO = \r -> \io -> case io of {
        IO f -> case f r of {
            Pair r out -> out
        }
    } in runIO RealWorld
in

let undefined = ffi ` NULL ` in
let debug = \x -> let y = ffi ` puts("debug") ` in x in

-- std library
let charEq:Char->Char->Bool = \x -> \y -> ffi ` (*(char*)$x == *(char*)$y ? $True : $False) ` in
let charCompare:Char->Char->Ordering = \x -> \y -> ffi ` (*(char*)$x == *(char*)$y ? $EQ : *(char*)$x < *(char*)$y ? $LT : $GT) ` in
let intEq:Int->Int->Bool = \x -> \y -> ffi ` (*(int*)$x == *(int*)$y ? $True : $False) ` in
rec stringEq = \s1 -> \s2 -> case s1 of {
    Cons h1 t1 -> case s2 of {
        Cons h2 t2 -> case charEq h1 h2 of {
            True -> stringEq t1 t2;
            False -> False
        };
        Nil -> False
    };
    Nil -> case s2 of {
        Cons h2 t2 -> False;
        Nil -> True
    }
}
in
let listJoin =
    rec listJoinHelper = \a -> \b -> case a of {
        Cons h t -> Cons h (listJoinHelper t b);
        Nil -> b
    }
    and listJoin = \l -> case l of {
        Cons h t -> listJoinHelper h (listJoin t);
        Nil -> Nil
    }
    in
    listJoin
in
rec map = \f -> \l -> case l of {
    Cons h t -> Cons (f h) (map f t);
    Nil -> Nil
}
in
rec filter = \p -> \l -> case l of {
    Cons h t -> case p h of {
        True -> Cons h (filter p t);
        False -> filter p t
    };
    Nil -> Nil
}
in

let or = \x -> \y -> case x of {
    True -> True;
    False -> y
}
in
let not = \x -> case x of {
    True -> False;
    False -> True
}
in

let return = \m -> case m of {MkMonad a b -> case a of { MkApplicative f p a -> p } } in
let bind = \m -> case m of {MkMonad a b->b} in

let MonadIO =
    let fmap = \f -> \fa -> IO \r -> case fa of {
        IO fa -> case fa r of {
            Pair r a -> Pair r (f a)
        }
    }
    in
    let pure = \a -> IO \r -> Pair r a in
    let bind = \ma -> \f -> IO \r -> case ma of {
        IO ma -> case ma r of {
            Pair r a -> case f a of {IO f->f r}
        }
    }
    in
    let ap = \f -> \a -> bind f \f -> bind a \x -> pure (f x) in
    let FunctorIO = MkFunctor fmap in
    let ApplicativeIO = MkApplicative FunctorIO pure ap in

    MkMonad ApplicativeIO bind
in

-- parser combinator
let runParser = \p -> case p of { Parser runParser -> runParser } in
let MonadParser:forall t.forall e.Monad (Parser t e) =
    let fmap = \f -> \p -> Parser \t -> case runParser p t of {
        Left e -> Left e;
        Right r -> case r of { Pair nt x ->
            Right (Pair nt (f x))
        }
    }
    in
    let pure = \r->Parser \t -> Right (Pair t r) in
    let bind = \p -> \f -> Parser \t -> case runParser p t of {
        Left e -> Left e;
        Right r -> case r of { Pair nt x ->
            runParser (f x) nt
        }
    }
    in
    let ap = \f -> \a -> bind f \f -> bind a \x -> pure (f x) in
    let FunctorParser = MkFunctor fmap in
    let ApplicativeParser = MkApplicative FunctorParser pure ap in

    MkMonad ApplicativeParser bind
in
let AlternativeParser = case MonadParser of {
    MkMonad a b ->
        let empty = Parser \t -> Left (GenericParsingError (toString ffi ` "error: empty: no matches" `)) in
        let alt = \a -> \b -> Parser \t -> case runParser a t of {
            Left err -> case runParser b t of {
                Left err' -> Left err;
                Right r -> Right r
            };
            Right r -> Right r
        }
        in
        MkAlternative a empty alt
}
in

let satisfy = \p -> Parser \t -> case t of {
    Cons h t -> case p h of {
        True -> Right (Pair t h);
        False -> Left (GenericParsingError (toString ffi ` "error: satisfy: not satisfied" `))
    };
    Nil -> Left (GenericParsingError (toString ffi ` "error: satisfy: no more token to satisfy" `))
}
in
let maybePeek = Parser \t -> case t of {
    Cons h nt -> Right (Pair t (Just h));
    Nil -> Right (Pair t Nothing)
}
in

-- impl
let tokenToString = \t -> case t of {
    Data -> toString ffi ` "data" `;
    Forall -> toString ffi ` "forall" `;
    Dot -> toString ffi ` "." `;
    Colon -> toString ffi ` ":" `;
    Arrow -> toString ffi ` "->" `;
    Semicolon -> toString ffi ` ";" `;

    Lambda -> toString ffi ` "\\" `;
    Let -> toString ffi ` "let" `;
    Equal -> toString ffi ` "=" `;
    In -> toString ffi ` "in" `;
    Rec -> toString ffi ` "rec" `;
    And -> toString ffi ` "and" `;
    Case -> toString ffi ` "case" `;
    Of -> toString ffi ` "of" `;
    Ffi s -> let sep = Cons (toChar ffi ` 36 `)
                      (Cons (toChar ffi ` 36 `) Nil) -- $$
             in
             listJoin (Cons (toString ffi ` "ffi " `)
                      (Cons sep
                      (Cons s
                      (Cons sep Nil))));

    LeftParenthesis -> toString ffi ` "(" `;
    RightParenthesis -> toString ffi ` ")" `;
    LeftBrace -> toString ffi ` "{" `;
    RightBrace -> toString ffi ` "}" `;

    Identifier s -> s;

    Whitespace s -> s;
    Comment s -> s
}
in

rec exprToString = \e -> case e of {
    VarExpr v -> v;
    AppExpr e1 e2 -> listJoin (Cons (toString ffi ` "(" `)
                              (Cons (exprToString e1)
                              (Cons (toString ffi ` ") (" `)
                              (Cons (exprToString e2)
                              (Cons (toString ffi ` ")" `) Nil)))));
    AbsExpr x e -> listJoin (Cons (toString ffi ` "(\\" `)
                            (Cons x
                            (Cons (toString ffi ` " -> " `)
                            (Cons (exprToString e)
                            (Cons (toString ffi ` ")" `) Nil)))));
    LetExpr x e1 e2 -> listJoin (Cons (toString ffi ` "(let " `)
                                (Cons x
                                (Cons (toString ffi ` " = " `)
                                (Cons (exprToString e1)
                                (Cons (toString ffi ` " in " `)
                                (Cons (exprToString e2)
                                (Cons (toString ffi ` ")" `) Nil)))))));
    RecExpr xes e -> toString ffi ` "not implemented" `;
    CaseExpr e pes -> toString ffi ` "not implemented" `;
    FfiExpr s -> toString ffi ` "not implemented" `
}
in

let lex =
    let bind = bind MonadParser in
    let return = return MonadParser in
    rec many = \x -> Parser \t -> case runParser x t of {
        Left e -> Right (Pair t Nil);
        Right r -> case r of { Pair nt h ->
            case runParser (many x) nt of {
                Left e -> Left e;
                Right r -> case r of { Pair nt t-> Right (Pair nt (Cons h t)) }
            }
        }
    }
    in
    let some = \x -> bind x \h -> bind (many x) \t -> return (Cons h t) in
    let alt = case AlternativeParser of { MkAlternative a e alt -> alt } in
    rec all = \x -> Parser \ts -> case ts of {
        Nil -> Right (Pair Nil Nil);
        Cons h t -> case runParser x ts of {
            Left e -> Left e;
            Right r -> case r of { Pair nt h ->
                case runParser (all x) nt of {
                    Left e -> Left e;
                    Right r -> case r of { Pair nt t-> Right (Pair nt (Cons h t)) }
                }
            }
        }
    }
    in
    let matchChar = \c -> satisfy (charEq c) in
    let isUppercase =
        let check = \c -> case charCompare c (toChar ffi ` 'Z' `) of {
            EQ-> True;
            GT-> False;
            LT-> True;
        }
        in
        \c -> case charCompare c (toChar ffi ` 'A' `) of {
            EQ-> check c;
            GT-> check c;
            LT-> False;
        }
    in
    let isLowercase =
        let check = \c -> case charCompare c (toChar ffi ` 'z' `) of {
            EQ-> True;
            GT-> False;
            LT-> True;
        }
        in
        \c -> case charCompare c (toChar ffi ` 'a' `) of {
            EQ-> check c;
            GT-> check c;
            LT-> False;
        }
    in

    let arrow = bind (matchChar (toChar ffi ` '-' `)) \c ->
                bind (matchChar (toChar ffi ` '>' `)) \c ->
                     return Arrow
    in
    let lambda = bind (matchChar (toChar ffi ` '\\' `)) \c ->
                      return Lambda
    in
    let let_ = bind (matchChar (toChar ffi ` 'l' `)) \c ->
               bind (matchChar (toChar ffi ` 'e' `)) \c ->
               bind (matchChar (toChar ffi ` 't' `)) \c ->
                    return Let
    in
    let equal = bind (matchChar (toChar ffi ` '=' `)) \c ->
                     return Equal
    in
    let in_ = bind (matchChar (toChar ffi ` 'i' `)) \c ->
              bind (matchChar (toChar ffi ` 'n' `)) \c ->
                   return In
    in
    let identifier = bind (some (alt (satisfy isLowercase) (satisfy isUppercase))) \s ->
                          return (Identifier s)
    in
    let whitespace = bind (some (alt (matchChar (toChar ffi ` ' ' `))
                                (alt (matchChar (toChar ffi ` '\t' `))
                                (alt (matchChar (toChar ffi ` '\n' `))
                                     (bind (matchChar (toChar ffi ` '\r' `)) \c ->
                                           (alt (matchChar (toChar ffi ` '\n' `)) (return (toChar ffi ` '\0' `)))))))) \s ->
                          return (Whitespace s)
    in

    all (alt arrow (alt lambda (alt let_ (alt equal (alt in_ (alt identifier whitespace))))))
in

let parse =
    let bind = bind MonadParser in
    let return = return MonadParser in
    let empty = case AlternativeParser of {
        MkAlternative a e alt -> e
    }
    in
    rec many = \x -> Parser \t -> case runParser x t of {
        Left e -> Right (Pair t Nil);
        Right r -> case r of { Pair nt h ->
            case runParser (many x) nt of {
                Left e -> Left e;
                Right r -> case r of { Pair nt t-> Right (Pair nt (Cons h t)) }
            }
        }
    }
    in
    let some = \x -> bind x \h -> bind (many x) \t -> return (Cons h t) in
    let alt = case AlternativeParser of { MkAlternative a e alt -> alt } in
    let unreachable = Parser \t -> Left (ParsingError (toString ffi ` "unreachable" `)) in
    let skip = \p -> Parser \t -> Right (Pair (filter p t) Unit) in
    let eof = Parser \t -> case t of {
        Nil -> Right (Pair Nil Unit);
        Cons h t -> Left (ParsingError (toString ffi ` "eof" `))
    }
    in

    let isArrow = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> True;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isLambda = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> True;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isLet = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> True;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isEqual = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> True;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isIn = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> True;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> False
    }
    in
    let isWhitespace = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> True;
        Comment s -> False
    }
    in
    let isComment = \t -> case t of {
        Data -> False;
        Forall -> False;
        Dot -> False;
        Colon -> False;
        Arrow -> False;
        Semicolon -> False;

        Lambda -> False;
        Let -> False;
        Equal -> False;
        In -> False;
        Rec -> False;
        And -> False;
        Case -> False;
        Of -> False;
        Ffi s -> False;

        LeftParenthesis -> False;
        RightParenthesis -> False;
        LeftBrace -> False;
        RightBrace -> False;

        Identifier s -> False;

        Whitespace s -> False;
        Comment s -> True
    }
    in
    let getIdentifier = \t -> case t of {
        Data -> Nothing;
        Forall -> Nothing;
        Dot -> Nothing;
        Colon -> Nothing;
        Arrow -> Nothing;
        Semicolon -> Nothing;

        Lambda -> Nothing;
        Let -> Nothing;
        Equal -> Nothing;
        In -> Nothing;
        Rec -> Nothing;
        And -> Nothing;
        Case -> Nothing;
        Of -> Nothing;
        Ffi s -> Nothing;

        LeftParenthesis -> Nothing;
        RightParenthesis -> Nothing;
        LeftBrace -> Nothing;
        RightBrace -> Nothing;

        Identifier s -> Just s;

        Whitespace s -> Nothing;
        Comment s -> Nothing
    }
    in

    let arrow = satisfy isArrow in
    let lambda = satisfy isLambda in
    let let_ = satisfy isLet in
    let identifier = bind (satisfy \t -> case getIdentifier t of {
        Nothing -> False;
        Just x -> True
    }) \x -> case getIdentifier x of {
        Nothing -> unreachable;
        Just x -> return x
    }
    in
    let equal = satisfy isEqual in
    let in_ = satisfy isIn in

    let isApp1 = bind maybePeek \x -> case x of {
        Nothing -> return False;
        Just x -> return (or (isLambda x) (isLet x))
    }
    in
    let isApp2 = bind maybePeek \x -> case x of {
        Nothing -> return False;
        Just x -> return case getIdentifier x of {
            Nothing -> False;
            Just s -> True
        }
    }
    in

    rec expr = \u -> alt (absExpr u)
                    (alt (letExpr u) (appExpr1 u))
    and expr_ = \u -> (varExpr u)
    and varExpr = \u ->
        bind identifier \x ->
             return (VarExpr x)
    and appExpr1 = \u ->
        bind (appExpr2 u) \e1 ->
        bind isApp1 \b -> case b of {
            False -> return e1;
            True ->  bind (expr u) \e2 ->
                         return (AppExpr e1 e2)
        }
    and appExpr2 = \u ->
        let expr =
            bind isApp2 \b -> case b of {
                False -> empty;
                True -> expr_ u
            }
        in
        rec toApp = \e -> \es -> case es of {
            Cons h t -> toApp (AppExpr e h) t;
            Nil -> e
        }
        in
        bind expr \e ->
        bind (many expr) \es->
             return (toApp e es)
    and absExpr = \u ->
        bind lambda \_ ->
        bind identifier \x ->
        bind arrow \_ ->
        bind (expr u) \e ->
             return (AbsExpr x e)
    and letExpr = \u ->
        bind let_ \_ ->
        bind identifier \x ->
        bind equal \_ ->
        bind (expr u) \e1 ->
        bind in_ \_ ->
        bind (expr u) \e2 ->
            return (LetExpr x e1 e2)
    in

    bind (skip (\x -> not (or (isWhitespace x) (isComment x)))) \_ ->
    bind (expr Unit) \e ->
    bind eof \_ ->
         return e
in

rec typeToString = \t -> Cons (toChar ffi ` 't' `) (toString ffi ` ({
    char* s = BSL_RT_MALLOC(11);
    sprintf(s, "%d", *(int*)$t);
    s;
}) `)
and monoToString = \t -> case t of {
    MonoTerm t -> typeToString t;
    MonoFunc t1 t2 -> listJoin (Cons (toString ffi ` "(" `)
                               (Cons (monoToString t1)
                               (Cons (toString ffi ` "->" `)
                               (Cons (monoToString t2)
                               (Cons (toString ffi ` ")" `) Nil)))))
}
and polyToString = \t -> case t of {
    PolyTerm t -> monoToString t;
    PolyForall t p -> listJoin (Cons (toString ffi ` "forall " `)
                               (Cons (typeToString t)
                               (Cons (toString ffi ` "." `)
                               (Cons (polyToString p) Nil))))
}
in

let typeInfer = \e ->
    let bind = \m -> \f -> TypeInfer \s -> case m of {
        TypeInfer runTypeInfer -> case runTypeInfer s of {
            Left e -> Left e;
            Right r -> case r of {
                Pair ns x -> case f x of {
                    TypeInfer runTypeInfer -> runTypeInfer ns
                }
            }
        }
    }
    in
    let return = \x -> TypeInfer \s -> Right (Pair s x) in
    let fail = \s -> TypeInfer \st -> Left s in
    let runTypeInfer = \infer -> case infer of {
        TypeInfer runTypeInfer -> case runTypeInfer (TypeInferState (toInt ffi ` 0 `) Nil) of {
            Left e -> Left e;
            Right r -> case r of {
                Pair s t -> Right t
            }
        }
    }
    in
    let elem = \e ->
        rec elem = \l -> case l of {
            Cons h t -> case intEq h e of {
                True -> True;
                False -> elem t
            };
            Nil -> False
        }
        in
        elem
    in
    let diff = \l1 -> \l2 ->
        rec diff = \l1 -> case l1 of {
            Cons h t -> case elem h l2 of {
                True -> diff t;
                False -> Cons h (diff t)
            };
            Nil -> Nil
        }
        in diff l1
    in
    rec uniq = \l -> case l of {
        Cons h t -> case elem h t of {
            True -> uniq t;
            False -> Cons h (uniq t)
        };
        Nil -> Nil
    }
    in
    let lookup = \x ->
        rec lookup = \m -> case m of {
            Cons h t -> case h of {
                Pair k v -> case stringEq k x of{
                    True -> Just v;
                    False -> lookup t
                }
            };
            Nil -> Nothing
        }
        in lookup
    in
    let insert = \k -> \v -> \m -> Cons (Pair k v) m in
    let newVar = TypeInfer \s -> case s of {
        TypeInferState nextVar par ->
            let inc = \x -> toInt ffi ` *(int*)$x + 1 ` in
            Right (Pair (TypeInferState (inc nextVar) par) nextVar)
    }
    in
    let find = \x -> TypeInfer \s -> case s of {
        TypeInferState nextVar par ->
            rec find = \x -> \par' -> case par' of {
                Cons h t -> case h of {
                    Pair k v -> case intEq k x of {
                        True -> case v of {
                            MonoTerm t -> find t par;
                            MonoFunc t1 t2 -> v
                        };
                        False -> find x t
                    }
                };
                Nil -> MonoTerm x
            }
            in
            case x of {
                MonoTerm t -> Right (Pair s (find t par));
                MonoFunc t1 t2 -> Right (Pair s x);
            }
    }
    in
    let inst =
        let apply = \s ->
            rec apply = \m -> bind (find m) \m -> case m of {
                MonoTerm t ->
                    rec lookup = \m -> case m of {
                        Cons mh mt -> case mh of {
                            Pair k v -> case intEq k t of {
                                True -> v;
                                False -> lookup mt
                            }
                        };
                        Nil -> t
                    }
                    in
                    return (MonoTerm (lookup s));
                MonoFunc t1 t2 -> bind (apply t1) \t1 ->
                                  bind (apply t2) \t2 ->
                                       return (MonoFunc t1 t2)
            }
            in
            apply
        in
        rec inst = \s -> \p -> case p of {
            PolyForall x p ->
                bind newVar \t ->
                     inst (Cons (Pair x t) s) p;
            PolyTerm m -> apply s m
        }
        in
        inst Nil
    in
    let occ = \x ->
        rec occ = \y -> bind (find y) \y -> case y of {
            MonoTerm t -> case intEq x t of {
                True -> fail (toString ffi ` "occ" `);
                False -> return Unit
            };
            MonoFunc t1 t2 -> bind (occ t1) \_ ->
                                   occ t2
        }
        in
        occ
    in
    let setPar = \x -> \y -> bind (occ x y) \_ -> TypeInfer \s -> case s of {
        TypeInferState nextVar par -> Right (Pair (TypeInferState nextVar (Cons (Pair x y) par)) Unit)
    }
    in
    rec ftv = \p -> case p of {
        PolyForall t p -> bind (ftv p) \f -> return (diff f (Cons t Nil));
        PolyTerm m ->
            rec ftv' = \m -> bind (find m) \m -> case m of {
                MonoTerm t -> return (Cons t Nil);
                MonoFunc t1 t2 -> bind (ftv' t1) \f1 ->
                                  bind (ftv' t2) \f2 ->
                                       return (listJoin (Cons f1 (Cons f2 Nil)))
            }
            in
            ftv' m
    }
    in
    rec ctxFtv = \ctx -> case ctx of {
        Cons h t -> case h of {
            Pair k v -> bind (ftv v) \h ->
                        bind (ctxFtv t) \t ->
                             return (listJoin (Cons h (Cons t Nil)))
        };
        Nil -> return Nil
    }
    in
    let gen = \ctx -> \m ->
        let toPoly = \m ->
            rec toPoly = \f -> case f of {
                Cons h t -> PolyForall h (toPoly t);
                Nil -> PolyTerm m
            }
            in
            toPoly
        in
        bind (ctxFtv ctx) \ctxf ->
        bind (ftv (PolyTerm m)) \mf ->
             let fa = uniq (diff mf ctxf) in
             return (toPoly m mf)
    in
    rec unify:Mono->Mono->TypeInfer Unit = \x -> \y ->
        bind (find x) \x ->
        bind (find y) \y ->
             case x of {
                 MonoTerm t -> case y of {
                     MonoTerm s -> case intEq t s of {
                        True -> return Unit;
                        False -> setPar t y
                     };
                     MonoFunc s1 s2 -> setPar t y
                 };
                 MonoFunc t1 t2 -> case y of {
                     MonoTerm s -> setPar s x;
                     MonoFunc s1 s2 ->
                         bind (unify t1 s1) \_ ->
                              unify t2 s2
                 }
             }
    in
    rec typeInfer = \ctx -> \e -> case e of {
        VarExpr v -> case lookup v ctx of {
            Just t -> inst t;
            Nothing -> fail (toString ffi ` "not found" `)
        };
        AppExpr e1 e2 ->
            bind (typeInfer ctx e1) \t1 ->
            bind (typeInfer ctx e2) \t2 ->
            bind newVar \t3 ->
            bind (unify t1 (MonoFunc t2 (MonoTerm t3))) \_ ->
                 return (MonoTerm t3);
        AbsExpr x e ->
            bind newVar \tx ->
                 let ctx' = insert x (PolyTerm (MonoTerm tx)) ctx in
            bind (typeInfer ctx' e) \te->
                 return (MonoFunc (MonoTerm tx) te);
        LetExpr x e1 e2 ->
            bind (typeInfer ctx e1) \t1 ->
            bind (gen ctx t1) \p1 ->
                 typeInfer (Cons (Pair x p1) ctx) e2;
        RecExpr xes e -> fail (toString ffi ` "not implemented" `);
        CaseExpr e pes -> fail (toString ffi ` "not implemented" `);
        FfiExpr s -> fail (toString ffi ` "not implemented" `)
    }
    in
    rec sub = \x -> bind (find x) \x -> case x of {
        MonoTerm t ->  return x;
        MonoFunc t1 t2 -> bind (sub t1) \t1 ->
                          bind (sub t2) \t2 ->
                               return (MonoFunc t1 t2)
    }
    in
    runTypeInfer (
        bind (typeInfer Nil e) \t ->
             sub t
    )
in

let main =
    let bind = bind MonadIO in
    let return = return MonadIO in

    let readString =
        rec readString = \u -> bind readChar \c -> case c of {
            Nothing -> return Nil;
            Just c-> bind (readString u) \s ->
                        return (Cons c s)
        }
        in
        readString Unit
    in
    rec writeString = \s -> case s of {
        Cons h t -> bind (writeChar h) \u ->
                         writeString t;
        Nil -> return Unit
    }
    in

    bind readString \s ->
         let tokens = case runParser lex s of {
            Left e -> case e of {
                ParsingError e -> Left e;
                GenericParsingError e -> Left e
            };
            Right r -> case r of { Pair r tokens -> Right tokens }
         }
         in
         let expr = case tokens of {
            Left e -> Left e;
            Right tokens -> case runParser parse tokens of {
                Left e -> case e of {
                    ParsingError e -> Left e;
                    GenericParsingError e -> Left e
                };
                Right r -> case r of {
                    Pair t expr -> Right expr
                }
            }
         }
         in
         let output = case expr of {
            Left e -> e;
            Right expr -> case typeInfer expr of {
                Left e -> e;
                Right t -> listJoin (Cons (exprToString expr)
                                    (Cons (toString ffi ` " : " `)
                                    (Cons (monoToString t) Nil)))
            }
         }
         in
    bind (writeString output) \u ->
    bind (writeString (toString ffi ` "\ninput:\n" `)) \u ->
    bind (writeString s) \u ->
         return u
in
runIO main
